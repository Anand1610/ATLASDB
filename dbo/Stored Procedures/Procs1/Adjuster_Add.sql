CREATE PROCEDURE [dbo].[Adjuster_Add]
(
	@s_a_DomainID	varchar(50),
	@i_a_Adjuster_Id			INT,
	@s_a_Adjuster_LName		varchar(200),
	@s_a_Adjuster_FName		varchar(200),
	--@i_a_InsuranceCompany_Id		int,
	@s_a_Address		varchar(255) = null,
	@s_a_Phone		varchar(100) = null,
	@s_a_Extenstion	varchar(50) = null,
	@s_a_Fax		varchar(100) = null,
	@s_a_Email		varchar(100) = null,
	--@s_a_IsActive		bit,
	@s_a_Created_By_User	VARCHAR(100)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	-- select * from Adjuster
	-- Adjuster_ID	Adjuster
	SET NOCOUNT ON;
	DECLARE @i_l_result				INT
	DECLARE @s_l_message			NVARCHAR(500)
	DECLARE @s_l_Adjuster		VARCHAR(200)
	DECLARE @s_l_notes_desc			NVARCHAR(MAX)
	
	IF(@i_a_Adjuster_Id = 0)
	BEGIN
	    IF EXISTS(SELECT Adjuster_LastName FROM tblAdjusters WHERE Adjuster_LastName = @s_a_Adjuster_LName AND Adjuster_FirstName = @s_a_Adjuster_FName and DomainID = @s_a_DomainID)
		OR EXISTS(SELECT Adjuster_LastName FROM tblAdjusters WHERE Adjuster_LastName = @s_a_Adjuster_FName AND Adjuster_FirstName = @s_a_Adjuster_LName and DomainID = @s_a_DomainID)
	    BEGIN
	       SET @s_l_message		=  'Adjuster Name already exists..!!!'
		   SET @i_l_result		=  SCOPE_IDENTITY()
	    END
	    ELSE
	    BEGIN
	          BEGIN TRAN
		      INSERT INTO tblAdjusters
		      (
			    Adjuster_LastName	,
				Adjuster_FirstName	,
				--InsuranceCompany_Id	,
				Adjuster_Address	,
				Adjuster_Phone	,
				Adjuster_Extension	,
				Adjuster_Fax	,
				Adjuster_Email	,
				DomainId	,
				--active	,
				created_by_user	,
				created_date	
		      )
		      VALUES
		      (
                @s_a_Adjuster_LName,
				@s_a_Adjuster_FName,
				--@i_a_InsuranceCompany_Id,
				@s_a_Address,
				@s_a_Phone,
				@s_a_Extenstion,
				@s_a_Fax,
				@s_a_Email,
				@s_a_DomainID,
				--@s_a_IsActive,
				@s_a_Created_By_User,
				GETDATE()	
		      )
		      SET @s_l_message		=  'Adjuster details saved successfully'
		      SET @i_l_result		=  SCOPE_IDENTITY()
		      
		      
		      SET @s_l_notes_desc = 'Added Adjuster -'+	 @s_a_Adjuster_LName+ ' ' + @s_a_Adjuster_FName


		      EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_User_Id = @s_a_Created_By_User,@s_a_notes_type='Adjuster',@DomainID =@s_a_DomainID 
		      COMMIT TRAN 
	    END		
	END
	ELSE
	BEGIN
		BEGIN TRAN
		
		DECLARE @oldAdjuster VARCHAR(200)

		SET @oldAdjuster = (SELECT TOP 1 Adjuster_LastName +' '+ Adjuster_FirstName FROM tblAdjusters WHERE  Adjuster_Id = @i_a_Adjuster_Id and DomainID = @s_a_DomainID )
		
		IF NOT EXISTS(SELECT TOP 1 Adjuster_LastName FROM tblAdjusters WHERE  Adjuster_Id <>  @i_a_Adjuster_Id and Adjuster_LastName +' '+ Adjuster_FirstName = @s_a_Adjuster_LName + ' ' + @s_a_Adjuster_FName   and DomainID = @s_a_DomainID )
		    AND NOT EXISTS(SELECT TOP 1 Adjuster_LastName FROM tblAdjusters WHERE  Adjuster_Id <>  @i_a_Adjuster_Id and Adjuster_FirstName +' '+ Adjuster_LastName=  @s_a_Adjuster_LName + ' ' + @s_a_Adjuster_FName  and DomainID = @s_a_DomainID )
		BEGIN
			UPDATE tblAdjusters
			SET 
				Adjuster_LastName	=	@s_a_Adjuster_LName	,
				Adjuster_FirstName	=	@s_a_Adjuster_FName	,
				--InsuranceCompany_Id = @i_a_InsuranceCompany_Id,
				Adjuster_Address	=	@s_a_Address	,
				Adjuster_Phone	=	@s_a_Phone	,
				Adjuster_Extension = @s_a_Extenstion,
				Adjuster_Fax	=	@s_a_Fax	,
				Adjuster_Email	=	@s_a_Email	,
				--active	= @s_a_IsActive	,			
				modified_by_user	=	@s_a_Created_By_User	,
				modified_date	=	GETDATE()	
			WHERE 
				 Adjuster_Id	=	@i_a_Adjuster_Id	
				 and DomainID = @s_a_DomainID

			--IF(@s_a_Adjuster<> @oldAdjuster)
			--BEGIN
			--	UPDATE tblCASE
			--	SET Adjuster		= @s_a_Adjuster
			--	WHERE Adjuster	= @oldAdjuster  and DomainID = @s_a_DomainID 
			--END

			SET @s_l_message	=  'Adjuster details updated successfully'
			SET @i_l_result		=  @i_a_Adjuster_Id

			
			SET @s_l_notes_desc = 'Updated Adjuster -'+	 @s_a_Adjuster_LName + ' ' +  @s_a_Adjuster_FName
            
		    EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_User_Id = @s_a_Created_By_User,@s_a_notes_type='Adjuster',@DomainID =@s_a_DomainID 
		   
		END
		ELSE
		BEGIN
			SET @s_l_message	=  'Adjuster already exist. You can not change the Adjuster '
			SET @i_l_result		=  @i_a_Adjuster_Id
		END
		                                      
		COMMIT TRAN			
	END
	SELECT @s_l_message AS [MESSAGE], @i_l_result AS [RESULT]	

END
