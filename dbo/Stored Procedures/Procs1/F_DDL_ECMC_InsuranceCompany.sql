CREATE PROCEDURE [dbo].[F_DDL_ECMC_InsuranceCompany]  
	
AS
BEGIN

	SET NOCOUNT ON;
	
	SELECT ' ---SELECT Insurance Company--- ' AS Insurance
	UNION
	SELECT DISTINCT Insurance  FROM ECMC WHERE Insurance not like '%SELECT%'
	UNION
	SELECT Distinct InsuranceCompany_Name from tblinsurancecompany
	
	SET NOCOUNT OFF ;



END

