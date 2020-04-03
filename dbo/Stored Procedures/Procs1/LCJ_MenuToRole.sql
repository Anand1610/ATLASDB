CREATE PROCEDURE [dbo].[LCJ_MenuToRole]
(
@RoleId int,
@MenuId int
)
as 
begin
insert into tblmenu_access
(
RoleId,
MenuId
)
values
(
@RoleId,
@MenuId
)
end

