-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Complaint_Print_Date_Update]
	@s_a_Case_Id varchar(50),
	@d_a_comp_Print_Date datetime,
	@s_a_DomainId varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	--Update tblCase_Date_Details
	--set Complaint_Print_Date = @d_a_comp_Print_Date
 --   where Case_Id = @s_a_Case_Id and DomainId = @s_a_DomainId

	--Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
	--Values('Complaint Print Date Added : '+Convert(varchar(20),@d_a_comp_Print_Date,101), 'Workflow', 1, @s_a_Case_Id, GETDATE(), 'admin', @s_a_DomainId)

	--Declare @Old_Status varchar(150);
	--Select @Old_Status = Status from tblcase(NOLOCK) where Case_Id = @s_a_Case_Id and DomainId = @s_a_DomainId

	--IF lower(@Old_Status) !='complaint printed' and  lower(@s_a_DomainId) = 'amt'
	--BEGIN
	--	Update tblcase set Status = 'Complaint Printed' where Case_Id = @s_a_Case_Id and DomainId = @s_a_DomainId

	--	exec LCJ_AddNotes @DomainId=@s_a_DomainId, @case_id=@s_a_Case_Id,@Notes_Type='Workflow',@Ndesc = 'Status Changed To : Complaint Printed', @user_Id='admin', @ApplyToGroup = 0  
	--END

END
