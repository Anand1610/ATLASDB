CREATE PROCEDURE [dbo].[Get_Quick_Search_Result]  
(  
 @SearchBy INT,  
 @UserType VARCHAR(5),  
 @DomainID VARCHAR (10),  
 @ProviderID VARCHAR (100),  
 @SearchText VARCHAR (255)  
)  
AS  
BEGIN  
 IF (@SearchBy = 0)  
 BEGIN  
  IF(@UserType = 'P')  
  BEGIN  
   SELECT CASE_ID,  
     InjuredParty_Name=(InjuredParty_LastName + ', ' + InjuredParty_FirstName)   
   FROM TBLCASE (NOLOCK)   
   WHERE Provider_Id = @ProviderID  
   AND  DomainID = @DomainID  
   AND  ISNULL(IsDeleted,0) = 0   
   AND  case_id  LIKE '%' + @SearchText + '%'  
  END  
  ELSE  
  BEGIN  
   SELECT CASE_ID,  
     InjuredParty_Name=(InjuredParty_LastName + ', ' + InjuredParty_FirstName)   
   FROM TBLCASE(NOLOCK)   
   WHERE DomainID= @DomainID   
   and  ISNULL(IsDeleted,0) = 0   
   and  case_id  like '%' + @SearchText + '%'  
  END  
 END  
 ELSE IF (@SearchBy = 1)  
 BEGIN  
  IF(@UserType = 'P')  
  BEGIN  
   SELECT CASE_ID=C.CASE_ID,  
     InjuredParty_Name=(C.InjuredParty_LastName + ', ' + C.InjuredParty_FirstName)   
   FROM TBLCASE C (NOLOCK)   
   JOIN TBLPACKET P (NOLOCK) on C.FK_Packet_ID = P.Packet_Auto_ID   
   WHERE C.Provider_Id=@ProviderID   
   and  C.DomainID= @DomainID   
   and  ISNULL(C.IsDeleted,0) = 0   
   and  P.PacketID  like '%' + @SearchText + '%'  
  END  
  ELSE  
  BEGIN  
   SELECT CASE_ID=C.CASE_ID,  
     InjuredParty_Name=(C.InjuredParty_LastName + ', ' + C.InjuredParty_FirstName)   
   FROM TBLCASE C (NOLOCK)   
   JOIN TBLPACKET P (NOLOCK) on C.FK_Packet_ID = P.Packet_Auto_ID   
   WHERE C.DomainID= @DomainID  
   and  ISNULL(C.IsDeleted,0) = 0   
   and  P.PacketID  like '%' + @SearchText + '%'  
  END  
 END  
 ELSE IF (@SearchBy = 2)  
 BEGIN  
  IF(@UserType = 'P')  
  BEGIN  
   SELECT CASE_ID,  
     InjuredParty_Name=(InjuredParty_LastName + ', ' + InjuredParty_FirstName)   
   FROM TBLCASE(NOLOCK)   
   WHERE Provider_Id=@ProviderID  
   and  DomainID= @DomainID   
   and  ISNULL(IsDeleted,0) = 0   
   and  indexoraaa_number  like '%' + @SearchText + '%'  
  END  
  ELSE  
  BEGIN  
   SELECT CASE_ID,  
     InjuredParty_Name=(InjuredParty_LastName + ', ' + InjuredParty_FirstName)   
   FROM TBLCASE(NOLOCK)   
   WHERE DomainID= @DomainID  
   and  ISNULL(IsDeleted,0) = 0   
   and  indexoraaa_number  like '%' + @SearchText + '%'  
  END  
 END  
 ELSE IF (@SearchBy = 3)  
 BEGIN  
  IF(@UserType = 'P')  
  BEGIN  
   SELECT CASE_ID,  
     InjuredParty_Name=(InjuredParty_LastName + ', ' + InjuredParty_FirstName)   
   FROM TBLCASE(NOLOCK)   
   WHERE Provider_Id=@ProviderID   
   and  DomainID= @DomainID  
   and  ISNULL(IsDeleted,0) = 0   
   and  (injuredparty_lastname like '%' + @SearchText + '%' or injuredparty_firstname like '%' + @SearchText + '%')  
  END  
  ELSE  
  BEGIN  
   SELECT CASE_ID,  
     InjuredParty_Name=(InjuredParty_LastName + ', ' + InjuredParty_FirstName)   
   FROM TBLCASE(NOLOCK) WHERE DomainID= @DomainID  
   and  ISNULL(IsDeleted,0) = 0   
   and  (injuredparty_lastname like '%' + @SearchText + '%' or injuredparty_firstname like '%' + @SearchText + '%')  
  END  
 END  
END