CREATE TABLE [ops].[DatabaseSizeHistory]
(
    [DatabaseSizeHistoryId]  BIGINT IDENTITY(1,1) NOT NULL,
    [InstanceId]             INT NOT NULL,
    [DatabaseAssetId]        INT NOT NULL,
    [DataSizeMb]             DECIMAL(19,4) NOT NULL,
    [LogSizeMb]              DECIMAL(19,4) NOT NULL,
    [TotalSizeMb]            DECIMAL(19,4) NOT NULL,
    [DataUsedMb]             DECIMAL(19,4) NULL,
    [LogUsedMb]              DECIMAL(19,4) NULL,
    [CapturedUtc]            DATETIME2(0) NOT NULL,
    [CreatedUtc]             DATETIME2(0) NOT NULL CONSTRAINT [DF_ops_DatabaseSizeHistory_CreatedUtc] DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT [PK_ops_DatabaseSizeHistory] PRIMARY KEY CLUSTERED ([DatabaseSizeHistoryId]),
    CONSTRAINT [FK_ops_DatabaseSizeHistory_cfg_Instance_InstanceId]
        FOREIGN KEY ([InstanceId]) REFERENCES [cfg].[Instance]([InstanceId]),
    CONSTRAINT [FK_ops_DatabaseSizeHistory_cfg_DatabaseAsset_DatabaseAssetId]
        FOREIGN KEY ([DatabaseAssetId]) REFERENCES [cfg].[DatabaseAsset]([DatabaseAssetId])
);
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Stores historical database size measurements for monitored databases. This table supports storage trend analysis, growth forecasting, capacity planning, anomaly detection, and AI-assisted prediction of storage-related risk.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'DatabaseSizeHistory';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Surrogate primary key for the database size history record.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'DatabaseSizeHistory',
    @level2type = N'COLUMN', @level2name = N'DatabaseSizeHistoryId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Foreign key to cfg.Instance identifying the monitored instance where the database size measurement was collected.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'DatabaseSizeHistory',
    @level2type = N'COLUMN', @level2name = N'InstanceId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Foreign key to cfg.DatabaseAsset identifying the monitored database for which the size history was captured.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'DatabaseSizeHistory',
    @level2type = N'COLUMN', @level2name = N'DatabaseAssetId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Total allocated data file size in megabytes for the database at the time of capture.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'DatabaseSizeHistory',
    @level2type = N'COLUMN', @level2name = N'DataSizeMb';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Total allocated log file size in megabytes for the database at the time of capture.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'DatabaseSizeHistory',
    @level2type = N'COLUMN', @level2name = N'LogSizeMb';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Total allocated database size in megabytes, typically equal to data size plus log size.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'DatabaseSizeHistory',
    @level2type = N'COLUMN', @level2name = N'TotalSizeMb';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Amount of used space in megabytes within data files when available from the collector.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'DatabaseSizeHistory',
    @level2type = N'COLUMN', @level2name = N'DataUsedMb';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Amount of used space in megabytes within log files when available from the collector.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'DatabaseSizeHistory',
    @level2type = N'COLUMN', @level2name = N'LogUsedMb';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'UTC timestamp when the database size measurement was observed or captured from the monitored environment.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'DatabaseSizeHistory',
    @level2type = N'COLUMN', @level2name = N'CapturedUtc';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'UTC timestamp when the database size history record was inserted into the central intelligence repository.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'DatabaseSizeHistory',
    @level2type = N'COLUMN', @level2name = N'CreatedUtc';
GO