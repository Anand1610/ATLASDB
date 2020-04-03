CREATE Procedure [dbo].[ProviderandInsuranceListAccess] 
@DomainId varchar(40),
@UserId INT 

as
--select   tba.MenuId from tblMenu_Access tba with(nolock)
--inner join tblMenu tM with(nolock) on tba.MenuId = tm.MenuID
--inner join IssueTracker_Roles IR with(nolock) on tba.RoleId = IR.RoleId
--where tba.DomainId=@DomainId and MenuName='DataEntry' and rolename='Administrator'

select * from IssueTracker_users  where domainid=@DomainId and Userid=@UserId 
and roleid in  (
select   tba.roleid from tblMenu_Access tba with(nolock) inner JOIN tblMenu TM 
on tba.MenuId = TM.MenuID 
inner JOIN IssueTracker_Roles IR with(nolock) on tba.RoleId = IR.RoleId
where  MenuName ='DataEntry' and RoleName='Administrator' and tba.domainid=@DomainId
) and username not like '%ls-%'  and Email not like '%greenyourbills.com%'



