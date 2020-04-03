CREATE PROCEDURE  [dbo].[SP_CREATE_SAVEDOC_NODES] -- 'ZF09-229'
	@p_szCaseID nvarchar(20)
as
declare @iNodeId int
declare @szCaseID nvarchar(20)
declare @iCount int
declare @iNodeOut int
begin
	-- set @szCaseId = (select SUBSTRING ( @p_szCaseID , charindex('-',@p_szCaseID,0)+1,len(@p_szCaseID)))	
    set @szCaseId = @p_szCaseID
	set @iNodeId = (select nodeid from tbltags where parentid is null and caseid = @szCaseId and nodelevel = 0)

	if(@iNodeId is null)
	begin
		exec STP_DSP_TREEVIEWCASEID NULL,@p_szCaseID,@szCaseId,null,'Folder.gif',1,1,@iNodeOut
		set @iNodeId = (select nodeid from tbltags where parentid is null and caseid = @szCaseId and nodelevel = 0)
	end

	set @iCount = (select count(1) from tbltags where nodetype = 'SVDLET' and caseid = @szCaseId)
	if(@iCount = 0)
	begin
		insert into tbltags(parentid,NodeName,caseid,doctypeid,nodeicon,nodelevel,expanded,nodetype)
		values(@iNodeId,'Saved Letters',@szCaseId,null,null,1,1,'SVDLET')

		insert into tbltags(parentid,NodeName,caseid,doctypeid,nodeicon,nodelevel,expanded,nodetype)
		values(@iNodeId,'Packet Exhibits',@szCaseId,null,null,1,1,'SVDPAK')

		insert into tbltags(parentid,NodeName,caseid,doctypeid,nodeicon,nodelevel,expanded,nodetype)
		values(@iNodeId,'Packet Document',@szCaseId,null,null,1,1,'SVDPDF')
	end
end

