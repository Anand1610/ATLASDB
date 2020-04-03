CREATE TABLE [dbo].[tblAttorney_Master] (
    [Attorney_Id]         INT            IDENTITY (1, 1) NOT NULL,
    [Attorney_Type_Id]    NVARCHAR (50)  NOT NULL,
    [Attorney_LastName]   VARCHAR (100)  NULL,
    [Attorney_FirstName]  VARCHAR (100)  NULL,
    [Attorney_Address]    VARCHAR (255)  NULL,
    [Attorney_City]       VARCHAR (50)   NULL,
    [Attorney_State]      VARCHAR (50)   NULL,
    [Attorney_Zip]        VARCHAR (50)   NULL,
    [Attorney_Phone]      VARCHAR (20)   NULL,
    [Attorney_Fax]        VARCHAR (20)   NULL,
    [Attorney_Email]      VARCHAR (40)   NULL,
    [DomainId]            NVARCHAR (512) NOT NULL,
    [created_by_user]     NVARCHAR (255) NOT NULL,
    [created_date]        DATETIME       NULL,
    [modified_by_user]    NVARCHAR (255) NULL,
    [modified_date]       DATETIME       NULL,
    [LawFirmName]         VARCHAR (200)  NULL,
    [IsOutsideAttorney]   BIT            DEFAULT ((0)) NULL,
    [Attorney_BAR_Number] VARCHAR (150)  NULL
);


GO
CREATE CLUSTERED INDEX [CIDX_tblAttorney_Master]
    ON [dbo].[tblAttorney_Master]([Attorney_Id] ASC);

