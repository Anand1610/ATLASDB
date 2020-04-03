
CREATE PROCEDURE [dbo].[Court_Type_Add]
(
   @i_a_Court_Id		INT,
   @s_a_Court_Name	    VARCHAR(100),
   @s_a_DomainID	    VARCHAR(50),   
   @s_a_Court_Venue	    NVARCHAR(100),
   @s_a_Court_Address	NVARCHAR(200),
   @s_a_Court_Basis     NVARCHAR(200),
   @s_a_Court_Misc      VARCHAR(200),
   @s_a_Created_By_User	VARCHAR(100),
   @s_a_County varchar(500) = null,
   @s_a_State varchar(250)  = null,
   @s_a_City varchar(250)	= null,
   @s_a_Zip varchar(20)		= null
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	-- select * from Court_Name
	-- Court_Id	Court_Name
	SET NOCOUNT ON;
	DECLARE @i_l_result			INT
	DECLARE @s_l_message		NVARCHAR(500)
	DECLARE @s_l_Court_Name		VARCHAR(200)
	DECLARE @s_l_notes_desc		NVARCHAR(MAX)
	
	IF(@i_a_Court_Id = 0)
	BEGIN
	    IF EXISTS(SELECT Court_Name FROM tblCourt WHERE Court_Name = @s_a_Court_Name and DomainID = @s_a_DomainID)
	    BEGIN
	       SET @s_l_message		=  'Court name already exists..!!!'
		   SET @i_l_result		=  SCOPE_IDENTITY()
	    END
	    ELSE
	    BEGIN
	          BEGIN TRAN
		      INSERT INTO tblCourt
		      (
			      Court_Name,
				  DomainID,
				  Court_Venue,
				  Court_Address,
				  Court_Basis,
				  Court_Misc,	
				  County,
				  State, 
				  city,
				  Zip,
			      created_by_user,
			      created_date
		      )
		      VALUES
		      (
                  @s_a_Court_Name,
				  @s_a_DomainID,				
				  @s_a_Court_Venue,
				  @s_a_Court_Address,
				  @s_a_Court_Basis,
				  @s_a_Court_Misc,	
				  @s_a_County,
				  @s_a_State,
				  @s_a_City,
				  @s_a_Zip,
                  @s_a_Created_By_User,
                  GETDATE()
		      )
		      SET @s_l_message		=  'Court details saved successfully'
		      SET @i_l_result		=  SCOPE_IDENTITY()
		      
		      
		      SET @s_l_notes_desc = 'Added Court -'+	 @s_a_Court_Name	


		      EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_User_Id = @s_a_Created_By_User,@s_a_notes_type='Court',@DomainID =@s_a_DomainID 
		      COMMIT TRAN 
	    END		
	END
	ELSE
	BEGIN
		BEGIN TRAN
		
		DECLARE @oldCourt_Name VARCHAR(200)

		SET @oldCourt_Name = (SELECT TOP 1 Court_Name FROM tblCourt WHERE  Court_Id = @i_a_Court_Id and DomainID = @s_a_DomainID )
		
		IF NOT EXISTS(SELECT TOP 1 Court_Name FROM tblCourt WHERE  Court_Id <>  @i_a_Court_Id and Court_Name= @s_a_Court_Name and DomainID = @s_a_DomainID )
		BEGIN
			UPDATE tblCourt
			SET 
				 Court_Name		= @s_a_Court_Name,                 			
				 Court_Venue	= @s_a_Court_Venue,
				 Court_Address	= @s_a_Court_Address,
				 Court_Basis	= @s_a_Court_Basis,
				 Court_Misc	    = @s_a_Court_Misc,
				  County		= @s_a_County,
				  State			= @s_a_State, 
				  city			= @s_a_City,
				  Zip			= @s_a_Zip,
				 modified_by_user	= @s_a_Created_By_User,
				 modified_date		= GETDATE()
			WHERE 
				 Court_Id = @i_a_Court_Id
				 and DomainID = @s_a_DomainID

		
			SET @s_l_message	=  'Court details updated successfully'
			SET @i_l_result		=  @i_a_Court_Id
		END
		ELSE
		BEGIN
			SET @s_l_message	=  'Court name already exist. You can not change the court name '
			SET @i_l_result		=  @i_a_Court_Id
		END
		
		
		SET @s_l_notes_desc = 'Updated Court -'+	 @s_a_Court_Name	
            
		      EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_User_Id = @s_a_Created_By_User,@s_a_notes_type='Court_Name',@DomainID =@s_a_DomainID 
		                                         
		COMMIT TRAN			
	END
	SELECT @s_l_message AS [MESSAGE], @i_l_result AS [RESULT]	

END
