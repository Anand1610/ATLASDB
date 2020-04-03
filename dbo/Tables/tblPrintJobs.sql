CREATE TABLE [dbo].[tblPrintJobs] (
    [PrintJobs_ID]   INT            IDENTITY (1, 1) NOT NULL,
    [Case_Id]        NVARCHAR (100) NULL,
    [Process_Id]     INT            NULL,
    [Date_Printed]   DATETIME       NULL,
    [Date_Submitted] DATETIME       NULL,
    [Printed]        BIT            NULL,
    [User_Id]        NVARCHAR (100) NULL,
    [DomainId]       NVARCHAR (512) DEFAULT ('h1') NOT NULL,
    CONSTRAINT [pkPrintJobsID] PRIMARY KEY CLUSTERED ([PrintJobs_ID] ASC) WITH (FILLFACTOR = 90),
    CONSTRAINT [FK__tblPrintJ__iProc__797309D9] FOREIGN KEY ([Process_Id]) REFERENCES [dbo].[tblProcess] ([Process_Id])
);

