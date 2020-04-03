CREATE TABLE [dbo].[tblOperatingDoctor] (
    [Doctor_Id]        INT            IDENTITY (1, 1) NOT NULL,
    [Doctor_Name]      VARCHAR (80)   NULL,
    [Active]           BIT            CONSTRAINT [DF_tblOperatingDoctor_Active] DEFAULT ((1)) NULL,
    [DomainId]         NVARCHAR (512) DEFAULT ('h1') NOT NULL,
    [created_by_user]  NVARCHAR (255) DEFAULT ('admin') NOT NULL,
    [created_date]     DATETIME       NULL,
    [modified_by_user] NVARCHAR (255) NULL,
    [modified_date]    DATETIME       NULL,
    [Doctor_Id_OLD]    INT            NULL
);

