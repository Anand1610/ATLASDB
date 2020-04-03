CREATE PROCEDURE [dbo].[SP_GET_COLUMN_NAME_AND_CASE_DATA] --[SP_GET_COLUMN_NAME_AND_CASE_DATA] '1'
	@Type int,
	@Case_ID varchar(100)=null
	
AS  
BEGIN	

	if(@Type = 0)
		select top 1 *  from  LCJ_VW_CaseSearchDetails_RTF where case_id = @Case_ID
	else 
		SELECT UPPER(COLUMN_NAME) COLUMN_NAME FROM INFORMATION_SCHEMA.Columns where TABLE_NAME = 'LCJ_VW_CaseSearchDetails_RTF'
END

