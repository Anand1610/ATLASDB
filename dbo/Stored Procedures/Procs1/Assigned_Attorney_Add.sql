

CREATE PROCEDURE [dbo].[Assigned_Attorney_Add]
(
   @i_a_Assigned_Attorney_Id INT,
   @s_a_Assigned_Attorney VARCHAR(100),
   @s_a_Address NVARCHAR(200),
   @s_a_Phone  NVARCHAR(200),
   @s_a_Fax NVARCHAR(200),
   @s_a_Email NVARCHAR(200),
   @s_a_DomainID VARCHAR(50),
   @s_a_Created_By_User VARCHAR(100),
   @LawFirm_Name VARCHAR(200)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	--select * from Assigned_Attorney
	--Assigned_Attorney_ID	Assigned_Attorney
	SET NOCOUNT ON;
	DECLARE @i_l_result	INT
	DECLARE @s_l_message	NVARCHAR(500)
	DECLARE @s_l_Assigned_AttorneyType	VARCHAR(200)
	DECLARE @s_l_notes_desc	NVARCHAR(MAX)
	
	IF(@i_a_Assigned_Attorney_Id = 0)
	BEGIN
	    IF EXISTS(SELECT Assigned_Attorney FROM Assigned_Attorney (NOLOCK) WHERE Assigned_Attorney = @s_a_Assigned_Attorney and DomainID = @s_a_DomainID)
	    BEGIN
	       SET @s_l_message	=  'Assigned Attorney already exists..!!!'
		   SET @i_l_result		=  SCOPE_IDENTITY()
	    END
	    ELSE
	    BEGIN
	          BEGIN TRAN
		      INSERT INTO Assigned_Attorney
		      (
			      Assigned_Attorney,
				  DomainID,
			      created_by_user,
			      created_date,
				  LawFirm_Name,
				  Assigned_Attorney_Address,
				  Assigned_Attorney_Phone,
				  Assigned_Attorney_Fax,
				  Assigned_Attorney_Email
		      )
		      VALUES
		      (
                  @s_a_Assigned_Attorney,
				  @s_a_DomainID,
                  @s_a_Created_By_User,
                  GETDATE(),
				  @LawFirm_Name,
				  @s_a_Address,
				  @s_a_Phone,
				  @s_a_Fax,
				  @s_a_Email
		      )
		      SET @s_l_message	=  'Assigned Attorney details saved successfuly'
		      SET @i_l_result		=  SCOPE_IDENTITY()
		      
		      
		      SET @s_l_notes_desc = 'Added Assigned Attorney-'+	 @s_a_Assigned_Attorney	


		      EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_User_Id = @s_a_Created_By_User,@s_a_notes_type='Assigned Attorney',@DomainID =@s_a_DomainID 
		      COMMIT TRAN 
	    END		
	END
	ELSE
	BEGIN
		IF NOT EXISTS(SELECT Assigned_Attorney FROM Assigned_Attorney (NOLOCK) WHERE Assigned_Attorney = @s_a_Assigned_Attorney and DomainID = @s_a_DomainID and PK_Assigned_Attorney_ID <> @i_a_Assigned_Attorney_Id)
		BEGIN
			BEGIN TRAN
		
			DECLARE @oldAssigned_Attorney VARCHAR(200)

			SET @oldAssigned_Attorney = (SELECT TOP 1 Assigned_Attorney FROM Assigned_Attorney (NOLOCK) WHERE  PK_Assigned_Attorney_ID = @i_a_Assigned_Attorney_Id and DomainID = @s_a_DomainID )
		
			--IF(@s_a_Assigned_Attorney<> @oldAssigned_Attorney)
			--BEGIN
				UPDATE Assigned_Attorney
				SET 
					 Assigned_Attorney		= @s_a_Assigned_Attorney,
					 modified_by_user	= @s_a_Created_By_User,
					 modified_date		= GETDATE(),
					 LawFirm_Name=@LawFirm_Name,
					 Assigned_Attorney_Address=@s_a_Address,
					 Assigned_Attorney_Phone=@s_a_Phone,
					 Assigned_Attorney_Fax=@s_a_Fax,
					 Assigned_Attorney_Email=@s_a_Email
				WHERE 
					 PK_Assigned_Attorney_ID = @i_a_Assigned_Attorney_Id
					 and DomainID = @s_a_DomainID

				----UPDATE tblCASE
				----SET Assigned_Attorney= @s_a_Assigned_Attorney
				----WHERE Assigned_Attorney = @oldAssigned_Attorney  and DomainID = @s_a_DomainID 
			--END

			SET @s_l_message	=  'Assigned Attorney details updated successfuly'
			SET @i_l_result	=  @i_a_Assigned_Attorney_Id
		
			SET @s_l_notes_desc = 'Updated Assigned Attorney-'+	 @s_a_Assigned_Attorney	
            
				  EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_User_Id = @s_a_Created_By_User,@s_a_notes_type='Assigned Attorney',@DomainID =@s_a_DomainID 
		                                         
			COMMIT TRAN		
		END
		ELSE
		BEGIN
			SET @s_l_message	=  'Cannot save, Assigned Attorney already exist...' 
			SET @i_l_result	=  @i_a_Assigned_Attorney_Id
		END			
	END
	SELECT @s_l_message AS [MESSAGE], @i_l_result AS [RESULT]	

END
