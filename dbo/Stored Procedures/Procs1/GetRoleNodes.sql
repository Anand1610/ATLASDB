CREATE PROCEDURE [dbo].[GetRoleNodes] --1







(







   @RoleId AS INT







) 	







AS







BEGIN	







	SET NOCOUNT ON;







    SELECT DN.NodeID,NodeName FROM dbo.MST_DOCUMENT_NODES DN INNER JOIN tbl_node_role ND







    ON DN.NodeID =ND.NodeID WHERE roleid=@RoleId ORDER BY NodeName







END

