CREATE PROCEDURE [dbo].[Get_FileRecon_report]
AS
BEGIN
SELECT distinct TBLCASE.CASE_ID,
			ISNULL(DBO.TBLCASE.INJUREDPARTY_FIRSTNAME, N'') + N'  ' + ISNULL(DBO.TBLCASE.INJUREDPARTY_LASTNAME, N'') AS INJUREDPARTY_NAME,
			--TBLPROVIDER.Provider_Name,
			--INSURANCECOMPANY_NAME,
			--POLICY_NUMBER,
			INS_CLAIM_NUMBER,
			convert(nvarchar(12),tblcase.Accident_Date,101) as Accident_Date,
			tblcase.CLAIM_AMOUNT,
			--CONVERT(FLOAT, ISNULL(DBO.TBLCASE.CLAIM_AMOUNT,0)) - CONVERT(FLOAT, ISNULL(DBO.TBLCASE.PAID_AMOUNT,0)) AS BALANCE_AMOUNT,
			STATUS,convert (varchar(10),date_opened,101) as date_opened ,
			--[dbo].[fncGetAccountNumber](tblcase.Case_Id) as account_number,
			--account_number,
			--DATEDIFF(DD,DATE_STATUS_CHANGED,GETDATE()) AS STATUSAGE,
			[dbo].[fncGetNotesDesc](TBLCASE.CASE_ID) AS NOTESDESC,
			tblrecon_file.FACS_ACCT as Account_Number,
			tblrecon_file.dos	
		FROM
		    tblrecon_file
		    left outer join
			TBLCASE  on tblrecon_file.Injuredparty_lastName   =tblcase.Injuredparty_lastName
			and CASE CHARINDEX(' ', LTRIM(tblrecon_file.Injuredparty_FirstName), 1)WHEN 0 THEN LTRIM(tblrecon_file.Injuredparty_FirstName)ELSE SUBSTRING(LTRIM(tblrecon_file.Injuredparty_FirstName), 1, CHARINDEX(' ',LTRIM(tblrecon_file.Injuredparty_FirstName), 1) - 1)End=tblcase.InjuredParty_FirstName
			--INNER JOIN TBLPROVIDER ON TBLCASE.PROVIDER_ID = TBLPROVIDER.Provider_Id 
			--INNER JOIN TBLINSURANCECOMPANY ON TBLCASE.INSURANCECOMPANY_ID = TBLINSURANCECOMPANY.INSURANCECOMPANY_ID
			--INNER JOIN tbltreatment ON TBLCASE.case_id = tbltreatment.case_id
			
			
			--(tblrecon_file.dos=CONVERT(nvarchar,(convert(datetime,tblcase.DateOfService_Start)),101)
			--and tblrecon_file.Insurance_Id=tblcase.INS_CLAIM_NUMBER
			--and CASE CHARINDEX(' ', LTRIM(tblrecon_file.Injuredparty_FirstName), 1)WHEN 0 THEN LTRIM(tblrecon_file.Injuredparty_FirstName)ELSE SUBSTRING(LTRIM(tblrecon_file.Injuredparty_FirstName), 1, CHARINDEX(' ',LTRIM(tblrecon_file.Injuredparty_FirstName), 1) - 1)End=tblcase.InjuredParty_FirstName
			--and   tblrecon_file.Injuredparty_lastName   =tblcase.Injuredparty_lastName)
			

		--WHERE TBLPROVIDER.PROVIDER_ID in(select provider_id from TXN_PROVIDER_LOGIN where user_id in
		--(select userid from issuetracker_users where username='nslij_fhkp'))
		--group by TBLCASE.CASE_ID,tblrecon_file.dos	,tblrecon_file.FACS_ACCT,TBLPROVIDER.Provider_Name,TBLCASE.INJUREDPARTY_FIRSTNAME,TBLCASE.INJUREDPARTY_LASTNAME,InsuranceCompany_Name,Accident_Date,Policy_Number,Ins_Claim_Number,TBLCASE.Claim_Amount,TBLCASE.Paid_Amount,TBLCASE.Status,TBLCASE.Date_Opened,DATE_STATUS_CHANGED,account_number
		
		
		
	  --select FACS_ACCT,tblrecon_file.Injuredparty_lastName,tblrecon_file.Injuredparty_FirstName,Product_Line,Exp,DU13211,DU13212,DU13213,File_Rec_Date,ACCT#_From_clt,Doctor_Name,Client_Name,DOS,Insurance_Id 
	  --from tblrecon_file inner join tblcase 
	  --on CONVERT(nvarchar,(convert(datetime,tblcase.DateOfService_Start)),101)=tblrecon_file.dos 
	  --and tblcase.InjuredParty_LastName =tblrecon_file.Injuredparty_lastName
	  --and tblcase.Injuredparty_FirstName =tblrecon_file.Injuredparty_FirstName
END

