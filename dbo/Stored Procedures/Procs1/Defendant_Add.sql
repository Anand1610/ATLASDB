CREATE PROCEDURE [dbo].[Defendant_Add]
(
	@s_a_DomainID	varchar(50),
	@i_a_Defendant_Id			INT,
	@s_a_Defendant_Name		varchar(200),
	@s_a_lawfirm_name			VARCHAR(max),
	@s_a_Address		varchar(255) = null,
	@s_a_City		varchar(100) = null,
	@s_a_State		varchar(100) = null,
	@s_a_Zip		varchar(50) = null,
	@s_a_Phone		varchar(100) = null,
	@s_a_Fax		varchar(100) = null,
	@s_a_Email		varchar(100) = null,
	@s_a_IsActive		bit,
	@s_a_Created_By_User	VARCHAR(100)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	-- select * from Defendant
	-- Defendant_ID	Defendant
	SET NOCOUNT ON;
	DECLARE @i_l_result				INT
	DECLARE @s_l_message			NVARCHAR(500)
	DECLARE @s_l_Defendant		VARCHAR(200)
	DECLARE @s_l_notes_desc			NVARCHAR(MAX)
	
	IF(@i_a_Defendant_Id = 0)
	BEGIN
	    IF EXISTS(SELECT Defendant_Name FROM tblDefendant WHERE Defendant_Name = @s_a_Defendant_Name and DomainID = @s_a_DomainID)
	    BEGIN
	       SET @s_l_message		=  'Attorney already exists..!!!'
		   SET @i_l_result		=  SCOPE_IDENTITY()
	    END
	    ELSE
	    BEGIN
	          BEGIN TRAN
		      INSERT INTO tblDefendant
		      (
			    Defendant_Name	,
				Defendant_DisplayName	,
				Defendant_Address	,
				Defendant_City	,
				Defendant_State	,
				Defendant_Zip	,
				Defendant_Phone	,
				Defendant_Fax	,
				Defendant_Email	,
				DomainId	,
				active	,
				created_by_user	,
				created_date,
				lawfirmname
		      )
		      VALUES
		      (
                @s_a_Defendant_Name,
				@s_a_Defendant_Name,
				@s_a_Address,
				@s_a_City,
				@s_a_State,
				@s_a_Zip,
				@s_a_Phone,
				@s_a_Fax,
				@s_a_Email,
				@s_a_DomainID,
				@s_a_IsActive,
				@s_a_Created_By_User,
				GETDATE(),
				@s_a_lawfirm_name
		      )
		      SET @s_l_message		=  'Attorney details saved successfully'
		      SET @i_l_result		=  SCOPE_IDENTITY()
		      
		      IF(LOWER(@s_a_DomainID) = 'amt')
				SET @s_l_notes_desc = 'Added Opposing Counsel Attorney -'+	 @s_a_Defendant_Name
			  ELSE
				SET @s_l_notes_desc = 'Added Adversary Attorney -'+	 @s_a_Defendant_Name	


		      EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_User_Id = @s_a_Created_By_User,@s_a_notes_type='Defendant',@DomainID =@s_a_DomainID 
		      COMMIT TRAN 
	    END		
	END
	ELSE
	BEGIN
		BEGIN TRAN
		
		DECLARE @oldDefendant VARCHAR(200)

		SET @oldDefendant = (SELECT TOP 1 Defendant_Name FROM tblDefendant WHERE  Defendant_Id = @i_a_Defendant_Id and DomainID = @s_a_DomainID )
		
		IF NOT EXISTS(SELECT TOP 1 Defendant_Name FROM tblDefendant WHERE  Defendant_Id <>  @i_a_Defendant_Id and Defendant_Name= @s_a_Defendant_Name and DomainID = @s_a_DomainID )
		BEGIN
			UPDATE tblDefendant
			SET 
				Defendant_Name	=	@s_a_Defendant_Name	,
				Defendant_DisplayName	=	@s_a_Defendant_Name	,
				Defendant_Address	=	@s_a_Address	,
				Defendant_City	=	@s_a_City	,
				Defendant_State	=	@s_a_State	,
				Defendant_Zip	=	@s_a_Zip	,
				Defendant_Phone	=	@s_a_Phone	,
				Defendant_Fax	=	@s_a_Fax	,
				Defendant_Email	=	@s_a_Email	,
				active			= @s_a_IsActive	,			
				modified_by_user=	@s_a_Created_By_User	,
				modified_date	=	GETDATE(),
				lawfirmname     =	@s_a_lawfirm_name	
			WHERE 
				 Defendant_Id	=	@i_a_Defendant_Id	
				 and DomainID	= @s_a_DomainID

			--IF(@s_a_Defendant<> @oldDefendant)
			--BEGIN
			--	UPDATE tblCASE
			--	SET Defendant		= @s_a_Defendant
			--	WHERE Defendant	= @oldDefendant  and DomainID = @s_a_DomainID 
			--END

			SET @s_l_message	=  'Attorney details updated successfully'
			SET @i_l_result		=  @i_a_Defendant_Id

			IF(LOWER(@s_a_DomainID) = 'amt')
				SET @s_l_notes_desc = 'Updated Opposing Counsel Attorney -'+	 @s_a_Defendant_Name
			ELSE
				SET @s_l_notes_desc = 'Updated Opposing Counsel Attorney -'+	 @s_a_Defendant_Name
            
		    EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_User_Id = @s_a_Created_By_User,@s_a_notes_type='Defendant',@DomainID =@s_a_DomainID 
		   
		END
		ELSE
		BEGIN
			SET @s_l_message	=  'Attorney already exist. You can not change the Attorney Name '
			SET @i_l_result		=  @i_a_Defendant_Id
		END
		                                      
		COMMIT TRAN			
	END
	SELECT @s_l_message AS [MESSAGE], @i_l_result AS [RESULT]	

END
