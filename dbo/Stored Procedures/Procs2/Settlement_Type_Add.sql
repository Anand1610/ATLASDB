CREATE PROCEDURE [dbo].[Settlement_Type_Add]
(
   @i_a_Settlement_Type_Id INT,
   @s_a_Settlement_Type VARCHAR(100),
   @s_a_DomainID VARCHAR(50),
   @s_a_Created_By_User VARCHAR(100)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	--select * from Settlement_Type
	--Settlement_Type_ID	Settlement_Type
	SET NOCOUNT ON;
	DECLARE @i_l_result	INT
	DECLARE @s_l_message	NVARCHAR(500)
	DECLARE @s_l_Settlement_Type	VARCHAR(200)
	DECLARE @s_l_notes_desc	NVARCHAR(MAX)
	
	IF(@i_a_Settlement_Type_Id = 0)
	BEGIN
	    IF EXISTS(SELECT Settlement_Type FROM tblSettlement_Type WHERE Settlement_Type = @s_a_Settlement_Type and DomainID = @s_a_DomainID)
	    BEGIN
	       SET @s_l_message	=  'Settlement Type already exists..!!!'
		   SET @i_l_result		=  SCOPE_IDENTITY()
	    END
	    ELSE
	    BEGIN
	          BEGIN TRAN
		      INSERT INTO tblSettlement_Type
		      (
			      Settlement_Type,
				  DomainID,
			      created_by_user,
			      created_date
		      )
		      VALUES
		      (
                  @s_a_Settlement_Type,
				  @s_a_DomainID,
                  @s_a_Created_By_User,
                  GETDATE()
		      )
		      SET @s_l_message	=  'Settlement Type details saved successfully'
		      SET @i_l_result		=  SCOPE_IDENTITY()
		      
		      
		      SET @s_l_notes_desc = 'Added Settlement Type-'+	 @s_a_Settlement_Type	


		      EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_User_Id = @s_a_Created_By_User,@s_a_notes_type='Settlement Type',@DomainID =@s_a_DomainID 
		      COMMIT TRAN 
	    END		
	END
	ELSE
	BEGIN
		IF NOT EXISTS(SELECT Settlement_Type FROM tblSettlement_Type WHERE Settlement_Type = @s_a_Settlement_Type and DomainID = @s_a_DomainID and SettlementType_Id <> @i_a_Settlement_Type_Id)
		BEGIN
			BEGIN TRAN
		
			DECLARE @oldSettlement_Type VARCHAR(200)

			SET @oldSettlement_Type = (SELECT TOP 1 Settlement_Type FROM tblSettlement_Type WHERE  SettlementType_Id = @i_a_Settlement_Type_Id and DomainID = @s_a_DomainID )
		

			

			IF(@s_a_Settlement_Type<> @oldSettlement_Type)
			BEGIN
				UPDATE tblSettlement_Type
				SET 
					 Settlement_Type		= @s_a_Settlement_Type,
					 modified_by_user	= @s_a_Created_By_User,
					 modified_date		= GETDATE()
				WHERE 
					 SettlementType_Id = @i_a_Settlement_Type_Id
					 and DomainID = @s_a_DomainID


				--UPDATE tblSettlements
				--SET Settlement_Type= @s_a_Settlement_Type
				--WHERE Settlement_Type = @oldSettlement_Type  and DomainID = @s_a_DomainID 



				SET @s_l_notes_desc = 'Updated Settlement Type-'+	 @s_a_Settlement_Type	
            
				EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_User_Id = @s_a_Created_By_User,@s_a_notes_type='Settlement Type',@DomainID =@s_a_DomainID 
		        
			END

			SET @s_l_message	=  'Settlement Type details updated successfully'
			SET @i_l_result	=  @i_a_Settlement_Type_Id
		
			                                 
			COMMIT TRAN		
		END
		ELSE
		BEGIN
			SET @s_l_message	=  'Cannot save, Settlement Type already exist...' --Settlement Type details updated successfully'
			SET @i_l_result	=  @i_a_Settlement_Type_Id
		END
	END
	SELECT @s_l_message AS [MESSAGE], @i_l_result AS [RESULT]	

END
