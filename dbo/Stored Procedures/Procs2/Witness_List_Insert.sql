CREATE PROCEDURE Witness_List_Insert 
	@s_a_CaseId varchar(100),
    @s_a_DomainId varchar(100),
	@i_a_WitnessId int,
	@s_a_Name varchar(500),
	@s_a_Address varchar(max),
	@s_a_City varchar(150),
	@s_a_State varchar(150),
	@s_a_Zip varchar(50),
	@s_a_Email varchar(150),
	@s_a_MobileNumber varchar(50),
	@s_a_PhoneNumber varchar(50),
	@s_a_FaxNumber varchar(50),
	@s_a_Notes varchar(max),
	@i_a_WitnesssTypeId int,
	@s_a_UserId varchar(150)
AS
BEGIN
	
	If @i_a_WitnessId =0
	BEGIN
	Insert into tblCaseWitnessList(Case_Id, DomainId, Name, Address, City, State, Zip, Email, MobileNumber, PhoneNumber, FaxNumber,
								   Notes,WitnessTypeID, CreatedBy, CreatedDate)
    Values(@s_a_CaseId, @s_a_DomainId, @s_a_Name, @s_a_Address, @s_a_City, @s_a_State, @s_a_Zip, @s_a_Email, @s_a_MobileNumber, @s_a_PhoneNumber, 
	      @s_a_FaxNumber, @s_a_Notes,@i_a_WitnesssTypeId, @s_a_UserId, GETDATE())
	
	Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
	Values(@s_a_Name+' Witness Added.', 'Workflow', 1, @s_a_CaseId, GETDATE(), @s_a_UserId, @s_a_DomainId)
	END
	ELSE
	BEGIN
	   Update tblCaseWitnessList Set 
	          Name = @s_a_Name,
	          Address = @s_a_Address,
	          City = @s_a_City,
	          State = @s_a_State,
	          Zip = @s_a_Zip,
	          Email = @s_a_Email,
	          MobileNumber = @s_a_MobileNumber,
	          PhoneNumber = @s_a_PhoneNumber,
	          FaxNumber = @s_a_FaxNumber,
	          Notes = @s_a_Notes,
			  WitnessTypeID = @i_a_WitnesssTypeId,
	          UpdatedBy = @s_a_UserId,
			  UpdatedDate = GETDATE()
			  Where WitnessId = @i_a_WitnessId and DomainId = @s_a_DomainId

	Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
	Values(@s_a_Name+' Witness Updated.', 'Workflow', 1, @s_a_CaseId, GETDATE(), @s_a_UserId, @s_a_DomainId)
	END
    
END
