CREATE TABLE [cfg].[Instance]
(
    [InstanceId]       INT IDENTITY(1,1) NOT NULL,
    [InstanceName]     NVARCHAR(128) NOT NULL,
    [HostName]         NVARCHAR(128) NOT NULL,
    [EnvironmentName]  NVARCHAR(50) NOT NULL,
    [PlatformType]     NVARCHAR(30) NOT NULL,
    [IsActive]         BIT NOT NULL CONSTRAINT [DF_cfg_Instance_IsActive] DEFAULT ((1)),
    [CreatedUtc]       DATETIME2(0) NOT NULL CONSTRAINT [DF_cfg_Instance_CreatedUtc] DEFAULT (SYSUTCDATETIME()),
    [UpdatedUtc]       DATETIME2(0) NULL,
    CONSTRAINT [PK_cfg_Instance] PRIMARY KEY CLUSTERED ([InstanceId])
);
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Registers each monitored database platform instance known by the Proactive DBA Intelligence Platform. This table is the primary configuration entity used to identify telemetry sources for on-prem SQL Server, Azure SQL Managed Instance, Azure SQL Database, and future supported platforms.',
    @level0type = N'SCHEMA', @level0name = N'cfg',
    @level1type = N'TABLE',  @level1name = N'Instance';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Surrogate primary key for the monitored instance record.',
    @level0type = N'SCHEMA', @level0name = N'cfg',
    @level1type = N'TABLE',  @level1name = N'Instance',
    @level2type = N'COLUMN', @level2name = N'InstanceId';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Logical instance name used by the platform for identification, reporting, correlation, and AI-assisted analysis.',
    @level0type = N'SCHEMA', @level0name = N'cfg',
    @level1type = N'TABLE',  @level1name = N'Instance',
    @level2type = N'COLUMN', @level2name = N'InstanceName';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Host server or machine name where the monitored database engine is running.',
    @level0type = N'SCHEMA', @level0name = N'cfg',
    @level1type = N'TABLE',  @level1name = N'Instance',
    @level2type = N'COLUMN', @level2name = N'HostName';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Environment classification for the monitored instance, such as DEV, QA, STG, PRD, LAB, or DR.',
    @level0type = N'SCHEMA', @level0name = N'cfg',
    @level1type = N'TABLE',  @level1name = N'Instance',
    @level2type = N'COLUMN', @level2name = N'EnvironmentName';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Platform category for the monitored target, such as SQLServer, AzureSQLMI, or AzureSQLDB.',
    @level0type = N'SCHEMA', @level0name = N'cfg',
    @level1type = N'TABLE',  @level1name = N'Instance',
    @level2type = N'COLUMN', @level2name = N'PlatformType';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'Indicates whether the instance is active and eligible for telemetry collection, baselining, anomaly detection, and AI analysis.',
    @level0type = N'SCHEMA', @level0name = N'cfg',
    @level1type = N'TABLE',  @level1name = N'Instance',
    @level2type = N'COLUMN', @level2name = N'IsActive';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'UTC timestamp when the monitored instance record was first created in the central intelligence repository.',
    @level0type = N'SCHEMA', @level0name = N'cfg',
    @level1type = N'TABLE',  @level1name = N'Instance',
    @level2type = N'COLUMN', @level2name = N'CreatedUtc';
GO

EXEC sys.sp_addextendedproperty
    @name = N'MS_Description',
    @value = N'UTC timestamp when the monitored instance record was last updated.',
    @level0type = N'SCHEMA', @level0name = N'cfg',
    @level1type = N'TABLE',  @level1name = N'Instance',
    @level2type = N'COLUMN', @level2name = N'UpdatedUtc';
GO