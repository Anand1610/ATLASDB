CREATE TABLE [dbo].[tblscrewed_cases2] (
    [case_id]               NVARCHAR (50)  NOT NULL,
    [insurancecompany_name] VARCHAR (250)  NULL,
    [insurancecompany_code] VARCHAR (100)  NULL,
    [new_ins_id]            INT            NULL,
    [DomainId]              NVARCHAR (512) DEFAULT ('h1') NOT NULL
);

