CREATE PROCEDURE [dbo].[F_Case_Activity_ADD]
(
	@s_a_Case_id			VARCHAR(100),
	@s_a_activity_category	VARCHAR(100),
	@s_a_Description		VARCHAR(Max),
	@dt_a_FollowUp_Dt		DATETIME=null,
	@b_a_is_Email			bit,
	@s_a_Group_IDs			VARCHAR(MAX),
	@s_a_User_IDs			VARCHAR(MAX),
	@s_a_E_Subject			VARCHAR(MAX),
	@s_a_E_To				VARCHAR(MAX),
	@i_a_created_user_id	INT
)
AS
BEGIN
DECLARE @s_l_message VARCHAR(MAX)
DECLARE @i_l_Result INT 


		insert into tbl_case_activity
		(
			   case_id
			,  activity_category
			,  activity_date
			,  description
			,  followup_date
			,  is_email
			,  email_subject
			,  email_to
			,  Created_User_ID
			,  created_date
		)
		values
		(
			@s_a_Case_id
			,  @s_a_activity_category
			,  GETDATE()
			,  @s_a_Description
			,  @dt_a_FollowUp_Dt
			,  @b_a_is_Email
			,  @s_a_E_Subject
			,  @s_a_E_To
			,  @i_a_created_user_id
			,  GETDATE()
		)
		SET @i_l_Result= IDENT_CURRENT('tbl_case_activity')
		
		IF (@s_a_User_IDs <> '')
		BEGIN
			INSERT INTO tbl_case_activity_user_mapping 
			SELECT @i_l_Result,items FROM dbo.SplitStringInt(@s_a_User_IDs,',')
		END
		
		IF (@s_a_Group_IDs <> '')
		BEGIN
			INSERT INTO tbl_case_activity_group_mapping 
			SELECT @i_l_Result,items FROM dbo.SplitStringInt(@s_a_Group_IDs,',')
		END
		
		
		SET @s_l_message=  'Case Activity saved successfully'
		select  @s_l_message aS MESSAGE,  @i_l_Result AS RESULT


END

