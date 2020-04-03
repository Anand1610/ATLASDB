CREATE PROCEDURE [dbo].[LCJ_DDL_DateFields]  
@DomainID VARCHAR(50) = ''
AS  
BEGIN  

	 SELECT   '0' AS Date_Field_Name,' ---SELECT--- ' AS Date_Field_Desc ,'' as DFN_TableFrom

	 UNION

	 SELECT   DISTINCT Date_Field_Name, Date_Field_Desc,Date_Field_Name+'-'+TableFrom as DFN_TableFrom  
	 FROM tblDateFields WITH(NOLOCK) 
	 --where DomainId=@DomainID
	 ORDER BY Date_Field_Desc

END

