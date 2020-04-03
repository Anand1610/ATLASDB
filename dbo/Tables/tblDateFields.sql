CREATE TABLE [dbo].[tblDateFields] (
    [date_auto_id]    INT            IDENTITY (1, 1) NOT NULL,
    [Date_Field_Name] NVARCHAR (200) NULL,
    [Date_Field_Desc] NVARCHAR (200) NULL,
    [DomainId]        VARCHAR (50)   NULL,
    [TableFrom]       VARCHAR (100)  NULL
);

