CREATE PROCEDURE [dbo].[sp_insert_Batch_Mail_Send]
(
	@DomainID nvarchar(100),
	@Case_Id varchar(100),
	@Type varchar(100),
	@BatchCode nvarchar(50)
)
AS
BEGIN

set deadlock_priority 10

	
	If exists(select Case_id from tblcase where Case_Id =@Case_Id AND DomainId=@DomainID )
		Begin
			IF exists(select case_id from tblBatchMailSend where Case_Id =@Case_Id AND DomainId=@DomainID)
			Begin
				update tblBatchMailSend
				set MailSendDate =getdate(),
				BatchCode=@BatchCode
				where Case_Id =@Case_Id AND DomainId=@DomainID 
			End
			Else
			Begin
				insert into tblBatchMailSend (Case_Id,MailSendDate,Type,DomainId,BatchCode)
				values(@Case_Id,GETDATE (),@Type,@DomainID,@BatchCode)
			End	
			exec LCJ_AddNotes @DomainId=@DomainID, @case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = 'Amended AR1 Document uploaded',@user_Id='System',@ApplyToGroup = 0			
		End
		
		If EXISTS(SELECT Distinct Case_id FROM dbo.tblCASE INNER JOIN dbo.tblCasePacket on tblcase.case_id=tblCasePacket.CaseId  WHERE PacketID = @Case_Id AND tblcase.DomainId=@DomainID)
		Begin -- Start FOR PACKET ID
						
				DECLARE @tblAAAVar table(Case_id VARCHAR(50), Fee_Schedule_Balance Money,Status VARCHAR(100), RN int,DomainID nvarchar(100))
				INSERT INTO @tblAAAVar
   				SELECT Case_id
					, Fee_Schedule
					, Status
					, ROW_NUMBER() OVER (ORDER BY Fee_Schedule DESC) RN /*Or RANK() for ties*/
					,tblCASE.DomainId
				FROM dbo.tblCASE INNER JOIN dbo.tblCasePacket ON tblcase.case_id=tblCasePacket.CaseId  
				WHERE PacketID = @Case_Id AND tblcase.DomainId=@DomainID
			
					
				update tblBatchMailSend
				set MailSendDate =getdate(),
				BatchCode=@BatchCode
				where Case_Id in(SELECT Case_Id FROM @tblAAAVar) AND DomainId=@DomainID 
	
				SELECT * from tblBatchMailSend
				insert into tblBatchMailSend (Case_Id,MailSendDate,TYPE,DomainId,BatchCode)
				SELECT Case_Id,GETDATE (),@Type,DomainID,@BatchCode FROM @tblAAAVar WHERE Case_Id not in(SELECT Case_Id FROM tblBatchMailSend where DomainId=@DomainID)		
					
			
			
		End  ---- END FOR PACKET ID
	
END
