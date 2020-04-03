CREATE PROCEDURE [dbo].[USP_AddProviderCaseBillDetail]
--USP_AddProviderCaseBillDetail 'PRIYA','PRIYA17-100008','10/12/2014','10/12/2015',500,10,'20/10/2015',0,'',0,'ACPUSER22','225K','',0,0
(
	@DomainId NVARCHAR(50),
	@Case_Id nvarchar(100),
	@DateOfService_Start DATETIME,
	@DateOfService_End DATETIME,
	@Claim_Amount MONEY,
	@Paid_Amount MONEY,
	@Date_BillSent	nvarchar(100),
	@DenialReasons_Type nvarchar(100),
	@ServiceType NVARCHAR(300),
	@PeerReviewDoctor INT,
	@UserID nvarchar(100),
	@Account_Number varchar(50),
	@ActionType nvarchar(100),
	@Fee_Schedule numeric(18,2),
	@TreatingDoctor_ID int 
	
)
AS
DECLARE @NOTES VARCHAR(200)
		
BEGIN
	
	BEGIN

UPDATE tblprovidercase 
		SET DateOfService_Start=@DateOfService_Start
			,DateOfService_End= @DateOfService_End
			,Claim_Amount=@Claim_Amount
			,Paid_Amount=@Paid_Amount
			,Date_BillSent=@Date_BillSent
			WHERE Case_Id=@Case_Id AND  DomainID=@DomainId

-- following if/then loop added by Serge on 9/22/08
if @claim_amount < @Paid_amount
BEGIN
SET @NOTES ='Bill Processing Cancelled.Incorrect Bill amount entered for DOS ' + convert(varchar(20),@DateOfService_Start) + ' - ' + convert(varchar(20),@DateOfService_end) + '.  >>XM-005'
	exec LCJ_AddNotes @DoaminId=@DomainId,@case_id=@case_id,@notes_type='Activity',@Ndesc=@NOTES,@User_id='SYSTEM',@Applytogroup=0
	RETURN
END
--End of update done by SJR on 9/22/08
		BEGIN TRAN
		DECLARE @DenialReason_ID INT
        set @DenialReason_ID=(select DenialReasons_Id from tblDenialReasons where DenialReasons_Type=@DenialReasons_Type and DomainID=@DomainId)
		INSERT INTO tblProviderCaseBillDetail
		(
			Case_Id,
			DateOfService_Start,
			DateOfService_End,
			Claim_Amount,
			Paid_Amount,
			Date_BillSent,
			SERVICE_TYPE,
			Account_Number,
			Fee_schedule,
			PeerReviewDoctor_ID,
			TreatingDoctor_ID,
			DomainId,
			DenialReason_ID,
			DenialReasons_Type
		)
		VALUES(		
			@Case_Id,
			@DateOfService_Start,
			@DateOfService_End,			
			@Claim_Amount,
			@Paid_Amount,
			@Date_BillSent,
			@ServiceType,
			@Account_Number,
			@Fee_Schedule,			
			@PeerReviewDoctor,
			@TreatingDoctor_ID,
			@DomainId
		   ,@DenialReason_ID
		  ,@DenialReasons_Type
		)	
		

		

		SET @NOTES = 'Bill added for DOS ' + convert(varchar(12),@DateOfService_Start) + ' - ' + convert(varchar(12),@DateOfService_end)
		exec LCJ_AddNotes @DomainId=@DomainId, @case_id=@case_id,@notes_type='Activity',@Ndesc=@NOTES,@User_id=@UserID,@Applytogroup=0

		COMMIT TRAN
	END -- END of ELSE	

END

