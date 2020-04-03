CREATE TABLE [dbo].[tblProvListBoxDetails] (
    [Auto_id]            INT            IDENTITY (1, 1) NOT NULL,
    [BatchNumber]        NVARCHAR (50)  NULL,
    [DateReceived]       DATETIME       NULL,
    [ProcessDate]        DATETIME       NULL,
    [SpecialNote]        NVARCHAR (500) NULL,
    [SpecialInstruction] NVARCHAR (500) NULL,
    [No_Of_Cases]        NVARCHAR (500) NULL,
    [Created_By]         NVARCHAR (50)  NULL,
    [Predestinated_Path] NVARCHAR (100) NULL,
    [DomainId]           NVARCHAR (512) DEFAULT ('h1') NOT NULL
);

