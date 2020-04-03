CREATE PROCEDURE [dbo].[Update_batch_print_email_fax_status_progress] 
	@i_a_pk_bp_ef_status_id		BIGINT,
	@s_a_DomainId				VARCHAR(50),
	@b_a_in_progress			BIT
AS
BEGIN
	update 
		tbl_batch_print_offline_email_fax_status 
	set 
		in_progress= @b_a_in_progress
	where 
		pk_bp_ef_status_id	=	@i_a_pk_bp_ef_status_id and 
		DomainId			=	@s_a_DomainId
END
