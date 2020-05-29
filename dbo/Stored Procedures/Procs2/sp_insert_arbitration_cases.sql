/* 
modified by	Atul Jadhav
Date		5/29/2020
Description	Created for relove the web application error
Last used by :
*/
CREATE  PROCEDURE [dbo].[sp_insert_arbitration_cases]
(
	@DomainId VARCHAR(50),
	@Case_Id varchar(40),
	@User_Id varchar(80),
	@isbit bit,
	@Status VARCHAR(200),
	@BatchCode VARCHAR(80)=null
)
AS
BEGIN

set deadlock_priority 10

	
	if(@isbit =0)-- ARB Done Cases By (Ready To Print Cases)
	Begin
		if not exists(select case_id from tblArbitrationCases (nolock) where Case_Id =@Case_Id and DomainId=@DomainId)
		Begin
			insert into tblArbitrationCases  (Case_Id,ready_by_user,ready_date,DomainId,BatchCode)
			values(@Case_Id,@user_id,GETDATE (),@DomainId,@BatchCode)
		ENd
	End
	Else -- AAA Package send mail cases
	Begin
		If exists(select Case_id from tblcase (nolock) where Case_Id =@Case_Id and DomainId=@DomainId )
		Begin
			----------------------------------------------------------------------------------------------
				Declare @oldStatus varchar(200), @newDesc varchar(500)
				Declare @new_stat_hierc int,@PROVIDER_ID VARCHAR(50) , @provider_ff nchar(10),@desc varchar(200),@status_bill money,@old_stat_hierc int,@motion_stat_hierc smallint,@status_bill_type VARCHAR(20),@status_bill_notes varchar(200)
				
				SET @oldStatus =(SELECT Status from tblcase (nolock) where Case_Id = @Case_Id and DomainId=@DomainId )
				
				DECLARE @oldStatusHierarchy int
			    DECLARE @newStatusHierarchy int
				SET @oldStatusHierarchy =(Select  Status_Hierarchy from  tblStatus(nolock) where  DomainID =@DomainID and Status_Type=@oldStatus)
				SET @newStatusHierarchy =(Select  Status_Hierarchy from  tblStatus(nolock) where  DomainID =@DomainID and Status_Type=@Status)
				

					if(@newStatusHierarchy>=@oldStatusHierarchy OR ((@newStatusHierarchy = 0 OR @oldStatusHierarchy = 0) AND @DomainID in ('AMT','PDC')))
					BEGIN

							update tblcase  		
							set status = @Status, Date_AAA_Arb_Filed=getdate()
							where  case_id = @Case_Id
							and DomainId=@DomainId
				
							SET @newDesc = 'Status changed from ' + @oldStatus + ' to ' + @Status  
							exec LCJ_AddNotes @DomainId=@DomainId,@case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @newDesc,@user_Id='System',@ApplyToGroup = 0
					end
					ELSE
					BEGIN
							update tblcase  		
							set Date_AAA_Arb_Filed=getdate()
							where  case_id = @Case_Id
							and DomainId=@DomainId

						SET @newDesc = 'Status Hierarchy Constraint error : Status cannot be changed from '+ @oldStatus + ' to ' + @Status  
						exec LCJ_AddNotes @DomainId=@DomainId,@case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @newDesc,@user_Id='System',@ApplyToGroup = 0
					END 

				
			
			----------------------------------------------------------------------------------
			IF exists(select case_id from tblArbitrationCases (nolock) where Case_Id =@Case_Id and DomainId=@DomainId)
			Begin
				update tblArbitrationCases 
				set MailSendDate =getdate(),
				BatchCode=@BatchCode
				where Case_Id =@Case_Id 
				and DomainId=@DomainId
			End
			Else
			Begin
				insert into tblArbitrationCases  (Case_Id,ready_by_user,ready_date,MailSendDate,DomainId,BatchCode)
				values(@Case_Id,'System',GETDATE (),GETDATE (),@DomainId,@BatchCode)
			End	
		End
	End
END

