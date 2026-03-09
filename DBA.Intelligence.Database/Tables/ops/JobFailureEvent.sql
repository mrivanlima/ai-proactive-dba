CREATE TABLE [ops].[JobFailureEvent]
(
    [JobFailureEventId]      BIGINT IDENTITY(1,1) NOT NULL,
    [InstanceId]             INT NOT NULL,
    [JobName]                NVARCHAR(256) NOT NULL,
    [StepName]               NVARCHAR(256) NULL,
    [StepId]                 INT NULL,
    [RunStatus]              NVARCHAR(30) NOT NULL,
    [ErrorMessage]           NVARCHAR(4000) NULL,
    [SqlMessageId]           INT NULL,
    [SqlSeverity]            INT NULL,
    [OperatorName]           NVARCHAR(256) NULL,
    [RetryAttempt]           INT NULL,
    [CapturedUtc]            DATETIME2(0) NOT NULL,
    [CreatedUtc]             DATETIME2(0) NOT NULL CONSTRAINT [DF_ops_JobFailureEvent_CreatedUtc] DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT [PK_ops_JobFailureEvent] PRIMARY KEY CLUSTERED ([JobFailureEventId]),
    CONSTRAINT [FK_ops_JobFailureEvent_cfg_Instance_InstanceId]
        FOREIGN KEY ([InstanceId]) REFERENCES [cfg].[Instance]([InstanceId]),
    CONSTRAINT [CK_ops_JobFailureEvent_RunStatus]
        CHECK ([RunStatus] IN (N'Failed', N'Retried', N'Canceled'))
);
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Stores SQL Agent job failure incidents captured from monitored SQL Server instances. This table supports operational monitoring, failure trend analysis, troubleshooting, and AI-assisted diagnosis of job execution problems.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'JobFailureEvent';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Surrogate primary key for the job failure event record.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'JobFailureEvent',
    @level2type = N'COLUMN', @level2name = N'JobFailureEventId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Foreign key to cfg.Instance identifying the monitored instance where the SQL Agent job failure occurred.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'JobFailureEvent',
    @level2type = N'COLUMN', @level2name = N'InstanceId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Name of the SQL Agent job associated with the failure event.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'JobFailureEvent',
    @level2type = N'COLUMN', @level2name = N'JobName';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Name of the SQL Agent job step that failed, when available.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'JobFailureEvent',
    @level2type = N'COLUMN', @level2name = N'StepName';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Numeric identifier of the SQL Agent job step that failed, when available.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'JobFailureEvent',
    @level2type = N'COLUMN', @level2name = N'StepId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Normalized run outcome classification for the event, such as Failed, Retried, or Canceled.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'JobFailureEvent',
    @level2type = N'COLUMN', @level2name = N'RunStatus';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Failure message or diagnostic text captured for the SQL Agent job execution event.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'JobFailureEvent',
    @level2type = N'COLUMN', @level2name = N'ErrorMessage';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'SQL Server message identifier associated with the failure when available.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'JobFailureEvent',
    @level2type = N'COLUMN', @level2name = N'SqlMessageId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'SQL Server severity associated with the failure when available.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'JobFailureEvent',
    @level2type = N'COLUMN', @level2name = N'SqlSeverity';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Operator name associated with job notifications or escalation when available.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'JobFailureEvent',
    @level2type = N'COLUMN', @level2name = N'OperatorName';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Retry attempt number associated with the failed or retried job step when available.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'JobFailureEvent',
    @level2type = N'COLUMN', @level2name = N'RetryAttempt';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'UTC timestamp when the SQL Agent job failure event was observed or captured from the monitored environment.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'JobFailureEvent',
    @level2type = N'COLUMN', @level2name = N'CapturedUtc';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'UTC timestamp when the job failure event record was inserted into the central intelligence repository.',
    @level0type = N'SCHEMA', @level0name = N'ops',
    @level1type = N'TABLE',  @level1name = N'JobFailureEvent',
    @level2type = N'COLUMN', @level2name = N'CreatedUtc';
GO