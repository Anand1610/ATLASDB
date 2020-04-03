CREATE procedure ManinReasonTypeRetrive
(
	
	@DomainId VARCHAR(50)
)
AS        
BEGIN  

    SELECT 
		  DenialReasons_Id	
		, DenialReasons_Type	
		, created_by_user	
		, CONVERT(VARCHAR(10), created_date, 101) AS created_date
		, modified_by_user	
		, CONVERT(VARCHAR(10), modified_date, 101) AS modified_date
		,isnull(IsMain,0) [IsMain]
	 FROM
		 tblDenialReasons  		
     WHERE 
		DomainID = @DomainId
		
		and isnull(IsMain,0)=1
	 ORDER BY 
		 DenialReasons_Type 	
 
		
END