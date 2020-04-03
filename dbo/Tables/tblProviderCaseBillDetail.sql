CREATE TABLE [dbo].[tblProviderCaseBillDetail] (
    [Id]                  INT             IDENTITY (1, 1) NOT NULL,
    [DateOfService_Start] DATETIME        NULL,
    [DateOfService_End]   DATETIME        NULL,
    [Claim_Amount]        VARCHAR (100)   NULL,
    [Paid_Amount]         VARCHAR (100)   NULL,
    [Fee_Schedule]        NUMERIC (18, 2) NULL,
    [Date_BillSent]       VARCHAR (250)   NULL,
    [DenialReasons_Type]  NVARCHAR (50)   NULL,
    [BILL_NUMBER]         VARCHAR (100)   NULL,
    [SERVICE_TYPE]        VARCHAR (100)   NULL,
    [TreatingDoctor_ID]   INT             NULL,
    [Action_Type]         VARCHAR (100)   NULL,
    [PeerReviewDoctor_ID] INT             NULL,
    [Case_Id]             NVARCHAR (50)   NULL,
    [DomainId]            NVARCHAR (50)   NOT NULL,
    [Account_Number]      VARCHAR (50)    NULL,
    [DenialReason_ID]     INT             NULL
);

