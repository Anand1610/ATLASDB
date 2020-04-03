CREATE TABLE [dbo].[tbl_template_word_offline_queue] (
    [pk_offline_queue_id] INT           IDENTITY (1, 1) NOT NULL,
    [domain_id]           VARCHAR (100) NULL,
    [fk_template_id]      INT           NULL,
    [case_ids]            VARCHAR (MAX) NULL,
    [save_as]             CHAR (5)      NULL,
    [NodeName]            VARCHAR (MAX) NULL,
    [is_upload_docs]      BIT           NULL,
    [fk_configured_by_id] INT           NULL,
    [configured_date]     DATETIME      NULL,
    [is_processed]        BIT           NULL,
    [processed_date]      DATETIME      NULL,
    [file_name]           VARCHAR (MAX) NULL,
    [file_path]           VARCHAR (MAX) NULL,
    [changed_status]      VARCHAR (100) NULL,
    PRIMARY KEY CLUSTERED ([pk_offline_queue_id] ASC),
    CONSTRAINT [tbl_template_word_offline_queue_fk_configured_by_id] FOREIGN KEY ([fk_configured_by_id]) REFERENCES [dbo].[IssueTracker_Users] ([UserId]),
    CONSTRAINT [tbl_template_word_offline_queue_fk_template_id] FOREIGN KEY ([fk_template_id]) REFERENCES [dbo].[tbl_template_word] ([pk_template_id])
);

