CREATE PROCEDURE ops.usp_collect_blocking
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @CollectorName      NVARCHAR(256) = N'ops.usp_collect_blocking';
    DECLARE @CollectorType      NVARCHAR(100) = N'Blocking';
    DECLARE @TargetScope        NVARCHAR(100) = N'Instance';
    DECLARE @ExecutionStartUtc  DATETIME2(0)  = SYSUTCDATETIME();
    DECLARE @ExecutionEndUtc    DATETIME2(0);
    DECLARE @ExecutionStatus    NVARCHAR(60)  = N'STARTED';
    DECLARE @RowsCaptured       INT = 0;
    DECLARE @RowsInserted       INT = 0;
    DECLARE @ErrorNumber        INT = NULL;
    DECLARE @ErrorMessage       NVARCHAR(4000) = NULL;
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
            N'; Source=sys.dm_exec_requests + sys.dm_exec_sessions'
        );

    BEGIN TRY
        IF OBJECT_ID('tempdb..#BlockingStage') IS NOT NULL
            DROP TABLE #BlockingStage;

        CREATE TABLE #BlockingStage
        (
            DatabaseAssetId           INT NULL,
            BlockedSessionId          INT NOT NULL,
            BlockingSessionId         INT NULL,
            WaitType                  NVARCHAR(120) NULL,
            WaitDurationMs            BIGINT NULL,
            ResourceDescription       NVARCHAR(512) NULL,
            BlockedCommand            NVARCHAR(64) NULL,
            BlockingCommand           NVARCHAR(64) NULL,
            BlockedLoginName          NVARCHAR(128) NULL,
            BlockingLoginName         NVARCHAR(128) NULL,
            BlockedHostName           NVARCHAR(128) NULL,
            BlockingHostName          NVARCHAR(128) NULL,
            BlockedProgramName        NVARCHAR(256) NULL,
            BlockingProgramName       NVARCHAR(256) NULL,
            BlockedQueryTextShort     NVARCHAR(1000) NULL,
            BlockingQueryTextShort    NVARCHAR(1000) NULL,
            CapturedUtc               DATETIME2(0) NOT NULL
        );

        INSERT INTO #BlockingStage
        (
            DatabaseAssetId,
            BlockedSessionId,
            BlockingSessionId,
            WaitType,
            WaitDurationMs,
            ResourceDescription,
            BlockedCommand,
            BlockingCommand,
            BlockedLoginName,
            BlockingLoginName,
            BlockedHostName,
            BlockingHostName,
            BlockedProgramName,
            BlockingProgramName,
            BlockedQueryTextShort,
            BlockingQueryTextShort,
            CapturedUtc
        )
        SELECT
            da.DatabaseAssetId,
            r.session_id AS BlockedSessionId,
            NULLIF(r.blocking_session_id, 0) AS BlockingSessionId,
            r.wait_type,
            CAST(r.wait_time AS BIGINT) AS WaitDurationMs,
            LEFT(r.wait_resource, 512) AS ResourceDescription,
            LEFT(r.command, 64) AS BlockedCommand,
            LEFT(br.command, 64) AS BlockingCommand,
            LEFT(bs.login_name, 128) AS BlockedLoginName,
            LEFT(bls.login_name, 128) AS BlockingLoginName,
            LEFT(bs.host_name, 128) AS BlockedHostName,
            LEFT(bls.host_name, 128) AS BlockingHostName,
            LEFT(bs.program_name, 256) AS BlockedProgramName,
            LEFT(bls.program_name, 256) AS BlockingProgramName,
            LEFT(
                REPLACE(REPLACE(REPLACE(bt.text, CHAR(13), N' '), CHAR(10), N' '), CHAR(9), N' '),
                1000
            ) AS BlockedQueryTextShort,
            LEFT(
                REPLACE(REPLACE(REPLACE(blt.text, CHAR(13), N' '), CHAR(10), N' '), CHAR(9), N' '),
                1000
            ) AS BlockingQueryTextShort,
            @ExecutionStartUtc AS CapturedUtc
        FROM sys.dm_exec_requests AS r
        INNER JOIN sys.dm_exec_sessions AS bs
            ON r.session_id = bs.session_id
        LEFT JOIN sys.dm_exec_requests AS br
            ON r.blocking_session_id = br.session_id
        LEFT JOIN sys.dm_exec_sessions AS bls
            ON r.blocking_session_id = bls.session_id
        OUTER APPLY sys.dm_exec_sql_text(r.sql_handle) AS bt
        OUTER APPLY sys.dm_exec_sql_text(br.sql_handle) AS blt
        LEFT JOIN cfg.DatabaseAsset AS da
            ON da.InstanceId = @InstanceId
           AND da.DatabaseName = DB_NAME(r.database_id)
           AND da.IsActive = 1
        WHERE r.blocking_session_id > 0
          AND r.session_id <> @@SPID;

        SELECT
            @RowsCaptured = COUNT(*)
        FROM #BlockingStage;

        INSERT INTO ops.BlockingEvent
        (
            InstanceId,
            DatabaseAssetId,
            BlockedSessionId,
            BlockingSessionId,
            WaitType,
            WaitDurationMs,
            ResourceDescription,
            BlockedCommand,
            BlockingCommand,
            BlockedLoginName,
            BlockingLoginName,
            BlockedHostName,
            BlockingHostName,
            BlockedProgramName,
            BlockingProgramName,
            BlockedQueryTextShort,
            BlockingQueryTextShort,
            CapturedUtc,
            CreatedUtc
        )
        SELECT
            @InstanceId,
            s.DatabaseAssetId,
            s.BlockedSessionId,
            s.BlockingSessionId,
            s.WaitType,
            s.WaitDurationMs,
            s.ResourceDescription,
            s.BlockedCommand,
            s.BlockingCommand,
            s.BlockedLoginName,
            s.BlockingLoginName,
            s.BlockedHostName,
            s.BlockingHostName,
            s.BlockedProgramName,
            s.BlockingProgramName,
            s.BlockedQueryTextShort,
            s.BlockingQueryTextShort,
            s.CapturedUtc,
            @ExecutionStartUtc
        FROM #BlockingStage AS s;

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
    @value = N'Collects current blocking chains from dynamic management views and stores them in ops.BlockingEvent while logging execution metadata to audit.CollectorExecution.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'PROCEDURE', @level1name = N'usp_collect_blocking';
GO