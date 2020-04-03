CREATE TABLE [dbo].[tblProviderFinancial] (
    [Srl_No]      INT            IDENTITY (1, 1) NOT NULL,
    [Provider_Id] NVARCHAR (100) NULL,
    [DomainId]    NVARCHAR (512) DEFAULT ('h1') NOT NULL
);

