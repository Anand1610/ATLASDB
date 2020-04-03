CREATE PROCEDURE WitnessType_Delete
	@i_a_WitnessTypeID int,
	@s_a_DomainId varchar(50)
AS
BEGIN
		IF EXISTS(Select * from tblCaseWitnessList Where WitnessTypeID = @i_a_WitnessTypeID and DomainId = @s_a_DomainId)
			BEGIN
				Select 'Witness type can not be deleted. Reference exists in case witness list.'
			END
		ELSE
			BEGIN
			     Delete from tblWitnessType Where WitnessTypeID = @i_a_WitnessTypeID and DomainId = @s_a_DomainId
			     
				 Select 'Witness type deleted successfully.'
			END
END
