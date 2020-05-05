



-- Template_Case_Details_Retrieve 'BT','BT20-114131',1111    
CREATE PROCEDURE [dbo].[Template_Case_Details_Retrieve]    
(    
 @DomainId  VARCHAR(40) = '' ,    
 @s_a_case_id NVARCHAR(2000) = '',    
 @i_a_user_id INT    = 0 ,
 @dt_NOW  DATETIME = NULL   
)    
AS    
BEGIN    
SET NOCOUNT ON    
SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED 

 
 IF @dt_NOW IS  NULL  
  SET @dt_NOW =  GETDATE() -- '2019-08-08' 
     
 DECLARE  @template_case_details TABLE     
 (    
 -- Provider    
  PROVIDER_SUITNAME VARCHAR(2000),    
  PROVIDER_LOCAL_ADDRESS VARCHAR(2000),    
  PROVIDER_LOCAL_CITY VARCHAR(2000),    
  PROVIDER_LOCAL_STATE VARCHAR(2000),    
  PROVIDER_LOCAL_ZIP VARCHAR(2000), 
  PROVIDER_LOCAL_PHONE VARCHAR(2000), 
  PROVIDER_EMAIL VARCHAR(200),
  PROVIDER_LOCAL_FAX VARCHAR(2000),   
  PROVIDER_TAXID VARCHAR(2000),    
  PROVIDER_PERM_ADDRESS VARCHAR(2000),    
  PROVIDER_PERM_CITY VARCHAR(2000),    
  PROVIDER_PERM_STATE VARCHAR(2000),    
  PROVIDER_PERM_ZIP VARCHAR(2000),    
  PROVIDER_PRESIDENT VARCHAR(2000),    
  PROVIDER_BILLING VARCHAR(2000),    
  PROVIDER_INTBILLING VARCHAR(2000),    
  PROVIDER_INITIAL_BILLING VARCHAR(2000),    
  PROVIDER_INITIAL_INTBILLING VARCHAR(2000),    
    
  ACCIDENT_DATE VARCHAR(20),    
  DATE_BILLSENT VARCHAR(20),    
  CASE_ID VARCHAR(2000),    
  PACKET_OR_CASE_ID VARCHAR(2000),    
  CLAIM_AMOUNT VARCHAR(2000),    
  PAID_AMOUNT VARCHAR(2000),     
  BALANCE_AMOUNT VARCHAR(2000),     
    
  INDEXORAAA_NUMBER VARCHAR(2000),    
  DATE_INDEX_NUMBER_PURCHASED VARCHAR(2000),    
    
  DOS_END VARCHAR(2000),    
  DOS_START VARCHAR(2000),    
  DOS_RANGE_ALL VARCHAR(4000),    
  INJUREDPARTY_NAME VARCHAR(2000),    
  INS_CLAIM_NUMBER VARCHAR(2000),    
  POLICY_NUMBER VARCHAR(2000),    
  INJUREDPARTY_LASTNAME VARCHAR(2000),    
  INJUREDPARTY_FIRSTNAME VARCHAR(2000),    
  INJUREDPARTY_FULL_ADDRESS VARCHAR(2000),    
  
  INSUREDPARTY_NAME VARCHAR(2000),  
  INSUREDPARTY_LASTNAME VARCHAR(2000),    
  INSUREDPARTY_FIRSTNAME VARCHAR(2000),    
  INSUREDPARTY_ADDRESS VARCHAR(2000),    
    
  REPRESENTETIVE_NAME VARCHAR(2000),    
  REPRESENTATIVE_CONTACT_NUMBER VARCHAR(2000),    
  --ASSIGNED_ATTORNEY VARCHAR(2000),    
  -- Insurance Details    
  INSURANCECOMPANY_SUITNAME  VARCHAR(2000),    
  INSURANCECOMPANY_NAME VARCHAR(2000),    
  INSURANCECOMPANY_LOCAL_ADDRESS VARCHAR(2000),    
  INSURANCECOMPANY_LOCAL_CITY VARCHAR(2000),    
  INSURANCECOMPANY_LOCAL_COUNTY VARCHAR(2000),    
  INSURANCECOMPANY_LOCAL_STATE VARCHAR(2000),    
  INSURANCECOMPANY_LOCAL_ZIP VARCHAR(2000),    
  INSURANCECOMPANY_LOCAL_FAX VARCHAR(2000),    
  INSURANCECOMPANY_LOCAL_PHONE VARCHAR(2000),  
  INSURANCECOMPANY_EMAIL VARCHAR(200),  
  INSURANCECOMPANY_PERM_ADDRESS VARCHAR(2000),    
  INSURANCECOMPANY_PERM_CITY VARCHAR(2000),    
  INSURANCECOMPANY_PERM_COUNTY VARCHAR(2000),    
  INSURANCECOMPANY_PERM_STATE VARCHAR(2000),    
  INSURANCECOMPANY_PERM_ZIP VARCHAR(2000),    
  INSURANCECOMPANY_PERM_FAX VARCHAR(2000),    
  INSURANCECOMPANY_PERM_PHONE VARCHAR(2000),    
  --- Court    
  COURT_NAME  VARCHAR(2000),    
  COURT_VENUE VARCHAR(2000),    
  NEW_COURT_VENUE VARCHAR(2000),    
  COURT_ADDRESS VARCHAR(2000),    
  COURT_BASIS VARCHAR(2000),    
  COURT_MISC NVARCHAR(50),    
  COURT_MISC_DISTRICT NVARCHAR(100),    
  COURT_MISC_CIRCUIT NVARCHAR(100),    
  COURT_CITY VARCHAR(MAX),    
  COURT_COUNTY VARCHAR(MAX),    
     --- SETT     
  SETTLED_WITH_NAME  VARCHAR(2000),    
  SETTLED_WITH_PHONE  VARCHAR(2000),    
  SETTLED_WITH_FAX  VARCHAR(2000),    
  SETTLEMENT_AMOUNT  VARCHAR(2000),    
  SETTLEMENT_INT  VARCHAR(2000),    
  SETTLEMENT_AF  VARCHAR(2000),    
  SETTLEMENT_FF  VARCHAR(2000),    
  SETTLEMENT_TOTAL  VARCHAR(2000),    
  SETTLEMENT_DATE  VARCHAR(2000),    
  SETTLEDWITH  VARCHAR(2000),    
    
  --- Transaction  Details    
  TRANSACTIONS_AMOUNT_COLLECTED VARCHAR(2000),    
  TRANSACTIONS_AMOUNT_INT VARCHAR(2000),    
  TRANSACTIONS_AMOUNT_AF VARCHAR(2000),    
      
  -- Adjuster    
  ADJUSTER_NAME VARCHAR(2000),    
  ADJUSTER_LASTNAME VARCHAR(2000),    
  ADJUSTER_FIRSTNAME VARCHAR(2000),    
  ADJUSTER_PHONE VARCHAR(2000),    
  ADJUSTER_FAX VARCHAR(2000),    
  ADJUSTER_EMAIL VARCHAR(2000),    
  -- ATTORNEY 
  ATTORNEY_FILENUMBER  VARCHAR(2000),    
  ATTORNEY_NAME VARCHAR(2000),    
  ATTORNEY_LASTNAME  VARCHAR(2000),    
  ATTORNEY_FIRSTNAME  VARCHAR(2000),    
  ATTORNEY_ADDRESS  VARCHAR(2000),    
  ATTORNEY_CITY  VARCHAR(2000),    
  ATTORNEY_STATE  VARCHAR(2000),    
  ATTORNEY_ZIP  VARCHAR(2000),    
  ATTORNEY_PHONE  VARCHAR(2000),    
  ATTORNEY_FAX  VARCHAR(2000),    
  ATTORNEY_EMAIL VARCHAR(2000),    
      
  --Defendant    
  DEFENDANT_NAME  VARCHAR(2000),    
  DEFENDANT_ADDRESS  VARCHAR(2000),    
  DEFENDANT_STATE  VARCHAR(2000),    
  DEFENDANT_ZIP  VARCHAR(2000),    
  DEFENDANT_PHONE  VARCHAR(2000),    
  DEFENDANT_FAX  VARCHAR(2000),    
  DEFENDANT_EMAIL  VARCHAR(2000),    
  DEFENDANT_CITY VARCHAR(2000),    
  --Date  

  SERVED_ON_DATE VARCHAR(50),    
  Served_On_Time VARCHAR(50),    
  SERVED_ON_DAY VARCHAR(50),    
  SERVED_ON_MONTH VARCHAR(50),    
  SERVED_ON_YEAR VARCHAR(50),
  Date_Answer_Received VARCHAR(50),    
  --Served_Person    
  Served_Person_Name VARCHAR(200),    
  --Served_Date VARCHAR(50),    
  Served_Person_Height VARCHAR(50),    
  Served_Person_Weight VARCHAR(50),    
  Served_Person_AGE VARCHAR(50),    
  Served_Person_Skin_Colour VARCHAR(50),    
  Served_Person_Hair_Colour VARCHAR(50),    
  Served_Person_Gender VARCHAR(50),    
  -- Notes    
  DELAY_NOTES VARCHAR(4000),    
  -- Client      
  LAWFIRMNAME VARCHAR(2000),    
  CLIENT_NAME VARCHAR(2000),    
  CLIENT_LAST_NAME VARCHAR(2000),    
  CLIENT_FIRST_NAME VARCHAR(2000),    
  CLIENT_EMAIL VARCHAR(2000),    
  CLIENT_ATTORNEY_NAME_1 VARCHAR(2000),    
  CLIENT_BILLING_ADDRESS VARCHAR(2000),    
  CLIENT_BILLING_CITY VARCHAR(2000),    
  CLIENT_BILLING_STATE VARCHAR(2000),    
  CLIENT_BILLING_ZIP VARCHAR(2000),    
  CLIENT_BILLING_FAX VARCHAR(2000),    
  CLIENT_BILLING_PHONE VARCHAR(2000),    
  ADMINISTRATIVE_ASSISTANT VARCHAR(2000),    
  NOTARY_DETAILS VARCHAR(2000),    
  NOTARY_SIGNED_BY_NAME VARCHAR(2000),    
  POSTAGE_ADDRESS VARCHAR(2000),    
      
  NOW_MONTH VARCHAR(2000),    
  NOW_YEAR VARCHAR(2000),
  NOW_DAY VARCHAR(8),  
  NOW_PRIFIX VARCHAR(8),    
  NOWDT VARCHAR(2000),    
  TODAY_DATE VARCHAR(2000),    
      
  --Operating Doctor--     
  DOCTOR_NAME VARCHAR(2000),    
    
  --Login User Details    
  LOGIN_USER_FNAME VARCHAR(500),    
  LOGIN_USER_LNAME VARCHAR(500),    
  LOGIN_USER_NAME VARCHAR(500),    
  JUDGE_NAME      VARCHAR(MAX),    
  --Opposing Counsel New    
  OPPOSING_COUNSEL_NAME   VARCHAR(MAX),    
  OPPOSING_COUNSEL_LAWFIRM  VARCHAR(MAX),    
  OPPOSING_COUNSEL_ATTORNEY_BAR_NUMBER VARCHAR(MAX),    
  OPPOSING_COUNSEL_ADDRESS  VARCHAR(MAX),    
  OPPOSING_COUNSEL_STATE   VARCHAR(MAX),    
  OPPOSING_COUNSEL_ZIP   VARCHAR(MAX),    
  OPPOSING_COUNSEL_PHONE   VARCHAR(MAX),    
  OPPOSING_COUNSEL_FAX   VARCHAR(MAX),    
  OPPOSING_COUNSEL_EMAIL   VARCHAR(MAX),    
  OPPOSING_COUNSEL_CITY   VARCHAR(MAX),    
      
  --Plaintiff Attorney New    
  PLAINTIFF_ATTORNEY_NAME   VARCHAR(MAX),    
  PLAINTIFF_ATTORNEY_LAWFIRM  VARCHAR(MAX),    
  PLAINTIFF_ATTORNEY_BAR_NUMBER VARCHAR(MAX),    
  PLAINTIFF_ATTORNEY_ADDRESS  VARCHAR(MAX),    
  PLAINTIFF_ATTORNEY_STATE  VARCHAR(MAX),    
  PLAINTIFF_ATTORNEY_ZIP   VARCHAR(MAX),    
  PLAINTIFF_ATTORNEY_PHONE  VARCHAR(MAX),    
  PLAINTIFF_ATTORNEY_FAX   VARCHAR(MAX),    
  PLAINTIFF_ATTORNEY_EMAIL  VARCHAR(MAX),    
  PLAINTIFF_ATTORNEY_CITY   VARCHAR(MAX),    
    
  TREATING_PHYSICIAN    VARCHAR(MAX),    
  READING_PHYSICIAN    VARCHAR(MAX),    
  PRESCRIBING_PHYSICIAN   VARCHAR(MAX),    
  PLAINTIFF_DEPOSITION_DATE_TIME VARCHAR(MAX),    
  CORPORATE_REP     VARCHAR(MAX),    
  [90_DAYS_FROM_DATE_FILED]       VARCHAR(MAX),    
  MOTION_HEARING_DATE_TIME        VARCHAR(MAX),    
  WORKFLOW_SETTLEMENT_DATE  VARCHAR(MAX),    
  CASE_EVALUATION_DATE   VARCHAR(MAX),    
  FACILITATION_DATE    VARCHAR(MAX),    
  SETTLEMENT_CONFERENCE_DATE      VARCHAR(MAX),    
  -- For Packeted Cases    
  PROVIDER_NAME_ALL VARCHAR(MAX),    
  INJURED_NAME_ALL VARCHAR(MAX),    
  BALANCE_AMOUNT_ALL Float ,    
  PROVIDER_ADDRESS_ALL VARCHAR(MAX),    
  DOSEND60DAY VARCHAR(MAX),
  POM_DATE varchar(MAX),
  -- For TPA Details
  TPA_YES VARCHAR(10),
  TPA_NO VARCHAR(10),
  TPA_GROUP_NAME VARCHAR(500),
  TPA_ADDRESS VARCHAR(250),
  TPA_CITY VARCHAR(100),
  TPA_STATE VARCHAR(20),
  TPA_ZIPCODE VARCHAR(50),
  TPA_EMAIL  VARCHAR(50)  
 )    
 DECLARE @PROVIDER_NAME_ALL VARCHAR(MAX) ='',    
   @INJURED_NAME_ALL VARCHAR(MAX) = '',    
   @BALANCE_AMOUNT_ALL Float =0,    
   @PROVIDER_ADDRESS_ALL VARCHAR(MAX)= '',    
   @DOSEND60DAY VARCHAR(MAX) = ''    
    
 DECLARE @s_l_DeductibleAmount decimal(19,2)    
 IF(@DomainId = 'AF')    
 BEGIN    
  SELECT @s_l_DeductibleAmount = Sum(ISNULL(DeductibleAmount,0.00)) FROM tblTreatment where case_id = @s_a_case_id AND DomainId = 'AF'    
 END    
 ELSE    
 BEGIN    
 SET @s_l_DeductibleAmount=0    
 END    
 DECLARE @s_l_PacketID VARCHAR(1000) = ''    
    
 IF (Exists(Select Packet_Auto_ID from tblPacket where PacketID=@s_a_case_id))    
 BEGIN    
    SET @s_l_PacketID = @s_a_case_id    
 END    
 ELSE    
 BEGIN    
  SET @s_l_PacketID = ( SELECT  TOP 1 ISNULL(PacketID,'') FROM dbo.tblCase cas    
  INNER  JOIN dbo.tblPacket pkt ON cas.FK_Packet_ID = pkt.Packet_Auto_ID     
  WHERE CASE_ID = @s_a_case_id)    
 END    
    
 IF(@s_l_PacketID  IS NULL or @s_l_PacketID = '')    
 BEGIN    
   --PRINT 'Without PacketID'    
	  INSERT INTO @template_case_details     
	  SELECT top 100    
		PROVIDER_SUITNAME =   UPPER(ISNULL(PRO.PROVIDER_SUITNAME,'')),    
		PROVIDER_LOCAL_ADDRESS =   ISNULL(REPLACE(REPLACE(PROVIDER_LOCAL_ADDRESS, CHAR(13), ' '), CHAR(10), ' '),''),  
		PROVIDER_LOCAL_CITY =   ISNULL(PRO.PROVIDER_LOCAL_CITY,''),    
		PROVIDER_LOCAL_STATE =   ISNULL(PRO.PROVIDER_LOCAL_STATE,''),    
		PROVIDER_LOCAL_ZIP =   ISNULL(PRO.PROVIDER_LOCAL_ZIP,''), 
		PROVIDER_LOCAL_PHONE =   ISNULL(PRO.PROVIDER_LOCAL_PHONE,''),
		PROVIDER_EMAIL	=	ISNULL(PRO.PROVIDER_EMAIL,''),
		PROVIDER_LOCAL_FAX =   ISNULL(PRO.PROVIDER_LOCAL_FAX,''),  
		PROVIDER_TAXID =  ISNULL(PRO.PROVIDER_TAXID,''),    
		PROVIDER_PERM_ADDRESS  =  ISNULL(REPLACE(REPLACE(PROVIDER_PERM_ADDRESS, CHAR(13), ' '), CHAR(10), ' '),''), --ISNULL(PRO.PROVIDER_PERM_ADDRESS,''),    
		PROVIDER_PERM_CITY  =  ISNULL(PRO.PROVIDER_PERM_CITY,''),    
		PROVIDER_PERM_STATE  =  ISNULL(PRO.PROVIDER_PERM_STATE,''),    
		PROVIDER_PERM_ZIP =  ISNULL(PRO.PROVIDER_PERM_ZIP,''),    
		PROVIDER_PRESIDENT = ISNULL(PRO.PROVIDER_PRESIDENT,''),    
		PROVIDER_BILLING = ISNULL(PRO.PROVIDER_BILLING,''),    
		PROVIDER_INTBILLING = ISNULL(PRO.PROVIDER_INTBILLING,''),    
		PROVIDER_INITIAL_BILLING = ISNULL(PRO.PROVIDER_INITIAL_BILLING,''),    
		PROVIDER_INITIAL_INTBILLING= ISNULL(PRO.PROVIDER_INITIAL_INTBILLING,''),    
      
    
		ACCIDENT_DATE =   ISNULL(CONVERT(VARCHAR(10), CAS.Accident_Date, 101),''),    
		DATE_BILLSENT =   ISNULL(CONVERT(VARCHAR(10), CAS.Date_BillSent, 101),''),    
		CASE_ID =   ISNULL(CAS.CASE_ID,''),    
		PACKET_OR_CASE_ID =   ISNULL(CAS.CASE_ID,''),    
		CLAIM_AMOUNT =   CONVERT(VARCHAR, CAST(ISNULL(CAS.CLAIM_AMOUNT,0.00) as money),1),    
		PAID_AMOUNT = CONVERT(VARCHAR, CAST(ISNULL(CAS.PAID_AMOUNT,0.00) as money),1),     
		--BALANCE_AMOUNT = CONVERT(VARCHAR,(convert(MONEY, (CONVERT(FLOAT, isnull(CAS.CLAIM_AMOUNT,0.00)) - CONVERT(FLOAT, isnull(CAS.PAID_AMOUNT,0.00)))))),     
		BALANCE_AMOUNT = CONVERT(VARCHAR, CAST(ISNULL(CAS.CLAIM_AMOUNT,0.00) - ISNULL(CAS.PAID_AMOUNT,0.00) - ISNULL(CAS.writeOff,0.00) - @s_l_DeductibleAmount  as money),1),    
		INDEXORAAA_NUMBER= UPPER(ISNULL(CAS.INDEXORAAA_NUMBER,'')),    
		Date_Index_Number_Purchased = CONVERT(VARCHAR(10),ISNULL(CAS.Date_Index_Number_Purchased,''),101),    
    
		--DOS_END =   CONVERT(NVARCHAR(12),CONVERT(DATETIME, CAS.DATEOFSERVICE_END), 101),    
		--DOS_START =   CONVERT(NVARCHAR(12),CONVERT(DATETIME, CAS.DATEOFSERVICE_START), 101),    

		DOS_END =   (select CONVERT(VARCHAR(10),MAX(T.DateOfService_End), 101) from tblTreatment T (NOLOCK) where CAS.Case_Id = T.Case_Id  
		and (CAS.Domainid = 'DK' OR convert(decimal(38,2),T.Claim_Amount) - convert(decimal(38,2),ISNULL(T.Paid_Amount,0))- 
	   convert(decimal(38,2),ISNULL(T.WriteOff,0.00))-convert(decimal(38,2),ISNULL(T.DeductibleAmount,0.00)) > 0) 
	   AND (CAS.Domainid = 'DK' OR ISNULL(T.DenialReason_ID,0) NOT 
	   IN(SELECT DenialReasons_Id from tblDenialReasons where DenialReasons_Type like 'PAID IN FULL'))   
	   AND (CAS.Domainid = 'DK' OR T.Treatment_Id NOT IN 
		   (select Treatment_Id from TXN_tblTreatment where DenialReasons_ID IN   
			  (SELECT DenialReasons_Id from tblDenialReasons where DenialReasons_Type like 'PAID IN FULL')))),    
		DOS_START =   (select CONVERT(VARCHAR(10),MIN(T.DateOfService_Start), 101) from tblTreatment T (NOLOCK) where CAS.Case_Id = T.Case_Id  
		and (CAS.Domainid = 'DK' OR convert(decimal(38,2),T.Claim_Amount) - convert(decimal(38,2),ISNULL(T.Paid_Amount,0))- 
	   convert(decimal(38,2),ISNULL(T.WriteOff,0.00))-convert(decimal(38,2),ISNULL(T.DeductibleAmount,0.00)) > 0) 
	   AND (CAS.Domainid = 'DK' OR ISNULL(T.DenialReason_ID,0) NOT 
	   IN(SELECT DenialReasons_Id from tblDenialReasons where DenialReasons_Type like 'PAID IN FULL'))   
	   AND (CAS.Domainid = 'DK' OR T.Treatment_Id NOT IN 
		   (select Treatment_Id from TXN_tblTreatment where DenialReasons_ID IN   
			  (SELECT DenialReasons_Id from tblDenialReasons where DenialReasons_Type like 'PAID IN FULL'))) )
,

		--DOS_RANGE_ALL = STUFF((SELECT '^p' +CONVERT(VARCHAR,DateOfService_Start,101) + '-' + CONVERT(VARCHAR,DateOfService_End,101) FROM tblTreatment     
		--     WHERE case_id = cas.Case_Id ORDER BY DateOfService_Start ASC FOR XML PATH('')), 1, 2, ''),     
		DOS_RANGE_ALL =STUFF((SELECT '^p' +CONVERT(VARCHAR,DateOfService_Start,101) + '-' + CONVERT(VARCHAR,DateOfService_End,101) FROM tblTreatment       
			   WHERE cast(case_id as varchar(50)) = cas.Case_Id     
			   and Treatment_Id not in (    
			select Treatment_Id from tblTreatment TR with(nolock)    
			inner JOIN tblDenialReasons TDR on TR.DenialReason_ID = TDR.DenialReasons_Id and TDR.DenialReasons_Type='PAID IN FULL'    
			and cast(TR.Case_Id as varchar(50))=cas.Case_Id and @DomainId='RLF'    
			UNION     
			select Treatment_Id from tblTreatment TR with(nolock)    
			where (isnull(Claim_Amount,0.00) - isnull(Paid_Amount,0.00)) <= 0.00 and     
			cast(TR.Case_Id as varchar(50))=cas.Case_Id and @DomainId='RLF'    
    
			)    
			  ORDER BY DateOfService_Start ASC FOR XML PATH('')), 1, 2, ''),    
    
    
		INJUREDPARTY_NAME =  UPPER(ISNULL(CAS.INJUREDPARTY_FIRSTNAME, N'')) + N' ' + UPPER(ISNULL(CAS.INJUREDPARTY_LASTNAME, N'')),    
		INS_CLAIM_NUMBER =   ISNULL(CAS.INS_CLAIM_NUMBER,''),    
		POLICY_NUMBER =   ISNULL(CAS.POLICY_NUMBER,'-'),    
		INJUREDPARTY_LASTNAME = UPPER(ISNULL(CAS.INJUREDPARTY_LASTNAME,'')),     
		INJUREDPARTY_FIRSTNAME = UPPER(ISNULL(CAS.INJUREDPARTY_FIRSTNAME,'')),    
		INJUREDPARTY_FULL_ADDRESS = Case when ISNULL(CAS.INJUREDPARTY_ADDRESS,'')<> ''     
			Then UPPER(ISNULL(CAS.INJUREDPARTY_ADDRESS,'') +', '+ISNULL(CAS.INJUREDPARTY_CITY,'') +', '+ISNULL(CAS.INJUREDPARTY_STATE,'')+', '+ISNULL(CAS.INJUREDPARTY_ZIP,''))    
			else 'N/A'  End,    
  
	 INSUREDPARTY_NAME = UPPER(ISNULL(CAS.INSUREDPARTY_FIRSTNAME, N'')) + N' ' + UPPER(ISNULL(CAS.INSUREDPARTY_LASTNAME, N'')),    
		INSUREDPARTY_LASTNAME = UPPER(ISNULL(CAS.INSUREDPARTY_LASTNAME,'')),     
		INSUREDPARTY_FIRSTNAME = UPPER(ISNULL(CAS.INSUREDPARTY_FIRSTNAME,'')),    
		INSUREDPARTY_ADDRESS = ISNULL(CAS.INSUREDPARTY_ADDRESS,''),    
        
        
         
		REPRESENTETIVE_NAME = UPPER(ISNULL(CAS.Representetive,'')),    
		REPRESENTATIVE_CONTACT_NUMBER = isnull(CAS.REPRESENTATIVE_CONTACT_NUMBER,''),    
		--ASSIGNED_ATTORNEY = ISNULL(a_att.ASSIGNED_ATTORNEY,''),    
    
        
		-- Insurance Details    
		INSURANCECOMPANY_SUITNAME  =  UPPER(ISNULL(INS.INSURANCECOMPANY_SUITNAME,'')),    
		INSURANCECOMPANY_NAME =   UPPER(ISNULL(INS.INSURANCECOMPANY_NAME,'')),    
		INSURANCECOMPANY_LOCAL_ADDRESS =   ISNULL(REPLACE(REPLACE(INS.INSURANCECOMPANY_LOCAL_ADDRESS, CHAR(13), ' '), CHAR(10), ' '),''), --ISNULL(INS.INSURANCECOMPANY_LOCAL_ADDRESS,''),    
		INSURANCECOMPANY_LOCAL_CITY =   ISNULL(INS.INSURANCECOMPANY_LOCAL_CITY,''),    
		INSURANCECOMPANY_LOCAL_COUNTY =   ISNULL(INS.InsuranceCompany_Local_County,''),    
		INSURANCECOMPANY_LOCAL_STATE =   ISNULL(INS.INSURANCECOMPANY_LOCAL_STATE,''),    
		INSURANCECOMPANY_LOCAL_ZIP =   ISNULL(INS.INSURANCECOMPANY_LOCAL_ZIP,''),     
		INSURANCECOMPANY_LOCAL_FAX =   ISNULL(INS.INSURANCECOMPANY_LOCAL_FAX,''),     
		INSURANCECOMPANY_LOCAL_PHONE =ISNULL(INS.INSURANCECOMPANY_LOCAL_PHONE,''),  
		INSURANCECOMPANY_EMAIL = ISNULL(INS.INSURANCECOMPANY_EMAIL,''),  
		INSURANCECOMPANY_PERM_ADDRESS = ISNULL(INS.InsuranceCompany_Perm_Address,''),    
		INSURANCECOMPANY_PERM_CITY = ISNULL(INS.InsuranceCompany_Perm_City,''),    
		INSURANCECOMPANY_PERM_COUNTY = ISNULL(INS.InsuranceCompany_Perm_County,''),    
		INSURANCECOMPANY_PERM_STATE = ISNULL(INS.InsuranceCompany_Perm_State,''),    
		INSURANCECOMPANY_PERM_ZIP = ISNULL(INS.InsuranceCompany_Perm_Zip,''),    
		INSURANCECOMPANY_PERM_FAX = ISNULL(INS.InsuranceCompany_Perm_Fax,''),    
		INSURANCECOMPANY_PERM_PHONE = ISNULL(INS.InsuranceCompany_Perm_Phone,''),    
		-- Court Details    
		COURT_NAME = UPPER(ISNULL(COURT.COURT_NAME,'')),     
		COURT_VENUE = UPPER(ISNULL(COURT.COURT_VENUE,'')),     
    
	   NEW_COURT_VENUE = CASE when (pro.Provider_Local_Address like '%brooklyn%' or pro.Provider_Local_City like '%brooklyn%'    
		or INS.InsuranceCompany_Local_Address like '%brooklyn%' OR INS.InsuranceCompany_Local_City like '%brooklyn%'    
					OR INS.InsuranceCompany_Perm_Address like '%brooklyn%' OR INS.InsuranceCompany_Perm_City like '%brooklyn%') then 'BROOKLYN'     
		else UPPER(ISNULL(COURT.COURT_VENUE,'')) end,    
    
    
		COURT_ADDRESS = ISNULL(COURT.COURT_ADDRESS,''),     
		COURT_BASIS=ISNULL(COURT.COURT_BASIS,''),    
		   COURT_MISC=ISNULL(COURT.Court_Misc,''),    
		COURT_MISC_DISTRICT= Case When COURT.COURT_NAME like '%'+'District'+'%' Then ISNULL(COURT.Court_Misc,'') Else '' End ,    
		COURT_MISC_CIRCUIT= Case When COURT.COURT_NAME like '%'+'Circuit'+'%' Then ISNULL(COURT.Court_Misc,'') Else '' End ,    
		COURT_CITY=ISNULL(COURT.City,''),    
		COURT_COUNTY=ISNULL(COURT.County,''),    
    
		-- Settlement    
		SETTLED_WITH_NAME = ISNULL(SETT.SETTLED_WITH_NAME, N''),     
		SETTLED_WITH_PHONE = ISNULL(SETT.SETTLED_WITH_PHONE, N'') ,     
		SETTLED_WITH_FAX = ISNULL(SETT.SETTLED_WITH_FAX, N''),     
		SETTLEMENT_AMOUNT = ISNULL(SETT.SETTLEMENT_AMOUNT,0.00),     
		SETTLEMENT_INT = ISNULL(SETT.SETTLEMENT_INT,''),     
		SETTLEMENT_AF = ISNULL(SETT.SETTLEMENT_AF,''),     
		SETTLEMENT_FF = ISNULL(SETT.SETTLEMENT_FF,''),     
		SETTLEMENT_TOTAL = ISNULL(SETT.SETTLEMENT_TOTAL,''),     
		SETTLEMENT_DATE = ISNULL(SETT.SETTLEMENT_DATE,''),     
		SETTLEDWITH = ISNULL(SETT.SETTLEDWITH,''),    
    
		--- Transaction  Details    
		TRANSACTIONS_AMOUNT_COLLECTED = (SELECT  ISNULL(sum(Transactions_Amount),0.00) FROM tblTransactions WHERE case_id = CAS.Case_Id and DomainId = cas.DomainId and Transactions_Type IN ('C', 'PreC')),    
		TRANSACTIONS_AMOUNT_INT =(SELECT ISNULL(sum(Transactions_Amount),0.00) FROM tblTransactions WHERE case_id = CAS.Case_Id and DomainId = cas.DomainId and Transactions_Type IN ('C', 'PreC')),    
		TRANSACTIONS_AMOUNT_AF  =(SELECT  ISNULL(sum(Transactions_Amount),0.00) FROM tblTransactions WHERE case_id = CAS.Case_Id and DomainId = cas.DomainId and Transactions_Type IN ('C', 'PreC')),    
    
		--Adjuster    
		ADJUSTER_NAME = ISNULL(ADJ.ADJUSTER_FIRSTNAME, N'') + N'  ' + ISNULL(ADJ.ADJUSTER_LASTNAME, N''),    
		ADJUSTER_LASTNAME = ISNULL(ADJ.ADJUSTER_LASTNAME,'') ,    
		ADJUSTER_FIRSTNAME = ISNULL(ADJ.ADJUSTER_FIRSTNAME,'') ,    
		ADJUSTER_PHONE = ISNULL(ADJ.ADJUSTER_PHONE,'') ,    
		ADJUSTER_FAX = ISNULL(ADJ.ADJUSTER_FAX,'') ,    
		ADJUSTER_EMAIL = ISNULL(ADJ.ADJUSTER_EMAIL,'') ,    
        
		-- Attorney  
		ATTORNEY_FILENUMBER  =   ISNULL(CAS.Attorney_FileNumber,''),   
		ATTORNEY_NAME = ISNULL(ATT.ATTORNEY_FIRSTNAME, N'') + N'  ' + ISNULL(ATT.ATTORNEY_LASTNAME, N'') ,    
		ATTORNEY_LASTNAME  = ISNULL(ATT.ATTORNEY_LASTNAME,'') ,    
		ATTORNEY_FIRSTNAME  = ISNULL(ATT.ATTORNEY_FIRSTNAME,'') ,    
		ATTORNEY_ADDRESS  = ISNULL(ATT.ATTORNEY_ADDRESS,'') ,    
		ATTORNEY_CITY  = ISNULL(ATT.ATTORNEY_CITY,'') ,    
		ATTORNEY_STATE  = ISNULL(ATT.ATTORNEY_STATE,'') ,    
		ATTORNEY_ZIP  = ISNULL(ATT.ATTORNEY_ZIP,'') ,    
		ATTORNEY_PHONE  = ISNULL(ATT.ATTORNEY_PHONE,'') ,    
		ATTORNEY_FAX  = ISNULL(ATT.ATTORNEY_FAX,'') ,    
		ATTORNEY_EMAIL = ISNULL(ATT.ATTORNEY_EMAIL,'') ,    
    
		-- DEFENDANT    
		DEFENDANT_NAME  = ISNULL(DEF.DEFENDANT_NAME,'') ,    
		DEFENDANT_ADDRESS  = ISNULL(DEF.DEFENDANT_ADDRESS,'')  ,    
		DEFENDANT_STATE  = ISNULL(DEF.DEFENDANT_STATE,'')  ,    
		DEFENDANT_ZIP  = ISNULL(DEF.DEFENDANT_ZIP,'')  ,    
		DEFENDANT_PHONE  = ISNULL(DEF.DEFENDANT_PHONE,'')  ,    
		DEFENDANT_FAX  = ISNULL(DEF.DEFENDANT_FAX,'')  ,    
		DEFENDANT_EMAIL  = ISNULL(DEF.DEFENDANT_EMAIL,'')  ,    
		DEFENDANT_CITY = ISNULL(DEF.DEFENDANT_CITY,'')  ,    
		--Date    
     
		--SERVED_ON_DATE = STUFF(REPLACE('/'+CONVERT(CHAR(10),ISNULL(CAS.SERVED_ON_DATE,''),101),'/0','/'),1,1,''),    
		SERVED_ON_DATE = DATENAME(MM,CAS.SERVED_ON_DATE) + RIGHT(CONVERT(VARCHAR(12), CAS.SERVED_ON_DATE, 107), 9),    
		SERVED_ON_TIME = ISNULL(CAS.SERVED_ON_TIME,''),    
		SERVED_ON_DAY =  STUFF(REPLACE('/'+CONVERT(CHAR(10),DATEPART(DD,CAS.SERVED_ON_DATE),101),'/0','/'),1,1,''),    
		SERVED_ON_MONTH = STUFF(REPLACE('/'+CONVERT(CHAR(10),DATENAME(MM,CAS.SERVED_ON_DATE),101),'/0','/'),1,1,''),    
		SERVED_ON_YEAR = STUFF(REPLACE('/'+CONVERT(CHAR(10),DATEPART(YY,CAS.SERVED_ON_DATE),101),'/0','/'),1,1,''), 
		Date_Answer_Received = DATENAME(MM,casdate.Date_Answer_Received) + RIGHT(CONVERT(VARCHAR(12), casdate.Date_Answer_Received, 107), 9),   
		--Served_Person    
		SERVED_PERSON_NAME = ISNULL(SER.NAME,''),    
		SERVED_PERSON_HEIGHT =ISNULL(SER.HEIGHT,''),    
		SERVED_PERSON_WEIGHT = ISNULL(SER.WEIGHT,''),    
		SERVED_PERSON_AGE = ISNULL(SER.AGE,''),    
		SERVED_PERSON_SKIN_COLOUR = ISNULL(SER.SKIN,''),    
		SERVED_PERSON_HAIR_COLOUR = ISNULL(SER.HAIR,''),    
		SERVED_PERSON_GENDER = ISNULL(SER.SEX,''),    
    
        
		-- Notes    
		DELAY_NOTES = (Select top 1 Notes_desc FROM tblNotes WHERE Case_ID = CAS.Case_Id and DomainId = @DomainId and Notes_Type like 'DELAY%' order by Notes_ID desc),    
        
		-- Client Details    
		LAWFIRMNAME =   ISNULL(CL.LAWFIRMNAME,''),    
		CLIENT_NAME =   ISNULL(CL.Client_First_Name,'')+' '+ ISNULL(CL.Client_Last_Name,''),    
		CLIENT_LAST_NAME = ISNULL(CL.Client_Last_Name,''),    
		CLIENT_FIRST_NAME = ISNULL(CL.Client_First_Name,''),    
		CLIENT_EMAIL = ISNULL(CL.Client_Email,''),    
		CLIENT_ATTORNEY_NAME_1 =   ISNULL(CL_OD.CLIENT_ATTORNEY_NAME_1,''),    
		CLIENT_BILLING_ADDRESS =   ISNULL(CL.CLIENT_BILLING_ADDRESS,''),    
		CLIENT_BILLING_CITY =   ISNULL(CL.CLIENT_BILLING_CITY,''),    
		CLIENT_BILLING_STATE =   ISNULL(CL.CLIENT_BILLING_STATE,''),    
		CLIENT_BILLING_ZIP =   ISNULL(CL.CLIENT_BILLING_ZIP,''),    
		CLIENT_BILLING_FAX =  ISNULL(CL.CLIENT_BILLING_FAX,''),    
		CLIENT_BILLING_PHONE =   ISNULL(CL.CLIENT_BILLING_PHONE,''),    
		ADMINISTRATIVE_ASSISTANT =   ISNULL(CL_OD.ADMINISTRATIVE_ASSISTANT,''),    
		NOTARY_DETAILS =   ISNULL(CL_OD.NOTARY_DETAILS,''),    
		NOTARY_SIGNED_BY_NAME =   ISNULL(CL_OD.NOTARY_SIGNED_BY_NAME,''),    
		POSTAGE_ADDRESS =   ISNULL(CL_OD.POSTAGE_ADDRESS,''),    
    
		-- Date    
		NOW_MONTH =   DATENAME(month,GETDATE()) ,    
		NOW_YEAR =   DATEPART(yy,GETDATE()), 
	
		NOW_DAY = CONVERT(VARCHAR,DATEPART(DD,@dt_NOW)),  
		NOW_PRIFIX = FORMAT(@dt_NOW,  
			IIF(DAY(@dt_NOW) IN (1,21,31),'''st'''  
			,IIF(DAY(@dt_NOW) IN (2,22),'''nd'''  
			,IIF(DAY(@dt_NOW) IN (3,23),'''rd''','''th''')))), 
	
		NOWDT = convert(varchar(10),GETDATE(),101),	   
		--NOWDT =   STUFF(REPLACE('/'+CONVERT(CHAR(10),GETDATE(),101),'/0','/'),1,1,''),    
		TODAY_DATE =   DATENAME(MM, GETDATE()) + RIGHT(CONVERT(VARCHAR(12), GETDATE(), 107), 9),    
    
		DOCTOR_NAME =  ISNULL(dbo.[fncGetOperatingDoctor](@domainId, cas.case_id),''),    
		LOGIN_USER_FNAME = ISNULL(USR.first_name,''),    
		LOGIN_USER_LNAME = ISNULL(USR.last_name,''),    
		LOGIN_USER_NAME = ISNULL(USR.first_name,'') +  ' ' +ISNULL(USR.last_name,''),    
    
		JUDGE_NAME    = ISNULL(arbit.ARBITRATOR_NAME,''),         
		-- OPPOSING COUNSEL    
		OPPOSING_COUNSEL_NAME  = (Select top 1 isnull(Attorney_FirstName, '') + ' ' + isnull(Attorney_LastName, '') as Attorney_Name    
				from tblAttorney_Case_Assignment ACA INNER JOIN tblAttorney_Master AM ON AM.Attorney_Id = ACA.Attorney_Id    
				INNER JOIN tblAttorney_Type ATP ON ATP.Attorney_Type_ID = AM.Attorney_Type_Id    
				Where Case_Id = @s_a_case_id and ACA.DomainId = @DomainId and lower(Attorney_Type) = 'opposing counsel' order by Assignment_Id desc),    
		OPPOSING_COUNSEL_LAWFIRM= (Select top 1 isnull(LawFirmName, '') as LawFirmName    
				from tblAttorney_Case_Assignment ACA INNER JOIN tblAttorney_Master AM ON AM.Attorney_Id = ACA.Attorney_Id    
				INNER JOIN tblAttorney_Type ATP ON ATP.Attorney_Type_ID = AM.Attorney_Type_Id    
				Where Case_Id = @s_a_case_id and ACA.DomainId = @DomainId and lower(Attorney_Type) = 'opposing counsel' order by Assignment_Id desc),    
    
		   OPPOSING_COUNSEL_ATTORNEY_BAR_NUMBER = (Select top 1 isnull(Attorney_BAR_Number, '') as Attorney_BAR_Number    
				from tblAttorney_Case_Assignment ACA INNER JOIN tblAttorney_Master AM ON AM.Attorney_Id = ACA.Attorney_Id    
				INNER JOIN tblAttorney_Type ATP ON ATP.Attorney_Type_ID = AM.Attorney_Type_Id    
				Where Case_Id = @s_a_case_id and ACA.DomainId = @DomainId and lower(Attorney_Type) = 'opposing counsel' order by Assignment_Id desc),    
    
		OPPOSING_COUNSEL_ADDRESS = (Select top 1 isnull(Attorney_Address,'')    
				from tblAttorney_Case_Assignment ACA INNER JOIN tblAttorney_Master AM ON AM.Attorney_Id = ACA.Attorney_Id    
				INNER JOIN tblAttorney_Type ATP ON ATP.Attorney_Type_ID = AM.Attorney_Type_Id    
				Where Case_Id = @s_a_case_id and ACA.DomainId = @DomainId and lower(Attorney_Type) = 'opposing counsel' order by Assignment_Id desc),    
		OPPOSING_COUNSEL_STATE = (Select top 1 isnull(Attorney_State,'')    
			   from tblAttorney_Case_Assignment ACA INNER JOIN tblAttorney_Master AM ON AM.Attorney_Id = ACA.Attorney_Id    
			   INNER JOIN tblAttorney_Type ATP ON ATP.Attorney_Type_ID = AM.Attorney_Type_Id    
			   Where Case_Id = @s_a_case_id and ACA.DomainId = @DomainId and lower(Attorney_Type) = 'opposing counsel' order by Assignment_Id desc),    
		OPPOSING_COUNSEL_ZIP  = (Select top 1 isnull(Attorney_Zip,'')    
			   from tblAttorney_Case_Assignment ACA INNER JOIN tblAttorney_Master AM ON AM.Attorney_Id = ACA.Attorney_Id    
			   INNER JOIN tblAttorney_Type ATP ON ATP.Attorney_Type_ID = AM.Attorney_Type_Id    
			   Where Case_Id = @s_a_case_id and ACA.DomainId = @DomainId and lower(Attorney_Type) = 'opposing counsel' order by Assignment_Id desc),    
		OPPOSING_COUNSEL_PHONE = (Select top 1 isnull(Attorney_Phone,'')    
			   from tblAttorney_Case_Assignment ACA INNER JOIN tblAttorney_Master AM ON AM.Attorney_Id = ACA.Attorney_Id    
			   INNER JOIN tblAttorney_Type ATP ON ATP.Attorney_Type_ID = AM.Attorney_Type_Id    
			   Where Case_Id = @s_a_case_id and ACA.DomainId = @DomainId and lower(Attorney_Type) = 'opposing counsel' order by Assignment_Id desc),    
		OPPOSING_COUNSEL_FAX  = (Select top 1 isnull(Attorney_Fax,'')    
			   from tblAttorney_Case_Assignment ACA INNER JOIN tblAttorney_Master AM ON AM.Attorney_Id = ACA.Attorney_Id    
			   INNER JOIN tblAttorney_Type ATP ON ATP.Attorney_Type_ID = AM.Attorney_Type_Id    
			   Where Case_Id = @s_a_case_id and ACA.DomainId = @DomainId and lower(Attorney_Type) = 'opposing counsel' order by Assignment_Id desc),    
		OPPOSING_COUNSEL_EMAIL = (Select top 1 isnull(Attorney_Email,'')    
			   from tblAttorney_Case_Assignment ACA INNER JOIN tblAttorney_Master AM ON AM.Attorney_Id = ACA.Attorney_Id    
			   INNER JOIN tblAttorney_Type ATP ON ATP.Attorney_Type_ID = AM.Attorney_Type_Id    
			   Where Case_Id = @s_a_case_id and ACA.DomainId = @DomainId and lower(Attorney_Type) = 'opposing counsel' order by Assignment_Id desc),    
		OPPOSING_COUNSEL_CITY = (Select top 1 isnull(Attorney_City,'')    
			   from tblAttorney_Case_Assignment ACA INNER JOIN tblAttorney_Master AM ON AM.Attorney_Id = ACA.Attorney_Id    
			   INNER JOIN tblAttorney_Type ATP ON ATP.Attorney_Type_ID = AM.Attorney_Type_Id    
			   Where Case_Id = @s_a_case_id and ACA.DomainId = @DomainId and lower(Attorney_Type) = 'opposing counsel' order by Assignment_Id desc),    
		-- PLAINTIFF ATTORNEY    
		PLAINTIFF_ATTORNEY_NAME  = (Select top 1 isnull(Attorney_FirstName, '') + ' ' + isnull(Attorney_LastName, '') as Attorney_Name    
				from tblAttorney_Case_Assignment ACA INNER JOIN tblAttorney_Master AM ON AM.Attorney_Id = ACA.Attorney_Id    
				INNER JOIN tblAttorney_Type ATP ON ATP.Attorney_Type_ID = AM.Attorney_Type_Id    
				Where Case_Id = @s_a_case_id and ACA.DomainId = @DomainId and lower(Attorney_Type) = 'plaintiff attorney' order by Assignment_Id desc),    
		PLAINTIFF_ATTORNEY_LAWFIRM = (Select top 1 isnull(LawFirmName, '') as LawFirmName    
				from tblAttorney_Case_Assignment ACA INNER JOIN tblAttorney_Master AM ON AM.Attorney_Id = ACA.Attorney_Id    
				INNER JOIN tblAttorney_Type ATP ON ATP.Attorney_Type_ID = AM.Attorney_Type_Id    
				Where Case_Id = @s_a_case_id and ACA.DomainId = @DomainId and lower(Attorney_Type) = 'plaintiff attorney' order by Assignment_Id desc),    
		PLAINTIFF_ATTORNEY_BAR_NUMBER = (Select top 1 isnull(Attorney_BAR_Number, '') as Attorney_BAR_Number    
				from tblAttorney_Case_Assignment ACA INNER JOIN tblAttorney_Master AM ON AM.Attorney_Id = ACA.Attorney_Id    
				INNER JOIN tblAttorney_Type ATP ON ATP.Attorney_Type_ID = AM.Attorney_Type_Id    
				Where Case_Id = @s_a_case_id and ACA.DomainId = @DomainId and lower(Attorney_Type) = 'plaintiff attorney' order by Assignment_Id desc),    
		PLAINTIFF_ATTORNEY_ADDRESS = (Select top 1 isnull(Attorney_Address,'')    
				from tblAttorney_Case_Assignment ACA INNER JOIN tblAttorney_Master AM ON AM.Attorney_Id = ACA.Attorney_Id    
				INNER JOIN tblAttorney_Type ATP ON ATP.Attorney_Type_ID = AM.Attorney_Type_Id    
				Where Case_Id = @s_a_case_id and ACA.DomainId = @DomainId and lower(Attorney_Type) = 'plaintiff attorney' order by Assignment_Id desc),    
		PLAINTIFF_ATTORNEY_STATE = (Select top 1 isnull(Attorney_State,'')    
			   from tblAttorney_Case_Assignment ACA INNER JOIN tblAttorney_Master AM ON AM.Attorney_Id = ACA.Attorney_Id    
			   INNER JOIN tblAttorney_Type ATP ON ATP.Attorney_Type_ID = AM.Attorney_Type_Id    
			   Where Case_Id = @s_a_case_id and ACA.DomainId = @DomainId and lower(Attorney_Type) = 'plaintiff attorney' order by Assignment_Id desc),    
		PLAINTIFF_ATTORNEY_ZIP   = (Select top 1 isnull(Attorney_Zip,'')    
			   from tblAttorney_Case_Assignment ACA INNER JOIN tblAttorney_Master AM ON AM.Attorney_Id = ACA.Attorney_Id    
			   INNER JOIN tblAttorney_Type ATP ON ATP.Attorney_Type_ID = AM.Attorney_Type_Id    
			   Where Case_Id = @s_a_case_id and ACA.DomainId = @DomainId and lower(Attorney_Type) = 'plaintiff attorney' order by Assignment_Id desc),    
		PLAINTIFF_ATTORNEY_PHONE= (Select top 1 isnull(Attorney_Phone,'')    
			   from tblAttorney_Case_Assignment ACA INNER JOIN tblAttorney_Master AM ON AM.Attorney_Id = ACA.Attorney_Id    
			   INNER JOIN tblAttorney_Type ATP ON ATP.Attorney_Type_ID = AM.Attorney_Type_Id    
			   Where Case_Id = @s_a_case_id and ACA.DomainId = @DomainId and lower(Attorney_Type) = 'plaintiff attorney' order by Assignment_Id desc),    
		PLAINTIFF_ATTORNEY_FAX  = (Select top 1 isnull(Attorney_Fax,'')    
			   from tblAttorney_Case_Assignment ACA INNER JOIN tblAttorney_Master AM ON AM.Attorney_Id = ACA.Attorney_Id    
			   INNER JOIN tblAttorney_Type ATP ON ATP.Attorney_Type_ID = AM.Attorney_Type_Id    
			   Where Case_Id = @s_a_case_id and ACA.DomainId = @DomainId and lower(Attorney_Type) = 'plaintiff attorney' order by Assignment_Id desc),    
		PLAINTIFF_ATTORNEY_EMAIL = (Select top 1 isnull(Attorney_Email,'')    
			   from tblAttorney_Case_Assignment ACA INNER JOIN tblAttorney_Master AM ON AM.Attorney_Id = ACA.Attorney_Id    
			   INNER JOIN tblAttorney_Type ATP ON ATP.Attorney_Type_ID = AM.Attorney_Type_Id    
			   Where Case_Id = @s_a_case_id and ACA.DomainId = @DomainId and lower(Attorney_Type) = 'plaintiff attorney' order by Assignment_Id desc),    
		PLAINTIFF_ATTORNEY_CITY = (Select top 1 isnull(Attorney_City,'')    
			   from tblAttorney_Case_Assignment ACA INNER JOIN tblAttorney_Master AM ON AM.Attorney_Id = ACA.Attorney_Id    
			   INNER JOIN tblAttorney_Type ATP ON ATP.Attorney_Type_ID = AM.Attorney_Type_Id    
			   Where Case_Id = @s_a_case_id and ACA.DomainId = @DomainId and lower(Attorney_Type) = 'plaintiff attorney' order by Assignment_Id desc),    
		TREATING_PHYSICIAN  = ISNULL((SELECT TOP 1 ISNULL(WL.Name,'N/A') FROM tblCaseWitnessList WL JOIN tblWitnessType WT ON WL.WitnessTypeID = WT.WitnessTypeID WHERE WL.Case_Id = @s_a_case_id AND LOWER(WT.WitnessType) = 'treating physician' ORDER BY WL.WitnessId DESC),'N/A'),    
		READING_PHYSICIAN  = ISNULL((SELECT TOP 1 ISNULL(WL.Name,'N/A') FROM tblCaseWitnessList WL JOIN tblWitnessType WT ON WL.WitnessTypeID = WT.WitnessTypeID WHERE WL.Case_Id = @s_a_case_id AND LOWER(WT.WitnessType) = 'reading physician' ORDER BY WL.WitnessId DESC),'N/A'),    
		PRESCRIBING_PHYSICIAN = ISNULL((SELECT TOP 1 ISNULL(WL.Name,'N/A') FROM tblCaseWitnessList WL JOIN tblWitnessType WT ON WL.WitnessTypeID = WT.WitnessTypeID WHERE WL.Case_Id = @s_a_case_id AND LOWER(WT.WitnessType) = 'prescribing physician' ORDER BY WL.WitnessId DESC),'N/A'),    
		PLAINTIFF_DEPOSITION_DATE_TIME = CASE WHEN ISNULL((SELECT TOP 1 ISNULL(CONVERT(VARCHAR,Plaintiff_Deposition_Date,101),'') FROM tblCase_Date_Details cd WHERE cd.Case_Id = @s_a_case_id),'') <> '' THEN ISNULL((SELECT TOP 1 ISNULL(CONVERT(VARCHAR,Plaintiff_Deposition_Date,101) + ' ' + CONVERT(VARCHAR(15),CAST(Plaintiff_Deposition_Date AS TIME),100)  +' EST','') FROM tblCase_Date_Details cd WHERE cd.Case_Id = @s_a_case_id),'') ELSE '' END,    
		CORPORATE_REP   = ISNULL((SELECT TOP 1 ISNULL(WL.Name,'') FROM tblCaseWitnessList WL JOIN tblWitnessType WT ON WL.WitnessTypeID = WT.WitnessTypeID WHERE WL.Case_Id = @s_a_case_id AND LOWER(WT.WitnessType) = 'corporate rep' ORDER BY WL.WitnessId DESC),''),    
		[90_DAYS_FROM_DATE_FILED] = CASE WHEN ISNULL((SELECT TOP 1 ISNULL(CONVERT(VARCHAR,Date_Filed,101),'') FROM tblCase_Date_Details cd WHERE cd.Case_Id = @s_a_case_id),'') <> '' THEN ISNULL((SELECT TOP 1 ISNULL(CONVERT(VARCHAR,DATEADD(DD,90,Date_Filed),101),'') FROM tblCase_Date_Details cd WHERE cd.Case_Id = @s_a_case_id),'') ELSE '' END,    
		MOTION_HEARING_DATE_TIME = CASE WHEN ISNULL((SELECT TOP 1 ISNULL(CONVERT(VARCHAR,MotionHearingDate,101),'') FROM tblCaseDateMotionMapping cm inner join tblCase_Date_Details cd on cd.Auto_Id = cm.CaseDateDetailsID WHERE cd.Case_Id = @s_a_case_id),'') <> '' THEN ISNULL((SELECT TOP 1 ISNULL(CONVERT(VARCHAR,MotionHearingDate,101) + ' ' + CONVERT(VARCHAR(15),CAST(MotionHearingDate AS TIME),100)  +' EST','') FROM tblCaseDateMotionMapping cm inner join tblCase_Date_Details cd on cd.Auto_Id = cm.CaseDateDetailsID WHERE cd.Case_Id = @s_a_case_id),'') ELSE '' END,    
		WORKFLOW_SETTLEMENT_DATE =  ISNULL((Select TOP 1 ISNULL(Convert(Varchar(50), Settlement_Date, 101),'') AS Settlement_Date from tblCase_Date_Details Where Case_Id = @s_a_case_id),''),    
		CASE_EVALUATION_DATE = ISNULL((Select TOP 1 ISNULL(Convert(Varchar(50), CASE_EVALUATION_DATE, 101),'') AS CASE_EVALUATION_DATE from tblCase_Date_Details Where Case_Id = @s_a_case_id),''),    
		FACILITATION_DATE  = ISNULL((Select TOP 1 ISNULL(Convert(Varchar(50), FACILITATION_DATE, 101),'') AS FACILITATION_DATE from tblCase_Date_Details Where Case_Id = @s_a_case_id),''),    
		SETTLEMENT_CONFERENCE_DATE = ISNULL((Select TOP 1 ISNULL(Convert(Varchar(50), SETTLEMENT_CONFERENCE_DATE, 101),'') AS SETTLEMENT_CONFERENCE_DATE from tblCase_Date_Details Where Case_Id = @s_a_case_id),'') ,    
		--- Packet Data    
		PROVIDER_NAME_ALL =UPPER(ISNULL(PRO.PROVIDER_SUITNAME,'')),    
		INJURED_NAME_ALL = UPPER(ISNULL(CAS.INJUREDPARTY_FIRSTNAME, N'')) + N' ' + UPPER(ISNULL(CAS.INJUREDPARTY_LASTNAME, N'')),    
		BALANCE_AMOUNT_ALL= convert(varchar,(convert(Money, (CONVERT(FLOAT, isnull(cas.CLAIM_AMOUNT,0)) - CONVERT(FLOAT, isnull(cas.PAID_AMOUNT,0)))))),     
		PROVIDER_ADDRESS_ALL=  UPPER(ISNULL(Provider_Name,''))+' ^p '+ UPPER(ISNULL(Provider_Local_Address,'')) +' ^p '+ UPPER(ISNULL(Provider_Local_City,'')) +' ' + UPPER(ISNULL(Provider_Local_State,'')) +' ' + UPPER(ISNULL(Provider_Local_Zip,'')) +' ' + UPPER(ISNULL(Provider_Local_Phone,'')) + ' ' + UPPER(ISNULL(Provider_Local_Fax,'')) + ' ^p^p ' ,    
		DOSEND60DAY = CONVERT(NVARCHAR(12), CONVERT(DATETIME, dateadd(day,+60, cast(DateOfService_End as date))), 101)   ,
		POM_DATE =  (select   top 1   ISNULL(CONVERT(VARCHAR(10), TD.Proof_of_Service_Date, 101),'') from tblCase_Date_Details TD with(nolock)    
					where TD.Case_Id = CAS.Case_Id  ),
		TPA_YES = CASE WHEN TPA.PK_TPA_GROUP_ID IS NOT NULL THEN 'X' ELSE ' ' END,
		TPA_NO = CASE WHEN TPA.PK_TPA_GROUP_ID IS NULL THEN 'X' ELSE ' ' END,
		TPA_GROUP_NAME = UPPER(ISNULL(TPA.TPA_GROUP_NAME,'')),
		TPA_ADDRESS = UPPER(ISNULL(TPA.ADDRESS,'')),
		TPA_CITY = UPPER(ISNULL(TPA.CITY,'')),
		TPA_STATE = UPPER(ISNULL(TPA.STATE,'')),
		TPA_ZIPCODE = TPA.ZIPCODE,
		TPA_EMAIL = UPPER(ISNULL(TPA.EMAIL,''))

	
	   FROM             
	   DBO.TBLCASE CAS    
	   INNER JOIN DBO.TBLINSURANCECOMPANY  INS WITH (NOLOCK) ON CAS.INSURANCECOMPANY_ID = INS.INSURANCECOMPANY_ID     
	   INNER JOIN  DBO.TBLPROVIDER PRO WITH (NOLOCK) ON CAS.PROVIDER_ID = PRO.PROVIDER_ID     
	   LEFT OUTER JOIN DBO.tbl_Client CL WITH (NOLOCK) ON CAS.DomainId = CL.DomainId    
	   LEFT OUTER JOIN  DBO.TBLSETTLEMENTS SETT WITH (NOLOCK) ON CAS.CASE_ID = SETT.CASE_ID    
	   LEFT OUTER JOIN DBO.tbl_Client_Other_Details CL_OD WITH (NOLOCK) on CAS.DomainId  = CL_OD.DomainId    
	   LEFT OUTER JOIN DBO.tblCourt COURT  WITH (NOLOCK) ON CAS.court_id = COURT.court_id    
	   LEFT OUTER JOIN  DBO.TBLADJUSTERS ADJ ON CAS.ADJUSTER_ID = ADJ.ADJUSTER_ID     
	   LEFT OUTER JOIN  DBO.TBLDEFENDANT DEF ON CAS.DEFENDANT_ID = DEF.DEFENDANT_ID     
	   LEFT OUTER JOIN  DBO.TBLATTORNEY ATT ON CAS.ATTORNEY_ID = ATT.ATTORNEY_ID     
	   LEFT OUTER JOIN dbo.tblServed SER WITH (NOLOCK) ON CAS.Served_To = SER.ID     
	   LEFT OUTER JOIN dbo.IssueTracker_Users USR WITH (NOLOCK) ON CAS.DomainID = USR.DomainID AND USR.UserId = @i_a_user_id    
	   --LEFT OUTER JOIN dbo.Assigned_Attorney a_att (NOLOCK) ON CAS.Assigned_Attorney = a_att.PK_Assigned_Attorney_ID    
	   LEFT OUTER JOIN dbo.TblArbitrator arbit ON arbit.ARBITRATOR_ID = CAS.Arbitrator_ID 
	   LEFT OUTER JOIN dbo.tblCase_Date_Details casdate ON casdate.Case_Id = CAS.CASE_ID     
	   LEFT OUTER JOIN dbo.tblInsurance_TPA_Group TPA ON PK_TPA_Group_ID = fk_TPA_Group_ID
	  WHERE     
	   CAS.Case_Id IN(select  s from dbo.splitstring(@s_a_case_id,','))      
	   and CAS.DomainId = @DomainId    
 END    
 ELSE    
 BEGIN    
  --PRINT 'With Packet ID'    
    
	  SELECT     
		@PROVIDER_NAME_ALL = COALESCE(@PROVIDER_NAME_ALL,' ') + Provider_Name + ' and ' ,    
		@PROVIDER_ADDRESS_ALL = COALESCE(@PROVIDER_ADDRESS_ALL,'') + Provider_Name+' ^p '+Provider_Local_Address+' ^p '+Provider_Local_City+' ' + Provider_Local_State+' ' + Provider_Local_Zip +' '+Provider_Local_Phone+' '+Provider_Local_Fax+' ^p^p ' ,    
		@INJURED_NAME_ALL = COALESCE(@INJURED_NAME_ALL,' ') + UPPER(ISNULL(cas.InjuredParty_FirstName,'')) + N'' + UPPER(ISNULL(cas.InjuredParty_LastName,'')) + ', ',    
		@BALANCE_AMOUNT_ALL = COALESCE(@BALANCE_AMOUNT_ALL,' ') + convert(varchar,(convert(Money, (CONVERT(FLOAT, isnull(cas.CLAIM_AMOUNT,0))- CONVERT(FLOAT, isnull(cas.Paid_Amount,0)) - CONVERT(FLOAT, isnull(cas.WriteOff,0)))))),
		@DOSEND60DAY = CONVERT(NVARCHAR(12), CONVERT(DATETIME, dateadd(day,+60, cast(DateOfService_End as date))), 101)    
	   FROM dbo.tblPacket pkt    
	   INNER JOIN tblCase cas on pkt.Packet_Auto_ID  = cas.FK_Packet_ID    
	   INNER JOIN DBO.TBLINSURANCECOMPANY ins ON cas.INSURANCECOMPANY_ID = ins.INSURANCECOMPANY_ID     
	   INNER JOIN  DBO.TBLPROVIDER pro ON cas.PROVIDER_ID = pro.PROVIDER_ID     
	   WHERE PacketID = @s_l_PacketID    
    
	  DECLARE @S_l_Packeted_Case_Ids VARCHAR(MAX)    
	  SET @S_l_Packeted_Case_Ids =  STUFF(    
			(SELECT ',' + CASE_ID FROM dbo.tblCase cas    
				  INNER  JOIN dbo.tblPacket pkt ON cas.FK_Packet_ID = pkt.Packet_Auto_ID     
				  WHERE PacketID = @s_l_PacketID and cas.DomainID = @DomainID    
			FOR XML PATH('')), 1, 1, '')    
     
	  INSERT INTO @template_case_details     
	  SELECT     
		PROVIDER_SUITNAME =   UPPER(ISNULL(MAX(PRO.PROVIDER_SUITNAME),'')),    
		PROVIDER_LOCAL_ADDRESS =   ISNULL(MAX(PRO.PROVIDER_LOCAL_ADDRESS),''),    
		PROVIDER_LOCAL_CITY =   ISNULL(MAX(PRO.PROVIDER_LOCAL_CITY),''),    
		PROVIDER_LOCAL_STATE =   ISNULL(MAX(PRO.PROVIDER_LOCAL_STATE),''),    
		PROVIDER_LOCAL_ZIP =   ISNULL(MAX(PRO.PROVIDER_LOCAL_ZIP),''),
		PROVIDER_LOCAL_PHONE  =   ISNULL(MAX(PRO.PROVIDER_LOCAL_PHONE),''),
		PROVIDER_EMAIL	=	ISNULL(MAX(PRO.PROVIDER_EMAIL),''), 
		PROVIDER_LOCAL_FAX  =   ISNULL(MAX(PRO.PROVIDER_LOCAL_FAX),''),  
		PROVIDER_TAXID =  ISNULL(MAX(PRO.PROVIDER_TAXID),''),    
		PROVIDER_PERM_ADDRESS  =  ISNULL(MAX(PRO.PROVIDER_PERM_ADDRESS),''),    
		PROVIDER_PERM_CITY  =  ISNULL(MAX(PRO.PROVIDER_PERM_CITY),''),    
		PROVIDER_PERM_STATE  =  ISNULL(MAX(PRO.PROVIDER_PERM_STATE),''),    
		PROVIDER_PERM_ZIP =  ISNULL(MAX(PRO.PROVIDER_PERM_ZIP),''),    
		PROVIDER_PRESIDENT = ISNULL(MAX(PRO.PROVIDER_PRESIDENT),''),    
		PROVIDER_BILLING = ISNULL(MAX(PRO.PROVIDER_BILLING),''),    
		PROVIDER_INTBILLING = ISNULL(MAX(PRO.PROVIDER_INTBILLING),''),    
		PROVIDER_INITIAL_BILLING = ISNULL(MAX(PRO.PROVIDER_INITIAL_BILLING),''),    
		PROVIDER_INITIAL_INTBILLING= ISNULL(MAX(PRO.PROVIDER_INITIAL_INTBILLING),''),      
		ACCIDENT_DATE =   ISNULL(MAX(CONVERT(VARCHAR(10), CAS.Accident_Date, 101)),''),    
		DATE_BILLSENT =   ISNULL(MAX(CONVERT(VARCHAR(10), CAS.Date_BillSent, 101)),''),    
		CASE_ID = @s_a_case_id,    
		PACKET_OR_CASE_ID =   ISNULL(MAX(PacketID),''),    
		CLAIM_AMOUNT =   CONVERT(VARCHAR,SUM(CONVERT(MONEY, CAS.CLAIM_AMOUNT)),1),    
		PAID_AMOUNT = CONVERT(VARCHAR,SUM(CONVERT(MONEY, CAS.Paid_Amount)),1),    
		--BALANCE_AMOUNT = CONVERT(VARCHAR,ISNULL(SUM(CONVERT(MONEY, CAS.CLAIM_AMOUNT)),0) - ISNULL(SUM(CONVERT(MONEY, CAS.Paid_Amount)),0)) ,    
		BALANCE_AMOUNT = @BALANCE_AMOUNT_ALL, --CONVERT(VARCHAR, SUM(CAST(ISNULL(CAS.CLAIM_AMOUNT,0.00) - ISNULL(CAS.PAID_AMOUNT,0.00) - ISNULL(CAS.WriteOff,0.00) - @s_l_DeductibleAmount as money)),1),     
		INDEXORAAA_NUMBER= UPPER(ISNULL(MAX(CAS.INDEXORAAA_NUMBER),'')),    
		Date_Index_Number_Purchased = CONVERT(VARCHAR(10),ISNULL(MAX(CAS.Date_Index_Number_Purchased),''),101),    
    
		--DOS_END =   CONVERT(NVARCHAR(12),CONVERT(DATETIME, MAX(CAS.DATEOFSERVICE_END)), 101),    
		--DOS_START =   CONVERT(NVARCHAR(12),CONVERT(DATETIME, MIN(CAS.DATEOFSERVICE_START)), 101),  
	
		DOS_END =   (select MAX(CONVERT(NVARCHAR(12),CONVERT(DATETIME, T.DateOfService_End), 101)) from tblTreatment T (NOLOCK) where CAS.Case_Id = T.Case_Id  
		and (CAS.Domainid = 'DK' OR convert(decimal(38,2),T.Claim_Amount) - convert(decimal(38,2),ISNULL(T.Paid_Amount,0))- 
	   convert(decimal(38,2),ISNULL(T.WriteOff,0.00))-convert(decimal(38,2),ISNULL(T.DeductibleAmount,0.00)) > 0) 
	   AND (CAS.Domainid = 'DK' OR ISNULL(T.DenialReason_ID,0) NOT 
	   IN(SELECT DenialReasons_Id from tblDenialReasons where DenialReasons_Type like 'PAID IN FULL'))   
	   AND (CAS.Domainid = 'DK' OR T.Treatment_Id NOT IN 
		   (select Treatment_Id from TXN_tblTreatment where DenialReasons_ID IN   
			  (SELECT DenialReasons_Id from tblDenialReasons where DenialReasons_Type like 'PAID IN FULL')))),    
		DOS_START =   (select MIN(CONVERT(NVARCHAR(12),CONVERT(DATETIME, T.DateOfService_Start), 101)) from tblTreatment T (NOLOCK) where CAS.Case_Id = T.Case_Id  
		and (CAS.Domainid = 'DK' OR convert(decimal(38,2),T.Claim_Amount) - convert(decimal(38,2),ISNULL(T.Paid_Amount,0))- 
	   convert(decimal(38,2),ISNULL(T.WriteOff,0.00))-convert(decimal(38,2),ISNULL(T.DeductibleAmount,0.00)) > 0) 
	   AND (CAS.Domainid = 'DK' OR ISNULL(T.DenialReason_ID,0) NOT 
	   IN(SELECT DenialReasons_Id from tblDenialReasons where DenialReasons_Type like 'PAID IN FULL'))   
	   AND (CAS.Domainid = 'DK' OR T.Treatment_Id NOT IN 
		   (select Treatment_Id from TXN_tblTreatment where DenialReasons_ID IN   
			  (SELECT DenialReasons_Id from tblDenialReasons where DenialReasons_Type like 'PAID IN FULL'))) ),


		--DOS_RANGE_ALL = STUFF((SELECT '^p' + CONVERT(VARCHAR,DateOfService_Start,101) + '-' + CONVERT(VARCHAR,DateOfService_End,101) FROM tblTreatment     
		--     WHERE case_id IN (SELECT items FROM dbo.STRING_SPLIT(@S_l_Packeted_Case_Ids,','))ORDER BY DateOfService_Start ASC FOR XML PATH('')), 1, 2, '') ,    
        
		DOS_RANGE_ALL = STUFF((    
							SELECT '^p' + CONVERT(VARCHAR,DateOfService_Start,101) + '-' + CONVERT(VARCHAR,DateOfService_End,101)     
			 FROM tblTreatment     
			 WHERE case_id IN (SELECT items FROM dbo.STRING_SPLIT(@S_l_Packeted_Case_Ids,','))    
			 and Treatment_Id not in (    
			 select Treatment_Id from tblTreatment TR with(nolock)    
			 inner JOIN tblDenialReasons TDR on TR.DenialReason_ID = TDR.DenialReasons_Id and     
			 TDR.DenialReasons_Type='PAID IN FULL'    
			 and TR.Case_Id IN (SELECT items FROM dbo.STRING_SPLIT(@S_l_Packeted_Case_Ids,',')) and @DomainId='RLF'    
			 UNION     
			 select Treatment_Id from tblTreatment TR with(nolock)    
			 where (isnull(Claim_Amount,0.00) - isnull(Paid_Amount,0.00)) <= 0.00 and     
			 TR.Case_Id IN (SELECT items FROM dbo.STRING_SPLIT(@S_l_Packeted_Case_Ids,',')) and @DomainId='RLF'    
    
			 )    
    
			 ORDER BY DateOfService_Start ASC FOR XML PATH('')), 1, 2, '') ,    
		INJUREDPARTY_NAME =  UPPER(ISNULL(MAX(CAS.INJUREDPARTY_FIRSTNAME), N'')) + N' ' + UPPER(ISNULL(MAX(CAS.INJUREDPARTY_LASTNAME), N'')),    
		INS_CLAIM_NUMBER =   ISNULL(MAX(CAS.INS_CLAIM_NUMBER),''),    
		POLICY_NUMBER =   ISNULL(MAX(CAS.POLICY_NUMBER),'-'),    
		INJUREDPARTY_LASTNAME = UPPER(ISNULL(MAX(CAS.INJUREDPARTY_LASTNAME),'')),     
		INJUREDPARTY_FIRSTNAME = UPPER(ISNULL(MAX(CAS.INJUREDPARTY_FIRSTNAME),'')),    
		INJUREDPARTY_FULL_ADDRESS = Case when ISNULL(MAX(CAS.INJUREDPARTY_ADDRESS),'')<> ''     
			Then UPPER(ISNULL(MAX(CAS.INJUREDPARTY_ADDRESS),'') +', '+ISNULL(MAX(CAS.INJUREDPARTY_CITY),'') +', '+ISNULL(MAX(CAS.INJUREDPARTY_STATE),'')+', '+ISNULL(MAX(CAS.INJUREDPARTY_ZIP),''))    
			else 'N/A'  End,    
		INSUREDPARTY_NAME =UPPER(ISNULL(MAX(CAS.INSUREDPARTY_FIRSTNAME), N'')) + N' ' + UPPER(ISNULL(MAX(CAS.INSUREDPARTY_LASTNAME), N'')),    
		INSUREDPARTY_LASTNAME = UPPER(ISNULL(MAX(CAS.INSUREDPARTY_LASTNAME),'')),     
		INSUREDPARTY_FIRSTNAME = UPPER(ISNULL(MAX(CAS.INSUREDPARTY_FIRSTNAME),'')),    
		INSUREDPARTY_ADDRESS = ISNULL(MAX(CAS.INSUREDPARTY_ADDRESS),''),    
        
		REPRESENTETIVE_NAME = UPPER(ISNULL(MAX(CAS.Representetive),'')),    
		REPRESENTATIVE_CONTACT_NUMBER = ISNULL(MAX(CAS.REPRESENTATIVE_CONTACT_NUMBER),''),    
		--ASSIGNED_ATTORNEY = ISNULL(MAX(a_att.ASSIGNED_ATTORNEY),''),    
    
		-- Insurance Details    
		INSURANCECOMPANY_SUITNAME  =  UPPER(ISNULL(MAX(INS.INSURANCECOMPANY_SUITNAME),'')),    
		INSURANCECOMPANY_NAME =   UPPER(ISNULL(MAX(INS.INSURANCECOMPANY_NAME),'')),    
		INSURANCECOMPANY_LOCAL_ADDRESS =   ISNULL(MAX(INS.INSURANCECOMPANY_LOCAL_ADDRESS),''),    
		INSURANCECOMPANY_LOCAL_CITY =   ISNULL(MAX(INS.INSURANCECOMPANY_LOCAL_CITY),''),    
		INSURANCECOMPANY_LOCAL_COUNTY =   ISNULL(MAX(INS.InsuranceCompany_Local_County),''),    
		INSURANCECOMPANY_LOCAL_STATE =   ISNULL(MAX(INS.INSURANCECOMPANY_LOCAL_STATE),''),    
		INSURANCECOMPANY_LOCAL_ZIP =   ISNULL(MAX(INS.INSURANCECOMPANY_LOCAL_ZIP),''),     
		INSURANCECOMPANY_LOCAL_FAX =   ISNULL(MAX(INS.INSURANCECOMPANY_LOCAL_FAX),''),     
		INSURANCECOMPANY_LOCAL_PHONE =ISNULL(MAX(INS.INSURANCECOMPANY_LOCAL_PHONE),''),  
		INSURANCECOMPANY_EMAIL = ISNULL(MAX(INS.INSURANCECOMPANY_EMAIL),''),  
		INSURANCECOMPANY_PERM_ADDRESS = ISNULL(MAX(INS.InsuranceCompany_Perm_Address),''),    
		INSURANCECOMPANY_PERM_CITY = ISNULL(MAX(INS.InsuranceCompany_Perm_City),''),    
		INSURANCECOMPANY_PERM_COUNTY = ISNULL(MAX(INS.InsuranceCompany_Perm_County),''),    
		INSURANCECOMPANY_PERM_STATE = ISNULL(MAX(INS.InsuranceCompany_Perm_State),''),    
		INSURANCECOMPANY_PERM_ZIP = ISNULL(MAX(INS.InsuranceCompany_Perm_Zip),''),    
		INSURANCECOMPANY_PERM_FAX = ISNULL(MAX(INS.InsuranceCompany_Perm_Fax),''),    
		INSURANCECOMPANY_PERM_PHONE = ISNULL(MAX(INS.InsuranceCompany_Perm_Phone),''),    
		-- Court Details    
		COURT_NAME = UPPER(ISNULL(MAX(COURT.COURT_NAME),'')),     
		COURT_VENUE = UPPER(ISNULL(MAX(COURT.COURT_VENUE),'')),     
    
		NEW_COURT_VENUE = CASE when (pro.Provider_Local_Address like '%brooklyn%' or pro.Provider_Local_City like '%brooklyn%'    
		or INS.InsuranceCompany_Local_Address like '%brooklyn%' OR INS.InsuranceCompany_Local_City like '%brooklyn%'    
					OR INS.InsuranceCompany_Perm_Address like '%brooklyn%' OR INS.InsuranceCompany_Perm_City like '%brooklyn%') then 'BROOKLYN'     
		else UPPER(ISNULL(COURT.COURT_VENUE,'')) end,    
    
    
    
		COURT_ADDRESS = ISNULL(MAX(COURT.COURT_ADDRESS),''),     
		COURT_BASIS=ISNULL(MAX(COURT.COURT_BASIS),''),    
		COURT_MISC=ISNULL(MAX(COURT.Court_Misc),''),    
		COURT_MISC_DISTRICT= Case When MAX(COURT.COURT_NAME) like '%'+'District'+'%' Then ISNULL(MAX(COURT.Court_Misc),'') Else '' End ,    
		COURT_MISC_CIRCUIT= Case When MAX(COURT.COURT_NAME) like '%'+'Circuit'+'%' Then ISNULL(MAX(COURT.Court_Misc),'') Else '' End ,    
		COURT_CITY=ISNULL(MAX(COURT.City),''),    
		COURT_COUNTY=ISNULL(MAX(COURT.County),''),    
		-- Settlement    
		SETTLED_WITH_NAME = ISNULL(MAX(SETT.SETTLED_WITH_NAME), N''),     
		SETTLED_WITH_PHONE = ISNULL(MAX(SETT.SETTLED_WITH_PHONE), N'') ,     
		SETTLED_WITH_FAX = ISNULL(MAX(SETT.SETTLED_WITH_FAX), N''),     
		SETTLEMENT_AMOUNT = ISNULL(SUM(SETT.SETTLEMENT_AMOUNT),0.00),     
		SETTLEMENT_INT = ISNULL(SUM(SETT.SETTLEMENT_INT),''),     
		SETTLEMENT_AF = ISNULL(SUM(SETT.SETTLEMENT_AF),''),     
		SETTLEMENT_FF = ISNULL(SUM(SETT.SETTLEMENT_FF),''),     
		SETTLEMENT_TOTAL = ISNULL(SUM(SETT.SETTLEMENT_TOTAL),''),     
		SETTLEMENT_DATE = ISNULL(MAX(SETT.SETTLEMENT_DATE),''),     
		SETTLEDWITH = ISNULL(MAX(SETT.SETTLEDWITH),''),    
        
		--- Transaction  Details    
		TRANSACTIONS_AMOUNT_COLLECTED = (SELECT  ISNULL(sum(Transactions_Amount),0.00) FROM tblTransactions WHERE case_id IN (SELECT items FROM dbo.STRING_SPLIT(@S_l_Packeted_Case_Ids,',')) and DomainId = MAX(cas.DomainId) and Transactions_Type IN ('C', 'PreC')),    
		TRANSACTIONS_AMOUNT_INT = (SELECT  ISNULL(sum(Transactions_Amount),0.00) FROM tblTransactions WHERE case_id IN (SELECT items FROM dbo.STRING_SPLIT(@S_l_Packeted_Case_Ids,','))  and DomainId =  MAX(cas.DomainId) and Transactions_Type IN ('I')),    
		TRANSACTIONS_AMOUNT_AF  = (SELECT  ISNULL(sum(Transactions_Amount),0.00) FROM tblTransactions WHERE case_id IN (SELECT items FROM dbo.STRING_SPLIT(@S_l_Packeted_Case_Ids,','))  and DomainId =  MAX(cas.DomainId) and Transactions_Type IN ('AF')),    
    
		--Adjuster    
		ADJUSTER_NAME = ISNULL(MAX(ADJ.ADJUSTER_FIRSTNAME), N'') + N'  ' + ISNULL(MAX(ADJ.ADJUSTER_LASTNAME), N''),    
		ADJUSTER_LASTNAME = ISNULL(MAX(ADJ.ADJUSTER_LASTNAME),'') ,    
		ADJUSTER_FIRSTNAME = ISNULL(MAX(ADJ.ADJUSTER_FIRSTNAME),'') ,    
		ADJUSTER_PHONE = ISNULL(MAX(ADJ.ADJUSTER_PHONE),'') ,    
		ADJUSTER_FAX = ISNULL(MAX(ADJ.ADJUSTER_FAX),'') ,    
		ADJUSTER_EMAIL = ISNULL(MAX(ADJ.ADJUSTER_EMAIL),'') ,    
		-- Attorney 
		ATTORNEY_FILENUMBER  = ISNULL(MAX(CAS.Attorney_FileNumber),'') ,   
		ATTORNEY_NAME = ISNULL(MAX(ATT.ATTORNEY_FIRSTNAME), N'') + N'  ' + ISNULL(MAX(ATT.ATTORNEY_LASTNAME), N'') ,    
		ATTORNEY_LASTNAME  = ISNULL(MAX(ATT.ATTORNEY_LASTNAME),'') ,    
		ATTORNEY_FIRSTNAME  = ISNULL(MAX(ATT.ATTORNEY_FIRSTNAME),'') ,    
		ATTORNEY_ADDRESS  = ISNULL(MAX(ATT.ATTORNEY_ADDRESS),'') ,    
		ATTORNEY_CITY  = ISNULL(MAX(ATT.ATTORNEY_CITY),'') ,    
		ATTORNEY_STATE  = ISNULL(MAX(ATT.ATTORNEY_STATE),'') ,    
		ATTORNEY_ZIP  = ISNULL(MAX(ATT.ATTORNEY_ZIP),'') ,    
		ATTORNEY_PHONE  = ISNULL(MAX(ATT.ATTORNEY_PHONE),'') ,    
		ATTORNEY_FAX  = ISNULL(MAX(ATT.ATTORNEY_FAX),'') ,    
		ATTORNEY_EMAIL = ISNULL(MAX(ATT.ATTORNEY_EMAIL),'') ,    
		-- DEFENDANT    
		DEFENDANT_NAME  = ISNULL(MAX(DEF.DEFENDANT_NAME),'') ,    
		DEFENDANT_ADDRESS  = ISNULL(MAX(DEF.DEFENDANT_ADDRESS),'')  ,    
		DEFENDANT_STATE  = ISNULL(MAX(DEF.DEFENDANT_STATE),'')  ,    
		DEFENDANT_ZIP  = ISNULL(MAX(DEF.DEFENDANT_ZIP),'') ,    
		DEFENDANT_PHONE  = ISNULL(MAX(DEF.DEFENDANT_PHONE),'')  ,    
		DEFENDANT_FAX  = ISNULL(MAX(DEF.DEFENDANT_FAX),'')  ,    
		DEFENDANT_EMAIL  = ISNULL(MAX(DEF.DEFENDANT_EMAIL),'')  ,    
		DEFENDANT_CITY = ISNULL(MAX(DEF.DEFENDANT_CITY),'')  ,    
    
		--Date  
	 
		SERVED_ON_DATE = STUFF(REPLACE('/'+CONVERT(CHAR(10),ISNULL(MAX(CAS.SERVED_ON_DATE),''),101),'/0','/'),1,1,''),    
		SERVED_ON_TIME = STUFF(REPLACE('/'+CONVERT(CHAR(10),ISNULL(MAX(CAS.SERVED_ON_TIME),''),101),'/0','/'),1,1,''),    
		SERVED_ON_DAY =  STUFF(REPLACE('/'+CONVERT(CHAR(10),DATEPART(DAY,MAX(CAS.SERVED_ON_DATE)),101),'/0','/'),1,1,''),    
		SERVED_ON_MONTH = STUFF(REPLACE('/'+CONVERT(CHAR(10),DATENAME(MONTH,MAX(CAS.SERVED_ON_DATE)),101),'/0','/'),1,1,''),    
		SERVED_ON_YEAR = STUFF(REPLACE('/'+CONVERT(CHAR(10),DATEPART(YEAR,MAX(CAS.SERVED_ON_DATE)),101),'/0','/'),1,1,''),    
		 Date_Answer_Received = STUFF(REPLACE('/'+CONVERT(CHAR(10),ISNULL(MAX(casdate.Date_Answer_Received),''),101),'/0','/'),1,1,''),      
		--Served_Person    
		SERVED_PERSON_NAME = UPPER(ISNULL(MAX(SER.NAME),'')),    
		SERVED_PERSON_HEIGHT =ISNULL(MAX(SER.HEIGHT),''),    
		SERVED_PERSON_WEIGHT = ISNULL(MAX(SER.WEIGHT),''),    
		SERVED_PERSON_AGE = ISNULL(MAX(SER.AGE),''),    
		SERVED_PERSON_SKIN_COLOUR = ISNULL(MAX(SER.SKIN),''),    
		SERVED_PERSON_HAIR_COLOUR = ISNULL(MAX(SER.HAIR),''),    
		SERVED_PERSON_GENDER = ISNULL(MAX(SER.SEX),''),    
    
		-- Notes    
		DELAY_NOTES = (Select top 1 Notes_desc FROM tblNotes WHERE case_id IN (SELECT items FROM dbo.STRING_SPLIT(@S_l_Packeted_Case_Ids,',')) and DomainId = MAX(cas.DomainId) and Notes_Type like 'DELAY%' order by Notes_ID desc),    
        
		-- Client Details    
		LAWFIRMNAME =   ISNULL(MAX(CL.LAWFIRMNAME),''),    
		CLIENT_NAME =   ISNULL(MAX(CL.Client_First_Name),'')+' '+ ISNULL(MAX(CL.Client_Last_Name),''),    
		CLIENT_LAST_NAME = ISNULL(MAX(CL.Client_Last_Name),''),    
		CLIENT_FIRST_NAME = ISNULL(MAX(CL.Client_First_Name),''),    
		CLIENT_EMAIL = ISNULL(MAX(CL.Client_Email),''),    
		CLIENT_ATTORNEY_NAME_1 =   ISNULL(MAX(CL_OD.CLIENT_ATTORNEY_NAME_1),''),    
		CLIENT_BILLING_ADDRESS =   ISNULL(MAX(CL.CLIENT_BILLING_ADDRESS),''),    
		CLIENT_BILLING_CITY =   ISNULL(MAX(CL.CLIENT_BILLING_CITY),''),    
		CLIENT_BILLING_STATE =   ISNULL(MAX(CL.CLIENT_BILLING_STATE),''),    
		CLIENT_BILLING_ZIP =   ISNULL(MAX(CL.CLIENT_BILLING_ZIP),''),    
		CLIENT_BILLING_FAX =  ISNULL(MAX(CL.CLIENT_BILLING_FAX),''),    
		CLIENT_BILLING_PHONE =   ISNULL(MAX(CL.CLIENT_BILLING_PHONE),''),    
		ADMINISTRATIVE_ASSISTANT =   ISNULL(MAX(CL_OD.ADMINISTRATIVE_ASSISTANT),''),    
		NOTARY_DETAILS =   ISNULL(MAX(CL_OD.NOTARY_DETAILS),''),    
		NOTARY_SIGNED_BY_NAME =   ISNULL(MAX(CL_OD.NOTARY_SIGNED_BY_NAME),''),    
		POSTAGE_ADDRESS =   ISNULL(MAX(CL_OD.POSTAGE_ADDRESS),''),    
		-- Date    
		NOW_MONTH =   DATENAME(month,GETDATE()) ,    
		NOW_YEAR =   DATEPART(yy,GETDATE()),  
		NOW_DAY = CONVERT(VARCHAR,DATEPART(DD,@dt_NOW)),  
		NOW_PRIFIX = FORMAT(@dt_NOW,  
			IIF(DAY(@dt_NOW) IN (1,21,31),'''st'''  
			,IIF(DAY(@dt_NOW) IN (2,22),'''nd'''  
			,IIF(DAY(@dt_NOW) IN (3,23),'''rd''','''th''')))) ,  
		NOWDT =   CONVERT(varchar(10),GETDATE(),101),    
		TODAY_DATE =   DATENAME(MM, GETDATE()) + RIGHT(CONVERT(VARCHAR(12), GETDATE(), 107), 9),    
    
		DOCTOR_NAME = ISNULL(MAX(dbo.[fncGetOperatingDoctor](@domainId, @s_a_case_id)),''),    
		LOGIN_USER_FNAME = ISNULL(MAX(USR.first_name),''),    
		LOGIN_USER_LNAME = ISNULL(MAX(USR.last_name),''),    
		LOGIN_USER_NAME =  ISNULL(MAX(USR.first_name),'') +' ' + ISNULL(MAX(USR.last_name),''),    
    
		JUDGE_NAME=ISNULL(MAX(arbit.ARBITRATOR_NAME),''),    
		-- OPPOSING COUNSEL    
		OPPOSING_COUNSEL_NAME  = (Select top 1 isnull(Attorney_FirstName, '') + ' ' + isnull(Attorney_LastName, '') as Attorney_Name    
				from tblAttorney_Case_Assignment ACA INNER JOIN tblAttorney_Master AM ON AM.Attorney_Id = ACA.Attorney_Id    
				INNER JOIN tblAttorney_Type ATP ON ATP.Attorney_Type_ID = AM.Attorney_Type_Id    
				Where Case_Id = @s_a_case_id and ACA.DomainId = @DomainId and lower(Attorney_Type) = 'opposing counsel' order by Assignment_Id desc),    
		OPPOSING_COUNSEL_LAWFIRM= (Select top 1 isnull(LawFirmName, '') as LawFirmName    
				from tblAttorney_Case_Assignment ACA INNER JOIN tblAttorney_Master AM ON AM.Attorney_Id = ACA.Attorney_Id    
				INNER JOIN tblAttorney_Type ATP ON ATP.Attorney_Type_ID = AM.Attorney_Type_Id    
				Where Case_Id = @s_a_case_id and ACA.DomainId = @DomainId and lower(Attorney_Type) = 'opposing counsel' order by Assignment_Id desc),    
		  OPPOSING_COUNSEL_ATTORNEY_BAR_NUMBER = (Select top 1 isnull(Attorney_BAR_Number, '') as Attorney_BAR_Number    
				from tblAttorney_Case_Assignment ACA INNER JOIN tblAttorney_Master AM ON AM.Attorney_Id = ACA.Attorney_Id    
				INNER JOIN tblAttorney_Type ATP ON ATP.Attorney_Type_ID = AM.Attorney_Type_Id    
				Where Case_Id = @s_a_case_id and ACA.DomainId = @DomainId and lower(Attorney_Type) = 'opposing counsel' order by Assignment_Id desc),    
		OPPOSING_COUNSEL_ADDRESS = (Select top 1 isnull(Attorney_Address,'')    
				from tblAttorney_Case_Assignment ACA INNER JOIN tblAttorney_Master AM ON AM.Attorney_Id = ACA.Attorney_Id    
				INNER JOIN tblAttorney_Type ATP ON ATP.Attorney_Type_ID = AM.Attorney_Type_Id    
				Where Case_Id = @s_a_case_id and ACA.DomainId = @DomainId and lower(Attorney_Type) = 'opposing counsel' order by Assignment_Id desc),    
		OPPOSING_COUNSEL_STATE = (Select top 1 isnull(Attorney_State,'')    
			   from tblAttorney_Case_Assignment ACA INNER JOIN tblAttorney_Master AM ON AM.Attorney_Id = ACA.Attorney_Id    
			   INNER JOIN tblAttorney_Type ATP ON ATP.Attorney_Type_ID = AM.Attorney_Type_Id    
			   Where Case_Id = @s_a_case_id and ACA.DomainId = @DomainId and lower(Attorney_Type) = 'opposing counsel' order by Assignment_Id desc),    
		OPPOSING_COUNSEL_ZIP  = (Select top 1 isnull(Attorney_Zip,'')    
			   from tblAttorney_Case_Assignment ACA INNER JOIN tblAttorney_Master AM ON AM.Attorney_Id = ACA.Attorney_Id    
			   INNER JOIN tblAttorney_Type ATP ON ATP.Attorney_Type_ID = AM.Attorney_Type_Id    
			   Where Case_Id = @s_a_case_id and ACA.DomainId = @DomainId and lower(Attorney_Type) = 'opposing counsel' order by Assignment_Id desc),    
		OPPOSING_COUNSEL_PHONE = (Select top 1 isnull(Attorney_Phone,'')    
			   from tblAttorney_Case_Assignment ACA INNER JOIN tblAttorney_Master AM ON AM.Attorney_Id = ACA.Attorney_Id    
			   INNER JOIN tblAttorney_Type ATP ON ATP.Attorney_Type_ID = AM.Attorney_Type_Id    
			   Where Case_Id = @s_a_case_id and ACA.DomainId = @DomainId and lower(Attorney_Type) = 'opposing counsel' order by Assignment_Id desc),    
		OPPOSING_COUNSEL_FAX  = (Select top 1 isnull(Attorney_Fax,'')    
			   from tblAttorney_Case_Assignment ACA INNER JOIN tblAttorney_Master AM ON AM.Attorney_Id = ACA.Attorney_Id    
			   INNER JOIN tblAttorney_Type ATP ON ATP.Attorney_Type_ID = AM.Attorney_Type_Id    
			   Where Case_Id = @s_a_case_id and ACA.DomainId = @DomainId and lower(Attorney_Type) = 'opposing counsel' order by Assignment_Id desc),    
		OPPOSING_COUNSEL_EMAIL = (Select top 1 isnull(Attorney_Email,'')    
			   from tblAttorney_Case_Assignment ACA INNER JOIN tblAttorney_Master AM ON AM.Attorney_Id = ACA.Attorney_Id    
			   INNER JOIN tblAttorney_Type ATP ON ATP.Attorney_Type_ID = AM.Attorney_Type_Id    
			   Where Case_Id = @s_a_case_id and ACA.DomainId = @DomainId and lower(Attorney_Type) = 'opposing counsel' order by Assignment_Id desc),    
		OPPOSING_COUNSEL_CITY = (Select top 1 isnull(Attorney_City,'')    
			   from tblAttorney_Case_Assignment ACA INNER JOIN tblAttorney_Master AM ON AM.Attorney_Id = ACA.Attorney_Id    
			   INNER JOIN tblAttorney_Type ATP ON ATP.Attorney_Type_ID = AM.Attorney_Type_Id    
			   Where Case_Id = @s_a_case_id and ACA.DomainId = @DomainId and lower(Attorney_Type) = 'opposing counsel' order by Assignment_Id desc),    
		-- PLAINTIFF ATTORNEY    
		PLAINTIFF_ATTORNEY_NAME  = (Select top 1 isnull(Attorney_FirstName, '') + ' ' + isnull(Attorney_LastName, '') as Attorney_Name    
				from tblAttorney_Case_Assignment ACA INNER JOIN tblAttorney_Master AM ON AM.Attorney_Id = ACA.Attorney_Id    
				INNER JOIN tblAttorney_Type ATP ON ATP.Attorney_Type_ID = AM.Attorney_Type_Id    
				Where Case_Id = @s_a_case_id and ACA.DomainId = @DomainId and lower(Attorney_Type) = 'plaintiff attorney' order by Assignment_Id desc),    
		PLAINTIFF_ATTORNEY_LAWFIRM= (Select top 1 isnull(LawFirmName, '') as LawFirmName    
				from tblAttorney_Case_Assignment ACA INNER JOIN tblAttorney_Master AM ON AM.Attorney_Id = ACA.Attorney_Id    
				INNER JOIN tblAttorney_Type ATP ON ATP.Attorney_Type_ID = AM.Attorney_Type_Id    
				Where Case_Id = @s_a_case_id and ACA.DomainId = @DomainId and lower(Attorney_Type) = 'plaintiff attorney' order by Assignment_Id desc),    
		PLAINTIFF_ATTORNEY_BAR_NUMBER = (Select top 1 isnull(Attorney_BAR_Number, '') as Attorney_BAR_Number    
				from tblAttorney_Case_Assignment ACA INNER JOIN tblAttorney_Master AM ON AM.Attorney_Id = ACA.Attorney_Id    
				INNER JOIN tblAttorney_Type ATP ON ATP.Attorney_Type_ID = AM.Attorney_Type_Id    
				Where Case_Id = @s_a_case_id and ACA.DomainId = @DomainId and lower(Attorney_Type) = 'plaintiff attorney' order by Assignment_Id desc),    
		PLAINTIFF_ATTORNEY_ADDRESS = (Select top 1 isnull(Attorney_Address,'')    
				from tblAttorney_Case_Assignment ACA INNER JOIN tblAttorney_Master AM ON AM.Attorney_Id = ACA.Attorney_Id    
				INNER JOIN tblAttorney_Type ATP ON ATP.Attorney_Type_ID = AM.Attorney_Type_Id    
				Where Case_Id = @s_a_case_id and ACA.DomainId = @DomainId and lower(Attorney_Type) = 'plaintiff attorney' order by Assignment_Id desc),    
		PLAINTIFF_ATTORNEY_STATE = (Select top 1 isnull(Attorney_State,'')    
			   from tblAttorney_Case_Assignment ACA INNER JOIN tblAttorney_Master AM ON AM.Attorney_Id = ACA.Attorney_Id    
			   INNER JOIN tblAttorney_Type ATP ON ATP.Attorney_Type_ID = AM.Attorney_Type_Id    
			   Where Case_Id = @s_a_case_id and ACA.DomainId = @DomainId and lower(Attorney_Type) = 'plaintiff attorney' order by Assignment_Id desc),    
		PLAINTIFF_ATTORNEY_ZIP  = (Select top 1 isnull(Attorney_Zip,'')    
			   from tblAttorney_Case_Assignment ACA INNER JOIN tblAttorney_Master AM ON AM.Attorney_Id = ACA.Attorney_Id    
			   INNER JOIN tblAttorney_Type ATP ON ATP.Attorney_Type_ID = AM.Attorney_Type_Id    
			   Where Case_Id = @s_a_case_id and ACA.DomainId = @DomainId and lower(Attorney_Type) = 'plaintiff attorney' order by Assignment_Id desc),    
		PLAINTIFF_ATTORNEY_PHONE = (Select top 1 isnull(Attorney_Phone,'')    
			   from tblAttorney_Case_Assignment ACA INNER JOIN tblAttorney_Master AM ON AM.Attorney_Id = ACA.Attorney_Id    
			   INNER JOIN tblAttorney_Type ATP ON ATP.Attorney_Type_ID = AM.Attorney_Type_Id    
			   Where Case_Id = @s_a_case_id and ACA.DomainId = @DomainId and lower(Attorney_Type) = 'plaintiff attorney' order by Assignment_Id desc),    
		PLAINTIFF_ATTORNEY_FAX  = (Select top 1 isnull(Attorney_Fax,'')    
			   from tblAttorney_Case_Assignment ACA INNER JOIN tblAttorney_Master AM ON AM.Attorney_Id = ACA.Attorney_Id    
			   INNER JOIN tblAttorney_Type ATP ON ATP.Attorney_Type_ID = AM.Attorney_Type_Id    
			   Where Case_Id = @s_a_case_id and ACA.DomainId = @DomainId and lower(Attorney_Type) = 'plaintiff attorney' order by Assignment_Id desc),    
		PLAINTIFF_ATTORNEY_EMAIL = (Select top 1 isnull(Attorney_Email,'')    
			   from tblAttorney_Case_Assignment ACA INNER JOIN tblAttorney_Master AM ON AM.Attorney_Id = ACA.Attorney_Id    
			   INNER JOIN tblAttorney_Type ATP ON ATP.Attorney_Type_ID = AM.Attorney_Type_Id    
			   Where Case_Id = @s_a_case_id and ACA.DomainId = @DomainId and lower(Attorney_Type) = 'plaintiff attorney' order by Assignment_Id desc),    
		PLAINTIFF_ATTORNEY_CITY = (Select top 1 isnull(Attorney_City,'')    
			   from tblAttorney_Case_Assignment ACA INNER JOIN tblAttorney_Master AM ON AM.Attorney_Id = ACA.Attorney_Id    
			   INNER JOIN tblAttorney_Type ATP ON ATP.Attorney_Type_ID = AM.Attorney_Type_Id    
			   Where Case_Id = @s_a_case_id and ACA.DomainId = @DomainId and lower(Attorney_Type) = 'plaintiff attorney' order by Assignment_Id desc),    
		TREATING_PHYSICIAN  = ISNULL((SELECT TOP 1 ISNULL(WL.Name,'N/A') FROM tblCaseWitnessList WL JOIN tblWitnessType WT ON WL.WitnessTypeID = WT.WitnessTypeID WHERE WL.Case_Id = @s_a_case_id AND LOWER(WT.WitnessType) = 'treating physician' ORDER BY WL.WitnessId DESC),'N/A'),    
		READING_PHYSICIAN  = ISNULL((SELECT TOP 1 ISNULL(WL.Name,'N/A') FROM tblCaseWitnessList WL JOIN tblWitnessType WT ON WL.WitnessTypeID = WT.WitnessTypeID WHERE WL.Case_Id = @s_a_case_id AND LOWER(WT.WitnessType) = 'reading physician' ORDER BY WL.WitnessId DESC),'N/A'),    
		PRESCRIBING_PHYSICIAN = ISNULL((SELECT TOP 1 ISNULL(WL.Name,'N/A') FROM tblCaseWitnessList WL JOIN tblWitnessType WT ON WL.WitnessTypeID = WT.WitnessTypeID WHERE WL.Case_Id = @s_a_case_id AND LOWER(WT.WitnessType) = 'prescribing physician' ORDER BY WL.WitnessId DESC),'N/A'),    
		PLAINTIFF_DEPOSITION_DATE_TIME = CASE WHEN ISNULL((SELECT TOP 1 ISNULL(CONVERT(VARCHAR,Plaintiff_Deposition_Date,101),'') FROM tblCase_Date_Details cd WHERE cd.Case_Id = @s_a_case_id),'') <> '' THEN ISNULL((SELECT TOP 1 ISNULL(CONVERT(VARCHAR,Plaintiff_Deposition_Date,101) + ' ' + CONVERT(VARCHAR(15),CAST(Plaintiff_Deposition_Date AS TIME),100)  +' EST','') FROM tblCase_Date_Details cd WHERE cd.Case_Id = @s_a_case_id),'') ELSE '' END,    
		CORPORATE_REP   = ISNULL((SELECT TOP 1 ISNULL(WL.Name,'') FROM tblCaseWitnessList WL JOIN tblWitnessType WT ON WL.WitnessTypeID = WT.WitnessTypeID WHERE WL.Case_Id = @s_a_case_id AND LOWER(WT.WitnessType) = 'corporate rep' ORDER BY WL.WitnessId DESC),''),    
		[90_DAYS_FROM_DATE_FILED] = CASE WHEN ISNULL((SELECT TOP 1 ISNULL(CONVERT(VARCHAR,Date_Filed,101),'') FROM tblCase_Date_Details cd WHERE cd.Case_Id = @s_a_case_id),'') <> '' THEN ISNULL((SELECT TOP 1 ISNULL(CONVERT(VARCHAR,DATEADD(DD,90,Date_Filed),101),'') FROM tblCase_Date_Details cd WHERE cd.Case_Id = @s_a_case_id),'') ELSE '' END,    
		MOTION_HEARING_DATE_TIME = CASE WHEN ISNULL((SELECT TOP 1 ISNULL(CONVERT(VARCHAR,MotionHearingDate,101),'') FROM tblCaseDateMotionMapping cm inner join tblCase_Date_Details cd on cd.Auto_Id = cm.CaseDateDetailsID WHERE cd.Case_Id = @s_a_case_id),'') <> '' THEN ISNULL((SELECT TOP 1 ISNULL(CONVERT(VARCHAR,MotionHearingDate,101) + ' ' + CONVERT(VARCHAR(15),CAST(MotionHearingDate AS TIME),100)  +' EST','') FROM tblCaseDateMotionMapping cm inner join tblCase_Date_Details cd on cd.Auto_Id = cm.CaseDateDetailsID WHERE cd.Case_Id = @s_a_case_id),'') ELSE '' END,    
		WORKFLOW_SETTLEMENT_DATE =  ISNULL((SELECT TOP 1 ISNULL(Convert(Varchar(50), Settlement_Date, 101),'') AS Settlement_Date from tblCase_Date_Details Where Case_Id = @s_a_case_id),''),    
		CASE_EVALUATION_DATE = ISNULL((SELECT TOP 1 ISNULL(Convert(Varchar(50), CASE_EVALUATION_DATE, 101),'') AS CASE_EVALUATION_DATE from tblCase_Date_Details Where Case_Id = @s_a_case_id),''),    
		FACILITATION_DATE =ISNULL((SELECT TOP 1 ISNULL(Convert(Varchar(50), FACILITATION_DATE, 101),'') AS FACILITATION_DATE from tblCase_Date_Details Where Case_Id = @s_a_case_id),''),    
		SETTLEMENT_CONFERENCE_DATE = ISNULL((SELECT TOP 1 ISNULL(Convert(Varchar(50), SETTLEMENT_CONFERENCE_DATE, 101),'') AS SETTLEMENT_CONFERENCE_DATE from tblCase_Date_Details Where Case_Id = @s_a_case_id),''),    
		--- Packet Data    
		PROVIDER_NAME_ALL = @PROVIDER_NAME_ALL,    
		INJURED_NAME_ALL = @INJURED_NAME_ALL,    
		BALANCE_AMOUNT_ALL= @BALANCE_AMOUNT_ALL,    
		PROVIDER_ADDRESS_ALL= @PROVIDER_ADDRESS_ALL,    
		DOSEND60DAY = @DOSEND60DAY    ,
		POM_DATE =  (select top 1 ISNULL(CONVERT(VARCHAR(10), TD.Proof_of_Service_Date, 101),'') from tblCase_Date_Details TD with(nolock)    
					where CAS.Case_Id = TD.Case_Id ),
		TPA_YES = CASE WHEN TPA.PK_TPA_GROUP_ID IS NOT NULL THEN 'X' ELSE ' ' END,
		TPA_NO = CASE WHEN TPA.PK_TPA_GROUP_ID IS NULL THEN 'X' ELSE ' ' END,
		TPA_GROUP_NAME = UPPER(ISNULL(TPA.TPA_GROUP_NAME,'')),
		TPA_ADDRESS = UPPER(ISNULL(TPA.ADDRESS,'')),
		TPA_CITY = UPPER(ISNULL(TPA.CITY,'')),
		TPA_STATE = UPPER(ISNULL(TPA.STATE,'')),
		TPA_ZIPCODE = TPA.ZIPCODE,
		TPA_EMAIL = UPPER(ISNULL(TPA.EMAIL,''))
	   FROM    
	   DBO.TBLCASE CAS    
	   INNER JOIN DBO.TBLINSURANCECOMPANY  INS ON CAS.INSURANCECOMPANY_ID = INS.INSURANCECOMPANY_ID     
		INNER JOIN  DBO.TBLPROVIDER PRO ON CAS.PROVIDER_ID = PRO.PROVIDER_ID     
	   LEFT OUTER JOIN DBO.tbl_Client CL ON CAS.DomainId = CL.DomainId    
	   LEFT OUTER JOIN  DBO.TBLSETTLEMENTS SETT ON CAS.CASE_ID = SETT.CASE_ID    
	   LEFT OUTER JOIN DBO.tbl_Client_Other_Details CL_OD on CAS.DomainId  = CL_OD.DomainId    
	   LEFT OUTER JOIN DBO.tblCourt COURT  ON CAS.court_id = COURT.court_id    
	   LEFT OUTER JOIN  DBO.TBLADJUSTERS ADJ ON CAS.ADJUSTER_ID = ADJ.ADJUSTER_ID     
	   LEFT OUTER JOIN  DBO.TBLDEFENDANT DEF ON CAS.DEFENDANT_ID = DEF.DEFENDANT_ID     
	   LEFT OUTER JOIN  DBO.TBLATTORNEY ATT ON CAS.ATTORNEY_ID = ATT.ATTORNEY_ID     
	   LEFT OUTER JOIN dbo.tblPacket pkt ON cas.FK_Packet_ID = pkt.Packet_Auto_ID     
	   LEFT OUTER JOIN dbo.tblServed SER WITH (NOLOCK) ON CAS.Served_To = SER.ID     
	   LEFT OUTER JOIN dbo.IssueTracker_Users USR WITH (NOLOCK) ON CAS.DomainID = USR.DomainID AND USR.UserId = @i_a_user_id    
	   --LEFT OUTER JOIN dbo.Assigned_Attorney a_att (NOLOCK) ON CAS.Assigned_Attorney = a_att.PK_Assigned_Attorney_ID    
	   LEFT OUTER JOIN dbo.TblArbitrator arbit ON arbit.ARBITRATOR_ID = CAS.Arbitrator_ID
	   LEFT OUTER JOIN dbo.tblCase_Date_Details casdate ON casdate.Case_Id = CAS.CASE_ID 
	   LEFT OUTER JOIN dbo.tblInsurance_TPA_Group TPA ON PK_TPA_Group_ID = fk_TPA_Group_ID
     
	  WHERE     
	   pkt.PacketID = @s_l_PacketID    
	   and CAS.DomainId = @DomainId     
	   group by CAS.DomainID,CAS.Case_Id,pro.provider_local_Address, pro.Provider_Local_Address, pro.Provider_Local_City, INS.InsuranceCompany_Local_Address,    
	   INS.InsuranceCompany_Local_City, INS.InsuranceCompany_Perm_Address, INS.InsuranceCompany_Perm_City, Court.Court_Venue,
	   PK_TPA_Group_ID, TPA_Group_Name, TPA.Address, TPA.City, TPA.State,TPA.ZipCode,TPA.Email
 END    
     
		SELECT * FROM @template_case_details    
    
SET NOCOUNT OFF            
END    
