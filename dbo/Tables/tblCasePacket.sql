CREATE TABLE [dbo].[tblCasePacket] (
    [CaseId]    NVARCHAR (50)  NOT NULL,
    [Details]   VARCHAR (200)  NULL,
    [PacketID]  VARCHAR (50)   NOT NULL,
    [FF_POSTED] BIT            NULL,
    [DomainId]  NVARCHAR (100) NULL
);

