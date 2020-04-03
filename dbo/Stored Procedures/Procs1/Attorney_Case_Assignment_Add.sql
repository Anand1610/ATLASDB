
CREATE PROCEDURE [dbo].[Attorney_Case_Assignment_Add]
(
	@s_a_DomainID	varchar(50),
	@i_a_Assignment_Id			INT,
	@i_a_Attorney_Id			INT,	
	@i_a_Attorney_Type_Id		int,
	@i_a_Case_Id		NVARCHAR(50),
	@s_a_Created_By_User	VARCHAR(100)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	-- select * from Attorney
	-- Attorney_ID	Attorney
	SET NOCOUNT ON;
	DECLARE @i_l_result				INT
	DECLARE @s_l_message			NVARCHAR(500)
	DECLARE @s_l_Attorney		VARCHAR(200)
	DECLARE @s_l_notes_desc			NVARCHAR(MAX)
	DECLARE @AttorneyID AS NVARCHAR(20) 
    DECLARE @MaxAttorney_Id_IDENTITY AS INTEGER    

	IF(@i_a_Assignment_Id = 0)
	BEGIN
     IF EXISTS(SELECT Assignment_Id FROM tblAttorney_Case_Assignment WHERE Attorney_Id = @i_a_Attorney_Id AND Attorney_Type_Id = @i_a_Attorney_Type_Id and Case_Id = @i_a_Case_Id and DomainID = @s_a_DomainID)
	    BEGIN
	       SET @s_l_message		=  'Attorney already Assigned..!!!'
		   SET @i_l_result		=  SCOPE_IDENTITY()
	    END
	    ELSE
	    BEGIN
	          BEGIN TRAN  
		      INSERT INTO tblAttorney_Case_Assignment
		      (
				Attorney_Type_Id,
			    Attorney_Id,
				Case_Id,
				DomainId	,
				--active	,
				created_by_user	,
				created_date	
		      )
		      VALUES
		      (
				@i_a_Attorney_Type_Id,
				@i_a_Attorney_Id,
				@i_a_Case_Id,
				@s_a_DomainID,
				--@s_a_IsActive,
				@s_a_Created_By_User,
				GETDATE()	
		      )

			  

		      SET @s_l_message		=  'Attorney Assignment saved successfully'
		      SET @i_l_result		=  SCOPE_IDENTITY()
		      
		      
		      SET @s_l_notes_desc = 'Added Attorney Assignment. Type -'+	convert(nvarchar(255), @i_a_Attorney_Type_Id) + '. Attorney - ' + convert(nvarchar(255), @i_a_Attorney_Id)  + ' for Case ID -'+@i_a_Case_Id


		      EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_User_Id = @s_a_Created_By_User,@s_a_notes_type='Attorney',@DomainID =@s_a_DomainID 
		      COMMIT TRAN 
	    END		
	END
	ELSE
	BEGIN
		BEGIN TRAN
		
		DECLARE @oldAttorneyId int;
		Declare @IsDuplicate bit =0;
		
		Select @oldAttorneyId = Attorney_Id from tblAttorney_Case_Assignment Where  Assignment_Id = @i_a_Assignment_Id
			   AND Case_Id = @i_a_Case_Id and DomainID = @s_a_DomainID
		
		IF(@oldAttorneyId != @i_a_Attorney_Id) and EXISTS(SELECT Assignment_Id FROM tblAttorney_Case_Assignment WHERE Attorney_Id = @i_a_Attorney_Id AND Attorney_Type_Id = @i_a_Attorney_Type_Id and Case_Id = @i_a_Case_Id and DomainID = @s_a_DomainID)
		BEGIN
			 SET @s_l_message	=  'Attorney already Assigned..!!!'
			 SET @IsDuplicate = 1;
			 SET @i_l_result		=  SCOPE_IDENTITY()
		END
		
		IF @IsDuplicate != 1
		BEGIN
			UPDATE tblAttorney_Case_Assignment
			SET 
				Attorney_Id=@i_a_Attorney_Id,
							
				modified_by_user	=	@s_a_Created_By_User	,
				modified_date	=	GETDATE()	
			WHERE 
				Assignment_Id=@i_a_Assignment_Id
				AND Case_Id=@i_a_Case_Id					
				 and DomainID = @s_a_DomainID

			--IF(@s_a_Attorney<> @oldAttorney)
			--BEGIN
			--	UPDATE tblCASE
			--	SET Attorney		= @s_a_Attorney
			--	WHERE Attorney	= @oldAttorney  and DomainID = @s_a_DomainID 
			--END

			SET @s_l_message	=  'Attorney Assignment updated successfully'
			SET @i_l_result		=  @i_a_Assignment_Id

			
			SET @s_l_notes_desc =  'Updated Attorney Assignment. Type -'+	convert(nvarchar(255), @i_a_Attorney_Type_Id)+ '. Attorney - ' + convert(nvarchar(255), @i_a_Attorney_Id)  + ' for Case ID -'+@i_a_Case_Id
            
		    EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_User_Id = @s_a_Created_By_User,@s_a_notes_type='Attorney',@DomainID =@s_a_DomainID 
		   
		END
		
		--BEGIN
		--	SET @s_l_message	=  'Attorney Assignment already exist. You can not change the Attorney Assignement '
		--	SET @i_l_result		=  @i_a_Assignment_Id
		--END
		                                      
		COMMIT TRAN			
	END
	SELECT @s_l_message AS [MESSAGE], @i_l_result AS [RESULT]	

END

