
CREATE PROCEDURE [dbo].[Assigned_Attorney_Retrive] -- [Assigned_Attorney_Retrive] 0,'localhost'
(
	@i_a_Assigned_Attorney_Id INT = 0,
	@s_a_DomainID VARCHAR(50)
)
AS        
BEGIN  

 IF(@i_a_Assigned_Attorney_Id = 0)
 BEGIN
    SELECT 
		PK_Assigned_Attorney_ID	
		,Assigned_Attorney	
		,Assigned_Attorney_Address
		,Assigned_Attorney_Phone
		,Assigned_Attorney_Fax
		,Assigned_Attorney_Email
		--,Assigned_Attorney_Extension

		, created_by_user	
		, CONVERT(VARCHAR(10), created_date, 101) AS created_date
		, modified_by_user	
		, CONVERT(VARCHAR(10), modified_date, 101) AS modified_date
		,LawFirm_Name
	 FROM
		 Assigned_Attorney  (NOLOCK)		
     WHERE 
		DomainID = @s_a_DomainID
	 ORDER BY 
		 Assigned_Attorney 	
 END
 ELSE
 BEGIN
	SELECT 
		PK_Assigned_Attorney_ID	
		, Assigned_Attorney	
		,Assigned_Attorney_Address
		,Assigned_Attorney_Phone
		,Assigned_Attorney_Fax
		,Assigned_Attorney_Email
		--,Assigned_Attorney_Extension
		, created_by_user	
		, CONVERT(VARCHAR(10), created_date, 101) AS created_date
		, modified_by_user	
		, CONVERT(VARCHAR(10), modified_date, 101) AS modified_date
	 FROM
		 Assigned_Attorney  		
	 WHERE
		 PK_Assigned_Attorney_ID = @i_a_Assigned_Attorney_Id
		 and DomainID = @s_a_DomainID
	 ORDER BY 
		 Assigned_Attorney 
 END
	

	
END
