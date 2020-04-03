CREATE PROCEDURE [dbo].[GET_MEDICALTABLE]  -- [GET_MEDICALTABLE] 'AF19-103592'  
 @CaseID VARCHAR(40)  
AS  
BEGIN  
  
DECLARE @s_l_PacketID VARCHAR(40) = ''  
  
 SET @s_l_PacketID = ( SELECT  TOP 1 ISNULL(PacketID,'') FROM dbo.tblCase cas  (NOLOCK)
 INNER  JOIN dbo.tblPacket pkt (NOLOCK) ON cas.FK_Packet_ID = pkt.Packet_Auto_ID   
 WHERE CASE_ID = @CaseID OR PacketID = @CaseID) 
  
 PRINT @s_l_PacketID  
  
 IF(@s_l_PacketID  IS NULL)  
 BEGIN  
  print 'Without Packetid'  
  SELECT PRO.Provider_Id
		, PRO.Provider_Name
		, PRO.Provider_Suitname
		, convert(decimal(38,2),T.Claim_Amount)[Claim_Amount]
		, convert(decimal(38,2),ISNULL(T.Paid_Amount,0)) + convert(decimal(38,2),ISNULL(T.WriteOff,0.00)) + convert(decimal(38,2),ISNULL(T.DeductibleAmount,0.00))[Paid_Amount] 
		, convert(decimal(38,2),T.Claim_Amount) - convert(decimal(38,2),ISNULL(T.Paid_Amount,0) ) - convert(decimal(38,2),ISNULL(T.WriteOff,0.00))-convert(decimal(38,2),ISNULL(T.DeductibleAmount,0.00)) [Balance_Amount]  
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
 END  
 ELSE  
 BEGIN  
  
  --DECLARE @S_l_Packeted_Case_Ids VARCHAR(MAX)  
  --SET @S_l_Packeted_Case_Ids =  STUFF(  
  --      (SELECT ',' + CASE_ID FROM dbo.tblCase cas  
  --            INNER  JOIN dbo.tblPacket pkt ON cas.FK_Packet_ID = pkt.Packet_Auto_ID   
  --            WHERE PacketID = @s_l_PacketID --and cas.DomainID = @DomainID  
  --      FOR XML PATH('')), 1, 1, '')  
  --print @S_l_Packeted_Case_Ids  
  
  print 'With Packetid'  
  SELECT PRO.Provider_Id
  , PRO.Provider_Name
  , PRO.Provider_Suitname
  , convert(decimal(38,2),T.Claim_Amount)[Claim_Amount] 
  , convert(decimal(38,2),ISNULL(T.Paid_Amount,0)) + convert(decimal(38,2),ISNULL(T.WriteOff,0.00))+ convert(decimal(38,2),ISNULL(T.DeductibleAmount,0.00)) AS [Paid_Amount] 
  , convert(decimal(38,2),T.Claim_Amount) - convert(decimal(38,2),ISNULL(T.Paid_Amount,0)) - convert(decimal(38,2),ISNULL(T.WriteOff,0))-convert(decimal(38,2),ISNULL(T.DeductibleAmount,0.00)) [Balance_Amount]  
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
   and (CS.Domainid = 'DK' OR convert(decimal(38,2),T.Claim_Amount) - convert(decimal(38,2),ISNULL(T.Paid_Amount,0)) - convert(decimal(38,2),ISNULL(T.WriteOff,0.00))-convert(decimal(38,2),ISNULL(T.DeductibleAmount,0.00)) > 0)
   AND (CS.Domainid = 'DK' OR ISNULL(T.DenialReason_ID,0) NOT IN(SELECT DenialReasons_Id from tblDenialReasons where DenialReasons_Type like 'PAID IN FULL'))   
   AND (CS.Domainid = 'DK' OR T.Treatment_Id NOT IN (select Treatment_Id from TXN_tblTreatment where DenialReasons_ID IN   
          (SELECT DenialReasons_Id from tblDenialReasons where DenialReasons_Type like 'PAID IN FULL')))
   ORDER BY convert(date,T.DateOfService_Start)  
 END  
END  