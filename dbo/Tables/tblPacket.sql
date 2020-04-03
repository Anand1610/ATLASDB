CREATE TABLE [dbo].[tblPacket] (
    [Packet_Auto_ID] INT           IDENTITY (1, 1) NOT NULL,
    [PacketID]       VARCHAR (50)  NULL,
    [PacketCaption]  VARCHAR (MAX) NULL,
    [FK_CaseType_Id] INT           NULL,
    [DomainId]       VARCHAR (50)  NULL,
    CONSTRAINT [PK_tblPacket] PRIMARY KEY CLUSTERED ([Packet_Auto_ID] ASC)
);

