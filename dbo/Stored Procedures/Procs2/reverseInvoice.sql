

CREATE PROCEDURE [dbo].[reverseInvoice](  
@id int  
)  
as  
begin  
declare @deleted_id int

insert into tblclientaccount_deleted ([Account_Id] ,
	[Provider_Id] ,
	[Gross_Amount] ,
	[Firm_Fees] ,
	[Cost_Balance] ,
	[Applied_Cost],
	[Final_Remit] ,
	[Account_Date] ,
	[Invoice_Image] ,
	[Last_Printed] ,
	[Prev_Cost_Balance] ,
	[DomainId] ,
	[VENDOR_FEE],
	[Intrest_Due] ,
	[Expense_Due],
	[Rebuttal_Fee]
	)
select 
    [Account_Id] ,
	[Provider_Id] ,
	[Gross_Amount] ,
	[Firm_Fees] ,
	[Cost_Balance] ,
	[Applied_Cost] ,
	[Final_Remit] ,
	[Account_Date] ,
	[Invoice_Image] ,
	[Last_Printed],
	[Prev_Cost_Balance],
	[DomainId] ,
	[VENDOR_FEE]  ,
	[Intrest_Due] ,
	[Expense_Due]  ,
	[Rebuttal_Fee]
	
	from tblclientaccount where account_id=@id

select @deleted_id=account_id from tblclientaccount_deleted where account_id=@id

if(@deleted_id=@id) 
	begin

insert into tblnotes  (Notes_Desc,	Notes_Type,	Notes_Priority,	Case_Id,	Notes_Date,	User_Id,	DomainId)
SELECT top 1 'INVOICE NO ' + CONVERT(VARCHAR,@ID) + ' REVERSED','ACTIVITY','1',CASE_ID,GETDATE(),'FINANCIALS',DomainId FROM TBLTRANSACTIONS WHERE INVOICE_ID=@ID  
  
update tbltransactions set Transactions_status = null,Invoice_id=null where Invoice_Id=@id  


UPDATE TblProvider
SET cost_balance =Prev_Cost_Balance 
from TblProvider P INNER JOIN tblclientaccount C on P.Provider_Id = C.Provider_Id WHERE ACCOUNT_ID=@ID

  
delete from TBLCLIENTACCOUNT WHERE ACCOUNT_ID=@ID
  
	end
end

