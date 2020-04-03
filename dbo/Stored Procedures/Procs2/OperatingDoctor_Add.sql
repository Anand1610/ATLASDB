
CREATE PROCEDURE [dbo].[OperatingDoctor_Add]
(
   @i_a_Doctor_id			INT,
   @s_a_Doctor_Name			VARCHAR(100),
   @s_a_Active			    NVARCHAR(200),
   @s_a_DomainID			VARCHAR(50),   
   @s_a_Created_By_User		VARCHAR(100)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	-- select * from tblOperatingDoctor
	-- Doctor_id	Doctor_Name
	SET NOCOUNT ON;
	DECLARE @i_l_result		 INT
	DECLARE @s_l_message	 NVARCHAR(500)
	DECLARE @s_l_Doctor_Name VARCHAR(200)
	DECLARE @s_l_notes_desc	 NVARCHAR(MAX)
	
	IF(@i_a_Doctor_id = 0)
	BEGIN
	    IF EXISTS(SELECT Doctor_Name FROM tblOperatingDoctor WHERE Doctor_Name = @s_a_Doctor_Name and DomainID = @s_a_DomainID)
	    BEGIN
	       SET @s_l_message		=  'Doctor already exists..!!!'
		   SET @i_l_result		=  SCOPE_IDENTITY()
	    END
	    ELSE
	    BEGIN
	          BEGIN TRAN
		      INSERT INTO tblOperatingDoctor
		      (
			      Doctor_Name,
				  DomainID,	
				  Active,						
			      created_by_user,
			      created_date
		      )
		      VALUES
		      (
                  @s_a_Doctor_Name,
				  @s_a_DomainID,				 
				  @s_a_Active,				
                  @s_a_Created_By_User,
                  GETDATE()
		      )
		      SET @s_l_message		=  'Doctor details saved successfully'
		      SET @i_l_result		=  SCOPE_IDENTITY()
		      
		      
		      SET @s_l_notes_desc = 'Added Doctor -'+	 @s_a_Doctor_Name	


		      EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_User_Id = @s_a_Created_By_User,@s_a_notes_type='Operating Doctor',@DomainID =@s_a_DomainID 
		      COMMIT TRAN 
	    END		
	END
	ELSE
	BEGIN
		BEGIN TRAN
		
		DECLARE @oldDoctor_Name VARCHAR(200)

		SET @oldDoctor_Name = (SELECT TOP 1 Doctor_Name FROM tblOperatingDoctor WHERE  Doctor_id = @i_a_Doctor_id and DomainID = @s_a_DomainID )
		
		IF NOT EXISTS(SELECT TOP 1 Doctor_Name FROM tblOperatingDoctor WHERE  Doctor_id <>  @i_a_Doctor_id and Doctor_Name= @s_a_Doctor_Name and DomainID = @s_a_DomainID )
		BEGIN
			UPDATE tblOperatingDoctor
			SET 
				 Doctor_Name		= @s_a_Doctor_Name,                 							
				 Active			    = @s_a_Active,				
				 modified_by_user	= @s_a_Created_By_User,
				 modified_date		= GETDATE()
			WHERE 
				 Doctor_id = @i_a_Doctor_id
				 and DomainID = @s_a_DomainID
		
			SET @s_l_message	=  'Doctor details updated successfully'
			SET @i_l_result		=  @i_a_Doctor_id
		END
		ELSE
		BEGIN
			SET @s_l_message	=  'Doctor name already exist. You can not change the Doctor name '
			SET @i_l_result		=  @i_a_Doctor_id
		END
		
		
		SET @s_l_notes_desc = 'Updated Doctor -'+	 @s_a_Doctor_Name	
            
		      EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_User_Id = @s_a_Created_By_User,@s_a_notes_type='Operating Doctor',@DomainID =@s_a_DomainID 
		                                         
		COMMIT TRAN			
	END
	SELECT @s_l_message AS [MESSAGE], @i_l_result AS [RESULT]	

END
