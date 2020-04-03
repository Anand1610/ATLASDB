-- =============================================
-- Author:		srosenthal
-- ALTER date: 
-- Description:	
-- =============================================
CREATE FUNCTION [dbo].[FUNC_Case_Provider_Note] (@case_id varchar(50))

RETURNS varchar(max)
AS
begin
Declare @note varchar(max)

	select   @note= Notes_Desc from tblnotes 
	where Case_Id=@case_id and Notes_Type='provider'
	order by Notes_ID desc
	

return @note


end
