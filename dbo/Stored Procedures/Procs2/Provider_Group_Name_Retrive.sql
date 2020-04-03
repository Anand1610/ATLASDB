CREATE PROCEDURE [dbo].[Provider_Group_Name_Retrive]
(
	@i_a_Provider_Group_ID INT = 0,
	@s_a_DomainID VARCHAR(50)
)
AS        
BEGIN  


    SELECT 
		Provider_Group_ID	
		, Provider_Group_Name
		, ISNULL(DESCRIPTION,'') AS DESCRIPTION
		, DomainID
		, SD_CODE
		, ISNULL(Email_For_Arb_Awards,'') AS Email_For_Arb_Awards
		, ISNULL(Email_For_Invoices,'') AS Email_For_Invoices
		, ISNULL(Email_For_Closing_Reports,'') AS Email_For_Closing_Reports
		, ISNULL(Email_For_Monthly_Report,'') AS Email_For_Monthly_Report
		, created_by_user	
		, CONVERT(VARCHAR(10), created_date, 101) AS created_date
		, modified_by_user	
		, CONVERT(VARCHAR(10), modified_date, 101) AS modified_date
	 FROM
		 TblProvider_Groups 		
     WHERE 
		DomainID = @s_a_DomainID
		AND (@i_a_Provider_Group_ID = 0 OR Provider_Group_ID = @i_a_Provider_Group_ID)
	 ORDER BY 
		 Provider_Group_Name 	

END
