CREATE PROCEDURE [dbo].[selectBAtchNumbers]
(
@DomainId NVARCHAR(50)
)
as
begin
select BatchNumber from tblProvListBoxDetails
WHERE @DomainId = DomainId
end

