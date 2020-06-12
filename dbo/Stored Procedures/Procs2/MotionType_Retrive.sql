CREATE PROCEDURE [dbo].[MotionType_Retrive]
(
	@i_a_MotionType_Id INT = 0,
	@s_a_DomainId VARCHAR(50)
)
AS        
BEGIN  

 IF(@i_a_MotionType_Id = 0)
 BEGIN
    SELECT 
		MotionTypeId	
		, Name as MotionType	
		, created_by_user	
		, CONVERT(VARCHAR(10), created_date, 101) AS created_date
		, modified_by_user	
		, CONVERT(VARCHAR(10), modified_date, 101) AS modified_date



	 FROM
		 tblMotionType  		
     WHERE 
		DomainId = @s_a_DomainId
	 ORDER BY 
		 MotionType 	
 END
 ELSE
 BEGIN
	SELECT 
		MotionTypeId	
		, Name as MotionType	
		, created_by_user	
		, CONVERT(VARCHAR(10), created_date, 101) AS created_date
		, modified_by_user	
		, CONVERT(VARCHAR(10), modified_date, 101) AS modified_date
	 FROM
		 tblMotionType  		
	 WHERE
		 MotionTypeId = @i_a_MotionType_Id
		 and DomainId = @s_a_DomainId
	 ORDER BY 
		  MotionType
 END	
END