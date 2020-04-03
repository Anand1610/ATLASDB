
CREATE PROCEDURE [dbo].[Provider_Group_Name_Delete]
(
   @i_a_Provider_Group_ID INT,
   @s_a_Provider_Group_Name VARCHAR(100),
   @s_a_DomainID VARCHAR(50),
   @s_a_Created_By_User VARCHAR(100)--,
   --@s_a_DESCRIPTION                     VARCHAR(200),
   --@s_a_SD_CODE                         VARCHAR(50), 
   --@s_a_Email_For_Arb_Awards            VARCHAR(200),
   --@s_a_Email_For_Invoices              NVARCHAR(200),
   --@s_a_Email_For_Closing_Reports       NVARCHAR(200),
   --@s_a_Email_For_Monthly_Report	    NVARCHAR(200)
)

AS
BEGIN
	 DECLARE @s_l_message				NVARCHAR(500),
			 @s_l_notes_desc				NVARCHAR(500)
			
	 BEGIN
		IF EXISTS(SELECT Provider_GroupName FROM tblProvider WHERE Provider_GroupName = @s_a_Provider_Group_Name and  DomainID =@s_a_DomainID )
	    BEGIN
	       SET @s_l_message	=  'Provider Group Name exists in Provider..!!!'
	    END
	    ELSE
	    BEGIN
			BEGIN TRAN
	        
	        DELETE FROM TblProvider_Groups  WHERE Provider_Group_ID = @i_a_Provider_Group_ID and  DomainID =@s_a_DomainID 
	        
			SET @s_l_message= 'Provider Group Name deleted'
			SET @s_l_notes_desc = 'Provider Group Name deleted - ' + @s_a_Provider_Group_Name 
		    
		    EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_user_Id=@s_a_Created_By_User,@s_a_notes_type='Provider Group Name',@DomainID =@s_a_DomainID 
		    
		    COMMIT TRAN 
		END	
		
		SELECT @s_l_message AS [MESSAGE]
		
	 END	
END

