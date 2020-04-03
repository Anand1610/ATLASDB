CREATE PROCEDURE [dbo].[cr_getPageDetails](
@ins varchar(255),
@prov varchar(255),
@yr varchar(50)
)
as
begin


create table #tempDt(Id int,Provider_Name varchar(200),InsuranceCompany_Name varchar(200),Yr varchar(10))



if @prov <> 'ALL'
begin
insert into #tempdt(Id,Provider_Name) 
select 1,Provider_Name from tblprovider where provider_Id = @prov
end
else if @prov = 'ALL'
begin
insert into #tempdt(Id,Provider_Name)  values (1,'ALL')
end

IF @ins <> 'ALL'
begin
update #tempdt set InsuranceCompany_Name =(select InsuranceCompany_Name from tblInsuranceCompany where InsuranceCompany_Id = @ins) where Id=1
end
else if @ins = 'ALL'
begin
update #tempdt set InsuranceCompany_Name ='ALL' where Id=1
end

update #tempdt set Yr =@yr where Id=1


select * from #tempdt

--print @st
--drop table #tempdt
end

