CREATE TABLE [dbo].[tblNotes_SA_OLD] (
    [Notes_ID]       INT             NOT NULL,
    [Notes_Desc]     NVARCHAR (3000) NULL,
    [Notes_Type]     NVARCHAR (20)   NULL,
    [Notes_Priority] NVARCHAR (3)    NULL,
    [Case_Id]        NVARCHAR (100)  NOT NULL,
    [Notes_Date]     SMALLDATETIME   NULL,
    [User_Id]        NVARCHAR (50)   NULL,
    [DomainId]       NVARCHAR (512)  NOT NULL,
    CONSTRAINT [PK_tblNotes_SA_OLD] PRIMARY KEY CLUSTERED ([Notes_ID] ASC) WITH (FILLFACTOR = 90)
);

