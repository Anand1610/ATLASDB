CREATE TABLE [dbo].[tbl_Case_Status_Hierarchy] (
    [DomainID]        VARCHAR (50)   NULL,
    [status]          NVARCHAR (100) NULL,
    [Case_id]         NVARCHAR (50)  NULL,
    [Case_Auto_Id]    INT            NULL,
    [Audit_Command]   VARCHAR (20)   NULL,
    [Audit_TimeStamp] DATETIME       NULL,
    [USER_NAME]       NVARCHAR (100) NULL
);

