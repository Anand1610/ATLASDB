CREATE PROCEDURE [dbo].[LGT_GroupCasesLinks]
(
@Case_Id nvarchar(100)

)
AS

BEGIN
DECLARE 
	@var nvarchar(500), 
	@CID varchar(50)
	set @var = ''
	--select case_id from tblCase where group_data = 1 and group_id in (select group_id from tblcase where case_id in ( @Case_Id ))
	Declare mycur cursor local for 
	select case_id from tblCase WITH (NOLOCK) where group_data = 1 and group_id in (select group_id from tblcase WITH (NOLOCK) where case_id in ('' + @Case_Id + ''))
	OPEN mycur
	FETCH NEXT FROM mycur INTO @CID
	while @@FETCH_STATUS = 0
	BEGIN
		--print '---------------' + @CID
		Select @var = @var + ', <a href = ''Settlements.aspx?sm=a6&Case_Id=' + @CID + '''>' + @CID + '</a>'
		--print @var
		FETCH NEXT FROM mycur INTO @CID
	END
	CLOSE mycur
	DEALLOCATE mycur

	IF LEN(@VAR) >0 
		SET @var = Right(@var, LEN(@var) - 1)
	ELSE
		SET @var = @Case_Id

	select @var as [output]


END

