CREATE TABLE [dbo].[H_tblNotes] (
    [Notes_ID]       INT             NOT NULL,
    [Notes_Desc]     NVARCHAR (3000) NULL,
    [Notes_Type]     NVARCHAR (20)   NULL,
    [Notes_Priority] NVARCHAR (3)    NULL,
    [Case_Id]        NVARCHAR (100)  NOT NULL,
    [Notes_Date]     SMALLDATETIME   CONSTRAINT [DF_tblNotes_Notes_Date_H] DEFAULT (getdate()) NULL,
    [User_Id]        NVARCHAR (50)   CONSTRAINT [DF_tblNotes_User_Id_H] DEFAULT ('system') NULL,
    [DomainId]       NVARCHAR (512)  DEFAULT ('h1') NOT NULL
);

