CREATE TABLE [dbo].[tblrecon_file] (
    [Auto_Id]                INT            IDENTITY (1, 1) NOT NULL,
    [FACS_ACCT]              NVARCHAR (50)  NULL,
    [Injuredparty_lastName]  NVARCHAR (100) NULL,
    [Injuredparty_FirstName] NVARCHAR (100) NULL,
    [Product_Line]           NVARCHAR (50)  NULL,
    [Exp]                    NVARCHAR (50)  NULL,
    [DU13211]                NVARCHAR (50)  NULL,
    [DU13212]                NVARCHAR (50)  NULL,
    [DU13213]                NVARCHAR (50)  NULL,
    [File_Rec_Date]          NVARCHAR (50)  NULL,
    [ACCT#_From_clt]         NVARCHAR (50)  NULL,
    [Doctor_Name]            NVARCHAR (100) NULL,
    [Client_Name]            NVARCHAR (100) NULL,
    [DOS]                    NVARCHAR (50)  NULL,
    [Insurance_Id]           NVARCHAR (50)  NULL,
    [DomainId]               NVARCHAR (512) DEFAULT ('h1') NOT NULL
);

