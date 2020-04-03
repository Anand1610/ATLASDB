
-----[LCJ_UpdateCaseDetails] 'a' ,'FDNY14-3023','','test','lblinsclaimrep','fassfirm','','test'

CREATE PROCEDURE [dbo].[LCJ_UpdateCaseDetails](        
@DomainId varchar(50),
@Case_Id varchar(200),        
@oldValue varchar(200),        
@newValue varchar(200),        
@fieldName varchar(200),        
@user_id varchar(50),        
@oldTextName varchar(200),        
@newTextName varchar(200)
       
)        
as        
BEGIN        
        
	declare        
	@st nVARCHAR(200),        
	@desc varchar(200),
	@Date_Answer_Expected datetime,
	@old_stat_hierc int,  
	@new_stat_hierc int,
	@motion_stat_hierc smallint,
	@PROVIDER_ID varchar(50) ,
	@provider_ff nchar(10),
	@status_bill money,
	@status_bill_type varchar(20),
	@status_bill_notes varchar(200),
	@current_status varchar(300)
	DECLARE @newStatusHierarchy int
	DECLARE @oldStatusHierarchy int

	declare @Description VARCHAR(200) ='Status Hierarchy Constraint error :Status cannot be changed from ' + @oldValue + ' to ' + 
			@newValue + ',' 

			IF @fieldName = 'Settlement_Date2'
	BEGIN 
		IF NOT EXISTS (SELECT Settlement_Id FROM tblSettlements WHERE  Case_Id=@Case_Id AND DomainId=@DomainId)
		BEGIN
		declare @Treatment_Id int
		set @Treatment_Id=(select max(Treatment_Id) from tblTreatment where  Case_Id=@case_id AND DomainId=DomainId)

				if(@newvalue='')
				begin
				set @newvalue=NULL
				end
		     INSERT INTO tblSettlements(Settlement_Date,Settlement_Int,Settlement_Af,Settlement_Ff,Settlement_Total,Treatment_Id,Case_Id,User_Id,DomainId)
			 VALUES(@newvalue,0,0,0,0,@Treatment_Id,@case_id,@user_id,@DomainId)
		END
		ELSE
		BEGIN
		UPDATE tblSettlements
		SET Settlement_Date=@newvalue
		WHERE Case_Id=@case_id AND DomainId=DomainId
		END
		set @desc = ''+'Settlement_Date' +  ' Changed From '+@oldValue+' To ' + @newvalue + ' '   
			exec LCJ_AddNotes @DomainId=@DomainId,@case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @desc,@user_Id=@User_Id,@ApplyToGroup = 0  
			SET @current_status=(select status from tblcase where case_id=@Case_Id and DomainId=@DomainId)			
			Declare @Company_Type varchar(150)
			Select TOP 1 @Company_Type = CompanyType from tbl_Client(NOLOCK) where DomainId = @DomainId

			IF lower(@current_status) !='settled awaiting payment' and lower(@Company_Type) = 'funding'
				   BEGIN
						SET @oldStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@current_status)
						SET @newStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type='SETTLED AWAITING PAYMENT')
						if(@newStatusHierarchy>=@oldStatusHierarchy OR ((@newStatusHierarchy = 0 OR @oldStatusHierarchy = 0) AND @DomainID in ('AMT','PDC')))
						begin
							Update tblcase set Status = 'SETTLED AWAITING PAYMENT' where Case_Id = @Case_Id and DomainId = @DomainId
							EXEC LCJ_AddNotes @DomainId=@DomainId, @case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = 'Status Changed To : SETTLED AWAITING PAYMENT', @user_Id=@User_Id, @ApplyToGroup = 0  
						end
						else
						begin
							EXEC F_Add_Activity_Notes   @DomainID =@DomainID
											   ,@s_a_case_id = @Case_Id  
											   ,@s_a_notes_type = 'Activity'  
											   ,@s_a_ndesc = 'Can not change the status to SETTLED AWAITING PAYMENT'
											   ,@s_a_user_Id = @User_Id 
											   ,@i_a_applytogroup = 0  
						end
						
				 END	
			RETURN	
	ENd
		IF @fieldName = 'Settlement_Amount'
	BEGIN 
		IF NOT EXISTS (SELECT Settlement_Id FROM tblSettlements WHERE  Case_Id=@Case_Id AND DomainId=@DomainId)
		BEGIN
			declare @Treatment_Id1 int
		set @Treatment_Id1=(select max(Treatment_Id) from tblTreatment where  Case_Id=@case_id AND DomainId=DomainId)
		     INSERT INTO tblSettlements(Settlement_Amount,Settlement_Int,Settlement_Af,Settlement_Ff,Settlement_Total,Treatment_Id,Case_Id,User_Id,DomainId)
			 VALUES(@newvalue,0,0,0,0,@Treatment_Id1,@case_id,@user_id,@DomainId)
		END
		ELSE
		BEGIN
		UPDATE tblSettlements
		SET Settlement_Amount=@newvalue
		WHERE Case_Id=@case_id AND DomainId=DomainId
		END

			set @desc = ''+'Settlement_Date2' +  ' Changed From '+@oldValue+' To ' + @newvalue + ' '   
			exec LCJ_AddNotes @DomainId=@DomainId,@case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @desc,@user_Id=@User_Id,@ApplyToGroup = 0  	
			RETURN	
	ENd


	IF (@fieldName='location_id')
	BEGIN
		IF(@newValue=1)
		set @newValue =null;		
	END
	--ARB WON UPDATER
	IF @fieldName = 'DateFile_Trial_DeNovo'
	BEGIN 
		IF @newvalue <=GETDATE()
		BEGIN
			SET @current_status=(select status from tblcase where case_id=@Case_Id and DomainId=@DomainId)
			IF @current_status = 'ARB WON-NOTICE OF ENTRY'
			BEGIN
				update tblcase
				SET STATUS='ARB WON-FLAG FOR JUDGMENT',Last_Status='ARB WON-NOTICE OF ENTRY'
				where Case_Id =@Case_Id
				exec LCJ_AddNotes @DomainId=@DomainId, @case_id=@case_id,@notes_type='Activity' ,@NDesc='Status changed to ARB WON-FLAG FOR JUDGMENT by system.>>>' ,@user_id='system',@applytogroup=0
			END
		END
	END

	IF @fieldName = 'DateOfService_Start' or @fieldName = 'DateOfService_END' or @fieldName = 'Claim_Amount' or @fieldName = 'Paid_Amount' or @fieldName ='Date_BillSent' or @fieldName = 'stips_signed_and_returned' or @fieldName = 'stips_signed_and_returned_2' or @fieldName = 'stips_signed_and_returned_3'      
	BEGIN        
		 IF @fieldName = 'Claim_Amount' or  @fieldName = 'Paid_Amount' or @fieldName = 'stips_signed_and_returned' or @fieldName = 'stips_signed_and_returned_2' or @fieldName = 'stips_signed_and_returned_3'        
			set @st = 'update tblcase set ' + @fieldName + '= ' + @newvalue + '  where Case_Id in ('''+@Case_Id + ''') and DomainId='''+@DomainId+''''        
		 ELSE        
			set @st = 'update tblcase set ' + @fieldName + '= ''' + @newvalue + '''  where Case_Id in ('''+@Case_Id + ''') and DomainId='''+@DomainId+''''        
		        
		 exec sp_Executesql @st         
	END     
	ELSE 
		IF @fieldName = 'Date_Answer_Received'
		BEGIN    
			SET NOCOUNT ON
			set @st = 'update tblCase_Date_Details set ' + @fieldName + '= ''' + @newvalue + ''' where Case_Id in ('''+@Case_Id +''') and DomainId='''+@DomainId+''''    
			 
			exec sp_Executesql @st    
			SELECT @Date_Answer_Expected = (CASE WHEN (Date_Ext_Of_Time_3 IS NOT NULL) 
							  THEN (Date_Ext_Of_Time_3 + 5) WHEN (Date_Ext_Of_Time_2 IS NOT NULL) AND (Date_Ext_Of_Time_3 IS NULL) 
							  THEN (Date_Ext_Of_Time_2 + 5) WHEN (Date_Ext_Of_Time IS NOT NULL) AND (Date_Ext_Of_Time_2 IS NULL) 
							  THEN (Date_Ext_Of_Time + 5) WHEN (Date_Ext_Of_Time IS NULL) AND (ISNULL(InsuranceCompany_GroupName,'') NOT LIKE '%GEICO%') THEN (Date_Afidavit_Filed + 45) 
							  WHEN (Date_Ext_Of_Time IS NULL) AND (ISNULL(InsuranceCompany_GroupName,'') LIKE '%GEICO%') THEN (Served_on_date + 65) END )
					FROM         dbo.tblcase INNER JOIN
							  dbo.tblInsuranceCompany ON dbo.tblcase.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id
					WHERE     (dbo.tblcase.Status = N'AFFIDAVITS FILED IN COURT') AND (dbo.tblcase.case_id=@case_id) and dbo.tblCase.DomainId=@DomainId
			
			IF @Date_Answer_Expected >= Convert(datetime,@Newvalue)
			BEGIN 
				SET @current_status=(select status from tblcase where case_id=@Case_Id and DomainId=@DomainId)
				SET @oldStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@current_status)
				SET @newStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type='ANSWER-RECD')
				if(@newStatusHierarchy>=@oldStatusHierarchy OR ((@newStatusHierarchy = 0 OR @oldStatusHierarchy = 0) AND @DomainID in ('AMT','PDC')))
					begin
						update	tblcase
								set status = 'ANSWER-RECD' where Case_Id = @Case_Id and DomainId=@DomainId
								exec LCJ_AddNotes @DomainId=@DomainId, @case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = 'STATUS CHANGED TO ANSWER-RECD BY SYSTEM >> XM-001' ,@user_Id='SYSTEM',@ApplyToGroup = 0
								GOTO FINISH
					end
					else
					begin
								exec LCJ_AddNotes @DomainId=@DomainId, @case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = 'Cant not change Status to ANSWER-RECD  >> XM-001' ,@user_Id='SYSTEM',@ApplyToGroup = 0
								GOTO FINISH
					End
			END

			IF @Date_Answer_Expected < Convert(datetime,@Newvalue)
			BEGIN 
				set @desc = 'STATUS CHANGED TO ANSWER-RCVD-LATE BY SYSTEM. ANSWER DEADLINE WAS : '+convert(varchar(12),@Date_Answer_Expected,101)+'          >> XM-001'
				SET @current_status=(select status from tblcase where case_id=@Case_Id and DomainId=@DomainId)
				SET @oldStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@current_status)
				SET @newStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type='ANSWER-RCVD-LATE')
				if(@newStatusHierarchy>=@oldStatusHierarchy OR ((@newStatusHierarchy = 0 OR @oldStatusHierarchy = 0) AND @DomainID in ('AMT','PDC')))
				begin
					update	tblcase
							set status = 'ANSWER-RCVD-LATE' where Case_Id = @Case_Id and DomainId=@DomainId
							exec LCJ_AddNotes @DomainId=@DomainId, @case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @desc ,@user_Id='SYSTEM',@ApplyToGroup = 0
							GOTO FINISH
				end
				begin
						exec LCJ_AddNotes @DomainId=@DomainId, @case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = 'Cant not change Status to ANSWER-RCVD-LATE  >> XM-001' ,@user_Id='SYSTEM',@ApplyToGroup = 0
						GOTO FINISH
				end
			END
		END
		ELSE IF @FieldName ='Status' -- Update on 12-11-07 ::Provision for Status Hierarchy.
		BEGIN
			SET NOCOUNT ON
			IF @newTextName = '21 days on hold PENDing Peer Review' OR @newTextName = '21 days on hold pENDing IME Report' OR @newTextName = '21 days on hold pENDing IME REPORT/PEER REVIEW'
			BEGIN
				IF EXISTS(SELECT 1 FROM MST_STATUS_LOG WHERE CASE_ID=@Case_id and DomainId=@DomainId)
				BEGIN
					UPDATE MST_STATUS_LOG SET STATUS_BIT = 1, DATE_CHANGED = getdate() WHERE CASE_ID=@Case_id and DomainId=@DomainId
				END
				ELSE
				BEGIN
					INSERT INTO MST_STATUS_LOG(CASE_ID,DATE_CHANGED,STATUS_BIT,DomainId) VALUES(@Case_id,getdate(),1,@DomainId)
				END
			END
			ELSE IF @oldTextName = '21 days on hold PENDing Peer Review' OR @oldTextName = '21 days on hold pENDing IME Report' OR @oldTextName = '21 days on hold pENDing IME REPORT/PEER REVIEW'
			BEGIN
					UPDATE MST_STATUS_LOG SET STATUS_BIT = 0 WHERE CASE_ID=@Case_id and DomainId=@DomainId
			END

			--PENDING ASSIGNMENT
			IF @newTextName = 'Pending' or @newTextName = 'AAA Pending' or @newTextName = 'AAA PPO Pending'
			BEGIN
				exec sp_assign_pending_work_desk @DomainId=@DomainId,@Case_Id=@Case_Id
			END

			-- for settled status change
			IF @newTextName = 'Settled'
			BEGIN
				IF EXISTS(SELECT 1 FROM TXN_ASSIGN_SETTLED_CASES WHERE CASE_ID=@Case_id and DomainId=@DomainId)
				BEGIN
					UPDATE TXN_ASSIGN_SETTLED_CASES SET isChanged = 1, DATE_CHANGED = getdate(), USER_ID = @User_Id WHERE CASE_ID=@Case_id and DomainId=@DomainId
				END
				ELSE
				BEGIN
					INSERT INTO TXN_ASSIGN_SETTLED_CASES(CASE_ID,USER_ID,DATE_CHANGED,isChanged,DomainId) VALUES(@Case_id,@User_Id,getdate(),1,@DomainId)
				END
			END
			ELSE IF @oldTextName = 'Settled'
			BEGIN
				UPDATE TXN_ASSIGN_SETTLED_CASES SET isChanged = 0 WHERE CASE_ID=@Case_id and DomainId=@DomainId
			END

			-- for answer received, ASSIGN CASE TO JOE, ERIN, DANA
			IF @newTextName = 'ANSWER-RECD'
			BEGIN
				exec [SP_ASSIGN_REDCAT_DENIAL_REASONS] @DomainId, @Case_id
			END


			SELECT @old_stat_hierc = STATUS_HIERARCHY FROM Tblstatus INNER JOIN TBLcase ON dbo.tblcase.status = dbo.tblstatus.status_Type
			where dbo.tblcase.case_id=@Case_id AND dbo.tblcase.status=@OldValue


			SELECT @motion_stat_hierc = STATUS_HIERARCHY FROM TblMotion_Status INNER JOIN TBLcase ON dbo.tblcase.Motion_Status = dbo.tblMotion_Status.status_desc
			where dbo.tblcase.case_id=@Case_id

			SELECT @new_stat_hierc = STATUS_HIERARCHY ,@status_bill = auto_bill_amount ,@status_bill_type = auto_bill_type,
				   @status_bill_notes=auto_bill_notes
			FROM Tblstatus
			 where status_type=@newValue
			 
			--IF ((@new_stat_hierc < @old_stat_hierc) OR (@new_stat_hierc < 900 AND @motion_stat_hierc = 1)) and @user_id <>'srosenthal'
			--BEGIN
			--	set @desc = 'Status Hierarchy Constraint error :'+@fieldName +  ' cannot be changed from ' + @oldTextName + ' to ' + @newTextName +'.  >>XM-003'       
			--	exec LCJ_AddNotes @DomainId=@DomainId,@case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @desc,@user_Id=@User_Id,@ApplyToGroup = 0
			--	RETURN
			--END

				SET @current_status=(select status from tblcase where case_id=@Case_Id and DomainId=@DomainId)
				SET @oldStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@current_status)
				SET @newStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@newValue)
			
					
					if(@newStatusHierarchy<@oldStatusHierarchy and ((@newStatusHierarchy >0 and @oldStatusHierarchy > 0) OR @DomainId not in ('AMT','PDC')))
					begin
						exec LCJ_AddNotes @DomainId=@DomainId, @case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @Description ,@user_Id='SYSTEM',@ApplyToGroup = 0
						return
					end

			

			--IF @status_bill > 0
			--BEGIN

			--	SELECT @provider_id=tblcase.provider_id ,@provider_ff = tblProvider.provider_ff 
			--	FROM   tblProvider INNER JOIN tblcase ON tblProvider.Provider_Id = tblcase.Provider_Id
			--	WHERE tblcase.case_id =@case_id


			--	INSERT INTO TBLTRANSACTIONS(CASE_ID,TRANSACTIONS_TYPE,TRANSACTIONS_DATE,TRANSACTIONS_AMOUNT,TRANSACTIONS_DESCRIPTION,PROVIDER_ID,TRANSACTIONS_FEE,USER_ID)
			--	VALUES (@case_id,@status_bill_type,GETDATE(),@status_bill,@status_bill_notes,@PROVIDER_ID,@status_bill,@USER_ID)

			--	set @desc = 'Payment/Transaction posted :'+ CONVERT(VARCHAR(20),@status_bill) +' '+'('+ @status_bill_type +') Desc-> ' + @status_bill_notes + '. New Status-> '+ @newvalue + ' .' 
			--	exec LCJ_AddNotes @DomainId=@DomainId,@case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @desc,@user_Id=@User_Id,@ApplyToGroup = 0

			--END

			HOP1:

			END -- END of Hierachy update on 12/11/07

	BEGIN        
		IF @newValue is null
		BEGIN
			set @st = 'update tblcase set ' + @fieldName + '= NULL where Case_Id in ('''+@Case_Id + ''')'
		END	
		ELSE
		BEGIN
			set @st = 'update tblcase set ' + @fieldName + '= ''' + @newvalue + ''' where Case_Id in ('''+@Case_Id + ''')'
		END    
          
		 print @st        
		 exec sp_Executesql @st  
		 
   
	END      
	FINISH:  
	
	
	IF(@fieldName='UserId')    
	BEGIN    
	 set @fieldname='Assigned To'    
	END    

	set @desc = @fieldName +  ' changed from ' + @oldTextName + ' to ' + @newTextName       
	exec LCJ_AddNotes @DomainId=@DomainId, @case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @desc,@user_Id=@User_Id,@ApplyToGroup = 0  
	
	-----FILING FEE ON INDEX CHANGE
	--IF (@fieldName='IndexOrAAA_Number')
	--BEGIN
	--				--[LCJ_AddPaymentsTransactions] 'FH12-96305','40901','15500.00','12/12/2011','C','','tech',''
	--			SELECT @provider_id=provider_id FROM TBLCASE WHERE Case_Id=@Case_Id
	--			EXEC [LCJ_AddPaymentsTransactions] @Case_Id,@provider_id,'40.0000',GETDATE,'FBB','',@user_id,''
	--END
	
	
	
		 ---DateAAA_ResponceRecieved
	 IF(@fieldName='DateAAA_ResponceRecieved')  
	 BEGIN
		DECLARE @oldStatus varchar(200), @newStatus varchar(200),@newDesc varchar(1000)
		IF((SELECT DATEDIFF(DD,DateAAA_ResponceRecieved,Date_AAA_Concilation_Over) from tblcase where Case_Id = @Case_Id) < 0)
		BEGIN
			
			SET @oldStatus = (SELECT status FROM tblcase WHERE  Case_Id = @Case_Id)
			
			IF (@oldStatus ='AAA CONFIRMED')
				SET @newStatus ='AAA RESPONSE-RCVD-LATE'
			ELSE IF (@oldStatus ='AAA PPO CONFIRMED')
				SET @newStatus='AAA PPO RESPONSE-RCVD-LATE'
			ELSE
				SET @newStatus=''
				
			

			IF (@newStatus<>'')
			BEGIN	
			   
				UPDATE tblcase
				SET Status=	@newStatus WHERE Case_Id = @Case_Id
				
				SET @newDesc = 'Status changed from ' + @oldStatus + ' to ' + @newStatus  
				
				exec LCJ_AddNotes @DomainId=@DomainId, @case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @newDesc,@user_Id='System',@ApplyToGroup = 0
				
			END
		END
		IF((SELECT DATEDIFF(DD,DateAAA_ResponceRecieved,Date_AAA_Concilation_Over) from tblcase where Case_Id = @Case_Id) >= 0)
		BEGIN
			
			
			SET @oldStatus = (SELECT status FROM tblcase WHERE  Case_Id = @Case_Id)
			IF (@oldStatus ='AAA CONFIRMED')
				SET @newStatus ='AAA RESPONSE RCVD'
			ELSE IF (@oldStatus ='AAA PPO CONFIRMED')
				SET @newStatus='AAA PPO RESPONSE RCVD'
			ELSE
				SET @newStatus=''
				
			IF (@newStatus<>'')
			BEGIN	
			   
			    
				UPDATE tblcase
				SET Status=	@newStatus WHERE Case_Id = @Case_Id
				SET @newDesc = 'Status changed from ' + @oldStatus + ' to ' + @newStatus  
				exec LCJ_AddNotes @DomainId=@DomainId,@case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @newDesc,@user_Id='System',@ApplyToGroup = 0
				
			END
		END
		
	 END  
	 
	 IF(@fieldName='Assigned_Attorney')
	 BEGIN
	 IF(@oldTextName <> @newTextName)
	 BEGIN
		UPDATE tblcase
				SET Assigned_Attorney=	@newValue WHERE Case_Id = @Case_Id

				SET @newDesc = 'Assigned Attorney changed from ' + @oldTextName + ' to ' + @newTextName  
				exec LCJ_AddNotes @DomainId=@DomainId,@case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @newDesc,@user_Id='System',@ApplyToGroup = 0
	 END
	 END
	 
	  
	  -- IF(@fieldName='DenialReasons')  
	  --  BEGIN
			--DECLARE @DenialReasonType varchar(50)
			-- BEGIN
			--	SET @DenialReasonType=(SELECT DenialReason FROM MST_DenialReasons WHERE PK_Denial_ID=@newValue)
			--	UPDATE tblcase 
			--	SET DenialReasons_Type=@DenialReasonType where Case_Id=@Case_Id
			--	END
	  --  END 
	  -- IF (@fieldName='Date_Open_Verification_Response_Sent1')
	  --  BEGIN
			--UPDATE tblcase set   Date_Open_Verification_Response_Sent1  =  convert(datetime,@newTextName,103)  where case_id = @Case_Id     
	  --  END
	  -- IF (@fieldName='Date_Open_Verification_Response_Sent2')
	  --  BEGIN
		 --   UPDATE tblcase set   Date_Open_Verification_Response_Sent2  =  convert(datetime,@newTextName,103)  where case_id = @Case_Id     
	  --  END
	  -- IF (@fieldName='Date_of_AAA_Awards')
	  --  BEGIN
			--UPDATE tblcase set   Date_of_AAA_Awards  =  convert(datetime,@newTextName,103)  where case_id = @Case_Id     
	  --  END   
END

