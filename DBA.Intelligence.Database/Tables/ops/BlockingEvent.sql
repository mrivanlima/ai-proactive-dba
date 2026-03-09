CREATE TABLE [ops].[BlockingEvent]
(
    [BlockingEventId]        BIGINT IDENTITY(1,1) NOT NULL,
    [InstanceId]             INT NOT NULL,
    [DatabaseAssetId]        INT NULL,
    [BlockedSessionId]       INT NOT NULL,
    [BlockingSessionId]      INT NULL,
    [WaitType]               NVARCHAR(120) NULL,
    [WaitDurationMs]         BIGINT NULL,
    [ResourceDescription]    NVARCHAR(512) NULL,
    [BlockedCommand]         NVARCHAR(64) NULL,
    [BlockingCommand]        NVARCHAR(64) NULL,
    [BlockedLoginName]       NVARCHAR(128) NULL,
    [BlockingLoginName]      NVARCHAR(128) NULL,
    [BlockedHostName]        NVARCHAR(128) NULL,
    [BlockingHostName]       NVARCHAR(128) NULL,
    [BlockedProgramName]     NVARCHAR(256) NULL,
    [BlockingProgramName]    NVARCHAR(256) NULL,
    [BlockedQueryTextShort]  NVARCHAR(1000) NULL,
    [BlockingQueryTextShort] NVARCHAR(1000) NULL,
    [CapturedUtc]            DATETIME2(0) NOT NULL,
    [CreatedUtc]             DATETIME2(0) NOT NULL CONSTRAINT [DF_ops_BlockingEvent_CreatedUtc] DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT [PK_ops_BlockingEvent] PRIMARY KEY CLUSTERED ([BlockingEventId]),
    CONSTRAINT [FK_ops_BlockingEvent_cfg_Instance_InstanceId]
        FOREIGN KEY ([InstanceId]) REFERENCES [cfg].[Instance]([InstanceId]),
    CONSTRAINT [FK_ops_BlockingEvent_cfg_DatabaseAsset_DatabaseAssetId]
        FOREIGN KEY ([DatabaseAssetId]) REFERENCES [cfg].[DatabaseAsset]([DatabaseAssetId])
);
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Stores blocking incidents captured from monitored SQL Server environments. This table supports operational troubleshooting, blocking trend analysis, incident reconstruction, and AI-assisted root cause analysis for concurrency issues.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'BlockingEvent';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Surrogate primary key for the blocking event record.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'BlockingEvent',
    @level2type = N'COLUMN', @level2name = N'BlockingEventId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Foreign key to cfg.Instance identifying the monitored instance where the blocking event occurred.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'BlockingEvent',
    @level2type = N'COLUMN', @level2name = N'InstanceId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Optional foreign key to cfg.DatabaseAsset when the blocking event is associated with a specific monitored database.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'BlockingEvent',
    @level2type = N'COLUMN', @level2name = N'DatabaseAssetId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Session ID of the blocked request or session.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'BlockingEvent',
    @level2type = N'COLUMN', @level2name = N'BlockedSessionId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Session ID of the blocking request or session when identified.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'BlockingEvent',
    @level2type = N'COLUMN', @level2name = N'BlockingSessionId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Wait type observed for the blocked request during the blocking event.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'BlockingEvent',
    @level2type = N'COLUMN', @level2name = N'WaitType';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Wait duration in milliseconds observed at the time of capture.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'BlockingEvent',
    @level2type = N'COLUMN', @level2name = N'WaitDurationMs';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Resource description associated with the blocking condition, such as lock resource details when available.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'BlockingEvent',
    @level2type = N'COLUMN', @level2name = N'ResourceDescription';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Command type running in the blocked session at the time of capture.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'BlockingEvent',
    @level2type = N'COLUMN', @level2name = N'BlockedCommand';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Command type running in the blocking session at the time of capture.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'BlockingEvent',
    @level2type = N'COLUMN', @level2name = N'BlockingCommand';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Login name associated with the blocked session when available.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'BlockingEvent',
    @level2type = N'COLUMN', @level2name = N'BlockedLoginName';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Login name associated with the blocking session when available.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'BlockingEvent',
    @level2type = N'COLUMN', @level2name = N'BlockingLoginName';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Host machine name associated with the blocked session when available.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'BlockingEvent',
    @level2type = N'COLUMN', @level2name = N'BlockedHostName';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Host machine name associated with the blocking session when available.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'BlockingEvent',
    @level2type = N'COLUMN', @level2name = N'BlockingHostName';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Program name associated with the blocked session when available.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'BlockingEvent',
    @level2type = N'COLUMN', @level2name = N'BlockedProgramName';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Program name associated with the blocking session when available.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'BlockingEvent',
    @level2type = N'COLUMN', @level2name = N'BlockingProgramName';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Short captured or normalized text for the blocked statement or batch, used for diagnostics and AI grounding.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'BlockingEvent',
    @level2type = N'COLUMN', @level2name = N'BlockedQueryTextShort';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Short captured or normalized text for the blocking statement or batch, used for diagnostics and AI grounding.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'BlockingEvent',
    @level2type = N'COLUMN', @level2name = N'BlockingQueryTextShort';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'UTC timestamp when the blocking event was observed or captured from the monitored environment.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'BlockingEvent',
    @level2type = N'COLUMN', @level2name = N'CapturedUtc';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'UTC timestamp when the blocking event record was inserted into the central intelligence repository.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'BlockingEvent',
    @level2type = N'COLUMN', @level2name = N'CreatedUtc';
GO