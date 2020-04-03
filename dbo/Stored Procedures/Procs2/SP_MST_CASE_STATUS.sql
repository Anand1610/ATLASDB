CREATE PROCEDURE [dbo].[SP_MST_CASE_STATUS]    
@ID     NVARCHAR(20)=NULL,    
@FLAG    VARCHAR(50)     
AS    
BEGIN    
		IF @FLAG='CASESTATUS_LIST'    
		BEGIN     
			SELECT  Status_Type [CODE],      
					Status_Type [DESCRIPTION]     
			FROM tblStatus    
			ORDER BY Status_Type ASC
		END    
END

