CREATE PROCEDURE [dbo].[LCJ_GroupCasesList]
(
@DomainId VARCHAR(50),
@Case_Id VARCHAR(100)

)
AS

BEGIN
SET NOCOUNT ON
DECLARE 
   
	@var VARCHAR(500), 
	@CID varchar(50)
	set @var = ''
	--select case_id from tblCase where group_data = 1 and group_id in (select group_id from tblcase where case_id in ( @Case_Id ))
	Declare mycur cursor local for 
	select case_id from tblcase  WITH (NOLOCK) where group_data = 1 and group_id in (select group_id from tblcase  WITH (NOLOCK) where DomainId=@DomainId and case_id in ('' + @Case_Id + ''))
	OPEN mycur
	FETCH NEXT FROM mycur INTO @CID
	while @@FETCH_STATUS = 0
	BEGIN
		--print '---------------' + @CID
		Select @var = @var + ', <a href = ''WorkAreaList.aspx?sm=a1&Case_Id=' + @CID + '''>' + @CID + '</a>'
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
	SET NOCOUNT OFF

END

