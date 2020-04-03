CREATE PROCEDURE [dbo].[Delete_ExistingAttorney] 
(
@CaseId nvarchar(50),
@DomainId nvarchar(50)

)
as
BEGIN

	begin
		if exists(select CaseId from [dbo].[CaseAttorneyMapping] where  DomainId=@DomainId and CaseId=@CaseId)
			--if @flag = 1	
			begin
				
				delete from [dbo].[CaseAttorneyMapping] where  DomainId = @DomainId and CaseId=@CaseId
			end				
	end
	
END
