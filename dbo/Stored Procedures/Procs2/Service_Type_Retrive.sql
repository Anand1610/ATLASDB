
CREATE PROCEDURE [dbo].[Service_Type_Retrive]
(
	@i_a_ServiceType_ID			INT,	
	@s_a_DomainID				VARCHAR(50)
)
AS        
BEGIN  

 IF(@i_a_ServiceType_ID = 0)
 BEGIN
    SELECT 
				   ServiceType_ID
				  ,ServiceType				 		 
				  ,ServiceDesc			      
				  ,DomainID			
				  ,created_by_user	
				  ,CONVERT(VARCHAR(10), created_date, 101) AS created_date
		          ,modified_by_user	
		          ,CONVERT(VARCHAR(10), modified_date, 101) AS modified_date
	 FROM
		 tblServiceType  		
     WHERE 
		DomainID = @s_a_DomainID
	 ORDER BY 
		 ServiceType 	
 END
 ELSE
 BEGIN
	SELECT 
					 
				   ServiceType_ID
	              ,ServiceType				 		 
				  ,ServiceDesc			      				
				  ,DomainID			
				  ,created_by_user	
				  ,CONVERT(VARCHAR(10), created_date, 101) AS created_date
		          ,modified_by_user	
		          ,CONVERT(VARCHAR(10), modified_date, 101) AS modified_date
	 FROM
		 tblServiceType  		
	 WHERE
		 ServiceType_ID = @i_a_ServiceType_ID
		 and DomainID = @s_a_DomainID
	 ORDER BY 
		 ServiceType 
 END
	

	
END
