CREATE TABLE [dbo].[tbl_template_word] (
    [pk_template_id]     INT            IDENTITY (1, 1) NOT NULL,
    [template_name]      VARCHAR (200)  NOT NULL,
    [remarks]            VARCHAR (500)  NULL,
    [template_file_name] VARCHAR (500)  NULL,
    [template_path]      VARCHAR (1000) NULL,
    [fk_default_node_id] INT            NULL,
    [DomainId]           VARCHAR (100)  NOT NULL,
    [created_by_user]    NVARCHAR (255) CONSTRAINT [DF__tbl_templ__creat__0EEE1503] DEFAULT ('admin') NOT NULL,
    [created_date]       DATETIME       NULL,
    [modified_by_user]   NVARCHAR (255) NULL,
    [modified_date]      DATETIME       NULL,
    [template_tag_array] VARCHAR (MAX)  NULL,
    [Status_Id]          INT            NULL,
    [BasePathId]         INT            NULL,
    [html_name]          VARCHAR (256)  NULL,
    [Batch_Template_bit] BIT            DEFAULT ((0)) NOT NULL,
    PRIMARY KEY CLUSTERED ([pk_template_id] ASC)
);

