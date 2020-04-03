CREATE PROCEDURE [dbo].[LCJ_procinsertinvoice](
@Provider_Id varchar(50),
@Gross_Amount money,
@Firm_Fees money,
@Cost_Balance money,
@Applied_Cost money,
@Final_Remit money,
@Invoice_Image ntext
)
as
begin
insert into tblClientAccount (Provider_Id,Gross_Amount,Firm_Fees,Cost_Balance,Applied_Cost,Final_Remit,Account_Date,Invoice_Image) 
values (@provider_id,@Gross_Amount,@Firm_Fees,@Cost_Balance,@Applied_Cost,@Final_Remit ,getdate(),@Invoice_Image)
end

