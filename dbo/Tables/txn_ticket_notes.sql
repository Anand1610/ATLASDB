CREATE TABLE [dbo].[txn_ticket_notes] (
    [i_id]            INT            IDENTITY (1, 1) NOT NULL,
    [sz_user_name]    NVARCHAR (20)  NULL,
    [bg_ticket_id]    NVARCHAR (20)  NULL,
    [sz_comment]      NVARCHAR (MAX) NULL,
    [dt_created_date] DATETIME       NULL
);

