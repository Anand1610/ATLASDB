  
CREATE PROCEDURE [dbo].[UpdateDatabaseForNewUser] 
-- UpdateDatabaseForNewUser @DomainId = 'MCM' ,@LawFirmName ='Boris Tadchiev',@CompanyType='funding',@Action='Insert'
@DomainId NVARCHAR(50)=null,  
@LawFirmName VARCHAR(50)=null,  
@CompanyType VARCHAR(50)=null,  
@Action varchar(10)  
AS  
BEGIN  
  
if(@Action='Insert')  
begin  
  
  
  
 DECLARE @Error VARCHAR(MAX)  
 BEGIN TRANSACTION T_NEW_USER  
    BEGIN TRY  
  INSERT INTO tbl_Client  (DomainId,	LawFirmName,	CompanyType)
  VALUES(@DomainId,@LawFirmName,@CompanyType)  
  
 -- select * from IssueTracker_Roles  
  
  PRINT N'Inserting [dbo].[IssueTracker_Roles]...';  
  
  INSERT INTO IssueTracker_Roles (RoleName ,RoleLevel ,RoleType ,DomainId)  
  VALUES ('Administrator' ,1 ,'S' ,@DomainId),  
  ('Provider' ,2 ,'P' ,@DomainId),  
  ('LawSpades Staff' ,4 ,'S' ,@DomainId),  
  ('INVESTOR' ,2 ,'I' ,@DomainId)  
  --('Peer-Review Doctor' ,4 ,'PD' ,@DomainId),  
  --('EBT Doctor' ,4 ,'EDoc' ,@DomainId)  
  
  PRINT N'Inserting [dbo].[tblmenu_access]...';  
  
  INSERT INTO  tblmenu_access (RoleId,MenuId,DomainId)   
  SELECT a.RoleId, b.MenuID, @DomainId FROM IssueTracker_Roles a, tblMenu b   
  WHERe a.RoleName= 'Administrator' and a.DomainId = @DomainId  
  
  DECLARE @UserRoleid INT  
  
   SELECT @UserRoleid = roleid FROM IssueTracker_Roles WHERE RoleName= 'Administrator' and DomainId = @DomainId  
  
  
  PRINT N'Inserting [dbo].[IssueTracker_Users]...';  
  
  INSERT INTO IssueTracker_Users (UserName,UserPassword,RoleId,Email,DisplayName,UserTypeLogin,UserType,IsActive,bit_for_reports_case_search,bit_for_Provider_Cases,last_name,first_name,UserRole,DomainId)  
  VALUES ('admin','LawSpades@12' ,@UserRoleid ,'priyanka.k@lawspades.com.com','admin','admin','S',1,null,null ,NULL ,NULL ,'Administrator',@DomainId)
	,   ('ls-admin','lslaw12!@' ,@UserRoleid ,'priyanka.k@lawspades.com.com','admin','admin','S',1,null,null ,NULL ,NULL ,'Administrator',@DomainId)  
	 --, ('sgabriel','suren12!@' ,@UserRoleid ,'surengabriel@gmail.com','admin','admin','S',1,null,null ,NULL ,NULL ,'Administrator',@DomainId)  
  
    
  
  PRINT N'Inserting [dbo].[tblApplicationSettings]...';  
  INSERT INTO tblApplicationSettings (ParameterName, ParameterValue, displayname, DomainId)  
  VALUES('DocumentUploadLocation','/LSCasemanager/Scans/','Base folder to store uploaded documents for cases',@DomainId),  
  ('DocumentUploadLocationPhysical','E:\LawSpades\Application\AtlasDocuments\','Specify the physical location of the files to be saved when the user edits and saves the doc files from edit templates to document manager',@DomainId)  
  
  
  
  PRINT N'Inserting [dbo].[tblCaseStatus]...';  
  
  INSERT INTO tblCaseStatus(name, description,DomainId)  
  VALUES ('ARB','ARB', @DomainId),  
    ('CLOSED','CLOSED', @DomainId),  
    ('LIT','LIT', @DomainId)  
  
  PRINT N'Inserting [dbo].[tblProvider]...';  
  
  INSERT INTO tblProvider(Provider_Name,Provider_Suitname,Funding_Company, DomainId)  
  VALUES('TESTING','TESTING','TESTING', @DomainId)  
  
  PRINT N'Inserting [dbo].[tblInsuranceCompany]...';  
  
  INSERT INTO tblInsuranceCompany(InsuranceCompany_Name, InsuranceCompany_SuitName,DomainId)  
  VALUES('Test','Test',@DomainId)  
  
  PRINT N'Inserting [dbo].[tblInsuranceCompany]...';  
  
  INSERT INTO tblStatus(Status_Abr,Status_Type,DomainId)  
  VALUES  
  ('CLOSED','CLOSED',@DomainId),  
  ('OPEN','OPEN',@DomainId)
  --('AAA - FILED ','AAA - FILED ',@DomainId),  
  --('AAA - AWAITING HEARING DATE','AAA - AWAITING HEARING DATE',@DomainId),  
  --('AAA - HEARING DATE RECEIVED ','AAA - HEARING DATE RECEIVED ',@DomainId),  
  --('AAA - AWARD - WIN ','AAA - AWARD - WIN ',@DomainId),  
  --('AAA - AWARD - PARTIAL WIN','AAA - AWARD - PARTIAL WIN',@DomainId),  
  --('AAA - AWARD - LOSS','AAA - AWARD - LOSS',@DomainId),  
  --('AAA - APPEAL PENDING ','AAA - APPEAL PENDING ',@DomainId),  
  --('AAA - APPEAL FILED ','AAA - APPEAL FILED ',@DomainId),  
  --('AAA - APPEAL - LOSS','AAA - APPEAL - LOSS',@DomainId),  
  --('AAA - APPEAL - WIN','AAA - APPEAL - WIN',@DomainId),  
  --('AAA - APPEAL - PARTIAL WIN','AAA - APPEAL - PARTIAL WIN',@DomainId),  
  --('CLOSED - RETURNED TO CLIENT','CLOSED - RETURNED TO CLIENT',@DomainId),  
  --('AAA - REJECT - COLLATERAL ESTOPPEL','AAA - REJECT - COLLATERAL ESTOPPEL',@DomainId),  
  --('AAA - REJECT - RETURN TO CLIENT - LOW CLAIM AMT','AAA - REJECT - RETURN TO CLIENT - LOW CLAIM AMT',@DomainId),  
  --('AAA - NEW CASE ENTERED ','AAA - NEW CASE ENTERED ',@DomainId),  
  --('AAA - PAID IN FULL & CLOSED - AFTER HEARING ','AAA - PAID IN FULL & CLOSED - AFTER HEARING ',@DomainId),  
  --('AAA - REJECT - RETURN TO CLIENT','AAA - REJECT - RETURN TO CLIENT',@DomainId),  
  --('AAA - FILE SENT FOR REBUTTAL AFF','AAA - FILE SENT FOR REBUTTAL AFF',@DomainId),  
  --('AAA - PAID IN FULL & CLOSED - AFTER SETTLEMENT ','AAA - PAID IN FULL & CLOSED - AFTER SETTLEMENT ',@DomainId),  
  --('AAA - SETTLED - AWAITING PAYMENTS','AAA - SETTLED - AWAITING PAYMENTS',@DomainId),  
  --('AAA - PENDING REBUTTAL AFF','AAA - PENDING REBUTTAL AFF',@DomainId),  
  --('AAA - REJECT - RETURN TO CLIENT - NO COVERAGE','AAA - REJECT - RETURN TO CLIENT - NO COVERAGE',@DomainId),  
  --('AAA - AWARD - LOSS - APPEAL NEEDED','AAA - AWARD - LOSS - APPEAL NEEDED',@DomainId),  
  --('AAA - REJECT - RETURN TO CLIENT - CARRIER ISSUE','AAA - REJECT - RETURN TO CLIENT - CARRIER ISSUE',@DomainId),  
  --('AAA - REJECT - RETURN TO CLIENT - POLICY EXHAUSTED','AAA - REJECT - RETURN TO CLIENT - POLICY EXHAUSTED',@DomainId),  
  --('AAA - REJECT - RETURN TO CLIENT - DUPLICATE','AAA - REJECT - RETURN TO CLIENT - DUPLICATE',@DomainId),  
  --('AAA - REJECT - RETURN TO CLIENT - NO POLICY','AAA - REJECT - RETURN TO CLIENT - NO POLICY',@DomainId),  
  --('AAA - AWARD - CONSENT AWARD','AAA - AWARD - CONSENT AWARD',@DomainId),  
  --('DELETE - DUPLICATE ENTRY','DELETE - DUPLICATE ENTRY',@DomainId),  
  --('AAA - REBUTTAL RECD - SEND FOR SIGNATURE','AAA - REBUTTAL RECD - SEND FOR SIGNATURE',@DomainId),  
  --('AAA - REJECT - RETURN TO CLIENT - LIEN','AAA - REJECT - RETURN TO CLIENT - LIEN',@DomainId),  
  --('AAA - AWARD - LOSS - POLICY EXHAUSTED','AAA - AWARD - LOSS - POLICY EXHAUSTED',@DomainId),  
  --('AAA - PACKAGE READY','AAA - PACKAGE READY',@DomainId),  
  --('AAA - 412 RECEIVED ','AAA - 412 RECEIVED ',@DomainId),  
  --('AAA - REJECT - RETURN TO CLIENT - 120 DAY RULE','AAA - REJECT - RETURN TO CLIENT - 120 DAY RULE',@DomainId),  
  --('AAA - REJECT - RETURN TO CLIENT - NF2 LATE','AAA - REJECT - RETURN TO CLIENT - NF2 LATE',@DomainId),  
  --('AAA - REJECT - RETURN TO CLIENT - EUO NO SHOW','AAA - REJECT - RETURN TO CLIENT - EUO NO SHOW',@DomainId),  
  --('AAA - REJECT - RETURN TO CLIENT - IME NO SHOW','AAA - REJECT - RETURN TO CLIENT - IME NO SHOW',@DomainId),  
  --('AAA - REJECT - RETURN TO CLIENT - 45 DAY RULE','AAA - REJECT - RETURN TO CLIENT - 45 DAY RULE',@DomainId),  
  --('AAA - REJECT - RETURN TO CLIENT - PAID PER FS','AAA - REJECT - RETURN TO CLIENT - PAID PER FS',@DomainId),  
  --('AAA - REJECT - RETURN TO CLIENT - WC FILE','AAA - REJECT - RETURN TO CLIENT - WC FILE',@DomainId),  
  --('AAA - REJECT - RETURN TO CLIENT - DJ ACTION','AAA - REJECT - RETURN TO CLIENT - DJ ACTION',@DomainId),  
  --('AAA - REJECT - RETURN TO CLIENT - NO JURISDICTION','AAA - REJECT - RETURN TO CLIENT - NO JURISDICTION',@DomainId),  
  --('AAA - REJECT - RETURN TO CLIENT - SOL UP','AAA - REJECT - RETURN TO CLIENT - SOL UP',@DomainId),  
  --('AAA - AWARD - DISMISSED','AAA - AWARD - DISMISSED',@DomainId),  
  --('AAA - REJECT - RETURN TO CLIENT - FRAUD','AAA - REJECT - RETURN TO CLIENT - FRAUD',@DomainId),  
  --('AAA - REJECT - PER PROVIDER AGT','AAA - REJECT - PER PROVIDER AGT',@DomainId),  
  --('AAA - REJECT - RETURN TO CLIENT - DOC EUO NO SHOW','AAA - REJECT - RETURN TO CLIENT - DOC EUO NO SHOW',@DomainId)  
  
  
  PRINT N'Inserting [dbo].[tblCourt]...';  
  
  INSERT INTO tblCourt (Court_Name,Court_Venue,Court_Address,Court_Basis,Court_Misc,DomainId)  
  VALUES  
  ('First District: Hempstead Part','District Court of the County of Nassau','99 Main St, Hempstead, NY 11550','','Nassau', @DomainId),  
  ('COUNTY OF QUEENS','CIVIL COURT OF THE CITY OF NEW YORK','89-17 SUTPHIN BOULEVARD, JAMAICA, NY, 11435','','Queens', @DomainId),  
  ('COUNTY OF KINGS','CIVIL COURT OF THE CITY OF NEW YORK','141 LIVINGSTON STREET, BROOKLYN , NY 11201','','Kings', @DomainId),  
  ('Third District : Great Neck','District Court of the County of Nassau','435 Middleneck Road, Great Neck , NY 11023','','Nassau', @DomainId),  
  ('County of Bronx','Civil Court of the City of New York','851 Grand Concourse, Bronx NY 10451',Null,'Bronx', @DomainId),  
  ('County of Richmond','Civil Court of the City of New York',Null,Null,'Richmond', @DomainId),  
  ('County of New York','Civil Court of the City of New York',Null,Null,'New York', @DomainId),  
  ('American Arbitration Association','American Arbitration Association',Null,Null,NULL, @DomainId),  
  ('Third District : Huntington Station','District Court of the County of Suffolk','1850 New York Ave, Huntington Station NY 11746',Null,'Suffolk', @DomainId)  
  
  PRINT N'Inserting [dbo].[tblNotesType]...';  
  
  INSERT INTO [dbo].[tblNotesType] (Notes_Type, Notes_Type_Color,DomainId)  
  VALUES  
  ('Activity','Grey',@DomainId),  
  ('General','Black',@DomainId),  
  ('Provider','Green',@DomainId),  
  ('Calendar','Blue',@DomainId),  
  ('PopUp','Red',@DomainId)  
  
  
  PRINT N'Inserting [dbo].[tblDenialReasons]...';  
  INSERT INTO [dbo].[tblDenialReasons] (DenialReasons_Type, I_CATEGORY_ID,DomainID)  
  VALUES  
   ('Peer Review', 1, @DomainId),  
  ('IME Denial', 1, @DomainId),  
  ('IME No Show', 1, @DomainId),  
  ('EUO No Show', 1, @DomainId),  
  ('Concurrent Care', 1, @DomainId),  
  ('8 Unit Rule Denial', 1, @DomainId),  
  ('Fee Schedule Denial', 1, @DomainId),  
  ('Policy Exhausted', 1, @DomainId),  
  ('No Policy In Effect', 1, @DomainId),  
  ('Verification Requests ', 1, @DomainId),  
  ('Delay Letter', 1, @DomainId),  
  ('No Denial Issued', 1, @DomainId),  
  ('30 day rule', 1, @DomainId),  
  ('No Coverage', 1, @DomainId),  
  ('Fraud', 1, @DomainId),  
  ('PROCEDURE CODE BILLED INVALID', 1, @DomainId),  
  ('INCORRECT CARRIER', 1, @DomainId),  
  ('45 Day Rule', 1, @DomainId),  
  ('EUO Pending', 1, @DomainId),  
  ('INVESTIGATION PENDING', 1, @DomainId),  
  ('NO CASUAL RELATIONSHIP', 1, @DomainId),  
  ('EUO CUT OFF', 1, @DomainId),  
  ('EXCESSIVE TREATMENT', 1, @DomainId),  
  ('IME CUTOFF', 1, @DomainId),  
  ('IMPROPER FEE SCHEDULE', 1, @DomainId),  
  ('MEDICALLY UNNECESSARY', 1, @DomainId),  
  ('120 DAYS RULE', 1, @DomainId)  
       
      
  PRINT N'Inserting [dbo].[tblServiceType]...';  
  INSERT INTO [dbo].[tblServiceType] (ServiceType,ServiceDesc,DomainID)  
  VALUES  
  ('Chiro','Chiro', @DomainId),  
  ('MRI','MRI', @DomainId),  
  ('X-RAY','X-RAY', @DomainId),  
  ('ACUPUNCTURE','ACUPUNCTURE', @DomainId),  
  ('PHYSICAL THERAPY','PHYSICAL THERAPY', @DomainId),  
  ('NCV/EMG','NCV/EMG', @DomainId),  
  ('MUSCLE TESTING','MUSCLE TESTING', @DomainId),  
  ('MEDICAL SUPPLY','MEDICAL SUPPLY', @DomainId),  
  ('TRANSPORTATION','TRANSPORTATION', @DomainId),  
  ('EVALUATION','EVALUATION', @DomainId),  
  ('SONOGRAM','SONOGRAM', @DomainId),  
  ('CT SCAN','CT SCAN', @DomainId),  
  ('EEG','EEG', @DomainId),  
  ('DIAGNOSTIC TESTING','DIAGNOSTIC TESTING', @DomainId),  
  ('SSEP','SSEP', @DomainId),  
  ('OTHER','OTHER', @DomainId),  
  ('FEE SCHEDULE','FEE SCHEDULE', @DomainId),  
  ('INITIAL VISIT','INITIAL VISIT', @DomainId),  
  ('FOLLOW-UP EVALUATION','FOLLOW-UP EVALUATION', @DomainId),  
  ('SURGERY','SURGERY', @DomainId),  
  ('TRIGGER POINT INJECTION','TRIGGER POINT INJECTION', @DomainId),  
  ('INJECTTION','INJECTTION', @DomainId),  
  ('BY REPORT','BY REPORT', @DomainId),  
  ('ANESTHESIA','ANESTHESIA', @DomainId),  
  ('EPIDURAL L/S','EPIDURAL L/S', @DomainId),  
  ('EMERGENCY ROOM','EMERGENCY ROOM', @DomainId),  
  ('INPATIENT','INPATIENT', @DomainId),  
  ('OUTPATIENT FACILITY','OUTPATIENT FACILITY', @DomainId),  
  ('AMBULANCE','AMBULANCE', @DomainId),  
  ('SYN','SYN', @DomainId),  
  ('PRE-OPERATIVE TEST','PRE-OPERATIVE TEST', @DomainId),  
  ('PRE-SURGICAL TESTING','PRE-SURGICAL TESTING', @DomainId),  
  ('CHIROPRACTIC ','CHIROPRACTIC ', @DomainId),  
  ('ORTHOPEDIC ','ORTHOPEDIC ', @DomainId),  
  ('MUA','MUA', @DomainId),  
  ('OUTCOME ASSESSMENT','OUTCOME ASSESSMENT', @DomainId),  
  ('CPM','CPM', @DomainId),  
  ('RAD EXAM','RAD EXAM', @DomainId),  
  ('OFFICE VISIT','OFFICE VISIT', @DomainId),  
  ('ROM/MMT','ROM/MMT', @DomainId),  
  ('PHYSICIAN ASST','PHYSICIAN ASST', @DomainId),  
  ('PHYSICAL CAPACITY TESTING','PHYSICAL CAPACITY TESTING', @DomainId),  
  ('NERVE TESTING','NERVE TESTING', @DomainId),  
  ('AMMA THERAPY','AMMA THERAPY', @DomainId),  
  ('pf-NCS','pf-NCS', @DomainId),  
  ('VsNCT','VsNCT', @DomainId),  
  ('Pharmacy/Compound','Pharmacy/Compound', @DomainId),  
  ('PERFORMANCE TEST','PERFORMANCE TEST', @DomainId),  
  ('PHYSICAL PERFORMANCE TEST','PHYSICAL PERFORMANCE TEST', @DomainId),  
  ('BIOFEEDBACK','BIOFEEDBACK', @DomainId)  
  
  
  
  PRINT N'Inserting [dbo].[tblSettlement_typ]...';  
  INSERT INTO [tblSettlement_type](Settlement_Type,DomainId)  
  VALUES  
  ('Settled/Phone', @DomainId),  
  ('Settled/Court', @DomainId),  
  ('Trial/Win', @DomainId),  
  ('Trial/Lose', @DomainId),  
  ('Withdrawn with Prejudice', @DomainId),  
  ('Arb/Win', @DomainId),  
  ('Arb/Lose', @DomainId),  
  ('Arb/Partial Win', @DomainId),  
  ('Withdrawn without Prejudice', @DomainId)  
  
  
  PRINT N'Inserting [dbo].[Mst_document_Nodes]...';  
  INSERT INTO [Mst_document_Nodes] (ParentID,NodeName ,NodeLevel,Expanded,FriendlyName,DomainId)  
  VALUES  
  (0,'A.O.B',1, 0,'A.O.B',@DomainId),   
  (0,'AAA Correspondence',1, 0,'AAA Correspondence',@DomainId),  
  (0,'AAA FILE RECEIPT',1, 0,'AAA FILE RECEIPT',@DomainId),
  (0,'AR 1',1, 0,'ARB Docs.',@DomainId),  
  (0,'BILLS',1, 0,'BILLS',@DomainId),  
  (0,'AR 1 Packet',1, 0,'CLAIM DOCS',@DomainId),  
  (0,'DENIALS',1, 0,'DENIALS',@DomainId),  
  (0,'MEDICAL REPORTS',1, 0,'MEDICAL REPORTS',@DomainId),  
  (0,'PEER REVIEW',1, 0,'PEER REVIEW',@DomainId),  
  (0,'POLICE REPORTS',1, 0,'POLICE REPORTS',@DomainId),  
  (0,'PROOF OF MAILING',1, 0,'PROOF OF MAILING',@DomainId),  
  (0,'UNCATEGORIZED',1, 0,'UNCATEGORIZED',@DomainId),  
  (0,'PAYMENTS - PROVIDER',1, 0,'PAYMENTS - PROVIDER',@DomainId),  
  (0,'PAYMENTS - ATTORNEY',1, 0,'PAYMENTS - ATTORNEY',@DomainId), 
  (0,'VERIFICATION REQUEST',1, 0,'VERIFICATION REQUEST',@DomainId), 
  (0,'VERIFICATION RESPONSE',1, 0,'VERIFICATION RESPONSE',@DomainId)
  
  
  PRINT N'Inserting [dbo].[MST_PacketCaseType]...';  
  INSERT INTO MST_PacketCaseType (CaseType,DomainID)  
  VALUES ('Single Case: (Coverage Issue) Multiple Carriers', @DomainId),  
  ('Packet Case: Multiple Providers/Same Patient/Same Carrier/Same Doa', @DomainId),  
  ('Packet Case: Same Provider/Multiple Patients/Same Carrier/Multiple Doa', @DomainId),  
  ('Packet Case: (Coverage Issue) Multiple Providers/Same Patient/ Multiple Carriers/Same DOA', @DomainId),  
  ('Packet Case: Same Provider/Multiple Patients/Same Carrier/Same Doa', @DomainId),  
  ('Single Case: Carrier With Multiple Addresses', @DomainId),  
  ('Single Case: No Provider, Patient Is Applicant', @DomainId)  
  


    PRINT N'Inserting [dbo].[tblEventType]...'; 
	INSERT INTO tblEventType (EventTypeName,DomainId,created_by_user)
	VALUES('AAA Arbitration', @DomainId, 'admin'),
	('Administrative Adjournment', @DomainId, 'admin'),
	('Appeal', @DomainId, 'admin'),
	('Arbitration', @DomainId, 'admin'),
	('Conference', @DomainId, 'admin'),
	('Deposition', @DomainId, 'admin'),
	('EBT', @DomainId, 'admin'),
	('Motion', @DomainId, 'admin'),
	('Order To Show Cause', @DomainId, 'admin'),
	('Trial', @DomainId, 'admin')


	PRINT N'Inserting [dbo].[tblEventStatus]...'; 
	INSERT INTO tblEventStatus(EventStatusName,DomainId,created_by_user)
	VALUES ('AAA Arbitration', @DomainId, 'admin'),
	('AAA Hearing Set', @DomainId, 'admin'),
	('AAA Hearing Set-2nd Time', @DomainId, 'admin'),
	('AAA Hearing Set-3rd Time', @DomainId, 'admin'),
	('AAA Hearing Set-4th Time', @DomainId, 'admin'),
	('AAA Hearing Set-5th Time', @DomainId, 'admin'),
	('AAA Hearing Set-6th Time', @DomainId, 'admin'),
	('AAA Hearing Set-7th Time', @DomainId, 'admin'),
	('AAA Hearing Set-8th Time', @DomainId, 'admin'),
	('Appeal', @DomainId, 'admin'),
	('Arbitration', @DomainId, 'admin'),
	('Conference', @DomainId, 'admin'),
	('Cross Motion (Ours)', @DomainId, 'admin'),
	('Cross Motion (Theirs)', @DomainId, 'admin'),
	('Deposition', @DomainId, 'admin'),
	('Discovery (Dismiss-Blown Stip) (Ours)', @DomainId, 'admin'),
	('Discovery (Dismiss-Blown Stip) (Theirs)', @DomainId, 'admin'),
	('Discovery (Preclusion) (Ours)', @DomainId, 'admin'),
	('Discovery (Preclusion) (Theirs)', @DomainId, 'admin'),
	('EBT', @DomainId, 'admin'),
	('Motion', @DomainId, 'admin'),
	('Motion - Affirmative Discovery Motion', @DomainId, 'admin'),
	('Motion - Affirmative SJ Motion', @DomainId, 'admin'),
	('Order To Show Cause', @DomainId, 'admin'),
	('Rescheduled', @DomainId, 'admin'),
	('Summary Judgment (Ours)', @DomainId, 'admin'),
	('Summary Judgment (Theirs)', @DomainId, 'admin'),
	('Trial - Eighth Time', @DomainId, 'admin'),
	('Trial - Fifth Time', @DomainId, 'admin'),
	('Trial - First Time', @DomainId, 'admin'),
	('Trial - Fourth Time', @DomainId, 'admin'),
	('Trial - Second Time', @DomainId, 'admin'),
	('Trial - Seventh Time', @DomainId, 'admin'),
	('Trial - Third Time', @DomainId, 'admin'),
	('Trial - Won', @DomainId, 'admin'),
	('Trial -Sixth Time', @DomainId, 'admin')
  
  SELECT * FROM IssueTracker_Users WHERE DomainId =@DomainId  
  
  COMMIT TRANSACTION T_NEW_USER  
  
    END TRY  
    BEGIN CATCH  
     SET @Error = ERROR_MESSAGE()  
  ROLLBACK TRANSACTION T_NEW_USER  
  RAISERROR(@Error, 16, 1)  
    END CATCH  
end  
  
if(@Action='Delete')  
begin  
  
DECLARE @Error2 VARCHAR(MAX)  
 BEGIN TRANSACTION T_DELETE_USER  
    BEGIN TRY  
    
  DELETE from tbl_Client where DomainId = @DomainId;  
     
       DELETE from IssueTracker_Users where DomainId = @DomainId;  
     
       DELETE from IssueTracker_Roles where DomainId = @DomainId;  
  
    DELETE from tblmenu_access where DomainId = @DomainId;  
  
       DELETE from tblApplicationSettings where DomainId = @DomainId;  
    
       DELETE from tblCaseStatus where DomainId = @DomainId;  
  
    DELETE from tblProvider where DomainId = @DomainId;  
  
    DELETE from tblInsuranceCompany where DomainId = @DomainId;  
    
    DELETE from tblStatus where DomainId = @DomainId;  
    
    DELETE from tblCourt where DomainId = @DomainId;  
    
    DELETE from tblNotesType where DomainId = @DomainId;  
  
    DELETE from tblDenialReasons where DomainId = @DomainId;   
       
    DELETE from tblServiceType where DomainId = @DomainId;    
    
    DELETE from tblSettlement_type where DomainId = @DomainId;  
    
    DELETE from Mst_document_Nodes where DomainId = @DomainId;  
  
    DELETE from MST_PacketCaseType where DomainId = @DomainId;  
    
    COMMIT TRANSACTION T_DELETE_USER  
  
    END TRY  
    BEGIN CATCH  
     SET @Error2 = ERROR_MESSAGE()  
  ROLLBACK TRANSACTION T_DELETE_USER  
  RAISERROR(@Error2, 16, 1)  
    END CATCH  
  
end  
  
if(@Action='Select')  
begin  
  
select Auto_ID, DomainId ,LawFirmName from tbl_client where  DomainId = @DomainId  
  
end  
  
END  
  
  
  
  
  
