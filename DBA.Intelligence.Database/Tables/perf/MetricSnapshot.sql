CREATE TABLE [perf].[MetricSnapshot]
(
    [MetricSnapshotId]       BIGINT IDENTITY(1,1) NOT NULL,
    [InstanceId]             INT NOT NULL,
    [DatabaseAssetId]        INT NULL,
    [MetricName]             NVARCHAR(128) NOT NULL,
    [MetricCategory]         NVARCHAR(50) NOT NULL,
    [MetricValue]            DECIMAL(19,4) NOT NULL,
    [MetricUnit]             NVARCHAR(30) NULL,
    [CollectionMethod]       NVARCHAR(50) NULL,
    [CapturedUtc]            DATETIME2(0) NOT NULL,
    [CreatedUtc]             DATETIME2(0) NOT NULL CONSTRAINT [DF_perf_MetricSnapshot_CreatedUtc] DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT [PK_perf_MetricSnapshot] PRIMARY KEY CLUSTERED ([MetricSnapshotId]),
    CONSTRAINT [FK_perf_MetricSnapshot_cfg_Instance_InstanceId]
        FOREIGN KEY ([InstanceId]) REFERENCES [cfg].[Instance]([InstanceId]),
    CONSTRAINT [FK_perf_MetricSnapshot_cfg_DatabaseAsset_DatabaseAssetId]
        FOREIGN KEY ([DatabaseAssetId]) REFERENCES [cfg].[DatabaseAsset]([DatabaseAssetId])
);
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Stores normalized time-series performance metrics collected from monitored SQL platforms. This table supports historical trending, baselining, anomaly detection, dashboard visualization, and AI-assisted operational analysis across instance-level and database-level signals.',
    @level0type = N'SCHEMA', @level0name = N'perf',
    @level1type = N'TABLE',  @level1name = N'MetricSnapshot';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Surrogate primary key for the metric snapshot record.',
    @level0type = N'SCHEMA', @level0name = N'perf',
    @level1type = N'TABLE',  @level1name = N'MetricSnapshot',
    @level2type = N'COLUMN', @level2name = N'MetricSnapshotId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Foreign key to cfg.Instance identifying the monitored instance from which the metric was collected.',
    @level0type = N'SCHEMA', @level0name = N'perf',
    @level1type = N'TABLE',  @level1name = N'MetricSnapshot',
    @level2type = N'COLUMN', @level2name = N'InstanceId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Optional foreign key to cfg.DatabaseAsset when the metric applies to a specific monitored database rather than only to the instance.',
    @level0type = N'SCHEMA', @level0name = N'perf',
    @level1type = N'TABLE',  @level1name = N'MetricSnapshot',
    @level2type = N'COLUMN', @level2name = N'DatabaseAssetId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Canonical metric name used by the platform, such as CPUUtilizationPct, ConnectionCount, TempDbUsedMB, or LogUsedPct.',
    @level0type = N'SCHEMA', @level0name = N'perf',
    @level1type = N'TABLE',  @level1name = N'MetricSnapshot',
    @level2type = N'COLUMN', @level2name = N'MetricName';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'High-level metric grouping used for organization and AI reasoning, such as CPU, Memory, IO, Connections, TempDB, Storage, or Workload.',
    @level0type = N'SCHEMA', @level0name = N'perf',
    @level1type = N'TABLE',  @level1name = N'MetricSnapshot',
    @level2type = N'COLUMN', @level2name = N'MetricCategory';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Numeric metric value captured at the recorded time, stored in a normalized decimal format for flexible analytics.',
    @level0type = N'SCHEMA', @level0name = N'perf',
    @level1type = N'TABLE',  @level1name = N'MetricSnapshot',
    @level2type = N'COLUMN', @level2name = N'MetricValue';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Unit of measure for the metric value, such as Percent, Milliseconds, MB, GB, Count, or Seconds.',
    @level0type = N'SCHEMA', @level0name = N'perf',
    @level1type = N'TABLE',  @level1name = N'MetricSnapshot',
    @level2type = N'COLUMN', @level2name = N'MetricUnit';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Collection source or technique used to obtain the metric, such as DMV, QueryStore, ExtendedEvents, AzureMonitor, or LogAnalytics.',
    @level0type = N'SCHEMA', @level0name = N'perf',
    @level1type = N'TABLE',  @level1name = N'MetricSnapshot',
    @level2type = N'COLUMN', @level2name = N'CollectionMethod';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'UTC timestamp representing when the metric value was observed on the monitored platform.',
    @level0type = N'SCHEMA', @level0name = N'perf',
    @level1type = N'TABLE',  @level1name = N'MetricSnapshot',
    @level2type = N'COLUMN', @level2name = N'CapturedUtc';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'UTC timestamp when the metric snapshot record was inserted into the central intelligence repository.',
    @level0type = N'SCHEMA', @level0name = N'perf',
    @level1type = N'TABLE',  @level1name = N'MetricSnapshot',
    @level2type = N'COLUMN', @level2name = N'CreatedUtc';
GO