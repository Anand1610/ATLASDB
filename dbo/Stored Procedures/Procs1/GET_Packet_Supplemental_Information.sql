 CREATE PROCEDURE [dbo].[GET_Packet_Supplemental_Information]  
--  [GET_Packet_Supplemental_Information] 'AF', 'AF19-102413'   
	@DomainId VARCHAR(40),
	@Case_ID VARCHAR(40) 
 AS  
BEGIN  
	DECLARE @s_l_PacketID VARCHAR(40) = ''  
	SET @s_l_PacketID = ( SELECT  TOP 1 ISNULL(PacketID,'') FROM dbo.tblCase cas  (NOLOCK)
						 INNER  JOIN dbo.tblPacket pkt (NOLOCK) ON cas.FK_Packet_ID = pkt.Packet_Auto_ID   
						 WHERE (CASE_ID = @Case_ID OR PacketID = @Case_ID) and cas.DomainID =@DomainId
						)  
	PRINT @s_l_PacketID  
	BEGIN  
			---	Replace inf for one case
			declare @tmp table
			(
				Case_ID VARCHAR(40),
				Provider_Suitname VARCHAR(200),
				PROVIDER_LOCAL_ADDRESS VARCHAR(200),
				PROVIDER_LOCAL_CITY VARCHAR(100),
				PROVIDER_LOCAL_STATE VARCHAR(100),
				PROVIDER_LOCAL_ZIP VARCHAR(100),
				INJUREDPARTY_NAME VARCHAR(100),
				INSURANCECOMPANY_NAME VARCHAR(100),
				InsuranceCompany_Local_Address VARCHAR(200),
				InsuranceCompany_Local_City VARCHAR(100),
				InsuranceCompany_Local_State VARCHAR(100),
				InsuranceCompany_Local_Zip VARCHAR(100),
				Ins_Claim_Number VARCHAR(100),
				Policy_Number VARCHAR(100)
			)
			IF EXISTS(SELECT TOP 1 CASE_ID FROM TBLCASE CS (nOLOCK) INNER JOIN dbo.tblPacket pkt (NOLOCK) ON CS.FK_Packet_ID = pkt.Packet_Auto_ID  WHERE  CS.Domainid = @DomainId AND CS.Case_Id = @Case_ID) 
			BEGIN		
			    insert into @tmp 
				SELECT TOP 1 
					  CS.Case_ID
					, PRO.Provider_Suitname
					, PRO.PROVIDER_LOCAL_ADDRESS
					, PRO.PROVIDER_LOCAL_CITY
					, PRO.PROVIDER_LOCAL_STATE
					, PRO.PROVIDER_LOCAL_ZIP
					, UPPER(ISNULL(cs.INJUREDPARTY_FIRSTNAME, N'')) + N' ' + UPPER(ISNULL(cs.INJUREDPARTY_LASTNAME, N'')) AS INJUREDPARTY_NAME
					, ins.INSURANCECOMPANY_NAME
					, ins.InsuranceCompany_Local_Address
					, ins.InsuranceCompany_Local_City
					, ins.InsuranceCompany_Local_State
					, ins.InsuranceCompany_Local_Zip
					, Ins_Claim_Number
					, Policy_Number  
				FROM TBLCASE CS  (NOLOCK)
				INNER JOIN TBLPROVIDER PRO (NOLOCK) ON PRO.PROVIDER_ID=CS.PROVIDER_ID 
				INNER JOIN tblInsuranceCompany ins (NOLOCK) ON ins.InsuranceCompany_Id = CS.InsuranceCompany_Id   
				WHERE CS.Case_Id = @Case_ID  
					AND CS.Domainid =@DomainId
			END
	  ELSE
	  BEGIN		
			
			---	Replace inf for one case			    
				insert into @tmp 
				SELECT TOP 1 
					  CS.Case_ID
					, PRO.Provider_Suitname
					, PRO.PROVIDER_LOCAL_ADDRESS
					, PRO.PROVIDER_LOCAL_CITY
					, PRO.PROVIDER_LOCAL_STATE
					, PRO.PROVIDER_LOCAL_ZIP
					, UPPER(ISNULL(cs.INJUREDPARTY_FIRSTNAME, N'')) + N' ' + UPPER(ISNULL(cs.INJUREDPARTY_LASTNAME, N'')) AS INJUREDPARTY_NAME
					, ins.InsuranceCompany_Name
					, ins.InsuranceCompany_Local_Address
					, ins.InsuranceCompany_Local_City
					, ins.InsuranceCompany_Local_State
					, ins.InsuranceCompany_Local_Zip
					, Ins_Claim_Number
					, Policy_Number  
				FROM TBLCASE CS  (NOLOCK)
				INNER JOIN TBLPROVIDER PRO (NOLOCK) ON PRO.PROVIDER_ID=CS.PROVIDER_ID 
				INNER JOIN tblInsuranceCompany ins (NOLOCK) ON ins.InsuranceCompany_Id = CS.InsuranceCompany_Id   
				INNER JOIN dbo.tblPacket pkt (NOLOCK) ON CS.FK_Packet_ID = pkt.Packet_Auto_ID    
				WHERE  pkt.PacketID = @s_l_PacketID 
					AND CS.Domainid =@DomainId
			END
			select * from @tmp
		  --print 'With Packetid'  
		  SELECT 
				  PRO.Provider_Suitname
				, PRO.PROVIDER_LOCAL_ADDRESS
				, PRO.PROVIDER_LOCAL_CITY
				, PRO.PROVIDER_LOCAL_STATE
				, PRO.PROVIDER_LOCAL_ZIP
				, PRO.PROVIDER_LOCAL_PHONE
				, PRO.PROVIDER_EMAIL
				, UPPER(ISNULL(cs.INJUREDPARTY_FIRSTNAME, N'')) + N' ' + UPPER(ISNULL(cs.INJUREDPARTY_LASTNAME, N'')) AS INJUREDPARTY_NAME	
		  FROM TBLCASE CS   (NOLOCK)
		  --INNER JOIN TBLCASEPACKET CP ON CS.CASE_ID=CP.CASEID  
		  INNER JOIN TBLPROVIDER PRO (NOLOCK) ON PRO.PROVIDER_ID=CS.PROVIDER_ID   
		  LEFT OUTER JOIN dbo.tblPacket pkt (NOLOCK) ON CS.FK_Packet_ID = pkt.Packet_Auto_ID    
		  inner join @tmp tmp on  PRO.Provider_Suitname	<> tmp.Provider_Suitname	 or PRO.PROVIDER_LOCAL_ADDRESS	<>	 tmp.PROVIDER_LOCAL_ADDRESS	or PRO.PROVIDER_LOCAL_CITY	<>	 tmp.PROVIDER_LOCAL_CITY  	or PRO.PROVIDER_LOCAL_ZIP	<>	 tmp.PROVIDER_LOCAL_ZIP or  PRO.PROVIDER_LOCAL_STATE	<>	 tmp.PROVIDER_LOCAL_STATE
  	      or UPPER(ISNULL(cs.INJUREDPARTY_FIRSTNAME, N'')) + N' ' + UPPER(ISNULL(cs.INJUREDPARTY_LASTNAME, N''))	<>	 tmp.INJUREDPARTY_NAME	
		  WHERE pkt.PacketID = @s_l_PacketID  
			AND CS.Domainid =@DomainId

		---- InsuranceCompany Details

		SELECT DISTINCT 
			  ins.InsuranceCompany_Name
			, ins.InsuranceCompany_Local_Address
			, ins.InsuranceCompany_Local_City
			, ins.InsuranceCompany_Local_State
			, ins.InsuranceCompany_Local_Zip
			, ins.INSURANCECOMPANY_LOCAL_PHONE
			, ins.INSURANCECOMPANY_EMAIL
			, cs.Ins_Claim_Number
			, cs.Policy_Number
		FROM TBLCASE CS  (NOLOCK) 
		INNER JOIN tblInsuranceCompany ins (NOLOCK) ON ins.InsuranceCompany_Id = CS.InsuranceCompany_Id   
		LEFT OUTER JOIN dbo.tblPacket pkt (NOLOCK) ON CS.FK_Packet_ID = pkt.Packet_Auto_ID   
		inner join @tmp tmp on tmp.InsuranceCompany_Name <> ins.InsuranceCompany_Name or
				   INS.InsuranceCompany_Local_Address	<>	 tmp.InsuranceCompany_Local_Address	or
				   INS.InsuranceCompany_Local_City	<>	 tmp.InsuranceCompany_Local_City	or
				   INS.InsuranceCompany_Local_State	<>	 tmp.InsuranceCompany_Local_State	or
				   INS.InsuranceCompany_Local_Zip	<>	 tmp.InsuranceCompany_Local_Zip	or
				   cs.Ins_Claim_Number	<>	 tmp.Ins_Claim_Number	or
                   cs.Policy_Number	<>	 tmp.Policy_Number	 
		WHERE pkt.PacketID = @s_l_PacketID  
			AND CS.Domainid =@DomainId
			

		---- Injured Party
		SELECT DISTINCT 
			  UPPER(ISNULL(cs.INJUREDPARTY_FIRSTNAME, N'')) + N' ' + UPPER(ISNULL(cs.INJUREDPARTY_LASTNAME, N'')) AS INJUREDPARTY_NAME
			, cs.Ins_Claim_Number
		FROM TBLCASE CS  (NOLOCK)
		LEFT OUTER JOIN dbo.tblPacket pkt (NOLOCK) ON CS.FK_Packet_ID = pkt.Packet_Auto_ID    
		inner join @tmp tmp on UPPER(ISNULL(cs.INJUREDPARTY_FIRSTNAME, N'')) + N' ' + UPPER(ISNULL(cs.INJUREDPARTY_LASTNAME, N''))	<>	 tmp.INJUREDPARTY_NAME or
				   cs.Ins_Claim_Number	<>	 tmp.Ins_Claim_Number	
		WHERE pkt.PacketID = @s_l_PacketID  
			AND CS.Domainid =@DomainId

 END  
END 

