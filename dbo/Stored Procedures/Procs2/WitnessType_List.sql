CREATE PROCEDURE WitnessType_List	
	@s_a_DomainId varchar(50)
AS
BEGIN
	SET NOCOUNT ON;
	Select  0 as WitnessTypeId, '--Select--' as WitnessType
	Union
	Select WitnessTypeId, WitnessType from tblWitnessType Where DomainId = @s_a_DomainId 
	ORDER BY WitnessType ASC
END
