
--exec PortfolioSettlementViewForClient 17,'cc' 
--select * from tbl_Portfolio where DomainId = 'cc'
 
CREATE PROCEDURE [dbo].[PortfolioSettlementViewForClient]    --  
(  
	@PortfolioId INT ,  
	@DomainId VARCHAR(50),  
	@SettlementDate DATE = NULL  
 )   
AS      
BEGIN    

SET NOCOUNT ON
   
DECLARE @CounterInsert INT = 1  
DECLARE @TotalCountInsert INT = 0  
  
  
DECLARE @Case_Id VARCHAR(50)  
DECLARE @Expected_Payment  NUMERIC(18,2)  
DECLARE @Client_Payment  NUMERIC(18,2)  
DECLARE @FAMT  NUMERIC(18,2)  
DECLARE @IFEE  NUMERIC(18,2)  
DECLARE @MFEE  NUMERIC(18,2)  
DECLARE @CLAIM_AMT  NUMERIC(18,2)  
DECLARE @Reserved_Percent  NUMERIC(18,2)  
DECLARE @Buyout  BIT  
DECLARE @Fixed_Fee_Rate_Time INT  
DECLARE @Funding_date date  
DECLARE @Settlement_Date date  
DECLARE @Settled_Amt NUMERIC(18,2)  
  
DECLARE @DaysOfService INT  
DECLARE @Months_For_MFEE INT  
DECLARE @Settled BIT  
  
DECLARE @TOTAL_ClaimAmt  NUMERIC(18,2)  
DECLARE @TOTAL_SettledAmt  NUMERIC(18,2)  
DECLARE @TOTAL_FundingAmt  NUMERIC(18,2)  
DECLARE @TOTAL_ExpectedPayment  NUMERIC(18,2)  
DECLARE @TOTAL_ClientPayment  NUMERIC(18,2)  
  
	IF @SettlementDate = NULL  
		BEGIN  
			SET @Settlement_Date =GETDATE()  
		END  
	ELSE  
		BEGIN  
			SET @Settlement_Date =@SettlementDate  
		END  
  
DECLARE @PortfolioPaymentSettlement TABLE  
		(  
			Id INT IDENTITY(1,1),  
			Case_Id VARCHAR(50),  
			Claim_Amt VARCHAR(50),  
			Settled_Amt MONEY,  
			Funding_Date DATE,  
			Funding_Amt DECIMAL(18,2),  
			IFee VARCHAR(50),  
			MFee VARCHAR(50),  
			Settlement_Date DATE ,  
			Expected_Payment NUMERIC(18,2),  
			Reserved VARCHAR(50),  
			Client_Payment NUMERIC(18,2),  
			Fixed_Fee_rate_Time INT,  
			Buyout BIT,  
			Settled BIT,
			Advance_Rate VARCHAR(50)    
		);  
  
  
  
INSERT INTO		@PortfolioPaymentSettlement   
SELECT			tc.Case_Id,  
				tc.Claim_Amount,  
				tsl.Settlement_Amount,  
				tc.PurchaseDate,  
				(tpr.Advance_Rate*(CASE WHEN tsl.Settlement_Amount IS NULL THEN(CASE WHEN tc.Claim_Amount is null THEN 0 
																					 WHEN tc.Claim_Amount ='' THEN 0 
																					 ELSE   CONVERT(NUMERIC(18,2),tc.Claim_Amount) 
																				END)
										WHEN tsl.Settlement_Amount ='' THEN(CASE WHEN tc.Claim_Amount is null THEN 0 
																				 WHEN tc.Claim_Amount ='' THEN 0 
																				 ELSE   CONVERT(NUMERIC(18,2),tc.Claim_Amount) 
																	        END)
										ELSE CONVERT(NUMERIC(18,2),tsl.Settlement_Amount) END))/100 AS Funding_amt,  
				tpr.Fixed_Fee_Rate,  
				tpr.Period_Fee_Rate,  
				tsl.Settlement_Date,  
				0,  
				tpf.Reserved_Percentage,  
				0,  
				tpr.Fixed_Fee_Rate_Time,  
				tpr.Buyout,  
				NULL,
				tpr.Advance_Rate  
FROM            tblcase tc   
    
JOIN			tbl_Portfolio tpf ON tc.PortfolioId =tpf.Id  
JOIN			tbl_Program  tpr ON tpf.ProgramId = tpr.Id  
LEFT JOIN		tblSettlements tsl ON tc.Case_Id=tsl.Case_Id  
  
WHERE			tc.[DomainId] =@DomainId  AND tpf.Id=@PortfolioId    
 
  
  
SELECT			@TotalCountInsert = COUNT(*)  
FROM			@PortfolioPaymentSettlement  
 
  

WHILE(@CounterInsert <= @TotalCountInsert)  
BEGIN  
  
	SELECT		@FAMT = Funding_Amt,  
				@IFEE = IFee,  
				@MFEE = MFee,  
				@CLAIM_AMT = CASE WHEN Claim_Amt  IS NULL THEN 0 WHEN Claim_Amt ='' THEN 0 ELSE CONVERT(NUMERIC(18,2),Claim_Amt) END,  
				@Reserved_Percent = Reserved,  
				@Buyout = Buyout,  
				@Fixed_Fee_Rate_Time = Fixed_Fee_rate_Time,  
				@Settlement_Date = CASE WHEN Settlement_Date is null THEN @Settlement_Date  
										WHEN Settlement_Date ='' THEN @Settlement_Date  
										ELSE  Settlement_Date END,  
				@Funding_date =Funding_date,  
				@Case_Id =Case_Id,  
				@Settled_Amt = CASE WHEN Settled_Amt is null THEN @CLAIM_AMT 
									ELSE  Settled_Amt END, --Settled_Amt  
				@Settled   =  CASE WHEN Settled_Amt is null THEN 0 
									ELSE  1 END
			  
	FROM		@PortfolioPaymentSettlement WHERE ID = @CounterInsert  
  


	--Final calculation    
	SET			@DaysOfService = DATEDIFF(day,@Funding_date,@Settlement_Date)  
   
	IF	@Fixed_Fee_Rate_Time >= @DaysOfService   
		BEGIN  
					--Expected Payment = (FAMT + IFEE + MFEE) +( (CLAIM AMOUNT - (FAMT + IFEE + MFEE) ) * (100-Reserve%))  
					IF (@Buyout =1 OR (ISNULL(@MFEE,0) = 0 AND ISNULL(@IFEE,0) = 0))
					BEGIN		
						SET @Expected_Payment =@Settled_Amt * (100 - @Reserved_Percent)/100
					END
					ELSE
					BEGIN
						SET @Expected_Payment =@FAMT+((@IFEE*@Settled_Amt)/100)   
						-- +( (@Settled_Amt -(@FAMT+((@IFEE*@Settled_Amt)/100)) )*(100-@Reserved_Percent) )/100  
					END  
					SET			@Client_Payment =@Settled_Amt - @Expected_Payment  
		END  
  
  
	ELSE  
		BEGIN  
					IF((@DaysOfService-@Fixed_Fee_Rate_Time)%30 =0)  
						BEGIN  
							SET @Months_For_MFEE = (@DaysOfService-@Fixed_Fee_Rate_Time)/30  
						END  
					ELSE  
						BEGIN  
							SET @Months_For_MFEE = (@DaysOfService-@Fixed_Fee_Rate_Time)/30+1  
						END
  
  
				   IF(@Buyout =1 OR (ISNULL(@MFEE,0) = 0 AND ISNULL(@IFEE,0) = 0))
						BEGIN	
							SET @Expected_Payment =@Settled_Amt * (100 - @Reserved_Percent)/100
						END
				   ELSE
						BEGIN			   
							SET @Expected_Payment =(@FAMT+((@IFEE*@Settled_Amt)/100) + ((@MFEE*@Settled_Amt)/100)*@Months_For_MFEE )   
						END

						--  +( (@Settled_Amt -(@FAMT+((@IFEE*@Settled_Amt)/100)   
						--  +((@MFEE*@Settled_Amt)/100)*@Months_For_MFEE) )*(100-@Reserved_Percent) )/100  
				  SET	 @Client_Payment =@Settled_Amt - @Expected_Payment  
  
  
		END  
	--Final calculation 

 
  
	UPDATE	@PortfolioPaymentSettlement   
	SET		Expected_payment = @Expected_Payment,  
			Client_payment= @Client_Payment,  
			Settled_Amt=@Settled_Amt,  
			Settlement_Date=@Settlement_Date,  
			Settled=@Settled,  
			IFee=CONVERT(VARCHAR(50),@IFEE)+'%',  
			MFee = CONVERT(VARCHAR(50),@MFEE)+'%',  
			Reserved=CONVERT(VARCHAR(50),@Reserved_Percent)+'%',  
			Claim_Amt=@CLAIM_AMT  
	WHERE   Id= @CounterInsert; 
	 
  
	SET		@CounterInsert = @CounterInsert + 1  
  
	SET		@Expected_Payment = NULL  
	SET		@Client_Payment = NULL  
	SET		@Settled_Amt = NULL  
	SET		@Settlement_Date = @SettlementDate  
	SET		@Settled = NULL  
	SET		@IFEE = NULL  
	SET		@MFEE = NULL  
	SET		@Reserved_Percent = NULL  
	SET		@CLAIM_AMT = NULL  

  
END 

 
  
SELECT      Case_Id,
			Claim_Amt,  
			Settled_Amt AS 'Payable Amount',  
			CONVERT(VARCHAR(50),Funding_Date) AS 'Funding Date',  
			Funding_Amt AS 'Funding Amt',  
		   --IFee,  
		   --MFee,  
		   CONVERT(VARCHAR(50),Settlement_Date) AS 'Settlement Date',  
		   Expected_Payment AS 'Payment To CC',  
		   --Reserved,  
		   Client_Payment AS 'Reserve/Provider' 
		     
FROM		@PortfolioPaymentSettlement   
WHERE       Settled=1  

  


SELECT     Case_Id,  
		   Claim_Amt,  
		   Settled_Amt AS 'Payable Amount',  
		   CONVERT(VARCHAR(50),Funding_Date) AS 'Funding Date',  
		   Funding_Amt AS 'Funding Amt',  
		   --IFee,  
		   --MFee,  
		   --Settlement_Date AS 'Settlement Date',  
		   Expected_Payment AS 'Expected Payment To CC',  
		   --Reserved,  
		   Client_Payment AS 'Reserve/Provider'		
		    
FROM        @PortfolioPaymentSettlement   
WHERE       Settled=0  

 
  

SELECT      SUM(CONVERT(NUMERIC(18,2),Claim_Amt)) AS Total_Claim,  
			SUM(CONVERT(NUMERIC(18,2),Settled_amt)) AS Total_Settled_Amt,  
			sum(CONVERT(NUMERIC(18,2),Expected_payment)) AS Expected_Payment,  
			SUM(CONVERT(NUMERIC(18,2),Client_payment)) AS Client_Payment ,
			IFee,
			MFee,
			Reserved,
			Fixed_Fee_rate_Time,
			Advance_Rate+'%' AS Advance_Rate
    
FROM        @PortfolioPaymentSettlement
GROUP BY    IFee,
			MFee,
			Reserved,
			Fixed_Fee_rate_Time,
			Advance_Rate  


  
END  
