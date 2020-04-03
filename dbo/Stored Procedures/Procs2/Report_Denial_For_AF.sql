
CREATE PROCEDURE [dbo].[Report_Denial_For_AF] --Report_Denial_For_AF @domainId=N'af', @s_a_Denial_Date_From='12/10/2019',@s_a_Denial_Date_To='12/26/2019',@s_a_ProviderId=0
--[Report_Denial_For_AF] 'af',@s_a_ProviderId=0,@s_a_Denial_Date_From='01/01/2019',@s_a_Denial_Date_To='01/01/2019',@s_a_Denial_Posted_Date_From='01/01/2019', @s_a_Denial_Posted_Date_To='03/01/2019'
--exec Report_Denial_For_AF @domainId=N'af',@s_a_ProviderId=N'0',@s_a_ProviderGroup=N'CIRCULAR SYMMETRY ACUPUNCTURE PC',@s_a_Denial_Date_From=N'01/01/2017',@s_a_Denial_Date_To=N'01/31/2019',@s_a_Denial_Posted_Date_From=N'01/01/2017',@s_a_Denial_Posted_Date_To=N'01/31/2019',@s_a_DenialReasons_ID=N'296,278,289,298,276,277,291,346,288,283,282,345'
	@domainId					VARCHAR(50),
	@s_a_ProviderId				int,
	@s_a_ProviderGroup			varchar(100)='',
	@s_a_Denial_Date_From	VARCHAR(50)=null,
	@s_a_Denial_Date_To		VARCHAR(50)=null,
	@s_a_Denial_Posted_Date_From	VARCHAR(50)=null,
	@s_a_Denial_Posted_Date_To		VARCHAR(50)=null,
	@s_a_DenialReasons_ID		VARCHAR(MAX)=''
	
AS
BEGIN
	SELECT 	Case_Id,
			Notes_Date
	INTO	#temp
	FROM	tblNotes t (NOLOCK)
	WHERE	DomainId = 	@domainId
	AND		Case_Id LIKE 'ACT%'
	AND		Notes_Desc LIKE '%BILLING - DENIAL%'
	AND 
			(
				@s_a_Denial_Posted_Date_From = '' OR (t.Notes_Date is not null AND convert(date,t.Notes_Date) >= CONVERT(date,@s_a_Denial_Posted_Date_From))
			)
			AND
			(
				@s_a_Denial_Posted_Date_To = '' OR (t.Notes_Date is not null AND convert(date,t.Notes_Date) <= CONVERT(date,@s_a_Denial_Posted_Date_To))
			)
	--select * from #temp
	 SELECT distinct
			tre.Treatment_Id, 
			cas.Case_Id AS Case_Id,
			tre.BILL_NUMBER AS BILL_NUMBER,
			CONVERT(VARCHAR(10),tre.DateOfService_Start,101) AS DateOfService_Start,
			CONVERT(VARCHAR(10),tre.DateOfService_End,101) AS DateOfService_End,
			pro.Provider_Name AS Provider_Name,
			cas.InjuredParty_LastName + ', ' + cas.InjuredParty_FirstName as InjuredParty_Name,
			ins.InsuranceCompany_Name AS InsuranceCompany_Name, 
			pro.Provider_Local_Address AS Provider_Local_Address,
			cas.Accident_Date,
			CONVERT(VARCHAR(10),tre.Date_BillSent, 101) AS BillDate_submitted,   
			tre.SERVICE_TYPE AS SERVICE_TYPE,
			convert(decimal(38,2),(convert(money,convert(float,tre.Claim_Amount)))) as Claim_Amount,
			convert(decimal(38,2),(convert(money,convert(float,tre.Paid_Amount)))) as Paid_Amount,
			convert(money,(convert(float,tre.Claim_Amount)) - convert(money,convert(float,tre.Paid_Amount))) as Claim_Balance,
			convert(decimal(38,2),convert(money,convert(float,tre.Fee_Schedule))) as Fee_Schedule,
			convert(money,(convert(float,tre.Claim_Amount)) - convert(money,convert(float,tre.Fee_Schedule))) as FS_Balance,
			cas.Initial_Status AS Initial_Status,
			cas.Status AS Status,
			cas.Old_Status,
			pro.Provider_GroupName AS Provider_GroupName,
			MAX(doc.DOCTOR_NAME) AS DOCTOR_NAME,
			tre.DenialDate AS DenialDate,
			tre.IMEDate AS IMEDate,
			tre.Notes AS Notes,
			dr.DenialReasons_Type AS DenialReasons_Type,
			CASE WHEN ISNULL(t.Notes_Date,'') <> '' THEN CONVERT(VARCHAR(10),t.Notes_Date,101) 
			ELSE '' 
			END AS DenialPostedDate

		FROM	dbo.tblTreatment tre WITH (NOLOCK)
		JOIN	dbo.tblCase cas WITH (NOLOCK) on cas.Case_Id= tre.Case_Id
		LEFT	JOIN dbo.tblprovider pro WITH (NOLOCK) on cas.provider_id=pro.provider_id 
		LEFT	JOIN dbo.tblInsuranceCompany ins WITH (NOLOCK) on cas.insurancecompany_id=ins.insurancecompany_id
		LEFT	JOIN tblOperatingDoctor doc WITH (NOLOCK) on  doc.Doctor_Id =tre.Doctor_Id 
		LEFT    JOIN TXN_tblTreatment t_tre  WITH (NOLOCK) on (tre.treatment_id = t_tre.Treatment_Id AND tre.DomainId = t_tre.DomainId)
		JOIN	tblDenialReasons dr ON(dr.DenialReasons_Id=tre.DenialReason_ID AND dr.DomainId = cas.DomainId)
		JOIN   #temp t ON t.Case_Id = tre.Case_Id
		WHERE
			cas.DomainId =@domainId
			AND cas.CASE_ID LIKE 'ACT%'
			AND 
			(
				@s_a_Denial_Posted_Date_From = '' OR (t.Notes_Date is not null AND convert(date,t.Notes_Date) >= CONVERT(date,@s_a_Denial_Posted_Date_From))
			)
			AND
			(
				@s_a_Denial_Posted_Date_To = '' OR (t.Notes_Date is not null AND convert(date,t.Notes_Date) <= CONVERT(date,@s_a_Denial_Posted_Date_To))
			)
			AND (@s_a_ProviderId = '0' OR cas.Provider_Id = @s_a_ProviderId)
			AND (@s_a_ProviderGroup = '' OR pro.Provider_GroupName = @s_a_ProviderGroup)
			AND (@s_a_DenialReasons_ID = '' 
			--OR	tre.DenialReason_ID IN (SELECT items FROM dbo.SplitStringInt(@s_a_DenialReasons_ID,','))
			OR		dr.DenialReasons_Id IN (SELECT items FROM dbo.SplitStringInt(@s_a_DenialReasons_ID,','))
			--OR	t_tre.DenialReasons_Id IN (SELECT items FROM dbo.SplitStringInt(@s_a_DenialReasons_ID,','))
			)
		group by
		tre.Treatment_Id, 
		cas.DomainId,
		cas.Case_Id,
		dr.DenialReasons_Type,
		cas.Accident_Date,
		pro.Provider_Name,
		pro.Provider_Local_Address,
		cas.InjuredParty_LastName,
		cas.InjuredParty_FirstName,
		ins.InsuranceCompany_Name,
		cas.Initial_Status,
		cas.Status,
		cas.Old_Status,
		pro.Provider_GroupName,
		tre.BILL_NUMBER,
		tre.DateOfService_Start,
		tre.DateOfService_End,
		tre.Date_BillSent,
		tre.SERVICE_TYPE,
		tre.Claim_Amount,
		tre.Paid_Amount,
		tre.Fee_Schedule
		,tre.DenialDate,
		tre.IMEDate,
		tre.Notes,
		t.Notes_Date
END
