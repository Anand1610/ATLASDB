CREATE PROCEDURE [dbo].[insPayment] (
@DomainID NVARCHAR(50),
@clid varchar(50),
@payment_amount money,
@payment_type varchar(10),
@notes nvarchar(500),
@user_id varchar(50)
)
as
begin
insert into tblpayment values (@clid,@payment_amount,getdate(),@notes,@payment_type,@user_id,@DomainID)
end

