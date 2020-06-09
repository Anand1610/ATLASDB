/*  Created by : atul jDescription : New Date: 6/8/2020Last Change By: atul j*/

create VIEW [dbo].[SJR_Filed_Case_report]
AS
SELECT  DISTINCT  tblcase.Case_Id AS [Case ID],tblcase.InjuredParty_LastName + N', ' +tblcase.InjuredParty_FirstName AS Claimant, 
                     tblProvider.Provider_Name AS Provider,tblInsuranceCompany.InsuranceCompany_Name AS [Ins Company], CONVERT(money, 
                     tblcase.Claim_Amount) - CONVERT(money,tblcase.Paid_Amount) AS Balance,tblcase.IndexOrAAA_Number AS [Index],tblcase.Status, 
                      CONVERT(varchar(12),tblcase.DateOfService_Start, 110) + ' - ' + CONVERT(varchar(12),tblcase.DateOfService_End, 110) AS DOS, 
                     tblcase.Ins_Claim_Number AS Claim#,tblcase.Date_Opened,tblcase.Case_Code,tblcase.Initial_Status,tblcase.Provider_Id, 
                      SUM(CONVERT(MONEY,tblcase.Claim_Amount)) AS Claim_Amount, SUM(CONVERT(MONEY,tblcase.Paid_Amount)) AS Paid_Amount, 
					  SUM(CONVERT(MONEY,tblcase.Fee_Schedule)) AS Fee_Schedule, 
                     tblcase.InjuredParty_LastName + N', ' +tblcase.InjuredParty_FirstName AS InjuredParty_Name,tblcase.Accident_Date,tblcase.domainid,
					 tblcase.Date_aaa_arb_filed 
FROM        tblcase as tblcase INNER JOIN
                     tblInsuranceCompany as tblInsuranceCompany ON tblcase.InsuranceCompany_Id =tblInsuranceCompany.InsuranceCompany_Id and tblcase.DomainId =  tblInsuranceCompany.DomainId  
					 INNER JOIN tblProvider as tblProvider ON tblcase.Provider_Id =tblProvider.Provider_Id and tblcase.DomainId = tblProvider.DomainId

GROUP BY tblcase.Case_Id, CONVERT(money,tblcase.Claim_Amount) - CONVERT(money,tblcase.Paid_Amount), 
                     tblInsuranceCompany.InsuranceCompany_Name,tblcase.InjuredParty_LastName + N', ' +tblcase.InjuredParty_FirstName, 
                     tblcase.IndexOrAAA_Number,tblcase.Status, CONVERT(varchar(12),tblcase.DateOfService_Start, 110) + ' - ' + CONVERT(varchar(12), 
                     tblcase.DateOfService_End, 110),tblcase.Ins_Claim_Number,tblProvider.Provider_Name,tblcase.Date_Opened, 
                     tblcase.Case_Code,tblcase.Initial_Status,tblcase.Provider_Id,tblcase.Accident_Date,tblcase.Fee_Schedule,tblcase.domainid
					 ,tblcase.Date_aaa_arb_filed ,tblcase.Date_Index_Number_Purchased




