CREATE TABLE [dbo].[tbl_InvestorPortfolio] (
    [Id]                   INT             IDENTITY (1, 1) NOT NULL,
    [InvestorId]           INT             NOT NULL,
    [PortfolioId]          INT             NOT NULL,
    [InvestmentAmount]     NUMERIC (18, 2) NULL,
    [InvestmentPercentage] NUMERIC (5, 2)  NULL,
    [Created_Date]         DATE            DEFAULT (getdate()) NOT NULL,
    [DomainId]             VARCHAR (50)    NULL,
    CONSTRAINT [FK_] FOREIGN KEY ([PortfolioId]) REFERENCES [dbo].[tbl_Portfolio] ([Id]),
    CONSTRAINT [FK_Investor_InvestorPortfolio] FOREIGN KEY ([InvestorId]) REFERENCES [dbo].[tbl_Investor] ([InvestorId])
);

