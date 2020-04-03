CREATE TABLE [dbo].[tblCaseDeskHistory] (
    [History_Id]    INT            IDENTITY (1, 1) NOT NULL,
    [Case_Id]       NVARCHAR (50)  NOT NULL,
    [Login_User_Id] INT            NOT NULL,
    [From_User_Id]  INT            NULL,
    [To_User_Id]    INT            NULL,
    [Date_Changed]  SMALLDATETIME  NULL,
    [Change_Reason] NVARCHAR (200) NULL,
    [bt_status]     BIT            NULL,
    [DomainId]      NVARCHAR (512) DEFAULT ('h1') NOT NULL,
    CONSTRAINT [PK_tblCaseDeskHistory] PRIMARY KEY CLUSTERED ([History_Id] ASC)
);

