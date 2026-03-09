CREATE TABLE [perf].[QueryRuntimeSnapshot]
(
    [QueryRuntimeSnapshotId] BIGINT IDENTITY(1,1) NOT NULL,
    [InstanceId]             INT NOT NULL,
    [DatabaseAssetId]        INT NOT NULL,
    [QueryHash]              BINARY(8) NULL,
    [PlanHash]               BINARY(8) NULL,
    [QueryTextHash]          VARBINARY(32) NULL,
    [QueryTextShort]         NVARCHAR(1000) NULL,
    [ExecutionCount]         BIGINT NOT NULL,
    [AvgDurationMs]          DECIMAL(19,4) NOT NULL,
    [AvgCpuMs]               DECIMAL(19,4) NULL,
    [AvgLogicalReads]        DECIMAL(19,4) NULL,
    [AvgPhysicalReads]       DECIMAL(19,4) NULL,
    [AvgWrites]              DECIMAL(19,4) NULL,
    [TotalDurationMs]        DECIMAL(19,4) NULL,
    [TotalCpuMs]             DECIMAL(19,4) NULL,
    [SampleWindowStartUtc]   DATETIME2(0) NULL,
    [SampleWindowEndUtc]     DATETIME2(0) NOT NULL,
    [CollectionMethod]       NVARCHAR(50) NULL,
    [CreatedUtc]             DATETIME2(0) NOT NULL CONSTRAINT [DF_perf_QueryRuntimeSnapshot_CreatedUtc] DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT [PK_perf_QueryRuntimeSnapshot] PRIMARY KEY CLUSTERED ([QueryRuntimeSnapshotId]),
    CONSTRAINT [FK_perf_QueryRuntimeSnapshot_cfg_Instance_InstanceId]
        FOREIGN KEY ([InstanceId]) REFERENCES [cfg].[Instance]([InstanceId]),
    CONSTRAINT [FK_perf_QueryRuntimeSnapshot_cfg_DatabaseAsset_DatabaseAssetId]
        FOREIGN KEY ([DatabaseAssetId]) REFERENCES [cfg].[DatabaseAsset]([DatabaseAssetId])
);
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Stores summarized query performance snapshots collected from monitored databases. This table supports query regression detection, workload analysis, baselining, performance trending, and AI-assisted investigation of runtime behavior across the platform.',
    @level0type = N'SCHEMA', @level0name = N'perf',
    @level1type = N'TABLE',  @level1name = N'QueryRuntimeSnapshot';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Surrogate primary key for the query runtime snapshot record.',
    @level0type = N'SCHEMA', @level0name = N'perf',
    @level1type = N'TABLE',  @level1name = N'QueryRuntimeSnapshot',
    @level2type = N'COLUMN', @level2name = N'QueryRuntimeSnapshotId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Foreign key to cfg.Instance identifying the monitored instance from which the query performance data was collected.',
    @level0type = N'SCHEMA', @level0name = N'perf',
    @level1type = N'TABLE',  @level1name = N'QueryRuntimeSnapshot',
    @level2type = N'COLUMN', @level2name = N'InstanceId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Foreign key to cfg.DatabaseAsset identifying the monitored database to which the query performance record belongs.',
    @level0type = N'SCHEMA', @level0name = N'perf',
    @level1type = N'TABLE',  @level1name = N'QueryRuntimeSnapshot',
    @level2type = N'COLUMN', @level2name = N'DatabaseAssetId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Binary query hash used to group semantically equivalent query shapes across executions.',
    @level0type = N'SCHEMA', @level0name = N'perf',
    @level1type = N'TABLE',  @level1name = N'QueryRuntimeSnapshot',
    @level2type = N'COLUMN', @level2name = N'QueryHash';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Binary plan hash used to identify the execution plan shape associated with the query snapshot.',
    @level0type = N'SCHEMA', @level0name = N'perf',
    @level1type = N'TABLE',  @level1name = N'QueryRuntimeSnapshot',
    @level2type = N'COLUMN', @level2name = N'PlanHash';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Optional SHA-256 style hash or equivalent normalized hash of the query text used for stronger correlation and deduplication.',
    @level0type = N'SCHEMA', @level0name = N'perf',
    @level1type = N'TABLE',  @level1name = N'QueryRuntimeSnapshot',
    @level2type = N'COLUMN', @level2name = N'QueryTextHash';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Short normalized or truncated representation of the query text used for diagnostics, reporting, and AI grounding without storing excessively large statements.',
    @level0type = N'SCHEMA', @level0name = N'perf',
    @level1type = N'TABLE',  @level1name = N'QueryRuntimeSnapshot',
    @level2type = N'COLUMN', @level2name = N'QueryTextShort';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Number of executions represented by the summarized query performance record within the sample window.',
    @level0type = N'SCHEMA', @level0name = N'perf',
    @level1type = N'TABLE',  @level1name = N'QueryRuntimeSnapshot',
    @level2type = N'COLUMN', @level2name = N'ExecutionCount';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Average duration in milliseconds for the query during the measured sample window.',
    @level0type = N'SCHEMA', @level0name = N'perf',
    @level1type = N'TABLE',  @level1name = N'QueryRuntimeSnapshot',
    @level2type = N'COLUMN', @level2name = N'AvgDurationMs';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Average CPU time in milliseconds consumed by the query during the measured sample window.',
    @level0type = N'SCHEMA', @level0name = N'perf',
    @level1type = N'TABLE',  @level1name = N'QueryRuntimeSnapshot',
    @level2type = N'COLUMN', @level2name = N'AvgCpuMs';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Average logical reads generated by the query during the measured sample window.',
    @level0type = N'SCHEMA', @level0name = N'perf',
    @level1type = N'TABLE',  @level1name = N'QueryRuntimeSnapshot',
    @level2type = N'COLUMN', @level2name = N'AvgLogicalReads';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Average physical reads generated by the query during the measured sample window.',
    @level0type = N'SCHEMA', @level0name = N'perf',
    @level1type = N'TABLE',  @level1name = N'QueryRuntimeSnapshot',
    @level2type = N'COLUMN', @level2name = N'AvgPhysicalReads';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Average write operations generated by the query during the measured sample window.',
    @level0type = N'SCHEMA', @level0name = N'perf',
    @level1type = N'TABLE',  @level1name = N'QueryRuntimeSnapshot',
    @level2type = N'COLUMN', @level2name = N'AvgWrites';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Total duration in milliseconds accumulated by all executions represented in the snapshot.',
    @level0type = N'SCHEMA', @level0name = N'perf',
    @level1type = N'TABLE',  @level1name = N'QueryRuntimeSnapshot',
    @level2type = N'COLUMN', @level2name = N'TotalDurationMs';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Total CPU time in milliseconds accumulated by all executions represented in the snapshot.',
    @level0type = N'SCHEMA', @level0name = N'perf',
    @level1type = N'TABLE',  @level1name = N'QueryRuntimeSnapshot',
    @level2type = N'COLUMN', @level2name = N'TotalCpuMs';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Optional UTC timestamp representing the beginning of the sample window used for the summarized query performance metrics.',
    @level0type = N'SCHEMA', @level0name = N'perf',
    @level1type = N'TABLE',  @level1name = N'QueryRuntimeSnapshot',
    @level2type = N'COLUMN', @level2name = N'SampleWindowStartUtc';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'UTC timestamp representing the end of the sample window or the exact capture time of the summarized query performance record.',
    @level0type = N'SCHEMA', @level0name = N'perf',
    @level1type = N'TABLE',  @level1name = N'QueryRuntimeSnapshot',
    @level2type = N'COLUMN', @level2name = N'SampleWindowEndUtc';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Collection source or method used to obtain the query performance data, such as QueryStore, DMVs, or another standardized collector process.',
    @level0type = N'SCHEMA', @level0name = N'perf',
    @level1type = N'TABLE',  @level1name = N'QueryRuntimeSnapshot',
    @level2type = N'COLUMN', @level2name = N'CollectionMethod';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'UTC timestamp when the query runtime snapshot record was inserted into the central intelligence repository.',
    @level0type = N'SCHEMA', @level0name = N'perf',
    @level1type = N'TABLE',  @level1name = N'QueryRuntimeSnapshot',
    @level2type = N'COLUMN', @level2name = N'CreatedUtc';
GO