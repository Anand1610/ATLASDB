CREATE FUNCTION [dbo].[fncISAOB](@Case_id varchar(50))
returns varchar(10) as
BEGIN
Declare @OutputString varchar(10)
Declare @AOBCount int
	set @AOBCount = (select count(*) from TBLIMAGES  where DOCUMENTID ='11' and CASE_ID = @Case_id)
	if(@AOBCount =0)
		set @OutputString = 'No'
	else
		set @OutputString = 'Yes'
 
 RETURN @OutputString 
END
