﻿CREATE TABLE [dbo].[TXN_CASE_PEER_REVIEW_DOCTOR] (
    [ID]           INT            IDENTITY (1, 1) NOT NULL,
    [TREATMENT_ID] INT            NOT NULL,
    [DOCTOR_ID]    INT            NOT NULL,
    [DomainId]     NVARCHAR (512) DEFAULT ('h1') NOT NULL,
    CONSTRAINT [PK_TXN_CASE_PEER_REVIEW_DOCTOR] PRIMARY KEY CLUSTERED ([ID] ASC),
    FOREIGN KEY ([DOCTOR_ID]) REFERENCES [dbo].[TblReviewingDoctor] ([Doctor_id]),
    CONSTRAINT [FK__TXN_CASE___TREAT__2AA05119] FOREIGN KEY ([TREATMENT_ID]) REFERENCES [dbo].[tblTreatment] ([Treatment_Id])
);


GO
CREATE NONCLUSTERED INDEX [IDX_TXN_CASE_PEER_REVIEW_DOCTOR_TREATMENT_ID]
    ON [dbo].[TXN_CASE_PEER_REVIEW_DOCTOR]([TREATMENT_ID] ASC)
    INCLUDE([DOCTOR_ID], [DomainId]);

