CREATE FUNCTION [dbo].[FUNC_COLLECTIONS_REPORT] 
(	

	
)
RETURNS TABLE 
AS
RETURN 
(



SELECT     Case_Id, Case_Code, InjuredParty_Name, Provider_Name, InsuranceCompany_Name, Balance, [Index], Status, Initial_Status, GLOBAL_STATUS, DOS, 
                      Claim#, BALANCE_SETT, BALANCE_AF, BALANCE_FF, MAX_SETT_DATE, DATEDIFF(d, MAX_SETT_DATE, GETDATE()) AS AGING, SETTLED_BY
FROM         [SJR-Case_report_Extended]
where status in ('aaa collection','collection')


	/*SELECT     dbo.tblcase.Case_Id, dbo.tblcase.Case_Code, dbo.tblcase.InjuredParty_LastName + N',' + dbo.tblcase.InjuredParty_FirstName AS Claimant, 
                      dbo.tblProvider.Provider_Name AS Provider, dbo.tblInsuranceCompany.InsuranceCompany_Name AS Insurance, 
                      ISNULL(dbo.[SJR-SETTLEMENTS_FULL].Sett_tot, 0) AS [Sett Tot], ISNULL(dbo.[SJR-SETTLED_PAYMENTS_FULL].Payments, 0) AS Payments, 
                      ISNULL(dbo.[SJR-SETTLEMENTS_FULL].Sett_tot, 0) - ISNULL(dbo.[SJR-SETTLED_PAYMENTS_FULL].Payments, 0) AS Balance, 
                      dbo.[SJR-SETTLEMENTS_FULL].Settl_date, CONVERT(int, GETDATE() - dbo.[SJR-SETTLEMENTS_FULL].Settl_date) AS Aging, CONVERT(int, 
                      dbo.[SJR-SETTLED_PAYMENTS_FULL].Max_Date - dbo.[SJR-SETTLED_PAYMENTS_FULL].Min_Date) AS [Pay spread], CONVERT(int, 
                      dbo.[SJR-SETTLED_PAYMENTS_FULL].Min_Date - dbo.[SJR-SETTLEMENTS_FULL].Settl_date) AS [Min delay], CONVERT(int, 
                      dbo.[SJR-SETTLED_PAYMENTS_FULL].Max_Date - dbo.[SJR-SETTLEMENTS_FULL].Settl_date) AS [Max delay], CONVERT(int, GETDATE() 
                      - dbo.[SJR-SETTLED_PAYMENTS_FULL].Max_Date) AS [Idle time], dbo.tblcase.Status, dbo.tblcase.Ins_Claim_Number AS Claim#, 
                      dbo.tblcase.IndexOrAAA_Number AS [Index]
FROM         dbo.tblInsuranceCompany INNER JOIN
                      dbo.tblcase ON dbo.tblInsuranceCompany.InsuranceCompany_Id = dbo.tblcase.InsuranceCompany_Id INNER JOIN
                      dbo.tblProvider ON dbo.tblcase.Provider_Id = dbo.tblProvider.Provider_Id INNER JOIN
                      dbo.[SJR-SETTLEMENTS_FULL] ON dbo.tblcase.Case_Id = dbo.[SJR-SETTLEMENTS_FULL].Case_Id LEFT OUTER JOIN
                      dbo.[SJR-SETTLED_PAYMENTS_FULL] ON dbo.[SJR-SETTLEMENTS_FULL].Case_Id = dbo.[SJR-SETTLED_PAYMENTS_FULL].Case_Id
WHERE     (CONVERT(int, GETDATE() - dbo.[SJR-SETTLEMENTS_FULL].Settl_date) > 46) AND (dbo.tblcase.Status = N'SETTLED' OR
                      dbo.tblcase.Status = N'PAID' OR
                      dbo.tblcase.Status = N'PAYMENT DISBURSED' OR
                      dbo.tblcase.Status = N'COLLECTION') AND (ISNULL(dbo.[SJR-SETTLEMENTS_FULL].Sett_tot, 0) 
                      - ISNULL(dbo.[SJR-SETTLED_PAYMENTS_FULL].Payments, 0) > 20)AND dbo.[SJR-SETTLEMENTS_FULL].Settl_date > @START_DATE*/

)
