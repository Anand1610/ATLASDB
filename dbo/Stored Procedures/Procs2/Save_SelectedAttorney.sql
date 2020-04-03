CREATE PROCEDURE [dbo].[Save_SelectedAttorney] 
(
@CaseId nvarchar(50),
@AttorneyId int,
@DomainId nvarchar(50)

)
as
BEGIN

	begin
		if exists(select CaseId from [dbo].[CaseAttorneyMapping] where AttorneyId=@AttorneyId and DomainId=@DomainId and CaseId=@CaseId)
			--if @flag = 1	
			begin
				
				delete from [dbo].[CaseAttorneyMapping] where  DomainId = 'xxx'
			end		
		else
			begin				
				insert into [dbo].[CaseAttorneyMapping] values (@CaseId,@AttorneyId,@DomainId)
			end
	end
	
END
