CREATE TABLE [dbo].[tblInsuranceCompany] (
    [InsuranceCompany_Id]               INT             IDENTITY (1, 1) NOT NULL,
    [InsuranceCompany_Name]             VARCHAR (250)   NULL,
    [InsuranceCompany_SuitName]         VARCHAR (250)   NULL,
    [InsuranceCompany_Type]             VARCHAR (40)    NULL,
    [InsuranceCompany_Local_Address]    VARCHAR (250)   NULL,
	InsuranceCompany_Local_Address_1    varchar(255)    NULL,
    [InsuranceCompany_Local_City]       VARCHAR (100)   NULL,
    [InsuranceCompany_Local_State]      VARCHAR (100)   NULL,
    [InsuranceCompany_Local_Zip]        VARCHAR (100)   NULL,
    [InsuranceCompany_Local_Phone]      VARCHAR (100)   NULL,
    [InsuranceCompany_Local_Fax]        VARCHAR (100)   NULL,
    [InsuranceCompany_Perm_Address]     VARCHAR (250)   NULL,
    [InsuranceCompany_Perm_City]        VARCHAR (100)   NULL,
    [InsuranceCompany_Perm_State]       VARCHAR (100)   NULL,
    [InsuranceCompany_Perm_Zip]         VARCHAR (100)   NULL,
    [InsuranceCompany_Perm_Phone]       VARCHAR (100)   NULL,
    [InsuranceCompany_Perm_Fax]         VARCHAR (100)   NULL,
    [InsuranceCompany_Contact]          VARCHAR (255)   NULL,
    [InsuranceCompany_Email]            VARCHAR (100)   NULL,
    [InsuranceCompany_GroupName]        VARCHAR (200)   NULL,
    [Active]                            INT             CONSTRAINT [DF_tblInsuranceCompany_Active1] DEFAULT ((2)) NULL,
    [SZ_SHORT_NAME]                     NVARCHAR (100)  NULL,
    [BILLING_ADDRESS]                   VARCHAR (100)   NULL,
    [BILLING_CITY]                      VARCHAR (50)    NULL,
    [BILLING_STATE]                     VARCHAR (2)     NULL,
    [BILLING_ZIP]                       VARCHAR (10)    NULL,
    [ActiveStatus]                      BIT             CONSTRAINT [DF_tblInsuranceCompany_ActiveStatus] DEFAULT ((1)) NULL,
    [InsuranceCompany_Initial_Address]  VARCHAR (250)   NULL,
    [InsuranceCompany_Initial_City]     VARCHAR (100)   NULL,
    [InsuranceCompany_Initial_State]    VARCHAR (100)   NULL,
    [InsuranceCompany_Initial_Zip]      VARCHAR (100)   NULL,
    [InsuranceCompany_Address2_Address] NVARCHAR (100)  NULL,
    [InsuranceCompany_Address2_City]    NVARCHAR (100)  NULL,
    [InsuranceCompany_Address2_State]   NVARCHAR (100)  NULL,
    [InsuranceCompany_Address2_Zip]     NVARCHAR (100)  NULL,
    [InsuranceCompany_Address2_Phone]   NVARCHAR (100)  NULL,
    [InsuranceCompany_Address2_Fax]     NVARCHAR (100)  NULL,
    [gbb_status]                        NVARCHAR (1000) NULL,
    [gbb_initial_status]                NVARCHAR (1000) NULL,
    [RCF_initial_status]                NVARCHAR (1000) NULL,
    [DomainId]                          NVARCHAR (50)   DEFAULT ('h1') NOT NULL,
    [InsuranceCompanyGroup_ID]          INT             NULL,
    [Served_Person_Name]                VARCHAR (200)   NULL,
    [Served_Date]                       DATETIME        NULL,
    [Height]                            NVARCHAR (50)   NULL,
    [Weight]                            NVARCHAR (50)   NULL,
    [Age]                               INT             NULL,
    [Skin_Colour]                       VARCHAR (50)    NULL,
    [Hair_Colour]                       VARCHAR (50)    NULL,
    [Gender]                            VARCHAR (50)    NULL,
    [InsuranceCompany_Local_County]     VARCHAR (150)   NULL,
    [InsuranceCompany_Address2_County]  VARCHAR (150)   NULL,
    [InsuranceCompany_Perm_County]      VARCHAR (150)   NULL,
    [InsuranceCompany_Initial_County]   VARCHAR (150)   NULL,
    [fk_TPA_Group_ID]                   INT             NULL,
    [Now_Known_As]                      VARCHAR (MAX)   NULL,
    [Notes]                             VARCHAR (MAX)   NULL,
    [FK_INSURANCE_TYPE_ID]              INT             NULL,
    CONSTRAINT [FK_tblInsuranceCompany_tblInsurance_TPA_Group] FOREIGN KEY ([fk_TPA_Group_ID]) REFERENCES [dbo].[tblInsurance_TPA_Group] ([PK_TPA_Group_ID])
);


GO
CREATE UNIQUE CLUSTERED INDEX [CIDX_DomainId_INS_ID]
    ON [dbo].[tblInsuranceCompany]([DomainId] ASC, [InsuranceCompany_Id] ASC);


GO
CREATE NONCLUSTERED INDEX [Xi_domainid]
    ON [dbo].[tblInsuranceCompany]([DomainId] ASC);


GO
CREATE NONCLUSTERED INDEX [idx_tblInsuranceCompany_InsuranceCompany_Id]
    ON [dbo].[tblInsuranceCompany]([InsuranceCompany_Id] ASC)
    INCLUDE([InsuranceCompany_Name]);

