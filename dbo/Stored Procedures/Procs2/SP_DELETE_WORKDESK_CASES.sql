CREATE PROCEDURE [dbo].[SP_DELETE_WORKDESK_CASES] --'slaxman','FH07-42372','slaxman'
@DomainId NVARCHAR(50),
@ASSIGNED_TO NVARCHAR(100),
@CASE_ID NVARCHAR(100),
@USER_ID NVARCHAR(100)
AS
BEGIN

	DECLARE @ST NVARCHAR(3500)
	set @Assigned_To = (Select UserID from issuetracker_users where username=@Assigned_To and DomainId=@DomainId)
	PRINT(@Assigned_To)
	IF @Case_Id <> '' AND @ASSIGNED_TO <> ''
		BEGIN

		SET @ST = 'Delete from tblCaseDeskHistory where To_User_Id = ' + @ASSIGNED_TO + ' And Case_Id in (''' +Replace(@Case_Id,',',''',''') + ''') AND BT_STATUS=1 AND DomainId= '''+@DomainId+''''
		PRINT @ST
		EXEC SP_EXECUTESQL @ST
		update tblcase set userid=null where Case_Id = @CASE_ID and DomainId=@DomainId
		
		INSERT INTO tblNotes (Notes_Desc,	Notes_Type,	Notes_Priority,	Case_Id,	Notes_Date,	User_Id,	DomainId)
		VALUES ('Case deleted from default desk!','Activity',1,@Case_Id, getdate(),@USER_ID,@DomainId)
	END

	IF EXISTS(SELECT 1 FROM TXN_ASSIGN_SETTLED_CASES WHERE CASE_ID=@CASE_ID and USER_ID=@ASSIGNED_TO and isChanged=1 and DomainId=@DomainId)
		BEGIN
			UPDATE TXN_ASSIGN_SETTLED_CASES SET isChanged = 0, DATE_CHANGED = getdate() WHERE CASE_ID=@CASE_ID and USER_ID=@ASSIGNED_TO and isChanged=1 and DomainId=@DomainId
		END

END

