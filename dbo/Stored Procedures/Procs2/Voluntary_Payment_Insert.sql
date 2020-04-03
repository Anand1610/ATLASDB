CREATE PROCEDURE [dbo].[Voluntary_Payment_Insert] 
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
   @i_a_User_Id VARCHAR(100),
   @s_a_FirstParty_Litig bit
AS
BEGIN
	BEGIN TRY
     BEGIN TRAN  
     Declare @Provider_Id VARCHAR(50);
	 Declare @dTransaction_Id int;
	 Declare @iTransaction_Id int;

	 Select @Provider_Id = Provider_Id from tblcase where Case_Id = @s_a_Case_Id and DomainId = @s_a_DomainId

	 IF @s_a_Payment_Type='V'
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
			   @d_a_Total_Collection,  
			   Convert(VARCHAR(15), @dt_a_Transaction_Date, 101),     
			   'PreC',  
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
			   @d_a_Litigated_Collection,  
			   Convert(VARCHAR(15), @dt_a_Transaction_Date, 101),     
			   'C',  
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

	 END

	 Declare @Transaction_Id int;
	 SELECT @Transaction_Id = CAST(scope_identity() AS int);

	 IF  @s_a_Payment_Type='V' and @d_a_Deductible > 0
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
			   Convert(VARCHAR(15), @dt_a_Transaction_Date, 101),     
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
	 END
	
	IF @s_a_Payment_Type='V' and @d_a_Pre_Interest > 0
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
			   Convert(VARCHAR(15), @dt_a_Transaction_Date, 101),     
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
	 END
	 Else If @s_a_Payment_Type='L' and @d_a_Litigated_Interest > 0
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
			   Convert(VARCHAR(15), @dt_a_Transaction_Date, 101),     
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
	 END


	Insert into tbl_Voluntary_Payment
	(
	  [Case_Id]
	 ,[Total_Collection]
	 ,[Deductible]
	 ,[Pre_Interest]
	 ,[Voluntary_AF]
	 ,[Payment_Type]
	 ,[Litigated_Collection]
	 ,[Litigated_Interest]
	 ,[Litigation_Fees]
	 ,[Court_Fees]
	 ,[Check_Date]
	 ,[Check_No]
	 ,[Transaction_Date]
	 ,[Transaction_Description]
	 ,[DomainId]
	 ,[Transactions_Id]
	 ,[FirstParty_Litigation]
	 ,dTransactions_Id
	 ,iTransactions_Id
	) 
	Values
	(
	  @s_a_Case_Id
	 ,@d_a_Total_Collection 
	 ,@d_a_Deductible
	 ,@d_a_Pre_Interest
	 ,@d_a_Voluntary_AF
	 ,@s_a_Payment_Type
	 ,@d_a_Litigated_Collection 
	 ,@d_a_Litigated_Interest
	 ,@d_a_Litigation_Fees 
	 ,@d_a_Court_Fees
	 ,@dt_a_Check_Date
	 ,@s_a_Check_No
	 ,@dt_a_Transaction_Date
	 ,@s_a_Transaction_Description 
	 ,@s_a_DomainId
	 ,@Transaction_Id
	 ,@s_a_FirstParty_Litig
	 ,@dTransaction_Id
	 ,@iTransaction_Id
	)
	 Declare @s_l_message int;

	 SELECT @s_l_message = CAST(scope_identity() AS int);

	 IF @s_a_Payment_Type='V' and @s_a_FirstParty_Litig = 1
		BEGIN
			Declare @OldStatus varchar(500)='';
			Declare @NotesDesc varchar(2000)='';
			DECLARE @oldStatusHierarchy int
			DECLARE @newStatusHierarchy int
			Select @OldStatus = STATUS from tblcase(Nolock) where Case_Id = @s_a_Case_Id and DomainId = @s_a_DomainId
			SET @NotesDesc = 'Status changed from '+ @OldStatus +' to Closed.';
			IF UPPER(@OldStatus) != 'CLOSED'
				BEGIN
				SET @oldStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@s_a_DomainId and Status_Type=@OldStatus)
				SET @newStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@s_a_DomainId and Status_Type='CLOSED')

				---IF(@newStatusHierarchy>=@oldStatusHierarchy)
				if(@newStatusHierarchy>=@oldStatusHierarchy OR ((@newStatusHierarchy = 0 OR @oldStatusHierarchy = 0) AND @s_a_DomainId in ('AMT','PDC')))
				BEGIN
					update tblcase SET STATUS='CLOSED' where Case_Id = @s_a_Case_Id and DomainId = @s_a_DomainId
					insert into tblNotes (Notes_Desc, Notes_Type, Notes_Priority, Case_Id, Notes_Date, User_Id, DomainId)   
					values (@NotesDesc,'Activity',1,@s_a_Case_Id,getdate(),'system',@s_a_DomainId)
				 end
				 ELSE
				 BEGIN
				 SET @NotesDesc = 'Can not chnage status from '+ @OldStatus +' to Closed.';
					insert into tblNotes (Notes_Desc, Notes_Type, Notes_Priority, Case_Id, Notes_Date, User_Id, DomainId)   
					values (@NotesDesc,'Activity',1,@s_a_Case_Id,getdate(),'system',@s_a_DomainId)
				 END  
				END
		END

	 SELECT @s_l_message AS [Message];

	COMMIT TRAN
	END TRY
		BEGIN CATCH
			ROLLBACK
		END CATCH
END
