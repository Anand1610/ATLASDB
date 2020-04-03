CREATE TABLE [dbo].[tblNotes] (
    [Notes_ID]        INT            IDENTITY (1, 1) NOT NULL,
    [Notes_Desc]      VARCHAR (3000) NULL,
    [Notes_Type]      VARCHAR (50)   NULL,
    [Notes_Priority]  VARCHAR (50)   NULL,
    [Case_Id]         VARCHAR (50)   NOT NULL,
    [Notes_Date]      SMALLDATETIME  CONSTRAINT [DF_tblNotes_Notes_Date] DEFAULT (getdate()) NULL,
    [User_Id]         VARCHAR (50)   CONSTRAINT [DF_tblNotes_User_Id] DEFAULT ('system') NULL,
    [DomainId]        VARCHAR (512)  CONSTRAINT [DF__tblNotes__Domain__5D60DB10] DEFAULT ('h1') NOT NULL,
    [WorkflowQueueID] INT            NULL,
    [Notes_Id_Old]    INT            NULL,
    CONSTRAINT [PK_tblNotes] PRIMARY KEY CLUSTERED ([Notes_ID] ASC) WITH (FILLFACTOR = 90)
);


GO
CREATE NONCLUSTERED INDEX [IDX_tblNotes_Case_Id_Notes_Type]
    ON [dbo].[tblNotes]([Case_Id] ASC, [Notes_Type] ASC)
    INCLUDE([Notes_Date], [Notes_Desc], [Notes_Priority], [Notes_ID]);


GO
CREATE NONCLUSTERED INDEX [idxtblNotes_CaseId]
    ON [dbo].[tblNotes]([DomainId] ASC, [Case_Id] DESC, [Notes_Date] ASC)
    INCLUDE([User_Id], [Notes_Desc], [Notes_Type]);

