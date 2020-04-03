CREATE TABLE [dbo].[tbl_template_column] (
    [s_no]          INT           IDENTITY (1, 1) NOT NULL,
    [column_name]   VARCHAR (MAX) NOT NULL,
    [status]        INT           NOT NULL,
    [friendly_name] VARCHAR (MAX) NULL
);

