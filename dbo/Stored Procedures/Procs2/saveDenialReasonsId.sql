create procedure [dbo].[saveDenialReasonsId]
@DenialID varchar(max),
@CaseID varchar(50),
@DomianID varchar(50)
as
begin

update tblcase set MainDenialReasonsId=@DenialID where Case_Id=@CaseID and DomainId=@DomianID
end