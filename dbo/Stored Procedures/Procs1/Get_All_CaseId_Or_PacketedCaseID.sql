CREATE PROCEDURE [dbo].[Get_All_CaseId_Or_PacketedCaseID]
(
	@DomainId nvarchar(100),
	@Case_Id_OR_PacketId varchar(100)
)
AS
BEGIN

set deadlock_priority 10
	IF(ISNULL(@Case_Id_OR_PacketId,'') <> '')
	BEGIN
		SELECT Distinct Case_id FROM dbo.tblCASE WHERE Case_Id= @Case_Id_OR_PacketId AND DomainId=@DomainId 
		
		UNION
		
		SELECT Distinct Case_id FROM dbo.tblCASE INNER JOIN dbo.tblCasePacket on tblcase.case_id=tblCasePacket.CaseId  
		WHERE Case_Id= @Case_Id_OR_PacketId OR PacketID = @Case_Id_OR_PacketId AND tblcase.DomainId=@DomainId
		
		UNION 
		
		SELECT Distinct CaseID FROM dbo.tblCasePacket 
		WHERE PacketID IN (	SELECT Distinct PacketID FROM dbo.tblCasePacket  WHERE CaseId= @Case_Id_OR_PacketId OR PacketID = @Case_Id_OR_PacketId AND DomainId=@DomainId)
		AND DomainId=@DomainId
	END
END


