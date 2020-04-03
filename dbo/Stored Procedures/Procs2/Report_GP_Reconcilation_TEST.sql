
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Report_GP_Reconcilation_TEST] -- [GP_Reconcilation_Report] 'AMT'
	@s_a_DomainId nvarchar(50),
	@s_a_status nvarchar(100)='',
	@i_a_PortfolioId int=0,
	@dt_a_invFromDate nvarchar(50)='',
	@dt_a_invToDate nvarchar(50)='',
	@i_a_UserId int
AS
BEGIN

	SET NOCOUNT ON 

    If @dt_a_invFromDate =''
	 BEGIN
	   Set @dt_a_invFromDate = @dt_a_invToDate
	 END
	 Else If @dt_a_invToDate = ''
	 BEGIN
	  Set @dt_a_invToDate = @dt_a_invFromDate
	 END

	 Declare @s_a_UserType Varchar(50);

	 Select @s_a_UserType = LTRIM(RTRIM(UserType)) from IssueTracker_Users(NOLOCK) where userid = @i_a_UserId


	 CREATE TABLE #TempVol (
		  VCaseId VARCHAR(50)
		, VPay DECIMAL(18,2)		
		, VDate DATETIME		
		, VDedct DECIMAL(18,2)		
		, VIntr DECIMAL(18,2)
		, VCheckDate DATETIME
		, VCheckNo VARCHAR(100)
		, VAttorneyF DECIMAL(18,2)
		, VNetPay DECIMAL(18,2)
		, VTransID INT
		, VAL_PAY_Freeze_Date DATETIME
		, Accounting_Date DATETIME
		, Transaction_Description VARCHAR(500)
		, RowNum INT
		, CPT_ATUO_ID INT
		, ChqDepositedDate DateTime
		,DOS Datetime
		)

		CREATE TABLE #TempLit (
		  VCaseId VARCHAR(50)
		, VTotCol1 DECIMAL(18,2)	
		, VCortFee1 DECIMAL(18,2)
		, VLitFee1 DECIMAL(18,2)
		, VNetLitCol1 DECIMAL(18,2)	
		, VLitPayDt1 DATETIME
		, VLitPayNo1 VARCHAR(100)	
		, VLitChkDt1 DATETIME		
		, VTransID INT
		, LIT_PAY_Freeze_Date DATETIME
		, Accounting_Date DATETIME
		, Transaction_Description VARCHAR(500)
		, RowNum INT	
		, CPT_ATUO_ID INT
		,DOS Datetime
		)


		--Query to insert into temp table for Voluntary Payment
INSERT INTO #TempVol (VCaseId, VPay,VDate,VDedct,VIntr,VCheckDate,VCheckNo,VAttorneyF,VNetPay,VTransID,VAL_PAY_Freeze_Date,Accounting_Date,Transaction_Description, RowNum, CPT_ATUO_ID
   ,ChqDepositedDate, DOS)
		SELECT r.*
		FROM
		(
			SELECT
				VP.Case_Id
				,ISNULL(cpt.Current_Paid,0.00) AS Total_Collection,
				 VP.Transaction_Date
				,ISNULL(cpt.Current_Deductible,0.00) AS Deductible
				,ISNULL(cpt.Current_Interest,0.00) AS Pre_Interest
				,Check_Date
				,Check_No
				,ISNULL(cpt.Current_AttorneyFee,0.00) AS Voluntary_AF
				, ((ISNULL(cpt.Current_Paid,0.00)+ISNULL(cpt.Current_Interest,0.00))-(ISNULL(cpt.Current_Deductible,0.00)+ISNULL(cpt.Current_AttorneyFee,0.00))) as VNetPay
				,VP.Transactions_Id
				,cpt.VAL_PAY_Freeze_Date
				,bc.Purchase_Freeze_Date
				,REPLACE(REPLACE(vp.Transaction_Description, CHAR(13), ''), CHAR(10), '') AS Transaction_Description
	            --,ROW_NUMBER() OVER(PARTITION BY VP.Case_Id, bc.CPT_ATUO_ID ORDER BY VP.Transactions_Id asc) rn
			   -- ,dense_rank() OVER(partition by  cas.case_id  order by  cas.case_id, VP.Transactions_Id ) rn
				
				   ,dense_rank() OVER(partition by  cas.case_id  order by  cas.case_id, VP.Check_No ) rn
				,bc.CPT_ATUO_ID
				, trdate =(Select top 1 TR.Transactions_Date FROM tblTransactions TR (NOLOCK) where Cas.Case_Id=TR.Case_Id and VP.Case_Id =TR.Case_Id and VP.Check_No = TR.ChequeNo),
				bc.dos
		   FROM tblcase Cas (NOLOCK) INNER JOIN tbl_Voluntary_Payment VP (NOLOCK) ON cas.Case_Id=VP.Case_Id
				LEFT JOIN tblCase_Date_Details (NOLOCK) ON tblCase_Date_Details.Case_Id= VP.Case_Id
				LEFT JOIN tbl_CPT_Payment_Details cpt(NOLOCK) on cpt.Transaction_Id = vp.Voluntary_Pay_Id  
				LEFT JOIN BILLS_WITH_PROCEDURE_CODES bc (NOLOCK) on bc.CPT_ATUO_ID=cpt.CPT_ATUO_ID
				
				WHERE cas.DomainId=@s_a_DomainId AND ISNULL(cas.IsDeleted,0) = 0
				--AND Transaction_Date < tblCase_Date_Details.Date_Case_Purchased
				AND VP.Payment_Type = 'V'   
				AND (@dt_a_invToDate = '' or Transaction_Date <= @dt_a_invToDate)
                AND (ISNULL(cpt.Current_Paid,0.00) > 0 or ISNULL(cpt.Current_Deductible,0.00) > 0 or ISNULL(cpt.Current_Interest,0.00) > 0 or ISNULL(cpt.Current_AttorneyFee,0.00) > 0)
		) r
		WHERE r.rn <= 3

		 ; with cte as(
  SELECT cptpd.Case_ID, DOS, Current_Paid
   ,row_number() OVER(partition by DOS, cptpd.case_id order by DOS, cptpd.case_id ) rn
  FROM tbl_CPT_Payment_Details cptpd (NOLOCK) INNER JOIN BILLS_WITH_PROCEDURE_CODES cod (NOLOCK) ON cptpd.CPT_ATUO_ID=cod.CPT_ATUO_ID 
  INNER JOIN tblcase cas (NOLOCK) ON cas.DomainId=@s_a_DomainId and cptpd.Case_ID=cas.Case_Id and cas.Case_Id=cod.Case_ID

  where cptpd.DomainId=@s_a_DomainId   and ISNULL(cas.IsDeleted,0)=0 and cod.DomainID=@s_a_DomainId 
   AND (ISNULL(cptpd.Current_Paid,0.00) > 0 ))

  select * into #tempVolpayment from cte

		--ORDER BY r.[Transactions_Id] asc

		--Select * from #TempVol where VCaseId = 'AMT19-103306'
--Query to insert into temp table Ends here


--Query to insert into temp table for Litigated Payment
INSERT INTO #TempLit (VCaseId, VTotCol1,VCortFee1,VLitFee1,VNetLitCol1,VLitPayDt1,VLitPayNo1,VLitChkDt1,VTransID,LIT_PAY_Freeze_Date,Accounting_Date,Transaction_Description, RowNum, CPT_ATUO_ID, DOS)
		SELECT r.*
		FROM
		(
			SELECT
				 VP.Case_Id
				,cpt.Current_LIT_Paid as Total_Collection
				,cpt.Current_LIT_CourtFee as Court_Fees
				--,cpt.Current_LIT_Paid as Litigated_Collection
				,cpt.Current_LIT_Fees
				,((cpt.Current_LIT_Paid+cpt.Current_LIT_Interest)-(cpt.Current_LIT_Fees+cpt.Current_LIT_CourtFee)) AS VNetLitCol1
				,Transaction_Date
				,check_no
				,Check_Date
				,Transactions_Id
				,cpt.LIT_PAY_Freeze_Date
				,bc.Purchase_Freeze_Date
				,REPLACE(REPLACE(vp.Transaction_Description, CHAR(13), ''), CHAR(10), '') AS Transaction_Description
				,ROW_NUMBER() OVER(PARTITION BY VP.Case_Id, bc.CPT_ATUO_ID ORDER BY Transactions_Id asc) rn
				,bc.CPT_ATUO_ID
				,bc.DOS
		   FROM tblcase Cas (NOLOCK) INNER JOIN tbl_Voluntary_Payment VP (NOLOCK) ON cas.Case_Id=VP.Case_Id
				LEFT JOIN tblCase_Date_Details (NOLOCK) ON tblCase_Date_Details.Case_Id= VP.Case_Id
				LEFT JOIN tbl_CPT_Payment_Details cpt(NOLOCK) on cpt.Transaction_Id = vp.Voluntary_Pay_Id  
				LEFT JOIN BILLS_WITH_PROCEDURE_CODES bc (NOLOCK) on bc.CPT_ATUO_ID=cpt.CPT_ATUO_ID
				WHERE cas.DomainId=@s_a_DomainId AND ISNULL(cas.IsDeleted,0)=0
				--AND Transaction_Date < tblCase_Date_Details.Date_Case_Purchased
				AND VP.Payment_Type = 'L'   
				AND (@dt_a_invToDate = '' or Transaction_Date <= @dt_a_invToDate)
		        AND (ISNULL(cpt.Current_LIT_Paid,0.00) > 0 or ISNULL(cpt.Current_LIT_Interest,0.00) > 0 or ISNULL(cpt.Current_LIT_Fees,0.00) > 0 or ISNULL(cpt.Current_LIT_CourtFee,0.00) > 0)
		) r
		WHERE r.rn <= 3
		--ORDER BY r.[Transactions_Id] asc

--Query to insert into temp table Ends here

	Select 
	distinct 
	cas.case_id,
	replace(UPPER(LTRIM(RTRIM(cas.InjuredParty_FirstName))),',',' ') AS InjuredParty_FirstName,
	replace(UPPER(LTRIM(RTRIM(cas.InjuredParty_LastName))),',',' ') AS InjuredParty_LastName,
	replace(LTRIM(RTRIM(LEFT(ins.InsuranceCompany_Name,15))),',',' ') AS InsuranceCompany_Name,
	CONVERT(VARCHAR(10),CONVERT(DATETIME,cod.DOS), 120) [DOS],
	replace(pf.Description,',',' ') [Project_Code],
	replace(pro.Provider_Name,',',' ') As Medical_Provider,


	--replace(cod.Specialty,',',' ')[Specialty],

	 (select MAX(replace(cod10.Specialty,',',' ')) from BILLS_WITH_PROCEDURE_CODES cod10 with(nolock)  where cod10.DOS=cod.DOS and 
	cod10.Case_ID = cod.Case_ID and cas.Case_Id=cod10.Case_ID) [Specialty],


	--replace(Tre.Bill_number,',',' ')[Bill_number],
	replace(ISNULL(Tre.Bill_number,''),',',' ')[Bill_number],

	Tre.account_number As Patient_no_Medic,
	Convert(varchar(10), cas.Accident_Date, 120) Accident_Date,
	(select top 1 replace(Doctor_Name,',',' ') from tblOperatingDoctor o (NOLOCK) left outer join tblTreatment t (NOLOCK) on t.Doctor_Id=o.Doctor_Id where t.Case_Id=cas.Case_Id)[DOCTOR_NAME],
	replace(cas.injuredparty_lastname,',',' ') As injuredparty_lastname,
	--cod.code,
		 (select MAX(cod9.Code) from BILLS_WITH_PROCEDURE_CODES cod9 with(nolock)  where cod9.DOS=cod.DOS and 
	cod9.Case_ID = cod.Case_ID and cas.Case_Id=cod9.Case_ID) AS code,

	(select sum(ISNULL(amount,0)) from BILLS_WITH_PROCEDURE_CODES cod2 with(nolock) where cod2.dos=cod.DOS and cod2.Case_ID = cod.Case_ID and cas.Case_Id=cod2.Case_ID) as amount,
	--cod.MOD,
	--cod.UNITS,
	(select max(cod7.MOD) from BILLS_WITH_PROCEDURE_CODES cod7 with(nolock) where cod7.dos=cod.DOS and cod7.Case_ID = cod.Case_ID and cas.Case_Id=cod7.Case_ID) as MOD,
	(select max(cod6.UNITS) from BILLS_WITH_PROCEDURE_CODES cod6 with(nolock) where cod6.dos=cod.DOS and cod6.Case_ID = cod.Case_ID and cas.Case_Id=cod6.Case_ID) as UNITS,

	case when  cod.ICD10_1 is null then 0 else 0 end as ICD10_1,
	case when  cod.ICD10_2 is null then 0 else 0 end as ICD10_2,
	case when  cod.ICD10_3 is null then 0 else 0 end as ICD10_3,
	--Convert(varchar(10), tre.Date_BillSent, 120) AS billing_date,
	'' AS billing_date,
	--cod.Specialty[bill_type],

	(select MAX(replace(cod11.Specialty,',',' ')) from BILLS_WITH_PROCEDURE_CODES cod11 with(nolock)  where cod11.DOS=cod.DOS and 
	cod11.Case_ID = cod.Case_ID and cas.Case_Id=cod11.Case_ID) [bill_type],

		(select sum(ISNULL(amount,0)) from BILLS_WITH_PROCEDURE_CODES cod2 where cod2.dos=cod.DOS and cod2.Case_ID = cod.Case_ID and cas.Case_Id=cod2.Case_ID)[total_billed_amt],

	--(isnull(cast(cod.Amount as float),0))[total_billed_amt],
	--(Select SUM(ISNULL(BCOD.Amount,0)) from tbltreatment Trtmnt 
	--INNER JOIN BILLS_WITH_PROCEDURE_CODES BCOD ON BCOD.fk_Treatment_Id = Trtmnt.Treatment_Id where Trtmnt.case_id=Tre.case_id)[total_billed_amt],
	cod.Bill_Adjustment,

	--convert(varchar(10), cod.Purchase_Freeze_Date, 120) as Accounting_Date,

	(select MIN(convert(varchar(10), cod3.Purchase_Freeze_Date, 120)) from BILLS_WITH_PROCEDURE_CODES cod3 where cod3.dos=cod.DOS and 
	cod3.Case_ID = cod.Case_ID and cas.Case_Id=cod3.Case_ID) as Accounting_Date,


	--(SELECT VPay FROM #TempVol tep (NOLOCK) WHERE tep.VCaseId=cas.Case_Id AND RowNum=1 AND tep.CPT_ATUO_ID = cod.CPT_ATUO_ID) as TT_Vol_1,
	
	(Select   sum(Current_Paid)
	 FROM  #tempVolpayment tvp where tvp.case_Id=cas.Case_id and rn=1 and tvp.DOS=cod.dos  and tvp.Case_ID=cod.Case_ID
	)
	
	
	as TT_Vol_1,
	(SELECT max(convert(varchar(10), VDate,120)) FROM #TempVol tep (NOLOCK) WHERE tep.VCaseId=cas.Case_Id AND RowNum=1
	--AND tep.CPT_ATUO_ID = cod.CPT_ATUO_ID
	AND tep.DOS = cod.DOS) as TD_Vol_1 , -- Deposited date
	(SELECT MAX(convert(varchar(10), VCheckDate,120)) FROM #TempVol tep (NOLOCK) WHERE tep.VCaseId=cas.Case_Id AND RowNum=1 AND tep.DOS = cod.DOS) as TD_Vol_Check_1 ,
	--AND tep.CPT_ATUO_ID = cod.CPT_ATUO_ID) as TD_Vol_Check_1 , -- Check Date
	(SELECT max(VCheckNo) FROM #TempVol tep (NOLOCK) WHERE tep.VCaseId=cas.Case_Id AND RowNum=1 AND tep.DOS = cod.DOS) as No_Vol_Check_1,
	--AND tep.CPT_ATUO_ID = cod.CPT_ATUO_ID) as No_Vol_Check_1,
	(SELECT sum(VNetPay) FROM #TempVol tep (NOLOCK) WHERE tep.VCaseId=cas.Case_Id AND RowNum=1  and tep.DOS= cod.DOS ) as Net_Voluntary_1,
	(SELECT SUM(VDedct) FROM #TempVol tep (NOLOCK) WHERE tep.VCaseId=cas.Case_Id AND RowNum=1 AND tep.DOS= cod.DOS) as Deductible_1,
	(SELECT SUM(VIntr) FROM #TempVol tep (NOLOCK) WHERE tep.VCaseId=cas.Case_Id AND RowNum=1 AND tep.DOS= cod.DOS) as Interest_1,
	(SELECT SuM(VAttorneyF) FROM #TempVol tep (NOLOCK) WHERE tep.VCaseId=cas.Case_Id AND RowNum=1 AND tep.DOS= cod.DOS) as Attorney_Fee_1,
	(SELECT MAX(convert(varchar(10), VDate,120)) FROM #TempVol tep (NOLOCK) WHERE tep.VCaseId=cas.Case_Id AND RowNum=1 AND tep.DOS= cod.DOS) as TD_Vol_Trans_1,
	(SELECT sum(VPay) FROM #TempVol tep (NOLOCK) WHERE tep.VCaseId=cas.Case_Id AND RowNum=1 AND    tep.DOS= cod.DOS) as Vol_No_1,
	(SELECT MAX(replace(Transaction_Description,',',' ')) FROM #TempVol tep (NOLOCK) WHERE tep.VCaseId=cas.Case_Id AND RowNum=1 AND tep.DOS= cod.DOS) as Vol_Note_1,
	(SELECT  MAX(convert(varchar(10), VAL_PAY_Freeze_Date,120)) FROM #TempVol tep (NOLOCK) WHERE tep.VCaseId=cas.Case_Id AND RowNum=1  AND tep.DOS= cod.DOS) as Vol_FreezeDate_1,

	--(SELECT VPay FROM #TempVol tep (NOLOCK) WHERE tep.VCaseId=cas.Case_Id AND RowNum=2 AND tep.CPT_ATUO_ID = cod.CPT_ATUO_ID) as TT_Vol_2,
	(Select   sum(Current_Paid) 
	 FROM  #tempVolpayment tvp where tvp.case_Id=cas.Case_id and rn=2 and tvp.DOS=cod.dos  and tvp.Case_ID=cod.Case_ID
	)
	
	
	as TT_Vol_2,
	

	(SELECT MAX(convert(varchar(10), VDate,120)) FROM #TempVol tep (NOLOCK) WHERE tep.VCaseId=cas.Case_Id AND RowNum=2 AND tep.DOS = cod.DOS) as TD_Vol_2, -- Deposited date
	(SELECT MAX(convert(varchar(10), VCheckDate,120)) FROM #TempVol tep (NOLOCK) WHERE tep.VCaseId=cas.Case_Id AND RowNum=2 AND tep.DOS = cod.DOS) as TD_Vol_Check_2 , -- Check Date
	(SELECT MAX(VCheckNo) FROM #TempVol tep (NOLOCK) WHERE tep.VCaseId=cas.Case_Id AND RowNum=2 AND tep.DOS = cod.DOS) as No_Vol_Check_2,
	(SELECT sum(VNetPay) FROM #TempVol tep (NOLOCK) WHERE tep.VCaseId=cas.Case_Id AND RowNum=2 AND   tep.DOS= cod.DOS) as Net_Voluntary_2,
	(SELECT SUm(VDedct) FROM #TempVol tep (NOLOCK) WHERE tep.VCaseId=cas.Case_Id AND RowNum=2 AND   tep.DOS= cod.DOS) as Deductible_2,
	(SELECT SUM(VIntr) FROM #TempVol tep (NOLOCK) WHERE tep.VCaseId=cas.Case_Id AND RowNum=2 AND   tep.DOS= cod.DOS) as Interest_2,
	(SELECT SUm(VAttorneyF) FROM #TempVol tep (NOLOCK) WHERE tep.VCaseId=cas.Case_Id AND RowNum=2 AND   tep.DOS= cod.DOS) as Attorney_Fee_2,
	(SELECT MAX(convert(varchar(10), VDate,120)) FROM #TempVol tep (NOLOCK) WHERE tep.VCaseId=cas.Case_Id AND RowNum=2 AND   tep.DOS= cod.DOS) as TD_Vol_Trans_2,
	(SELECT sum(VPay) FROM #TempVol tep (NOLOCK) WHERE tep.VCaseId=cas.Case_Id AND RowNum=2 AND   tep.DOS= cod.DOS) as Vol_No_2,
	(SELECT MAX(replace(Transaction_Description,',', ' ')) FROM #TempVol tep (NOLOCK) WHERE tep.VCaseId=cas.Case_Id AND RowNum=2 AND  tep.DOS= cod.DOS) as Vol_Note_2,
	(SELECT  MAX(convert(varchar(10), VAL_PAY_Freeze_Date,120)) FROM #TempVol tep (NOLOCK) WHERE tep.VCaseId=cas.Case_Id AND RowNum=2 AND  tep.DOS= cod.DOS) as Vol_FreezeDate_2,


	--(SELECT VPay FROM #TempVol tep (NOLOCK) WHERE tep.VCaseId=cas.Case_Id AND RowNum=3 AND tep.CPT_ATUO_ID = cod.CPT_ATUO_ID) as TT_Vol_3,

	(Select  sum(Current_Paid) 
	 FROM  #tempVolpayment tvp where tvp.case_Id=cas.Case_id and rn=3 and tvp.DOS=cod.dos  and tvp.Case_ID=cod.Case_ID
	)
	
	
	as TT_Vol_3,

	(SELECT MAX(convert(varchar(10), VDate,120)) FROM #TempVol tep (NOLOCK) WHERE tep.VCaseId=cas.Case_Id AND RowNum=3 AND tep.DOS = cod.DOS) as TD_Vol_3 , -- Deposited date
	(SELECT MAX(convert(varchar(10), VCheckDate,120)) FROM #TempVol tep (NOLOCK) WHERE tep.VCaseId=cas.Case_Id AND RowNum=3 AND tep.DOS = cod.DOS) as TD_Vol_Check_3, -- Check Date
	(SELECT MAX(VCheckNo) FROM #TempVol tep (NOLOCK) WHERE tep.VCaseId=cas.Case_Id AND RowNum=3 AND tep.DOS = cod.DOS) as No_Vol_Check_3,
	(SELECT SUM(VDedct) FROM #TempVol tep (NOLOCK) WHERE tep.VCaseId=cas.Case_Id AND RowNum=3 AND tep.DOS = cod.DOS) as Deductible_3,
	(SELECT sum(VNetPay) FROM #TempVol tep (NOLOCK) WHERE tep.VCaseId=cas.Case_Id AND RowNum=3  and tep.DOS= cod.DOS) as Net_Voluntary_3,
	(SELECT SUM(VIntr) FROM #TempVol tep (NOLOCK) WHERE tep.VCaseId=cas.Case_Id AND RowNum=3 AND tep.DOS = cod.DOS) as Interest_3,
	(SELECT Sum(VAttorneyF) FROM #TempVol tep (NOLOCK) WHERE tep.VCaseId=cas.Case_Id AND RowNum=3 AND tep.DOS = cod.DOS) as Attorney_Fee_3,
	(SELECT MAX(convert(varchar(10), VDate,120)) FROM #TempVol tep (NOLOCK) WHERE tep.VCaseId=cas.Case_Id AND RowNum=3 AND tep.DOS = cod.DOS) as TD_Vol_Trans_3,
	(SELECT sum(VPay) FROM #TempVol tep (NOLOCK) WHERE tep.VCaseId=cas.Case_Id AND RowNum=3  AND   tep.DOS= cod.DOS) as Vol_No_3,
	(SELECT MAX(replace(Transaction_Description,',', ' ')) FROM #TempVol tep (NOLOCK) WHERE tep.VCaseId=cas.Case_Id AND RowNum=3 AND tep.DOS = cod.DOS) as Vol_Note_3,
	(SELECT  MAX(convert(varchar(10), VAL_PAY_Freeze_Date,120)) FROM #TempVol tep (NOLOCK) WHERE tep.VCaseId=cas.Case_Id AND RowNum=3 AND tep.DOS = cod.DOS) as Vol_FreezeDate_3,

		--VDedct AS Deductible,
		--VIntr  as Interest,
	    ISNULL((SELECT SUM(ISNULL(VDedct,0.00)) FROM #TempVol tep (NOLOCK) WHERE tep.VCaseId=cas.Case_Id  AND tep.DOS = cod.DOS), 0.00) as Deductible,
	    ISNULL((SELECT SUM(ISNULL(VIntr,0.00)) FROM #TempVol tep (NOLOCK) WHERE tep.VCaseId=cas.Case_Id AND tep.DOS = cod.DOS), 0.00) as Interest,
		

		(SELECT SUM(VTotCol1) FROM #TempLit tepLit (NOLOCK) WHERE tepLit.VCaseId=cas.Case_Id AND RowNum=1 AND tepLit.DOS = cod.DOS) as Total_Litigation_Collection_1,
		(SELECT SUM(VCortFee1) FROM #TempLit tepLit (NOLOCK) WHERE tepLit.VCaseId=cas.Case_Id AND RowNum=1 AND tepLit.DOS = cod.DOS) as Court_Fees_1,
		(SELECT SUM(VLitFee1) FROM #TempLit tepLit (NOLOCK) WHERE tepLit.VCaseId=cas.Case_Id AND RowNum=1 AND tepLit.DOS = cod.DOS) as Litigation_Fees_1,
		(SELECT SUM(VNetLitCol1) FROM #TempLit tepLit (NOLOCK) WHERE tepLit.VCaseId=cas.Case_Id AND RowNum=1 AND tepLit.DOS = cod.DOS) as Net_Litigation_Collection_1,
	    (SELECT MAX(convert(varchar(10), VLitChkDt1,120)) FROM #TempLit tepLit (NOLOCK) WHERE tepLit.VCaseId=cas.Case_Id AND RowNum=1 AND tepLit.DOS = cod.DOS) as Lit_Pay_Date_1,
		(SELECT MAX(VLitPayNo1) FROM #TempLit tepLit (NOLOCK) WHERE tepLit.VCaseId=cas.Case_Id AND RowNum=1 AND tepLit.DOS = cod.DOS) as Lit_Payment_no_1,
	    (SELECT MAX(convert(varchar(10), VLitPayDt1,120)) FROM #TempLit tepLit (NOLOCK) WHERE tepLit.VCaseId=cas.Case_Id AND RowNum=1 AND tepLit.DOS = cod.DOS)  as Lit_Cheque_Date_1,
		--(SELECT replace(Transaction_Description,',', ' ') FROM #TempLit tepLit (NOLOCK) WHERE tepLit.VCaseId=cas.Case_Id AND RowNum=1 AND tepLit.CPT_ATUO_ID = cod.CPT_ATUO_ID) as Lit_Note_1,

	    (SELECT MAX(LEFT(DATENAME(MM,CONVERT(DATE,vdate)),3)+ ' '+ CONVERT(VARCHAR(4),YEAR(CONVERT(DATE,vdate)))) FROM #TempVol tep (NOLOCK) WHERE tep.VCaseId=cas.Case_Id AND RowNum=1 AND tep.DOS = cod.DOS) as Lit_Note_1,
		
		(SELECT MAX(convert(varchar(10), LIT_PAY_Freeze_Date,120)) FROM #TempLit tepLit (NOLOCK) WHERE tepLit.VCaseId=cas.Case_Id AND RowNum=1 AND tepLit.DOS = cod.DOS) as Lit_FreezeDate_1,

		(SELECT SUM(VTotCol1) FROM #TempLit tepLit (NOLOCK) WHERE tepLit.VCaseId=cas.Case_Id AND RowNum=2 AND tepLit.DOS = cod.DOS) as Total_Litigation_Collection_2,
		(SELECT SUM(VCortFee1) FROM #TempLit tepLit (NOLOCK) WHERE tepLit.VCaseId=cas.Case_Id AND RowNum=2 AND tepLit.DOS = cod.DOS) as Court_Fees_2,
		(SELECT SUM(VLitFee1) FROM #TempLit tepLit (NOLOCK) WHERE tepLit.VCaseId=cas.Case_Id AND RowNum=2 AND tepLit.DOS = cod.DOS) as Litigation_Fees_2,
		(SELECT SUM(VNetLitCol1) FROM #TempLit tepLit (NOLOCK) WHERE tepLit.VCaseId=cas.Case_Id AND RowNum=2 AND tepLit.DOS = cod.DOS) as Net_Litigation_Collection_2,
		(SELECT MAX(convert(varchar(10), VLitChkDt1,120)) FROM #TempLit tepLit (NOLOCK) WHERE tepLit.VCaseId=cas.Case_Id AND RowNum=2 AND tepLit.DOS = cod.DOS)  as Lit_Pay_Date_2,
		(SELECT MAX(VLitPayNo1) FROM #TempLit tepLit (NOLOCK) WHERE tepLit.VCaseId=cas.Case_Id AND RowNum=2 AND tepLit.DOS = cod.DOS) as Lit_Payment_no_2,
		(SELECT MAX(convert(varchar(10), VLitPayDt1,120)) FROM #TempLit tepLit (NOLOCK) WHERE tepLit.VCaseId=cas.Case_Id AND RowNum=2 AND tepLit.DOS = cod.DOS)as Lit_Cheque_Date_2,
		--(SELECT replace(Transaction_Description,',', ' ') FROM #TempLit tepLit (NOLOCK) WHERE tepLit.VCaseId=cas.Case_Id AND RowNum=2 AND tepLit.CPT_ATUO_ID = cod.CPT_ATUO_ID) as Lit_Note_2,
	    (SELECT MAX(LEFT(DATENAME(MM,CONVERT(DATE,vdate)),3)+ ' '+ CONVERT(VARCHAR(4),YEAR(CONVERT(DATE,vdate)))) FROM #TempVol tep (NOLOCK) WHERE tep.VCaseId=cas.Case_Id AND RowNum=2 AND tep.DOS = cod.DOS) as Lit_Note_2,
		(SELECT MAX(convert(varchar(10), LIT_PAY_Freeze_Date,120)) FROM #TempLit tepLit (NOLOCK) WHERE tepLit.VCaseId=cas.Case_Id AND RowNum=2 AND tepLit.DOS = cod.DOS) as Lit_FreezeDate_2,

		(SELECT SUm(VTotCol1) FROM #TempLit tepLit (NOLOCK) WHERE tepLit.VCaseId=cas.Case_Id AND RowNum=3 AND tepLit.DOS = cod.DOS) as Total_Litigation_Collection_3,
		(SELECT SUM(VCortFee1) FROM #TempLit tepLit (NOLOCK) WHERE tepLit.VCaseId=cas.Case_Id AND RowNum=3 AND tepLit.DOS = cod.DOS) as Court_Fees_3,
		(SELECT SUM(VLitFee1) FROM #TempLit tepLit (NOLOCK) WHERE tepLit.VCaseId=cas.Case_Id AND RowNum=3 AND tepLit.DOS = cod.DOS) as Litigation_Fees_3,
		(SELECT SUm(VNetLitCol1) FROM #TempLit tepLit (NOLOCK) WHERE tepLit.VCaseId=cas.Case_Id AND RowNum=3 AND tepLit.DOS = cod.DOS) as Net_Litigation_Collection_3,
	
        (SELECT MAX(convert(varchar(10), VLitChkDt1,120)) FROM #TempLit tepLit (NOLOCK) WHERE tepLit.VCaseId=cas.Case_Id AND RowNum=3 AND tepLit.DOS = cod.DOS) as Lit_Pay_Date_3,
		(SELECT MAX(VLitPayNo1) FROM #TempLit tepLit (NOLOCK) WHERE tepLit.VCaseId=cas.Case_Id AND RowNum=3 AND tepLit.DOS = cod.DOS) as Lit_Payment_no_3,
 	    (SELECT MAX(convert(varchar(10), VLitPayDt1,120)) FROM #TempLit tepLit (NOLOCK) WHERE tepLit.VCaseId=cas.Case_Id AND RowNum=3 AND tepLit.DOS = cod.DOS)  as Lit_Cheque_Date_3,
		--(SELECT replace(Transaction_Description,',', ' ') FROM #TempLit tepLit (NOLOCK) WHERE tepLit.VCaseId=cas.Case_Id AND RowNum=3 AND tepLit.CPT_ATUO_ID = cod.CPT_ATUO_ID) as Lit_Note_3,
        (SELECT MAX(LEFT(DATENAME(MM,CONVERT(DATE,vdate)),3)+ ' '+ CONVERT(VARCHAR(4),YEAR(CONVERT(DATE,vdate)))) FROM #TempVol tep (NOLOCK) 
		WHERE tep.VCaseId=cas.Case_Id AND RowNum=3 AND tep.DOS = cod.DOS) as Lit_Note_3,
		(SELECT MAX(convert(varchar(10), LIT_PAY_Freeze_Date,120)) FROM #TempLit tepLit (NOLOCK) 
		WHERE tepLit.VCaseId=cas.Case_Id AND RowNum=3 AND tepLit.DOS = cod.DOS) as Lit_FreezeDate_3,
		 
		 
		 --cod.Code as CPT,

		 (select MAX(cod8.Code) from BILLS_WITH_PROCEDURE_CODES cod8 with(nolock)  where cod8.DOS=cod.DOS and 
	cod8.Case_ID = cod.Case_ID and cas.Case_Id=cod8.Case_ID) AS CPT,

		 --cod.Amount - CASE WHEN  CollectedAmount IS NULL THEN 0 ELSE CollectedAmount END 
			--- CASE WHEN  Deductible IS NULL THEN 0 ELSE Deductible END  
			--+ CASE WHEN  Intrest IS NULL THEN 0 ELSE Intrest END Purchase_Balance,
	    '' AS Voluntary_Payment_1,
		'' AS Voluntary_Payment_Date_1,
		'' AS Voluntary_Payment_2,
		'' AS Voluntary_Payment_Date_2,
		'' AS Voluntary_Payment_3,
		'' AS Voluntary_Payment_Date_3,
		'' AS Voluntary_Deductible,
		'' AS Voluntary_Interest,
		--cod.Amount AS Purchase_Balance,
		(select sum(ISNULL(amount,0)) from BILLS_WITH_PROCEDURE_CODES cod2 where cod2.dos=cod.DOS and cod2.Case_ID = cod.Case_ID and cas.Case_Id=cod2.Case_ID) AS Purchase_Balance,
	    (select CAST(isnull(sum(cod3.Amount),0)AS FLOAT) * (CASE WHEN CAST(ISNULL(Advance_Rate,0)AS FLOAT) > 0 then CAST(ISNULL(Advance_Rate,0)AS FLOAT) ELSE 1 END)/ 100
		from BILLS_WITH_PROCEDURE_CODES cod3 where cod3.dos=cod.DOS and cod3.Case_ID = cod.Case_ID and cas.Case_Id=cod3.Case_ID ) AS Purchase_Price,
		--CAST(isnull(cod.Amount,0)AS FLOAT) * (CASE WHEN CAST(ISNULL(Advance_Rate,0)AS FLOAT) > 0 then CAST(ISNULL(Advance_Rate,0)AS FLOAT) ELSE 1 END)/ 100 AS Purchase_Price,
		----CAST(isnull(Cod.Amount,0) AS FLOAT)- CAST(ISNULL(cod.Bill_Adjustment,0) AS FLOAT) - CAST(ISNULL((SELECT SUM(ISNULL(VPay,0.00)) FROM #TempVol tep (NOLOCK) WHERE tep.VCaseId=cas.Case_Id AND tep.CPT_ATUO_ID = cod.CPT_ATUO_ID), 0.00) AS FLOAT) - CAST(ISNULL((SELECT SUM(ISNULL(VDedct,0.00)) FROM #TempVol tep (NOLOCK) WHERE tep.VCaseId=cas.Case_Id AND tep.CPT_ATUO_ID = cod.CPT_ATUO_ID), 0.00) AS FLOAT) + CAST(ISNULL((SELECT SUM(ISNULL(VIntr,0.00)) FROM #TempVol tep (NOLOCK) WHERE tep.VCaseId=cas.Case_Id AND tep.CPT_ATUO_ID = cod.CPT_ATUO_ID), 0.00) AS FLOAT) AS Purchase_Balance,		
		--CAST(isnull((Select SUM(ISNULL(BCOD.Amount,0)) from tbltreatment Trtmnt INNER JOIN BILLS_WITH_PROCEDURE_CODES BCOD ON BCOD.fk_Treatment_Id = Trtmnt.Treatment_Id where Trtmnt.case_id=Tre.case_id ),0) AS FLOAT)
		--- CAST(ISNULL(cod.Bill_Adjustment,0) AS FLOAT) - CAST(ISNULL((SELECT SUM(ISNULL(VPay,0.00)) FROM #TempVol tep (NOLOCK) WHERE tep.VCaseId=cas.Case_Id AND tep.CPT_ATUO_ID = cod.CPT_ATUO_ID), 0.00) AS FLOAT) 
		--- CAST(ISNULL((SELECT SUM(ISNULL(VDedct,0.00)) FROM #TempVol tep (NOLOCK) WHERE tep.VCaseId=cas.Case_Id AND tep.CPT_ATUO_ID = cod.CPT_ATUO_ID), 0.00) AS FLOAT) 
		--+ CAST(ISNULL((SELECT SUM(ISNULL(VIntr,0.00)) FROM #TempVol tep (NOLOCK) WHERE tep.VCaseId=cas.Case_Id AND tep.CPT_ATUO_ID = cod.CPT_ATUO_ID), 0.00) AS FLOAT) AS Purchase_Balance,		
		
		----((CAST(isnull(cod.Amount,0)AS FLOAT)- CAST(ISNULL(cod.Bill_Adjustment,0) AS FLOAT) - CAST(ISNULL((SELECT SUM(ISNULL(VPay,0.00)) FROM #TempVol tep (NOLOCK) WHERE tep.VCaseId=cas.Case_Id AND tep.CPT_ATUO_ID = cod.CPT_ATUO_ID), 0.00) AS FLOAT) - CAST(ISNULL((SELECT SUM(ISNULL(VDedct,0.00)) FROM #TempVol tep (NOLOCK) WHERE tep.VCaseId=cas.Case_Id AND tep.CPT_ATUO_ID = cod.CPT_ATUO_ID), 0.00) AS FLOAT) + CAST(ISNULL((SELECT SUM(ISNULL(VIntr,0.00)) FROM #TempVol tep (NOLOCK) WHERE tep.VCaseId=cas.Case_Id AND tep.CPT_ATUO_ID = cod.CPT_ATUO_ID), 0.00) AS FLOAT))
		----	  *(CASE WHEN CAST(ISNULL(Advance_Rate,0)AS FLOAT) > 0 then CAST(ISNULL(Advance_Rate,0)AS FLOAT) ELSE 1 END))
		----	/ 100
		----	 AS Purchase_Price,
		--((CAST(isnull((Select SUM(ISNULL(BCOD.Amount,0)) from tbltreatment Trtmnt INNER JOIN BILLS_WITH_PROCEDURE_CODES BCOD ON BCOD.fk_Treatment_Id = Trtmnt.Treatment_Id where Trtmnt.case_id=Tre.case_id ),0)AS FLOAT)
		--- CAST(ISNULL(cod.Bill_Adjustment,0) AS FLOAT) - CAST(ISNULL((SELECT SUM(ISNULL(VPay,0.00)) FROM #TempVol tep (NOLOCK) WHERE tep.VCaseId=cas.Case_Id AND tep.CPT_ATUO_ID = cod.CPT_ATUO_ID), 0.00) AS FLOAT) 
		--- CAST(ISNULL((SELECT SUM(ISNULL(VDedct,0.00)) FROM #TempVol tep (NOLOCK) WHERE tep.VCaseId=cas.Case_Id AND tep.CPT_ATUO_ID = cod.CPT_ATUO_ID), 0.00) AS FLOAT) 
		--+ CAST(ISNULL((SELECT SUM(ISNULL(VIntr,0.00)) FROM #TempVol tep (NOLOCK) WHERE tep.VCaseId=cas.Case_Id AND tep.CPT_ATUO_ID = cod.CPT_ATUO_ID), 0.00) AS FLOAT))
		--* (CASE WHEN CAST(ISNULL(Advance_Rate,0)AS FLOAT) > 0 then CAST(ISNULL(Advance_Rate,0)AS FLOAT) ELSE 1 END)) / 100 AS Purchase_Price,

		--convert(varchar(10), Tre.Date_BillSent,120) AS Purchase_Date,

			(select MIN(convert(varchar(10), cod4.Date_BillSent, 120)) from tbltreatment cod4 with(nolock)  where cod4.DateOfService_Start=cod.DOS and 
	cod4.Case_ID = cod.Case_ID and cas.Case_Id=cod4.Case_ID) AS Purchase_Date,

		replace(cas.Policy_Number, ',', ' ') AS Policy_Number,
		--cas.Memo[Note],
		replace(REPLACE(REPLACE(cas.Memo, CHAR(13), ''), CHAR(10), ''), ',', ' ')[Note],
		d.First_Party_Case_Status,
		convert(varchar(10), casDt.CASE_EVALUATION_DATE,120) AS CASE_EVALUATION_DATE,	
		convert(varchar, First_Party_Suit_Filed_Date,101)[First_Party_Suit_Filed_Date],
		replace(crt.Court_Name, ',', ' ') as court_type,
		replace(crt.Court_Venue, ',', ' ') as court_county,
		--(iif(Attorney_FirstName is null,'', Attorney_FirstName) +' ' + iif(Attorney_LastName is null, '', Attorney_LastName)) as First_Party_Attorney,
		(Select TOP 1 replace(ISNULL(Attorney_FirstName,''),',',' ') + ' ' + replace(ISNULL(Attorney_LastName,''),',', ' ') as First_Party_Attorney from tblAttorney_Case_Assignment aca(NOLOCK) inner join tblAttorney_Master am(NOLOCK) on am.Attorney_Id=aca.Attorney_Id
		inner join tblAttorney_Type atp(NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id Where lower(Attorney_Type) = 'plaintiff attorney' and aca.Case_Id = cas.Case_Id and aca.DomainId = cas.DomainId) as First_Party_Attorney,
		(Select TOP 1 replace(ISNULL(LawFirmName,''), ',', ' ') as First_Party_Attorney from tblAttorney_Case_Assignment aca(NOLOCK) inner join tblAttorney_Master am(NOLOCK) on am.Attorney_Id=aca.Attorney_Id
		inner join tblAttorney_Type atp(NOLOCK) on atp.Attorney_Type_ID = am.Attorney_Type_Id Where lower(Attorney_Type) = 'plaintiff attorney' and aca.Case_Id = cas.Case_Id and aca.DomainId = cas.DomainId) as First_Party_LawFirm,
		replace(REPLACE(REPLACE(Attorney_frmBiller_Note, CHAR(13), ''), CHAR(10), ''), ',', ' ') AS Attorney_frmBiller_Note,
		replace(Our_Attorney,',', ' ') AS Our_Attorney,
		replace(Our_Attorney_Law_Firm,',', ' ') AS Our_Attorney_Law_Firm,
		replace(Law_Suit_Type,',', ' ') AS Law_Suit_Type,


		--convert(varchar(10), cod.Purchase_Freeze_Date,120)[InvDate],

			(select MIN(convert(varchar(10), cod5.Purchase_Freeze_Date, 120)) from BILLS_WITH_PROCEDURE_CODES cod5 with(nolock) where cod5.dos=cod.DOS and 
	cod5.Case_ID = cod.Case_ID and cas.Case_Id=cod5.Case_ID) [InvDate],


		(Select Sum(CONVERT(float, ISNULL(FEE_SCHEDULE,0)) - CONVERT(float, ISNULL(PAID_AMOUNT,0))) From tblTreatment Trtm(NOLOCK)
		Where Trtm.Case_Id=cas.Case_Id and Trtm.Domainid = cas.DomainId and trtm.DateOfService_Start = cod.DOS and trtm.Case_Id = cod.Case_ID
		group by Trtm.Case_Id) AS Current_Balance_per_patient,

		CAST((Select iif(Sum(CONVERT(float, ISNULL(FEE_SCHEDULE,0))) =0,0, (Sum(CONVERT(float, ISNULL(PAID_AMOUNT,0)))/Sum(CONVERT(float, ISNULL(FEE_SCHEDULE,0)))*100)) From tblTreatment Trtm(NOLOCK) Where Trtm.Case_Id=cas.Case_Id and Trtm.Domainid = cas.DomainId group by Trtm.Case_Id) AS NUMERIC(18,2)) AS Percentage_Collected,
		iif((Select Count(FirstParty_Litigation) from tbl_Voluntary_Payment VLit Where VLit.FirstParty_Litigation = 1 
		and VLit.Case_Id = cas.Case_Id and VLit.DomainId = cas.DomainId) > 0, 'Yes', 'No') AS Settledby_First_Party_Litigation,
		cas.Status AS Litigation_Coding,
		'ACTIVE' AS Status_of_Patient_Bill
	from tblcase cas (NOLOCK)
	INNER JOIN tblInsuranceCompany ins (NOLOCK) ON cas.InsuranceCompany_Id = ins.InsuranceCompany_Id
	left join tbltreatment Tre (NOLOCK) on cas.case_id=Tre.case_id 
	left join BILLS_WITH_PROCEDURE_CODES cod (NOLOCK) on cod.fk_Treatment_Id = Tre.Treatment_Id --cod.CPT_ATUO_ID = cpt.CPT_ATUO_ID
	--left join tbl_cpt_payment_details cpt (NOLOCK) on cpt.CPT_ATUO_ID = cod.CPT_ATUO_ID --cpt.Transaction_Id = v_pay.Voluntary_Pay_Id 
	--LEFT OUTER JOIN tbl_Voluntary_Payment v_pay (NOLOCK) on  v_pay.Voluntary_Pay_Id = cpt.Transaction_Id --v_pay.Case_Id=cas.Case_Id
	--((ISNULL(cod.BillNumber,'') = ISNULL(Tre.BILL_NUMBER,'') AND ISNULL(Tre.BILL_NUMBER,'') <> '') OR Treatment_id = ISNULL(fk_Treatment_Id,0))
	left outer join tblCase_additional_info d (NOLOCK) on d.case_id=cas.Case_Id
	LEFT OUTER JOIN tblCase_Date_Details casDt (NOLOCK) ON cas.Case_Id=casDt.Case_Id
	left join tblCourt crt (NOLOCK) on crt.Court_Id=cas.Court_Id
	--left join tblAttorney_Case_Assignment cass (NOLOCK) on cass.Case_Id = cas.Case_Id
	--left join tblAttorney_Master am (NOLOCK) on cass.Attorney_Id = am.Attorney_Id
	LEFT OUTER JOIN tbl_Portfolio pf (NOLOCK) on pf.Id = cas.PortfolioId
	LEFT OUTER JOIN tbl_Program tbPr (NOLOCK) ON pf.ProgramId = tbPr.Id
	left join tblProvider pro (NOLOCK) on pro.Provider_Id=cas.Provider_Id
	--LEFT OUTER JOIN #TempVol Tem  ON cas.Case_Id=Tem.VCaseId AND Tem.CPT_ATUO_ID=cod.CPT_ATUO_ID

	WHERE cas.DomainId=@s_a_DomainId AND ISNULL(cas.IsDeleted,0)=0
			AND (@s_a_status = '' OR cas.Status = @s_a_status)
			--	AND ((@dt_a_FromDate='' AND @dt_a_ToDate='') OR (Tre.Date_BillSent BETWEEN CONVERT(datetime,@dt_a_FromDate) AND CONVERT(datetime,@dt_a_ToDate) + 1 ))		
			--  AND ((@dt_a_invFromDate='' AND @dt_a_invToDate='') OR (cas.inv_date BETWEEN CONVERT(datetime,@dt_a_invFromDate) AND CONVERT(datetime,@dt_a_invToDate) + 1 ))		
			AND (
				(@dt_a_invFromDate='' AND @dt_a_invToDate='')
				OR
				(@dt_a_invFromDate<>'' AND @dt_a_invToDate<>'' AND cod.Purchase_Freeze_Date BETWEEN CONVERT(datetime,@dt_a_invFromDate) AND CONVERT(datetime,@dt_a_invToDate))
			)	
			AND (((@i_a_PortfolioId = 0  OR cas.PortfolioId = @i_a_PortfolioId) and @s_a_UserType <> 'I') OR
				  (@i_a_PortfolioId = 0 or cas.PortfolioId = @i_a_PortfolioId) and cas.PortfolioId in (Select PortfolioId from tbl_InvestorPortfolio(NOLOCK) where InvestorId in (select InvestorId from tbl_Investor(NOLOCK) where userid = @i_a_UserId))  and @s_a_UserType = 'I' )
			AND Convert(decimal(18,2), iif(cas.Claim_Amount is null or ltrim(rtrim(cas.Claim_Amount)) ='', '0', cas.Claim_Amount)) > Convert(decimal(18,2),0)
			--AND isnull(cas.Claim_Amount,0) > 0
	
			OPTION	(RECOMPILE)

		DROP TABLE #TempVol

        DROP TABLE #TempLit

		DROP TABLE #tempVolpayment

END



