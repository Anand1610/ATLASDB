CREATE TABLE [dbo].[tblProvider_Slabs] (
    [ID]         INT           IDENTITY (1, 1) NOT NULL,
    [ProviderId] INT           NULL,
    [SlabFrom]   FLOAT (53)    DEFAULT ((0.00)) NULL,
    [SlabTo]     FLOAT (53)    DEFAULT ((0.00)) NULL,
    [VendorFee]  FLOAT (53)    DEFAULT ((0.00)) NULL,
    [AmountType] VARCHAR (200) NULL,
    PRIMARY KEY CLUSTERED ([ID] ASC)
);

