SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRAN;

    DECLARE @InstanceName     NVARCHAR(128) = N'sql2025-lab';
    DECLARE @HostName         NVARCHAR(128) = N'sql2025-lab';
    DECLARE @EnvironmentName  NVARCHAR(50)  = N'LAB';
    DECLARE @PlatformType     NVARCHAR(50)  = N'SQLServer';
    DECLARE @UtcNow           DATETIME2(7)  = SYSUTCDATETIME();

    UPDATE cfg.Instance
       SET HostName        = @HostName,
           EnvironmentName = @EnvironmentName,
           PlatformType    = @PlatformType,
           IsActive        = 1,
           UpdatedUtc      = @UtcNow
     WHERE InstanceName    = @InstanceName;

    IF @@ROWCOUNT = 0
    BEGIN
        INSERT INTO cfg.Instance
        (
            InstanceName,
            HostName,
            EnvironmentName,
            PlatformType,
            IsActive,
            CreatedUtc,
            UpdatedUtc
        )
        VALUES
        (
            @InstanceName,
            @HostName,
            @EnvironmentName,
            @PlatformType,
            1,
            @UtcNow,
            @UtcNow
        );
    END;

    COMMIT TRAN;
END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRAN;

    THROW;
END CATCH;
GO

SELECT
    InstanceId,
    InstanceName,
    HostName,
    EnvironmentName,
    PlatformType,
    IsActive,
    CreatedUtc,
    UpdatedUtc
FROM cfg.Instance
WHERE InstanceName = N'sql2025-lab';
GO