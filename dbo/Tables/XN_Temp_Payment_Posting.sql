CREATE TABLE [dbo].[XN_Temp_Payment_Posting] (
    [AutoID]          INT            IDENTITY (1, 1) NOT NULL,
    [Account]         NVARCHAR (255) NULL,
    [BillNumber]      NVARCHAR (255) NULL,
    [PatientName]     NVARCHAR (255) NULL,
    [InsuranceName]   NVARCHAR (255) NULL,
    [DoctorName]      NVARCHAR (255) NULL,
    [ProviderName]    NVARCHAR (255) NULL,
    [Location]        NVARCHAR (255) NULL,
    [Specialty]       NVARCHAR (255) NULL,
    [CheckNo]         FLOAT (53)     NULL,
    [CheckDate]       DATETIME       NULL,
    [CheckAmount]     FLOAT (53)     NULL,
    [PaymentDate]     DATETIME       NULL,
    [Username]        NVARCHAR (255) NULL,
    [PaymentType]     NVARCHAR (255) NULL,
    [Transfer_Status] VARCHAR (200)  NULL
);

