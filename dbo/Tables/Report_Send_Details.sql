CREATE TABLE [dbo].[Report_Send_Details] (
    [Autoid]           INT           IDENTITY (1, 1) NOT NULL,
    [Provider]         VARCHAR (500) NULL,
    [Report_Send_Date] DATETIME      NULL,
    [Filename]         VARCHAR (500) NULL,
    [DomainID]         VARCHAR (512) NULL,
    [Generated_By]     INT           NULL,
    [Report_Send_Id]   INT           NOT NULL
);

