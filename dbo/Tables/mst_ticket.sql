﻿CREATE TABLE [dbo].[mst_ticket] (
    [bg_ticket_id]          BIGINT         IDENTITY (1, 1) NOT NULL,
    [sz_ticket_number]      NVARCHAR (40)  NULL,
    [sz_company_id]         NVARCHAR (50)  NOT NULL,
    [sz_raised_by]          NVARCHAR (255) NOT NULL,
    [dt_raised_on]          DATETIME       DEFAULT (getdate()) NOT NULL,
    [sz_subject]            NVARCHAR (255) NOT NULL,
    [sz_description]        NVARCHAR (MAX) NOT NULL,
    [sz_type]               NVARCHAR (255) NOT NULL,
    [sz_sub_type]           NVARCHAR (255) NULL,
    [dt_last_activity]      DATETIME       NULL,
    [sz_callback_phone]     NVARCHAR (255) NULL,
    [i_status_id]           INT            NULL,
    [sz_default_mail]       NVARCHAR (255) NULL,
    [sz_mail_cc]            NVARCHAR (MAX) NULL,
    [i_priority_id]         INT            NULL,
    [bt_associate_account]  BIT            NULL,
    [sz_associate_account]  NVARCHAR (20)  NULL,
    [dt_estimated_delivery] DATETIME       NULL,
    [bt_estimated_delivery] BIT            NULL,
    [i_sub_status_id]       INT            NULL,
    [i_note_count]          INT            NULL,
    [sz_assigned_to]        NVARCHAR (20)  NULL,
    PRIMARY KEY CLUSTERED ([bg_ticket_id] ASC) WITH (FILLFACTOR = 80),
    FOREIGN KEY ([i_priority_id]) REFERENCES [dbo].[mst_ticket_priority] ([i_priority_id]),
    FOREIGN KEY ([i_status_id]) REFERENCES [dbo].[mst_ticket_status] ([i_status_id]),
    UNIQUE NONCLUSTERED ([sz_ticket_number] ASC) WITH (FILLFACTOR = 80)
);

