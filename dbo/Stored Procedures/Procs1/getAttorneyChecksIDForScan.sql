CREATE PROCEDURE [dbo].[getAttorneyChecksIDForScan]--getProviderChecksIDForScan 'FH13-163690'  
(  
@DomainId NVARCHAR(50),  
@s_a_case_id varchar(50)  
)  
as  
begin  
  
	DECLARE @i_l_node_id INT  
   
	SET @i_l_node_id = (SELECT top 1 NodeID from tblTags  WHERE CaseID = @s_a_case_id AND NodeName IN  ('Payment to Attorney', 'PAYMENTS - ATTORNEY') AND DomainId = @DomainId)  
   
	IF  (@i_l_node_id is null)  
	BEGIN  
		EXEC sp_createDefaultDocTypesForTree  @DomainId,  @s_a_case_id, @s_a_case_id   
	END  

  
	IF(@DomainId = 'AMT')
	BEGIN
		 
		SELECT top 1 NodeID from tblTags WHERE CaseID = @s_a_case_id AND NodeName = 'Payment to Attorney' AND DomainId = @DomainId
	END
	ELSE
	BEGIN
		SELECT top 1 NodeID from tblTags WHERE CaseID = @s_a_case_id AND NodeName = 'PAYMENTS - ATTORNEY'  AND DomainId = @DomainId
	END
END  
  
