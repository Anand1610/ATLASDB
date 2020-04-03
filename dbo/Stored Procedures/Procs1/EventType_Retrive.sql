

CREATE PROCEDURE [dbo].[EventType_Retrive]
(
	@i_a_EventTypeId INT = 0,
	@s_a_DomainID VARCHAR(50)
)
AS        
BEGIN  

 IF(@i_a_EventTypeId = 0)
 BEGIN
    SELECT 
		  EventTypeId	
		, EventTypeName	
		, created_by_user	
		, CONVERT(VARCHAR(10), created_date, 101) AS created_date
		, modified_by_user	
		, CONVERT(VARCHAR(10), modified_date, 101) AS modified_date
	 FROM
		 tblEventType	

     WHERE 
		DomainID = @s_a_DomainID
	 ORDER BY 
		 EventTypeName 	
 END
ELSE
 BEGIN
	SELECT 
		EventTypeId
		, EventTypeName	
		, created_by_user	
		, CONVERT(VARCHAR(10), created_date, 101) AS created_date
		, modified_by_user	
		, CONVERT(VARCHAR(10), modified_date, 101) AS modified_date
	 FROM
		  tblEventType			
	 WHERE
		 EventTypeId = @i_a_EventTypeId
		 and DomainID = @s_a_DomainID
	 ORDER BY 
		 EventTypeName 
 END

END
