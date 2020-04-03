CREATE PROCEDURE [dbo].[FHA_getSettlementAmt] 
(
@DomainId nvarchar(50),
@Case_Id varchar(100)
)
as 
begin
	declare @min int
	declare @count int
	declare @flag bit 
	set @min=(select min(treatment_id) from tblsettlements where case_id=@Case_Id and DomainId=@DomainId)
	set @count=(select count(*) from tblsettlements where case_id=@Case_Id and DomainId=@DomainId)
	
	if @count>1 
		begin
			set @flag=1
			Select @flag as 'Flag',Sum(Settlement_Amount)as 'Settlement Amount',sum(Settlement_Int) as 'Settlement Int',sum(Settlement_Af) as 'Attorney Fee',sum(Settlement_Ff) as 'Filing Fee Total' from tblsettlements where case_id=@Case_Id and DomainId=@DomainId
		end
	else
		begin
			if @count=1 or @count=0 or @count=''
			begin
				set @flag=0
				select @flag as 'Flag',Settlement_Amount as 'Settlement Amount',Settlement_Int as 'Settlement Int',Settlement_Af as 'Attorney Fee',Settlement_Ff as 'Filing Fee Total' from tblsettlements where case_id=@Case_Id  and DomainId=@DomainId
				
			end
		end
end

