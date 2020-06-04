CREATE PROCEDURE [dbo].[GET_Treatment_Supplemental_Table]  -- [GET_Treatment_Supplemental_Table] 'AF19-103683'  
 @CaseID VARCHAR(40)  
AS  
BEGIN  
  
DECLARE @s_l_PacketID VARCHAR(40) = ''  
  
 SET @s_l_PacketID = ( SELECT  TOP 1 ISNULL(PacketID,'') FROM dbo.tblCase cas  (NOLOCK)
 INNER  JOIN dbo.tblPacket pkt (NOLOCK) ON cas.FK_Packet_ID = pkt.Packet_Auto_ID   
 WHERE CASE_ID = @CaseID OR PacketID = @CaseID) 
  
 PRINT @s_l_PacketID  
  
 DECLARE @tblPatientWise TABLE
 (
	Treatment_ID INT,
	--Provider_Name VARCHAR(200),
	Provider_Suitname VARCHAR(200),
	Claim_Amount decimal(38,2),
	Paid_Amount	decimal(38,2),
	Balance_Amount	decimal(38,2),
	DOS_Range	VARCHAR(40),
	Date_BillSent VARCHAR(10),	
	DateOfService_Start	VARCHAR(10),
	DateOfService_End	VARCHAR(10),
	ACCIDENT_DATE	VARCHAR(10),
	INJUREDPARTY_NAME VARCHAR(200)
 )
  
 IF(@s_l_PacketID  IS NULL)  
 BEGIN  
		  print 'Without Packetid'  
		  INSERT INTO @tblPatientWise
		  SELECT TOP 20 
				  T.Treatment_ID
				--, PRO.Provider_Id
				--, PRO.Provider_Name
				, PRO.Provider_Suitname
				, convert(decimal(38,2),T.Claim_Amount)[Claim_Amount]
				, convert(decimal(38,2),ISNULL(T.Paid_Amount,0)) + convert(decimal(38,2),ISNULL(T.WriteOff,0.00)) + convert(decimal(38,2),ISNULL(T.DeductibleAmount,0.00))[Paid_Amount] 
				
				,case when CS.DomainId='JL' then 
				convert(decimal(38,2),T.Claim_Amount) - convert(decimal(38,2),ISNULL(T.Paid_Amount,0) ) - convert(decimal(38,2),ISNULL(T.WriteOff,0.00))-convert(decimal(38,2),ISNULL(T.DeductibleAmount,0.00)) 
				- isnull((
				Select sum(isnull(Transactions_Amount,0.00)) from tblTransactions with(nolock) where Transactions_Type in ('C') 
				and  cast(Treatment_Id as varchar) = cast(TreatmentIds as varchar)
				
				),0.00) 
				- isnull((
				Select sum(isnull(Transactions_Amount,0.00)) from tblTransactions with(nolock) where Transactions_Type in ('C') 
				and  cast(TreatmentIds as varchar) in (select cast(Treatment_id as varchar) from tbltreatment where Act_case_Id =@CaseID)
			
				),0.00) 
				
				
				else convert(decimal(38,2),T.Claim_Amount) - convert(decimal(38,2),ISNULL(T.Paid_Amount,0) ) - convert(decimal(38,2),ISNULL(T.WriteOff,0.00))-convert(decimal(38,2),ISNULL(T.DeductibleAmount,0.00))  end 
				
				[Balance_Amount] 

				, CONVERT(VARCHAR,T.DateOfService_Start,101) + ' - ' + CONVERT(VARCHAR,T.DateOfService_End,101) [DOS_Range]  
				, CONVERT(VARCHAR, t.Date_BillSent, 101) [Date_BillSent]  
				, CONVERT(VARCHAR,T.DateOfService_Start,101) AS DateOfService_Start
				, CONVERT(VARCHAR,T.DateOfService_End,101) as DateOfService_End
				, ISNULL(CONVERT(VARCHAR(10), cs.Accident_Date, 101),'') AS ACCIDENT_DATE
				, UPPER(ISNULL(cs.INJUREDPARTY_FIRSTNAME, N'')) + N' ' + UPPER(ISNULL(cs.INJUREDPARTY_LASTNAME, N'')) AS INJUREDPARTY_NAME	
		  FROM TBLCASE CS  (NOLOCK) 
		  --INNER JOIN TBLCASEPACKET CP ON CS.CASE_ID=CP.CASEID  
		  INNER JOIN TBLPROVIDER PRO (NOLOCK) ON PRO.PROVIDER_ID=CS.PROVIDER_ID   
		  INNER JoiN tblTreatment T (NOLOCK) ON CS.Case_Id = T.Case_Id   
		  --WHERE CS.Case_Id =@CaseID  
		  WHERE CS.Case_Id = @CaseID  
		   and (CS.Domainid = 'DK' OR convert(decimal(38,2),T.Claim_Amount) - convert(decimal(38,2),ISNULL(T.Paid_Amount,0))- convert(decimal(38,2),ISNULL(T.WriteOff,0.00))-convert(decimal(38,2),ISNULL(T.DeductibleAmount,0.00)) > 0) 
		   AND (CS.Domainid = 'DK' OR ISNULL(T.DenialReason_ID,0) NOT IN(SELECT DenialReasons_Id from tblDenialReasons where DenialReasons_Type like 'PAID IN FULL'))   
		   AND (CS.Domainid = 'DK' OR T.Treatment_Id NOT IN (select Treatment_Id from TXN_tblTreatment where DenialReasons_ID IN   
				  (SELECT DenialReasons_Id from tblDenialReasons where DenialReasons_Type like 'PAID IN FULL')))
		  ORDER BY convert(date,T.DateOfService_Start)  
		  ---------------------------------------------------------------------
		  SELECT * FROM @tblPatientWise	
		  ---------------------------------------------------------------------
		  SELECT 
				  T.Treatment_ID
				--, PRO.Provider_Id
				--, PRO.Provider_Name
				, PRO.Provider_Suitname
				, convert(decimal(38,2),T.Claim_Amount)[Claim_Amount]
				, convert(decimal(38,2),ISNULL(T.Paid_Amount,0)) + convert(decimal(38,2),ISNULL(T.WriteOff,0.00)) + convert(decimal(38,2),ISNULL(T.DeductibleAmount,0.00))[Paid_Amount] 
				
				, 
				case when CS.DomainID='JL' then 
				convert(decimal(38,2),T.Claim_Amount) - convert(decimal(38,2),ISNULL(T.Paid_Amount,0) ) - convert(decimal(38,2),ISNULL(T.WriteOff,0.00))-convert(decimal(38,2),ISNULL(T.DeductibleAmount,0.00)) 
				- isnull((
				Select sum(isnull(Transactions_Amount,0.00)) from tblTransactions with(nolock) where Transactions_Type in ('C') 
				and cast(Treatment_Id as varchar) = cast(TreatmentIds as varchar)
				
				),0.00)
				- isnull((
				Select sum(isnull(Transactions_Amount,0.00)) from tblTransactions with(nolock) where Transactions_Type in ('C') 
				and  cast(TreatmentIds as varchar) in (select cast(Treatment_id as varchar) from tbltreatment where Act_case_Id =@CaseID)
			
				),0.00) 
				else 
					convert(decimal(38,2),T.Claim_Amount) - convert(decimal(38,2),ISNULL(T.Paid_Amount,0) ) - convert(decimal(38,2),ISNULL(T.WriteOff,0.00))-convert(decimal(38,2),ISNULL(T.DeductibleAmount,0.00)) 
				end
				[Balance_Amount]  

				, CONVERT(VARCHAR,T.DateOfService_Start,101) + ' - ' + CONVERT(VARCHAR,T.DateOfService_End,101) [DOS_Range]  
				, CONVERT(VARCHAR, t.Date_BillSent, 101) [Date_BillSent]  
				, CONVERT(VARCHAR,T.DateOfService_Start,101) AS DateOfService_Start
				, CONVERT(VARCHAR,T.DateOfService_End,101) as DateOfService_End
				, ISNULL(CONVERT(VARCHAR(10), cs.Accident_Date, 101),'') AS ACCIDENT_DATE
				, UPPER(ISNULL(cs.INJUREDPARTY_FIRSTNAME, N'')) + N' ' + UPPER(ISNULL(cs.INJUREDPARTY_LASTNAME, N'')) AS INJUREDPARTY_NAME
		
		  FROM TBLCASE CS  (NOLOCK) 
		  --INNER JOIN TBLCASEPACKET CP ON CS.CASE_ID=CP.CASEID  
		  INNER JOIN TBLPROVIDER PRO (NOLOCK) ON PRO.PROVIDER_ID=CS.PROVIDER_ID   
		  INNER JoiN tblTreatment T (NOLOCK) ON CS.Case_Id = T.Case_Id   
		  --WHERE CS.Case_Id =@CaseID  
		  WHERE CS.Case_Id = @CaseID 
		   AND T.Treatment_ID NOT IN (SELECT Treatment_ID FROM @tblPatientWise)	 
		   and (CS.Domainid = 'DK' OR convert(decimal(38,2),T.Claim_Amount) - convert(decimal(38,2),ISNULL(T.Paid_Amount,0))- convert(decimal(38,2),ISNULL(T.WriteOff,0.00))-convert(decimal(38,2),ISNULL(T.DeductibleAmount,0.00)) > 0) 
		   AND (CS.Domainid = 'DK' OR ISNULL(T.DenialReason_ID,0) NOT IN(SELECT DenialReasons_Id from tblDenialReasons where DenialReasons_Type like 'PAID IN FULL'))   
		   AND (CS.Domainid = 'DK' OR T.Treatment_Id NOT IN (select Treatment_Id from TXN_tblTreatment where DenialReasons_ID IN   
				  (SELECT DenialReasons_Id from tblDenialReasons where DenialReasons_Type like 'PAID IN FULL')))
		  ORDER BY convert(date,T.DateOfService_Start)  

 END  
 ELSE  
 BEGIN  
		  print 'With Packetid'  

		  declare @tmp table
		  (
			Case_ID VARCHAR(100),
			INJUREDPARTY_NAME VARCHAR(200)
		  )

		  IF EXISTS(SELECT TOP 1 CASE_ID FROM TBLCASE CS (nOLOCK) WHERE CS.Case_Id = @CaseID) 
		  BEGIN		
			    insert into @tmp 
				SELECT  CS.Case_ID, 
				ISNULL(cs.INJUREDPARTY_FIRSTNAME, N'') + N' ' + ISNULL(cs.INJUREDPARTY_LASTNAME, N'') AS INJUREDPARTY_NAME
				FROM TBLCASE CS (nolock) WHERE CS.Case_Id = @CaseID
		  END
		  ELSE
		  BEGIN
			   SELECT  TOP 1 CS.Case_ID, 
			   ISNULL(cs.INJUREDPARTY_FIRSTNAME, N'') + N' ' + ISNULL(cs.INJUREDPARTY_LASTNAME, N'') AS INJUREDPARTY_NAME
			   FROM TBLCASE CS (nolock)
			   LEFT OUTER JOIN dbo.tblPacket pkt (NOLOCK) ON CS.FK_Packet_ID = pkt.Packet_Auto_ID    
			   WHERE  pkt.PacketID = @s_l_PacketID 
		  END

		  INSERT INTO @tblPatientWise
		  SELECT TOP 20
			T.Treatment_ID
		  --, PRO.Provider_Id
		  --, PRO.Provider_Name
		  , PRO.Provider_Suitname
		  , convert(decimal(38,2),T.Claim_Amount)[Claim_Amount] 
		  , convert(decimal(38,2),ISNULL(T.Paid_Amount,0)) + convert(decimal(38,2),ISNULL(T.WriteOff,0.00))+ convert(decimal(38,2),ISNULL(T.DeductibleAmount,0.00)) AS [Paid_Amount] 
		  
		  ,Case When CS.DomainId='JL' then 
		  convert(decimal(38,2),T.Claim_Amount) - convert(decimal(38,2),ISNULL(T.Paid_Amount,0)) - convert(decimal(38,2),ISNULL(T.WriteOff,0))-convert(decimal(38,2),ISNULL(T.DeductibleAmount,0.00)) 
		 - isnull((
				Select sum(isnull(Transactions_Amount,0.00)) from tblTransactions with(nolock) where Case_Id=CS.Case_Id AND Transactions_Type in ('C') 
				and Treatment_Id = TreatmentIds
				
				),0.00)
		  else
		  convert(decimal(38,2),T.Claim_Amount) - convert(decimal(38,2),ISNULL(T.Paid_Amount,0)) - convert(decimal(38,2),ISNULL(T.WriteOff,0))-convert(decimal(38,2),ISNULL(T.DeductibleAmount,0.00)) 
		  end
		  [Balance_Amount]  

		  , CONVERT(VARCHAR,T.DateOfService_Start,101) + ' - ' + CONVERT(VARCHAR,T.DateOfService_End,101) [DOS_Range]  
		  , CONVERT(VARCHAR, t.Date_BillSent, 101) [Date_BillSent]  
		  , CONVERT(VARCHAR,T.DateOfService_Start,101) AS DateOfService_Start
		  , CONVERT(VARCHAR,T.DateOfService_End,101) as DateOfService_End
		  , ISNULL(CONVERT(VARCHAR(10), cs.Accident_Date, 101),'') AS ACCIDENT_DATE
		 , UPPER(ISNULL(cs.INJUREDPARTY_FIRSTNAME, N'')) + N' ' + UPPER(ISNULL(cs.INJUREDPARTY_LASTNAME, N'')) AS INJUREDPARTY_NAME
		
		  FROM TBLCASE CS   (NOLOCK)
		  --INNER JOIN TBLCASEPACKET CP ON CS.CASE_ID=CP.CASEID  
		  INNER JOIN TBLPROVIDER PRO (NOLOCK) ON PRO.PROVIDER_ID=CS.PROVIDER_ID   
		  INNER JoiN tblTreatment T (NOLOCK) ON CS.Case_Id = T.Case_Id   
		  LEFT OUTER JOIN dbo.tblPacket pkt (NOLOCK) ON CS.FK_Packet_ID = pkt.Packet_Auto_ID    
		  WHERE pkt.PacketID = @s_l_PacketID  
		   AND ISNULL(cs.INJUREDPARTY_FIRSTNAME, N'') + N' ' + ISNULL(cs.INJUREDPARTY_LASTNAME, N'') IN (select INJUREDPARTY_NAME FROM @tmp)
		   AND (CS.Domainid = 'DK' OR convert(decimal(38,2),T.Claim_Amount) - convert(decimal(38,2),ISNULL(T.Paid_Amount,0)) - convert(decimal(38,2),ISNULL(T.WriteOff,0.00))-convert(decimal(38,2),ISNULL(T.DeductibleAmount,0.00)) > 0)
		   AND (CS.Domainid = 'DK' OR ISNULL(T.DenialReason_ID,0) NOT IN(SELECT DenialReasons_Id from tblDenialReasons where DenialReasons_Type like 'PAID IN FULL'))   
		   AND (CS.Domainid = 'DK' OR T.Treatment_Id NOT IN (select Treatment_Id from TXN_tblTreatment where DenialReasons_ID IN   
				  (SELECT DenialReasons_Id from tblDenialReasons where DenialReasons_Type like 'PAID IN FULL')))
		   ORDER BY convert(date,T.DateOfService_Start) 
		  ---------------------------------------------------------------------
		  SELECT * FROM @tblPatientWise	
		  ---------------------------------------------------------------------
		   
		   SELECT 
			T.Treatment_ID
		  --, PRO.Provider_Id
		  --, PRO.Provider_Name
		  , PRO.Provider_Suitname
		  , convert(decimal(38,2),T.Claim_Amount)[Claim_Amount] 
		  , convert(decimal(38,2),ISNULL(T.Paid_Amount,0)) + convert(decimal(38,2),ISNULL(T.WriteOff,0.00))+ convert(decimal(38,2),ISNULL(T.DeductibleAmount,0.00)) AS [Paid_Amount] 
	        ,Case when CS.DomainID='JL' then convert(decimal(38,2),T.Claim_Amount) - convert(decimal(38,2),ISNULL(T.Paid_Amount,0)) - convert(decimal(38,2),ISNULL(T.WriteOff,0))-convert(decimal(38,2),ISNULL(T.DeductibleAmount,0.00)) 
		  - isnull((
				Select sum(isnull(Transactions_Amount,0.00)) from tblTransactions with(nolock) where Case_Id=CS.Case_Id AND Transactions_Type in ('C') 
				and Treatment_Id = TreatmentIds
				
				),0.00)
		  else
		  convert(decimal(38,2),T.Claim_Amount) - convert(decimal(38,2),ISNULL(T.Paid_Amount,0)) - convert(decimal(38,2),ISNULL(T.WriteOff,0))-convert(decimal(38,2),ISNULL(T.DeductibleAmount,0.00)) 
		  end
		  [Balance_Amount]    
		  , CONVERT(VARCHAR,T.DateOfService_Start,101) + ' - ' + CONVERT(VARCHAR,T.DateOfService_End,101) [DOS_Range]  
		  , CONVERT(VARCHAR, t.Date_BillSent, 101) [Date_BillSent]  
		  , CONVERT(VARCHAR,T.DateOfService_Start,101) AS DateOfService_Start
		  , CONVERT(VARCHAR,T.DateOfService_End,101) as DateOfService_End
		  , ISNULL(CONVERT(VARCHAR(10), cs.Accident_Date, 101),'') AS ACCIDENT_DATE
		 , UPPER(ISNULL(cs.INJUREDPARTY_FIRSTNAME, N'')) + N' ' + UPPER(ISNULL(cs.INJUREDPARTY_LASTNAME, N'')) AS INJUREDPARTY_NAME
		
		  FROM TBLCASE CS   (NOLOCK)
		  --INNER JOIN TBLCASEPACKET CP ON CS.CASE_ID=CP.CASEID  
		  INNER JOIN TBLPROVIDER PRO (NOLOCK) ON PRO.PROVIDER_ID=CS.PROVIDER_ID   
		  INNER JoiN tblTreatment T (NOLOCK) ON CS.Case_Id = T.Case_Id   
		  LEFT OUTER JOIN dbo.tblPacket pkt (NOLOCK) ON CS.FK_Packet_ID = pkt.Packet_Auto_ID    
		  WHERE pkt.PacketID = @s_l_PacketID 
		   AND T.Treatment_ID NOT IN (SELECT Treatment_ID FROM @tblPatientWise)	 
		   and (CS.Domainid = 'DK' OR convert(decimal(38,2),T.Claim_Amount) - convert(decimal(38,2),ISNULL(T.Paid_Amount,0)) - convert(decimal(38,2),ISNULL(T.WriteOff,0.00))-convert(decimal(38,2),ISNULL(T.DeductibleAmount,0.00)) > 0)
		   AND (CS.Domainid = 'DK' OR ISNULL(T.DenialReason_ID,0) NOT IN(SELECT DenialReasons_Id from tblDenialReasons where DenialReasons_Type like 'PAID IN FULL'))   
		   AND (CS.Domainid = 'DK' OR T.Treatment_Id NOT IN (select Treatment_Id from TXN_tblTreatment where DenialReasons_ID IN   
				  (SELECT DenialReasons_Id from tblDenialReasons where DenialReasons_Type like 'PAID IN FULL')))
		   ORDER BY convert(date,T.DateOfService_Start)  
 END  
END  