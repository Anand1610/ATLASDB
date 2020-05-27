CREATE PROCEDURE [dbo].[Payment_Freeze]
	@s_a_Ids varchar(max),
	@s_a_DomainId varchar(50),
	@dt_a_inv_date varchar(50),
	@s_report_type varchar(50)
AS
BEGIN

-- tbl_Voluntary_Payment
	IF(@s_report_type ='VoluntaryPaymentReport')
		Update tbl_CPT_Payment_Details 
		set VAL_PAY_Freeze_Date = CONVERT(datetime, @dt_a_inv_date)
		where CPT_Pay_Id in (Select items from  dbo.STRING_SPLIT(@s_a_Ids, ',') ) and DomainId = @s_a_DomainId

	IF(@s_report_type ='LitigatedPaymentReport')
		Update tbl_CPT_Payment_Details 
		set LIT_PAY_Freeze_Date = CONVERT(datetime, @dt_a_inv_date)
		where CPT_Pay_Id in (Select items from  dbo.STRING_SPLIT(@s_a_Ids, ',') ) and DomainId = @s_a_DomainId

	IF(@s_report_type ='PurchaseReport')
		Update BILLS_WITH_PROCEDURE_CODES 
		set Purchase_Freeze_Date = CONVERT(datetime, @dt_a_inv_date)
		where CPT_ATUO_ID in (Select items from  dbo.STRING_SPLIT(@s_a_Ids, ',') ) and DomainId = @s_a_DomainId

	IF(@s_report_type ='RefundReport')
		Update BILLS_WITH_PROCEDURE_CODES 
		set Refund_Freeze_Date = CONVERT(datetime, @dt_a_inv_date)
		where CPT_ATUO_ID in (Select items from  dbo.STRING_SPLIT(@s_a_Ids, ',') ) and DomainId = @s_a_DomainId

		--ALTER table BILLS_WITH_PROCEDURE_CODES
		--Add Purchase_Freeze_Date DATETIME

		IF(@s_report_type ='GPReconcilationReport')
		Update BILLS_WITH_PROCEDURE_CODES 
		set GP_Freeze_Date = CONVERT(datetime, @dt_a_inv_date)
		where CPT_ATUO_ID in (Select items from  dbo.STRING_SPLIT(@s_a_Ids, ',') ) and DomainId = @s_a_DomainId

END
