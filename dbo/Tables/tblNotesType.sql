CREATE TABLE [dbo].[tblNotesType] (
    [NotesType_Id]     INT            IDENTITY (1, 1) NOT NULL,
    [Notes_Type]       NVARCHAR (50)  NULL,
    [Notes_Type_Color] NVARCHAR (50)  NULL,
    [DomainId]         NVARCHAR (512) DEFAULT ('h1') NOT NULL
);

