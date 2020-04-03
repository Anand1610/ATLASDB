CREATE VIEW [dbo].[SJR-Case_report_Extended]
AS
SELECT     dbo.tblcase.Case_AutoId, dbo.tblcase.Case_Id, dbo.tblcase.Case_Code, 
                      dbo.tblcase.InjuredParty_LastName + N', ' + dbo.tblcase.InjuredParty_FirstName AS InjuredParty_Name, REPLACE(dbo.tblProvider.Provider_Name, '--', '##') 
                      AS Provider_Name, dbo.tblProvider.Provider_GroupName, dbo.tblInsuranceCompany.InsuranceCompany_Name, ISNULL(CONVERT(money, 
                      dbo.tblcase.Claim_Amount), 0) - ISNULL(CONVERT(money, dbo.tblcase.Paid_Amount), 0) AS Balance, dbo.tblcase.IndexOrAAA_Number AS [Index], dbo.tblcase.Status, 
                      dbo.tblcase.Initial_Status, CASE WHEN TBLCASE.STATUS LIKE '%CLOSED%' OR
                      TBLCASE.STATUS LIKE '%PAID%' THEN 'CLOSED' WHEN TBLCASE.STATUS LIKE '%WITHDRAWN%' THEN 'WITHDRAWN' ELSE 'ACTIVE' END AS GLOBAL_STATUS, 
                      ISNULL(CONVERT(varchar(12), dbo.tblcase.DateOfService_Start, 110) + ' - ' + CONVERT(varchar(12), dbo.tblcase.DateOfService_End, 110), N'-') AS DOS, 
                      dbo.tblcase.Ins_Claim_Number AS Claim#, dbo.tblcase.Policy_Number, dbo.tblcase.Date_Opened, dbo.tblStatus.Status_Hierarchy, dbo.tblcase.Provider_Id, 
                      dbo.tblcase.InsuranceCompany_Id, dbo.tblcase.IndexOrAAA_Number, SUM(ISNULL(CONVERT(money, dbo.tblcase.Claim_Amount), 0)) AS Claim_Amount, 
                      SUM(ISNULL(CONVERT(money, dbo.tblcase.Paid_Amount), 0)) AS Paid_Amount, 
                      SUM(ISNULL(dbo.[SJR-SETTLEMENTS_FULL].Settlement_Amount + dbo.[SJR-SETTLEMENTS_FULL].Settlement_Int, 0)) AS Settlement_total, 
                      SUM(ISNULL(dbo.[SJR-SETTLEMENTS_FULL].Settlement_Af, 0)) AS Settlement_AF, SUM(ISNULL(dbo.[SJR-SETTLEMENTS_FULL].Settlement_Ff, 0)) AS Settlement_FF, 
                      SUM(ISNULL(dbo.[SJR-SETTLED_PAYMENTS_FULL].Payments, 0)) AS Settlement_Payments, 
                      SUM(ISNULL(dbo.[SJR-SETTLEMENTS_FULL].Settlement_Amount + dbo.[SJR-SETTLEMENTS_FULL].Settlement_Int + dbo.[SJR-SETTLEMENTS_FULL].Settlement_Af + dbo.[SJR-SETTLEMENTS_FULL].Settlement_Ff,
                       ISNULL(CONVERT(money, dbo.tblcase.Claim_Amount), 0) - ISNULL(CONVERT(money, dbo.tblcase.Paid_Amount), 0)) 
                      - ISNULL(dbo.[SJR-SETTLED_PAYMENTS_FULL].Payments, 0)) AS Settlement_balance, dbo.tblDefendant.Defendant_Name, dbo.tblCourt.Court_Misc AS County, 
                      dbo.tblcase.Served_On_Date, dbo.tblcase.Accident_Date, dbo.tblCase_Date_Details.Date_Answer_Received, SUM(ISNULL(dbo.[SJR-SETTLED_PAYMENTS_FULL].PRINC, 0) 
                      + ISNULL(dbo.[SJR-SETTLED_PAYMENTS_FULL].INT, 0)) AS PROVIDER_PAYMENT, 
                      SUM(ISNULL(dbo.[SJR-SETTLEMENTS_FULL].Settlement_Amount + dbo.[SJR-SETTLEMENTS_FULL].Settlement_Int, ISNULL(CONVERT(money, 
                      dbo.tblcase.Claim_Amount), 0) - ISNULL(CONVERT(money, dbo.tblcase.Paid_Amount), 0)) - ISNULL(dbo.[SJR-SETTLED_PAYMENTS_FULL].PRINC, 0) 
                      - ISNULL(dbo.[SJR-SETTLED_PAYMENTS_FULL].INT, 0)) AS PROVIDER_BALANCE, MAX(dbo.[SJR-SETTLEMENTS_FULL].Settl_date) AS MAX_SETT_DATE, 
                      dbo.[SJR-SETTLED_PAYMENTS_FULL].Max_Date AS MAX_PAY_DATE, dbo.tblProvider.Provider_Billing, dbo.[SJR-SETTLEMENTS_FULL].Settlement_Batch, 
                      SUM(ISNULL(dbo.[SJR-SETTLED_PAYMENTS_FULL].PRINC, 0) + ISNULL(dbo.[SJR-SETTLED_PAYMENTS_FULL].INT, 0)) AS PAYMENT_SETT, 
                      SUM(ISNULL(dbo.[SJR-SETTLED_PAYMENTS_FULL].AF, 0)) AS PAYMENT_AF, SUM(ISNULL(dbo.[SJR-SETTLED_PAYMENTS_FULL].FFC, 0)) AS PAYMENT_FF, 
                      SUM(ISNULL(dbo.[SJR-SETTLEMENTS_FULL].Settlement_Amount + dbo.[SJR-SETTLEMENTS_FULL].Settlement_Int, 0) 
                      - (ISNULL(dbo.[SJR-SETTLED_PAYMENTS_FULL].PRINC, 0) + ISNULL(dbo.[SJR-SETTLED_PAYMENTS_FULL].INT, 0))) AS BALANCE_SETT, 
                      SUM(ISNULL(dbo.[SJR-SETTLEMENTS_FULL].Settlement_Af, 0) - ISNULL(dbo.[SJR-SETTLED_PAYMENTS_FULL].AF, 0)) AS BALANCE_AF, 
                      SUM(ISNULL(dbo.[SJR-SETTLEMENTS_FULL].Settlement_Ff, 0) - ISNULL(dbo.[SJR-SETTLED_PAYMENTS_FULL].FFC, 0)) AS BALANCE_FF, 
                      dbo.[SJR-SETTLEMENTS_FULL].Settlement_SubBatch, dbo.[SJR-SETTLEMENTS_FULL].User_Id AS SETTLED_BY, dbo.[SJR-SETTLEMENTS_FULL].COA, 
                      CASE WHEN (ISNULL(CONVERT(money, dbo.tblcase.Claim_Amount), 0) - ISNULL(CONVERT(money, dbo.tblcase.Paid_Amount), 0)) 
                      = 0 THEN '-1' ELSE SUM(ISNULL(dbo.[SJR-SETTLEMENTS_FULL].Settlement_Amount + dbo.[SJR-SETTLEMENTS_FULL].Settlement_Int, 0)) / (ISNULL(CONVERT(money,
                       dbo.tblcase.Claim_Amount), 0) - ISNULL(CONVERT(money, dbo.tblcase.Paid_Amount), 0)) END AS SETT_RATIO, dbo.tblcase.Defendant_Id, 
                      dbo.tblProvider.Provider_Suitname,
                          (SELECT     COUNT(Treatment_Id) AS Expr1
                            FROM          dbo.tblTreatment
                            WHERE      (Case_Id = Case_Id)) AS Bills, dbo.tblcase.Last_Status, dbo.tblcase.Date_Status_Changed, dbo.tblcase.Date_Closed, 
                      dbo.tblcase.DateAAA_ResponceRecieved, dbo.tblcase.DateAAA_packagePrinting, dbo.tblcase.AAA_Confirmed_Date, dbo.tblcase.Date_AAA_Arb_Filed, 
                      dbo.tblcase.Date_AAA_Concilation_Over, ISNULL(dbo.tblcase.Fee_Schedule,0)AS Fee_Schedule
FROM         dbo.tblcase 
		LEFT OUTER JOIN dbo.tblProvider ON dbo.tblcase.Provider_Id = dbo.tblProvider.Provider_Id 
		LEFT OUTER JOIN dbo.tblInsuranceCompany ON dbo.tblcase.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id 
		LEFT OUTER JOIN dbo.tblStatus ON dbo.tblcase.Status = dbo.tblStatus.Status_Type and dbo.tblcase.DomainId = dbo.tblStatus.DomainId
		LEFT OUTER JOIN dbo.tblCourt ON dbo.tblcase.Court_Id = dbo.tblCourt.Court_Id 
		LEFT OUTER JOIN dbo.tblDefendant ON dbo.tblcase.Defendant_Id = dbo.tblDefendant.Defendant_id
		LEFT OUTER JOIN dbo.[SJR-SETTLED_PAYMENTS_FULL] ON dbo.tblcase.Case_Id = dbo.[SJR-SETTLED_PAYMENTS_FULL].Case_Id 
		LEFT OUTER JOIN dbo.[SJR-SETTLEMENTS_FULL] ON dbo.tblcase.Case_Id = dbo.[SJR-SETTLEMENTS_FULL].Case_Id
		LEFT OUTER JOIN dbo.tblCase_Date_Details ON tblcase.Case_Id = dbo.tblCase_Date_Details.Case_Id
WHERE tblcase.Case_id NOT IN (SELECT DISTINCT Packeted_Case_ID from Billing_Packet)
GROUP BY dbo.tblcase.Case_Id, ISNULL(CONVERT(money, dbo.tblcase.Claim_Amount), 0) - ISNULL(CONVERT(money, dbo.tblcase.Paid_Amount), 0), 
                      dbo.tblInsuranceCompany.InsuranceCompany_Name, dbo.tblcase.InjuredParty_LastName + N', ' + dbo.tblcase.InjuredParty_FirstName, 
                      dbo.tblcase.IndexOrAAA_Number, dbo.tblcase.Status, CONVERT(varchar(12), dbo.tblcase.DateOfService_Start, 110) + ' - ' + CONVERT(varchar(12), 
                      dbo.tblcase.DateOfService_End, 110), dbo.tblcase.Ins_Claim_Number, REPLACE(dbo.tblProvider.Provider_Name, '--', '##'), dbo.tblcase.Date_Opened, 
                      dbo.tblcase.Case_Code, dbo.tblcase.Initial_Status, dbo.tblcase.Provider_Id, dbo.tblcase.InsuranceCompany_Id, dbo.tblDefendant.Defendant_Name, 
                      dbo.tblCourt.Court_Misc, dbo.tblcase.Served_On_Date, dbo.tblProvider.Provider_GroupName, dbo.tblcase.Accident_Date, dbo.tblCase_Date_Details.Date_Answer_Received, 
                      dbo.tblcase.Policy_Number, dbo.tblProvider.Provider_Billing, dbo.[SJR-SETTLEMENTS_FULL].Settlement_Batch, 
                      dbo.[SJR-SETTLEMENTS_FULL].Settlement_SubBatch, dbo.[SJR-SETTLEMENTS_FULL].User_Id, dbo.[SJR-SETTLEMENTS_FULL].COA, 
                      dbo.[SJR-SETTLED_PAYMENTS_FULL].Max_Date, dbo.tblcase.Defendant_Id, dbo.tblcase.Case_AutoId, dbo.tblProvider.Provider_Suitname, 
                      dbo.tblStatus.Status_Hierarchy, dbo.tblcase.Last_Status, dbo.tblcase.Date_Status_Changed, dbo.tblcase.Date_Closed, dbo.tblcase.DateAAA_ResponceRecieved, 
                      dbo.tblcase.DateAAA_packagePrinting, dbo.tblcase.AAA_Confirmed_Date, dbo.tblcase.Date_AAA_Arb_Filed, dbo.tblcase.Date_AAA_Concilation_Over, 
                      dbo.tblcase.Fee_Schedule

