CREATE TABLE [ops].[FileGrowthEvent]
(
    [FileGrowthEventId]      BIGINT IDENTITY(1,1) NOT NULL,
    [InstanceId]             INT NOT NULL,
    [DatabaseAssetId]        INT NULL,
    [DatabaseName]           NVARCHAR(128) NOT NULL,
    [LogicalFileName]        NVARCHAR(128) NOT NULL,
    [FileTypeDesc]           NVARCHAR(20) NOT NULL,
    [FilePath]               NVARCHAR(260) NULL,
    [GrowthMb]               DECIMAL(19,4) NOT NULL,
    [SizeBeforeMb]           DECIMAL(19,4) NULL,
    [SizeAfterMb]            DECIMAL(19,4) NULL,
    [DurationMs]             BIGINT NULL,
    [IsAutoGrowth]           BIT NOT NULL CONSTRAINT [DF_ops_FileGrowthEvent_IsAutoGrowth] DEFAULT ((1)),
    [CapturedUtc]            DATETIME2(0) NOT NULL,
    [CreatedUtc]             DATETIME2(0) NOT NULL CONSTRAINT [DF_ops_FileGrowthEvent_CreatedUtc] DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT [PK_ops_FileGrowthEvent] PRIMARY KEY CLUSTERED ([FileGrowthEventId]),
    CONSTRAINT [FK_ops_FileGrowthEvent_cfg_Instance_InstanceId]
        FOREIGN KEY ([InstanceId]) REFERENCES [cfg].[Instance]([InstanceId]),
    CONSTRAINT [FK_ops_FileGrowthEvent_cfg_DatabaseAsset_DatabaseAssetId]
        FOREIGN KEY ([DatabaseAssetId]) REFERENCES [cfg].[DatabaseAsset]([DatabaseAssetId])
);
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Stores database file growth events captured from monitored SQL Server environments. This table supports storage trend analysis, autogrowth investigation, capacity planning, and AI-assisted diagnosis of file growth pressure and storage-related incidents.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'FileGrowthEvent';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Surrogate primary key for the file growth event record.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'FileGrowthEvent',
    @level2type = N'COLUMN', @level2name = N'FileGrowthEventId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Foreign key to cfg.Instance identifying the monitored instance where the file growth event occurred.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'FileGrowthEvent',
    @level2type = N'COLUMN', @level2name = N'InstanceId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Optional foreign key to cfg.DatabaseAsset when the file growth event is associated with a specific monitored database.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'FileGrowthEvent',
    @level2type = N'COLUMN', @level2name = N'DatabaseAssetId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Name of the database associated with the file growth event, captured for direct diagnostic readability.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'FileGrowthEvent',
    @level2type = N'COLUMN', @level2name = N'DatabaseName';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Logical file name of the data or log file that grew.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'FileGrowthEvent',
    @level2type = N'COLUMN', @level2name = N'LogicalFileName';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'File type classification such as ROWS or LOG for the file that grew.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'FileGrowthEvent',
    @level2type = N'COLUMN', @level2name = N'FileTypeDesc';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Physical file path of the file that grew when captured by the collector.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'FileGrowthEvent',
    @level2type = N'COLUMN', @level2name = N'FilePath';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Amount of file growth in megabytes associated with the event.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'FileGrowthEvent',
    @level2type = N'COLUMN', @level2name = N'GrowthMb';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'File size in megabytes immediately before the growth event when available.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'FileGrowthEvent',
    @level2type = N'COLUMN', @level2name = N'SizeBeforeMb';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'File size in megabytes immediately after the growth event when available.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'FileGrowthEvent',
    @level2type = N'COLUMN', @level2name = N'SizeAfterMb';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Duration in milliseconds for the growth event when the source collector can determine it.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'FileGrowthEvent',
    @level2type = N'COLUMN', @level2name = N'DurationMs';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indicates whether the event was triggered by automatic file growth rather than a manual growth action.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'FileGrowthEvent',
    @level2type = N'COLUMN', @level2name = N'IsAutoGrowth';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'UTC timestamp when the file growth event was observed or captured from the monitored environment.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'FileGrowthEvent',
    @level2type = N'COLUMN', @level2name = N'CapturedUtc';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'UTC timestamp when the file growth event record was inserted into the central intelligence repository.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'FileGrowthEvent',
    @level2type = N'COLUMN', @level2name = N'CreatedUtc';
GO