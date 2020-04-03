CREATE PROCEDURE [dbo].[DenialReason_Retrive]
(
	@i_a_Denial_ID INT = 0,
	@s_a_DomainID VARCHAR(50)
)
AS        
BEGIN  
  SELECT 
		  PK_Denial_ID	
		, DenialReason	
		, created_by_user	
		, CONVERT(VARCHAR(10), created_date, 101) AS created_date
		, modified_by_user	
		, CONVERT(VARCHAR(10), modified_date, 101) AS modified_date
	 FROM
		 MST_DenialReasons  		
     WHERE 
		DomainID = @s_a_DomainID
		AND (@i_a_Denial_ID = 0 OR PK_Denial_ID = @i_a_Denial_ID)
	 ORDER BY 
		 DenialReason 	
	
END
