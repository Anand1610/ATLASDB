CREATE PROCEDURE [dbo].[PROC_UPDATEexpCOSTBALANCE] 
(
@DomainId NVARCHAR(50),
@ttype varchar(20),
@amt money,
@case_id varchar(50)
)
as
begin
declare
@cnt int

select @cnt = count(*) from tbltransactions where case_id=@case_id and transactions_type=@ttype and DomainId=@DomainId
if @cnt >=1 
begin
update tbltransactions set transactions_amount = @amt,transactions_deScription = transactions_description + 'COST UPDATION' where case_id=@case_id and transactions_type=@ttype and DomainId=@DomainId
end
else
begin
insert into tbltransactions(CASE_ID,TRANSACTIONS_TYPE,TRANSACTIONS_dATE,TRANSACTIONS_AMOUNT,TRANSACTIONS_DESCRIPTION,PROVIDER_ID,USER_ID,TRANSACTIONS_FEE)
select @case_id,@ttype,getdate(),@amt,'COST CORRECTION',PROVIDER_ID,'SYSTEM',@AMT FROM TBLCASE WHERE CASE_ID=@CASE_ID and DomainId=@DomainId
end
end

--select * from tbltransactions where transactions_type='exp' and transactions_amount=0

