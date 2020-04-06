CREATE TABLE [dbo].[BILLS_WITH_PROCEDURE_CODES] (
    [Account]              VARCHAR (255)   NULL,
    [BillNumber]           VARCHAR (255)   NULL,
    [Code]                 VARCHAR (50)    NULL,
    [Description]          VARCHAR (MAX)   NULL,
    [Amount]               FLOAT (53)      NULL,
    [DOS]                  DATETIME        NULL,
    [Specialty]            VARCHAR (255)   NULL,
    [BillAmount]           FLOAT (53)      NULL,
    [ins_fee_schedule]     MONEY           NULL,
    [CPT_ATUO_ID]          INT             IDENTITY (1, 1) NOT NULL,
    [Case_ID]              VARCHAR (50)    NULL,
    [fk_Treatment_Id]      INT             NULL,
    [DomainID]             VARCHAR (50)    CONSTRAINT [DF__BILLS_WIT__Domai__71139959] DEFAULT ('p') NOT NULL,
    [created_by_user]      NVARCHAR (255)  CONSTRAINT [DF__BILLS_WIT__creat__7207BD92] DEFAULT ('admin') NOT NULL,
    [created_date]         DATETIME        NULL,
    [modified_by_user]     NVARCHAR (255)  NULL,
    [modified_date]        DATETIME        NULL,
    [CollectedAmount]      DECIMAL (18, 2) NULL,
    [ICD10_3]              VARCHAR (100)   NULL,
    [ICD10_2]              VARCHAR (100)   NULL,
    [ICD10_1]              VARCHAR (100)   NULL,
    [MOD]                  INT             CONSTRAINT [DF_BILLS_WITH_PROCEDURE_CODES_MOD] DEFAULT ((0)) NULL,
    [UNITS]                INT             CONSTRAINT [DF_BILLS_WITH_PROCEDURE_CODES_UNITS] DEFAULT ((1)) NULL,
    [Deductible]           FLOAT (53)      NULL,
    [Intrest]              FLOAT (53)      NULL,
    [AttorneyFee]          FLOAT (53)      NULL,
    [LITCollectedAmount]   DECIMAL (18, 2) NULL,
    [LITIntrest]           DECIMAL (18, 2) NULL,
    [LITFees]              DECIMAL (18, 2) NULL,
    [CourtFees]            DECIMAL (18, 2) NULL,
    [Purchase_Freeze_Date] DATETIME        NULL,
    [Bill_Adjustment]      FLOAT (53)      NULL,
    [Refund_Freeze_Date]   DATETIME        NULL,
    [GP_Freeze_Date]       DATETIME        NULL,
    [GBBCodeID]            VARCHAR (20)    NULL,
    [Auto_Proc_id]         INT             NULL,
	[FeeSchedule]		   money           Null
);


GO
CREATE TRIGGER [dbo].[Trigger_CPT_Change] 
	ON [dbo].[BILLS_WITH_PROCEDURE_CODES] 
	AFTER INSERT, UPDATE, DELETE
AS 
Declare @Treatment_Id int,@Amount decimal(18, 2), @ins_fee_schedule decimal(18, 2), @BILL_NUMBER varchar(150),@SumofAmount decimal(18, 2),@sumRegionIV decimal(18, 2),@count int;



 If exists (Select * from inserted) and not exists(Select * from deleted)
	Begin
		SELECT @Treatment_Id = fk_Treatment_Id, @Amount = isnull(Amount,0), @ins_fee_schedule = isnull(ins_fee_schedule,0), @BILL_NUMBER = BillNumber
		from inserted i;



		select @count=count(t1.Auto_Proc_id) from  
		MST_PROCEDURE_CODES t1
		join BILLS_WITH_PROCEDURE_CODES t2 on t1.Auto_Proc_id=t2.Auto_Proc_id
		where t2.fk_Treatment_Id=@Treatment_Id and t1.Specialty='Law Firm Code'

		if(@count>0)
		begin
			select @SumofAmount=sum(isnull(t1.amount,0)),@sumRegionIV=sum(isnull(t1.FeeSchedule,0))
			from BILLS_WITH_PROCEDURE_CODES t1
			join MST_PROCEDURE_CODES t2 on t1.Auto_Proc_id=t2.Auto_Proc_id
			where fk_Treatment_Id=@Treatment_Id and t2.Specialty='Law Firm Code'
		end
		else
		begin
			select @SumofAmount=sum(isnull(amount,0)),@sumRegionIV=sum(isnull(FeeSchedule,0))
			from BILLS_WITH_PROCEDURE_CODES where fk_Treatment_Id=@Treatment_Id
			
		end

		Update tblTreatment set 
		Claim_Amount = @SumofAmount,
		Fee_Schedule = @sumRegionIV
		Where Treatment_Id = @Treatment_Id or (ISNULL(BILL_NUMBER,'') = ISNULL(@BILL_NUMBER,'') AND ISNULL(BILL_NUMBER,'') <> '')
	End

  If exists(SELECT * from inserted) and exists (SELECT * from deleted)
	Begin
		SELECT @Treatment_Id = i.fk_Treatment_Id, @Amount = (isnull(i.Amount,0) - isnull(d.Amount,0)), 
		@ins_fee_schedule = (isnull(i.ins_fee_schedule,0) - isnull(d.ins_fee_schedule,0)), @BILL_NUMBER = d.BillNumber
		from inserted i join deleted d on (i.CPT_ATUO_ID = d.CPT_ATUO_ID);
		
		select @count=count(t1.Auto_Proc_id) from  
		MST_PROCEDURE_CODES t1
		join BILLS_WITH_PROCEDURE_CODES t2 on t1.Auto_Proc_id=t2.Auto_Proc_id
		where t2.fk_Treatment_Id=@Treatment_Id and t1.Specialty='Law Firm Code'

		if(@count>0)
		begin
			select @SumofAmount=sum(isnull(t1.amount,0)),@sumRegionIV=sum(isnull(t1.FeeSchedule,0))
			from BILLS_WITH_PROCEDURE_CODES t1
			join MST_PROCEDURE_CODES t2 on t1.Auto_Proc_id=t2.Auto_Proc_id
			where fk_Treatment_Id=@Treatment_Id and t2.Specialty='Law Firm Code'
		end
		else
		begin		
		select @SumofAmount=sum(isnull(amount,0)),@sumRegionIV=sum(isnull(FeeSchedule,0))
		from BILLS_WITH_PROCEDURE_CODES where fk_Treatment_Id=@Treatment_Id
		end


		Update tblTreatment set 
		Claim_Amount = @SumofAmount,
		Fee_Schedule = @sumRegionIV
		Where Treatment_Id = @Treatment_Id or (ISNULL(BILL_NUMBER,'') = ISNULL(@BILL_NUMBER,'') AND ISNULL(BILL_NUMBER,'') <> '')
	End
	

	If exists(select * from deleted) and not exists(Select * from inserted)
	Begin
	 SELECT @Treatment_Id = fk_Treatment_Id, @Amount = isnull(Amount,0), @ins_fee_schedule = isnull(ins_fee_schedule,0), @BILL_NUMBER = BillNumber from deleted i;

	 select @count=count(t1.Auto_Proc_id) from  
		MST_PROCEDURE_CODES t1
		join BILLS_WITH_PROCEDURE_CODES t2 on t1.Auto_Proc_id=t2.Auto_Proc_id
		where t2.fk_Treatment_Id=@Treatment_Id and t1.Specialty='Law Firm Code'

		if(@count>0)
		begin
			select @SumofAmount=sum(isnull(t1.amount,0)),@sumRegionIV=sum(isnull(t1.FeeSchedule,0))
			from BILLS_WITH_PROCEDURE_CODES t1
			join MST_PROCEDURE_CODES t2 on t1.Auto_Proc_id=t2.Auto_Proc_id
			where fk_Treatment_Id=@Treatment_Id and t2.Specialty='Law Firm Code'
		end
		else
		begin
			select @SumofAmount=sum(isnull(amount,0)) ,@sumRegionIV=sum(isnull(FeeSchedule,0))
			from BILLS_WITH_PROCEDURE_CODES where fk_Treatment_Id=@Treatment_Id
		end
	

		Update tblTreatment set 
		Claim_Amount = @SumofAmount,
		Fee_Schedule = @sumRegionIV
		Where Treatment_Id = @Treatment_Id or (ISNULL(BILL_NUMBER,'') = ISNULL(@BILL_NUMBER,'') AND ISNULL(BILL_NUMBER,'') <> '')

		--Update tblTreatment set 
		--Claim_Amount = case when  (isnull(Claim_Amount,0) - @Amount)<0 then 0 else   (isnull(Claim_Amount,0) - @Amount) end ,
		--Fee_Schedule =  case when  isnull(Fee_Schedule,0) - @ins_fee_schedule <0 then 0 else  isnull(Fee_Schedule,0) - @ins_fee_schedule end 
		--Where Treatment_Id = @Treatment_Id or (ISNULL(BILL_NUMBER,'') = ISNULL(@BILL_NUMBER,'') AND ISNULL(BILL_NUMBER,'') <> '')
	End
