
CREATE PROCEDURE [dbo].[Attorney_Master_Add]
(
	@s_a_DomainID	varchar(50),
	@i_a_Attorney_Id			INT,
	@s_a_Attorney_LName		varchar(200),
	@s_a_Attorney_FName		varchar(200),
	@s_a_LawFirmName varchar(200) = null,
	@i_a_Attorney_Type_Id		int,
	@s_a_Address		varchar(255) = null,
	@s_a_City		varchar(100) = null,
	@s_a_State		varchar(100) = null,
	@s_a_Zip		varchar(50) = null,
	@s_a_Phone		varchar(100) = null,
	--@s_a_Extenstion	varchar(50) = null,
	@s_a_Fax		varchar(100) = null,
	@s_a_Email		varchar(100) = null,	
	@s_a_Created_By_User	VARCHAR(100),
	@b_a_IsOutsideAttorney bit,
	@s_a_Attorney_BAR_Number varchar(150) = null
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

	IF(@i_a_Attorney_Id = 0)
	BEGIN
	    IF EXISTS(SELECT Attorney_LastName FROM tblAttorney_Master WHERE Attorney_LastName = @s_a_Attorney_LName AND Attorney_FirstName = @s_a_Attorney_FName and Attorney_Type_Id = @i_a_Attorney_Type_Id and DomainID = @s_a_DomainID)
		OR EXISTS(SELECT Attorney_LastName FROM tblAttorney_Master WHERE Attorney_LastName = @s_a_Attorney_FName AND Attorney_FirstName = @s_a_Attorney_LName and Attorney_Type_Id = @i_a_Attorney_Type_Id and DomainID = @s_a_DomainID)
	    BEGIN
	       SET @s_l_message		=  'Attorney Name already exists..!!!'
		   SET @i_l_result		=  SCOPE_IDENTITY()
	    END
	    ELSE
	    BEGIN
	          BEGIN TRAN  
		      INSERT INTO tblAttorney_Master
		      (
				
			    Attorney_LastName	,
				Attorney_FirstName	,
				LawFirmName,
				Attorney_Type_Id	,
				Attorney_Address	,
				Attorney_City,    
				Attorney_State,    
				Attorney_Zip,  
				Attorney_Phone	,
				--Attorney_Extension	,
				Attorney_Fax	,
				Attorney_Email	,
				DomainId	,
				--active	,
				created_by_user	,
				created_date,
				IsOutsideAttorney,
				Attorney_BAR_Number
		      )
		      VALUES
		      (
				
                @s_a_Attorney_LName,
				@s_a_Attorney_FName,
				@s_a_LawFirmName,
				@i_a_Attorney_Type_Id,
				@s_a_Address,
				@s_a_City,
				@s_a_State,
				@s_a_Zip,
				@s_a_Phone,
				--@s_a_Extenstion,
				@s_a_Fax,
				@s_a_Email,
				@s_a_DomainID,
				--@s_a_IsActive,
				@s_a_Created_By_User,
				GETDATE()	,
				@b_a_IsOutsideAttorney,
				@s_a_Attorney_BAR_Number
		      )

			  

		      SET @s_l_message		=  'Attorney details saved successfully'
		      SET @i_l_result		=  SCOPE_IDENTITY()
		      
		      
		      SET @s_l_notes_desc = 'Added Attorney -'+	 @s_a_Attorney_LName+ ' ' + @s_a_Attorney_FName


		      EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_User_Id = @s_a_Created_By_User,@s_a_notes_type='Attorney',@DomainID =@s_a_DomainID 
		      COMMIT TRAN 
	    END		
	END
	ELSE
	BEGIN
		BEGIN TRAN
		
		DECLARE @oldAttorney VARCHAR(200)

		SET @oldAttorney = (SELECT TOP 1 Attorney_LastName +' '+ Attorney_FirstName FROM tblAttorney_Master WHERE  Attorney_Id = @i_a_Attorney_Id and DomainID = @s_a_DomainID )
		
		IF NOT EXISTS(SELECT TOP 1 Attorney_LastName FROM tblAttorney_Master WHERE  Attorney_Id <>  @i_a_Attorney_Id and Attorney_LastName +' '+ Attorney_FirstName = @s_a_Attorney_LName + ' ' + @s_a_Attorney_FName  and Attorney_Type_Id = @i_a_Attorney_Type_Id and DomainID = @s_a_DomainID )
		    AND NOT EXISTS(SELECT TOP 1 Attorney_LastName FROM tblAttorney_Master WHERE  Attorney_Id <>  @i_a_Attorney_Id and Attorney_FirstName +' '+ Attorney_LastName=  @s_a_Attorney_LName + ' ' + @s_a_Attorney_FName  and Attorney_Type_Id = @i_a_Attorney_Type_Id and DomainID = @s_a_DomainID )
		BEGIN
			UPDATE tblAttorney_Master
			SET 
				Attorney_LastName	=	@s_a_Attorney_LName	,
				Attorney_FirstName	=	@s_a_Attorney_FName	,
				LawFirmName = @s_a_LawFirmName,
				Attorney_Type_Id = @i_a_Attorney_Type_Id,
				Attorney_Address	=	@s_a_Address	,
				Attorney_City	=	@s_a_City	,
				Attorney_State	=	@s_a_State	,
				Attorney_Zip	=	@s_a_Zip	,
				Attorney_Phone	=	@s_a_Phone	,
				--Attorney_Extension = @s_a_Extenstion,
				Attorney_Fax	=	@s_a_Fax	,
				Attorney_Email	=	@s_a_Email	,
				--active	= @s_a_IsActive	,			
				modified_by_user	=	@s_a_Created_By_User	,
				modified_date	=	GETDATE(),
				IsOutsideAttorney = @b_a_IsOutsideAttorney,
				Attorney_BAR_Number = @s_a_Attorney_BAR_Number
			WHERE 
				 Attorney_Id	=	@i_a_Attorney_Id	
				 and DomainID = @s_a_DomainID

			--IF(@s_a_Attorney<> @oldAttorney)
			--BEGIN
			--	UPDATE tblCASE
			--	SET Attorney		= @s_a_Attorney
			--	WHERE Attorney	= @oldAttorney  and DomainID = @s_a_DomainID 
			--END

			SET @s_l_message	=  'Attorney details updated successfully'
			SET @i_l_result		=  @i_a_Attorney_Id

			
			SET @s_l_notes_desc = 'Updated Attorney -'+	 @s_a_Attorney_LName + ' ' +  @s_a_Attorney_FName
            
		    EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_User_Id = @s_a_Created_By_User,@s_a_notes_type='Attorney',@DomainID =@s_a_DomainID 
		   
		END
		ELSE
		BEGIN
			SET @s_l_message	=  'Attorney already exist. You can not change the Attorney '
			SET @i_l_result		=  @i_a_Attorney_Id
		END
		                                      
		COMMIT TRAN			
	END
	SELECT @s_l_message AS [MESSAGE], @i_l_result AS [RESULT]	

END

