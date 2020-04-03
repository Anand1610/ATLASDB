CREATE PROCEDURE [dbo].[ClientPayment] (
@clid varchar(50)
)
as
begin
select * from tblpayment where provider_id=@clid order by payment_date desc
end

