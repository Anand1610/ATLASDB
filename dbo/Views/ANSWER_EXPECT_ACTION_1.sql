
CREATE VIEW [dbo].[ANSWER_EXPECT_ACTION_1]
AS
SELECT     dbo.[SJR-ANSWER_EXPECT].Case_Id, dbo.[SJR-ANSWER_EXPECT].Case_Code, CASE WHEN ANS_EXPECT IS NULL THEN 'ERROR' WHEN GETDATE() 
                      BETWEEN ANS_EXPECT AND (ANS_EXPECT + 0) THEN 'LATE ANSWER' WHEN GETDATE() > (ANS_EXPECT + 0) THEN 'DEFAULT' WHEN GETDATE() 
                      < ANS_EXPECT THEN 'WAITING' END AS ACTION, dbo.[SJR-ANSWER_EXPECT].ANS_EXPECT, CONVERT(VARCHAR(4), 
                      YEAR(dbo.[SJR-ANSWER_EXPECT].ANS_EXPECT)) + '-' + CONVERT(VARCHAR(2), MONTH(dbo.[SJR-ANSWER_EXPECT].ANS_EXPECT)) AS MONTH, 
                      dbo.tblInsuranceCompany.InsuranceCompany_Name, dbo.tblProvider.Provider_Name, 
                      dbo.tblcase.InjuredParty_FirstName + N' ' + dbo.tblcase.InjuredParty_LastName AS Injured_Party, dbo.tblcase.Ins_Claim_Number, 
                      dbo.tblcase.IndexOrAAA_Number, dbo.[SJR-ANSWER_EXPECT].Served_On_Date, 
                      CASE WHEN dbo.[SJR-ANSWER_EXPECT].STATUS = 'ANSWER-RCVD-LATE' THEN 'RCVD' ELSE NULL END AS LAR
FROM         dbo.tblProvider INNER JOIN
                      dbo.tblcase ON dbo.tblProvider.Provider_Id = dbo.tblcase.Provider_Id INNER JOIN
                      dbo.tblInsuranceCompany ON dbo.tblcase.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id INNER JOIN
                      dbo.[SJR-ANSWER_EXPECT] ON dbo.tblcase.Case_Id = dbo.[SJR-ANSWER_EXPECT].Case_Id
