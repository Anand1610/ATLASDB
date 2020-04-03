CREATE TABLE [dbo].[tblNotesAAACases] (
    [Notes_ID]   INT             IDENTITY (1, 1) NOT NULL,
    [Notes_Desc] NVARCHAR (3000) NULL,
    [Case_Id]    NVARCHAR (100)  NOT NULL,
    [Notes_Date] DATETIME        DEFAULT (getdate()) NOT NULL,
    [User_Id]    NVARCHAR (50)   NULL,
    [DomainId]   NVARCHAR (512)  NOT NULL
);

