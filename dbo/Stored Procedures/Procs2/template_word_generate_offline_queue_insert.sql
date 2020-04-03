CREATE PROCEDURE [dbo].[template_word_generate_offline_queue_insert]
(
	@s_a_domain_id			VARCHAR(MAX),
	@i_a_template_id		INT,
	@s_a_case_ids			VARCHAR(MAX),
	@s_a_save_as			CHAR(5),
	@s_a_node_name			VARCHAR(MAX),
	@b_a_is_upload_docs		BIT,
	@i_a_configured_by_id	INT,
	@dt_a_configured_date	DATETIME,
	@s_a_changed_status varchar(100)
)
AS
BEGIN
SET NOCOUNT ON	
	
	INSERT INTO tbl_template_word_offline_queue
	(
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
		changed_status
	)
	VALUES
	(
		@s_a_domain_id,
		@i_a_template_id,
		@s_a_case_ids,
		@s_a_save_as,
		@s_a_node_name,
		@b_a_is_upload_docs,
		@i_a_configured_by_id,
		@dt_a_configured_date,
		0,
		NULL,
		'',
		'',
		@s_a_changed_status
	)

	SELECT 'Offline request saved successfully..!!' AS result
   
SET NOCOUNT OFF        
END

