CREATE TABLE [dbo].[Case_Packet_Status] (
    [PacketStatusId]   INT           IDENTITY (1, 1) NOT NULL,
    [DomainId]         VARCHAR (50)  NULL,
    [Status]           VARCHAR (200) NULL,
    [Packet_Indicator] INT           NULL
);

