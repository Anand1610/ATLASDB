CREATE FUNCTION [dbo].[fnc_Case_Bill_Count] (@case_id varchar(50))
returns int
as

begin

declare @value int
select  @value=COUNT(treatment_id) from tblTreatment where Case_Id =@case_id

return @value

end
