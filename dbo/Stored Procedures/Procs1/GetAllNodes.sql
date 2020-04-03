CREATE PROCEDURE [dbo].[GetAllNodes]  	







(







   @RoleId As INT







)







AS







BEGIN	







	SET NOCOUNT ON;







    







    SELECT NodeID,NodeName FROM dbo.MST_DOCUMENT_NODES WHERE NodeID not in(select NodeID from tbl_node_role where roleid=@RoleId) 







END

