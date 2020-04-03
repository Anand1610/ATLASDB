CREATE PROCEDURE [dbo].[Get_TriggerType_ErrorLog]
	@s_a_DomainId varchar(250),
	@i_a_QueueType int,
	@i_a_QueueSourceId int
AS
BEGIN
	
	SET NOCOUNT ON;
	
	Select TE.QueueSourceId, TE.AutoID, TE.CaseId, TT.Name As PrintType, 
	(SUBSTRING(ISNULL(STUFF((SELECT COALESCE(isnull(template_name,'')+', ',' - ')
	FROM tblTriggerTemplate TP INNER JOIN tbl_template_word W ON W.pk_template_id = TP.TemplateId Where TP.TriggerTypeId = TT.Id
				for xml path('')),1,0,''),','),1,(LEN(ISNULL(STUFF(	(
	SELECT COALESCE(isnull(template_name,'')+', ',' - ')
	FROM tblTriggerTemplate TP INNER JOIN tbl_template_word W ON W.pk_template_id = TP.TemplateId Where TP.TriggerTypeId = TT.Id 
				for xml path('')),1,0,''),',')))-1)) AS template_name
	, TE.UnknownTags, TE.ReplacementValueMissingTags, 'Workflow' AS QueueType 
	,TE.EmailErrorMessage AS EmailError
	from tblTriggerTypeErrorLog TE 
	INNER JOIN tblCaseWorkflowTriggerQueue WQ ON WQ.Id = TE.QueueSourceId AND ISNULL(TE.QueueType,0) = 1
	INNER JOIN tblTriggerType TT ON TT.Id = WQ.TriggerTypeId
	where ISNULL(IsResolved,0)=0 and TE.DomainId = @s_a_DomainId and (ISNULL(@i_a_QueueType,0) = 0 or TE.QueueType = @i_a_QueueType)
	and (ISNULL(@i_a_QueueSourceId,0) = 0 OR TE.QueueSourceId = @i_a_QueueSourceId)
	UNION
	Select TE.QueueSourceId, TE.AutoID, TE.CaseId, Q.printing_type As PrintType, W.template_name AS template_name, TE.UnknownTags, TE.ReplacementValueMissingTags, iif(BT.Name='Email','Bulk Email',BT.Name) AS QueueType,TE.EmailErrorMessage AS EmailError
	from tblTriggerTypeErrorLog TE 
	INNER JOIN tbl_batch_print_offline_queue Q ON Q.pk_batch_print_Id = TE.QueueSourceId AND ISNULL(TE.QueueType,0) = 2
	LEFT JOIN tbl_template_word W ON W.pk_template_id = Q.fk_template_id
	LEFT JOIN tbl_batch_type BT ON Q.fk_batch_type_id = BT.ID  
	where ISNULL(IsResolved,0)=0 and ISNULL(Q.IsDeleted, 0) = 0 and TE.DomainId = @s_a_DomainId  and ((ISNULL(@i_a_QueueType,0) = 0 or TE.QueueType = @i_a_QueueType and lower(BT.Name)!='email') or (ISNULL(@i_a_QueueType,0) = 4 AND lower(BT.Name)='email'))
	and (ISNULL(@i_a_QueueSourceId,0) = 0 OR TE.QueueSourceId = @i_a_QueueSourceId)
	UNION
	Select TE.QueueSourceId, TE.AutoID, TE.CaseId, '' As PrintType, W.template_name AS template_name, TE.UnknownTags, TE.ReplacementValueMissingTags, 'Bulk Template' AS QueueType,TE.EmailErrorMessage AS EmailError
	from tblTriggerTypeErrorLog TE 
	INNER JOIN tbl_template_word_offline_queue Q ON Q.pk_offline_queue_id = TE.QueueSourceId AND ISNULL(TE.QueueType,0) = 3
	LEFT JOIN tbl_template_word W ON W.pk_template_id = Q.fk_template_id
	where ISNULL(IsResolved,0)=0 and TE.DomainId = @s_a_DomainId  and (ISNULL(@i_a_QueueType,0) = 0 or TE.QueueType = @i_a_QueueType)
	and (ISNULL(@i_a_QueueSourceId,0) = 0 OR TE.QueueSourceId = @i_a_QueueSourceId)
	order by QueueType, TE.QueueSourceId, TE.AutoID

END