CREATE PROCEDURE [dbo].[LCJ_DeleteTransactions]

(
@DomainID NVARCHAR(50),
@Transactions_Id INT

)
AS
-- UPDATE BY Serge Rosenthal on 10/24/07 : Prevent special transactions from being deleted
-- UPDATE BY Serge Rosenthal on 10/27/07 : Add notes
-- UPDATE BY Serge Rosenthal on 5/12/2008 : Add amount deleted in notes 
Declare @Case_id nvarchar(50),@tranType nvarchar(20),@tranAmount money , 
@Notes varchar(100),@transtatus varchar(50),@casestatus varchar(100),@balance money,@payments money
set nocount on
select @case_id = tblTransactions.case_id,@tranType = tblTransactions.Transactions_Type,
@tranAmount = tblTransactions.Transactions_Amount,
@transtatus=tblTransactions.Transactions_status , @casestatus=tblcase.status
from  tblcase INNER JOIN tblTransactions ON tblcase.Case_Id = tblTransactions.Case_Id 
where tblTransactions.transactions_id = @transactions_id and tblCase.DomainId=@DomainID

set @Notes = 'Payment/Transaction deleted: $'+ convert(varchar(8),@tranAmount) +'('+@trantype+')'

Delete from tblTransactions where (Transactions_Id= @Transactions_Id)and (Transactions_status is null or Transactions_status = '0') and DomainId=@DomainID
exec LCJ_AddNotes @DomainId=@DomainID, @case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @Notes ,@user_Id='',@ApplyToGroup = 0


select @balance=isnull(balance,0) from [sjr-payment_balance] where case_id =@case_id and DomainId=@DomainID

IF @CASESTATUS ='CLOSED' AND @TRANSTATUS IS NULL and @balance >20
BEGIN
UPDATE TBLCASE
SET STATUS = 'SETTLED'
FROM TBLCASE WHERE CASE_ID = @CASE_ID and DomainId=@DomainID
exec LCJ_AddNotes @DomainId=@DomainId,@case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = 'STATUS CHANGED BACK FROM CLOSED TO SETTLED AFTER TRANSACTION WAS DELETED' ,@user_Id='SYSTEM',@ApplyToGroup = 0
END

