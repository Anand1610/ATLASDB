-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[TransferPayment] -- TransferPayment 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

   	DECLARE @Payment TABLE
		(
			ID INT IDENTITY(1,1),
			[AutoID] int,
			[CaseId] varchar(100) NOT NULL,
			[DomainId] VARCHAR(500) NULL,
			Provider_Id int ,
			CheckNo	 float NULL,
			CheckDate DATETIME NULL,
			CheckAmount	Money,
			PaymentDate	DATETIME NULL,
			BILL_NUMBER VARCHAR(100)
	    )


		--select * from tblTransactions
		INSERT INTO @Payment
			
		select autoid, t.case_id, t.DomainId, tblcase.Provider_Id, CheckNo,	CheckDate,	CheckAmount,	PaymentDate, BILL_NUMBER from [XN_Temp_Payment_Posting] p
		INNER join tblTreatment t on p.BillNumber =t.BILL_NUMBER
		INNER JOIN tblcase on tblcase.Case_Id = t.Case_Id and t.DomainId = tblcase.DomainId
		WHERE isnull(Transfer_Status,'') =''


		DECLARE @TotalCount INT = 0
		DECLARE @Counter INT = 1
		DECLARE @Notes varchar(2000)

		DECLARE @DomainId NVARCHAR(50),
		   @Case_Id nvarchar(3000),  
		   @Provider_Id nvarchar(50),  
		   @Transactions_Amount MONEY,  
		   @Transactions_Date DATETIME,  
		   @Transactions_Type NVARCHAR(10),  
		   @Transactions_Description nvarchar(3950),  
		   @User_Id nvarchar(100),  
		   @transactions_status varchar(10),  
		   @ChequeNo varchar(50),
		   @autoid int,
		   @PaymentDate Datetime,
		   @BILL_NUMBER varchar(200)

		SELECT @TotalCount = COUNT(*) FROM @Payment

		WHILE(@Counter <= @TotalCount)
		BEGIN
			SELECT	@autoid = autoid,
					@Case_Id = CaseId, 
					@Provider_Id = provider_id,
					@DomainId = DomainId,
					@Transactions_Amount = CheckAmount,
					@Transactions_Date = CheckDate,
					@Transactions_Type = 'PreC',
					@Transactions_Description = BILL_NUMBER,
					@User_Id = 'admin',
					@transactions_status = '',
					@PaymentDate = PaymentDate,
					@ChequeNo =CheckNo
			FROM	@Payment WHERE ID = @Counter


			--select *  FROM	@Payment WHERE ID = @Counter
			
			
				set @Notes = 'Payment/Transaction posted :'+' $'+ CONVERT(VARCHAR(10),@Transactions_Amount)++' '+'('+ @Transactions_Type+') Desc->'+@Transactions_Description
					
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
						@PaymentDate,
						@User_Id,
						@DomainId
					)
			-- 
					--Transactions_Fee 
					DECLARE @Transactions_Fee MONEY =0.00
					

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
					   ChequeNo
					  )  
					  VALUES
					  (  
					   @Case_Id,  
					   @Provider_Id,  
					   @Transactions_Amount,  
					   Convert(nvarchar(15), @Transactions_Date, 101),     
					   @Transactions_Type,  
					   @Transactions_Description,  
					   isnull(@Transactions_Fee,0.00),
					   @User_Id,
					   @DomainId,
					   @ChequeNo  
					  )  
					print @Case_Id + '-Done'
					UPDATE XN_Temp_Payment_Posting
					SET Transfer_Status = 'Done'							
					Where autoid = @autoid

				COMMIT TRAN 
				
				
				SET @autoid = null
				SET @Case_Id = null
				SET @DomainId = null
				SET @Provider_Id = null
				SET @Transactions_Amount = null
				SET @Transactions_Date = null
				SET @Transactions_Type = null
				SET @Transactions_Description = null
				SET @User_Id = null
				SET @transactions_status = null
				SET @PaymentDate = null
				SET @ChequeNo = null

				SET @Counter = @Counter + 1
		 
			END

			
		
END
