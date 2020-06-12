CREATE PROCEDURE [dbo].[MotionType_Add]
(
    @i_a_MotionType_Id INT,
    @s_a_MotionType VARCHAR(100),
    @s_a_DomainID VARCHAR(50),
    @s_a_Created_By_User VARCHAR(100)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	--select * from MST_PacketCaseType
	--CaseType_ID	CaseType
	SET NOCOUNT ON;
	DECLARE @i_l_result	INT
	DECLARE @s_l_message	NVARCHAR(500)
	DECLARE @s_l_CaseType	VARCHAR(200)
	DECLARE @s_l_notes_desc	NVARCHAR(MAX)
	
	IF( @i_a_MotionType_Id = 0)
	BEGIN
	    IF EXISTS(SELECT Name FROM tblMotionType WHERE Name =  @s_a_MotionType and DomainID = @s_a_DomainID)
	    BEGIN
	       SET @s_l_message	=  'Motion Type already exists..!!!'
		   SET @i_l_result		=  SCOPE_IDENTITY()
	    END
	    ELSE
	    BEGIN
	          BEGIN TRAN
		      INSERT INTO tblMotionType
		      (
			      Name,
				  DomainID,
			      created_by_user,
			      created_date
		      )
		      VALUES
		      (
                  @s_a_MotionType,
				  @s_a_DomainID,
                  @s_a_Created_By_User,
                  GETDATE()
		      )
		      SET @s_l_message	=  'Motion Type details saved successfully'
		      SET @i_l_result		=  SCOPE_IDENTITY()
		      
		      
		      SET @s_l_notes_desc = 'Added Motion Type-'+	  @s_a_MotionType	


		      EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_User_Id = @s_a_Created_By_User,@s_a_notes_type='Motion Type',@DomainID =@s_a_DomainID 
		      COMMIT TRAN 
	    END		
	END
	ELSE
	BEGIN
		IF NOT EXISTS(SELECT Name FROM tblMotionType WHERE Name =  @s_a_MotionType and DomainID = @s_a_DomainID and Name <>  @s_a_MotionType)
		BEGIN
			BEGIN TRAN
		
			DECLARE @oldMotionType VARCHAR(200)

			SET @oldMotionType = (SELECT TOP 1 Name FROM tblMotionType WHERE  MotionTypeId =  @i_a_MotionType_Id and DomainID = @s_a_DomainID )
		
			IF( @s_a_MotionType<> @oldMotionType)
			BEGIN
				UPDATE tblMotionType
				SET 
					 Name		=  @s_a_MotionType,
					 modified_by_user	= @s_a_Created_By_User,
					 modified_date		= GETDATE()
				WHERE 
					 MotionTypeId =  @i_a_MotionType_Id
					 and DomainID = @s_a_DomainID

				--UPDATE tblCASE
				--SET Initial_Status=  @s_a_CaseType
				--WHERE Initial_Status = @oldCaseType  and DomainID = @s_a_DomainID 

				SET @s_l_notes_desc = 'Motion Type Status-' + @oldMotionType + ' to '+  @s_a_MotionType	
				EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_User_Id = @s_a_Created_By_User,@s_a_notes_type='Motion Type',@DomainID =@s_a_DomainID 
		      
			END

			SET @s_l_message	=  'Motion Type details updated successfuly'
			SET @i_l_result	=   @i_a_MotionType_Id
                                   
			COMMIT TRAN		
		END
		ELSE
		BEGIN
			SET @s_l_message	=  'Cannot save, Packet Type already exist...' 
			SET @i_l_result	=   @i_a_MotionType_Id
		END			
	END
	SELECT @s_l_message AS [MESSAGE], @i_l_result AS [RESULT]	

END