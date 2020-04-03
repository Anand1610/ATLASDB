--sp_helptext LCJ_AddDataEntry1

CREATE PROCEDURE [dbo].[Add_ProviderBoxDetails] --Add_ProviderBoxDetails '','','','','05072012','','Save'
(  
	@DomainId nvarchar(50),
	@DateReceived datetime,
	@CreatedBy nvarchar(50),	 	
	@SpecialNote nvarchar(500),
    @SpecialInstruction  nvarchar(500),
    @BatchNumber nvarchar(50),
    @No_Of_Cases nvarchar(50),
    @condition nvarchar(50),
    @Predestinated_Path nvarchar(100)
)  
AS  
declare @batch_no as nvarchar(50)
declare @batch_no_count as nvarchar(50)
BEGIN
set @batch_no=(select max(BatchNumber) from tblProvListBoxDetails where BatchNumber like @BatchNumber+'%' and DomainId = @DomainId)
if(@batch_no is null)
set @batch_no=@BatchNumber+'_0'
set @batch_no_count=convert(int,(select SUBSTRING (@batch_no ,10, 12 )))
if(@condition='Save')
begin
insert into tblProvListBoxDetails
		(
		DomainId,
		BatchNumber,		
		DateReceived,		
		SpecialNote,
		SpecialInstruction,
        No_Of_Cases,
        Created_By,
        Predestinated_Path		
		)
		values(@DomainId, @BatchNumber+'_'+convert(nvarchar,@batch_no_count+1),@DateReceived,@SpecialNote,@SpecialInstruction,@No_Of_Cases,@CreatedBy,@Predestinated_Path)
end
else
begin
update tblProvListBoxDetails
set     DomainId = @DomainId,
		DateReceived=@DateReceived,				
		SpecialNote=@SpecialNote,
		SpecialInstruction=@SpecialInstruction,
        No_Of_Cases=@No_Of_Cases,
        Predestinated_Path=@Predestinated_Path
        where BatchNumber=@BatchNumber
end
End

