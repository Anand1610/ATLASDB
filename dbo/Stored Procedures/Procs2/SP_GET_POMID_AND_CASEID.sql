CREATE PROCEDURE [dbo].[SP_GET_POMID_AND_CASEID]
(            
 @DomainId VARCHAR(50),
 @pom_id VARCHAR(10)     
)            
AS            
BEGIN 
	
	DECLARE @CaseID TABLE
	(
		CaseID VARCHAR(20)
	)
	 
	 INSERT INTO @CaseID (CaseID) select Case_Id from [dbo].[tblPomCase] where pom_id = @pom_id and case_id NOT LIKE 'ACT%' and DomainId = @DomainId
	
	 select NodeID,CaseID from tblTags where CASEID in (select CaseID from @CaseID) and NodeName = 'PROOF OF MAILING'

END
