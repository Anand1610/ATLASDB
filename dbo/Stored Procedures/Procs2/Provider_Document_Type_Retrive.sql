CREATE PROCEDURE [dbo].[Provider_Document_Type_Retrive]
(
	@i_a_Doc_Id INT = 0,
	@s_a_DomainID VARCHAR(50)
)
AS        
BEGIN  

    SELECT 
		  Doc_Id	
		, ProviderDoc_Type	
		, created_by_user	
		, CONVERT(VARCHAR(10), created_date, 101) AS created_date
		, modified_by_user	
		, CONVERT(VARCHAR(10), modified_date, 101) AS modified_date
	 FROM
		 Provider_Document_Type  		
     WHERE 
		DomainID = @s_a_DomainID
		AND (@i_a_Doc_Id = 0 OR Doc_Id = @i_a_Doc_Id)
	 ORDER BY 
		 ProviderDoc_Type 	
 
	
	

	
END
