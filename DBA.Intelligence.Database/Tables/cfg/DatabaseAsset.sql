CREATE TABLE [cfg].[DatabaseAsset]
(
    [DatabaseAssetId]        INT IDENTITY(1,1) NOT NULL,
    [InstanceId]             INT NOT NULL,
    [DatabaseName]           NVARCHAR(128) NOT NULL,
    [DatabaseGuid]           UNIQUEIDENTIFIER NULL,
    [CompatibilityLevel]     SMALLINT NULL,
    [RecoveryModel]          NVARCHAR(30) NULL,
    [ContainmentDesc]        NVARCHAR(60) NULL,
    [IsReadOnly]             BIT NOT NULL CONSTRAINT [DF_cfg_DatabaseAsset_IsReadOnly] DEFAULT ((0)),
    [IsAutoCloseOn]          BIT NOT NULL CONSTRAINT [DF_cfg_DatabaseAsset_IsAutoCloseOn] DEFAULT ((0)),
    [IsAutoShrinkOn]         BIT NOT NULL CONSTRAINT [DF_cfg_DatabaseAsset_IsAutoShrinkOn] DEFAULT ((0)),
    [IsActive]               BIT NOT NULL CONSTRAINT [DF_cfg_DatabaseAsset_IsActive] DEFAULT ((1)),
    [CreatedUtc]             DATETIME2(0) NOT NULL CONSTRAINT [DF_cfg_DatabaseAsset_CreatedUtc] DEFAULT (SYSUTCDATETIME()),
    [UpdatedUtc]             DATETIME2(0) NULL,
    CONSTRAINT [PK_cfg_DatabaseAsset] PRIMARY KEY CLUSTERED ([DatabaseAssetId]),
    CONSTRAINT [FK_cfg_DatabaseAsset_cfg_Instance_InstanceId]
        FOREIGN KEY ([InstanceId]) REFERENCES [cfg].[Instance]([InstanceId]),
    CONSTRAINT [UQ_cfg_DatabaseAsset_InstanceId_DatabaseName]
        UNIQUE ([InstanceId], [DatabaseName])
);
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Registers each database belonging to a monitored instance. This table provides the database-level configuration and identity context required for telemetry collection, workload analysis, baselining, anomaly detection, and AI-assisted operational reasoning.',
    @level0type = N'SCHEMA', @level0name = N'cfg',
    @level1type = N'TABLE',  @level1name = N'DatabaseAsset';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Surrogate primary key for the monitored database record.',
    @level0type = N'SCHEMA', @level0name = N'cfg',
    @level1type = N'TABLE',  @level1name = N'DatabaseAsset',
    @level2type = N'COLUMN', @level2name = N'DatabaseAssetId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Foreign key to cfg.Instance identifying the monitored instance that owns this database.',
    @level0type = N'SCHEMA', @level0name = N'cfg',
    @level1type = N'TABLE',  @level1name = N'DatabaseAsset',
    @level2type = N'COLUMN', @level2name = N'InstanceId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Name of the database as reported by the monitored SQL platform.',
    @level0type = N'SCHEMA', @level0name = N'cfg',
    @level1type = N'TABLE',  @level1name = N'DatabaseAsset',
    @level2type = N'COLUMN', @level2name = N'DatabaseName';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Optional database unique identifier used for stronger identity tracking across refreshes, restores, or migrations when available.',
    @level0type = N'SCHEMA', @level0name = N'cfg',
    @level1type = N'TABLE',  @level1name = N'DatabaseAsset',
    @level2type = N'COLUMN', @level2name = N'DatabaseGuid';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Database compatibility level used to interpret engine behavior and feature support.',
    @level0type = N'SCHEMA', @level0name = N'cfg',
    @level1type = N'TABLE',  @level1name = N'DatabaseAsset',
    @level2type = N'COLUMN', @level2name = N'CompatibilityLevel';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Recovery model of the database, such as FULL, SIMPLE, or BULK_LOGGED.',
    @level0type = N'SCHEMA', @level0name = N'cfg',
    @level1type = N'TABLE',  @level1name = N'DatabaseAsset',
    @level2type = N'COLUMN', @level2name = N'RecoveryModel';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Containment description reported by the database engine, used for environment awareness and platform interpretation.',
    @level0type = N'SCHEMA', @level0name = N'cfg',
    @level1type = N'TABLE',  @level1name = N'DatabaseAsset',
    @level2type = N'COLUMN', @level2name = N'ContainmentDesc';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indicates whether the database is currently configured as read-only.',
    @level0type = N'SCHEMA', @level0name = N'cfg',
    @level1type = N'TABLE',  @level1name = N'DatabaseAsset',
    @level2type = N'COLUMN', @level2name = N'IsReadOnly';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indicates whether AUTO_CLOSE is enabled for the database.',
    @level0type = N'SCHEMA', @level0name = N'cfg',
    @level1type = N'TABLE',  @level1name = N'DatabaseAsset',
    @level2type = N'COLUMN', @level2name = N'IsAutoCloseOn';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indicates whether AUTO_SHRINK is enabled for the database.',
    @level0type = N'SCHEMA', @level0name = N'cfg',
    @level1type = N'TABLE',  @level1name = N'DatabaseAsset',
    @level2type = N'COLUMN', @level2name = N'IsAutoShrinkOn';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indicates whether this database is active and should participate in telemetry collection and analysis.',
    @level0type = N'SCHEMA', @level0name = N'cfg',
    @level1type = N'TABLE',  @level1name = N'DatabaseAsset',
    @level2type = N'COLUMN', @level2name = N'IsActive';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'UTC timestamp when the monitored database record was created in the intelligence repository.',
    @level0type = N'SCHEMA', @level0name = N'cfg',
    @level1type = N'TABLE',  @level1name = N'DatabaseAsset',
    @level2type = N'COLUMN', @level2name = N'CreatedUtc';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'UTC timestamp when the monitored database record was last updated.',
    @level0type = N'SCHEMA', @level0name = N'cfg',
    @level1type = N'TABLE',  @level1name = N'DatabaseAsset',
    @level2type = N'COLUMN', @level2name = N'UpdatedUtc';
GO