CREATE PROCEDURE [dbo].[InsuranceCompanyGroup_Retrive]
(
	@i_a_InsuranceCompanyGroup_ID INT = 0,
	@s_a_DomainID VARCHAR(50)
)
AS        
BEGIN  

 IF(@i_a_InsuranceCompanyGroup_ID = 0)
 BEGIN
    SELECT 
		  InsuranceCompanyGroup_ID	
		, InsuranceCompanyGroup_Name	
		, created_by_user	
		, CONVERT(VARCHAR(10), created_date, 101) AS created_date
		, modified_by_user	
		, CONVERT(VARCHAR(10), modified_date, 101) AS modified_date
	 FROM
		 tblInsuranceCompanyGroup	

     WHERE 
		DomainId = @s_a_DomainID
	 ORDER BY 
		 InsuranceCompanyGroup_Name 	
 END
ELSE
 BEGIN
	SELECT 
		InsuranceCompanyGroup_ID
		, InsuranceCompanyGroup_Name	
		, created_by_user	
		, CONVERT(VARCHAR(10), created_date, 101) AS created_date
		, modified_by_user	
		, CONVERT(VARCHAR(10), modified_date, 101) AS modified_date
	 FROM
		  tblInsuranceCompanyGroup			
	 WHERE
		 InsuranceCompanyGroup_ID = @i_a_InsuranceCompanyGroup_ID
		 and DomainID = @s_a_DomainID
	 ORDER BY 
		 InsuranceCompanyGroup_Name 
 END

END
