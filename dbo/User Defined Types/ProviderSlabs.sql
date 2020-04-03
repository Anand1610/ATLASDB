CREATE TYPE [dbo].[ProviderSlabs] AS TABLE (
    [ProviderId] INT           NULL,
    [SlabFrom]   FLOAT (53)    DEFAULT ((0.00)) NULL,
    [SlabTo]     FLOAT (53)    DEFAULT ((0.00)) NULL,
    [VendorFee]  FLOAT (53)    DEFAULT ((0.00)) NULL,
    [AmountType] VARCHAR (200) NULL);

