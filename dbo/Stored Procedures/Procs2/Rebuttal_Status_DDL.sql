CREATE PROCEDURE [dbo].[Rebuttal_Status_DDL] -- [Rebuttal_Status_DDL] 'localhost'
(
	@DomainID VARCHAR(50)
)
AS        
BEGIN  

	
	SELECT 
		'0' AS Rebuttal_Status_ID	
		, '' AS Rebuttal_Status_Value	
		, '  ---Select Rebuttal Status---  ' AS Rebuttal_Status	
	
	UNION 
    SELECT 
		PK_Rebuttal_Status_ID	AS Rebuttal_Status_ID	
		, Rebuttal_Status AS Rebuttal_Status_Value	
		, Rebuttal_Status	
	 FROM
		 Rebuttal_Status  	WITH(NOLOCK)	
     WHERE 
		DomainID = @DomainID
	 ORDER BY 
		 Rebuttal_Status 	
		 	
END
