CREATE TABLE [dbo].[tblcaserecon] (
    [id]             INT            IDENTITY (1, 1) NOT NULL,
    [case_id]        NVARCHAR (50)  NULL,
    [facs_Acct]      NVARCHAR (100) NULL,
    [ACCT#_From_clt] VARCHAR (100)  NULL,
    [Product_Line]   NVARCHAR (100) NULL,
    [DomainId]       NVARCHAR (512) DEFAULT ('h1') NOT NULL
);

