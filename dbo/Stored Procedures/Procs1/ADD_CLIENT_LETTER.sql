CREATE PROCEDURE [dbo].[ADD_CLIENT_LETTER] -- ADD_CLIENT_LETTER 'DAMBROSIO & DAMBROSIO, P.C. ( FOR SUPPLY COMPANY).rtf','Oss'
	@filename varchar(200)
AS
BEGIN
	DECLARE @temp_id AS int
	Declare @count as int

	declare @value nvarchar(50)
	declare @delimit nvarchar(4)
	select
      @delimit = '.'
	
	SET
      @value = SUBSTRING(@filename,1,CHARINDEX(@delimit,@filename)-1)
	select
      @value as retSplittedValue

	if((select count(*) from tbl_Client_Letter where Letter_FileName = @filename) = 0)
	Begin
		insert into dbo.tbl_Client_Letter(Letter_Display_Name, Letter_FileName)
		values(@value, @filename)

	End
END

