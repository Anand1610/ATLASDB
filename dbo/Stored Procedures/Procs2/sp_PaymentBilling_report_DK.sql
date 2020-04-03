CREATE proc sp_PaymentBilling_report_DK  
  
As  
Begin  
  
select distinct c.Case_id ,   
prov.Provider_Name[Provider],  
ins.insurancecompany_name[Insurance],  
InjuredParty_FirstName ,  
InjuredParty_LastName,  
Status,  
Initial_Status,  
c.Date_Status_Changed,  
c.gb_case_id,  
CONVERT(VARCHAR,DateOfService_Start,101) AS DOS_START,  
CONVERT(VARCHAR,DateOfService_End,101) AS DOS_END,  
convert(varchar,Date_Opened,101)[Date Opened],  
convert(varchar,Accident_Date,101) [Date of accident],  
dbo.fncGetBillNumber(c.case_id) AS bill_number,  
dbo.fncGetDenialReasons(c.Case_id) AS DenialReason,  
c.Claim_Amount[Claim Amount],  
c.Paid_Amount[Paid Amount],  
(convert(decimal(38,2),c.Claim_Amount)-convert(decimal(38,2),c.Paid_Amount))[Claim Balance],  
c.Fee_Schedule[Fee Schedule],  
c.Fee_Schedule-c.Paid_Amount[Fee Schedule Balance],  
  
STUFF((SELECT ',  ' + CONVERT(VARCHAR,ChequeNo) FROM dbo.tblTransactions tre  
WHERE Case_ID = c.Case_Id  
and year(Transactions_Date)= (select datepart(YEAR,CAST(DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1) as DATE)))  
AND month(Transactions_Date)= (select datepart(MONTH,CAST(DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1) as DATE))) --and tre.DomainID = cas.DomainID  
FOR XML PATH('')), 1, 1, '') [Cheque#],  
  
STUFF((SELECT ', ' + CONVERT(VARCHAR,Transactions_Date) FROM dbo.tblTransactions tre  
WHERE Case_ID = c.Case_Id   
and year(Transactions_Date)= (select datepart(YEAR,CAST(DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1) as DATE)))  
AND month(Transactions_Date)= (select datepart(MONTH,CAST(DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1) as DATE)))--and tre.DomainID = cas.DomainID  
FOR XML PATH('')), 1, 1, '') [Transactions_Date],  
  
STUFF((SELECT ', ' + CONVERT(VARCHAR,Transactions_Type) FROM dbo.tblTransactions tre  
WHERE Case_ID = c.Case_Id --and tre.DomainID = cas.DomainID  
FOR XML PATH('')), 1, 1, '') [Transactions_Type],  
  
  
(select sum(Transactions_Amount) from tblTransactions tt where tt.Transactions_Type = 'PreC'   
and tt.Case_Id=c.Case_Id  
and year(Transactions_Date)= (select datepart(YEAR,CAST(DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1) as DATE)))  
AND month(Transactions_Date)= (select datepart(MONTH,CAST(DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1) as DATE)))) AS [Total PreC Transactions_Amount],  
  
(select sum(Transactions_Amount) from tblTransactions tt where tt.Transactions_Type = 'I'  
and tt.Case_Id=c.Case_Id  
and year(Transactions_Date)= (select datepart(YEAR,CAST(DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1) as DATE)))  
AND month(Transactions_Date)= (select datepart(MONTH,CAST(DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1) as DATE)))) AS [Total Intrest Transactions_Amount]  
  
from tblcase c   
inner join tblprovider prov (NOLOCK) on c.provider_id=prov.provider_id  
inner join tblinsurancecompany ins (NOLOCK) on ins.insurancecompany_id=c.insurancecompany_id  
left join tblCourt ct (NOLOCK) on ct.court_id=c.court_id  
left join tblsettlements s (NOLOCK) on s.Case_Id=c.case_id  
left join tblTransactions t (NOLOCK) on t.Case_Id=c.case_id  
where c.case_id in   
(SELECT Distinct case_id FRom tblTransactions where (Transactions_Type like '%PreC%')   
and year(Transactions_Date)= (select datepart(YEAR,CAST(DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1) as DATE)))  
AND month(Transactions_Date)= (select datepart(MONTH,CAST(DATEADD(MONTH, DATEDIFF(MONTH, -1, GETDATE())-1, -1) as DATE))))  
--(SELECT Distinct case_id FRom tblNotes where (notes_desc like '%(PreC)%' )   
--and year([Notes_Date])= 2019 AND month([Notes_Date])= 01)  
  
and (Provider_Name like '%RF Chiro%'  
or Provider_Name like '%Hamid Lalani%'  
or Provider_Name like '%Comfort%'  
or Provider_Name like '%Manhattan%'  
or Provider_Name like '%Mill%'  
or Provider_Name like '%NYC Care%'  
or Provider_Name like '%S&K Warbasse Pharmacy%'  
or Provider_Name like '%Inje%'
or Provider_Name like '%Crosstown Chiro%')  
--and c.case_id ='DK18-52103'  
order by Provider  
  
  
End  
  