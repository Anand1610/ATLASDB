CREATE TABLE [dbo].[tbl_verification_response_fax_queue] (
    [pk_vr_fax_queue_id]     INT           IDENTITY (1, 1) NOT NULL,
    [DomainID]               VARCHAR (50)  NOT NULL,
    [I_VERIFICATION_ID]      INT           NOT NULL,
    [FaxNumber]              VARCHAR (50)  NOT NULL,
    [SentByUser]             VARCHAR (MAX) NOT NULL,
    [SentOn]                 DATETIME      NOT NULL,
    [isDeleted]              BIT           NULL,
    [IsAddedtoQueue]         BIT           NULL,
    [AddedtoQueueDate]       DATETIME      NULL,
    [CoverPageText]          VARCHAR (MAX) NULL,
    [AddToQueueCount]        INT           NULL,
    [pk_vr_fax_queue_id_old] INT           NULL,
    [inprogress_send]        BIT           NULL,
    [inprogress_download]    BIT           NULL,
    PRIMARY KEY CLUSTERED ([pk_vr_fax_queue_id] ASC)
);

