CREATE TYPE [dbo].[procedurecode] AS TABLE (
    [BillNumber]     VARCHAR (256) NULL,
    [Code]           VARCHAR (256) NULL,
    [Description]    VARCHAR (MAX) NULL,
    [Amount]         VARCHAR (64)  NULL,
    [DOS]            VARCHAR (64)  NULL,
    [Specialty]      VARCHAR (64)  NULL,
    [BillAmount]     VARCHAR (64)  NULL,
    [InsFeeSchedule] VARCHAR (64)  NULL,
    [CaseID]         VARCHAR (50)  NULL,
    [TreatmentId]    VARCHAR (64)  NULL,
    [Unit]           VARCHAR (10)  NULL,
    [DomainID]       VARCHAR (50)  NULL,
    [CodeID]         VARCHAR (20)  NULL);

