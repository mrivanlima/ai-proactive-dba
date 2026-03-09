CREATE TABLE [perf].[WaitStatsSnapshot]
(
    [WaitStatsSnapshotId]    BIGINT IDENTITY(1,1) NOT NULL,
    [InstanceId]             INT NOT NULL,
    [WaitType]               NVARCHAR(120) NOT NULL,
    [WaitTimeMs]             BIGINT NOT NULL,
    [SignalWaitTimeMs]       BIGINT NOT NULL,
    [WaitingTasksCount]      BIGINT NOT NULL,
    [SampleWindowStartUtc]   DATETIME2(0) NULL,
    [SampleWindowEndUtc]     DATETIME2(0) NOT NULL,
    [CollectionMethod]       NVARCHAR(50) NULL,
    [CreatedUtc]             DATETIME2(0) NOT NULL CONSTRAINT [DF_perf_WaitStatsSnapshot_CreatedUtc] DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT [PK_perf_WaitStatsSnapshot] PRIMARY KEY CLUSTERED ([WaitStatsSnapshotId]),
    CONSTRAINT [FK_perf_WaitStatsSnapshot_cfg_Instance_InstanceId]
        FOREIGN KEY ([InstanceId]) REFERENCES [cfg].[Instance]([InstanceId])
);
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Stores wait statistics snapshots collected from monitored SQL Server instances. This table is used to analyze resource contention patterns, identify dominant wait classes, support baselining, detect anomalies, and provide evidence for AI-assisted root cause analysis.',
    @level0type = N'SCHEMA', @level0name = N'perf',
    @level1type = N'TABLE',  @level1name = N'WaitStatsSnapshot';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Surrogate primary key for the wait statistics snapshot record.',
    @level0type = N'SCHEMA', @level0name = N'perf',
    @level1type = N'TABLE',  @level1name = N'WaitStatsSnapshot',
    @level2type = N'COLUMN', @level2name = N'WaitStatsSnapshotId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Foreign key to cfg.Instance identifying the monitored instance from which the wait statistics were collected.',
    @level0type = N'SCHEMA', @level0name = N'perf',
    @level1type = N'TABLE',  @level1name = N'WaitStatsSnapshot',
    @level2type = N'COLUMN', @level2name = N'InstanceId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Name of the SQL Server wait type, such as PAGEIOLATCH_SH, CXPACKET, ASYNC_NETWORK_IO, or WRITELOG.',
    @level0type = N'SCHEMA', @level0name = N'perf',
    @level1type = N'TABLE',  @level1name = N'WaitStatsSnapshot',
    @level2type = N'COLUMN', @level2name = N'WaitType';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Total wait time in milliseconds attributed to the wait type for the measured sample window or captured snapshot context.',
    @level0type = N'SCHEMA', @level0name = N'perf',
    @level1type = N'TABLE',  @level1name = N'WaitStatsSnapshot',
    @level2type = N'COLUMN', @level2name = N'WaitTimeMs';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Portion of total wait time in milliseconds spent on signal waits, which helps distinguish scheduler pressure from resource waiting.',
    @level0type = N'SCHEMA', @level0name = N'perf',
    @level1type = N'TABLE',  @level1name = N'WaitStatsSnapshot',
    @level2type = N'COLUMN', @level2name = N'SignalWaitTimeMs';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Number of waiting tasks recorded for the wait type during the sample window or snapshot.',
    @level0type = N'SCHEMA', @level0name = N'perf',
    @level1type = N'TABLE',  @level1name = N'WaitStatsSnapshot',
    @level2type = N'COLUMN', @level2name = N'WaitingTasksCount';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Optional UTC timestamp representing the beginning of the sample window used to derive the wait statistics values.',
    @level0type = N'SCHEMA', @level0name = N'perf',
    @level1type = N'TABLE',  @level1name = N'WaitStatsSnapshot',
    @level2type = N'COLUMN', @level2name = N'SampleWindowStartUtc';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'UTC timestamp representing the end of the sample window or the exact capture time of the wait statistics snapshot.',
    @level0type = N'SCHEMA', @level0name = N'perf',
    @level1type = N'TABLE',  @level1name = N'WaitStatsSnapshot',
    @level2type = N'COLUMN', @level2name = N'SampleWindowEndUtc';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Collection source or method used to obtain the wait statistics, such as DMVDelta, DMVSnapshot, or another standardized collector technique.',
    @level0type = N'SCHEMA', @level0name = N'perf',
    @level1type = N'TABLE',  @level1name = N'WaitStatsSnapshot',
    @level2type = N'COLUMN', @level2name = N'CollectionMethod';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'UTC timestamp when the wait statistics snapshot record was inserted into the central intelligence repository.',
    @level0type = N'SCHEMA', @level0name = N'perf',
    @level1type = N'TABLE',  @level1name = N'WaitStatsSnapshot',
    @level2type = N'COLUMN', @level2name = N'CreatedUtc';
GO