CREATE PROCEDURE [dbo].[GetPOMPrintInfo_NEW]-- [GetPOMPrintInfo] 'localhost','','','',''    
 @DomainID VARCHAR(50),    
 @POMID AS INT,    
 @Date_POM_Printed_From DateTime = Null,    
 @Date_POM_Printed_To DateTime = Null,    
 @PROVIDER_ID AS VARCHAR(50),    
 @POMType VARCHAR(50)    
AS    
BEGIN    
    
DECLARE @POM_ID INT     
    
            DECLARE @caseData Table
			(
			[Case_Id] varchar(50) index IDX_CLUST Clustered,
			[DomainId] varchar(50),
			[Provider_Id] int NULL,
			[Provider_Name] varchar(250) NULL,
			[InsuranceCompany_Name] varchar(250) NULL
			)

			INSERT INTO @caseData(Case_Id,DomainId,Provider_Id, Provider_Name, InsuranceCompany_Name)
				SELECT 
				cas.Case_Id,cas.DomainId,cas.Provider_Id, Provider_Name, InsuranceCompany_Name
			from tblcase cas with(nolock) 
			INNER JOIN dbo.tblprovider pro(NOLOCK) ON cas.provider_id = pro.provider_id
			INNER JOIN dbo.tblinsurancecompany ins(NOLOCK) ON cas.insurancecompany_id = ins.insurancecompany_id
			where cas.domainid=@DomainID 


			DECLARE @TBLPOMCASE TABLE
			(
			  [Case_Id] varchar(50),
			  [DomainId] varchar(30),
			  [pom_Id] int,
			  [POM_FileName] varchar(500),
			  [POM_PacketFileName] varchar(200),
			  [BasePathId] int
			)
			
			INSERT INTO @TBLPOMCASE(Case_Id,DomainId, pom_Id, POM_FileName, POM_PacketFileName, BasePathId)
			SELECT Case_Id,DomainId, pom_Id, POM_FileName, POM_PacketFileName, BasePathId FROM TBLPOMCASE with(nolock) 
			where domainid=@DomainID AND (POMType = @POMType) 

			DECLARE @PROVIDERNAME TABLE
			(
			  [Case_Id] varchar(50),
			  [ProviderName] varchar(MAX) NULL
			   
			)

			INSERT INTO @PROVIDERNAME(Case_Id, ProviderName)
			SELECT Case_Id, STUFF((SELECT DISTINCT ','+cas.Provider_Name FROM TBLPOM (NOLOCK)    
								   INNER JOIN @TBLPOMCASE   POMCASE ON TBLPOM.POM_ID_new=POMCASE.POM_ID     
								   INNER JOIN @caseData cas ON POMCASE.CASE_ID = cas.CASE_ID AND  POMCASE.DomainID = cas.Domainid   
								   WHERE    POMCASE.DomainId = @DomainID    
								   FOR XML PATH('')    
								   )    
								   ,1,1,'') AS ProviderName FROM @caseData cas

			DECLARE @INSURANCECOMPANYNAME TABLE
			(
			  [Case_Id] varchar(50),
			  [InsuranceName] varchar(MAX) NULL
			   
			)

			INSERT INTO @INSURANCECOMPANYNAME(Case_Id, InsuranceName)
			SELECT Case_Id,   STUFF    
							   (    
							   (SELECT DISTINCT ','+cas.InsuranceCompany_Name    
							   FROM TBLPOM (NOLOCK)    
							   INNER JOIN @TBLPOMCASE POMCASE ON TBLPOM.POM_ID_new=POMCASE.POM_ID AND TBLPOM.DomainId=POMCASE.DomainId   
							   INNER JOIN @caseData   cas ON  POMCASE.CASE_ID = cas.CASE_ID   AND POMCASE.DomainId = cas.DomainId    
							   WHERE  POMCASE.DomainId = @DomainID  
							   FOR XML PATH('')    
							   )    
							   ,1,1,'') AS InsuranceName  FROM @caseData cas



    
 SELECT DISTINCT    
     
    PC.POM_ID AS POM_ID ,    
       
   CONVERT(NVARCHAR(12),pom_date,101) AS pom_date,    
   POM_FILENAME,    
   ISNULL(POM_ReceivedFileName,'') AS POM_ReceivedFileName,    
   pom_generated_by,    
   concat(replace(VirtualBasePath, '/', '\'),'\',Pc.DomainID,'\POM Generated\',POM_FILENAME) as Link,    
   --ParameterValue + Pc.DomainID+'/POM Generated/' + POM_FILENAME AS Link,    
   --ParameterValue +Pc.DomainID+'/POM/' + POM_ReceivedFileName AS LinkStampedPOM,    
   concat(replace(VirtualBasePath, '/', '\'),'\',Pc.DomainID,'/POM/',POM_ReceivedFileName) as LinkStampedPOM,    
   pom_scan_date,    
   [Received_Date]=(CASE WHEN pom_scan_date IS NOT NULL 
   THEN CONVERT(VARCHAR(12),pom_scan_date,101) ELSE convert(varchar(12),'-') END),    
   pom_scan_by,    
   ISNULL(POM_PacketFileName,'') AS POM_PacketFileName,    
   ParameterValue + POM_PacketFileName as LinkPOMPacket   , 
   --STUFF    
   --(    
   --(SELECT DISTINCT ','+cas.Provider_Name    
   --FROM TBLPOM (NOLOCK)    
   --INNER JOIN @TBLPOMCASE   POMCASE ON TBLPOM.POM_ID_new=POMCASE.POM_ID     
   --INNER JOIN @caseData cas ON POMCASE.CASE_ID = cas.CASE_ID AND  POMCASE.DomainID = cas.Domainid   
   --WHERE POMCASE.pom_id=PC.pom_id AND  POMCASE.DomainId = @DomainID    
   --FOR XML PATH('')    
   --)    
   --,1,1,'') AS ProviderName, 
   ProviderName,
   InsuranceName ,
   --STUFF    
   --(    
   --(SELECT DISTINCT ','+cas.InsuranceCompany_Name    
   --FROM TBLPOM (NOLOCK)    
   --INNER JOIN @TBLPOMCASE POMCASE ON TBLPOM.POM_ID_new=POMCASE.POM_ID AND TBLPOM.DomainId=POMCASE.DomainId   
   --INNER JOIN @caseData   cas ON  POMCASE.CASE_ID = cas.CASE_ID   AND POMCASE.DomainId = cas.DomainId    
   --WHERE POMCASE.pom_id=PC.pom_id  AND POMCASE.DomainId = @DomainID  
   --FOR XML PATH('')    
   --)    
   --,1,1,'') AS InsuranceName ,
   ISNULL( CONVERT(NVARCHAR(12),P.POM_Date_Bill_Send,101),'') AS date_Bill_Sent   
       
 FROM    
   TBLPOM P (NOLOCK)    
   INNER JOIN @TBLPOMCASE PC  ON P.POM_ID_new=PC.POM_ID and P.DomainId = PC.DomainId    
   INNER JOIN @caseData TC  ON PC.CASE_ID = TC.CASE_ID and PC.DomainId = TC.DomainId      
   INNER JOIN tblBasePath b (NOLOCK) on b.BasePathId = PC.BasePathId     
   LEFT OUTER JOIN tblApplicationSettings settings (NOLOCK) ON p.DomainId =  settings.DomainId 
   INNER JOIN @PROVIDERNAME prov ON TC.case_id=prov.Case_Id
   INNER JOIN @INSURANCECOMPANYNAME INS ON TC.case_id=INS.Case_Id
   and ParameterName = 'DocumentUploadLocation' 
  

 WHERE 1=1 and Pc.DomainID =@DomainID    
    
 AND (@POMID='' OR PC.POM_ID = @POMID)    
 AND (@Date_POM_Printed_From='' OR (pom_date Between CONVERT(datetime,@Date_POM_Printed_From) 
 And CONVERT(datetime,@Date_POM_Printed_To + 1)))    
 AND (@PROVIDER_ID='' OR TC.Provider_Id = @PROVIDER_ID)    
    
 ORDER BY PC.POM_ID DESC    
 --SELECT * FROM TBLPOM    
END    
