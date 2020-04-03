CREATE TABLE [dbo].[tblServed] (
    [InsuranceCompany_Id] INT            NULL,
    [Name]                VARCHAR (120)  NULL,
    [Age]                 VARCHAR (10)   NULL,
    [Weight]              VARCHAR (10)   NULL,
    [Height]              VARCHAR (10)   NULL,
    [skin]                VARCHAR (50)   NULL,
    [hair]                VARCHAR (50)   NULL,
    [sex]                 VARCHAR (10)   NULL,
    [ID]                  INT            IDENTITY (1, 1) NOT NULL,
    [DomainId]            NVARCHAR (512) DEFAULT ('h1') NOT NULL
);

