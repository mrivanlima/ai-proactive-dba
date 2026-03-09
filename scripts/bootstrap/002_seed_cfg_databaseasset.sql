SET NOCOUNT ON;
SET XACT_ABORT ON;

BEGIN TRY
    BEGIN TRAN;

    DECLARE @InstanceName        NVARCHAR(128) = N'sql2025-lab';
    DECLARE @DatabaseName        NVARCHAR(128) = N'DBA_Intelligence';
    DECLARE @StableDatabaseGuid  UNIQUEIDENTIFIER = '11111111-1111-1111-1111-111111111111';
    DECLARE @UtcNow              DATETIME2(7) = SYSUTCDATETIME();

    DECLARE @InstanceId INT;

    SELECT
        @InstanceId = i.InstanceId
    FROM cfg.Instance AS i
    WHERE i.InstanceName = @InstanceName;

    IF @InstanceId IS NULL
    BEGIN
        THROW 50001, 'cfg.Instance seed row was not found. Run 001_seed_cfg_instance.sql first.', 1;
    END;

    DECLARE @CompatibilityLevel INT;
    DECLARE @RecoveryModel      NVARCHAR(60);
    DECLARE @ContainmentDesc    NVARCHAR(60);
    DECLARE @IsReadOnly         BIT;
    DECLARE @IsAutoCloseOn      BIT;
    DECLARE @IsAutoShrinkOn     BIT;

    SELECT
        @CompatibilityLevel = d.compatibility_level,
        @RecoveryModel      = d.recovery_model_desc,
        @ContainmentDesc    = d.containment_desc,
        @IsReadOnly         = d.is_read_only,
        @IsAutoCloseOn      = d.is_auto_close_on,
        @IsAutoShrinkOn     = d.is_auto_shrink_on
    FROM sys.databases AS d
    WHERE d.name = @DatabaseName;

    IF @CompatibilityLevel IS NULL
    BEGIN
        THROW 50002, 'Target database DBA_Intelligence was not found on this instance.', 1;
    END;

    UPDATE cfg.DatabaseAsset
       SET CompatibilityLevel = @CompatibilityLevel,
           RecoveryModel      = @RecoveryModel,
           ContainmentDesc    = @ContainmentDesc,
           IsReadOnly         = @IsReadOnly,
           IsAutoCloseOn      = @IsAutoCloseOn,
           IsAutoShrinkOn     = @IsAutoShrinkOn,
           IsActive           = 1,
           UpdatedUtc         = @UtcNow
     WHERE InstanceId         = @InstanceId
       AND DatabaseName       = @DatabaseName;

    IF @@ROWCOUNT = 0
    BEGIN
        INSERT INTO cfg.DatabaseAsset
        (
            InstanceId,
            DatabaseName,
            DatabaseGuid,
            CompatibilityLevel,
            RecoveryModel,
            ContainmentDesc,
            IsReadOnly,
            IsAutoCloseOn,
            IsAutoShrinkOn,
            IsActive,
            CreatedUtc,
            UpdatedUtc
        )
        VALUES
        (
            @InstanceId,
            @DatabaseName,
            @StableDatabaseGuid,
            @CompatibilityLevel,
            @RecoveryModel,
            @ContainmentDesc,
            @IsReadOnly,
            @IsAutoCloseOn,
            @IsAutoShrinkOn,
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
    da.DatabaseAssetId,
    da.InstanceId,
    da.DatabaseName,
    da.DatabaseGuid,
    da.CompatibilityLevel,
    da.RecoveryModel,
    da.ContainmentDesc,
    da.IsReadOnly,
    da.IsAutoCloseOn,
    da.IsAutoShrinkOn,
    da.IsActive,
    da.CreatedUtc,
    da.UpdatedUtc
FROM cfg.DatabaseAsset AS da
INNER JOIN cfg.Instance AS i
    ON da.InstanceId = i.InstanceId
WHERE i.InstanceName = N'sql2025-lab'
  AND da.DatabaseName = N'DBA_Intelligence';
GO