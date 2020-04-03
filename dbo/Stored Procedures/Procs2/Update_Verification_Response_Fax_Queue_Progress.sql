CREATE PROCEDURE Update_Verification_Response_Fax_Queue_Progress 
	@i_a_pk_vr_fax_queue_id int,  
	@s_a_DomainId varchar(50),  
	@b_a_inpprogress_send bit  
AS
BEGIN
	SET NOCOUNT ON;
	Update tbl_verification_response_fax_queue Set inprogress_send = @b_a_inpprogress_send 
	Where DomainID = @s_a_DomainId and pk_vr_fax_queue_id = @i_a_pk_vr_fax_queue_id

END
