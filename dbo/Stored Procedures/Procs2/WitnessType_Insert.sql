CREATE PROCEDURE WitnessType_Insert
    @i_a_WitnessTypeID int = 0,
	@s_a_WitnessType varchar(250),
	@s_a_Description varchar(500),
	@s_a_DomainId varchar(50),
	@s_a_UserId varchar(150)
AS
BEGIN
	SET NOCOUNT ON;

	IF @i_a_WitnessTypeID = 0 and EXISTS(Select * from tblWitnessType Where WitnessType = @s_a_WitnessType and DomainId = @s_a_DomainId)
		BEGIN
			Select 'Witness type already exists.'
		END
	ELSE IF  @i_a_WitnessTypeID = 0 
		BEGIN
			Insert into tblWitnessType(WitnessType, Description, DomainId, created_by_user, created_date)
			Values (@s_a_WitnessType, @s_a_Description, @s_a_DomainId,@s_a_UserId,GETDATE());

			Select 'Witness type saved successfully.'
	END
	ELSE IF @i_a_WitnessTypeID != 0 and EXISTS(Select * from tblWitnessType Where WitnessTypeID != @i_a_WitnessTypeID and WitnessType = @s_a_WitnessType and DomainId = @s_a_DomainId) 
		BEGIN
			Select 'Witness type already exists.'
		END
	ELSE
		BEGIN
		   UPDATE tblWitnessType SET
				  WitnessType = @s_a_WitnessType,
				  Description = @s_a_Description,
				  modified_by_user = @s_a_UserId,
				  modified_date = GETDATE()
		   Where WitnessTypeID = @i_a_WitnessTypeID and DomainId = @s_a_DomainId

		   Select 'Witness type updated successfully.'

		END
   
END
