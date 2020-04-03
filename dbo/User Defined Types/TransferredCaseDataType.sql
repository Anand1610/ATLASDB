CREATE TYPE [dbo].[TransferredCaseDataType] AS TABLE (
    [ID]                            INT             NOT NULL,
    [GYBBillNumber]                 NVARCHAR (40)   NOT NULL,
    [BillAmount]                    DECIMAL (18, 4) NOT NULL,
    [TransferAmount]                DECIMAL (18, 4) NOT NULL,
    [GYBAccountID]                  NVARCHAR (40)   NOT NULL,
    [GYBLawFirmID]                  NVARCHAR (40)   NOT NULL,
    [GYBProviderID]                 NVARCHAR (40)   NOT NULL,
    [GYBInsuranceCompanyID]         NVARCHAR (40)   NOT NULL,
    [TransferdDate]                 DATETIME        NOT NULL,
    [AtlasCaseID]                   NVARCHAR (40)   NULL,
    [AtlasCaseIndexNumber]          NVARCHAR (100)  NULL,
    [AtlasPrincipalAmountCollected] DECIMAL (18, 4) NULL,
    [AtlasInterestAmountCollected]  DECIMAL (18, 4) NULL,
    [TransferdStatus]               NVARCHAR (512)  NULL,
    [AtlasCaseStatus]               NVARCHAR (512)  NULL,
    [AtlasLastTransactionDate]      DATETIME        NULL);

