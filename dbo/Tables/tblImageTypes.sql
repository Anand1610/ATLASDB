CREATE TABLE [dbo].[tblImageTypes] (
    [Image_Id]   INT            IDENTITY (1, 1) NOT NULL,
    [Image_Type] NVARCHAR (100) NULL,
    [DomainId]   NVARCHAR (512) DEFAULT ('h1') NOT NULL
);

