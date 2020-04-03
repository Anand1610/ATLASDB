CREATE TABLE [dbo].[tbl_batch_print_fax_queue] (
    [pk_bp_fax_queue_id] INT           IDENTITY (1, 1) NOT NULL,
    [Domain_Id]          VARCHAR (50)  NOT NULL,
    [fk_bp_ef_status_id] BIGINT        NOT NULL,
    [FaxNumber]          VARCHAR (50)  NOT NULL,
    [SentByUser]         VARCHAR (MAX) NULL,
    [SentOn]             DATETIME      NULL,
    [isDeleted]          BIT           NULL,
    [IsAddedtoQueue]     BIT           NULL,
    [AddedtoQueueDate]   DATETIME      NULL,
    [CoverPageText]      VARCHAR (MAX) NULL,
    [AddToQueueCount]    INT           NULL,
    [RecipientName]      VARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([pk_bp_fax_queue_id] ASC),
    CONSTRAINT [tbl_batch_print_fax_queue_fk_bp_ef_status_id] FOREIGN KEY ([fk_bp_ef_status_id]) REFERENCES [dbo].[tbl_batch_print_offline_email_fax_status] ([pk_bp_ef_status_id])
);

