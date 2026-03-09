CREATE TABLE [ops].[DeadlockEvent]
(
    [DeadlockEventId]          BIGINT IDENTITY(1,1) NOT NULL,
    [InstanceId]               INT NOT NULL,
    [DatabaseAssetId]          INT NULL,
    [DeadlockGraphXml]         XML NOT NULL,
    [DeadlockHash]             VARBINARY(32) NULL,
    [VictimSessionId]          INT NULL,
    [VictimLoginName]          NVARCHAR(128) NULL,
    [VictimHostName]           NVARCHAR(128) NULL,
    [VictimProgramName]        NVARCHAR(256) NULL,
    [VictimQueryTextShort]     NVARCHAR(1000) NULL,
    [SurvivorSessionId]        INT NULL,
    [SurvivorLoginName]        NVARCHAR(128) NULL,
    [SurvivorHostName]         NVARCHAR(128) NULL,
    [SurvivorProgramName]      NVARCHAR(256) NULL,
    [SurvivorQueryTextShort]   NVARCHAR(1000) NULL,
    [CapturedUtc]              DATETIME2(0) NOT NULL,
    [CreatedUtc]               DATETIME2(0) NOT NULL CONSTRAINT [DF_ops_DeadlockEvent_CreatedUtc] DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT [PK_ops_DeadlockEvent] PRIMARY KEY CLUSTERED ([DeadlockEventId]),
    CONSTRAINT [FK_ops_DeadlockEvent_cfg_Instance_InstanceId]
        FOREIGN KEY ([InstanceId]) REFERENCES [cfg].[Instance]([InstanceId]),
    CONSTRAINT [FK_ops_DeadlockEvent_cfg_DatabaseAsset_DatabaseAssetId]
        FOREIGN KEY ([DatabaseAssetId]) REFERENCES [cfg].[DatabaseAsset]([DatabaseAssetId])
);
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Stores deadlock incidents captured from monitored SQL Server environments. This table preserves deadlock graph evidence and key session context to support forensic investigation, recurring pattern analysis, and AI-assisted root cause analysis.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'DeadlockEvent';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Surrogate primary key for the deadlock event record.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'DeadlockEvent',
    @level2type = N'COLUMN', @level2name = N'DeadlockEventId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Foreign key to cfg.Instance identifying the monitored instance where the deadlock occurred.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'DeadlockEvent',
    @level2type = N'COLUMN', @level2name = N'InstanceId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Optional foreign key to cfg.DatabaseAsset when the deadlock is associated with a specific monitored database.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'DeadlockEvent',
    @level2type = N'COLUMN', @level2name = N'DatabaseAssetId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'XML deadlock graph captured from Extended Events or another collector, preserving the full deadlock structure and evidence.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'DeadlockEvent',
    @level2type = N'COLUMN', @level2name = N'DeadlockGraphXml';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Optional normalized hash of the deadlock graph used to identify repeating deadlock patterns over time.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'DeadlockEvent',
    @level2type = N'COLUMN', @level2name = N'DeadlockHash';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Session ID of the deadlock victim when identifiable from the captured graph.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'DeadlockEvent',
    @level2type = N'COLUMN', @level2name = N'VictimSessionId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Login name associated with the deadlock victim session when available.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'DeadlockEvent',
    @level2type = N'COLUMN', @level2name = N'VictimLoginName';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Host machine name associated with the deadlock victim session when available.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'DeadlockEvent',
    @level2type = N'COLUMN', @level2name = N'VictimHostName';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Program name associated with the deadlock victim session when available.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'DeadlockEvent',
    @level2type = N'COLUMN', @level2name = N'VictimProgramName';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Short captured or normalized text for the deadlock victim statement or batch, used for diagnostics and AI grounding.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'DeadlockEvent',
    @level2type = N'COLUMN', @level2name = N'VictimQueryTextShort';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Session ID of a surviving participant in the deadlock when identifiable from the captured graph.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'DeadlockEvent',
    @level2type = N'COLUMN', @level2name = N'SurvivorSessionId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Login name associated with a surviving deadlock participant when available.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'DeadlockEvent',
    @level2type = N'COLUMN', @level2name = N'SurvivorLoginName';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Host machine name associated with a surviving deadlock participant when available.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'DeadlockEvent',
    @level2type = N'COLUMN', @level2name = N'SurvivorHostName';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Program name associated with a surviving deadlock participant when available.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'DeadlockEvent',
    @level2type = N'COLUMN', @level2name = N'SurvivorProgramName';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Short captured or normalized text for a surviving deadlock participant statement or batch, used for diagnostics and AI grounding.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'DeadlockEvent',
    @level2type = N'COLUMN', @level2name = N'SurvivorQueryTextShort';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'UTC timestamp when the deadlock event was observed or captured from the monitored environment.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'DeadlockEvent',
    @level2type = N'COLUMN', @level2name = N'CapturedUtc';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'UTC timestamp when the deadlock event record was inserted into the central intelligence repository.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'DeadlockEvent',
    @level2type = N'COLUMN', @level2name = N'CreatedUtc';
GO