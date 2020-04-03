
CREATE PROCEDURE [dbo].[template_word_generate_offline_queue_update] 
(
	@s_a_domain_id				VARCHAR(50),
	@i_a_pk_offline_queue_id	INT,
	@dt_processed_date			DATETIME,
	@s_a_file_name				VARCHAR(MAX),
	@s_a_file_path				VARCHAR(MAX)
)
AS 
BEGIN  
SET NOCOUNT ON 
	
	UPDATE tbl_template_word_offline_queue 
	SET
		is_processed			=	1,
		processed_date			=	@dt_processed_date,
		file_name				=	@s_a_file_name,
		file_path				=	@s_a_file_path
	WHERE
		 pk_offline_queue_id	=	@i_a_pk_offline_queue_id AND 
		 domain_id				=	@s_a_domain_id
SET NOCOUNT OFF  
END
