CREATE TABLE [dbo].[tbl_ImageTag_Modifiedby] (
    [s_no]        INT            IDENTITY (1, 1) NOT NULL,
    [ImageId]     BIGINT         NOT NULL,
    [modified_by] INT            NOT NULL,
    [DomainId]    NVARCHAR (512) DEFAULT ('h1') NOT NULL
);

