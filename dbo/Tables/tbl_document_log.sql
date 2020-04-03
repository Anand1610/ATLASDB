CREATE TABLE [dbo].[tbl_document_log] (
    [pk_log_id]     INT            IDENTITY (1, 1) NOT NULL,
    [fk_user_id]    INT            NOT NULL,
    [fk_node_id]    INT            NOT NULL,
    [document_name] VARCHAR (MAX)  NULL,
    [operation]     VARCHAR (100)  NOT NULL,
    [log_date_time] DATETIME       NOT NULL,
    [log_action]    VARCHAR (MAX)  NULL,
    [pk_case_id]    NVARCHAR (50)  NULL,
    [DomainId]      NVARCHAR (512) DEFAULT ('h1') NOT NULL,
    [pk_log_id_old] INT            NULL,
    [FilePath]      VARCHAR (255)  NULL
);

