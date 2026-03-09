CREATE TABLE [audit].[CollectorExecution]
(
    [CollectorExecutionId]   BIGINT IDENTITY(1,1) NOT NULL,
    [CollectorName]          NVARCHAR(128) NOT NULL,
    [CollectorType]          NVARCHAR(50) NOT NULL,
    [TargetScope]            NVARCHAR(50) NOT NULL,
    [InstanceId]             INT NULL,
    [DatabaseAssetId]        INT NULL,
    [ExecutionStartUtc]      DATETIME2(0) NOT NULL,
    [ExecutionEndUtc]        DATETIME2(0) NULL,
    [ExecutionStatus]        NVARCHAR(30) NOT NULL,
    [RowsCaptured]           INT NULL,
    [RowsInserted]           INT NULL,
    [ErrorNumber]            INT NULL,
    [ErrorMessage]           NVARCHAR(4000) NULL,
    [ExecutionContext]       NVARCHAR(1000) NULL,
    [CreatedUtc]             DATETIME2(0) NOT NULL CONSTRAINT [DF_audit_CollectorExecution_CreatedUtc] DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT [PK_audit_CollectorExecution] PRIMARY KEY CLUSTERED ([CollectorExecutionId]),
    CONSTRAINT [FK_audit_CollectorExecution_cfg_Instance_InstanceId]
        FOREIGN KEY ([InstanceId]) REFERENCES [cfg].[Instance]([InstanceId]),
    CONSTRAINT [FK_audit_CollectorExecution_cfg_DatabaseAsset_DatabaseAssetId]
        FOREIGN KEY ([DatabaseAssetId]) REFERENCES [cfg].[DatabaseAsset]([DatabaseAssetId]),
    CONSTRAINT [CK_audit_CollectorExecution_ExecutionStatus]
        CHECK ([ExecutionStatus] IN (N'Started', N'Succeeded', N'Failed', N'Partial'))
);
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Logs each telemetry collector execution performed by the Proactive DBA Intelligence Platform. This table supports observability, troubleshooting, operational auditing, and AI-assisted reasoning about collection reliability and data freshness.',
    @level0type = N'SCHEMA', @level0name = N'audit',
    @level1type = N'TABLE',  @level1name = N'CollectorExecution';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Surrogate primary key for the collector execution record.',
    @level0type = N'SCHEMA', @level0name = N'audit',
    @level1type = N'TABLE',  @level1name = N'CollectorExecution',
    @level2type = N'COLUMN', @level2name = N'CollectorExecutionId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Logical name of the collector process or routine that executed.',
    @level0type = N'SCHEMA', @level0name = N'audit',
    @level1type = N'TABLE',  @level1name = N'CollectorExecution',
    @level2type = N'COLUMN', @level2name = N'CollectorName';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Category of collector, such as DMV, QueryStore, ExtendedEvents, AzureMonitor, or LogAnalytics.',
    @level0type = N'SCHEMA', @level0name = N'audit',
    @level1type = N'TABLE',  @level1name = N'CollectorExecution',
    @level2type = N'COLUMN', @level2name = N'CollectorType';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Target level of the collection activity, such as Instance, Database, or Platform.',
    @level0type = N'SCHEMA', @level0name = N'audit',
    @level1type = N'TABLE',  @level1name = N'CollectorExecution',
    @level2type = N'COLUMN', @level2name = N'TargetScope';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Optional foreign key to cfg.Instance when the collector execution applies to a specific monitored instance.',
    @level0type = N'SCHEMA', @level0name = N'audit',
    @level1type = N'TABLE',  @level1name = N'CollectorExecution',
    @level2type = N'COLUMN', @level2name = N'InstanceId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Optional foreign key to cfg.DatabaseAsset when the collector execution applies to a specific monitored database.',
    @level0type = N'SCHEMA', @level0name = N'audit',
    @level1type = N'TABLE',  @level1name = N'CollectorExecution',
    @level2type = N'COLUMN', @level2name = N'DatabaseAssetId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'UTC timestamp when the collector execution started.',
    @level0type = N'SCHEMA', @level0name = N'audit',
    @level1type = N'TABLE',  @level1name = N'CollectorExecution',
    @level2type = N'COLUMN', @level2name = N'ExecutionStartUtc';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'UTC timestamp when the collector execution ended.',
    @level0type = N'SCHEMA', @level0name = N'audit',
    @level1type = N'TABLE',  @level1name = N'CollectorExecution',
    @level2type = N'COLUMN', @level2name = N'ExecutionEndUtc';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Final status of the collector execution lifecycle.',
    @level0type = N'SCHEMA', @level0name = N'audit',
    @level1type = N'TABLE',  @level1name = N'CollectorExecution',
    @level2type = N'COLUMN', @level2name = N'ExecutionStatus';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Number of source rows captured or read by the collector, when available.',
    @level0type = N'SCHEMA', @level0name = N'audit',
    @level1type = N'TABLE',  @level1name = N'CollectorExecution',
    @level2type = N'COLUMN', @level2name = N'RowsCaptured';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Number of rows successfully inserted into the central intelligence repository.',
    @level0type = N'SCHEMA', @level0name = N'audit',
    @level1type = N'TABLE',  @level1name = N'CollectorExecution',
    @level2type = N'COLUMN', @level2name = N'RowsInserted';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Error number returned by the collector process or SQL engine when a failure occurred.',
    @level0type = N'SCHEMA', @level0name = N'audit',
    @level1type = N'TABLE',  @level1name = N'CollectorExecution',
    @level2type = N'COLUMN', @level2name = N'ErrorNumber';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Error message or diagnostic detail captured when the collector execution failed or completed partially.',
    @level0type = N'SCHEMA', @level0name = N'audit',
    @level1type = N'TABLE',  @level1name = N'CollectorExecution',
    @level2type = N'COLUMN', @level2name = N'ErrorMessage';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Optional execution context details such as parameters, filter scope, or other run metadata helpful for troubleshooting and AI grounding.',
    @level0type = N'SCHEMA', @level0name = N'audit',
    @level1type = N'TABLE',  @level1name = N'CollectorExecution',
    @level2type = N'COLUMN', @level2name = N'ExecutionContext';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'UTC timestamp when the collector execution record was written to the audit repository.',
    @level0type = N'SCHEMA', @level0name = N'audit',
    @level1type = N'TABLE',  @level1name = N'CollectorExecution',
    @level2type = N'COLUMN', @level2name = N'CreatedUtc';
GO