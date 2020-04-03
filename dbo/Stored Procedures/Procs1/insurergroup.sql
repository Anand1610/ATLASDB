CREATE PROCEDURE [dbo].[insurergroup](  
@dt1 varchar(50),  
@dt2 varchar(50),  
@printtype varchar(100),  
@STATUS VARCHAR(50) ,
@opened_by varchar(100) 
)  
as  
begin 
SET NOCOUNT ON 
declare @st nvarchar(1000)  
  
 set @st='select iNSURANCECOMPANY_NAME,
 InsuranceCompany_Local_Address + '' '' +InsuranceCompany_Local_City+'' ''+InsuranceCompany_Local_State +'' ''+InsuranceCompany_Local_Zip AS InsuranceCompany_Local_Address,
 count(*) as [Count],
  (CASE InsuranceCompany_type WHEN 1 THEN 95.00 ELSE 55.00 END) AS [fees] 
  from lcj_vw_casesearchdetails where   
  CAST(FLOOR(CAST(' + @printtype + ' AS FLOAT))AS DATETIME) >= Replace(''' + @dt1 + ''',''/'',''-'') and  
  CAST(FLOOR(CAST('+@printtype+' AS FLOAT))AS DATETIME) <= Replace(''' + @dt2+''',''/'',''-'') '  
  if @status <> 'ALL'  
  set @st = @st + ' and status = ''' + @status + ''' group by iNSURANCECOMPANY_NAME,InsuranceCompany_Local_Address + '' '' +InsuranceCompany_Local_City+'' ''+InsuranceCompany_Local_State +'' ''+InsuranceCompany_Local_Zip,InsuranceCompany_type order by iNSURANCECOMPANY_NAME' 
  else  
   if @opened_by <> 'ALL'  
  set @st = @st + ' and opened_by = ''' + @opened_by + '''  group by iNSURANCECOMPANY_NAME,InsuranceCompany_Local_Address + '' '' +InsuranceCompany_Local_City+'' ''+InsuranceCompany_Local_State +'' ''+InsuranceCompany_Local_Zip,InsuranceCompany_type order by iNSURANCECOMPANY_NAME'  
  else  
  set @st = @st + ' group by iNSURANCECOMPANY_NAME,InsuranceCompany_Local_Address + '' '' +InsuranceCompany_Local_City+'' ''+InsuranceCompany_Local_State +'' ''+InsuranceCompany_Local_Zip,InsuranceCompany_type order by iNSURANCECOMPANY_NAME'  
  print @st  
  execute sp_executesql @st  
end

