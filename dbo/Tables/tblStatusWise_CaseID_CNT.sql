CREATE TABLE [dbo].[tblStatusWise_CaseID_CNT]
(
	[DomainId] [nvarchar](512) NOT NULL,
	[Year_Opened] [int] NULL,
	[QUARTER] [varchar](2) NULL,
	[MONTH_Opened] [char](3) NULL,
	[Initial_Status] [varchar](50) NULL,
	[Status] [varchar](50) NULL,
	[CASE_COUNT] [int] NULL
) ON [PRIMARY]
