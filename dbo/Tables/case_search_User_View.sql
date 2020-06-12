CREATE TABLE [dbo].[case_search_User_View]
(
	[pk_search_query_id] [int] IDENTITY(1,1) NOT NULL,
	[domainid] [varchar](100) NULL,
	[column_value] [varchar](max) NULL,
	[column_name] [varchar](max) NULL,
	[query_name] [nvarchar](250) NULL,
	[userid] [int] NULL,
	[modified_userid] [int] NULL,
	[create_date] [datetime] NULL,
	[modified_date] [datetime] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]

