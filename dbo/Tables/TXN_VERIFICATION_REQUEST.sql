CREATE TABLE [dbo].[TXN_VERIFICATION_REQUEST] (
    [I_VERIFICATION_ID]         INT             IDENTITY (1, 1) NOT NULL,
    [SZ_CASE_ID]                NVARCHAR (20)   NOT NULL,
    [DT_VERIFICATION_RECEIVED]  DATETIME        NULL,
    [DT_VERIFICATION_REPLIED]   DATETIME        NULL,
    [SZ_NOTES]                  NVARCHAR (2000) NULL,
    [SZ_USER_ID]                NVARCHAR (20)   NOT NULL,
    [DomainID]                  VARCHAR (50)    NULL,
    [RequestImageID]            BIGINT          NULL,
    [VerificationResponse]      VARCHAR (MAX)   NULL,
    [FaxQueueID]                BIGINT          NULL,
    [FaxAcknowledgementImageID] BIGINT          NULL,
    [FaxStatus]                 VARCHAR (MAX)   NULL,
    [ManualResponseImageID]     BIGINT          NULL,
    [ResendCount]               INT             NULL,
    [I_VERIFICATION_ID_OLD]     INT             NULL,
    [vr_type_Id]                INT             NULL,
    [DT_UPLOAD]                 DATETIME        DEFAULT (getdate()) NULL,
    CONSTRAINT [PK_TXN_VERIFICATION_REQUEST] PRIMARY KEY CLUSTERED ([I_VERIFICATION_ID] ASC)
);

