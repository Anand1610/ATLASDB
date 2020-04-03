CREATE TABLE [dbo].[tblFirms] (
    [Firm_AutoId]  INT            IDENTITY (1, 1) NOT NULL,
    [Firm_Id]      NVARCHAR (50)  NOT NULL,
    [Firm_Name]    VARCHAR (100)  NOT NULL,
    [Firm_Address] VARCHAR (255)  NULL,
    [Firm_City]    VARCHAR (100)  NULL,
    [Firm_State]   VARCHAR (100)  NULL,
    [Firm_Zip]     VARCHAR (20)   NULL,
    [Firm_Phone]   VARCHAR (20)   NULL,
    [Firm_Fax]     VARCHAR (20)   NULL,
    [Firm_Email]   VARCHAR (100)  NULL,
    [DomainId]     NVARCHAR (512) DEFAULT ('h1') NOT NULL
);

