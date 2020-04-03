CREATE PROCEDURE [dbo].[OperatingDoctor_Retrive]
(
	@i_a_Doctor_id INT = 0,
	@s_a_DomainID VARCHAR(50)
)
AS        
BEGIN  

 	SELECT 
		  Doctor_id	
		, Doctor_Name
		, Active	
		, created_by_user	
		, CONVERT(VARCHAR(10), created_date, 101) AS created_date
		, modified_by_user	
		, CONVERT(VARCHAR(10), modified_date, 101) AS modified_date
	 FROM
		 tblOperatingDoctor  		
	 WHERE
		  DomainID     = @s_a_DomainID 
		  AND (@i_a_Doctor_id = 0 or Doctor_id = @i_a_Doctor_id)
	 ORDER BY 
		 Doctor_Name 
 
		
END
