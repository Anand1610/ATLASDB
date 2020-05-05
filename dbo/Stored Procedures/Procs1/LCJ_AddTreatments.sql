

CREATE PROCEDURE [dbo].[LCJ_AddTreatments]
(
	@DomainId NVARCHAR(50),
	@Case_Id nvarchar(100),
	@DateOfService_Start DATETIME,
	@DateOfService_End DATETIME,
	@Claim_Amount MONEY,
	@Paid_Amount MONEY,
	@Date_BillSent	DATETIME,
	@DenialReason_ID INT,
	@ServiceType NVARCHAR(300),
	@PeerReviewDoctor INT,
	@UserID nvarchar(100),
	@Account_Number varchar(50),
	@Fee_Schedule numeric(18,2),
	@TreatingDoctor_ID int ,
	@RefundDate DateTime = null,
	@WriteOff MONEY,
	@DeductibleAmount DECIMAL(19,2) = 0.00
	--@DenialReasons_Type nvarchar(200)
            --@Treatment_Id int
)
AS
DECLARE @NOTES VARCHAR(200)
		
BEGIN
	
	BEGIN
-- following if/then loop added by Serge on 9/22/08
if @claim_amount < @Paid_amount
BEGIN
SET @NOTES ='Bill Processing Cancelled.Incorrect Bill amount entered for DOS ' + convert(varchar(20),@DateOfService_Start) + ' - ' + convert(varchar(20),@DateOfService_end) + '.  >>XM-005'
	exec LCJ_AddNotes @DomainId=@DomainId,@case_id=@case_id,@notes_type='Activity',@Ndesc=@NOTES,@User_id='SYSTEM',@Applytogroup=0
	RETURN
END
--End of update done by SJR on 9/22/08
DECLARE @Treatment_Id INT
		BEGIN TRAN
		DECLARE @dt_l_Denial_Posted DATETIME 

		IF(@DenialReason_ID IS NOT NULL)
			SET @dt_l_Denial_Posted = GETDATE()

		--set @DenialReason_ID=(select DenialReasons_Id from tblDenialReasons where DenialReasons_Type=@DenialReasons_Type)
		INSERT INTO tblTreatment
		(
			Case_Id,
			DateOfService_Start,
			DateOfService_End,
			Claim_Amount,
			Paid_Amount,
			Date_BillSent,
			SERVICE_TYPE,
			BILL_NUMBER,
			Fee_schedule,
			DenialReason_Id,
			PeerReviewDoctor_ID,
			TreatingDoctor_ID,
			Denial_Posted_Date,
			DomainId,
			Refund_Date,
			WriteOff,
			DeductibleAmount
		)

		VALUES(
		
			@Case_Id,
			Convert(nvarchar(15), @DateOfService_Start, 101),
			Convert(nvarchar(15), @DateOfService_End, 101),			
			@Claim_Amount,
			@Paid_Amount,
			@Date_BillSent,
			@ServiceType,
			@Account_Number,
			case when @DomainId='af' then 0 else @Fee_Schedule end ,
			@DenialReason_ID,
			@PeerReviewDoctor,
			@TreatingDoctor_ID,
			@dt_l_Denial_Posted,
			@DomainId,
			@RefundDate,
			@WriteOff,
			@DeductibleAmount
			--@CPT_Id
		)	
		SET @Treatment_Id=(SELECT SCOPE_IDENTITY())
		SET @NOTES = 'Bill added for DOS ' + convert(varchar(12),@DateOfService_Start) + ' - ' + convert(varchar(12),@DateOfService_end)
		exec LCJ_AddNotes @DomainId=@DomainId, @case_id=@case_id,@notes_type='Activity',@Ndesc=@NOTES,@User_id=@UserID,@Applytogroup=0

		COMMIT TRAN

		---Start of  changes for LSS-440 done on 21 APRIL 2020  By Tushar Chandgude
           IF(@DenialReason_ID IS NOT NULL)
		exec Update_Denial_Case @Case_Id
         ---End   of  changes for LSS-440 done on 21 APRIL 2020  By Tushar Chandgude

		IF(@DomainId='AMT')
		BEGIN
			
				INSERT INTO BILLS_WITH_PROCEDURE_CODES(BillNumber,
													    Code,
														Description,
													    Amount,
														DOS,
														Specialty,
														fk_Treatment_Id,	
														Case_ID,
														DomainID,		
														created_by_user,
														created_date,
														ins_fee_schedule) 
														VALUES('',
															   @ServiceType,
															   '',
															   @Claim_Amount,
															   Convert(nvarchar(15), @DateOfService_Start, 101),
															   @ServiceType,
															   @Treatment_Id,
															   @Case_Id,
															   @DomainId,
															   @UserID,
															   GETDATE(),
															   @Fee_Schedule
															   )

															   UPDATE tblTreatment SET 
																		Claim_Amount=Claim_Amount-@Claim_Amount ,
																		Fee_schedule=(Fee_schedule-@Fee_Schedule)
																		WHERE Treatment_Id=@Treatment_Id
																		AND   Case_Id=@Case_Id
															      
		END
	END -- END of ELSE	

END
