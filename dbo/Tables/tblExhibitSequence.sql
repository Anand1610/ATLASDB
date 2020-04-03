CREATE TABLE [dbo].[tblExhibitSequence] (
    [Case_Id]    NVARCHAR (50)  NOT NULL,
    [Exhibit_Id] INT            NOT NULL,
    [Sequence]   INT            NOT NULL,
    [DomainId]   NVARCHAR (512) DEFAULT ('h1') NOT NULL
);

