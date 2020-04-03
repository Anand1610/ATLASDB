


CREATE PROCEDURE [dbo].[F_Template_Column_Name_And_Case_Data] -- F_Template_Column_Name_And_Case_Data 'TEST2','0','TEST217-12007'
	@DomainId varchar(50),
	@i_a_type int,
	@s_a_case_id varchar(100)=null
	
AS  
BEGIN	
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	

	if(@i_a_type = 1)
	BEGIN
		SELECT  UPPER(COLUMN_NAME) AS COLUMN_NAME FROM MST_TEMPLATES_COLUMN
	END
	ELSE
	BEGIN	
		EXEC 	[dbo].[F_Template_Case_Data] @DomainId,@i_a_type,@s_a_case_id 
	END

		--SELECT TOP 500 UPPER(COLUMN_NAME) COLUMN_NAME FROM INFORMATION_SCHEMA.Columns where TABLE_NAME = 'LCJ_VW_CaseSearchDetails_RTF'
END



