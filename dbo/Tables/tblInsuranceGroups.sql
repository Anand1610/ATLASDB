CREATE TABLE [dbo].[tblInsuranceGroups] (
    [GroupName] VARCHAR (100)  NOT NULL,
    [DomainId]  NVARCHAR (512) DEFAULT ('h1') NOT NULL,
    CONSTRAINT [PK_tblInsuranceGroups] PRIMARY KEY CLUSTERED ([GroupName] ASC)
);

