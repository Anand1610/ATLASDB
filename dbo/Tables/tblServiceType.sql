CREATE TABLE [dbo].[tblServiceType] (
    [ServiceType_ID]     INT            IDENTITY (1, 1) NOT NULL,
    [ServiceType]        VARCHAR (25)   NULL,
    [ServiceDesc]        VARCHAR (50)   NULL,
    [DomainId]           NVARCHAR (512) CONSTRAINT [DF__tblServic__Domai__038683F8] DEFAULT ('h1') NOT NULL,
    [created_by_user]    VARCHAR (255)  NULL,
    [created_date]       DATETIME       NULL,
    [modified_by_user]   VARCHAR (255)  NULL,
    [modified_date]      DATETIME       NULL,
    [ServiceType_ID_Old] INT            NULL
);

