CREATE TABLE [dbo].[tblCaseWitnessList] (
    [WitnessId]     INT            IDENTITY (1, 1) NOT NULL,
    [Case_Id]       NVARCHAR (100) NULL,
    [DomainId]      NVARCHAR (100) NULL,
    [Name]          VARCHAR (500)  NULL,
    [Address]       VARCHAR (MAX)  NULL,
    [City]          VARCHAR (150)  NULL,
    [State]         VARCHAR (150)  NULL,
    [Zip]           VARCHAR (50)   NULL,
    [Email]         VARCHAR (150)  NULL,
    [MobileNumber]  VARCHAR (50)   NULL,
    [PhoneNumber]   VARCHAR (50)   NULL,
    [FaxNumber]     VARCHAR (50)   NULL,
    [Notes]         VARCHAR (MAX)  NULL,
    [CreatedBy]     VARCHAR (100)  NULL,
    [CreatedDate]   DATETIME       NULL,
    [UpdatedBy]     VARCHAR (100)  NULL,
    [UpdatedDate]   DATETIME       NULL,
    [WitnessTypeID] INT            NULL,
    CONSTRAINT [PK_tblCaseWitnessList] PRIMARY KEY CLUSTERED ([WitnessId] ASC)
);

