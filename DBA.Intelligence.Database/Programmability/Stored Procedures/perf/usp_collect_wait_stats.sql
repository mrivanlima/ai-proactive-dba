CREATE PROCEDURE perf.usp_collect_wait_stats
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @CollectorName      NVARCHAR(256) = N'perf.usp_collect_wait_stats';
    DECLARE @CollectorType      NVARCHAR(100) = N'WaitStats';
    DECLARE @TargetScope        NVARCHAR(100) = N'Instance';
    DECLARE @CollectionMethod   NVARCHAR(100) = N'sys.dm_os_wait_stats snapshot';
    DECLARE @ExecutionStartUtc  DATETIME2(0)  = SYSUTCDATETIME();
    DECLARE @ExecutionEndUtc    DATETIME2(0);
    DECLARE @ExecutionStatus    NVARCHAR(60)  = N'STARTED';
    DECLARE @RowsCaptured       INT = 0;
    DECLARE @RowsInserted       INT = 0;
    DECLARE @ErrorNumber        INT = NULL;
    DECLARE @ErrorMessage NVARCHAR(4000) = NULL;
    DECLARE @ExecutionContext   NVARCHAR(2000);
    DECLARE @InstanceId         INT;

    SELECT
        @InstanceId = i.InstanceId
    FROM cfg.Instance AS i
    WHERE i.InstanceName = @@SERVERNAME
      AND i.IsActive = 1;

    IF @InstanceId IS NULL
    BEGIN
        SELECT TOP (1)
            @InstanceId = i.InstanceId
        FROM cfg.Instance AS i
        WHERE i.HostName = CAST(SERVERPROPERTY('MachineName') AS NVARCHAR(128))
          AND i.IsActive = 1
        ORDER BY i.InstanceId;
    END;

    IF @InstanceId IS NULL
    BEGIN
        RAISERROR('No active cfg.Instance row matched this SQL Server instance. Seed cfg.Instance first.', 16, 1);
        RETURN;
    END;

    SET @ExecutionContext =
        CONCAT(
            N'InstanceId=', @InstanceId,
            N'; ServerName=', CAST(@@SERVERNAME AS NVARCHAR(256)),
            N'; MachineName=', CAST(SERVERPROPERTY('MachineName') AS NVARCHAR(256)),
            N'; CollectionMethod=', @CollectionMethod
        );

    BEGIN TRY
        IF OBJECT_ID('tempdb..#WaitStatsStage') IS NOT NULL
            DROP TABLE #WaitStatsStage;

        CREATE TABLE #WaitStatsStage
        (
            WaitType            NVARCHAR(120) NOT NULL,
            WaitTimeMs          BIGINT        NOT NULL,
            SignalWaitTimeMs    BIGINT        NOT NULL,
            WaitingTasksCount   BIGINT        NOT NULL
        );

        INSERT INTO #WaitStatsStage
        (
            WaitType,
            WaitTimeMs,
            SignalWaitTimeMs,
            WaitingTasksCount
        )
        SELECT
            ws.wait_type,
            ws.wait_time_ms,
            ws.signal_wait_time_ms,
            ws.waiting_tasks_count
        FROM sys.dm_os_wait_stats AS ws
        WHERE ws.waiting_tasks_count > 0
          AND ws.wait_type NOT IN
          (
              N'BROKER_EVENTHANDLER',
              N'BROKER_RECEIVE_WAITFOR',
              N'BROKER_TASK_STOP',
              N'BROKER_TO_FLUSH',
              N'BROKER_TRANSMITTER',
              N'CHECKPOINT_QUEUE',
              N'CHKPT',
              N'CLR_AUTO_EVENT',
              N'CLR_MANUAL_EVENT',
              N'CLR_SEMAPHORE',
              N'DBMIRROR_DBM_EVENT',
              N'DBMIRROR_EVENTS_QUEUE',
              N'DBMIRROR_WORKER_QUEUE',
              N'DBMIRRORING_CMD',
              N'DIRTY_PAGE_POLL',
              N'DISPATCHER_QUEUE_SEMAPHORE',
              N'EXECSYNC',
              N'FSAGENT',
              N'FT_IFTS_SCHEDULER_IDLE_WAIT',
              N'FT_IFTSHC_MUTEX',
              N'HADR_CLUSAPI_CALL',
              N'HADR_FILESTREAM_IOMGR_IOCOMPLETION',
              N'HADR_LOGCAPTURE_WAIT',
              N'HADR_NOTIFICATION_DEQUEUE',
              N'HADR_TIMER_TASK',
              N'HADR_WORK_QUEUE',
              N'KSOURCE_WAKEUP',
              N'LAZYWRITER_SLEEP',
              N'LOGMGR_QUEUE',
              N'MEMORY_ALLOCATION_EXT',
              N'ONDEMAND_TASK_QUEUE',
              N'PARALLEL_REDO_DRAIN_WORKER',
              N'PARALLEL_REDO_LOG_CACHE',
              N'PARALLEL_REDO_TRAN_LIST',
              N'PARALLEL_REDO_WORKER_SYNC',
              N'PARALLEL_REDO_WORKER_WAIT_WORK',
              N'PREEMPTIVE_XE_GETTARGETSTATE',
              N'PWAIT_ALL_COMPONENTS_INITIALIZED',
              N'PWAIT_DIRECTLOGCONSUMER_GETNEXT',
              N'QDS_PERSIST_TASK_MAIN_LOOP_SLEEP',
              N'QDS_ASYNC_QUEUE',
              N'QDS_CLEANUP_STALE_QUERIES_TASK_MAIN_LOOP_SLEEP',
              N'QDS_SHUTDOWN_QUEUE',
              N'REDO_THREAD_PENDING_WORK',
              N'REQUEST_FOR_DEADLOCK_SEARCH',
              N'RESOURCE_QUEUE',
              N'SERVER_IDLE_CHECK',
              N'SLEEP_BPOOL_FLUSH',
              N'SLEEP_DBSTARTUP',
              N'SLEEP_DCOMSTARTUP',
              N'SLEEP_MASTERDBREADY',
              N'SLEEP_MASTERMDREADY',
              N'SLEEP_MASTERUPGRADED',
              N'SLEEP_MSDBSTARTUP',
              N'SLEEP_SYSTEMTASK',
              N'SLEEP_TASK',
              N'SLEEP_TEMPDBSTARTUP',
              N'SNI_HTTP_ACCEPT',
              N'SP_SERVER_DIAGNOSTICS_SLEEP',
              N'SQLTRACE_BUFFER_FLUSH',
              N'SQLTRACE_INCREMENTAL_FLUSH_SLEEP',
              N'SQLTRACE_WAIT_ENTRIES',
              N'UCS_SESSION_REGISTRATION',
              N'VDI_CLIENT_OTHER',
              N'WAIT_FOR_RESULTS',
              N'WAITFOR',
              N'WAITFOR_TASKSHUTDOWN',
              N'WAIT_XTP_RECOVERY',
              N'WAIT_XTP_HOST_WAIT',
              N'WAIT_XTP_OFFLINE_CKPT_NEW_LOG',
              N'WAIT_XTP_CKPT_CLOSE',
              N'XE_DISPATCHER_JOIN',
              N'XE_DISPATCHER_WAIT',
              N'XE_TIMER_EVENT'
          );

        SELECT
            @RowsCaptured = COUNT(*)
        FROM #WaitStatsStage;

        INSERT INTO perf.WaitStatsSnapshot
        (
            InstanceId,
            WaitType,
            WaitTimeMs,
            SignalWaitTimeMs,
            WaitingTasksCount,
            SampleWindowStartUtc,
            SampleWindowEndUtc,
            CollectionMethod,
            CreatedUtc
        )
        SELECT
            @InstanceId,
            s.WaitType,
            s.WaitTimeMs,
            s.SignalWaitTimeMs,
            s.WaitingTasksCount,
            NULL,
            @ExecutionStartUtc,
            @CollectionMethod,
            @ExecutionStartUtc
        FROM #WaitStatsStage AS s;

        SET @RowsInserted = @@ROWCOUNT;
        SET @ExecutionStatus = N'SUCCEEDED';
        SET @ExecutionEndUtc = SYSUTCDATETIME();

        INSERT INTO audit.CollectorExecution
        (
            CollectorName,
            CollectorType,
            TargetScope,
            InstanceId,
            DatabaseAssetId,
            ExecutionStartUtc,
            ExecutionEndUtc,
            ExecutionStatus,
            RowsCaptured,
            RowsInserted,
            ErrorNumber,
            ErrorMessage,
            ExecutionContext,
            CreatedUtc
        )
        VALUES
        (
            @CollectorName,
            @CollectorType,
            @TargetScope,
            @InstanceId,
            NULL,
            @ExecutionStartUtc,
            @ExecutionEndUtc,
            @ExecutionStatus,
            @RowsCaptured,
            @RowsInserted,
            NULL,
            NULL,
            @ExecutionContext,
            SYSUTCDATETIME()
        );
    END TRY
    BEGIN CATCH
        SET @ExecutionStatus = N'FAILED';
        SET @ExecutionEndUtc = SYSUTCDATETIME();
        SET @ErrorNumber = ERROR_NUMBER();
        SET @ErrorMessage = LEFT(ERROR_MESSAGE(), 4000);

        INSERT INTO audit.CollectorExecution
        (
            CollectorName,
            CollectorType,
            TargetScope,
            InstanceId,
            DatabaseAssetId,
            ExecutionStartUtc,
            ExecutionEndUtc,
            ExecutionStatus,
            RowsCaptured,
            RowsInserted,
            ErrorNumber,
            ErrorMessage,
            ExecutionContext,
            CreatedUtc
        )
        VALUES
        (
            @CollectorName,
            @CollectorType,
            @TargetScope,
            @InstanceId,
            NULL,
            @ExecutionStartUtc,
            @ExecutionEndUtc,
            @ExecutionStatus,
            @RowsCaptured,
            @RowsInserted,
            @ErrorNumber,
            @ErrorMessage,
            @ExecutionContext,
            SYSUTCDATETIME()
        );

        RAISERROR(@ErrorMessage, 16, 1);
        RETURN;
    END CATCH;
END;
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Collects instance-level wait statistics from sys.dm_os_wait_stats into perf.WaitStatsSnapshot and logs collector execution to audit.CollectorExecution.',
    @level0type = N'SCHEMA', @level0name = N'perf',
    @level1type = N'PROCEDURE', @level1name = N'usp_collect_wait_stats';
GO