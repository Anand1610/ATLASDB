CREATE TABLE [dbo].[tblPomCase] (
    [pom_id]             INT            NOT NULL,
    [case_id]            NVARCHAR (50)  NOT NULL,
    [DomainId]           NVARCHAR (512) DEFAULT ('h1') NOT NULL,
    [POM_FileName]       VARCHAR (500)  NULL,
    [POM_PacketFileName] VARCHAR (200)  NULL,
    [POMType]            VARCHAR (50)   NULL,
    [BasePathId]         INT            NULL
);

