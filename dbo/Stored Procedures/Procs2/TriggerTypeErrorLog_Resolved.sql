CREATE PROCEDURE TriggerTypeErrorLog_Resolved 
	@s_a_DomainId varchar(250),
	@s_a_AutoIds varchar(max),
	@s_a_UserId varchar(max)
AS
BEGIN
	
	SET NOCOUNT ON;
	
	Update tblTriggerTypeErrorLog 
	Set IsResolved = 1,
	ResolvedBy = @s_a_UserId,
	ResolvedDate = GETDATE()
	where DomainId = @s_a_DomainId AND AutoID in (Select items From SplitStringInt(@s_a_AutoIds, ','))
	

END
