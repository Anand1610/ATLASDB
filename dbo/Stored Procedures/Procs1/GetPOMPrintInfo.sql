CREATE PROCEDURE [dbo].[GetPOMPrintInfo]-- [GetPOMPrintInfo] 'localhost','','','',''    
 @DomainID VARCHAR(50),    
 @POMID AS INT,    
 @Date_POM_Printed_From DateTime = Null,    
 @Date_POM_Printed_To DateTime = Null,    
 @PROVIDER_ID AS VARCHAR(50),    
 @POMType VARCHAR(50)    
AS    
BEGIN    
    
DECLARE @POM_ID INT     
    
    
    
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
   [Received_Date]=(CASE WHEN pom_scan_date IS NOT NULL THEN CONVERT(VARCHAR(12),pom_scan_date,101) ELSE convert(varchar(12),'-') END),    
   pom_scan_by,    
   ISNULL(POM_PacketFileName,'') AS POM_PacketFileName,    
   ParameterValue + POM_PacketFileName as LinkPOMPacket,    
   STUFF    
   (    
   (SELECT DISTINCT ','+tblProvider.Provider_Name    
   FROM TBLPOM (NOLOCK)    
   INNER JOIN TBLPOMCASE (NOLOCK) ON TBLPOM.POM_ID_new=TBLPOMCASE.POM_ID  AND TBLPOM.domainid = TBLPOMCASE.domainid  
   INNER JOIN TBLCASE (NOLOCK) ON TBLPOMCASE.CASE_ID = TBLCASE.CASE_ID AND  TBLPOMCASE.DomainID = TBLCASE.Domainid   
   INNER JOIN tblProvider (NOLOCK) ON TBLCASE.Provider_Id = tblProvider.Provider_Id    
   WHERE TBLPOMCASE.pom_id=PC.pom_id AND tblProvider.DomainId=@DomainID  AND TBLPOMCASE.DomainId = @DomainID    
   FOR XML PATH('')    
   )    
   ,1,1,'') AS ProviderName,    
   STUFF    
   (    
   (SELECT DISTINCT ','+tblInsuranceCompany.InsuranceCompany_Name    
   FROM TBLPOM (NOLOCK)    
   INNER JOIN TBLPOMCASE (NOLOCK) ON TBLPOM.POM_ID_new=TBLPOMCASE.POM_ID AND TBLPOM.DomainId=TBLPOMCASE.DomainId   
   INNER JOIN TBLCASE (NOLOCK) ON TBLPOMCASE.CASE_ID = TBLCASE.CASE_ID   AND TBLPOMCASE.DomainId = TBLCASE.DomainId    
   INNER JOIN tblInsuranceCompany (NOLOCK) ON TBLCASE.InsuranceCompany_Id = tblInsuranceCompany.InsuranceCompany_Id    
   WHERE TBLPOMCASE.pom_id=PC.pom_id AND tblInsuranceCompany.DomainId = @DomainID AND TBLPOMCASE.DomainId = @DomainID  
   FOR XML PATH('')    
   )    
   ,1,1,'') AS InsuranceName ,
   ISNULL( CONVERT(NVARCHAR(12),P.POM_Date_Bill_Send,101),'') AS date_Bill_Sent   
       
 FROM    
   TBLPOM P (NOLOCK)    
   INNER JOIN TBLPOMCASE PC (NOLOCK) ON P.POM_ID_new=PC.POM_ID and P.DomainId = PC.DomainId    
   INNER JOIN TBLCASE TC (NOLOCK) ON PC.CASE_ID = TC.CASE_ID and PC.DomainId = TC.DomainId      
   INNER JOIN tblBasePath b (NOLOCK) on b.BasePathId = PC.BasePathId     
   LEFT OUTER JOIN tblApplicationSettings settings (NOLOCK) ON p.DomainId =  settings.DomainId and ParameterName = 'DocumentUploadLocation'     
 WHERE 1=1 and Pc.DomainID =@DomainID    
    
 AND (@POMID='' OR PC.POM_ID = @POMID)    
 AND (@Date_POM_Printed_From='' OR (pom_date Between CONVERT(datetime,@Date_POM_Printed_From) And CONVERT(datetime,@Date_POM_Printed_To + 1)))    
 AND (@PROVIDER_ID='' OR TC.Provider_Id = @PROVIDER_ID)    
 AND (PC.POMType = @POMType)    
 ORDER BY PC.POM_ID DESC    
 --SELECT * FROM TBLPOM    
END    
