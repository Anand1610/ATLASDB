CREATE TABLE [dbo].[AdminNotes] (
    [Notes_ID]   INT             IDENTITY (1, 1) NOT NULL,
    [Notes_Desc] NVARCHAR (3000) NULL,
    [Notes_Date] DATETIME        CONSTRAINT [DF_AdminNotes1_Notes_Date_1] DEFAULT (getdate()) NULL,
    [User_Id]    NVARCHAR (50)   CONSTRAINT [DF_AdminNotes1_User_Id_1] DEFAULT ('system') NULL,
    [Type]       NVARCHAR (200)  NULL,
    [DomainId]   NVARCHAR (50)   DEFAULT ('h1') NOT NULL
);

