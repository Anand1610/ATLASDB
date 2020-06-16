CREATE TABLE [dbo].[tblStatusWise_Age_Details]
(
	[DomainID] [varchar](50) NULL,
	[Case_id] [nvarchar](50) NULL,
	[Case_Auto_Id] [int] NULL,
	[Provider_Id] [int] NULL,
	[Provider_Name] [nvarchar](100) NULL,
	[status] [nvarchar](100) NULL,
	[Audit_TimeStamp] [datetime] NULL,
	[N_DAYS] [int] NULL,
	[N_DAYS_PRD] [int] NULL,
	[Days_OverAll] [int] NULL,
	[N_DAYS_STS] [int] NULL,
	[MONTH_Opened] [char](3) NULL,
	[Year_Opened] [int] NULL,
	[QUARTER] [varchar](2) NULL,
	[D_RNK] [bigint] NULL,
	[RNK] [bigint] NULL,
	[U_ROWID] [int] IDENTITY(1,1) NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[U_ROWID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
