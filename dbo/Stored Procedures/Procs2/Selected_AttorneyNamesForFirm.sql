CREATE PROCEDURE [dbo].[Selected_AttorneyNamesForFirm]    
(
@CaseId varchar(50),
@DomainId varchar(50)
	) 
AS    
BEGIN      
    select cam.AttorneyId,au.Name from  [dbo].[CaseAttorneyMapping] cam join [dbo].[tbl_AttorneyUser] au on cam.AttorneyId =au.UserId  where cam.CaseId=@CaseId and cam.DomainId=@DomainId
END
