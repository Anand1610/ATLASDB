  
CREATE PROCEDURE [dbo].[LCJ_DDL_ReviewingDoctor_Active]  
    (
	@DomainID NVARCHAR(50)
	)
AS  
BEGIN  
   
 SET NOCOUNT ON;  
 SELECT ' --- Select Reviewing Doctor --- '  as Doctor_Name, '0' Doctor_id  
 UNION  
 SELECT     Doctor_Name, Doctor_id  
 FROM         TblReviewingDoctor WHERE  Doctor_Name <>'' and Doctor_Name not like '%select%' and Active = 1  AND DomainId = @DomainID
 ORDER BY Doctor_name  
   
   
END

