CREATE PROCEDURE [dbo].[Test5]
as
begin
select  top 5000
tblcase.Case_Id as [Case Id], 
[dbo].[fncGetAccountNumber](tblcase.Case_Id) as [Account Number],
InjuredParty_LastName + ', ' + InjuredParty_FirstName as [InjuredParty Name],  
Provider_Name + ISNULL(' [ ' + Provider_Groupname + ' ]','') as [Provider Name],  
InsuranceCompany_Name as [InsuranceCompany Name],
Ins_Claim_Number as [Claim Number], 
convert (varchar(10),convert(datetime,tblcase.DateOfService_Start),101) as [DOS Start],
convert (varchar(10),convert(datetime,tblcase.DateOfService_End),101) as [DOS End],
convert(varchar, Date_Opened,101)as [Date Opened],
tblcase.Claim_Amount as [Claim Amount],
tblcase.paid_amount as [Paid Amount],
(convert(float,tblcase.Claim_Amount)-convert(float,tblcase.paid_amount))as [Balance],
Status,  
sum(isnull(Settlement_Amount,0.00)) as [Settlement Amount],
sum(isnull(Settlement_AF,0.00)) as [Attorney Fee],
sum(isnull(Settlement_FF,0.00)) as [Filing Fee],
sum(isnull(Settlement_Int,0.00)) as [Settlement Int],
max(Settlement_Date) as [Settlement Date],
case when (convert(float,(isnull(tblcase.Claim_Amount,0.00)))-convert(float,(isnull(tblcase.Paid_Amount,0.00))))<>  0.00 
Then convert(numeric(18,2),((sum(isnull(Settlement_Amount,0.00))+sum(isnull(Settlement_Int,0.00)))*100)/
(convert(float,(isnull(tblcase.Claim_Amount,0.00)))-convert(float,(isnull(tblcase.Paid_Amount,0.00))))) 
else '0.00' end as [Set Per]
From tblcase left outer join tblprovider on tblcase.provider_id=tblprovider.provider_id 
left outer join tblinsurancecompany on tblcase.insurancecompany_id=tblinsurancecompany.insurancecompany_id
left outer join tblTreatment on tblcase.Case_Id = tblTreatment .Case_Id
left outer join tblsettlements on tblsettlements.case_id = tblcase.case_id
WHERE 1=1 AND tblcase.Provider_Id in (select Provider_id from tblprovider where Provider_GroupName = 'NSLIJ')
group by case_autoid,location_id,tblcase.Initial_Status,TBLCASE.CASE_ID,tblcase.Last_Status,tblprovider.Provider_GroupName,TBLPROVIDER.Provider_Name,INJUREDPARTY_FIRSTNAME,INJUREDPARTY_LASTNAME,InsuranceCompany_Name,Accident_Date,Policy_Number,Ins_Claim_Number,TBLCASE.Claim_Amount,TBLCASE.Paid_Amount,TBLCASE.Status,TBLCASE.Date_Opened,DATE_STATUS_CHANGED,account_number,tblcase.IndexOrAAA_Number,tblcase.DateOfService_Start,tblcase.DateOfService_End
order by case_autoid desc
End

