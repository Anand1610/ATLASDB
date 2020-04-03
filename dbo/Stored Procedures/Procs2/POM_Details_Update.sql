CREATE PROCEDURE [dbo].[POM_Details_Update] -- [POMCode_Add] 'localhost',0,'99989','DESC'
(
   @s_a_DomainID	VARCHAR(40),  
   @s_a_CaseID VARCHAR(40),  
   @i_a_TreatmentID		INT,
   @s_a_POM_ID VARCHAR(16) = null,
   @dt_a_POM_Created	DATETIME = Null,
   @dt_a_POM_Stampped DATETIME = Null,
   @s_a_Created_By_User VARCHAR(40)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;
	DECLARE @i_l_result				INT
	DECLARE @s_l_message			NVARCHAR(500)
	DECLARE @s_l_notes_desc			NVARCHAR(MAX)
	
			BEGIN TRAN

			UPDATE tblTreatment
			SET 
				  Date_BillSent = @dt_a_POM_Stampped,
				  pom_created_date = @dt_a_POM_Created,
				  pom_id	=	@s_a_POM_ID
			WHERE 
				 Treatment_Id = @i_a_TreatmentID
				 and DomainID = @s_a_DomainID
				 and case_id = @s_a_CaseID

			SET @s_l_message	=  'POM details updated successfully'
			SET @i_l_result		=  @i_a_TreatmentID

			
			set @s_l_notes_desc = 'POM Details Updated'
			exec LCJ_AddNotes @DomainId=@s_a_DomainID, @case_id=@s_a_CaseID,@notes_type='Activity' ,@NDesc=@s_l_notes_desc,@user_id=@s_a_Created_By_User,@applytogroup=0
		                       
		COMMIT TRAN			
	
	SELECT @s_l_message AS [MESSAGE], @i_l_result AS [RESULT]	

END
