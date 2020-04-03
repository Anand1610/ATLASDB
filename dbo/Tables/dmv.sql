CREATE TABLE [dbo].[dmv] (
    [ID]                    NVARCHAR (255) NULL,
    [Insurer_Name]          NVARCHAR (255) NULL,
    [Insurer_Suit_Name]     NVARCHAR (255) NULL,
    [Insurer_Perm_Address]  NVARCHAR (255) NULL,
    [Insurer_Perm_City]     NVARCHAR (255) NULL,
    [Insurer_Perm_State]    NVARCHAR (255) NULL,
    [Insurer_Perm_Zip]      NVARCHAR (255) NULL,
    [Insurer_Perm_Phone]    NVARCHAR (255) NULL,
    [Insurer_Perm_Fax]      NVARCHAR (255) NULL,
    [Insurer_local_Address] NVARCHAR (255) NULL,
    [Insurer_local_City]    NVARCHAR (255) NULL,
    [Insurer_local_State]   NVARCHAR (255) NULL,
    [Insurer_local_Zip]     NVARCHAR (255) NULL,
    [Insurer_local_phone]   NVARCHAR (255) NULL,
    [Insurer_local_fax]     NVARCHAR (255) NULL,
    [DomainId]              NVARCHAR (50)  DEFAULT ('h1') NOT NULL
);

