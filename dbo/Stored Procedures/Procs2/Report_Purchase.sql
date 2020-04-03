
CREATE PROCEDURE [dbo].[Report_Purchase] 
-- [Report_CaseDetails_PurchaseTest] 'amt','','12/19/2018','12/19/2018',46,'',''
	@s_a_DomainId varchar(40),
	@s_a_status varchar(200)='',
	@dt_a_FromDate varchar(50)='',
	@dt_a_ToDate varchar(50)='',
	@i_a_PortfolioId int=0,
	@dt_a_invFromDate varchar(50)='',
	@dt_a_invToDate varchar(50)=''
AS
BEGIN
	 SET NOCOUNT ON 
     
	 If @dt_a_FromDate =''
	 BEGIN
	   Set @dt_a_FromDate = @dt_a_ToDate
	 END
	 Else If @dt_a_ToDate = ''
	 BEGIN
	  Set @dt_a_ToDate = @dt_a_FromDate
	 END

	  If @dt_a_invFromDate =''
	 BEGIN
	   Set @dt_a_invFromDate = @dt_a_invToDate
	 END
	 Else If @dt_a_invToDate = ''
	 BEGIN
	  Set @dt_a_invToDate = @dt_a_invFromDate
	 END

	CREATE TABLE #TempVol (
		  VCaseId VARCHAR(50)
		, VPay DECIMAL(18,2)		
		, VDate DATETIME		
		, VDedct DECIMAL(18,2)		
		, VIntr DECIMAL(18,2)
		, VTransID INT
		, RowNum INT	
		, CPT_ATUO_ID INT
		)

--Query to insert into temp table
INSERT INTO #TempVol (VCaseId, VPay,VDate,VDedct,VIntr,VTransID,RowNum,CPT_ATUO_ID)
SELECT r.*
		FROM
		(
			SELECT
				VP.Case_Id
				, ISNULL(cpt.Current_Paid,0.00) AS Total_Collection
				, Transaction_Date
				, ISNULL(cpt.Current_Deductible,0.00) AS Deductible
				, ISNULL(cpt.Current_Interest,0.00) AS Pre_Interest
				, Transactions_Id
				, dense_rank() OVER(PARTITION BY VP.Case_Id ORDER BY VP.Case_Id,  Transactions_Id ASC) rn
				, bc.CPT_ATUO_ID
		   FROM tblcase Cas (NOLOCK) 
				INNER JOIN tbl_Voluntary_Payment VP (NOLOCK) ON cas.Case_Id=VP.Case_Id
				INNER JOIN tblCase_Date_Details (NOLOCK) ON tblCase_Date_Details.Case_Id= VP.Case_Id
				INNER JOIN tbl_CPT_Payment_Details cpt(NOLOCK) on cpt.Transaction_Id = vp.Voluntary_Pay_Id  
				INNER JOIN BILLS_WITH_PROCEDURE_CODES bc (NOLOCK) on bc.CPT_ATUO_ID=cpt.CPT_ATUO_ID
				WHERE cas.DomainId=@s_a_DomainId AND ISNULL(cas.IsDeleted, 0) = 0
				--AND Transaction_Date < tblCase_Date_Details.Date_Case_Purchased
				--and cas.case_id='AMT18-102455'
				AND VP.Payment_Type = 'V'   
				AND (@dt_a_invToDate = '' or Transaction_Date <= @dt_a_invToDate)
                AND (ISNULL(cpt.Current_Paid,0.00) > 0 or ISNULL(cpt.Current_Deductible,0.00) > 0 or ISNULL(cpt.Current_Interest,0.00) > 0 or ISNULL(cpt.Current_AttorneyFee,0.00) > 0)
		) r
		WHERE r.rn <= 3
		ORDER BY r.[Transactions_Id] ASC

--Query to insert into temp table Ends here

	 
--Query to insert into temp table Ends here

	 SELECT distinct 
		cod.CPT_ATUO_ID, 
		cas.case_id,
		UPPER(LTRIM(RTRIM(cas.InjuredParty_FirstName))) AS InjuredParty_FirstName,
		UPPER(LTRIM(RTRIM(cas.InjuredParty_LastName))) AS InjuredParty_LastName,
		REPLACE(LTRIM(RTRIM(LEFT(ins.InsuranceCompany_Name,15))),',', ' ') AS [InsuranceCompany_Name],
		CONVERT(VARCHAR(10),CONVERT(DATETIME,cod.DOS), 120) [DOS],
		REPLACE(pf.Description,',',' ') [Project_Code],
		REPLACE(LTRIM(RTRIM(LEFT(pro.Provider_Name,15))),',',' ') As Medical_Provider,
		REPLACE(cod.Specialty,',',' ')[Specialty],
		Tre.Bill_number[Bill_number],
		Tre.account_number as Patient_no_Medic,
		Convert(varchar(10), cas.Accident_Date, 120) Accident_Date,
		(select top 1 Doctor_Name from tblOperatingDoctor o (NOLOCK) left outer join tblTreatment t (NOLOCK) on t.Doctor_Id=o.Doctor_Id where t.Case_Id=cas.Case_Id)[DOCTOR_NAME],
		cas.injuredparty_lastname,
		cod.code,
		cod.amount,
		cod.MOD,
		cod.UNITS,
		cod.ICD10_1,
		cod.ICD10_2,
		cod.ICD10_3,



		Convert(varchar(10), tre.Date_BillSent, 120) AS billing_date,
		REPLACE(cod.Specialty,',',' ') AS [bill_type],
		(isnull(cast(cod.Amount as float),0))[total_billed_amt],
		--(Select SUM(ISNULL(BCOD.Amount,0)) from tbltreatment Trtmnt 
		--INNER JOIN BILLS_WITH_PROCEDURE_CODES BCOD ON BCOD.fk_Treatment_Id = Trtmnt.Treatment_Id where Trtmnt.case_id=Tre.case_id)[total_billed_amt],
		ISNULL(cod.Bill_Adjustment,0.00) AS Bill_Adjustment,
	    (SELECT VPay FROM #TempVol tep  WHERE tep.VCaseId=cas.Case_Id AND RowNum=1 AND tep.CPT_ATUO_ID = cod.CPT_ATUO_ID)as TT_PreC_1,
		(SELECT convert(varchar(10), VDate,120) FROM #TempVol tep  WHERE tep.VCaseId=cas.Case_Id AND RowNum=1 AND tep.CPT_ATUO_ID = cod.CPT_ATUO_ID)as TD_PreC_1,

		(SELECT VPay FROM #TempVol tep  WHERE tep.VCaseId=cas.Case_Id AND RowNum=2 AND tep.CPT_ATUO_ID = cod.CPT_ATUO_ID)as TT_PreC_2,
		(SELECT convert(varchar(10), VDate,120) FROM #TempVol tep  WHERE tep.VCaseId=cas.Case_Id AND RowNum=2 AND tep.CPT_ATUO_ID = cod.CPT_ATUO_ID)as TD_PreC_2,

		(SELECT VPay FROM #TempVol tep  WHERE tep.VCaseId=cas.Case_Id AND RowNum=3 AND tep.CPT_ATUO_ID = cod.CPT_ATUO_ID)as TT_PreC_3,
		(SELECT convert(varchar(10), VDate,120) FROM #TempVol tep  WHERE tep.VCaseId=cas.Case_Id AND RowNum=3 AND tep.CPT_ATUO_ID = cod.CPT_ATUO_ID)as TD_PreC_3,

		--(SELECT convert(varchar(10), VDate,120) FROM #TempVol tep  WHERE tep.VCaseId=cas.Case_Id AND RowNum=2 AND tep.CPT_ATUO_ID = cod.CPT_ATUO_ID)as TD_PreC_2,
		--(SELECT VPay FROM #TempVol tep  WHERE tep.VCaseId=cas.Case_Id AND RowNum=3 AND tep.CPT_ATUO_ID = cod.CPT_ATUO_ID)as TT_PreC_3,	
		--(SELECT convert(varchar(10), VDate,120) FROM #TempVol tep  WHERE tep.VCaseId=cas.Case_Id AND RowNum=3 AND tep.CPT_ATUO_ID = cod.CPT_ATUO_ID) AS TD_PreC_3,
		--VDedct AS Deductible,
		--VIntr  as Interest,
              ISNULL(cod.Deductible,0.00) as Deductible,
	    ISNULL(cod.Intrest,0.00) as Interest,
		 
		--CAST(isnull((Select ISNULL(Tre.Amount,0) from tbltreatment Trtmnt INNER JOIN BILLS_WITH_PROCEDURE_CODES BCOD ON BCOD.fk_Treatment_Id = Trtmnt.Treatment_Id where 
		--Trtmnt.case_id=Tre.case_id ),0) AS FLOAT)
		--- CAST(ISNULL(cod.Bill_Adjustment,0) AS FLOAT) - CAST(ISNULL((SELECT ISNULL(VPay,0.00) FROM #TempVol tep WHERE tep.VCaseId=cas.Case_Id AND tep.CPT_ATUO_ID 
		--= cod.CPT_ATUO_ID), 0.00) AS FLOAT) 
		--- CAST(ISNULL((SELECT ISNULL(VDedct,0.00) FROM #TempVol tep  WHERE tep.VCaseId=cas.Case_Id AND tep.CPT_ATUO_ID = cod.CPT_ATUO_ID), 0.00) AS FLOAT) 
		--+ CAST(ISNULL((SELECT ISNULL(VIntr,0.00) FROM #TempVol tep  WHERE tep.VCaseId=cas.Case_Id AND tep.CPT_ATUO_ID = cod.CPT_ATUO_ID), 0.00) AS FLOAT) AS Purchase_Balance,
		

		--((CAST(isnull((Select ISNULL(BCOD.Amount,0) from tbltreatment Trtmnt INNER JOIN BILLS_WITH_PROCEDURE_CODES BCOD ON BCOD.fk_Treatment_Id = Trtmnt.Treatment_Id where Trtmnt.case_id=Tre.case_id ),0)AS FLOAT)
		--- CAST(ISNULL(cod.Bill_Adjustment,0) AS FLOAT) - CAST(ISNULL((SELECT SUM(ISNULL(VPay,0.00)) FROM #TempVol tep  WHERE tep.VCaseId=cas.Case_Id AND tep.CPT_ATUO_ID = cod.CPT_ATUO_ID), 0.00) AS FLOAT) 
		--- CAST(ISNULL((SELECT SUM(ISNULL(VDedct,0.00)) FROM #TempVol tep  WHERE tep.VCaseId=cas.Case_Id AND tep.CPT_ATUO_ID = cod.CPT_ATUO_ID), 0.00) AS FLOAT) + CAST(ISNULL((SELECT SUM(ISNULL(VIntr,0.00)) FROM #TempVol tep  WHERE tep.VCaseId=cas.Case_Id AND tep.CPT_ATUO_ID = cod.CPT_ATUO_ID), 0.00) AS FLOAT))
		-- *(CASE WHEN CAST(ISNULL(Advance_Rate,0)AS FLOAT) > 0 then CAST(ISNULL(Advance_Rate,0)AS FLOAT) ELSE 1 END))/ 100 AS Purchase_Price,
		

	    ISNULL(cod.Amount,0)-CAST(ISNULL(cod.Bill_Adjustment,0) AS FLOAT) - ISNULL(cod.Deductible,0.00) - ISNULL(cod.Intrest,0.00) 
		
		as Purchase_Balance,
		(ISNULL(cod.Amount,0)-CAST(ISNULL(cod.Bill_Adjustment,0) AS FLOAT) - ISNULL(cod.Deductible,0.00) - ISNULL(cod.Intrest,0.00))*.36 AS Purchase_Price,
		cas.Policy_Number,
		REPLACE(REPLACE(cas.Memo, CHAR(13), ''), CHAR(10), '')[Note],
		First_Party_Case_Status,
		convert(varchar(10), casDt.CASE_EVALUATION_DATE,120) AS CASE_EVALUATION_DATE,
		convert(varchar(10), casDt.First_Party_Suit_Filed_Date,120)[First_Party_Suit_Filed_Date],
		REPLACE(crt.Court_Name,',', ' ') as court_type,
		REPLACE(crt.Court_Venue,',', ' ') as court_county,
		--(iif(Attorney_FirstName IS NULL,'', Attorney_FirstName) +' ' + iif(Attorney_LastName IS NULL, '', Attorney_LastName)) as First_Party_Attorney,
		--First_Party_LawFirm,
		(Select TOP 1 ISNULL(Attorney_FirstName,'') + ' ' + ISNULL(Attorney_LastName,'') as First_Party_Attorney from tblAttorney_Case_Assignment aca(NOLOCK) inner join tblAttorney_Master am(NOLOCK) on am.Attorney_Id=aca.Attorney_Id
		inner join tblAttorney_Type atp(NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id Where lower(Attorney_Type) = 'plaintiff attorney' and aca.Case_Id = cas.Case_Id and aca.DomainId = cas.DomainId) as First_Party_Attorney,
		(Select TOP 1 ISNULL(LawFirmName,'') as First_Party_Attorney from tblAttorney_Case_Assignment aca(NOLOCK) inner join tblAttorney_Master am(NOLOCK) on am.Attorney_Id=aca.Attorney_Id
		inner join tblAttorney_Type atp(NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id Where lower(Attorney_Type) = 'plaintiff attorney' and aca.Case_Id = cas.Case_Id and aca.DomainId = cas.DomainId) as First_Party_LawFirm,
		REPLACE(REPLACE(Attorney_frmBiller_Note, CHAR(13), ''), CHAR(10), '') AS Attorney_frmBiller_Note,
		REPLACE(Our_Attorney,',',' ') AS Our_Attorney,
		REPLACE(Our_Attorney_Law_Firm,',',' ') AS Our_Attorney_Law_Firm,
		REPLACE(Law_Suit_Type,',',' ') AS Law_Suit_Type,
		convert(varchar(10), cod.Purchase_Freeze_Date,120)[InvDate]
	FROM tblcase cas (NOLOCK)
	INNER JOIN tblInsuranceCompany ins (NOLOCK) ON cas.InsuranceCompany_Id = ins.InsuranceCompany_Id
	LEFT JOIN tbltreatment Tre (NOLOCK) on cas.case_id=Tre.case_id 
	LEFT OUTER JOIN BILLS_WITH_PROCEDURE_CODES cod (NOLOCK) on cod.fk_Treatment_Id = Tre.Treatment_Id
	LEFT JOIN tbl_CPT_Payment_Details cpt(NOLOCK) on cpt.CPT_ATUO_ID = cod.CPT_ATUO_ID
	--LEFT OUTER JOIN tbl_Voluntary_Payment v_pay (NOLOCK) on v_pay.Voluntary_Pay_Id = cpt.Transaction_Id AND v_pay.Payment_Type = 'V'
	LEFT OUTER JOIN tblProvider pro (NOLOCK) ON cas.Provider_Id = pro.Provider_Id
	--((ISNULL(cod.BillNumber,'') = ISNULL(Tre.BILL_NUMBER,'') AND ISNULL(Tre.BILL_NUMBER,'') <> '') OR Treatment_id = ISNULL(fk_Treatment_Id,0))
	LEFT OUTER JOIN tblCase_additional_info det (NOLOCK) on det.case_id=cas.Case_Id
	LEFT OUTER JOIN tblCase_Date_Details casDt (NOLOCK) ON cas.Case_Id=casDt.Case_Id
	LEFT OUTER JOIN tblCourt crt (NOLOCK) on crt.Court_Id=cas.Court_Id
	--LEFT OUTER JOIN tblAttorney_Case_Assignment cass (NOLOCK) on cass.Case_Id = cas.Case_Id
	--LEFT OUTER JOIN tblAttorney_Master am (NOLOCK) on cass.Attorney_Id = am.Attorney_Id
	LEFT OUTER JOIN tbl_Portfolio pf (NOLOCK) on pf.Id = cas.PortfolioId
	LEFT OUTER JOIN tbl_Program tbPr (NOLOCK) ON pf.ProgramId = tbPr.Id
	--LEFT OUTER JOIN #TempVol Tem  ON cas.Case_Id=Tem.VCaseId
	WHERE cas.DomainId=@s_a_DomainId AND ISNULL(cas.IsDeleted, 0) = 0 --and cas.case_id='AMT18-102455'
		AND (@s_a_status = '' OR cas.Status = @s_a_status)
		AND ((@dt_a_FromDate='' AND @dt_a_ToDate='') OR (Tre.Date_BillSent BETWEEN CONVERT(datetime,@dt_a_FromDate) AND CONVERT(datetime,@dt_a_ToDate)))		
		--AND ((@dt_a_invFromDate='' AND @dt_a_invToDate='') OR (cas.inv_date BETWEEN CONVERT(datetime,@dt_a_invFromDate) AND CONVERT(datetime,@dt_a_invToDate) + 1 ))		
		AND (
		  (@dt_a_invFromDate='' AND @dt_a_invToDate='')
		OR
	     (@dt_a_invFromDate<>'' AND @dt_a_invToDate<>'' AND cod.Purchase_Freeze_Date BETWEEN CONVERT(datetime,@dt_a_invFromDate) AND CONVERT(datetime,@dt_a_invToDate))
		)	
		AND ( @i_a_PortfolioId = 0 OR cas.PortfolioId = @i_a_PortfolioId)
		AND Convert(decimal(18,2), iif(cas.Claim_Amount is null or ltrim(rtrim(cas.Claim_Amount)) ='', '0', cas.Claim_Amount)) > Convert(decimal(18,2),0)
		
		--AND isnull(cas.Claim_Amount,0) > 0
	--GROUP BY 
	--	cas.Case_Id,
	--	cas.InjuredParty_FirstName,
	--	cas.InjuredParty_LastName,
	--	cas.InsuranceCompany_Id,
	--	cas.DateOfService_Start,
	--	cas.DateOfService_End,
	--	cas.Accident_Date,
	--	cas.Date_BillSent,
	--	cas.Claim_Amount,
	--	pf.Description,
	--	pro.Provider_Name,
	--	cod.Specialty,
	--	Tre.BILL_NUMBER,
	--	Tre.account_number,
	--	cod.Code,
	--	cod.Amount,
	--	cod.MOD,
	--	cod.UNITS,
	--	cod.ICD10_1,
	--	cod.ICD10_2,
	--	cod.ICD10_3,
	--	det.Bill_Adjustment,
	--	tbPr.Advance_Rate,
	--	cas.Policy_Number,
	--	cas.Memo,
	--	det.First_Party_Case_Status,
	--	casDt.CASE_EVALUATION_DATE,
	--	casDt.First_Party_Suit_Filed_Date,
	--	crt.Court_Name,
	--	crt.Court_Venue,
	--	am.Attorney_FirstName,
	--	am.Attorney_LastName,
	--	det.First_Party_LawFirm,
	--	det.Attorney_frmBiller_Note,
	--	det.Our_Attorney,
	--	det.Our_Attorney_Law_Firm,
	--	det.Law_Suit_Type,
	--	cas.inv_date


		DROP TABLE #TempVol

		--Select Case_Id, Total_Collection, Deductible, Pre_Interest, Voluntary_AF, Convert(varchar(50), Transaction_Date, 101) as Transaction_Date 
		--from tbl_Voluntary_Payment (NOLOCK) where  DomainId = @s_a_DomainId AND Payment_Type = 'V'


END



