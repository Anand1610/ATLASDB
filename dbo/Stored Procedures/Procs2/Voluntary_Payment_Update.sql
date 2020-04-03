-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Voluntary_Payment_Update] 
   @i_a_Voluntary_Pay_Id int,
   @s_a_Case_Id varchar(50),
   @d_a_Total_Collection decimal(18, 2),
   @d_a_Deductible decimal(18, 2),
   @d_a_Pre_Interest decimal(18, 2),
   @d_a_Voluntary_AF decimal(18, 2),
   @s_a_Payment_Type varchar(10),
   @d_a_Litigated_Collection decimal(18, 2),
   @d_a_Litigated_Interest decimal(18, 2),
   @d_a_Litigation_Fees decimal(18, 2),
   @d_a_Court_Fees decimal(18, 2),
   @dt_a_Check_Date DateTime,
   @s_a_Check_No varchar(100),
   @dt_a_Transaction_Date DateTime,
   @s_a_Transaction_Description varchar(250),
   @s_a_DomainId varchar(50),
   @s_a_FirstParty_Litig bit,
   @i_a_User_Id nvarchar(100)
AS
BEGIN
    BEGIN TRAN  
	Update tbl_Voluntary_Payment Set
	  [Total_Collection] = @d_a_Total_Collection
	 ,[Deductible] = @d_a_Deductible
	 ,[Pre_Interest] = @d_a_Pre_Interest
	 ,[Voluntary_AF] = @d_a_Voluntary_AF
	 ,[Payment_Type] = @s_a_Payment_Type
	 ,[Litigated_Collection] = @d_a_Litigated_Collection
	 ,[Litigated_Interest] = @d_a_Litigated_Interest
	 ,[Litigation_Fees] = @d_a_Litigation_Fees
	 ,[Court_Fees] = @d_a_Court_Fees
	 ,[Check_Date] = @dt_a_Check_Date
	 ,[Check_No] = @s_a_Check_No
	 ,[Transaction_Date] = @dt_a_Transaction_Date
	 ,[Transaction_Description] = @s_a_Transaction_Description
	 ,[FirstParty_Litigation]=@s_a_FirstParty_Litig
	 Where
	 Voluntary_Pay_Id = @i_a_Voluntary_Pay_Id
	 and Case_Id = @s_a_Case_Id
	 and DomainId = @s_a_DomainId

	 Declare @Transaction_Id int;
	 Declare @dTransaction_Id int;
	 Declare @iTransaction_Id int;
	 Declare @Provider_Id nvarchar(50);

	 Select @Provider_Id = Provider_Id from tblcase where Case_Id = @s_a_Case_Id and DomainId = @s_a_DomainId

	 Select @Transaction_Id = Transactions_Id
	       ,@dTransaction_Id =  dTransactions_Id
		   ,@iTransaction_Id = iTransactions_Id
		   from tbl_Voluntary_Payment  Where Voluntary_Pay_Id = @i_a_Voluntary_Pay_Id
	 and Case_Id = @s_a_Case_Id and DomainId = @s_a_DomainId

	 IF @s_a_Payment_Type='V'
	 BEGIN
	     
		DECLARE @i_l_Treat_Coount INT 
		DECLARE @d_Transactions_Amount MONEY

		SET @i_l_Treat_Coount = (select ISNULL(count(case_id),0) from tblTreatment where DomainId=@s_a_DomainId and Case_Id=@s_a_Case_Id)
		SET @d_Transactions_Amount = (select ISNULL(SUM(Transactions_Amount),0) from tblTransactions where DomainId=@s_a_DomainId and Case_Id=@s_a_Case_Id and Transactions_Type IN ('PreC','PreCToP'))

		IF(@i_l_Treat_Coount = 1 AND @s_a_DomainId IN ('GLF'))
		BEGIN
			UPDATE tblTreatment SET Paid_Amount = CONVERT(MONEY,(@d_Transactions_Amount/@i_l_Treat_Coount)) WHERE DomainId=@s_a_DomainId and Case_Id = @s_a_Case_Id
		END
		ELSE IF(@i_l_Treat_Coount > 0)
		BEGIN
			UPDATE tblTreatment SET Paid_Amount = CONVERT(MONEY,(@d_Transactions_Amount/@i_l_Treat_Coount)) WHERE DomainId=@s_a_DomainId and Case_Id = @s_a_Case_Id
		END


		 Update tblTransactions set
		 Transactions_Amount=@d_a_Total_Collection,
		 Transactions_Date = Convert(nvarchar(15), @dt_a_Transaction_Date, 101),
		 Transactions_Description = @s_a_Transaction_Description,
		 ChequeNo = @s_a_Check_No,
		 CheckDate = @dt_a_Check_Date
		 where Transactions_Id = @Transaction_Id and DomainId = @s_a_DomainId

		 If @dTransaction_Id is not null
		 BEGIN
		    Update tblTransactions set
			 Transactions_Amount=@d_a_Deductible,
			 Transactions_Date = Convert(nvarchar(15), @dt_a_Transaction_Date, 101),
			 Transactions_Description = @s_a_Transaction_Description,
			 ChequeNo = @s_a_Check_No,
			 CheckDate = @dt_a_Check_Date
			 where Transactions_Id = @dTransaction_Id and DomainId = @s_a_DomainId
		 END
		 Else If @d_a_Pre_Interest > 0
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
				   @s_a_Case_Id,  
				   @Provider_Id,  
				   @d_a_Deductible,  
				   Convert(nvarchar(15), @dt_a_Transaction_Date, 101),     
				   'D',  
				   @s_a_Transaction_Description,  
				   @i_a_User_Id,  
				   '0',
					0,
				   @s_a_DomainId,
				   @s_a_Check_No,
				   @dt_a_Check_Date,
				   '',
				   ''
				  )   

			   SELECT @dTransaction_Id = CAST(scope_identity() AS int);

			   Update tbl_Voluntary_Payment Set
			   dTransactions_Id = @dTransaction_Id
			   Where Voluntary_Pay_Id = @i_a_Voluntary_Pay_Id and Case_Id = @s_a_Case_Id and DomainId = @s_a_DomainId
	     END

		 If @iTransaction_Id is not null
		  BEGIN
		    Update tblTransactions set
			 Transactions_Amount=@d_a_Pre_Interest,
			 Transactions_Date = Convert(nvarchar(15), @dt_a_Transaction_Date, 101),
			 Transactions_Description = 'Voluntary Pre Interest',
			 ChequeNo = @s_a_Check_No,
			 CheckDate = @dt_a_Check_Date
			 where Transactions_Id = @iTransaction_Id and DomainId = @s_a_DomainId
		 END
		 Else If @d_a_Pre_Interest > 0
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
				   @s_a_Case_Id,  
				   @Provider_Id,  
				   @d_a_Pre_Interest,  
				   Convert(nvarchar(15), @dt_a_Transaction_Date, 101),     
				   'PreI',  
				   'Voluntary Pre Interest',  
				   @i_a_User_Id,  
				   '0',
					0,
				   @s_a_DomainId,
				   @s_a_Check_No,
				   @dt_a_Check_Date,
				   '',
				   ''
				  )   

			   SELECT @iTransaction_Id = CAST(scope_identity() AS int);

			   Update tbl_Voluntary_Payment Set
			   iTransactions_Id = @iTransaction_Id
			   Where Voluntary_Pay_Id = @i_a_Voluntary_Pay_Id and Case_Id = @s_a_Case_Id and DomainId = @s_a_DomainId
	  END

	 END
	 ELSE
	 BEGIN
	 Update tblTransactions set
		 Transactions_Amount=@d_a_Litigated_Collection,
		 Transactions_Date = Convert(nvarchar(15), @dt_a_Transaction_Date, 101),
		 Transactions_Description = @s_a_Transaction_Description,
		 ChequeNo = @s_a_Check_No,
		 CheckDate = @dt_a_Check_Date
		 where Transactions_Id = @Transaction_Id and DomainId = @s_a_DomainId

		  If @iTransaction_Id is not null
		  BEGIN
		    Update tblTransactions set
			 Transactions_Amount=@d_a_Litigated_Interest,
			 Transactions_Date = Convert(nvarchar(15), @dt_a_Transaction_Date, 101),
			 Transactions_Description = 'Litigated Interest',
			 ChequeNo = @s_a_Check_No,
			 CheckDate = @dt_a_Check_Date
			 where Transactions_Id = @iTransaction_Id and DomainId = @s_a_DomainId
		 END
		 Else If @d_a_Litigated_Interest > 0
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
				   @s_a_Case_Id,  
				   @Provider_Id,  
				   @d_a_Litigated_Interest,  
				   Convert(nvarchar(15), @dt_a_Transaction_Date, 101),     
				   'PreI',  
				   'Litigated Interest',  
				   @i_a_User_Id,  
				   '0',
					0,
				   @s_a_DomainId,
				   @s_a_Check_No,
				   @dt_a_Check_Date,
				   '',
				   ''
				  )   

			   SELECT @iTransaction_Id = CAST(scope_identity() AS int);

			   Update tbl_Voluntary_Payment Set
			   iTransactions_Id = @iTransaction_Id
			   Where Voluntary_Pay_Id = @i_a_Voluntary_Pay_Id and Case_Id = @s_a_Case_Id and DomainId = @s_a_DomainId
	  END

	 END
	 COMMIT TRAN
END
