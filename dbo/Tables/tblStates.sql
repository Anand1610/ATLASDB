CREATE TABLE [dbo].[tblStates] (
    [State_Id]   INT            IDENTITY (1, 1) NOT NULL,
    [State_Name] VARCHAR (100)  NULL,
    [State_Abr]  VARCHAR (2)    NULL,
    [DomainId]   NVARCHAR (512) DEFAULT ('h1') NOT NULL
);

