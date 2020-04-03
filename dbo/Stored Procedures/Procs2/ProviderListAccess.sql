Create Procedure ProviderListAccess 
@DomainId varchar(40)
as
select   * from tblMenu_Access tba with(nolock)
inner join tblMenu tM with(nolock) on tba.MenuId = tm.MenuID
inner join IssueTracker_Roles IR with(nolock) on tba.RoleId = IR.RoleId
where tba.DomainId=@DomainId and MenuName='DataEntry'



