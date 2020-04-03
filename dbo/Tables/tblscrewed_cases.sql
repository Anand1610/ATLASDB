CREATE TABLE [dbo].[tblscrewed_cases] (
    [case_id]             NVARCHAR (50)  NOT NULL,
    [insurancecompany_id] INT            NOT NULL,
    [DomainId]            NVARCHAR (512) DEFAULT ('h1') NOT NULL
);

