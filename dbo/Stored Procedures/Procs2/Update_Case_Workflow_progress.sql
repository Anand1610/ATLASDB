-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE Update_Case_Workflow_progress 
	@i_a_Queue_Id int,
	@s_a_DomainId varchar(50)='amt',
	@b_a_in_progress bit
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from 1
	update tblCaseWorkflowTriggerQueue set InProgress= @b_a_in_progress
	where Id= @i_a_Queue_Id and DomainId= @s_a_DomainId
END
