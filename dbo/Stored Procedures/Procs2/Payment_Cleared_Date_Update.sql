-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Payment_Cleared_Date_Update]
	@s_a_Ids varchar(max),
	@s_a_DomainId varchar(50),
	@dt_a_clear_date varchar(50),
	@s_a_bill_type varchar(50)
AS
BEGIN
        if(@s_a_bill_type='voluntary')
		BEGIN
			Update tbl_CPT_Payment_Details 
			set VAL_Cleared_Date = CONVERT(datetime, @dt_a_clear_date)
			where CPT_Pay_Id in (Select items from dbo.STRING_SPLIT(@s_a_Ids, ',') ) and DomainId = @s_a_DomainId
		END
		Else if(@s_a_bill_type='litigated')
		BEGIN
		    Update tbl_CPT_Payment_Details 
			set LIT_Cleared_Date = CONVERT(datetime, @dt_a_clear_date)
			where CPT_Pay_Id in (Select items from dbo.STRING_SPLIT(@s_a_Ids, ',') ) and DomainId = @s_a_DomainId
		END
END
