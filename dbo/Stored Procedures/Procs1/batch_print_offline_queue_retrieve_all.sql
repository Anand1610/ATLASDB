CREATE PROCEDURE [dbo].[batch_print_offline_queue_retrieve_all]
    @s_a_DomainId	VARCHAR(50),
	@i_a_UserId		INT
AS
BEGIN	
	SET NOCOUNT ON;

     Select 
		pk_batch_print_Id,
		Q.[DomainId],
		[printing_type],
		[case_ids],
		[node_name],
		[changed_status],
		is_upload_docs=CASE WHEN ISNULL(is_upload_docs,0) = 1 THEN 'Yes' ELSE 'No' END,
		InSequence=CASE WHEN ISNULL(InSequence,0) = 1 THEN 'Yes' ELSE 'No' END,
		[fk_configured_by_id],
		configured_date=CONVERT(VARCHAR,configured_date,101),
		is_processed,
		status=CASE WHEN ISNULL(is_processed,0) = 0 THEN 'In Progress' ELSE 'Completed' END,
		processed_date=CASE WHEN processed_date IS NULL THEN CONVERT(VARCHAR,GETDATE(),101) ELSE CONVERT(VARCHAR,processed_date,101) END,
		file_name,
		file_path,
		configuredBy=U.DisplayName,
		processed_case_ids,
		failed_case_ids,
		fk_batch_type_id,
		BT.Name AS batch_type_name,
		EnityType=(STUFF((SELECT N', ' + ET.Name FROM tbl_batch_entity_type ET WHERE ET.ID IN (SELECT items FROM dbo.STRING_SPLIT(entity_type_ids,',')) ORDER BY ET.Name FOR XML PATH(''), TYPE).value(N'.[1]', N'nvarchar(max)'), 1, 2, N'')),
		template_name,
		ISNULL((Select TOP 1 ISNULL(IsResolved,0) From tblTriggerTypeErrorLog TE Where TE.QueueSourceId = Q.pk_batch_print_Id AND ISNULL(TE.QueueType,0) = 2 AND (ISNULL(IsResolved,0) = 0 OR TE.EmailErrorMessage IS NOT NULL)), 1) AS IsErrorResolved
	 from
		[dbo].[tbl_batch_print_offline_queue] Q
		JOIN IssueTracker_Users U ON U.UserId = Q.fk_configured_by_id
		JOIN tbl_batch_type BT ON Q.fk_batch_type_id = BT.ID
		LEFT JOIN tbl_template_word TW ON TW.pk_template_id = Q.fk_template_id
	 WHERE
		Q.[DomainId]			=	@s_a_DomainId AND
		fk_configured_by_id		=	@i_a_UserId AND
		ISNULL(Q.IsDeleted,0)	=	0
	ORDER BY
		pk_batch_print_Id DESC

	SET NOCOUNT OFF;
END
