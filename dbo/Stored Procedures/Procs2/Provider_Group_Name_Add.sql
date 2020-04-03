CREATE PROCEDURE [dbo].[Provider_Group_Name_Add]
(
   @i_a_Provider_Group_ID INT,
   @s_a_Provider_Group_Name VARCHAR(100),
   @s_a_DomainID VARCHAR(50),
   @s_a_Created_By_User VARCHAR(100),
   @s_a_DESCRIPTION                     VARCHAR(200),
   @s_a_SD_CODE                         VARCHAR(50), 
   @s_a_Email_For_Arb_Awards            VARCHAR(200),
   @s_a_Email_For_Invoices              NVARCHAR(200),
   @s_a_Email_For_Closing_Reports       NVARCHAR(200),
   @s_a_Email_For_Monthly_Report	    NVARCHAR(200)
 
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	--select * from Provider_Group_Name
	--Provider_Group_ID	Provider_Group_Name
	SET NOCOUNT ON;
	DECLARE @i_l_result	INT
	DECLARE @s_l_message	NVARCHAR(500)
	DECLARE @s_l_Provider_Group_NameType	VARCHAR(200)
	DECLARE @s_l_notes_desc	NVARCHAR(MAX)
	
	IF(@i_a_Provider_Group_ID = 0)
	BEGIN
	    IF EXISTS(SELECT Provider_Group_Name FROM TblProvider_Groups WHERE Provider_Group_Name = @s_a_Provider_Group_Name and DomainID = @s_a_DomainID)
	    BEGIN
	       SET @s_l_message	=  'Provider Group Name already exists..!!!'
		   SET @i_l_result		=  SCOPE_IDENTITY()
	    END
	    ELSE
	    BEGIN
	          BEGIN TRAN
		      INSERT INTO TblProvider_Groups
		      (
			      Provider_Group_Name,
				  DESCRIPTION,
				  DomainID,
				  SD_CODE,
				  Email_For_Arb_Awards,
				  Email_For_Invoices,
				  Email_For_Closing_Reports,
				  Email_For_Monthly_Report,
			      created_by_user,
			      created_date
				 
		      )
		      VALUES
		      (
					@s_a_Provider_Group_Name,
					@s_a_DESCRIPTION  ,
					@s_a_DomainID,
					@s_a_SD_CODE, 
					@s_a_Email_For_Arb_Awards,
					@s_a_Email_For_Invoices,
					@s_a_Email_For_Closing_Reports,
					@s_a_Email_For_Monthly_Report ,
					@s_a_Created_By_User,
					GETDATE()
				   
		      )
		      SET @s_l_message	=  'Provider Group Name details saved successfully'
		      SET @i_l_result		=  SCOPE_IDENTITY()
		      
		      
		      SET @s_l_notes_desc = 'Added Provider Group Name-'+	 @s_a_Provider_Group_Name	


		      EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_User_Id = @s_a_Created_By_User,@s_a_notes_type='Provider Group Name',@DomainID =@s_a_DomainID 
		      COMMIT TRAN 
	    END		
	END
	ELSE
	BEGIN
		BEGIN TRAN
		
		DECLARE @oldProvider_Group_Name VARCHAR(200)

		SET @oldProvider_Group_Name = (SELECT TOP 1 Provider_Group_Name FROM TblProvider_Groups WHERE  Provider_Group_ID = @i_a_Provider_Group_ID and DomainID = @s_a_DomainID )
		
		IF NOT EXISTS(SELECT TOP 1 Provider_Group_Name FROM TblProvider_Groups WHERE  Provider_Group_ID <>  @i_a_Provider_Group_ID and Provider_Group_Name= @s_a_Provider_Group_Name and DomainID = @s_a_DomainID )
		BEGIN
			UPDATE TblProvider_Groups
			SET 
				 Provider_Group_Name		= @s_a_Provider_Group_Name,
				  DESCRIPTION				= @s_a_DESCRIPTION,

				  SD_CODE					= @s_a_SD_CODE,
				 Email_For_Arb_Awards		= @s_a_Email_For_Arb_Awards,
				 Email_For_Invoices			= @s_a_Email_For_Invoices,
			     Email_For_Closing_Reports	= @s_a_Email_For_Closing_Reports,
			     Email_For_Monthly_Report	= @s_a_Email_For_Monthly_Report,
				 modified_by_user			= @s_a_Created_By_User,
				 modified_date		= GETDATE()
			WHERE 
				 Provider_Group_ID = @i_a_Provider_Group_ID
				 and DomainID = @s_a_DomainID

			IF(@s_a_Provider_Group_Name<> @oldProvider_Group_Name)
			BEGIN
				UPDATE tblProvider
				SET Provider_GroupName= @s_a_Provider_Group_Name
				WHERE Provider_GroupName = @oldProvider_Group_Name  and DomainID = @s_a_DomainID 
			END

			SET @s_l_message	=  'Provider Group Name details updated successfully'
			SET @i_l_result	=  @i_a_Provider_Group_ID
		END
		ELSE
		BEGIN
			SET @s_l_message	=  'Provider Group Name already exist. You can not change the stuatus '
			SET @i_l_result	=  @i_a_Provider_Group_ID
		END
		
		
		SET @s_l_notes_desc = 'Updated Provider Group Name-'+	 @s_a_Provider_Group_Name	
            
		EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_User_Id = @s_a_Created_By_User,@s_a_notes_type='Provider Group Name',@DomainID =@s_a_DomainID 
		                                         
		COMMIT TRAN			
	END
	SELECT @s_l_message AS [MESSAGE], @i_l_result AS [RESULT]	

END
