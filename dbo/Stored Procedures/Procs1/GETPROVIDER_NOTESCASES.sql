﻿CREATE PROCEDURE [dbo].[GETPROVIDER_NOTESCASES]  --[GETPROVIDER_NOTESCASES] 'BT','5363',0,'amilogin'  
 @DomainId nvarchar(50),  
 @PROVIDER_ID INT=NULL,  
 @BIT_NOTES_CASES INT,  
 @UserName varchar(100) ,
  @IsExport int = 0
 
AS  
BEGIN  


IF @BIT_NOTES_CASES = 0  and @IsExport=1 and @DomainId='BT'
BEGIN

select distinct 
   TBLCASE.CASE_ID as [Case Id],  
   TBLPROVIDER.Provider_Name as Provider,
   ISNULL(DBO.TBLCASE.INJUREDPARTY_FIRSTNAME, N'') + N'  ' + ISNULL(DBO.TBLCASE.INJUREDPARTY_LASTNAME, N'') AS Patient, 
   INSURANCECOMPANY_NAME as Insurer,  
   convert(nvarchar(12),tblcase.Accident_Date,101) as [Accident Date],  
   STUFF((SELECT distinct ',' + BILL_NUMBER FROM tblTreatment(NOLOCK) T2
										WHERE TBLCASE.Case_Id = T2.Case_Id 
										--ORDER BY BILL_NUMBER 
										FOR XML PATH(''))
								, 1, 1, ''
							) as [Bill Number],
   ISNULL(convert(varchar, tblCase.DateOfService_Start,101),'') as [DOS START],  
   ISNULL(convert(varchar, tblCase.DateOfService_End,101),'') as [DOS END],     
   tblcase.Status, 
   convert(decimal(38,2),isnull(tblcase.CLAIM_AMOUNT,0)) as [Claim Amount], 
   (select convert(decimal(38,2),isnull(sum(transactions_amount),0)) from tbltransactions (NOLOCK) where (Transactions_type='PreC' OR Transactions_type='PrecTop'  )
   and Case_Id=tblcase.Case_ID and DomainId= tblcase.DomainId ) as [Voluntary Principal Payment], 
   (select convert(decimal(38,2),isnull(sum(transactions_amount),0)) from tbltransactions (NOLOCK) where (Transactions_type='PreI' 
   OR Transactions_type='ID') and Case_Id=tblcase.Case_ID and DomainId= tblcase.DomainId ) as [Voluntary Interest Payment],  
   CONVERT(FLOAT, ISNULL(DBO.TBLCASE.CLAIM_AMOUNT,0)) - CONVERT(FLOAT,ISNULL(DBO.TBLCASE.PAID_AMOUNT,0)) AS [Balance Pre-Arb],  
   convert(decimal(38,2),ISNULL(TBLSETTLEMENTS.SETTLEMENT_AMOUNT,0.00)) AS [Settlement Amount] ,
   (select convert(decimal(38,2),isnull(sum(transactions_amount),0))
   from tbltransactions where   Transactions_Type='C' and Case_Id=tblcase.Case_ID and DomainId= tblcase.DomainId and tblcase.case_id in (select case_id from tblSettlements 
   where  Case_Id=tblcase.Case_ID))
   as [Principal Received], 

   (select convert(decimal(38,2),isnull(sum(transactions_amount),0)) from tbltransactions (NOLOCK) where (
   Transactions_type='I')
   
   and Case_Id=tblcase.Case_ID and DomainId= tblcase.DomainId ) as [Interest Received],  
   DATEDIFF(DD,DATE_STATUS_CHANGED,GETDATE()) AS [Age in Current Status] , 
   Convert(varchar,settlement_date,101) as  [Date Settled]
   
   FROM  
   TBLCASE (NOLOCK)  
  INNER JOIN TBLPROVIDER (NOLOCK) AS TBLPROVIDER ON TBLCASE.PROVIDER_ID = TBLPROVIDER.Provider_Id and TBLCASE.DomainId=TBLPROVIDER.DomainId  
  INNER JOIN TBLINSURANCECOMPANY (NOLOCK) as TBLINSURANCECOMPANY ON TBLCASE.INSURANCECOMPANY_ID = TBLINSURANCECOMPANY.INSURANCECOMPANY_ID and TBLCASE.DomainId=TBLINSURANCECOMPANY.DomainId  
  LEFT OUTER JOIN tblsettlements (NOLOCK) on tblcase.Case_Id=tblsettlements.Case_Id  
  WHERE TBLCASE.IsDeleted=0 AND TBLPROVIDER.PROVIDER_ID in(select provider_id from TXN_PROVIDER_LOGIN (NOLOCK) where DomainId=''+ @DomainId + '' and user_id in  
  (select userid from IssueTracker_Users  where username= @UserName  and DomainId=@DomainId  )) and tblcase.DomainId= @DomainId  
  and status <> 'IN ARB OR LIT'  
  and ( TBLCASE.PROVIDER_ID = @PROVIDER_ID  or @PROVIDER_ID=0 or  @PROVIDER_ID is null)
  ORDER BY Provider_Name,TBLCASE.Case_Id  
  return
END


IF @BIT_NOTES_CASES = 0   and @IsExport=1 and @DomainId!='BT'
BEGIN

select distinct 
   TBLCASE.CASE_ID as [Case Id],  
   TBLPROVIDER.Provider_Name as Provider,
   ISNULL(DBO.TBLCASE.INJUREDPARTY_FIRSTNAME, N'') + N'  ' + ISNULL(DBO.TBLCASE.INJUREDPARTY_LASTNAME, N'') AS Patient, 
   (select top 1 isnull(account_number,'') from tbltreatment where Case_Id=tblcase.Case_ID) as [Account No],
   INSURANCECOMPANY_NAME as Insurer,  
   convert(nvarchar(12),tblcase.Accident_Date,101) as [Accident Date],  

   --STUFF(
			--						(SELECT distinct ',' + BILL_NUMBER 
			--							FROM tblTreatment(NOLOCK) T2
			--							WHERE TBLCASE.Case_Id = T2.Case_Id 
			--							--ORDER BY BILL_NUMBER 
			--							FOR XML PATH(''))
			--					, 1, 1, ''
			--				) as [Bill Number],
   ISNULL(convert(varchar, tblCase.DateOfService_Start,101),'') as [DOS START],  
   ISNULL(convert(varchar, tblCase.DateOfService_End,101),'') as [DOS END],     
   convert(decimal(38,2),isnull(tblcase.CLAIM_AMOUNT,0)) as [Claim Amt], 
   tblcase.Fee_Schedule as [Fee Schedule],
  
   (select convert(decimal(38,2),isnull(sum(transactions_amount),0)) from tbltransactions (NOLOCK) where (Transactions_type='PreC' OR Transactions_type='PrecTop'  )
   and Case_Id=tblcase.Case_ID and DomainId= tblcase.DomainId ) as [Voluntary Payment], 

   CONVERT(FLOAT, ISNULL(DBO.TBLCASE.CLAIM_AMOUNT,0)) - CONVERT(FLOAT,ISNULL(DBO.TBLCASE.PAID_AMOUNT,0)) AS [Balance Pre-Arb],  

   (select convert(decimal(38,2),isnull(sum(transactions_amount),0))
   from tbltransactions where   Transactions_Type='C' and Case_Id=tblcase.Case_ID and DomainId= tblcase.DomainId and tblcase.case_id in (select case_id from tblSettlements 
   where  Case_Id=tblcase.Case_ID))
   as [Principal Settlement Amount], 

   (select convert(decimal(38,2),isnull(sum(transactions_amount),0)) from tbltransactions (NOLOCK) where (Transactions_type='PreI' 
   OR Transactions_type='I' OR Transactions_type='D')
   
   and Case_Id=tblcase.Case_ID and DomainId= tblcase.DomainId ) as [Total Interest Received],  
    
   tblcase.Status, 
   tblcase.initial_status [initial status], 
      DATEDIFF(DD,DATE_STATUS_CHANGED,GETDATE()) AS [Age in Current Status] , 
	   convert (varchar(10),date_opened,101) as [File Received] ,  
	    (select MAX(convert(varchar,Event_Date,101)) from tblEvent E (NOLOCK)  
   inner join tblEventType T (NOLOCK) on E.EventTypeId = T.EventTypeId  
   inner join tblEventStatus S (NOLOCK) on E.EventStatusId = S.EventStatusId  
   WHERE EventStatusName in('AAA HEARING SET','MOTION') and Case_id =tblcase.Case_Id) AS [HEARING SET/MOTION],  
   Convert(varchar,settlement_date,101) as  [Date Settled],  
   convert(decimal(38,2),ISNULL(TBLSETTLEMENTS.SETTLEMENT_AMOUNT,0.00)) AS [Settlement Amt] ,
   --(select convert(decimal(38,2),isnull(sum(transactions_amount),0)) from tbltransactions (NOLOCK) where Transactions_type IN ('PriC','C') and Case_Id=tblcase.Case_ID and DomainId= tblcase.DomainId ) as Principal_Received,  
   (select convert(decimal(38,2),isnull(sum(transactions_amount),0)) from tbltransactions (NOLOCK) where Transactions_type IN ('PreC','C') and Case_Id=tblcase.Case_ID and DomainId= tblcase.DomainId ) as [Principal Received],  


    POLICY_NUMBER [Policy No],  
   replace(INS_CLAIM_NUMBER,char(9),'') [Claim No],  

     [dbo].[fncGetNotesDesc](TBLCASE.CASE_ID) AS [Client Notes],  
	 convert(varchar(10),(select top 1  isnull(Date_BillSent,'') from tbltreatment where Case_Id=tblcase.Case_ID),101) as [Date Bill Sent],
    
       
   ISNULL(dbo.fncGetServiceType( TBLCASE.Case_ID),'') AS [Service Type]
   
 

   
   
 

  
 
  
  
  	
							
 FROM  
   TBLCASE (NOLOCK)  
  INNER JOIN TBLPROVIDER (NOLOCK) AS TBLPROVIDER ON TBLCASE.PROVIDER_ID = TBLPROVIDER.Provider_Id and TBLCASE.DomainId=TBLPROVIDER.DomainId  
  INNER JOIN TBLINSURANCECOMPANY (NOLOCK) as TBLINSURANCECOMPANY ON TBLCASE.INSURANCECOMPANY_ID = TBLINSURANCECOMPANY.INSURANCECOMPANY_ID and TBLCASE.DomainId=TBLINSURANCECOMPANY.DomainId  
  LEFT OUTER JOIN tblsettlements (NOLOCK) on tblcase.Case_Id=tblsettlements.Case_Id  
  WHERE TBLCASE.IsDeleted=0 AND TBLPROVIDER.PROVIDER_ID in(select provider_id from TXN_PROVIDER_LOGIN (NOLOCK) where DomainId=''+ @DomainId + '' and user_id in  
  (select userid from IssueTracker_Users  where username= @UserName  and DomainId=@DomainId  )) and tblcase.DomainId= @DomainId  
  and status <> 'IN ARB OR LIT'  
  and ( TBLCASE.PROVIDER_ID = @PROVIDER_ID  or @PROVIDER_ID=0 or  @PROVIDER_ID is null)
  ORDER BY Provider_Name,TBLCASE.Case_Id  
  return
END


 IF @BIT_NOTES_CASES = 0  
 BEGIN  
   select distinct TBLCASE.CASE_ID,  
   (select top 1 isnull(account_number,'') from tbltreatment where Case_Id=tblcase.Case_ID) as account_number,  
   Convert(varchar,settlement_date,101) as  settlement_date,  
   (select MAX(convert(varchar,Event_Date,101)) from tblEvent E (NOLOCK)  
   inner join tblEventType T (NOLOCK) on E.EventTypeId = T.EventTypeId  
   inner join tblEventStatus S (NOLOCK) on E.EventStatusId = S.EventStatusId  
   WHERE EventStatusName in('AAA HEARING SET','MOTION') and Case_id =tblcase.Case_Id) AS [HEARING_SET/MOTION],  
   --(select convert(decimal(38,2),isnull(sum(transactions_amount),0)) from tbltransactions (NOLOCK) where Transactions_type IN ('PriC','C') and Case_Id=tblcase.Case_ID and DomainId= tblcase.DomainId ) as Principal_Received,  
   (select convert(decimal(38,2),isnull(sum(transactions_amount),0)) from tbltransactions (NOLOCK) where Transactions_type IN ('PreC','C') and Case_Id=tblcase.Case_ID and DomainId= tblcase.DomainId ) as Principal_Received,  
   (select convert(decimal(38,2),isnull(sum(transactions_amount),0)) from tbltransactions (NOLOCK) where (Transactions_type='PreI' 
   OR Transactions_type='ID')
   
   and Case_Id=tblcase.Case_ID and DomainId= tblcase.DomainId ) as Interest_Received,  
   --(select convert(decimal(38,2),isnull(sum(transactions_amount),0)) from tbltransactions (NOLOCK) where Transactions_type='I' and Case_Id=tblcase.Case_ID and DomainId= tblcase.DomainId ) as Interest_Received,  
    (select convert(decimal(38,2),isnull(sum(transactions_amount),0)) from tbltransactions (NOLOCK) where (Transactions_type='PreC' 
   OR Transactions_type='PrecTop'  )
   
   and Case_Id=tblcase.Case_ID and DomainId= tblcase.DomainId ) as Voluntary_Payment, 

     (select convert(decimal(38,2),isnull(sum(transactions_amount),0))
	 from tbltransactions where   Transactions_Type='C' and Case_Id=tblcase.Case_ID and DomainId= tblcase.DomainId and tblcase.case_id in (select case_id from tblSettlements 
	 where  Case_Id=tblcase.Case_ID))
   as Principal_Settlement_Amount, 

    (select convert(decimal(38,2),isnull(sum(transactions_amount),0)) from tbltransactions (NOLOCK) where Transactions_type IN ('C') and Case_Id=tblcase.Case_ID and DomainId= tblcase.DomainId ) as Principal_Received_C,  


    (select convert(decimal(38,2),isnull(sum(transactions_amount),0)) from tbltransactions (NOLOCK) where (Transactions_type='I' 
    )
   
   and Case_Id=tblcase.Case_ID and DomainId= tblcase.DomainId ) as Interest_Received_I,  

   ISNULL(DBO.TBLCASE.INJUREDPARTY_FIRSTNAME, N'') + N'  ' + ISNULL(DBO.TBLCASE.INJUREDPARTY_LASTNAME, N'') AS INJUREDPARTY_NAME,  
   TBLPROVIDER.Provider_Name,  
   INSURANCECOMPANY_NAME,  
   POLICY_NUMBER,  
   replace(INS_CLAIM_NUMBER,char(9),'') INS_CLAIM_NUMBER,  
   ISNULL(convert(varchar, tblCase.DateOfService_Start,101),'') as DateOfService_Start,  
   ISNULL(convert(varchar, tblCase.DateOfService_End,101),'') as DateOfService_End,     
   convert(nvarchar(12),tblcase.Accident_Date,101) as Accident_Date,  
   convert(decimal(38,2),isnull(tblcase.CLAIM_AMOUNT,0)) as CLAIM_AMOUNT,  
   CONVERT(FLOAT, ISNULL(DBO.TBLCASE.CLAIM_AMOUNT,0)) - CONVERT(FLOAT,ISNULL(DBO.TBLCASE.PAID_AMOUNT,0)) AS BALANCE_AMOUNT,  
   tblcase.Status,  
   tblcase.initial_status,  
   convert (varchar(10),date_opened,101) as date_opened ,  
   DATEDIFF(DD,DATE_STATUS_CHANGED,GETDATE()) AS STATUSAGE,  
   [dbo].[fncGetNotesDesc](TBLCASE.CASE_ID) AS NOTESDESCDATE,  
   tblcase.Fee_Schedule as Fee_Schedule,  
   convert(decimal(38,2),ISNULL(TBLSETTLEMENTS.SETTLEMENT_AMOUNT,0.00)) AS SETTLEMENT_AMOUNT ,
   --New field added 02/06/2020
   --(select  isnull(Date_BillSent,'') from tbltreatment where Case_Id=tblcase.Case_ID) as Date_BillSent
   convert(varchar(10),(select top 1  isnull(Date_BillSent,'') from tbltreatment where Case_Id=tblcase.Case_ID),101) as Date_BillSent,
   ISNULL(dbo.fncGetServiceType( TBLCASE.Case_ID),'') AS [ServiceType]
 --End of chenges New field added 02/06/2020,
  		,STUFF(
									(SELECT distinct ',' + BILL_NUMBER 
										FROM tblTreatment(NOLOCK) T2
										WHERE TBLCASE.Case_Id = T2.Case_Id 
										--ORDER BY BILL_NUMBER 
										FOR XML PATH(''))
								, 1, 1, ''
							) as BillNumber
							
 FROM  
   TBLCASE (NOLOCK)  
  INNER JOIN TBLPROVIDER (NOLOCK) AS TBLPROVIDER ON TBLCASE.PROVIDER_ID = TBLPROVIDER.Provider_Id and TBLCASE.DomainId=TBLPROVIDER.DomainId  
  INNER JOIN TBLINSURANCECOMPANY (NOLOCK) as TBLINSURANCECOMPANY ON TBLCASE.INSURANCECOMPANY_ID = TBLINSURANCECOMPANY.INSURANCECOMPANY_ID and TBLCASE.DomainId=TBLINSURANCECOMPANY.DomainId  
  LEFT OUTER JOIN tblsettlements (NOLOCK) on tblcase.Case_Id=tblsettlements.Case_Id  
  WHERE TBLCASE.IsDeleted=0 AND TBLPROVIDER.PROVIDER_ID in(select provider_id from TXN_PROVIDER_LOGIN (NOLOCK) where DomainId=''+ @DomainId + '' and user_id in  
  (select userid from IssueTracker_Users  where username= @UserName  and DomainId=@DomainId  )) and tblcase.DomainId= @DomainId  
  and status <> 'IN ARB OR LIT'  
  and ( TBLCASE.PROVIDER_ID = @PROVIDER_ID  or @PROVIDER_ID=0 or  @PROVIDER_ID is null)
  ORDER BY Provider_Name,Case_Id  
 END  
 ELSE IF @BIT_NOTES_CASES = 1  
 BEGIN  
  SELECT TBLCASE.CASE_ID,  
   NOTES_DESC,  
   CONVERT(NVARCHAR(12),NOTES_DATE,101) AS NOTES_DATE  
  FROM  
   tblcase  as tblcase (NOLOCK)   
   INNER JOIN tblNotes  TBLNOTES (NOLOCK)  ON TBLCASE.CASE_ID = TBLNOTES.CASE_ID and tblcase.DomainId = tblNotes.DomainId  
  WHERE TBLCASE.IsDeleted=0 AND TBLCASE.PROVIDER_ID = @PROVIDER_ID  
  AND tblcase.DomainId=@DomainId  
  AND NOTES_TYPE='PROVIDER'  
 END  
END  
  
