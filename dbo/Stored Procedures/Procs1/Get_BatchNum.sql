--sp_helptext LCJ_AddDataEntry1

CREATE PROCEDURE [dbo].[Get_BatchNum] --Add_ProviderBoxDetails '','','','','0507201234','','Save'
(  
	@DomainId nvarchar(50),	
    @BatchNumber nvarchar(50)  
)  
AS  
declare @batch_no as nvarchar(50)
declare @batch_no_count as nvarchar(50)
BEGIN
set @batch_no=(select max(BatchNumber) from tblProvListBoxDetails  where BatchNumber like @BatchNumber+'%' and DomainId = @DomainId)

set @batch_no_count=convert(int,(select SUBSTRING (@batch_no ,10, 12 )))
select @BatchNumber+'_'+convert(nvarchar,@batch_no_count)
End

