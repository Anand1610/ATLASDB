CREATE PROCEDURE [dbo].[Attorney_Type_Add]
(
   @i_a_Attorney_Type_ID		INT,
   @s_a_Attorney_Type    VARCHAR(100),
   @s_a_DomainID		VARCHAR(50),
   @s_a_Created_By_User VARCHAR(100)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	--select * from tblAttorney_Type
	--Denial_ID	Attorney_Type
	SET NOCOUNT ON;
	DECLARE @i_l_result	           INT
	DECLARE @s_l_message	       NVARCHAR(500)
	DECLARE @s_l_Attorney_TypeType  VARCHAR(200)
	DECLARE @s_l_notes_desc	       NVARCHAR(MAX)
	
	IF(@i_a_Attorney_Type_ID = 0)
	BEGIN
	    IF EXISTS(SELECT Attorney_Type FROM tblAttorney_Type WHERE Attorney_Type = @s_a_Attorney_Type and DomainID = @s_a_DomainID)
	    BEGIN
	       SET @s_l_message	=  'Attorney Type already exists..!!!'
		   SET @i_l_result		=  SCOPE_IDENTITY()
	    END
	    ELSE
	    BEGIN
	          BEGIN TRAN
		      INSERT INTO tblAttorney_Type
		      (
			      Attorney_Type,
				  DomainID,
			      created_by_user,
			      created_date
		      )
		      VALUES
		      (
                  @s_a_Attorney_Type,
				  @s_a_DomainID,
                  @s_a_Created_By_User,
                  GETDATE()
		      )
		      SET @s_l_message	=  'Attorney Type saved successfully'
		      SET @i_l_result	=  SCOPE_IDENTITY()		     		      
		      SET @s_l_notes_desc = 'Added Attorney Type-'+	 @s_a_Attorney_Type	

		      EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_User_Id = @s_a_Created_By_User,@s_a_notes_type='Attorney_Type',@DomainID =@s_a_DomainID 
		      COMMIT TRAN 
	    END		
	END
	ELSE
	BEGIN
		BEGIN TRAN
		
		DECLARE @oldAttorney_Type VARCHAR(200)

		SET @oldAttorney_Type = (SELECT TOP 1 Attorney_Type FROM tblAttorney_Type WHERE  Attorney_Type_ID = @i_a_Attorney_Type_ID and DomainID = @s_a_DomainID )
		
		IF NOT EXISTS(SELECT TOP 1 Attorney_Type FROM tblAttorney_Type WHERE  Attorney_Type_ID <>  @i_a_Attorney_Type_ID and Attorney_Type= @s_a_Attorney_Type and DomainID = @s_a_DomainID )
		BEGIN
			UPDATE tblAttorney_Type
			SET 
				 Attorney_Type		= @s_a_Attorney_Type,
				 modified_by_user	= @s_a_Created_By_User,
				 modified_date		= GETDATE()
			WHERE 
				 Attorney_Type_ID = @i_a_Attorney_Type_ID
				 and DomainID = @s_a_DomainID

		 --  IF(@s_a_Attorney_Type<> @oldAttorney_Type)
		 --  BEGIN
			--	UPDATE tblCASE
			--	SET Attorney_Type   = @s_a_Attorney_Type
			--	WHERE Attorney_Type = @oldAttorney_Type  and DomainID = @s_a_DomainID 
			--END

	
			SET @s_l_message =  'Attorney Type updated successfully'
			SET @i_l_result	 =  @i_a_Attorney_Type_ID
		END
		ELSE
		BEGIN
			SET @s_l_message =  'Attorney Type already exist. You can not change the Attorney Type '
			SET @i_l_result  =  @i_a_Attorney_Type_ID
		END
		
		
		SET @s_l_notes_desc = 'Updated Attorney Type-'+	 @s_a_Attorney_Type	
            
		      EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_User_Id = @s_a_Created_By_User,@s_a_notes_type='Attorney_Type',@DomainID =@s_a_DomainID 
		                                         
		COMMIT TRAN			
	END
	SELECT @s_l_message AS [MESSAGE], @i_l_result AS [RESULT]	

END
