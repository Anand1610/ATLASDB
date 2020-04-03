CREATE TYPE [dbo].[BillDocumentDetailsDetails] AS TABLE (
    [FileName]     VARCHAR (200)  NULL,
    [Path]         VARCHAR (2000) NULL,
    [NodeType]     VARCHAR (100)  NULL,
    [BasePathId]   INT            NULL,
    [BaseFilePath] VARCHAR (200)  NULL,
    [BasePathType] VARCHAR (10)   NULL);

