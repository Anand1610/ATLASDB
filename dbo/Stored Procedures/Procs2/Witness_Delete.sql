CREATE PROCEDURE Witness_Delete
     @i_a_WitnessId int,
	 @s_a_CaseId varchar(50),
	 @s_a_DomainId varchar(50),
	 @s_a_UserId varchar(150)
AS
BEGIN

	Declare @Notes_Desc varchar(500);
	Select @Notes_Desc = Name from tblCaseWitnessList  where WitnessId = @i_a_WitnessId and DomainId = @s_a_DomainId
	Set @Notes_Desc =  @Notes_Desc + ' Witenss Deleted.';

	Delete from tblCaseWitnessList where WitnessId = @i_a_WitnessId and DomainId = @s_a_DomainId

	Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
	Values(@Notes_Desc, 'Workflow', 1, @s_a_CaseId, GETDATE(), @s_a_UserId, @s_a_DomainId)

END
