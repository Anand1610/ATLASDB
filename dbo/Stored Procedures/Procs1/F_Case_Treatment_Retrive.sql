CREATE PROCEDURE [dbo].[F_Case_Treatment_Retrive] --[F_Case_Treatment_Retrive] 'FH12-96549'
(
	@s_a_CASE_ID NVARCHAR(50) = '',
	@i_a_treatment_id INT = 0
)
AS        
BEGIN  
		SELECT 
			DISTINCT tre.Treatment_Id AS Treatment_Id,
			RANK() OVER (Order by tre.DateOfService_Start,tre.DateOfService_End,tre.Treatment_Id   asc ) AS RANK,
			ISNULL(convert(nvarchar(20),tre.DateOfService_Start,101),'')[DateOfService_Start], 
			ISNULL(convert(nvarchar(20),tre.DateOfService_End,101),'')[DateOfService_End], 
			tre.Case_Id,
			'<TABLE  width="100%" border="0"><TR>'
			    + '<TD width="2px" bgcolor="'
			    + CASE  WHEN (isnull(tre.Claim_Amount,0.00) - isnull(tre.Paid_Amount,0.00)) <= 0.00
					THEN 'RED'
					ELSE 'YELLOW' END		
			    +'">&nbsp;&nbsp;&nbsp;&nbsp;</TD>'
			    + '</TR></TABLE>' [Color_Categories],
			ISNULL(convert(nvarchar(50),tre.Claim_Amount),'0.00')[Claim_Amount],        
			ISNULL(convert(nvarchar(50),tre.Paid_Amount),'0.00')[Paid_Amount],   
			ISNULL(Fee_Schedule,0.00)  AS Fee_Schedule ,  
			CASE WHEN ISDATE (Date_BillSent) = 1 THEN  CONVERT(VARCHAR(10),CONVERT(DATETIME,Date_BillSent),101) ELSE NULL END AS Date_BillSent, 
			ISNULL(tre.Claim_Amount,0) - Isnull(tre.Paid_Amount,0) AS  Balance_Amount,
			ISNULL(tre.Account_Number,Isnull(tre.Bill_Number,'')) AS Account_Number,
			SERVICE_TYPE,
			STUFF(
				(SELECT distinct ',' + DenialReasons_Type from tblDenialReasons
				 INNER JOIN TXN_tblTreatment on TXN_tblTreatment.DenialReasons_Id = tblDenialReasons.DenialReasons_Id
				 WHERE TXN_tblTreatment.Treatment_Id = tre.Treatment_Id
				 FOR XML PATH('')),1,1,'') AS DenialReasons_Type,
			STUFF(
				(SELECT distinct ',' + CONVERT(VARCHAR(100),tblDenialReasons.DenialReasons_Id) from tblDenialReasons
				 INNER JOIN TXN_tblTreatment on TXN_tblTreatment.DenialReasons_Id = tblDenialReasons.DenialReasons_Id
				 WHERE TXN_tblTreatment.Treatment_Id = tre.Treatment_Id
				 FOR XML PATH('')),1,1,'') AS DenialReasons_Id,
			STUFF(
				(SELECT distinct ',' + TblReviewingDoctor.Doctor_Name  from TblReviewingDoctor
				 INNER JOIN TXN_CASE_PEER_REVIEW_DOCTOR on TXN_CASE_PEER_REVIEW_DOCTOR.DOCTOR_ID = TblReviewingDoctor.Doctor_id
				 WHERE TXN_CASE_PEER_REVIEW_DOCTOR.Treatment_Id = tre.Treatment_Id
				 FOR XML PATH('')),1,1,'') AS REVIEW_DOCTOR_Name,
			STUFF(
				(SELECT distinct ',' + CONVERT(VARCHAR(100),TblReviewingDoctor.Doctor_id) from TblReviewingDoctor
				 INNER JOIN TXN_CASE_PEER_REVIEW_DOCTOR on TXN_CASE_PEER_REVIEW_DOCTOR.DOCTOR_ID = TblReviewingDoctor.Doctor_id
				 WHERE TXN_CASE_PEER_REVIEW_DOCTOR.Treatment_Id = tre.Treatment_Id
				 FOR XML PATH('')),1,1,'') AS REVIEW_DOCTOR_ID,
			STUFF(
				(SELECT distinct ',' + tblOperatingDoctor.Doctor_Name  from tblOperatingDoctor
				 INNER JOIN TXN_CASE_Treating_Doctor on TXN_CASE_Treating_Doctor.DOCTOR_ID = tblOperatingDoctor.Doctor_id
				 WHERE TXN_CASE_Treating_Doctor.Treatment_Id = tre.Treatment_Id
				 FOR XML PATH('')),1,1,'') AS Treating_Doctor_Name,
			STUFF(
				(SELECT distinct ',' + CONVERT(VARCHAR(100),tblOperatingDoctor.Doctor_Id) from tblOperatingDoctor
				 INNER JOIN TXN_CASE_Treating_Doctor on TXN_CASE_Treating_Doctor.DOCTOR_ID = tblOperatingDoctor.Doctor_id
				 WHERE TXN_CASE_Treating_Doctor.Treatment_Id = tre.Treatment_Id
				 FOR XML PATH('')),1,1,'') AS Treating_Doctor_Id 
		FROM 
			tblTreatment tre
		WHERE 
			tre.Case_Id= @s_a_CASE_ID
		ORDER BY 
			RANK  

	
END

