CREATE TABLE [dbo].[tblMotions] (
    [Motion_ID]             INT            IDENTITY (1, 1) NOT NULL,
    [Case_ID]               NVARCHAR (50)  NULL,
    [Motion_Date]           DATETIME       NULL,
    [Motion_Status]         VARCHAR (50)   NULL,
    [Our_Motion_Type]       VARCHAR (50)   NULL,
    [Defendent_Motion_Type] VARCHAR (200)  NULL,
    [Opposition_Due_Date]   DATETIME       NULL,
    [Reply_Due_Date]        DATETIME       NULL,
    [Notes]                 VARCHAR (200)  NULL,
    [cross_motion]          CHAR (1)       NULL,
    [whose_motion]          NVARCHAR (50)  NULL,
    [room]                  NVARCHAR (50)  NULL,
    [part]                  NVARCHAR (50)  NULL,
    [judge_name]            NVARCHAR (50)  NULL,
    [time_duration]         VARCHAR (50)   NULL,
    [DomainId]              NVARCHAR (512) DEFAULT ('h1') NOT NULL
);

