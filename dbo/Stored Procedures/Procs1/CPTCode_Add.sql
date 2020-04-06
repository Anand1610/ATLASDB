CREATE PROCEDURE [dbo].[CPTCode_Add] -- [CPTCode_Add] 'localhost',0,'99989','DESC'
(
   @s_a_DomainID			VARCHAR(50),  
   @s_a_CaseID		VARCHAR(50),
   @i_a_CPT_ATUO_ID			INT,
   @s_a_CPTCode				VARCHAR(100),
   @s_a_Description			NVARCHAR(200) = null,
   @s_a_CPT_Amount	MONEY = null,
   @s_a_DOS      NVARCHAR(200)= null,
   @s_a_Ins_FS_Amount     MONEY= null,
   @s_a_Specialty	NVARCHAR(200)= null,
   @i_a_TreatmentID		INT= null,
   @s_a_Created_By_User		VARCHAR(100) ='admin',
   @s_a_MOD VARCHAR(50),
   @s_a_Units INT,
   @s_a_ICD10_1 VARCHAR(100),
   @s_a_ICD10_2 VARCHAR(100),
   @s_a_ICD10_3 VARCHAR(100),
   @Auto_Proc_id int =null,
   @FeeSchedule money=null
   --@s_a_refund_date VARCHAR(20)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	SET NOCOUNT ON;
	DECLARE @i_l_result				INT
	DECLARE @s_l_message			NVARCHAR(500)
	DECLARE @s_l_notes_desc			NVARCHAR(MAX)
	
	IF(@i_a_CPT_ATUO_ID = 0)
	BEGIN
	    BEGIN
	          BEGIN TRAN
		      INSERT INTO BILLS_WITH_PROCEDURE_CODES
		      (
			      BillNumber,
				  Code,
				  Description,
				  Amount,
				  DOS,
				  ins_fee_schedule,
				  Specialty,
				  fk_Treatment_Id,	
				  Case_ID,
				  DomainID,		
			      created_by_user,
			      created_date,
				  MOD,
				  UNITS,
				  ICD10_1,
				  ICD10_2,
				  ICD10_3,
				  Auto_Proc_id,
				  FeeSchedule
		      )
		      VALUES
		      (
					'',
					@s_a_CPTCode,
					@s_a_Description,
					@s_a_CPT_Amount,
					@s_a_DOS,
					@s_a_Ins_FS_Amount,
					@s_a_Specialty,
					@i_a_TreatmentID,
					@s_a_CaseID,
					@s_a_DomainID,
					@s_a_Created_By_User,
					GETDATE(),
					@s_a_MOD,
					@s_a_Units,
					@s_a_ICD10_1,
					@s_a_ICD10_2,
					@s_a_ICD10_3,
					@Auto_Proc_id,
					@FeeSchedule
		      )
		      SET @s_l_message		=  'CPT details saved successfully'
		      SET @i_l_result		=  SCOPE_IDENTITY()
		      
		      set @s_l_notes_desc = 'CPT Details Added :'+' $'+ CONVERT(VARCHAR(10),@s_a_CPT_Amount)+' '+'('+ ISNULL(@s_a_CPTCode,'')+') Desc->'+ ISNULL(@s_a_Description,'')
			  exec LCJ_AddNotes @DomainId=@s_a_DomainID, @case_id=@s_a_CaseID,@notes_type='Activity' ,@NDesc=@s_l_notes_desc,@user_id=@s_a_Created_By_User,@applytogroup=0
		      COMMIT TRAN 
	    END		
	END
	ELSE
	BEGIN
		BEGIN TRAN
			UPDATE BILLS_WITH_PROCEDURE_CODES
			SET 
				  BillNumber = '',
				  Code	=	@s_a_CPTCode,
				  Description	=	@s_a_Description,
				  Amount	=	@s_a_CPT_Amount,
				  DOS		=	@s_a_DOS,
				  ins_fee_schedule	=	@s_a_Ins_FS_Amount,
				  Specialty			=	@s_a_Specialty,
				  modified_by_user	= @s_a_Created_By_User,
				  modified_date		= GETDATE(),
				  MOD=@s_a_MOD,
				  UNITS=@s_a_Units,
				  ICD10_1=@s_a_ICD10_1,
				  ICD10_2=@s_a_ICD10_2,
				  ICD10_3=@s_a_ICD10_3,
				  Auto_Proc_id=@Auto_Proc_id,
				  FeeSchedule=@FeeSchedule
			WHERE 
				 CPT_ATUO_ID = @i_a_CPT_ATUO_ID
				 and DomainID = @s_a_DomainID

		

			SET @s_l_message	=  'CPT details updated successfully'
			SET @i_l_result		=  @i_a_CPT_ATUO_ID

			
			set @s_l_notes_desc = 'CPT Details Updated :'+' $'+ CONVERT(VARCHAR(10),@s_a_CPT_Amount)+' '+'('+ ISNULL(@s_a_CPTCode,'')+') Desc->'+ ISNULL(@s_a_Description,'')
			exec LCJ_AddNotes @DomainId=@s_a_DomainID, @case_id=@s_a_CaseID,@notes_type='Activity' ,@NDesc=@s_l_notes_desc,@user_id=@s_a_Created_By_User,@applytogroup=0
		                       
		COMMIT TRAN			
	END
	SELECT @s_l_message AS [MESSAGE], @i_l_result AS [RESULT]	

END