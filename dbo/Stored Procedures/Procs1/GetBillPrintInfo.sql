CREATE PROCEDURE [dbo].[GetBillPrintInfo]--[GetBillPrintInfo] 'test','01/01/2018','09/09/2018','Date_Opened',''
(  
@DomainId NVARCHAR(50),
@dt1 varchar(50),  
@dt2 varchar(50),  
@printtype varchar(100),  
@status varchar(50)  
)  
as  
begin  
declare  
@st varchar(MAX)  
  
  set @st = 'select 
				CASE_ID,
				Injuredparty_name,
				Provider_name,
				Insurancecompany_name,
				Ins_Claim_Number,
				(select isnull(CONVERT(NVARCHAR(12),min(DateOfService_Start),101),'''') from tbltreatment where case_id=lcj_vw_casesearchdetails.case_id) as DOS_Start, 
				(select isnull(CONVERT(NVARCHAR(12),max(DateOfService_End),101),'''') from tbltreatment where case_id=lcj_vw_casesearchdetails.case_id) as DOS_End, 
				ISNULL(CONVERT(NVARCHAR(12),Accident_Date,101),'''') as Accident_Date, 
				isnull(claim_amount,0.00) as claim_amount,
				InsuranceCompany_Perm_Address As InsuranceCompany_Address,
				InsuranceCompany_Perm_City As InsuranceCompany_City,
				InsuranceCompany_Perm_State As InsuranceCompany_State,
				InsuranceCompany_Perm_Zip As InsuranceCompany_Zip
			from lcj_vw_casesearchdetails where domainid ='''+@DomainId+''' and 
			CAST(FLOOR(CAST(' + @printtype + ' AS FLOAT))AS DATETIME) >= Replace(''' + @dt1 + ''',''/'',''-'') and  
			CAST(FLOOR(CAST('+@printtype+' AS FLOAT))AS DATETIME) <= Replace(''' + @dt2+''',''/'',''-'') '  
  if @status <> '0'  
  set @st = @st + ' and status = ''' + @status + ''' order by case_id'  
  else  
  set @st = @st + '  order by case_id'  
  print @st  
  execute(@st)
end

