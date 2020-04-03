CREATE TABLE [dbo].[AMT] (
    [case_id]             NVARCHAR (255) NULL,
    [Claim_Amount]        FLOAT (53)     NULL,
    [Paid_Amount]         NVARCHAR (255) NULL,
    [DateOfService_Start] DATETIME       NULL,
    [DateOfService_End]   DATETIME       NULL,
    [SERVICE_TYPE]        NVARCHAR (255) NULL,
    [DomainId]            NVARCHAR (255) NULL,
    [Date_BillSent]       DATETIME       NULL
);

