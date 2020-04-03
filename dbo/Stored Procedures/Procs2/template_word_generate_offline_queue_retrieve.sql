CREATE PROCEDURE [dbo].[template_word_generate_offline_queue_retrieve] 
AS  
BEGIN  
SET NOCOUNT ON 
	SELECT
		pk_offline_queue_id,
		domain_id,
		fk_template_id,
		case_ids,
		save_as,
		NodeName,
		is_upload_docs,
		fk_configured_by_id,
		configured_date,
		is_processed,
		processed_date,
		file_name,
		file_path,
		configuredBy=U.DisplayName,
		template_name=W.template_name,
		Email,
		template_tag_array,
		template_path,
		template_name,	
		changed_status,
		CompanyType,
		ISNULL(w.BasePathId,0) AS BasePathId
	FROM
		tbl_template_word_offline_queue Q
		JOIN IssueTracker_Users U ON U.UserId = Q.fk_configured_by_id
		JOIN tbl_template_word W ON W.pk_template_id = Q.fk_template_id
		JOIN tbl_Client C ON C.DomainId = Q.domain_id 
	WHERE
		ISNULL(is_processed,0)	=	0 AND
        Q.pk_offline_queue_id not in (Select QueueSourceId from tblTriggerTypeErrorLog tel (NOLOCK) Where ISNULL(IsResolved,0) = 0 and tel.DomainId = Q.domain_id and tel.QueueType = 3)
	ORDER BY
		pk_offline_queue_id ASC
SET NOCOUNT OFF  
END
