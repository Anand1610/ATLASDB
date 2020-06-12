CREATE TABLE [dbo].[tblMotionType] (
    [MotionTypeId] INT            IDENTITY (1, 1) NOT NULL,
    [Name]         NVARCHAR (100) NULL,
    [DomainId]     NVARCHAR (100) NULL,
    [created_by_user] VARCHAR(510) NULL, 
    [created_date] DATETIME NULL, 
    [modified_by_user] VARCHAR(510) NULL, 
    [modified_date] DATETIME NULL, 
    CONSTRAINT [PK_tblMotionType] PRIMARY KEY CLUSTERED ([MotionTypeId] ASC)
);

