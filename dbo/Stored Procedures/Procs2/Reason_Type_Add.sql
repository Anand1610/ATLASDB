CREATE PROCEDURE [dbo].[Reason_Type_Add]
(
   @i_a_DenialReasons_Id   	INT,
   @s_a_DenialReasons_Type	VARCHAR(100),
   @s_a_DomainID			VARCHAR(50),
   @s_a_Created_By_User     VARCHAR(100),
   @b_is_main				bit=null
)
AS
BEGIN

	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	-- select * from tblDenialReasons
	-- DenialReasons_Id	DenialReasons_Type
	SET NOCOUNT ON;
	DECLARE @i_l_result	            INT
	DECLARE @s_l_message	        NVARCHAR(500)
	DECLARE @s_l_DenialReasons_Type	VARCHAR(200)
	DECLARE @s_l_notes_desc	        NVARCHAR(MAX)
	
	IF(@i_a_DenialReasons_Id = 0)
	BEGIN
	    IF EXISTS(SELECT DenialReasons_Type FROM tblDenialReasons WHERE DenialReasons_Type = @s_a_DenialReasons_Type and DomainID = @s_a_DomainID)
	    BEGIN
	       SET @s_l_message	=  'Reason type already exists..!!!'
		   SET @i_l_result	=  SCOPE_IDENTITY()
	    END
	    ELSE
	    BEGIN
	          BEGIN TRAN
		      INSERT INTO tblDenialReasons
		      (
			      DenialReasons_Type,
				  DomainID,
			      created_by_user,
			      created_date,
				  IsMain
		      )
		      VALUES
		      (
                  @s_a_DenialReasons_Type,
				  @s_a_DomainID,
                  @s_a_Created_By_User,
                  GETDATE(),
				  @b_is_main
		      )
		      SET @s_l_message	=  'Reason type saved successfully'
		      SET @i_l_result	=  SCOPE_IDENTITY()		      
		      SET @s_l_notes_desc = 'Added Reason type-'+	 @s_a_DenialReasons_Type	

		      EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_User_Id = @s_a_Created_By_User,@s_a_notes_type='Reason_Type',@DomainID =@s_a_DomainID 
		      COMMIT TRAN 
	    END		
	END
	ELSE
	BEGIN
		BEGIN TRAN	
			
		DECLARE @oldDenialReasons_Type VARCHAR(200)

		SET @oldDenialReasons_Type = (SELECT TOP 1 DenialReasons_Type FROM tblDenialReasons WHERE  DenialReasons_Id = @i_a_DenialReasons_Id and DomainID = @s_a_DomainID )
		
		IF NOT EXISTS(SELECT TOP 1 DenialReasons_Type FROM tblDenialReasons WHERE  DenialReasons_Id <>  @i_a_DenialReasons_Id and DenialReasons_Type= @s_a_DenialReasons_Type and DomainID = @s_a_DomainID )
		BEGIN
			UPDATE tblDenialReasons
			SET 
				 DenialReasons_Type	= @s_a_DenialReasons_Type,
				 modified_by_user	= @s_a_Created_By_User,
				 modified_date		= GETDATE(),
				 IsMain				=@b_is_main
			WHERE 
				 DenialReasons_Id = @i_a_DenialReasons_Id
				 and DomainID     = @s_a_DomainID

			IF(@s_a_DenialReasons_Type<> @oldDenialReasons_Type)
			BEGIN
				UPDATE tblTreatment
				SET   DENIALREASONS_TYPE   = @s_a_DenialReasons_Type
				WHERE DENIALREASONS_TYPE   = @oldDenialReasons_Type  and DomainID = @s_a_DomainID 
			END

			SET @s_l_message	=  'Reason type updated successfully'
			SET @i_l_result	    =  @i_a_DenialReasons_Id
		END
		ELSE
		BEGIN
			SET @s_l_message	=  'Reason type already exist. You can not change the Reason type'
			SET @i_l_result	=  @i_a_DenialReasons_Id
		END
		
		
		SET @s_l_notes_desc = 'Updated Reason types-'+	 @s_a_DenialReasons_Type	
            
		      EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_User_Id = @s_a_Created_By_User,@s_a_notes_type='Reason_Type',@DomainID =@s_a_DomainID 
		                                         
		COMMIT TRAN			
	END
	SELECT @s_l_message AS [MESSAGE], @i_l_result AS [RESULT]	

END
