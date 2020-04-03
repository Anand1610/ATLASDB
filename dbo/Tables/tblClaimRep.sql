CREATE TABLE [dbo].[tblClaimRep] (
    [ClaimRep_Id]        INT            IDENTITY (1, 1) NOT NULL,
    [ClaimRep_LastName]  NVARCHAR (100) NULL,
    [ClaimRep_FirstName] NVARCHAR (100) NULL,
    [Insurer_Id]         NVARCHAR (50)  NOT NULL,
    [ClaimRep_Phone]     NVARCHAR (50)  NULL,
    [ClaimRep_Fax]       NVARCHAR (50)  NULL,
    [ClaimRep_Email]     NVARCHAR (50)  NULL,
    [DomainId]           NVARCHAR (512) DEFAULT ('h1') NOT NULL
);

