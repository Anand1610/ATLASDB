CREATE PROCEDURE [dbo].[F_Case_Search_Save]
(	
	@i_a_query_id					INT,
	@s_a_query_name					NVARCHAR		(MAX),
	@i_a_UserId	INT,
	@s_a_ProviderGroupSel	VARCHAR(MAX)	=	'',
	@s_a_InsuranceGroupSel	VARCHAR(MAX)	=	'',
	@s_a_Case_ID	VARCHAR(100)	=	'',
	@s_a_OldCaseId	VARCHAR(100)	=	'',
	@s_a_InjuredName	VARCHAR(100)	=	'',
	@s_a_InsuredName	VARCHAR(100)	=	'',
	@s_a_IndexOrAAANo	VARCHAR(100)	=	'',
	@s_a_PolicyNo	VARCHAR(100)	=	'',
	@s_a_ClaimNo	VARCHAR(100)	=	'',
	@s_a_InitialStatus	VARCHAR(500)	=	'',
	@s_a_CurrentStatus	VARCHAR(500)	=	'',
	@i_a_DenailReason	INT	=	0,
	@i_a_Court	INT	=	0,
	@i_a_SRL	INT	=	0,
	@i_a_ReviewingDoctor	INT	=	0,
	@i_a_Defendant	INT	=	0,
	@s_a_ProviderGroup	VARCHAR(100)	=	'',
	@s_a_DOSFrom	VARCHAR(100)	=	'',
	@s_a_DOSTo	VARCHAR(100)	=	'',
	@s_a_date_opened_from	VARCHAR(100)	=	'',
	@s_a_date_Opened_To	VARCHAR(100)	=	'',
	@i_a_AgeFrom	INT	=	NULL,
	@i_a_AgeTo	INT	=	NULL
)
AS
BEGIN	
	DECLARE @s_l_message NVARCHAR(MAX)
	DECLARE @i_l_result int
	IF(@i_a_query_id = 0)
	BEGIN
		INSERT INTO tbl_advanced_search_saved_query
		(
			query_name	,
			UserID	,
			Create_Date,
			ProviderGroupSel	,
			InsuranceGroupSel	,
			Case_ID	,
			OldCaseId	,
			InjuredName	,
			InsuredName	,
			IndexOrAAANo	,
			PolicyNo	,
			ClaimNo	,
			InitialStatus	,
			CurrentStatus	,
			DenailReasonId	,
			Court	,
			SRL	,
			ReviewingDoctor	,
			Defendant	,
			ProviderGroup	,
			DOSFrom	,
			DOSTo	,
			date_opened_from	,
			date_Opened_To	,
			AgeFrom	,
			AgeTo
		)
		VALUES
		(
			@s_a_query_name	,
			@i_a_UserId	,
			Getdate()	,
			@s_a_ProviderGroupSel	,
			@s_a_InsuranceGroupSel	,
			@s_a_Case_ID	,
			@s_a_OldCaseId	,
			@s_a_InjuredName	,
			@s_a_InsuredName	,
			@s_a_IndexOrAAANo	,
			@s_a_PolicyNo	,
			@s_a_ClaimNo	,
			@s_a_InitialStatus	,
			@s_a_CurrentStatus	,
			@i_a_DenailReason	,
			@i_a_Court	,
			@i_a_SRL	,
			@i_a_ReviewingDoctor	,
			@i_a_Defendant	,
			@s_a_ProviderGroup	,
			@s_a_DOSFrom	,
			@s_a_DOSTo	,
			@s_a_date_opened_from	,
			@s_a_date_Opened_To	,
			@i_a_AgeFrom	,
			@i_a_AgeTo
		)		
		
		set @i_l_result=@@IDENTITY						
	END
	ELSE
	BEGIN
		UPDATE
			tbl_advanced_search_saved_query
		SET
			query_name	=	@s_a_query_name	,
			UserID	=	@i_a_UserId	,
			Create_Date	=	Getdate()	,
			ProviderGroupSel	=	@s_a_ProviderGroupSel	,
			InsuranceGroupSel	=	@s_a_InsuranceGroupSel	,
			Case_ID	=	@s_a_Case_ID	,
			OldCaseId	=	@s_a_OldCaseId	,
			InjuredName	=	@s_a_InjuredName	,
			InsuredName	=	@s_a_InsuredName	,
			IndexOrAAANo	=	@s_a_IndexOrAAANo	,
			PolicyNo	=	@s_a_PolicyNo	,
			ClaimNo	=	@s_a_ClaimNo	,
			InitialStatus	=	@s_a_InitialStatus	,
			CurrentStatus	=	@s_a_CurrentStatus	,
			DenailReasonId	=	@i_a_DenailReason	,
			Court	=	@i_a_Court	,
			SRL	=	@i_a_SRL	,
			ReviewingDoctor	=	@i_a_ReviewingDoctor	,
			Defendant	=	@i_a_Defendant	,
			ProviderGroup	=	@s_a_ProviderGroup	,
			DOSFrom	=	@s_a_DOSFrom	,
			DOSTo	=	@s_a_DOSTo	,
			date_opened_from	=	@s_a_date_opened_from	,
			date_Opened_To	=	@s_a_date_Opened_To	,
			AgeFrom	=	@i_a_AgeFrom	,
			AgeTo	=	@i_a_AgeTo	

		WHERE
			pk_advanced_search_query_id = @i_a_query_id
				
		set @i_l_result=@i_a_query_id
	END
	
	
	SET @s_l_message = 'Advanced search query details saved successfully'
	SELECT @s_l_message AS [Message],@i_l_result as Result
END

--select * from tbl_advanced_search_saved_query

