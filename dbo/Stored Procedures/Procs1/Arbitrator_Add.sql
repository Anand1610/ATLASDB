
CREATE PROCEDURE [dbo].[Arbitrator_Add]
(
   @i_a_ARBITRATOR_ID		INT,
   @s_a_ARBITRATOR_NAME		VARCHAR(100),
   @s_a_DomainID			VARCHAR(50),   
   @s_a_ABITRATOR_LOCATION	NVARCHAR(200),
   @s_a_ARBITRATOR_PHONE	NVARCHAR(200),
   @s_a_ARBITRATOR_FAX      NVARCHAR(200),  
   @s_a_IsAAA			    NVARCHAR(200),
   @s_a_ARBITRATOR_Email    NVARCHAR(200),
   @s_a_Created_By_User		VARCHAR(100)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	-- select * from TblArbitrator
	-- ARBITRATOR_ID	ARBITRATOR_NAME
	SET NOCOUNT ON;
	DECLARE @i_l_result		 INT
	DECLARE @s_l_message	 NVARCHAR(500)
	DECLARE @s_l_Status		 VARCHAR(200)
	DECLARE @s_l_notes_desc	 NVARCHAR(MAX)
	
	IF(@i_a_ARBITRATOR_ID = 0)
	BEGIN
	    IF EXISTS(SELECT ARBITRATOR_NAME FROM TblArbitrator WHERE ARBITRATOR_NAME = @s_a_ARBITRATOR_NAME and DomainID = @s_a_DomainID)
	    BEGIN
	       SET @s_l_message		=  'Judge/Arbitrator already exists..!!!'
		   SET @i_l_result		=  SCOPE_IDENTITY()
	    END
	    ELSE
	    BEGIN
	          BEGIN TRAN
		      INSERT INTO TblArbitrator
		      (
			      ARBITRATOR_NAME,
				  DomainID,				
				  ABITRATOR_LOCATION,
				  ARBITRATOR_PHONE,
				  ARBITRATOR_FAX ,
				  IS_AAA,
				  ARBITRATOR_Email,				 				 		
			      created_by_user,
			      created_date
		      )
		      VALUES
		      (
                  @s_a_ARBITRATOR_NAME,
				  @s_a_DomainID,
				  @s_a_ABITRATOR_LOCATION,
                  @s_a_ARBITRATOR_PHONE,
                  @s_a_ARBITRATOR_FAX ,  
                  @s_a_IsAAA,
				  @s_a_ARBITRATOR_Email,				  
                  @s_a_Created_By_User,
                  GETDATE()
		      )
		      SET @s_l_message		=  'Judge/Arbitrator details saved successfully'
		      SET @i_l_result		=  SCOPE_IDENTITY()
		      
		      
		      SET @s_l_notes_desc = 'Added Judge/Arbitrator-'+	 @s_a_ARBITRATOR_NAME	


		      EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_User_Id = @s_a_Created_By_User,@s_a_notes_type='Arbitrator',@DomainID =@s_a_DomainID 
		      COMMIT TRAN 
	    END		
	END
	ELSE
	BEGIN
		BEGIN TRAN
		
		DECLARE @oldArbitrator VARCHAR(200)

		SET @oldArbitrator = (SELECT TOP 1 ARBITRATOR_NAME FROM TblArbitrator WHERE  ARBITRATOR_ID = @i_a_ARBITRATOR_ID and DomainID = @s_a_DomainID )
		
		IF NOT EXISTS(SELECT TOP 1 ARBITRATOR_NAME FROM TblArbitrator WHERE  ARBITRATOR_ID <>  @i_a_ARBITRATOR_ID and ARBITRATOR_NAME= @s_a_ARBITRATOR_NAME and DomainID = @s_a_DomainID )
		BEGIN
			UPDATE TblArbitrator
			SET 
			
				 ARBITRATOR_NAME	= @s_a_ARBITRATOR_NAME,                 			
				 ABITRATOR_LOCATION = @s_a_ABITRATOR_LOCATION,
				 ARBITRATOR_PHONE	= @s_a_ARBITRATOR_PHONE,
				 ARBITRATOR_FAX	    = @s_a_ARBITRATOR_FAX,		
				 IS_AAA             = @s_a_IsAAA,
				 ARBITRATOR_Email   = @s_a_ARBITRATOR_Email,				 		
				 modified_by_user	= @s_a_Created_By_User,
				 modified_date		= GETDATE()
			WHERE 
				 ARBITRATOR_ID  = @i_a_ARBITRATOR_ID
				 and DomainID   = @s_a_DomainID

			
			SET @s_l_message	=  'Judge/Arbitrator details updated successfully'
			SET @i_l_result		=  @i_a_ARBITRATOR_ID
		END
		ELSE
		BEGIN
			SET @s_l_message	=  'Judge/Arbitrator already exist. You can not change the Judge/Arbitrator '
			SET @i_l_result		=  @i_a_ARBITRATOR_ID
		END
		
		
		SET @s_l_notes_desc = 'Updated Judge/Arbitrator-'+	 @s_a_ARBITRATOR_NAME	
            
		      EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_User_Id = @s_a_Created_By_User,@s_a_notes_type='Arbitrator',@DomainID =@s_a_DomainID 
		                                         
		COMMIT TRAN			
	END
	SELECT @s_l_message AS [MESSAGE], @i_l_result AS [RESULT]	

END
