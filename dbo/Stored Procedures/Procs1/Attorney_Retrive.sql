
CREATE PROCEDURE [dbo].[Attorney_Retrive] -- [Attorney_Retrive] 0,'localhost'
(
	@i_a_Attorney_Id		INT = 0,
	@s_a_DomainID		VARCHAR(50)
)
AS        
BEGIN  
    SELECT 
			Attorney_AutoId
			, Attorney_Id	
			, Attorney_LastName
			, Attorney_FirstName
			, A.Defendant_Id
			, Defendant_Name
			, Attorney_Address
			, Attorney_City
			, Attorney_State
			, Attorney_Zip
			, Attorney_Phone
			--, Attorney_Extension
			, Attorney_Fax
			, Attorney_Email	
			-- , ISNULL(active,'1') AS IsActive
			, A.DomainID			
			, A.created_by_user	
			, CONVERT(VARCHAR(10), A.created_date, 101) AS created_date
			, A.modified_by_user	
			, CONVERT(VARCHAR(10), A.modified_date, 101) AS modified_date
	 FROM
		 tblAttorney  A
	 LEFT OUTER JOIN tblDefendant I ON A.Defendant_Id =  I.Defendant_Id and I.DomainId = @s_a_DomainID
     WHERE 
		A.DomainID = @s_a_DomainID
		AND (@i_a_Attorney_Id = 0 OR Attorney_AutoId = @i_a_Attorney_Id)
	 ORDER BY 
		 Attorney_LastName, Attorney_FirstName 		
END
