CREATE PROCEDURE [dbo].[SP_MST_CASE_TYPE]  -- '' ,'CASESTATUS_LIST' 
@ID     NVARCHAR(20)=NULL,    
@FLAG    VARCHAR(50)     
AS
BEGIN    
		IF @FLAG='CASETYPE_LIST'    
		BEGIN     
			SELECT  ID [CODE],      
					Name [DESCRIPTION]     
			FROM tblCaseStatus    
			ORDER BY Name,ID ASC    
		END    
END

