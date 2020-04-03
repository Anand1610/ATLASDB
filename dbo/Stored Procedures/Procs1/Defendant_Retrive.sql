
CREATE PROCEDURE [dbo].[Defendant_Retrive]
(
	@i_a_Defendant_Id		INT = 0,
	@s_a_DomainID		VARCHAR(50)
)
AS        
BEGIN  
    SELECT 
			Defendant_Id	
			, Defendant_Name
			, Defendant_DisplayName
			, Defendant_Address
			, Defendant_City
			, Defendant_State
			, Defendant_Zip
			, Defendant_Phone
			, Defendant_Fax
			, Defendant_Email	
			, ISNULL(active,'1') AS IsActive
			, DomainID			
			, created_by_user	
			, CONVERT(VARCHAR(10), created_date, 101) AS created_date
			, modified_by_user	
			, CONVERT(VARCHAR(10), modified_date, 101) AS modified_date
			,lawfirmname
	 FROM
		 tblDefendant  		
     WHERE 
		DomainID = @s_a_DomainID
		AND (@i_a_Defendant_Id = 0 OR Defendant_Id = @i_a_Defendant_Id)
	 ORDER BY 
		 Defendant_Name 	
 

	
END
