CREATE TABLE [dbo].[tbl_display_column_Case_Search](
	[pk_display_column_id] [int] IDENTITY(1,1) NOT NULL,
	[display_name] [nvarchar](100) NOT NULL,
	[table_column] [nvarchar](100) NOT NULL,
	[is_default] [bit] NULL,
	[column_order] [int] NULL,
	[CompanyType] [varchar](200) NULL,
 CONSTRAINT [PK_tbl_display_column_Case_Search] PRIMARY KEY CLUSTERED 
(
	[pk_display_column_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]