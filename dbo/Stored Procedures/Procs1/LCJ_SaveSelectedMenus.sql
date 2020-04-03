CREATE PROCEDURE [dbo].[LCJ_SaveSelectedMenus] 
(
@DomainId nvarchar(50),
@roleid int,
@menuid int
)
as
BEGIN
declare @m int
declare @p int
declare @flag int
declare @ifexists int

select @m=menuid,@p=parentid from tblmenu where menuid=@menuid
print '@m='
print @m
print '   @p='
print @p
--set @ifexists =(select menuid from tblmenu_access where menuid=@m and roleid=@roleid)

--if @ifexists >0 
--set @flag=1
--else
--set @flag=0
if @p is not NULL --if all menu are child menu
	begin
		if exists(select menuid from tblmenu_access where menuid=@m and roleid=@roleid AND DomainId = @DomainId)
			--if @flag = 1
			begin
				print 'in if--if'
				--delete from tblmenu_access where roleid=@roleid and menuid=@p
				--insert into tblmenu_access(roleid,menuid) values(@roleid,@m)
				--insert into tblmenu_access(roleid,menuid) values (@roleid,@p)
			end
		else
			begin
				print 'in if-- else'
				delete from tblmenu_access where roleid=@roleid and menuid=@p and menuid not in(1,8) and DomainId = @DomainId
				insert into tblmenu_access (DomainId,roleid,menuid) values (@DomainId,@roleid,@p)
				insert into tblmenu_access (DomainId,roleid,menuid) values (@DomainId,@roleid,@m)
			end
	end
else
	begin
	 --delete from tblmenu_access where roleid=@roleid and menuid in (2,3,4,5,6) --and menuid not in(1)
		if exists(select menuid from tblmenu_access where menuid=@m and roleid=@roleid and DomainId = @DomainId)
			--if @flag = 1
			begin
				print 'in else-- if'
				delete from tblmenu_access where roleid=@roleid and menuid=@m and DomainId = @DomainId--and menuid not in(1) and roleid not in(1)
				--insert into tblmenu_access(roleid,menuid) values (@roleid,@p)
				insert into tblmenu_access (DomainId,roleid,menuid) values (@DomainId,@roleid,@m) 
				--delete from tblmenu_access where roleid=@roleid and menuid=@m
				--insert into tblmenu_access(roleid,menuid) values(@roleid,@m)
				--insert into tblmenu_access(roleid,menuid) values (@roleid,@p)
			end
		else
			begin
				print 'in else--else'
				delete from tblmenu_access where roleid=@roleid and menuid=@m and menuid not in(1) and DomainId = @DomainId
				--insert into tblmenu_access(roleid,menuid) values (@roleid,@p)
				insert into tblmenu_access (DomainId,roleid,menuid) values (@DomainId,@roleid,@m)
			end
	end
END

