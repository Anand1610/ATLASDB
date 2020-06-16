CREATE TABLE [dbo].[tblCaseID_Age_Details]
(
	[DomainID] [varchar](50) NULL,
	[Case_id] [nvarchar](50) NULL,
	[Case_Auto_Id] [int] NULL,
	[Provider_Id] [int] NULL,
	[Provider_Name] [nvarchar](100) NULL,
	[Audit_TimeStamp] [datetime] NULL,
	[AVG_AGE] [int] NULL,
	[AVG_AGE_PRD] [int] NULL,
	[AVG_AGE_STS] [int] NULL,
	[MONTH_Opened] [char](3) NULL,
	[Year_Opened] [int] NULL,
	[D_RNK] [bigint] NULL,
	[RNK] [bigint] NULL,
	[QUARTER] [varchar](2) NULL
) ON [PRIMARY]
