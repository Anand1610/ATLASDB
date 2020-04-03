CREATE TABLE [dbo].[TypeOfBatchPrint] (
    [Type_Id]       INT           IDENTITY (1, 1) NOT NULL,
    [Printing_Type] VARCHAR (150) NULL,
    [Domain_Id]     VARCHAR (50)  NULL,
    CONSTRAINT [PK_TypeOfBatchPrint] PRIMARY KEY CLUSTERED ([Type_Id] ASC)
);

