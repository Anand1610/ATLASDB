CREATE PROCEDURE [dbo].[Rebuttal_Status_Retrive] -- [Rebuttal_Status_Retrive] 0,'localhost'
(
	@i_a_Rebuttal_Status_Id INT = 0,
	@s_a_DomainID VARCHAR(50)
)
AS        
BEGIN  

 IF(@i_a_Rebuttal_Status_Id = 0)
 BEGIN
    SELECT 
		PK_Rebuttal_Status_ID	
		, Rebuttal_Status	
		, created_by_user	
		, CONVERT(VARCHAR(10), created_date, 101) AS created_date
		, modified_by_user	
		, CONVERT(VARCHAR(10), modified_date, 101) AS modified_date
	 FROM
		 Rebuttal_Status  		
     WHERE 
		DomainID = @s_a_DomainID
	 ORDER BY 
		 Rebuttal_Status 	
 END
 ELSE
 BEGIN
	SELECT 
		PK_Rebuttal_Status_ID	
		, Rebuttal_Status	
		, created_by_user	
		, CONVERT(VARCHAR(10), created_date, 101) AS created_date
		, modified_by_user	
		, CONVERT(VARCHAR(10), modified_date, 101) AS modified_date
	 FROM
		 Rebuttal_Status  		
	 WHERE
		 PK_Rebuttal_Status_ID = @i_a_Rebuttal_Status_Id
		 and DomainID = @s_a_DomainID
	 ORDER BY 
		 Rebuttal_Status 
 END
	

	
END
