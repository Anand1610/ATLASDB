CREATE TABLE [dbo].[tbl_ip_tracker] (
    [Auto_ID]     INT             IDENTITY (1, 1) NOT NULL,
    [UserName]    VARCHAR (50)    NULL,
    [UserId]      VARCHAR (50)    NULL,
    [REMOTE_ADDR] NVARCHAR (2000) NULL,
    [IPAdd]       NVARCHAR (500)  NULL,
    [Login_Date]  DATETIME        CONSTRAINT [DF_tbl_ip_tracker_Login_Date] DEFAULT (getdate()) NULL,
    [DomainID]    VARCHAR (50)    NULL
);

