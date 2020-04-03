CREATE PROCEDURE [dbo].[Arbitrator_Retrive]
(
	@i_a_ARBITRATOR_ID INT = 0,
	@s_a_DomainID      VARCHAR(50)
)
AS        
BEGIN  
	SELECT 
		  ARBITRATOR_ID	
		, ARBITRATOR_NAME
		, ABITRATOR_LOCATION
		, ARBITRATOR_PHONE
		, ARBITRATOR_FAX 
	    , IS_AAA
		, ARBITRATOR_Email
		, created_by_user	
		, CONVERT(VARCHAR(10), created_date, 101) AS created_date
		, modified_by_user	
		, CONVERT(VARCHAR(10), modified_date, 101) AS modified_date
	 FROM
		 TblArbitrator  	
	 WHERE
		 DomainID = @s_a_DomainID
		 and (@i_a_ARBITRATOR_ID = 0 or ARBITRATOR_ID = @i_a_ARBITRATOR_ID)
	 ORDER BY 
		 ARBITRATOR_NAME  asc 
 
		
END
