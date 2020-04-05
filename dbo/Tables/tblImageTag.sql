CREATE TABLE [dbo].[tblImageTag] (
    [ImageID]      BIGINT         NOT NULL,
    [TagID]        BIGINT         NOT NULL,
    [LoginID]      NCHAR (20)     NULL,
    [DateInserted] DATETIME       NULL,
    [DateModified] DATETIME       NULL,
    [DateScanned]  DATETIME       NULL,
    [DomainId]     NVARCHAR (512) DEFAULT ('h1') NOT NULL, 
    [IsDeleted] BIT NULL DEFAULT 0
);


GO
CREATE CLUSTERED INDEX [CIDX_tblImageTag]
    ON [dbo].[tblImageTag]([ImageID] ASC, [TagID] ASC);


GO
CREATE NONCLUSTERED INDEX [IDX_tblImageTag_DomainId]
    ON [dbo].[tblImageTag]([DomainId] ASC, [ImageID] ASC, [TagID] ASC)
    INCLUDE([LoginID], [DateScanned]);


GO
CREATE NONCLUSTERED INDEX [idx_TagID]
    ON [dbo].[tblImageTag]([TagID] ASC)
    INCLUDE([ImageID]);

