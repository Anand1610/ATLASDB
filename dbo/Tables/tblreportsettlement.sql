CREATE TABLE [dbo].[tblreportsettlement] (
    [case_id]               NVARCHAR (50)   NULL,
    [sett_tot]              MONEY           NULL,
    [Provider_Name]         NVARCHAR (100)  NULL,
    [InsuranceCompany_Name] NVARCHAR (100)  NULL,
    [InjuredParty_Name]     NVARCHAR (100)  NULL,
    [Claim_Amount]          MONEY           NULL,
    [User_Id]               NVARCHAR (100)  NULL,
    [Settlement_Amount]     MONEY           NULL,
    [Settlement_Int]        MONEY           NULL,
    [Settlement_Af]         MONEY           NULL,
    [Settlement_Ff]         MONEY           NULL,
    [Settlement_Date]       DATETIME        NULL,
    [Settlement_Notes]      NVARCHAR (2000) NULL,
    [Provider_Id]           NVARCHAR (20)   NULL,
    [Settlement_Total]      MONEY           NULL,
    [Paid_amount]           MONEY           NULL,
    [Date_Opened]           DATETIME        NULL,
    [InsuranceCompany_Id]   NVARCHAR (20)   NULL,
    [DOS]                   NVARCHAR (200)  NULL,
    [Fee_Schedule]          MONEY           NULL,
    [DomainId]              NVARCHAR (512)  DEFAULT ('h1') NOT NULL
);

