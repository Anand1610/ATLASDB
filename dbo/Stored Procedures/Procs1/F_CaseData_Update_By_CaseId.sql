CREATE PROCEDURE [dbo].[F_CaseData_Update_By_CaseId]  --[F_CaseData_Update_By_CaseId] 'cwhite',0,'','',''
(
     @s_a_Case_Id nvarchar(100)=null,
     @s_a_UserID int=null,
     @s_a_FieldName nvarchar(100)=null,
     @s_a_OldValueText nvarchar(max)=null,
     @s_a_NewValueText nvarchar(max)=null
)  
  
AS    
BEGIN
	

	--DECLARE @s_l_Sql nvarchar(max)
	--set @s_l_Sql = 'update tblcase set ' + @s_a_FieldName + '= ''' + @s_a_NewValueText + '''  where Case_Id in ('''+@s_a_Case_Id + ''')'   
	--exec sp_Executesql @s_l_Sql  
	--exec F_Add_Activity_Notes @s_a_Case_Id=@s_a_Case_Id,@s_a_Notes_Type='Activity',@s_a_NDesc = @desc ,@s_a_UserID='SYSTEM',@i_a_ApplyToGroup = 0
	
	
	declare        
	@st nvarchar(200),        
	@desc varchar(200),
	@Date_Answer_Expected datetime,
	@old_stat_hierc int,  
	@new_stat_hierc int,
	@motion_stat_hierc smallint,
	@PROVIDER_ID nvarchar(50) ,
	@provider_ff nchar(10),
	@status_bill money,
	@status_bill_type nvarchar(20),
	@status_bill_notes varchar(200)

	--IF (@s_a_FieldName='location_id')
	--BEGIN
	--	IF(@s_a_NewValueText=1)
	--	set @s_a_NewValueText =null;		
	--END


	IF @s_a_FieldName = 'DateOfService_Start' or @s_a_FieldName = 'DateOfService_END' or @s_a_FieldName = 'Claim_Amount' or @s_a_FieldName = 'Paid_Amount' or @s_a_FieldName ='Date_BillSent' or @s_a_FieldName = 'stips_signed_and_returned' or @s_a_FieldName = 'stips_signed_and_returned_2' or @s_a_FieldName = 'stips_signed_and_returned_3'      
	BEGIN        
		 IF @s_a_FieldName = 'Claim_Amount' or  @s_a_FieldName = 'Paid_Amount' or @s_a_FieldName = 'stips_signed_and_returned' or @s_a_FieldName = 'stips_signed_and_returned_2' or @s_a_FieldName = 'stips_signed_and_returned_3'        
			set @st = 'update tblcase set ' + @s_a_FieldName + '= ' + @s_a_NewValueText + '  where Case_Id in ('''+@s_a_Case_Id + ''')'        
		 ELSE        
			set @st = 'update tblcase set ' + @s_a_FieldName + '= ''' + @s_a_NewValueText + '''  where Case_Id in ('''+@s_a_Case_Id + ''')'        
		        
		 exec sp_Executesql @st         
	END     
	ELSE 
		IF @s_a_FieldName = 'Date_Answer_Received'
		BEGIN    
			SET NOCOUNT ON
			set @st = 'update tblcase set ' + @s_a_FieldName + '= ''' + @s_a_NewValueText + ''' where case_id in ('''+@s_a_Case_Id +''')'     
			exec sp_Executesql @st    
			SELECT @Date_Answer_Expected = (CASE WHEN (Date_Ext_Of_Time_3 IS NOT NULL) 
							  THEN (Date_Ext_Of_Time_3 + 5) WHEN (Date_Ext_Of_Time_2 IS NOT NULL) AND (Date_Ext_Of_Time_3 IS NULL) 
							  THEN (Date_Ext_Of_Time_2 + 5) WHEN (Date_Ext_Of_Time IS NOT NULL) AND (Date_Ext_Of_Time_2 IS NULL) 
							  THEN (Date_Ext_Of_Time + 5) WHEN (Date_Ext_Of_Time IS NULL) AND (ISNULL(InsuranceCompany_GroupName,'') NOT LIKE '%GEICO%') THEN (Date_Afidavit_Filed + 45) 
							  WHEN (Date_Ext_Of_Time IS NULL) AND (ISNULL(InsuranceCompany_GroupName,'') LIKE '%GEICO%') THEN (Served_on_date + 65) END )
					FROM         dbo.tblcase INNER JOIN
							  dbo.tblInsuranceCompany ON dbo.tblcase.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id
					WHERE     (dbo.tblcase.Status = N'AFFIDAVITS FILED IN COURT') AND (dbo.tblcase.case_id=@s_a_Case_Id)
			
			IF @Date_Answer_Expected >= Convert(datetime,@s_a_NewValueText)
			BEGIN 
				update tblcase
				set status = 'ANSWER-RECD' where Case_Id = @s_a_Case_Id
				exec F_Add_Activity_Notes @s_a_Case_Id=@s_a_Case_Id,@s_a_Notes_Type='Activity',@s_a_NDesc = 'STATUS CHANGED TO ANSWER-RECD BY SYSTEM >> XM-001' ,@s_a_UserName='SYSTEM',@i_a_ApplyToGroup = 0
				GOTO FINISH
			END
			IF @Date_Answer_Expected < Convert(datetime,@s_a_NewValueText)
			BEGIN 
				set @desc = 'STATUS CHANGED TO ANSWER-RCVD-LATE BY SYSTEM. ANSWER DEADLINE WAS : '+convert(varchar(12),@Date_Answer_Expected,101)+'          >> XM-001'
				update tblcase
				set status = 'ANSWER-RCVD-LATE' where Case_Id = @s_a_Case_Id
				exec F_Add_Activity_Notes @s_a_Case_Id=@s_a_Case_Id,@s_a_Notes_Type='Activity',@s_a_NDesc = @desc ,@s_a_UserID='SYSTEM',@i_a_ApplyToGroup = 0
				GOTO FINISH
			END
		END
		ELSE IF @s_a_FieldName ='Status' -- Update on 12-11-07 ::Provision for Status Hierarchy.
		BEGIN
			SET NOCOUNT ON
			IF @s_a_NewValueText = '21 days on hold PENDing Peer Review' OR @s_a_NewValueText = '21 days on hold pENDing IME Report' OR @s_a_NewValueText = '21 days on hold pENDing IME REPORT/PEER REVIEW'
			BEGIN
				IF EXISTS(SELECT 1 FROM MST_STATUS_LOG WHERE CASE_ID=@s_a_Case_Id)
				BEGIN
					UPDATE MST_STATUS_LOG SET STATUS_BIT = 1, DATE_CHANGED = getdate() WHERE CASE_ID=@s_a_Case_Id
				END
				ELSE
				BEGIN
					INSERT INTO MST_STATUS_LOG(CASE_ID,DATE_CHANGED,STATUS_BIT) VALUES(@s_a_Case_Id,getdate(),1)
				END
			END
			ELSE IF @s_a_OldValueText = '21 days on hold PENDing Peer Review' OR @s_a_OldValueText = '21 days on hold pENDing IME Report' OR @s_a_OldValueText = '21 days on hold pENDing IME REPORT/PEER REVIEW'
			BEGIN
					UPDATE MST_STATUS_LOG SET STATUS_BIT = 0 WHERE CASE_ID=@s_a_Case_Id
			END

			-- for settled status change
			IF @s_a_NewValueText = 'Settled'
			BEGIN
				IF EXISTS(SELECT 1 FROM TXN_ASSIGN_SETTLED_CASES WHERE CASE_ID=@s_a_Case_Id)
				BEGIN
					UPDATE TXN_ASSIGN_SETTLED_CASES SET isChanged = 1, DATE_CHANGED = getdate(), USER_ID = @s_a_UserID WHERE CASE_ID=@s_a_Case_Id
				END
				ELSE
				BEGIN
					INSERT INTO TXN_ASSIGN_SETTLED_CASES(CASE_ID,USER_ID,DATE_CHANGED,isChanged) VALUES(@s_a_Case_Id,@s_a_UserID,getdate(),1)
				END
			END
			ELSE IF @s_a_OldValueText = 'Settled'
			BEGIN
				UPDATE TXN_ASSIGN_SETTLED_CASES SET isChanged = 0 WHERE CASE_ID=@s_a_Case_Id
			END

			-- for answer received, ASSIGN CASE TO JOE, ERIN, DANA
			IF @s_a_NewValueText = 'ANSWER-RECD'
			BEGIN
				exec [SP_ASSIGN_REDCAT_DENIAL_REASONS] @s_a_Case_Id
			END


			SELECT @old_stat_hierc = STATUS_HIERARCHY FROM Tblstatus INNER JOIN TBLcase ON dbo.tblcase.status = dbo.tblstatus.status_Type
			where dbo.tblcase.case_id=@s_a_Case_Id AND dbo.tblcase.status=@s_a_OldValueText


			SELECT @motion_stat_hierc = STATUS_HIERARCHY FROM TblMotion_Status INNER JOIN TBLcase ON dbo.tblcase.Motion_Status = dbo.tblMotion_Status.status_desc
			where dbo.tblcase.case_id=@s_a_Case_Id

			SELECT @new_stat_hierc = STATUS_HIERARCHY ,@status_bill = auto_bill_amount ,@status_bill_type = auto_bill_type,
				   @status_bill_notes=auto_bill_notes
			FROM Tblstatus
			 where status_type=@s_a_NewValueText
			 
			IF ((@new_stat_hierc < @old_stat_hierc) OR (@new_stat_hierc < 900 AND @motion_stat_hierc = 1)) and @s_a_UserID <>'srosenthal'
			BEGIN
				set @desc = 'Status Hierarchy Constraint error :'+@s_a_FieldName +  ' cannot be changed from ' + @s_a_OldValueText + ' to ' + @s_a_NewValueText +'.  >>XM-003'       
				exec F_Add_Activity_Notes @s_a_Case_Id=@s_a_Case_Id,@s_a_Notes_Type='Activity',@s_a_NDesc = @desc,@s_a_UserID=@s_a_UserID,@i_a_ApplyToGroup = 0
				RETURN
			END

			IF @status_bill > 0
			BEGIN

				SELECT @provider_id=tblcase.provider_id ,@provider_ff = tblProvider.provider_ff 
				FROM   tblProvider INNER JOIN tblcase ON tblProvider.Provider_Id = tblcase.Provider_Id
				WHERE tblcase.case_id =@s_a_Case_Id

				IF NOT Exists(SELECT Case_ID From	TBLTRANSACTIONS WHERE TRANSACTIONS_TYPE = @status_bill_type and case_id = @s_a_case_id)
				BEGIN
					INSERT INTO TBLTRANSACTIONS(CASE_ID,TRANSACTIONS_TYPE,TRANSACTIONS_DATE,TRANSACTIONS_AMOUNT,TRANSACTIONS_DESCRIPTION,PROVIDER_ID,TRANSACTIONS_FEE,USER_ID)
					VALUES (@s_a_Case_Id,@status_bill_type,GETDATE(),@status_bill,@status_bill_notes,@PROVIDER_ID,@status_bill,@s_a_UserID)

					set @desc = 'Payment/Transaction posted :'+ CONVERT(VARCHAR(20),@status_bill) +' '+'('+ @status_bill_type +') Desc-> ' + @status_bill_notes + '. New Status-> '+ @s_a_NewValueText + ' .' 
					exec F_Add_Activity_Notes @s_a_Case_Id=@s_a_Case_Id,@s_a_Notes_Type='Activity',@s_a_NDesc = @desc,@s_a_UserID=@s_a_UserID,@i_a_ApplyToGroup = 0
				END
			END

			HOP1:

			END -- END of Hierachy update on 12/11/07

	BEGIN        
		IF @s_a_NewValueText is null
		BEGIN
			set @st = 'update tblcase set ' + @s_a_FieldName + '= NULL where Case_Id in ('''+@s_a_Case_Id + ''')'
		END	
		ELSE
		BEGIN
			set @st = 'update tblcase set ' + @s_a_FieldName + '= ''' + @s_a_NewValueText + ''' where Case_Id in ('''+@s_a_Case_Id + ''')'
		END    
          
		 print @st        
		 exec sp_Executesql @st  
		 
   
	END      
	FINISH:  
	
	IF(@s_a_FieldName='UserId')    
	BEGIN    
	 set @s_a_FieldName='Assigned To'    
	END    

	set @desc = @s_a_FieldName +  ' changed from ' + @s_a_OldValueText + ' to ' + @s_a_NewValueText       
	exec F_Add_Activity_Notes @s_a_Case_Id=@s_a_Case_Id,@s_a_Notes_Type='Activity',@s_a_NDesc = @desc,@s_a_UserID=@s_a_UserID,@i_a_ApplyToGroup = 0  
	
	
	
		 ---DateAAA_ResponceRecieved
	 IF(@s_a_FieldName='DateAAA_ResponceRecieved')  
	 BEGIN
		DECLARE @oldStatus NVARCHAR(200), @newStatus NVARCHAR(200),@newDesc nvarchar(1000)
		IF((SELECT DATEDIFF(DD,DateAAA_ResponceRecieved,Date_AAA_Concilation_Over) from tblcase where Case_Id = @s_a_Case_Id) < 0)
		BEGIN
			
			SET @oldStatus = (SELECT status FROM tblcase WHERE  Case_Id = @s_a_Case_Id)
			
			IF (@oldStatus ='AAA CONFIRMED')
				SET @newStatus ='AAA RESPONSE-RCVD-LATE'
			ELSE IF (@oldStatus ='AAA PPO CONFIRMED')
				SET @newStatus='AAA PPO RESPONSE-RCVD-LATE'
			ELSE
				SET @newStatus=''
				
			IF (@newStatus<>'')
			BEGIN	
				UPDATE tblcase
				SET Status=	@newStatus WHERE Case_Id = @s_a_Case_Id
				
				SET @newDesc = 'Status changed from ' + @oldStatus + ' to ' + @newStatus  
				
				exec F_Add_Activity_Notes @s_a_Case_Id=@s_a_Case_Id,@s_a_Notes_Type='Activity',@s_a_NDesc = @newDesc,@s_a_UserID='System',@i_a_ApplyToGroup = 0
			END
		END
		IF((SELECT DATEDIFF(DD,DateAAA_ResponceRecieved,Date_AAA_Concilation_Over) from tblcase where Case_Id = @s_a_Case_Id) >= 0)
		BEGIN
			
			
			SET @oldStatus = (SELECT status FROM tblcase WHERE  Case_Id = @s_a_Case_Id)
			IF (@oldStatus ='AAA CONFIRMED')
				SET @newStatus ='AAA RESPONSE RCVD'
			ELSE IF (@oldStatus ='AAA PPO CONFIRMED')
				SET @newStatus='AAA PPO RESPONSE RCVD'
			ELSE
				SET @newStatus=''
				
			IF (@newStatus<>'')
			BEGIN	
				UPDATE tblcase
				SET Status=	@newStatus WHERE Case_Id = @s_a_Case_Id
				
				SET @newDesc = 'Status changed from ' + @oldStatus + ' to ' + @newStatus  
				exec F_Add_Activity_Notes @s_a_Case_Id=@s_a_Case_Id,@s_a_Notes_Type='Activity',@s_a_NDesc = @newDesc,@s_a_UserID='System',@i_a_ApplyToGroup = 0
			END
		END
		
	 END       

END

