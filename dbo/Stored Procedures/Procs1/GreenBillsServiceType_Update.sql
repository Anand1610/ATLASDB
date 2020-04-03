
CREATE PROCEDURE [dbo].[GreenBillsServiceType_Update](


@s_a_GB_ServiceType  VARCHAR(200),
@s_a_ServiceType     VARCHAR(200),
@s_a_DomainId         VARCHAR(50)

)
AS
BEGIN
   SET NOCOUNT ON;
   DECLARE @i_l_result	    INT
   DECLARE @s_l_message  	NVARCHAR(500)
   DECLARE @s_l_notes_desc	NVARCHAR(MAX)
   
			UPDATE GreenBillServiceType

				SET		 ServiceType = @s_a_ServiceType 

				WHERE	 GB_ServiceType  = @s_a_GB_ServiceType and
						 DomainId = @s_a_DomainId
		
				   SET @s_l_message	=  ' Successfully Updated Service Type'
	              

END



