
CREATE PROCEDURE [dbo].[Status_Add]
(
   @i_a_Status_Id			INT,
   @s_a_Status				VARCHAR(100),
   @s_a_DomainID			VARCHAR(50),   
   @s_a_Status_Hierarchy	INT,
   @s_a_Auto_bill_amount	MONEY,
   @s_a_Auto_bill_type      NVARCHAR(200),
   @s_a_Auto_bill_notes     VARCHAR(200),
   @s_a_Status_Description	NVARCHAR(200),
   @s_a_Final_Status        NVARCHAR(200),
   @s_a_IsActive			NVARCHAR(200),
   @s_a_forum				NVARCHAR(200),
   @s_a_Filed_Unfiled       NVARCHAR(200),
   @s_a_hierarchy_Id		INT, 
   @s_a_Created_By_User		VARCHAR(100)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	-- select * from Status
	-- Status_ID	Status
	SET NOCOUNT ON;
	DECLARE @i_l_result				INT
	DECLARE @s_l_message			NVARCHAR(500)
	DECLARE @s_l_Status		VARCHAR(200)
	DECLARE @s_l_notes_desc			NVARCHAR(MAX)
	
	IF(@i_a_Status_Id = 0)
	BEGIN
	    IF EXISTS(SELECT Status_Type FROM tblStatus WHERE Status_Type = @s_a_Status and DomainID = @s_a_DomainID)
	    BEGIN
	       SET @s_l_message		=  'Status Type already exists..!!!'
		   SET @i_l_result		=  SCOPE_IDENTITY()
	    END
	    ELSE
	    BEGIN
	          BEGIN TRAN
		      INSERT INTO tblStatus
		      (
			      Status_Type,
				  DomainID,
				  Status_Abr,
				  Status_Hierarchy,
				  Auto_bill_amount,
				  Auto_bill_type,
				  Auto_bill_notes,
				  Status_Description,
				  Final_Status,
				  IsActive,
				  forum,
				  Filed_Unfiled,
				  hierarchy_Id,				
			      created_by_user,
			      created_date
		      )
		      VALUES
		      (
                  @s_a_Status,
				  @s_a_DomainID,
				  @s_a_Status,
				  @s_a_Status_Hierarchy,
				  @s_a_Auto_bill_amount,
				  @s_a_Auto_bill_type,
				  @s_a_Auto_bill_notes,
				  @s_a_Status_Description,
				  @s_a_Final_Status,
				  @s_a_IsActive,
				  @s_a_forum,
				  @s_a_Filed_Unfiled,
				  @s_a_hierarchy_Id	,
				 
                  @s_a_Created_By_User,
                  GETDATE()
		      )
		      SET @s_l_message		=  'Status Type details saved successfully'
		      SET @i_l_result		=  SCOPE_IDENTITY()
		      
		      
		      SET @s_l_notes_desc = 'Added Status Type-'+	 @s_a_Status	


		      EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_User_Id = @s_a_Created_By_User,@s_a_notes_type='Status',@DomainID =@s_a_DomainID 
		      COMMIT TRAN 
	    END		
	END
	ELSE
	BEGIN
		BEGIN TRAN
		
		DECLARE @oldStatus VARCHAR(200)

		SET @oldStatus = (SELECT TOP 1 Status_Type FROM tblStatus WHERE  Status_Id = @i_a_Status_Id and DomainID = @s_a_DomainID )
		
		IF NOT EXISTS(SELECT TOP 1 Status_Type FROM tblStatus WHERE  Status_Id <>  @i_a_Status_Id and Status_Type= @s_a_Status and DomainID = @s_a_DomainID )
		BEGIN
			UPDATE tblStatus
			SET 
				 Status_Type		= @s_a_Status,                 			
				 Status_Abr			= @s_a_Status,
				 Status_Hierarchy	= @s_a_Status_Hierarchy,
				 Auto_bill_amount	= @s_a_Auto_bill_amount,
				 Auto_bill_type		= @s_a_Auto_bill_type,
				 Auto_bill_notes	= @s_a_Auto_bill_notes,
				 Status_Description	= @s_a_Status_Description,
				 Final_Status		= @s_a_Final_Status,
				 IsActive			= @s_a_IsActive,
				 forum				= @s_a_forum,
				 Filed_Unfiled		= @s_a_Filed_Unfiled,
				 hierarchy_Id		= @s_a_hierarchy_Id	,
			
				 modified_by_user	= @s_a_Created_By_User,
				 modified_date		= GETDATE()
			WHERE 
				 Status_Id = @i_a_Status_Id
				 and DomainID = @s_a_DomainID

			IF(@s_a_Status<> @oldStatus)
			BEGIN
				UPDATE tblCASE
				SET Status		= @s_a_Status
				WHERE Status	= @oldStatus  and DomainID = @s_a_DomainID 
			END

			SET @s_l_message	=  'Status Type details updated successfully'
			SET @i_l_result		=  @i_a_Status_Id

			
			SET @s_l_notes_desc = 'Updated Status Type-'+	 @s_a_Status	
            
		    EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_User_Id = @s_a_Created_By_User,@s_a_notes_type='Status',@DomainID =@s_a_DomainID 
		   
		END
		ELSE
		BEGIN
			SET @s_l_message	=  'Status Type already exist. You can not change the status '
			SET @i_l_result		=  @i_a_Status_Id
		END
		                                      
		COMMIT TRAN			
	END
	SELECT @s_l_message AS [MESSAGE], @i_l_result AS [RESULT]	

END
