﻿CREATE PROCEDURE [dbo].[SP_GET_NODENAME_USING_NODEID] -- '89', 'ReqVeri'
@SZ_NODE_ID VARCHAR(20),
@flag VARCHAR (20)
AS
BEGIN
SET NOCOUNT ON
	if	@flag = 'DocMgr'
	begin
		SELECT NodeName FROM tblTags WITH(NOLOCK) WHERE NodeID = @SZ_NODE_ID
	end
	else
	begin
		select SZ_NODE_NAME from MST_NODES WITH(NOLOCK) where I_NODE_ID = @SZ_NODE_ID
	end
	SET NOCOUNT OFF
END

