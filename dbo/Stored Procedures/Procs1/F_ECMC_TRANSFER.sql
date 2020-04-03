CREATE PROCEDURE [dbo].[F_ECMC_TRANSFER] --[dbo].[F_ECMC_TRANSFER] 'CELLINI,JOSEPH','','21stCENT','','','','',''
	(
		
		@s_a_FHKP_case_id NVARCHAR(50),
		@s_a_insurance NVARCHAR(255),
		@s_a_user_name NVARCHAR(50)
	
	)
	
	AS
	BEGIN
	DECLARE @desc varchar(200),
			@s_l_message NVARCHAR(500),
			@s_l_insid int,
			@s_l_strfirstname varchar(200),
			@s_l_strlastname varchar(200)
		
		SET @s_l_insid=(SELECT TOP 1 InsuranceCompany_Id FROM tblInsuranceCompany WHERE InsuranceCompany_GroupName like '%'+@s_a_insurance+'%' or InsuranceCompany_Name like '%'+@s_a_insurance+'%')
		SET @s_l_strlastname=(SELECT substring([Patient Name], 1, charindex(',',[Patient Name]) - 1) as LastName from ECMC where FHKP_Case_Id=@s_a_FHKP_case_id)
		SET @s_l_strfirstname=(SELECT substring([Patient Name], charindex(',',[Patient Name]) + 1,len([Patient Name]) - charindex('-',[Patient Name])) as FirstName from ECMC where FHKP_Case_Id=@s_a_FHKP_case_id)
		
		UPDATE TBLCASE
		SET
			
			InsuranceCompany_Id=@s_l_insid,
			Provider_Id=41037,
			InjuredParty_FirstName=@s_l_strfirstname,
			InjuredParty_LastName=@s_l_strlastname
		
		WHERE 
		
			Case_Id =@s_a_FHKP_case_id
			
		SET @s_l_message	=  'ECMC case Transferred successfuly'
		
		--SET @desc = 'ECMC case Transferred'
		--EXEC F_Add_Activity_Notes @s_a_case_id=@s_a_FHKP_case_id,@s_a_notes_type='Activity',@s_a_ndesc = @desc,@s_a_user_Id=@s_a_user_name,@i_a_applytogroup = 0
	
		SELECT @s_l_message AS [MESSAGE]
	END

