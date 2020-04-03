

CREATE PROCEDURE [dbo].[Attorney_Master_Retrive] -- [Attorney_Master_Retrive] 0,'localhost'
(
	@i_a_Attorney_Id		INT = 0,
	@s_a_DomainID		VARCHAR(50)
)
AS        
BEGIN  
    SELECT 
			
			Attorney_Id	
			, Attorney_LastName
			, Attorney_FirstName
			, LawFirmName
			, I.Attorney_Type_ID 
			, I.Attorney_Type
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
			, Isnull(IsOutsideAttorney,0) As IsOutsideAttorney
			, iif(Isnull(IsOutsideAttorney,0) = 0, 'No', 'Yes') AS OutsideAttorney
			, ISNULL(Attorney_BAR_Number,'') As Attorney_BAR_Number
	 FROM
		 tblAttorney_Master  A
	 INNER JOIN tblAttorney_Type I ON A.Attorney_Type_ID =  I.Attorney_Type_ID and A.DomainId = @s_a_DomainID
     WHERE 
		A.DomainID = @s_a_DomainID
		
	 ORDER BY 
		 Attorney_LastName ,Attorney_FirstName ASC	
END

