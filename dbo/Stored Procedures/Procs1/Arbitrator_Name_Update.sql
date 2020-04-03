CREATE PROCEDURE Arbitrator_Name_Update 
	@s_a_CaseId varchar(50),
	@s_a_DomainId varchar(50),
	@new_Arbitrator_ID int,
	@new_Arbitrator varchar(150),
	@old_Arbitrator_ID int,
	@s_a_UserId varchar(150)
AS
BEGIN
	Declare @old_Arbitrator varchar(150);
	Declare @Notes_Desc varchar(500);

	IF(@new_Arbitrator = '--Select--')
		SET @new_Arbitrator =''

	SELECT @old_Arbitrator = CONCAT(ARBITRATOR_NAME,  ' [ ', ABITRATOR_LOCATION, ' ] ') FROM TblArbitrator
    WHERE ARBITRATOR_ID = @old_Arbitrator_ID AND DomainId=@s_a_DomainId

	Update tblcase set Arbitrator_ID = @new_Arbitrator_ID where Case_Id = @s_a_CaseId and DomainId = @s_a_DomainId


	If ((@old_Arbitrator_ID is null or @old_Arbitrator_ID = 0) and @new_Arbitrator_ID != 0)
	BEGIN
		 Set @Notes_Desc = 'Judge/Arbitrator Added '+ @new_Arbitrator;
	
		Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
		Values(@Notes_Desc, 'Workflow', 1, @s_a_CaseId, GETDATE(), @s_a_UserId, @s_a_DomainId)
	END
	ELSE IF(@old_Arbitrator_ID <> @new_Arbitrator_ID)
	BEGIN
		Set @Notes_Desc = 'Judge/Arbitrator changed from '+@old_Arbitrator+' to '+ @new_Arbitrator;

		Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
		Values(@Notes_Desc, 'Workflow', 1, @s_a_CaseId, GETDATE(), @s_a_UserId, @s_a_DomainId)
	END


END
