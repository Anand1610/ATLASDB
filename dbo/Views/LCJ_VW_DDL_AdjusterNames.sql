

CREATE VIEW [dbo].[LCJ_VW_DDL_AdjusterNames]
AS
SELECT     ISNULL(dbo.tblAdjusters.Adjuster_FirstName, N'') + N'  ' + ISNULL(dbo.tblAdjusters.Adjuster_LastName, N'') AS Adjuster_Name, 
                      dbo.tblAdjusters.Adjuster_Id, dbo.tblAdjusters.Adjuster_Phone, dbo.tblInsuranceCompany.InsuranceCompany_Name, 
                      ISNULL(dbo.tblInsuranceCompany.InsuranceCompany_Local_Phone, 'N/A') AS InsuranceCompany_Local_Phone, tblAdjusters.DomainId
FROM         dbo.tblAdjusters LEFT OUTER JOIN
                      dbo.tblInsuranceCompany ON dbo.tblAdjusters.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id
