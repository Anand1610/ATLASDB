CREATE PROCEDURE [dbo].[batch_print_offline_email_failed_retrieve]
AS
BEGIN	
	SET NOCOUNT ON;
	IF(ISNULL((SELECT COUNT(*) FROM tbl_batch_print_offline_email_fax_status WHERE ISNULL(IsDeleted,0) = 0 AND ISNULL(in_progress,0) = 1 AND ISNULL(emailStatus,'') = 'Failed' AND ISNULL(ResendCount,0) < 4),0) < 2)
	BEGIN
			 SELECT TOP 1
				pk_batch_print_Id,
				Q.[DomainId],
				[printing_type],
				[case_ids],
				[node_name],
				[changed_status],
				is_upload_docs,
				[fk_configured_by_id],
				configured_date,
				is_processed,
				processed_date,
				file_name,
				file_path,
				configuredBy=U.DisplayName,
				Email,
				fk_batch_type_id,
				fk_template_id,
				entity_type_ids,
				BT.Name AS batch_type,
				template_tag_array,
				template_path,
				template_name,
				pk_bp_ef_status_id,
				failed_case_Id=ISNULL(case_Id,''),
				fk_batch_entity_type_id,
				ResendCount=ISNULL(ResendCount,0),
				ISNULL(w.BasePathId,0) AS BasePathId,
				EmailFrom,  
				Password,  
				SMTP_Port_Number,  
				SMTP_Server_Name,  
				isSSLEnabled,  
				ReplyToEmailId
			 FROM
				tbl_batch_print_offline_email_fax_status EFS
				JOIN tbl_batch_print_offline_queue Q ON Q.pk_batch_print_Id = EFS.fk_batch_print_id
				JOIN IssueTracker_Users U ON U.UserId = Q.fk_configured_by_id
				JOIN tbl_batch_type BT ON BT.ID = Q.fk_batch_type_id
				LEFT JOIN tbl_template_word W ON W.pk_template_id = Q.fk_template_id
				LEFT JOIN tblDomainEmailSettings DS ON DS.Domain_Id = Q.DomainId  
			 WHERE
				ISNULL(EFS.IsDeleted,0)		=	0	AND
				ISNULL(Q.IsDeleted,0)		=	0	AND				 
				ISNULL(EFS.in_progress,0)	=	0	AND
				ISNULL(emailStatus,'')		=	'Failed' AND
				ISNULL(ResendCount,0)		<	4
			ORDER BY
				pk_batch_print_Id ASC
	END
	ELSE
	BEGIN
			--This will always return empty result
			SELECT TOP 1
				pk_batch_print_Id,
				Q.[DomainId],
				[printing_type],
				[case_ids],
				[node_name],
				[changed_status],
				is_upload_docs,
				[fk_configured_by_id],
				configured_date,
				is_processed,
				processed_date,
				file_name,
				file_path,
				configuredBy=U.DisplayName,
				Email,
				fk_batch_type_id,
				fk_template_id,
				entity_type_ids,
				BT.Name AS batch_type,
				template_tag_array,
				template_path,
				template_name,
				pk_bp_ef_status_id,
				failed_case_Id=ISNULL(case_Id,''),
				fk_batch_entity_type_id,
				ResendCount=ISNULL(ResendCount,0),
				ISNULL(w.BasePathId,0) AS BasePathId,
				EmailFrom,  
				Password,  
				SMTP_Port_Number,  
				SMTP_Server_Name,  
				isSSLEnabled,  
				ReplyToEmailId
			 FROM
				tbl_batch_print_offline_email_fax_status EFS
				JOIN tbl_batch_print_offline_queue Q ON Q.pk_batch_print_Id = EFS.fk_batch_print_id
				JOIN IssueTracker_Users U ON U.UserId = Q.fk_configured_by_id
				JOIN tbl_batch_type BT ON BT.ID = Q.fk_batch_type_id
				LEFT JOIN tbl_template_word W ON W.pk_template_id = Q.fk_template_id
				LEFT JOIN tblDomainEmailSettings DS ON DS.Domain_Id = Q.DomainId  
			 WHERE
				ISNULL(EFS.IsDeleted,0)		=	-1	AND
				ISNULL(Q.IsDeleted,0)		=	-1	AND				 
				ISNULL(EFS.in_progress,0)	=	-1
			ORDER BY
				pk_batch_print_Id ASC				
	END
   SET NOCOUNT OFF;
END

