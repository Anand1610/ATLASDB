CREATE TABLE [dbo].[tblCase_additional_info] (
    [case_id]                          NVARCHAR (100)  NULL,
    [domainid]                         NVARCHAR (50)   NULL,
    [Patient_no_Medic]                 NVARCHAR (300)  NULL,
    [Purchase_Balance]                 NVARCHAR (300)  NULL,
    [Purchase_Price]                   NVARCHAR (100)  NULL,
    [First_Party_Case_Status]          NVARCHAR (300)  NULL,
    [First_Party_Attorney]             NVARCHAR (300)  NULL,
    [First_Party_LawFirm]              NVARCHAR (300)  NULL,
    [Our_Attorney]                     NVARCHAR (300)  NULL,
    [Law_Suit_Type]                    NVARCHAR (300)  NULL,
    [Settledby_First_Party_Litigation] NVARCHAR (300)  NULL,
    [Attorney_frmBiller_Note]          NVARCHAR (100)  NULL,
    [Our_Attorney_Law_Firm]            NVARCHAR (100)  NULL,
    [Balance_On_Policy]                DECIMAL (10, 2) NULL,
    [Balance_On_Policy_Bit]            BIT             NULL,
    [CaseFinalStatus]                  NVARCHAR (510)  NULL,
	[VerificationStatus]				VARCHAR(100)	NULL,
	[VerificationDate]					DATETIME NULL
);

