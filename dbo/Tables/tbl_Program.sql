CREATE TABLE [dbo].[tbl_Program] (
    [Id]                    INT             IDENTITY (1, 1) NOT NULL,
    [Advance_Rate]          DECIMAL (18, 2) NULL,
    [Buyout]                BIT             NULL,
    [Fixed_Fee_Rate]        DECIMAL (18, 2) NULL,
    [Fixed_Fee_Rate_Time]   INT             NULL,
    [Period_Fee_Rate]       DECIMAL (18, 2) NULL,
    [Period_Fee_Time_Frame] INT             NULL,
    [Created_Date]          DATE            NULL,
    [DomainId]              NVARCHAR (50)   NOT NULL,
    [Name]                  VARCHAR (50)    NOT NULL,
    PRIMARY KEY CLUSTERED ([Id] ASC)
);

