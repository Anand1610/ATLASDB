
create procedure GetProcedureConfiguration -- GetProcedureConfiguration @DomainId='af'
@DomainId varchar(50)
as
begin
select 
	Id ,
	LastTranfertDate,
	EmailFrom,
	EmailTO,
	EmailCC,
	SmtpServer,
	SmtpPort,
	EmailPassword
	from ProcedureCodeConfiguration
	where  DomainId=@DomainId
end

--select * from ProcedureCodeConfiguration
--insert into ProcedureCodeConfiguration 
--values('2019/08/01','AF','techsupport@lawspades.com','atul.d.jadhav@gmail.com','connectaidres1@greenyourbills.com','smtp.gmail.com','587','9yUIge/gVoW1Xkhd82UVug==')
			