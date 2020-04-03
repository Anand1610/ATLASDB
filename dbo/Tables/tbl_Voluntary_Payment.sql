CREATE TABLE [dbo].[tbl_Voluntary_Payment] (
    [Voluntary_Pay_Id]        INT             IDENTITY (1, 1) NOT NULL,
    [Case_Id]                 VARCHAR (50)    NULL,
    [Total_Collection]        DECIMAL (18, 2) NULL,
    [Deductible]              DECIMAL (18, 2) NULL,
    [Pre_Interest]            DECIMAL (18, 2) NULL,
    [Voluntary_AF]            DECIMAL (18, 2) NULL,
    [Payment_Type]            VARCHAR (10)    NULL,
    [Litigated_Collection]    DECIMAL (18, 2) NULL,
    [Litigated_Interest]      DECIMAL (18, 2) NULL,
    [Litigation_Fees]         DECIMAL (18, 2) NULL,
    [Court_Fees]              DECIMAL (18, 2) NULL,
    [Check_Date]              DATETIME        NULL,
    [Check_No]                VARCHAR (100)   NULL,
    [Transaction_Date]        DATETIME        NULL,
    [Transaction_Description] VARCHAR (250)   NULL,
    [DomainId]                VARCHAR (50)    NULL,
    [Transactions_Id]         INT             NULL,
    [FirstParty_Litigation]   BIT             NULL,
    [dTransactions_Id]        INT             NULL,
    [iTransactions_Id]        INT             NULL,
    CONSTRAINT [PK_tbl_Voluntary_Payment] PRIMARY KEY CLUSTERED ([Voluntary_Pay_Id] ASC)
);


GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[trgVoluntaryPayment] 
   ON  [dbo].[tbl_Voluntary_Payment]
   AFTER INSERT
AS 
BEGIN
    Declare @Case_Id varchar(50);
	Declare @Total_Collection decimal(18, 2);
	Declare @Paid_Amount decimal(18, 2);
	Declare @Claim_Amount decimal(18, 2);
	Declare @Paid_Percent decimal(6, 2);
	Declare @Vol_Percent decimal(6, 2);
	Declare @Domain_Id varchar(50);
	Declare @TransactionId int;
	Declare @UserId varchar(50);

	Select @Case_Id = Case_Id, @Domain_Id =DomainId, @TransactionId = Transactions_Id from inserted

	Select @Total_Collection = sum(Total_Collection) from tbl_Voluntary_Payment where Case_Id = @Case_Id and LTRIM(RTRIM(Payment_Type)) = 'V'

	Select @Paid_Amount = Paid_Amount, @Claim_Amount = Claim_Amount from tblcase where Case_Id = @Case_Id

	Select @UserId = User_Id from tblTransactions Where Transactions_Id = @TransactionId

	IF isnull(@Claim_Amount,0) != 0
	BEGIN
		Set @Paid_Percent = (isnull(@Paid_Amount,0)/isnull(@Claim_Amount,0)) * 100;
	END
	ELSE
	BEGIN
		Set @Paid_Percent = 0;
	END
	IF isnull(@Paid_Amount,0) != 0
	BEGIN
		Set @Vol_Percent = (isnull(@Total_Collection,0)/isnull(@Paid_Amount,0)) * 100;
	END
	ELSE
	BEGIN
		Set @Vol_Percent = 0;
	END

	IF @Paid_Percent = 100 and @Vol_Percent = 100
	BEGIN
	  Exec Update_Cases_Current_Status @DomainId = @Domain_Id, @status = 'Paid and Closed with Voluntary payment', @case_id = @Case_Id, @User_Id = @UserId
	END
	ELSE IF @Paid_Percent > 60 and @Vol_Percent > 60
	BEGIN
	  Exec Update_Cases_Current_Status @DomainId = @Domain_Id, @status = 'Closed pending with FA review', @case_id = @Case_Id, @User_Id = @UserId
	END
	ELSE IF (isnull(@Claim_Amount,0) - isnull(@Paid_Amount,0)) < 3000
	BEGIN
	  Exec Update_Cases_Current_Status @DomainId = @Domain_Id, @status = 'Closed pending with FA review', @case_id = @Case_Id, @User_Id = @UserId
	END

END
