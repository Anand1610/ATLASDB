--===========================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE Case_Date_Motion_Mapping_Delete
	@s_a_Case_Id varchar(50),
	@s_a_DomainId varchar(50),
	@s_a_UserId varchar(150),
	@i_a_Id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    
	Declare @Notes_Desc varchar(500);

	Select @Notes_Desc = Name from tblMotionType 
	Where MotionTypeId = (Select MotionTypeId From tblCaseDateMotionMapping where Id = @i_a_Id and DomainId = @s_a_DomainId)

	Set @Notes_Desc = @Notes_Desc + ' Deleted.';

	Delete from tblCaseDateMotionMapping where Id = @i_a_Id and DomainId = @s_a_DomainId

	Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
	Values(@Notes_Desc, 'Workflow', 1, @s_a_Case_Id, GETDATE(), @s_a_UserId, @s_a_DomainId)

	Update tblCaseWorkflowTriggerQueue set IsDeleted = 1 where MotionMappingId = @i_a_Id and DomainId = @s_a_DomainId

END
