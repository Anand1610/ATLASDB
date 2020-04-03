--sp_helptext LCJ_AddDataEntry1

CREATE PROCEDURE [dbo].[get_ProviderBatch] -- [S_ProviderBatch] 869
  
(  
	@domainId nvarchar(50),
	@proid varchar(50)      
)  
AS
BEGIN
	select batch_no, CAST(auto_id AS varchar(12))  as auto_id  from tblProviderBoxDetails  where provider_id=@proid or provider_id='' and DomainId = @DomainId order by batch_no
End

