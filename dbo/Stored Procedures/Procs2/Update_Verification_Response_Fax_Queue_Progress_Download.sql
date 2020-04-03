CREATE PROCEDURE Update_Verification_Response_Fax_Queue_Progress_Download 
	@i_a_pk_vr_fax_queue_id int,  
	@s_a_DomainId varchar(50),  
	@b_a_inprogress_download bit  
AS
BEGIN

	SET NOCOUNT ON;

	Update tbl_verification_response_fax_queue Set inprogress_download = @b_a_inprogress_download 
	Where DomainID = @s_a_DomainId and pk_vr_fax_queue_id = @i_a_pk_vr_fax_queue_id
END
