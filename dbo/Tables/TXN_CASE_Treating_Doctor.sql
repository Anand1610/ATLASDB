CREATE TABLE [dbo].[TXN_CASE_Treating_Doctor] (
    [ID]           INT            IDENTITY (1, 1) NOT NULL,
    [TREATMENT_ID] INT            NULL,
    [DOCTOR_ID]    INT            NULL,
    [DomainId]     NVARCHAR (512) DEFAULT ('h1') NOT NULL,
    CONSTRAINT [FK__TXN_CASE___TREAT__2B947552] FOREIGN KEY ([TREATMENT_ID]) REFERENCES [dbo].[tblTreatment] ([Treatment_Id])
);

