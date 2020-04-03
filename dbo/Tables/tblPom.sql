CREATE TABLE [dbo].[tblPom] (
    [pom_id]               INT            IDENTITY (1, 1) NOT NULL,
    [pom_date]             DATETIME       NULL,
    [pom_generated_by]     NVARCHAR (50)  NULL,
    [pom_scan_date]        DATETIME       NULL,
    [pom_scan_by]          NVARCHAR (50)  NULL,
    [DomainId]             NVARCHAR (512) DEFAULT ('h1') NOT NULL,
    [POM_ID_New]           INT            NULL,
    [POM_ReceivedFileName] VARCHAR (200)  NULL,
    [POM_Date_Bill_Send]   DATETIME       NULL,
    CONSTRAINT [PK_tblpom] PRIMARY KEY CLUSTERED ([pom_id] ASC)
);

