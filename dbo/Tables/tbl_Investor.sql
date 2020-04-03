CREATE TABLE [dbo].[tbl_Investor] (
    [InvestorId]   INT           IDENTITY (1, 1) NOT NULL,
    [UserId]       INT           NOT NULL,
    [Name]         VARCHAR (50)  NOT NULL,
    [Email]        VARCHAR (250) NOT NULL,
    [ContactNo]    VARCHAR (50)  NULL,
    [Address]      VARCHAR (250) NULL,
    [City]         VARCHAR (50)  NULL,
    [State]        VARCHAR (50)  NULL,
    [Country]      VARCHAR (50)  NULL,
    [Zip]          INT           NOT NULL,
    [Created_Date] DATE          DEFAULT (getdate()) NOT NULL,
    [DomainId]     VARCHAR (50)  NULL,
    PRIMARY KEY CLUSTERED ([InvestorId] ASC),
    CONSTRAINT [FK_UserInvestor] FOREIGN KEY ([UserId]) REFERENCES [dbo].[IssueTracker_Users] ([UserId])
);

