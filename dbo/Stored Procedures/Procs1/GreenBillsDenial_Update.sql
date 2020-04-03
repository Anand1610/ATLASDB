
CREATE PROCEDURE [dbo].[GreenBillsDenial_Update](


@s_a_GB_DenialReason  VARCHAR(200),
@s_a_DenialReason     VARCHAR(200),
@s_a_DomainId         VARCHAR(50)

)
AS
BEGIN
   SET NOCOUNT ON;
   DECLARE @i_l_result	    INT
   DECLARE @s_l_message  	NVARCHAR(500)
   DECLARE @s_l_notes_desc	NVARCHAR(MAX)
   
			UPDATE GreenBillsDenial

				SET		 RFA_DENIAL_REASON = @s_a_DenialReason 

				WHERE	 GB_DENIAL_REASON  = @s_a_GB_DenialReason and
						 [DomainID] = @s_a_DomainId
		
				   SET @s_l_message	=  ' Successfully Updated Denial Reason'
	              

END



