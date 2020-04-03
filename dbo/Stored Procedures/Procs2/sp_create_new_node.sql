CREATE PROCEDURE [dbo].[sp_create_new_node] --'113','Added','CO00023','3581'
(
	@CaseID nvarchar(200),
	@NodeName nvarchar(200),
	@SZ_COMPANY_ID nvarchar(20) = NULL,
	@Parent_ID nvarchar(20)
)
AS
BEGIN

	declare @sub_node_level int 
	declare @sub_parent_id nvarchar(200)
	set @sub_parent_id=(select  parentid from tbltags where nodeid=@Parent_ID)

	
	if @sub_parent_id is not null
		begin
			set @sub_node_level = (select  nodelevel from tbltags where nodeid=@Parent_ID) +1
			INSERT INTO tblTags(NodeName,Expanded,ParentID,CaseID,NodeLevel) 
			VALUES((LTRIM(RTRIM(@NodeName))),0,@Parent_ID,@CaseID,@sub_node_level)
			return 1
		end
	else
		begin

			INSERT INTO tblTags(NodeName,Expanded,ParentID,CaseID,NodeLevel) 
			VALUES((LTRIM(RTRIM(@NodeName))),0,@Parent_ID,@CaseID,1)
			return 1
		end
end

