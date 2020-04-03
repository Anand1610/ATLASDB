CREATE PROCEDURE [dbo].[ADD_RTF_TEMPLATE] -- ADD_RTF LATE 'DAMBROSIO & DAMBROSIO, P.C. ( FOR SUPPLY COMPANY).rtf','Oss'
	@DomainId varchar(50),
	@filename varchar(200),
	@usertype varchar(10)
AS
BEGIN
	DECLARE @temp_id AS int
	Declare @count as int

	declare @value nvarchar(50)
	declare @delimit nvarchar(4)
	select
      @delimit = '.rtf'
	
	SET
      @value = SUBSTRING(@filename,1,CHARINDEX(@delimit,@filename)-1)
	select
      @value as retSplittedValue

	if((select count(*) from MST_TEMPLATES where SZ_TEMPLATE_PATH = @filename and DomainId = @DomainId) = 0)
	Begin
		insert into dbo.MST_TEMPLATES(SZ_TEMPLATE_NAME,SZ_TEMPLATE_FORMAT,SZ_TEMPLATE_PATH,SZ_TEMPLATE_FILENAME,DomainId)
		values(@value,'RTF',@filename, @filename,@DomainId)

		select @temp_id = I_TEMPLATE_ID from MST_TEMPLATES where SZ_TEMPLATE_PATH = @filename and DomainId = @DomainId

		--insert into dbo.TXN LATES_ACCESS (TEMPLATE_ID,USER_TYPE)
		--values( @temp_id,@usertype)
	End


END

