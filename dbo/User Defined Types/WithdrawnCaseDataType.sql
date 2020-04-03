CREATE TYPE [dbo].[WithdrawnCaseDataType] AS TABLE (
    [ID]            BIGINT        NOT NULL,
    [BillNumber]    NVARCHAR (20) NOT NULL,
    [CompanyID]     NVARCHAR (20) NOT NULL,
    [LawFirmID]     NVARCHAR (20) NOT NULL,
    [DateWithdrawn] DATETIME      NULL);

