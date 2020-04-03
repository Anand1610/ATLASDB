CREATE PROCEDURE [dbo].[spSearchContacts] (
@strsearch varchar(100)
)
as
begin
Create table #temp (Name varchar(100),Address varchar (100),city varchar(100),state varchar(100),zip varchar(100),phone varchar(100),fax varchar(100),email varchar(100),type varchar(100))
insert into #temp
select provider_name,provider_local_address,provider_local_city,provider_local_state,provider_local_zip,provider_local_phone,provider_local_fax,provider_email,'PROVIDER' from tblprovider where provider_name like '%' + @strsearch + '%'
insert into #temp
select adjuster_firstname + ' ' + adjuster_lastname as [Name],INSURANCECOMPANY_NAME,' ',' ',' ',adjuster_phone,adjuster_fax,adjuster_email,'ADJUSTER' from tbladjusters INNER JOIN TBLINSURANCECOMPANY ON TBLADJUSTERS.INSURANCECOMPANY_ID=TBLINSURANCECOMPANY.INSURANCECOMPANY_ID where adjuster_firstname like '%' + @strsearch + '%' or adjuster_lastname like '%' + @strsearch + '%'
insert into #temp
select insurancecompany_name,insurancecompany_local_address,insurancecompany_local_city,insurancecompany_local_state,insurancecompany_local_zip,insurancecompany_local_phone,insurancecompany_local_fax,insurancecompany_email,'INSURER' from tblinsurancecompany where insurancecompany_name like '%' + @strsearch + '%' 
insert into #temp
select injuredparty_lastname + ' ' + injuredparty_firstname,injuredparty_address,injuredparty_city,injuredparty_state,injuredparty_zip,injuredparty_phone,'','','PATIENT' from tblcase where injuredparty_firstname like '%' + @strsearch + '%' or injuredparty_lastname like '%' + @strsearch + '%' 
insert into #temp
select attorney_firstname + ' ' + attorney_lastname,attorney_address,attorney_city,attorney_state,attorney_zip,attorney_phone,attorney_fax,attorney_email,'ATTORNEY' from tblattorney where attorney_firstname like '%' + @strsearch + '%'  or attorney_lastname like '%' + @strsearch + '%' 
insert into #temp
select defendant_name,defendant_address,defendant_city,defendant_state,defendant_zip,defendant_phone,defendant_fax,defendant_email,'DEFENDANT' from tbldefendant where defendant_name like '%' + @strsearch + '%'

select * from #temp ORDER BY TYPE
drop table #temp
end

