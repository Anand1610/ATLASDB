CREATE PROCEDURE [dbo].[SP_UPDATE_ASSIGN_WORK_DESK]-- 'FH10-67183','39456'
@DomainId			nvarchar(50),
@CASE_ID			NVARCHAR(50)=null,
@To_User_Id			INT,
@History_Id			int =null

AS BEGIN
	SET @CASE_ID=(LTRIM(RTRIM(@CASE_ID)))
	Set @History_Id=(Select max(History_Id) from tblCasedeskHistory  where case_id=@case_id and to_user_id = @To_User_Id and bt_status=1 and DomainId=@DomainId)
PRINT(@History_Id)
	if (@History_Id is not null)
		begin
			Update tblCaseDeskHistory 
			set bt_status=0
			where history_id=@history_id and DomainId=@DomainId
		end
END

