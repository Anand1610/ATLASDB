

CREATE PROCEDURE [dbo].[GreenBillsInsurance_Update]
(
@i_a_ID				  VARCHAR(50),
@s_a_INSURANCECOMPANY VARCHAR(200),
@s_a_DomainId		  VARCHAR(50)
)
AS
BEGIN


   SET NOCOUNT ON;
   DECLARE @i_l_result	INT
   DECLARE @s_l_message	NVARCHAR(500)
   DECLARE @s_l_notes_desc	NVARCHAR(MAX)


			UPDATE GreenBillsInsurance

				SET   
				 INSURANCECOMPANY_ID=@s_a_INSURANCECOMPANY 

			   WHERE 
			     id=@i_a_ID  and  DomainId= @s_a_DomainId

				  	   
	   SET @s_l_message	=  ' Successfully Updated Insurance'
	   SET @i_l_result	=  @i_a_ID

END



