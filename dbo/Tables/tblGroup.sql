CREATE TABLE [dbo].[tblGroup] (
    [Group_Id]         INT             IDENTITY (1, 1) NOT NULL,
    [Group_CreateDate] DATETIME        CONSTRAINT [DF_tblGroup_Group_CreateDate] DEFAULT (getdate()) NOT NULL,
    [Group_All]        NVARCHAR (1000) NULL,
    [DomainId]         NVARCHAR (512)  DEFAULT ('h1') NOT NULL,
    CONSTRAINT [PK_tblGroup] PRIMARY KEY CLUSTERED ([Group_Id] ASC) WITH (FILLFACTOR = 90)
);

