
CREATE PROCEDURE [dbo].[Adjuster_Retrive] -- [Adjuster_Retrive] 0,'localhost'
(
	@i_a_Adjuster_Id		INT = 0,
	@s_a_DomainID		VARCHAR(50)
)
AS        
BEGIN  
    SELECT 
			Adjuster_Id	
			, Adjuster_LastName
			, Adjuster_FirstName
			--, A.InsuranceCompany_Id
			--, InsuranceCompany_Name
			, Adjuster_Address
			, Adjuster_Phone
			, Adjuster_Extension
			, Adjuster_Fax
			, Adjuster_Email	
			-- , ISNULL(active,'1') AS IsActive
			, A.DomainID			
			, A.created_by_user	
			, CONVERT(VARCHAR(10), A.created_date, 101) AS created_date
			, modified_by_user	
			, CONVERT(VARCHAR(10), A.modified_date, 101) AS modified_date
	 FROM
		 tblAdjusters  A
	-- LEFT OUTER JOIN tblInsuranceCompany I ON A.InsuranceCompany_Id =  I.InsuranceCompany_Id and I.DomainId = @s_a_DomainID
     WHERE 
		A.DomainID = @s_a_DomainID
		AND (@i_a_Adjuster_Id = 0 OR Adjuster_Id = @i_a_Adjuster_Id)
	 ORDER BY 
		 Adjuster_LastName, Adjuster_FirstName 		
END
