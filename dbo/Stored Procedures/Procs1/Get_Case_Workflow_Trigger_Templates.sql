--Get_Case_Workflow_Trigger_Queue 'localhost'
CREATE PROCEDURE [dbo].[Get_Case_Workflow_Trigger_Templates]
    @i_a_TriggerTypeId int,
	@s_a_DomainId varchar(50)
AS
BEGIN	
	SET NOCOUNT ON;
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED
	
	Select   template_name
			,template_file_name
			,template_path
			,template_tag_array
			,TemplateId
			,ISNULL(TW.BasePathId,0) AS BasePathId
			from tblTriggerTemplate TT INNER JOIN tbl_template_word TW ON TW.pk_template_id = TT.TemplateId
			Where TriggerTypeId = @i_a_TriggerTypeId and TT.DomainId = @s_a_DomainId

END
