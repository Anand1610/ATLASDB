CREATE PROCEDURE [dbo].[procClientPayments] 
(
@DomainId NVARCHAR(50),@pid varchar(20),@pamount float,@pdate datetime,@pdesc varchar(200)
)
as
begin
declare
@cb money

select @cb = cost_balance from tblprovider where provider_id=@pid and DomainId=@DomainId

insert into tblClientPayment values (@pid,@pamount,@pdate,@pdesc, @DomainId)

set @cb = @cb - @pamount

update tblProvider set cost_balance = @cb where provider_id=@pid and DomainId=@DomainId

end

