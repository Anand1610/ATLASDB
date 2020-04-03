CREATE PROCEDURE [dbo].[Auto_Packet_Insert]
AS
BEGIN
---   active billing denial received
	TRUNCATE TABLE Auto_Packet

	INSERT INTO Auto_Packet
	SELECT distinct
		cas.DomainId,
		cas.Case_Id
	FROM dbo.tblCase cas With(Nolock)
		INNER JOIN dbo.tblprovider pro With(Nolock) on cas.provider_id=pro.provider_id 
		INNER JOIN dbo.tblinsurancecompany ins With(Nolock) on cas.insurancecompany_id=ins.insurancecompany_id
		--LEFT OUTER JOIN dbo.tblTreatment tre With(Nolock) on tre.Case_Id= cas.Case_Id
		LEFT OUTER JOIN dbo.tblPacket pkt ON cas.FK_Packet_ID = pkt.Packet_Auto_ID 
		LEFT OUTER JOIN dbo.tblStatus sta ON cas.Status = sta.Status_Type
	WHERE cas.CASE_ID NOT LIKE 'ACT%' AND cas.DomainId IN ('GLF','LOCALHOST')
	AND (
		Status IN ('ACTIVE BILLING DELAYED 90', 'ACTIVE BILLING DELAYED 120',
				'FEE SCHEDULE OPEN','IME OR EUO NO SHOW','NEW CASE ENTERED','LIT PREP',
				'120 DAY RULE','45 DAY RULE','8 UNIT RULE','MATERIAL MISREP','NO COVERAGE',
				'NOTICE OF CLAIM-30 DAY RULE','PENDING EUO-PATIENT','PENDING EUO-PROVIDER','POLICY EXHAUSTION')
		--OR Filed_Unfiled= 'UNFILED'
		OR Status like 'BELOW $%'
		)
	AND Filed_Unfiled <> 'FILED'
	AND ISNULL(pkt.PacketID,'') =''
	Group by 	
		cas.DomainId,
		cas.Case_Id
--*******************************************************************************
--- ALL CASES have more than 6K
	DECLARE @Auto_Packet_Above_6K TABLE
	(
		DomainID VARCHAR(50),
		InjuredParty_LastName VARCHAR(200),
		InjuredParty_FirstName VARCHAR(200),
		Accident_Date DATETIME,
		provider_id int,
		InsuranceCompany_id int,
		Claim_Amount money
	)
	
	Insert Into @Auto_Packet_Above_6K
	SELECT distinct
		cas.DomainID
		--, cas.Case_Id
		, cas.InjuredParty_LastName
	    , cas.InjuredParty_FirstName
		, cas.Accident_Date
		, cas.Provider_Id
		, cas.InsuranceCompany_Id
		, SUM(CONVERT(Money,Claim_Amount))
		--, CONVERT(int, CONVERT(VARCHAR,DATEDIFF(dd,min(tre.DateOfService_End),GETDATE())))
		--, min(tre.DateOfService_End)
	FROM dbo.tblCase cas With(Nolock)
		INNER JOIN dbo.tblprovider pro With(Nolock) on cas.provider_id=pro.provider_id 
		INNER JOIN dbo.tblinsurancecompany ins With(Nolock) on cas.insurancecompany_id=ins.insurancecompany_id
		LEFT OUTER JOIN dbo.tblPacket pkt ON cas.FK_Packet_ID = pkt.Packet_Auto_ID 
		LEFT OUTER JOIN dbo.tblStatus sta ON cas.Status = sta.Status_Type		 
	WHERE 
		cas.CASE_ID NOT LIKE 'ACT%' AND cas.DomainId IN ('GLF','LOCALHOST')
		AND Filed_Unfiled <> 'FILED'
	GROUP BY
		cas.DomainID
		--, cas.Case_Id
		, cas.InjuredParty_LastName
	    , cas.InjuredParty_FirstName
		, cas.Accident_Date
		, cas.Provider_Id
		, cas.InsuranceCompany_Id
	HAVING SUM(CONVERT(Money,Claim_Amount)) >= 6000
-----------------------------------------------------------------------------------------------------------------------
	--*******************************************************************************
	--- All Patient for linked with above case
	DECLARE @Auto_Packet TABLE
	(
		DomainID VARCHAR(50),
		InjuredParty_LastName VARCHAR(200),
		InjuredParty_FirstName VARCHAR(200),
		Accident_Date DATETIME,
		provider_id int,
		InsuranceCompany_id int
	)
	
	Insert Into @Auto_Packet
	SELECT distinct
		cas.DomainID
		--, cas.Case_Id
		, cas.InjuredParty_LastName
	    , cas.InjuredParty_FirstName
		, cas.Accident_Date
		, cas.Provider_Id
		, cas.InsuranceCompany_Id
		--, CONVERT(int, CONVERT(VARCHAR,DATEDIFF(dd,min(tre.DateOfService_End),GETDATE())))
		--, min(tre.DateOfService_End)
	FROM dbo.tblCase cas With(Nolock)
		INNER JOIN dbo.tblprovider pro With(Nolock) on cas.provider_id=pro.provider_id 
		INNER JOIN dbo.tblinsurancecompany ins With(Nolock) on cas.insurancecompany_id=ins.insurancecompany_id
		INNER JOIN dbo.Auto_Packet pck With(Nolock)on cas.case_id = pck.Case_ID
		LEFT OUTER JOIN dbo.tblTreatment tre With(Nolock) on tre.Case_Id= cas.Case_Id
		
	WHERE 
		cas.CASE_ID NOT LIKE 'ACT%' 
		and status <> 'IN ARB OR LIT'
		--and CONVERT(int, CONVERT(VARCHAR,DATEDIFF(dd,min(tre.DateOfService_End),GETDATE()))) > 45
	GROUP BY
		cas.DomainID
		--, cas.Case_Id
		, cas.InjuredParty_LastName
	    , cas.InjuredParty_FirstName
		, cas.Accident_Date
		, cas.Provider_Id
		, cas.InsuranceCompany_Id
-----------------------------------------------------------------------------------------------------------------------
	INSERT INTO Auto_Packet
	SELECT distinct
		cas.DomainId,
		cas.Case_Id
	FROM dbo.tblCase cas With(Nolock)
		INNER JOIN dbo.tblprovider pro With(Nolock) on cas.provider_id=pro.provider_id 
		INNER JOIN dbo.tblinsurancecompany ins With(Nolock) on cas.insurancecompany_id=ins.insurancecompany_id
		LEFT OUTER JOIN dbo.tblTreatment tre With(Nolock) on tre.Case_Id= cas.Case_Id
		LEFT OUTER JOIN dbo.Billing_Packet pck With(Nolock) on cas.case_id = pck.Case_ID
		INNER JOIN @Auto_Packet auto_bp  on 
					 auto_bp.Accident_Date = cas.Accident_Date
				 and auto_bp.InjuredParty_FirstName = cas.InjuredParty_FirstName
				 and auto_bp.InjuredParty_LastName = cas.InjuredParty_LastName
				 and auto_bp.provider_id = cas.Provider_Id
				 -- and auto_bp.InsuranceCompany_id = cas.InsuranceCompany_id
				 and auto_bp.DomainID = cas.DomainId
	WHERE cas.CASE_ID NOT LIKE 'ACT%' AND cas.Case_Id NOT in (SELECT Case_ID FROM Auto_Packet)
		  AND status <> 'IN ARB OR LIT'
	Group by 	
		cas.DomainId,
		cas.Case_Id
--*******************************************************************************

-----------------------------------------------------------------------------------------------------------
	TRUNCATE TABLE Auto_Packet_Info

	INSERT INTO Auto_Packet_Info
	SELECT distinct
				cas.DomainId,
				cas.Case_Id,
				cas.Case_AutoId,
				cas.Case_Code AS Case_Code,
				pkt.PacketID as PacketID,
				cas.InjuredParty_LastName,
				cas.InjuredParty_FirstName,  
				cas.InsuredParty_LastName,
				cas.InsuredParty_FirstName,
				Provider_Name,  
				ins.InsuranceCompany_Name,  
				convert(decimal(38,2),(convert(money,convert(float,cas.Claim_Amount)))) as Claim_Amount,
				convert(decimal(38,2),(convert(money,convert(float,cas.Claim_Amount) - convert(float,cas.Paid_Amount)))) as Claim_Balance,
				convert(decimal(38,2),cas.Paid_Amount) AS Paid_Amount,
				convert(decimal(38,2),(convert(money,convert(float,cas.Fee_Schedule)))) as Fee_Schedule,
				convert(decimal(38,2),(convert(money,convert(float,cas.Fee_Schedule) - convert(float,cas.Paid_Amount)))) as FS_Balance,
				cas.Status,  
				cas.Initial_Status,
				cas.Accident_Date,		
				cas.Ins_Claim_Number,
				cas.Policy_Number, 
				pro.Provider_GroupName,
				CONVERT(int, CONVERT(VARCHAR,DATEDIFF(dd,cas.date_status_Changed,GETDATE()))) as Status_Age,
				CONVERT(varchar(10), min(tre.DateOfService_Start), 101) AS DateOfService_Start, 
				CONVERT(varchar(12), min(tre.DateOfService_End), 1) AS DateOfService_End,
				CONVERT(varchar(12), min(tre.Date_BillSent), 1) AS Date_BillSent,
				cas.DenialReasons_Type as  DenialReasons,
				--dbo.fncGetDenialReasons(cas.Case_Id) AS DenialReasons,
				dbo.fncGetServiceType(cas.Case_ID) AS ServiceType,
				cas.Provider_Id,
				cas.InsuranceCompany_Id,
				cas.Date_Opened,
				cas.Date_Status_Changed,
				pro.packet_type
			FROM dbo.tblCase cas With(Nolock)
				INNER JOIN dbo.tblprovider pro With(Nolock) on cas.provider_id=pro.provider_id 
				INNER JOIN dbo.tblinsurancecompany ins With(Nolock) on cas.insurancecompany_id=ins.insurancecompany_id
				INNER JOIN Auto_Packet abp With(Nolock) ON  cas.Case_Id = abp.Case_Id and cas.DomainId= abp.DomainId
				LEFT OUTER JOIN dbo.tblTreatment tre With(Nolock) on tre.Case_Id= cas.Case_Id
				LEFT OUTER JOIN dbo.tblPacket pkt ON cas.FK_Packet_ID = pkt.Packet_Auto_ID 
				AND ISNULL(pkt.PacketID,'') =''
			Group by 	
				cas.DomainId,
				cas.Case_Id,
				cas.Case_AutoId,
				cas.Case_Code,
				pkt.PacketID,
				cas.InjuredParty_FirstName,
				cas.InjuredParty_LastName,
				cas.InsuredParty_LastName,
				cas.InsuredParty_FirstName,
				pro.Provider_Name,
				ins.InsuranceCompany_Name,
				cas.Claim_Amount,
				cas.Fee_Schedule,
				cas.Status,
				cas.Accident_Date,		
				cas.Initial_Status,
				pro.Provider_GroupName,
				cas.Paid_Amount,
				cas.Ins_Claim_Number,
				cas.Policy_Number,
				Cas.Date_Opened,
				Cas.Date_Status_Changed,
				cas.DenialReasons_Type,
				cas.Provider_Id,
				cas.InsuranceCompany_Id,
				cas.Date_Opened,
				pro.packet_type
			ORDER BY Provider_Name




    ---- Remove cases which have only one case

	DECLARE @Auto_Packet_SingleCase TABLE
	(
		DomainID VARCHAR(50),
		InjuredParty_LastName VARCHAR(200),
		InjuredParty_FirstName VARCHAR(200),
		Accident_Date DATETIME,
		provider_id int,
		InsuranceCompany_id int,
		CaseCount int,
		CaseIDMax Varchar(100)
	)
	
	Insert Into @Auto_Packet_SingleCase
	SELECT 
		cas.DomainID
		, cas.InjuredParty_LastName
	    , cas.InjuredParty_FirstName
		, cas.Accident_Date
		, cas.Provider_Id
		, cas.InsuranceCompany_Id 
		, Count(cas.Case_Id)
		, MAX(cas.case_id)
	from Auto_Packet_Info cas With(Nolock)
		GROUP BY
		cas.DomainID
		, cas.InjuredParty_LastName
	    , cas.InjuredParty_FirstName
		, cas.Accident_Date
		, cas.Provider_Id
		, cas.InsuranceCompany_Id
	HAVING 
		Count(cas.Case_Id) = 1



		DELETE FROM dbo.Auto_Packet_Info WHERE Case_id IN(
		SELECT CaseIDMax FROM @Auto_Packet_SingleCase)
		
END
