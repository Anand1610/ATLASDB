CREATE PROCEDURE [dbo].[PROC_UPDATECOSTBALANCE](
@DomainId NVARCHAR(50),
@PID VARCHAR(50),
@AMT MONEY
)
AS
BEGIN
UPDATE tblprovider SET cost_balance=@AMT where provider_id = @PID and DomainId=@DomainId
END

