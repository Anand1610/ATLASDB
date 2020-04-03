CREATE TABLE [dbo].[tblCaseDesk] (
    [Case_Id]     VARCHAR (50)   NULL,
    [Desk_Id]     INT            NULL,
    [Desk_Reason] NVARCHAR (500) NULL,
    [DomainId]    NVARCHAR (512) DEFAULT ('h1') NOT NULL
);

