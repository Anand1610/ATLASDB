CREATE FUNCTION [dbo].[f_GetTreatmentDOS](@Case_id varchar(50))  
RETURNS VARCHAR(max)  
AS  
BEGIN  
	DECLARE @s_l_treatment VARCHAR(max)  

	Declare @Dos varchar(8000)
	DECLARE CUR_Notes CURSOR
	FOR select Convert(Varchar(10),DateOfService_Start,101)+ ' - ' + Convert(Varchar(10),DateOfService_End,101) 
	from tbltreatment where case_id=@Case_id 
 set @s_l_treatment=''
	OPEN CUR_Notes
	FETCH CUR_Notes INTO @Dos
	WHILE @@FETCH_STATUS = 0
	BEGIN
	
		set @s_l_treatment = @s_l_treatment + @Dos +','
		FETCH CUR_Notes INTO @Dos
	END
	CLOSE CUR_Notes
	DEALLOCATE CUR_Notes
	RETURN @s_l_treatment
END
