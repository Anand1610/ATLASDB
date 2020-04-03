CREATE TABLE [dbo].[MST_PacketCaseType] (
    [PK_CaseType_Id]   INT            IDENTITY (0, 1) NOT NULL,
    [CaseType]         NVARCHAR (500) NOT NULL,
    [DomainId]         VARCHAR (50)   NOT NULL,
    [created_by_user]  NVARCHAR (255) DEFAULT ('admin') NOT NULL,
    [created_date]     DATETIME       CONSTRAINT [DF_PKTCaseStatus_created_date] DEFAULT (getdate()) NULL,
    [modified_by_user] NVARCHAR (255) NULL,
    [modified_date]    DATETIME       NULL,
    CONSTRAINT [PK_PacketCaseType] PRIMARY KEY CLUSTERED ([DomainId] ASC, [CaseType] ASC)
);

