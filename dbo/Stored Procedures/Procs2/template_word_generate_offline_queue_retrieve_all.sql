--template_word_generate_offline_queue_retrieve_all 'localhost'

CREATE PROCEDURE [dbo].[template_word_generate_offline_queue_retrieve_all] 
(
	@DomainId	VARCHAR(50),
	@UserId		INT
)
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
		is_upload_docs=CASE WHEN ISNULL(is_upload_docs,0) = 1 THEN 'Yes' ELSE 'No' END,
		fk_configured_by_id,
		configured_date=CONVERT(VARCHAR,configured_date,101),
		is_processed,
		status=CASE WHEN ISNULL(is_processed,0) = 0 THEN 'In Progress' ELSE 'Completed' END,
		processed_date=CASE WHEN processed_date IS NULL THEN CONVERT(VARCHAR,GETDATE(),101) ELSE CONVERT(VARCHAR,processed_date,101) END,
		file_name,
		file_path,
		configuredBy=U.DisplayName,
		template_name=W.template_name
	FROM
		tbl_template_word_offline_queue Q
		JOIN IssueTracker_Users U ON U.UserId = Q.fk_configured_by_id
		JOIN tbl_template_word W ON W.pk_template_id = Q.fk_template_id
	WHERE
		domain_id			=	@DomainId AND
		fk_configured_by_id	=	@UserId
	ORDER BY
		pk_offline_queue_id DESC
SET NOCOUNT OFF  
END
