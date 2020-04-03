CREATE PROCEDURE [dbo].[F_DDL_Adjuster_For_Settlements]
	
AS
BEGIN

	SET NOCOUNT ON;
	SELECT '0' Adjuster_Id,' ---Select Adjusters--- ' AS Adjuster_Name_Details
	UNION
	SELECT Adjuster_Id,
	LTRIM(RTRIM(Upper(ISNULL(dbo.tblAdjusters.Adjuster_FirstName, N'') + N'  ' + ISNULL(dbo.tblAdjusters.Adjuster_LastName, N'')+ ' =>' + '[Adj.Ph#: ' +Adjuster_Phone +' / ' 
	+ 'Ins.Cpy: ' + ISNULL(InsuranceCompany_Name, '')+ ' / ' + 'Ins.Cpy.Ph#: ' + ISNULL(InsuranceCompany_Local_Phone,N'') + ']' )))AS Adjuster_Name_Details
	FROM dbo.tblAdjusters 
	LEFT OUTER JOIN
        dbo.tblInsuranceCompany ON dbo.tblAdjusters.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id
     WHERE 
		Adjuster_Id <> 0
	ORDER BY Adjuster_Name_Details

	
	SET NOCOUNT OFF ; 

END

