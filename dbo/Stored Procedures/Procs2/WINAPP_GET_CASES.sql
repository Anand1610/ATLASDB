CREATE PROCEDURE [dbo].[WINAPP_GET_CASES] --'','','Raphael',''
@Case_Id                 nvarchar(50),  
@Status                    nvarchar(100),  
@InjuredParty_LastName     nvarchar(100),  
@InjuredParty_FirstName     nvarchar(100)
AS
BEGIN
	DECLARE @strsql as varchar(8000)
	set @strsql = 'select top 500 ROW_NUMBER() OVER (ORDER BY case_autoid) AS RowNumber,Case_Id, 
InjuredParty_LastName + '', '' + InjuredParty_FirstName as [InjuredParty_Name],  
Provider_Name + ISNULL('' [ '' + Provider_Groupname + '' ]'','''') as Provider_Name,  
InsuranceCompany_Name,  
Indexoraaa_number,  
convert(decimal(38,2),(convert(money,convert(float,Claim_Amount) - convert(float,Paid_Amount)))) as Claim_Amount,
Status,  
Ins_Claim_Number,
INITIAL_STATUS,
case_autoid
From tblcase left join tblprovider on tblcase.provider_id=tblprovider.provider_id 
left join tblinsurancecompany on tblcase.insurancecompany_id=tblinsurancecompany.insurancecompany_id
WHERE 1=1 '
  
if @Case_Id <> ''  
begin  
	set @strsql = @strsql + ' AND Case_Id Like ''%' + @Case_Id + '%'''               
end  
  
if @Status <> '' and @Status <> '0'  
begin  
	set @strsql = @strsql + '  AND STATUS = ''' + @Status + ''''         
end 
if @InjuredParty_LastName <> ''   
begin  
	set @strsql = @strsql + '  AND InjuredParty_LastName LIKE ''%' + @InjuredParty_LastName + '%'''
end

if @InjuredParty_FirstName <> ''   
begin  
	set @strsql = @strsql + '  AND InjuredParty_FirstName LIKE ''%' + @InjuredParty_FirstName + '%'''
end 

SET @strsql = @strsql + '  order by case_autoid desc'  
print(@strsql)
exec(@strsql)
END

