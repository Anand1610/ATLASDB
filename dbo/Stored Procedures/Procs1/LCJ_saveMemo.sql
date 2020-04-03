
CREATE PROCEDURE [dbo].[LCJ_saveMemo](
@cid varchar(50),
@Memo nvarchar(3000),
@DomainId nvarchar(50)
)
as
begin
update tblcase set Memo = @Memo where case_id=@cid And DomainId = @DomainId
end

