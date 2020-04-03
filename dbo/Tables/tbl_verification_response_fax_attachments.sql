CREATE TABLE [dbo].[tbl_verification_response_fax_attachments] (
    [pk_vr_fax_attachment_id]     INT          IDENTITY (1, 1) NOT NULL,
    [I_VERIFICATION_ID]           INT          NOT NULL,
    [FaxImageID]                  BIGINT       NOT NULL,
    [DomainID]                    VARCHAR (50) NULL,
    [isDeleted]                   BIT          NULL,
    [pk_vr_fax_attachment_id_old] INT          NULL,
    CONSTRAINT [tbl_verification_response_fax_attachments_I_VERIFICATION_ID] FOREIGN KEY ([I_VERIFICATION_ID]) REFERENCES [dbo].[TXN_VERIFICATION_REQUEST] ([I_VERIFICATION_ID])
);

