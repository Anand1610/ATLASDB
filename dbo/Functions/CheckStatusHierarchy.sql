CREATE FUNCTION [dbo].[CheckStatusHierarchy] (  
 @CaseID VARCHAR(20)  
 ,@OldStatus VARCHAR(200)  
 ,@NewStatus VARCHAR(200)  
 ,@UserName VARCHAR(50)  
 ,@DomainID VARCHAR(20)  
 )  
RETURNS INT  
AS  
BEGIN  
 DECLARE @OldStatusHierarchy INT  
  ,@Description VARCHAR(200)  
  ,@NewStatusHierarchy INT  
  
 SELECT @OldStatusHierarchy = CONVERT(INT, ISNULL(STATUS_HIERARCHY, 0))  
 FROM Tblstatus ts(NOLOCK)  
 INNER JOIN TBLcase tc(NOLOCK) ON tc.STATUS = ts.status_Type  
 WHERE tc.case_id = @CaseID  
 AND  tc.STATUS = @OldStatus  
 AND  tc.DomainId = @DomainID  and tS.DomainId= tc.DomainId 
  
 SELECT @NewStatusHierarchy = STATUS_HIERARCHY  
 FROM Tblstatus ts(NOLOCK)  
 WHERE status_type = @NewStatus  AND  ts.DomainId = @DomainID  

 if exists(select * from tblStatusHierarchyAccessAtlas where username=@UserName and domainid=@DomainID)
 BEGIN
  return 1

  End
 IF (@NewStatusHierarchy < @OldStatusHierarchy AND ((@NewStatusHierarchy > 0 and @OldStatusHierarchy > 0) or @DomainID not in ('AMT','PDC')) )
 BEGIN  
 
  
  RETURN 0  
 END  
   
 RETURN 1  
END  