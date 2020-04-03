CREATE PROCEDURE [dbo].[ArbitrationNote]--'FH07-42372'
@DomainId VARCHAR(50),
@cid varchar(50)

as
begin

	Declare @oldStatus varchar(200)
	DECLARE @newStatusHierarchy int
	DECLARE @oldStatusHierarchy int
	SET @oldStatus =(SELECT Status from tblcase where Case_Id = @cid and DomainId=@DomainId)
	if @oldStatus= 'AAA PPO OPEN'
	Begin

		update tblcase 		
		set status='AAA PPO PACKAGE PRINTED' , DATE_STATUS_CHANGED=GETDATE()
		where  case_id=@cid		
		AND DomainId=@DomainId
	End
	ELSE
	BEGIN
	SET @oldStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@oldStatus)
		SET @newStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type='AAA PACKAGE PRINTED')
		if(@newStatusHierarchy>=@oldStatusHierarchy OR ((@newStatusHierarchy = 0 OR @oldStatusHierarchy = 0) AND @DomainID in ('AMT','PDC')))
		BEGIN
			update tblcase 
			set status='AAA PACKAGE PRINTED' , DATE_STATUS_CHANGED=GETDATE()
			where  case_id=@cid
			AND DomainId=@DomainId
		END
		ELSE
		BEGIN
			INSERT INTO tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id,DomainID)
			values('Case Status Changed from '+@oldStatus+' to '+'AAA PACKAGE PRINTED' ,'Activity', 1,@cid,GETDATE(),'System',@DomainID)
		END
	END
	


	update tblcase
	set DateAAA_packagePrinting =GETDATE()
	where Case_Id =@cid
	AND DomainId=@DomainId


	if exists(select * from tblArbitrationCases where Case_Id= @cid and DomainId=@DomainId)
	Begin
		UPDATE tblArbitrationCases
		SET printed_date = GETDATE()
		WHERE Case_Id= @cid
		AND DomainId=@DomainId
	End
	else
	Begin
		insert into tblArbitrationCases (Case_Id,ready_by_user,ready_date,printed_date,DomainId)
		values(@cid,'System',GETDATE (),GETDATE (),@DomainId)
	end
 
end

