CREATE TABLE [dbo].[tbldates_lookup] (
    [DateKey]        INT            NOT NULL,
    [DateFull]       DATETIME       NULL,
    [CharacterDate]  VARCHAR (10)   NULL,
    [FullYear]       CHAR (4)       NULL,
    [QuarterNumber]  TINYINT        NULL,
    [WeekNumber]     TINYINT        NULL,
    [WeekDayName]    VARCHAR (10)   NULL,
    [MonthDay]       TINYINT        NULL,
    [MonthName]      VARCHAR (12)   NULL,
    [YearDay]        SMALLINT       NULL,
    [DateDefinition] VARCHAR (100)  NULL,
    [WeekDay]        TINYINT        NULL,
    [MonthNumber]    TINYINT        NULL,
    [Holiday]        BIT            CONSTRAINT [DF_tbldates_lookup_Holiday] DEFAULT ((0)) NULL,
    [DomainId]       NVARCHAR (512) DEFAULT ('h1') NOT NULL,
    CONSTRAINT [PK__tbldates_lookup__1D5142F3] PRIMARY KEY CLUSTERED ([DateKey] ASC)
);

