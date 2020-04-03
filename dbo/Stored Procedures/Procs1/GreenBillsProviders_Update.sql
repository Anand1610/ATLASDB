

CREATE PROCEDURE [dbo].[GreenBillsProviders_Update]
(
	@i_a_ID				INT,
	@s_a_PROVIDER		VARCHAR(500),
	@s_a_Status			VARCHAR(200),
	@s_a_InitialStatus  VARCHAR(200),
	@s_a_DomainID       VARCHAR(50)
)
AS
BEGIN

   SET NOCOUNT ON;
   DECLARE @i_l_result		INT
   DECLARE @s_l_message		NVARCHAR(500)
  
		UPDATE GreenBillsProviders

		 SET PROVIDER_ID	  = @s_a_PROVIDER,
			 Initial_Status = @s_a_InitialStatus,
			 Status		  = @s_a_Status
	    
       WHERE 
			  id	   = @i_a_ID
	     and  DomainId = @s_a_DomainId
      
		 	   
	   SET @s_l_message	=  ' Successfully Updated Provider'
	   SET @i_l_result	=  @i_a_ID
END


