CREATE TABLE [dbo].[tblRTFNotes] (
    [id]            INT             IDENTITY (1, 1) NOT NULL,
    [Notes_Desc]    NVARCHAR (2000) NULL,
    [Notes_Date]    SMALLDATETIME   NULL,
    [template_name] VARCHAR (200)   NULL,
    [User_Id]       NVARCHAR (50)   NULL,
    [DomainId]      NVARCHAR (512)  DEFAULT ('h1') NOT NULL
);

