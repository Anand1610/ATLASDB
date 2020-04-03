
CREATE PROCEDURE [dbo].[CaseStatus_Add]
(
   @i_a_Id INT,
   @s_a_Name VARCHAR(100),
   @s_a_Description		VARCHAR(100),
   @s_a_DomainID VARCHAR(50),
   @s_a_Created_By_User VARCHAR(100)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	--select * from CaseStatus
	--CaseStatus_ID	CaseStatus
	SET NOCOUNT ON;
	DECLARE @i_l_result	INT
	DECLARE @s_l_message	NVARCHAR(500)
	DECLARE @s_l_CaseStatusType	VARCHAR(200)
	DECLARE @s_l_notes_desc	NVARCHAR(MAX)
	
	IF(@i_a_Id = 0)
	BEGIN
	    IF EXISTS(SELECT name FROM tblCaseStatus WHERE name = @s_a_Name and DomainID = @s_a_DomainID)
	    BEGIN
	       SET @s_l_message	=  'Case Status already exists..!!!'
		   SET @i_l_result		=  SCOPE_IDENTITY()
	    END
	    ELSE
	    BEGIN
	          BEGIN TRAN
		      INSERT INTO tblCaseStatus
		      (
			      name,
				  Description,
				  DomainID,				  
			      created_by_user,
			      created_date
		      )
		      VALUES
		      (
                  @s_a_Name,
				  @s_a_Description,
				  @s_a_DomainID,
                  @s_a_Created_By_User,
                  GETDATE()
		      )
		      SET @s_l_message	=  'Case Status details saved successfully'
		      SET @i_l_result		=  SCOPE_IDENTITY()
		      
		      
		      SET @s_l_notes_desc = 'Added Case Status-'+	 @s_a_Name	


		      EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_User_Id = @s_a_Created_By_User,@s_a_notes_type='Case Status',@DomainID =@s_a_DomainID 
		      COMMIT TRAN 
	    END		
	END
	ELSE
	BEGIN
		IF NOT EXISTS(SELECT name FROM tblCaseStatus WHERE name = @s_a_Name and DomainID = @s_a_DomainID and name <> @s_a_Name)
		BEGIN
			BEGIN TRAN
		
			DECLARE @oldCaseStatus VARCHAR(200)

			SET @oldCaseStatus = (SELECT TOP 1 name FROM tblCaseStatus WHERE  ID = @i_a_Id and DomainID = @s_a_DomainID )
		
			IF(@s_a_Name<> @oldCaseStatus)
			BEGIN
				UPDATE tblCaseStatus
				SET 
					 name		= @s_a_Name,
					 description = @s_a_Description,
					 modified_by_user	= @s_a_Created_By_User,
					 modified_date		= GETDATE()
				WHERE 
					 ID = @i_a_Id
					 and DomainID = @s_a_DomainID

				UPDATE tblCASE
				SET Initial_Status= @s_a_Name 					
				WHERE Initial_Status = @oldCaseStatus  and DomainID = @s_a_DomainID 

				SET @s_l_notes_desc = 'Updated Case Status-' + @oldCaseStatus + ' to '+	@oldCaseStatus + @s_a_Name	
				EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_User_Id = @s_a_Created_By_User,@s_a_notes_type='Case Status',@DomainID =@s_a_DomainID 
		      
			END

			SET @s_l_message	=  'Case Status details updated successfully'
			SET @i_l_result	=  @i_a_Id
                                   
			COMMIT TRAN		
		END
		ELSE
		BEGIN
			SET @s_l_message	=  'Cannot save, Case Status already exist...' 
			SET @i_l_result	=  @i_a_Id
		END			
	END
	SELECT @s_l_message AS [MESSAGE], @i_l_result AS [RESULT]	

END
