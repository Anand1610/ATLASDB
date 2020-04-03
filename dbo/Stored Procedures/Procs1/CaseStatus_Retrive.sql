CREATE PROCEDURE [dbo].[CaseStatus_Retrive]
(
	@i_a_Id INT = 0,
	@s_a_DomainID VARCHAR(50)
)
AS        
BEGIN  

 IF(@i_a_Id = 0)
 BEGIN
    SELECT 
		  id	
		, name	
		, description
		, created_by_user	
		, CONVERT(VARCHAR(10), created_date, 101) AS created_date
		, modified_by_user	
		, CONVERT(VARCHAR(10), modified_date, 101) AS modified_date
	 FROM
		 tblCaseStatus	

     WHERE 
		DomainID = @s_a_DomainID
	 ORDER BY 
		 name 	
 END
ELSE
 BEGIN
	SELECT 
		id
		, name	
		, description
		, created_by_user	
		, CONVERT(VARCHAR(10), created_date, 101) AS created_date
		, modified_by_user	
		, CONVERT(VARCHAR(10), modified_date, 101) AS modified_date
	 FROM
		  tblCaseStatus			
	 WHERE
		 id = @i_a_Id
		 and DomainID = @s_a_DomainID
	 ORDER BY 
		 name 
 END

END
