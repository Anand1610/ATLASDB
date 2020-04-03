CREATE TABLE [dbo].[tbl_domain_master] (
    [pk_domain_id]   INT           IDENTITY (1, 1) NOT NULL,
    [domain_name]    VARCHAR (MAX) NOT NULL,
    [appname]        VARCHAR (MAX) NOT NULL,
    [webservice_url] VARCHAR (MAX) NULL,
    [remarks]        VARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([pk_domain_id] ASC)
);

