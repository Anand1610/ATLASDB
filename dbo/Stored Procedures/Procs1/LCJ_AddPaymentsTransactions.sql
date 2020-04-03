CREATE PROCEDURE [dbo].[LCJ_AddPaymentsTransactions]  
--[LCJ_AddPaymentsTransactions] 'amt','AMT18-102836','22','10.00','12/10/2018','PreC','test1','ls-admin',NULL,'5465738','11/27/2018','x',NULL
(  
   @DomainId	VARCHAR(50),
   @Case_Id		varchar(50),  
   @Provider_Id VARCHAR(50),  
   @Transactions_Amount MONEY,  
   @Transactions_Date DATETIME,  
   @Transactions_Type VARCHAR(10),  
   @Transactions_Description VARCHAR(3950),  
   @User_Id varchar(50),  
   @transactions_status varchar(10),  
   @ChequeNo varchar(50),
   @CheckDate Datetime = Null,
   @BatchNo varchar(100),
   @TreatmentIds varchar(500) = NULL
)  
AS  

DECLARE @notes VARCHAR(4000),@initial_status varchar(50)
set @Notes = 'Payment/Transaction posted :'+' $'+ CONVERT(VARCHAR(10),@Transactions_Amount)++' '+'('+ @Transactions_Type+') Desc->'+@Transactions_Description

BEGIN  
	BEGIN  
  -- Insert the records  
		BEGIN TRAN  
			INSERT INTO tblNotes
			(
				Notes_Desc,
				Notes_Type,
				Notes_Priority,
				Case_Id,
				Notes_Date,
				User_Id,
				DomainId
			)
			VALUES
			(
				@Notes,
				'Activity',
				'0',
				@Case_Id,
				getdate(),
				@User_Id,
				@DomainId
			)
			-- 
			--Transactions_Fee 
			DECLARE @Transactions_Fee MONEY =0.00
			-- Bit to update prelit cases paid amount
			DECLARE @i_a_ACTIVE_CASE INT = 0
			 DECLARE @newStatusHierarchy int
			DECLARE @oldStatusHierarchy int

			
			 
			IF ((@Transactions_Type = 'C' or @Transactions_Type = 'PreC' or @Transactions_Type = 'PreCToP' or @Transactions_Type = 'PreI') AND @Case_Id NOT like 'ACT%')
			BEGIN
				SET @Transactions_Fee = (select @Transactions_Amount * (SELECT  isnull(Provider_Billing,0) FROM TBLPROVIDER WHERE PROVIDER_ID=@Provider_Id and DomainId=@DomainId) /100 )
			END
			ELSE IF ((@Transactions_Type = 'C' or @Transactions_Type = 'PreC' or @Transactions_Type = 'PreCToP' or @Transactions_Type = 'PreI') AND @Case_Id like 'ACT%')
			BEGIN
				SET @Transactions_Fee = (select @Transactions_Amount * (SELECT  isnull(Provider_Initial_Billing,0) FROM TBLPROVIDER WHERE PROVIDER_ID=@Provider_Id and DomainId=@DomainId) /100 )
				SET @i_a_ACTIVE_CASE = 1
			END
			ELSE IF (@Transactions_Type = 'I' AND @Case_Id NOT like 'ACT%')
			BEGIN
				SET @Transactions_Fee = (select @Transactions_Amount * (SELECT  isnull(Provider_IntBilling,0) FROM TBLPROVIDER WHERE PROVIDER_ID=@Provider_Id and DomainId=@DomainId) /100 )
			END
			ELSE IF (@Transactions_Type = 'I' AND @Case_Id like 'ACT%')
			BEGIN
				SET @Transactions_Fee = (select @Transactions_Amount * (SELECT  isnull(Provider_Initial_IntBilling,0) FROM TBLPROVIDER WHERE PROVIDER_ID=@Provider_Id and DomainId=@DomainId) /100 )
			END


			IF @transactions_status = 'X'  
			BEGIN  
			  INSERT INTO tblTransactions  
			  (  
			   Case_Id,  
			   Provider_Id,  
			   Transactions_Amount,  
			   Transactions_Date,  
			   Transactions_Type,  
			   Transactions_Description,  
			   User_id,  
			   Transactions_status,
			   Transactions_Fee,
			   DomainId,
			   ChequeNo,
			   CheckDate,
			   BatchNo,
			   TreatmentIds
			  )  
			  VALUES
			  (  
			   @Case_Id,  
			   @Provider_Id,  
			   @Transactions_Amount,  
			   Convert(VARCHAR(15), @Transactions_Date, 101),     
			   @Transactions_Type,  
			   @Transactions_Description,  
			   @User_Id,  
			   @transactions_status ,
			   isnull(@Transactions_Fee,0.00),
			   @DomainId,
			   @ChequeNo,
			   @CheckDate,
			   @BatchNo,
			   @TreatmentIds
			  )       
			END  
			ELSE  
			BEGIN  
			  INSERT INTO tblTransactions  
			  (  
			   Case_Id,  
			   Provider_Id,  
			   Transactions_Amount,  
			   Transactions_Date,  
			   Transactions_Type,  
			   Transactions_Description,  
			   Transactions_Fee,
			   User_id ,
			   DomainId,
			   ChequeNo,
			   CheckDate,
			   BatchNo,
			   TreatmentIds
			  )  
			  VALUES
			  (  
			   @Case_Id,  
			   @Provider_Id,  
			   @Transactions_Amount,  
			   Convert(VARCHAR(15), @Transactions_Date, 101),     
			   @Transactions_Type,  
			   @Transactions_Description,  
			   isnull(@Transactions_Fee,0.00),
			   @User_Id,
			   @DomainId,
			   @ChequeNo,
			   @CheckDate,
			   @BatchNo,
			   @TreatmentIds
			  )  
			END  

			
		
IF(@Transactions_Type IN ('PreC','PreCToP','PreI'))
			BEGIN
				DECLARE @i_l_Treat_Count INT 
				DECLARE @d_Transactions_Amount MONEY

				If(@TreatmentIds is not null and @TreatmentIds != '')
				BEGIN
					SET @i_l_Treat_Count = (select ISNULL(count(case_id),0) from tblTreatment where DomainId=@DomainId and Case_Id=@Case_Id and Treatment_Id in (Select items from SplitStringInt(@TreatmentIds, ',')))
					SET @d_Transactions_Amount = @Transactions_Amount

					IF(@i_l_Treat_Count = 1)
					BEGIN
						IF(@Transactions_Type = 'PreI')
							BEGIN

								IF(@DomainId <> 'BT')
									BEGIN

										UPDATE tblTreatment 
										SET Paid_Amount = @Transactions_Amount + ISNULL(Paid_Amount,0) WHERE DomainId=@DomainId 
										and Case_Id = @Case_Id 
										and Treatment_Id in (Select items from SplitStringInt(@TreatmentIds, ',') )

									END

							END

						ELSE
							BEGIN
								
								UPDATE tblTreatment 
								SET Paid_Amount = @Transactions_Amount + ISNULL(Paid_Amount,0) WHERE DomainId=@DomainId 
								and Case_Id = @Case_Id 
								and Treatment_Id in (Select items from SplitStringInt(@TreatmentIds, ',') )

							END
					END
					ELSE IF(@i_l_Treat_Count > 0)
					BEGIN
						
						IF(@Transactions_Type = 'PreI')
							BEGIN

								IF(@DomainId <> 'BT')
									BEGIN

										UPDATE tblTreatment 
										SET Paid_Amount = CONVERT(MONEY,(@d_Transactions_Amount/@i_l_Treat_Count)) + ISNULL(Paid_Amount,0) 
										WHERE DomainId=@DomainId and Case_Id = @Case_Id and Treatment_Id in (Select items from SplitStringInt(@TreatmentIds, ','))

									END

							END

						ELSE
							BEGIN
								
								UPDATE tblTreatment 
								SET Paid_Amount = CONVERT(MONEY,(@d_Transactions_Amount/@i_l_Treat_Count)) + ISNULL(Paid_Amount,0) 
								WHERE DomainId=@DomainId and Case_Id = @Case_Id and Treatment_Id in (Select items from SplitStringInt(@TreatmentIds, ','))

							END
						
					END
				END
				ELSE
				BEGIN

					SET @i_l_Treat_Count = (select ISNULL(count(case_id),0) from tblTreatment where DomainId=@DomainId and Case_Id=@Case_Id)
					IF(@DomainId = 'AF')
						BEGIN
							SET @d_Transactions_Amount = (select ISNULL(SUM(Transactions_Amount),0) from tblTransactions where DomainId=@DomainId and Case_Id=@Case_Id and Transactions_Type IN ('PreC','PreCToP','PreI'))
						END
					ELSE
						BEGIN
							SET @d_Transactions_Amount = (select ISNULL(SUM(Transactions_Amount),0) from tblTransactions where DomainId=@DomainId and Case_Id=@Case_Id and Transactions_Type IN ('PreC','PreCToP'))
						END
					

					IF(@i_l_Treat_Count = 1)
					BEGIN
						IF(@Transactions_Type = 'PreI')
							BEGIN

								IF(@DomainId <> 'BT')
									BEGIN

										UPDATE tblTreatment SET Paid_Amount = @Transactions_Amount  + ISNULL(Paid_Amount,0) WHERE DomainId=@DomainId and Case_Id = @Case_Id

									END

							END

						ELSE
							BEGIN

								UPDATE tblTreatment SET Paid_Amount = @Transactions_Amount  + ISNULL(Paid_Amount,0) WHERE DomainId=@DomainId and Case_Id = @Case_Id

							END
						
					END
					ELSE IF(@i_l_Treat_Count > 0)
					BEGIN

						IF(@Transactions_Type = 'PreI')
							BEGIN

								IF(@DomainId <> 'BT')
									BEGIN

										UPDATE tblTreatment SET Paid_Amount = CONVERT(MONEY,(@d_Transactions_Amount/@i_l_Treat_Count))  + ISNULL(Paid_Amount,0) WHERE DomainId=@DomainId and Case_Id = @Case_Id

									END

							END

						ELSE
							BEGIN

								UPDATE tblTreatment SET Paid_Amount = CONVERT(MONEY,(@d_Transactions_Amount/@i_l_Treat_Count))  + ISNULL(Paid_Amount,0) WHERE DomainId=@DomainId and Case_Id = @Case_Id

							END
						
					END
				END

				DECLARE @s_l_OldStatus VARCHAR(200)
				DECLARE @s_l_NewStatus VARCHAR(200)
				DECLARE @s_l_DESC VARCHAR(200)

				IF Exists(SELECT 1 FROM tblCASE WHERE case_id = @Case_Id and DomainId IN ('AF', 'JL', 'LOCALHOST') and Status <> 'IN ARB OR LIT' and case_id like 'ACT%') --and @DomainID IN ('AF','LOCALHOST')
				BEGIN

					SET @s_l_OldStatus = (SELECT Status FROM tblCASE WHERE case_id = @Case_Id and DomainId = @DomainId)
						if exists(select Case_AutoId from tblCASE where DomainId='af' and  Case_Id=@Case_Id and Paid_Amount>=Claim_Amount)
						 begin
							SET @s_l_NewStatus = 'BILLING - PAID IN FULL'
						 end
						 else if(@DomainID = 'JL')
							SET @s_l_NewStatus = 'PAID'
						 else
						 begin
							
							SET @s_l_NewStatus = 'BILLING - PAYMENT'
						 end
						  SET @oldStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@s_l_OldStatus)
							 SET @newStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@s_l_NewStatus)
							 -- if(@newStatusHierarchy>=@oldStatusHierarchy)
							 if(@newStatusHierarchy>=@oldStatusHierarchy OR ((@newStatusHierarchy = 0 OR @oldStatusHierarchy = 0) AND @DomainID in ('AMT','PDC')))
							BEGIN
								SET @s_l_DESC = 'Status changed from ' + @s_l_OldStatus  + ' to ' + @s_l_NewStatus

								UPDATE TBLCASE SET STATUS = @s_l_NewStatus WHERE Case_Id = @Case_Id

								exec LCJ_AddNotes @DomainId=@DomainId, @case_id=@Case_Id,@notes_type='Activity' ,@NDesc=@s_l_DESC,@user_id='system',@applytogroup=0

						    end
							ELSE
							BEGIN
								SET @s_l_DESC = 'Can not change the status from ' + @s_l_OldStatus  + ' to ' + @s_l_NewStatus

								--UPDATE TBLCASE SET STATUS = @s_l_NewStatus WHERE Case_Id = @Case_Id

								exec LCJ_AddNotes @DomainId=@DomainId, @case_id=@Case_Id,@notes_type='Activity' ,@NDesc=@s_l_DESC,@user_id='system',@applytogroup=0
							END
				ENd

			END


			IF (@Transactions_Type IN ('PreC','C','AF','FFB') and @DomainId='amt') --,'C','AF','FFB'
			BEGIN
			DECLARE @count INT, @count1 int, @count2 int, @count3 int
			
			set @count = ISNULL((select count(*) from tblTransactions where Transactions_Type in ('PreC') and case_id=@Case_Id and DomainId=@DomainId),0)
			set @count1 = ISNULL((select count(*) from tblTransactions where Transactions_Type in ('C') and case_id=@Case_Id and DomainId=@DomainId),0)
			set @count2 = ISNULL((select count(*) from tblTransactions where Transactions_Type in ('AF') and case_id=@Case_Id and DomainId=@DomainId),0)
			set @count3 = ISNULL((select count(*) from tblTransactions where Transactions_Type in ('FFB') and case_id=@Case_Id and DomainId=@DomainId),0)
			--print PreC
				IF (@count = 1)
				BEGIN
					INSERT INTO tblTransactions_Details
					(
					Case_Id,
					DomainId,
					TT_PreC_1,
					TD_PreC_1,
					TC_PreC_1,
					TCN_PreC_1
					)
					VALUES
					(
					@Case_Id,@DomainId,@Transactions_Amount,@Transactions_Date,@CheckDate,@ChequeNo
					)
					--print 'b'
				END
				ELSE IF (@count = 2)
				BEGIN
					
					UPDATE tblTransactions_Details SET TT_PreC_2 = @Transactions_Amount,
					TD_PreC_2= @Transactions_Date, TC_PreC_2 = @CheckDate, TCN_PreC_2=@ChequeNo WHERE Case_Id =@Case_Id and DomainId=@DomainId
					--print 'c'
				END
				ELSE IF (@count = 3)
				BEGIN
					UPDATE tblTransactions_Details SET TT_PreC_3 = @Transactions_Amount,
					TD_PreC_3 = @Transactions_Date, TC_PreC_3 = @CheckDate, TCN_PreC_3=@ChequeNo WHERE Case_Id =@Case_Id and DomainId=@DomainId
					--print 'd'
				END
				
				--print C
				IF (@count1 = 1)
				BEGIN
					INSERT INTO tblTransactions_Details
					(
					Case_Id,
					DomainId,
					TT_C_1,
					TD_C_1,
					TC_C_1,
					TCN_C_1
					)
					VALUES
					(
					@Case_Id,@DomainId,@Transactions_Amount,@Transactions_Date,@CheckDate,@ChequeNo
					)
					--print 'b'
				END
				ELSE IF (@count1 = 2)
				BEGIN
					
					UPDATE tblTransactions_Details SET TT_C_2 = @Transactions_Amount,
					TD_C_2= @Transactions_Date, TC_C_2 = @CheckDate, TCN_C_2=@ChequeNo WHERE Case_Id =@Case_Id and DomainId=@DomainId
					--print 'c'
				END
				ELSE IF (@count1 = 3)
				BEGIN
					UPDATE tblTransactions_Details SET TT_C_3 = @Transactions_Amount,
					TD_C_3 = @Transactions_Date, TC_C_3 = @CheckDate, TCN_C_3=@ChequeNo WHERE Case_Id =@Case_Id and DomainId=@DomainId
					--print 'd'
				END

				--print AF
				IF (@count2 = 1)
				BEGIN
					INSERT INTO tblTransactions_Details
					(
					Case_Id,
					DomainId,
					TT_AF_1,
					TD_AF_1,
					TC_AF_1,
					TCN_AF_1
					)
					VALUES
					(
					@Case_Id,@DomainId,@Transactions_Amount,@Transactions_Date,@CheckDate,@ChequeNo
					)
					--print 'b'
				END
				ELSE IF (@count2 = 2)
				BEGIN
					
					UPDATE tblTransactions_Details SET TT_AF_2 = @Transactions_Amount,
					TD_AF_2= @Transactions_Date, TC_AF_2 = @CheckDate, TCN_AF_2=@ChequeNo WHERE Case_Id =@Case_Id and DomainId=@DomainId
					--print 'c'
				END
				ELSE IF (@count2 = 3)
				BEGIN
					UPDATE tblTransactions_Details SET TT_AF_3 = @Transactions_Amount,
					TD_AF_3 = @Transactions_Date, TC_AF_3 = @CheckDate, TCN_AF_3=@ChequeNo WHERE Case_Id =@Case_Id and DomainId=@DomainId
					--print 'd'
				END

				--print FFB
				IF (@count3 = 1)
				BEGIN
					INSERT INTO tblTransactions_Details
					(
					Case_Id,
					DomainId,
					TT_FF_1,
					TD_FF_1,
					TC_FF_1,
					TCN_FF_1
					)
					VALUES
					(
					@Case_Id,@DomainId,@Transactions_Amount,@Transactions_Date,@CheckDate,@ChequeNo
					)
					--print 'b'
				END
				ELSE IF (@count3 = 2)
				BEGIN
					
					UPDATE tblTransactions_Details SET TT_FF_2 = @Transactions_Amount,
					TD_FF_2= @Transactions_Date, TC_FF_2 = @CheckDate, TCN_FF_2=@ChequeNo WHERE Case_Id =@Case_Id and DomainId=@DomainId
					--print 'c'
				END
				ELSE IF (@count3 = 3)
				BEGIN
					UPDATE tblTransactions_Details SET TT_FF_3 = @Transactions_Amount,
					TD_FF_3 = @Transactions_Date, TC_FF_3 = @CheckDate, TCN_FF_3=@ChequeNo WHERE Case_Id =@Case_Id and DomainId=@DomainId
					--print 'd'
				END
				
			END
		
			--SET NOCOUNT ON
			--	IF EXISTS (SELECT dbo.[SJR-SETTLED_PAYMENTS_FULL].Case_Id, dbo.[SJR-SETTLED_PAYMENTS_FULL].Payments, dbo.[SJR-SETTLEMENTS_FULL].Sett_tot,
			--			dbo.[SJR-SETTLEMENTS_FULL].STATUS
			--			FROM         dbo.[SJR-SETTLED_PAYMENTS_FULL] INNER JOIN
			--			dbo.[SJR-SETTLEMENTS_FULL] ON dbo.[SJR-SETTLED_PAYMENTS_FULL].Case_Id = dbo.[SJR-SETTLEMENTS_FULL].Case_Id  INNER JOIN
			--			dbo.TBLCASE ON dbo.TBLCASE.CASE_ID = dbo.[SJR-SETTLEMENTS_FULL].Case_Id
			--			WHERE (dbo.[SJR-SETTLEMENTS_FULL].Sett_tot <= dbo.[SJR-SETTLED_PAYMENTS_FULL].Payments+30)AND (dbo.Tblcase.Case_id = @Case_ID)
			--			and dbo.[SJR-SETTLEMENTS_FULL].status not like '%CLOSED%'
			--			and dbo.[SJR-SETTLED_PAYMENTS_FULL].DomainId = @DomainId)
			--	BEGIN 
			--			UPDATE TBLCASE 
			--			SET STATUS ='CLOSED',Date_Closed=GETDATE()
			--			FROM  dbo.[SJR-SETTLED_PAYMENTS_FULL] INNER JOIN
			--			dbo.[SJR-SETTLEMENTS_FULL] ON dbo.[SJR-SETTLED_PAYMENTS_FULL].Case_Id = dbo.[SJR-SETTLEMENTS_FULL].Case_Id  INNER JOIN
			--			dbo.TBLCASE ON dbo.TBLCASE.CASE_ID = dbo.[SJR-SETTLEMENTS_FULL].Case_Id
			--			WHERE (dbo.[SJR-SETTLEMENTS_FULL].Sett_tot <= dbo.[SJR-SETTLED_PAYMENTS_FULL].Payments+30)AND (dbo.Tblcase.Case_id = @Case_ID)
			--			and dbo.[SJR-SETTLED_PAYMENTS_FULL].DomainId = @DomainId

			--		exec LCJ_AddNotes @DomainId=@DomainId,@case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = 'Case automatically closed by system .All payments received.    >>XM-002',@user_Id='SYSTEM',@ApplyToGroup = 0
			--	END
			--SET NOCOUNT OFF
	   IF Exists(SELECT 1 FROM tblCASE WHERE case_id = @Case_Id and DomainId IN ('AF','JL','LOCALHOST') and Status <> 'IN ARB OR LIT' and case_id like 'ACT%') --and @DomainID IN ('AF','LOCALHOST')
				BEGIN

					SET @s_l_OldStatus = (SELECT Status FROM tblCASE WHERE case_id = @Case_Id and DomainId = @DomainId)
					if exists(select Case_AutoId from tblCASE where DomainId='af' and  Case_Id=@Case_Id and Paid_Amount>=Claim_Amount)
						 begin
							

						 IF(@DomainID = 'JL')
							SET @s_l_NewStatus = 'PAID'
						 ELSE
							SET @s_l_NewStatus = 'BILLING - PAID IN FULL'

							SET @s_l_DESC = 'Status changed from ' + @s_l_OldStatus  + ' to ' + @s_l_NewStatus

							
							 SET @oldStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@s_l_OldStatus)
							 SET @newStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@s_l_NewStatus)
							--  if(@newStatusHierarchy>=@oldStatusHierarchy)
							if(@newStatusHierarchy>=@oldStatusHierarchy OR ((@newStatusHierarchy = 0 OR @oldStatusHierarchy = 0) AND @DomainID in ('AMT','PDC')))
							BEGIN
								UPDATE TBLCASE SET STATUS = @s_l_NewStatus WHERE Case_Id = @Case_Id
								exec LCJ_AddNotes @DomainId=@DomainId, @case_id=@Case_Id,@notes_type='Activity' ,@NDesc=@s_l_DESC,@user_id='system',@applytogroup=0
							END
							ELSE
							BEGIN
							 SET @s_l_DESC ='can not change status from '+ @s_l_OldStatus  + ' to ' + @s_l_NewStatus
							exec LCJ_AddNotes @DomainId=@DomainId, @case_id=@Case_Id,@notes_type='Activity' ,@NDesc=@s_l_DESC,@user_id='system',@applytogroup=0
							END

								
						 end
						 
					
				ENd
		COMMIT TRAN  
   END -- END of ELSE   
END

