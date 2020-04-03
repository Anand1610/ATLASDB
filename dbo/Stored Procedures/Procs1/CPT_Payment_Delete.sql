CREATE PROCEDURE [dbo].[CPT_Payment_Delete] 
	@Case_ID NVARCHAR(50),
	@Transaction_ID INT,
	@DomainID NVARCHAR(50)
AS
BEGIN
     
     SET NOCOUNT ON;
	 Declare @IsSuccess varchar(50) = '';
	 BEGIN TRY
		 BEGIN TRAN  
			 Declare @Payment_Type varchar(10);
    
			 Select @Payment_Type = LTRIM(RTRIM(Payment_Type)) 
			 From tbl_Voluntary_Payment(NOLOCK) 
			 Where Voluntary_Pay_Id = @Transaction_ID and Case_Id = @Case_ID and DomainId = @DomainID

			 If(@Payment_Type='V')
			 BEGIN
				Declare @tblCPT CPTBillsUpdate;

				Insert into @tblCPT(TCPT_ATUO_ID, TCollectedAmount,TDeductible,TIntrest,TAttorneyFee,TDomainID)
				Select B.CPT_ATUO_ID, (CollectedAmount - Current_Paid),(Deductible - Current_Deductible),(Intrest - Current_Interest),
				(AttorneyFee - Current_AttorneyFee), P.Domainid
				from tbl_CPT_Payment_Details P (NOLOCK)  inner join BILLS_WITH_PROCEDURE_CODES B (NOLOCK) ON B.CPT_ATUO_ID=P.CPT_ATUO_ID
				where P.Case_ID=@Case_ID and Transaction_Id = @Transaction_ID and P.Domainid=@DomainID

				Exec BillsProcedure_CPT_Update @tblCPT
			 END
			 Else If(@Payment_Type = 'L')
			 BEGIN
			   Declare @tblCPTLIT CPTBillsUpdateLIT;
	   
			   Insert into @tblCPTLIT(TCPT_ATUO_ID, TLITCollectedAmount,TLITIntrest,TLITFees,TCourtFees,TDomainID)
				Select B.CPT_ATUO_ID, (LITCollectedAmount - Current_LIT_Paid),(LITIntrest - Current_LIT_Interest),
				(LITFees - Current_LIT_Fees),(CourtFees - Current_LIT_CourtFee), P.Domainid
				from tbl_CPT_Payment_Details P (NOLOCK) inner join BILLS_WITH_PROCEDURE_CODES B (NOLOCK) ON B.CPT_ATUO_ID=P.CPT_ATUO_ID
				where P.Case_ID=@Case_ID and Transaction_Id = @Transaction_ID and P.Domainid=@DomainID

				Exec BillsProcedure_CPT_Update_LIT @tblCPTLIT
			 END
	
			DELETE FROM tbl_CPT_Payment_Details 
			WHERE
			Case_ID=@Case_ID
			AND Transaction_Id=@Transaction_ID
			AND Domainid=@DomainID
	
			COMMIT TRAN
			SET @IsSuccess = 'success';
	 END TRY
	 BEGIN CATCH
			ROLLBACK
			SET @IsSuccess = 'failed';
	 END CATCH

	 Select @IsSuccess
END
