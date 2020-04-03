CREATE PROCEDURE [dbo].[bulk_print_offline_queue_delete] 
	@s_a_domain_id			VARCHAR(50),
	@i_a_pk_batch_print_Id	INT
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE tbl_batch_print_fax_queue SET isDeleted = 1 WHERE fk_bp_ef_status_id IN (SELECT pk_bp_ef_status_id FROM tbl_batch_print_offline_email_fax_status WHERE fk_batch_print_id = @i_a_pk_batch_print_Id)
	UPDATE tbl_batch_print_offline_email_fax_status SET isDeleted = 1 WHERE fk_batch_print_id = @i_a_pk_batch_print_Id
	UPDATE tbl_batch_print_offline_queue SET isDeleted = 1 WHERE  pk_batch_print_Id = @i_a_pk_batch_print_Id AND DomainId = @s_a_domain_id
	SET NOCOUNT OFF;
END
