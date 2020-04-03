CREATE TABLE [dbo].[tblClient_Network_Details] (
    [ID]               INT            IDENTITY (1, 1) NOT NULL,
    [client_id]        NVARCHAR (500) NOT NULL,
    [client_Secret]    NVARCHAR (500) NOT NULL,
    [User_Name]        NVARCHAR (50)  NOT NULL,
    [User_Password]    NVARCHAR (500) NOT NULL,
    [DomainID]         VARCHAR (50)   NOT NULL,
    [Host_Name]        NVARCHAR (50)  NULL,
    [Folder_Base_Path] NVARCHAR (500) NULL,
    [ControlPlane]     NVARCHAR (100) NULL,
    [ReortSentID]      VARCHAR (200)  NULL,
    [Report_Type]      NVARCHAR (50)  NULL,
    [TimerValue]       INT            NULL,
    [TimerDay]         INT            NULL,
    [Report_SP]        NVARCHAR (100) NULL,
    [Report_Sub]       NVARCHAR (500) NULL,
    [Report_CC]        NVARCHAR (50)  NULL,
    [Report_BCC]       NVARCHAR (50)  NULL,
    [Report_Reply_To]  NVARCHAR (50)  NULL
);

