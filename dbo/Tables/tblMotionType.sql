CREATE TABLE [dbo].[tblMotionType] (
    [MotionTypeId] INT            IDENTITY (1, 1) NOT NULL,
    [Name]         NVARCHAR (100) NULL,
    [DomainId]     NVARCHAR (100) NULL,
    CONSTRAINT [PK_tblMotionType] PRIMARY KEY CLUSTERED ([MotionTypeId] ASC)
);

