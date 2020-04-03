CREATE PROCEDURE [dbo].[Get_Template_Details] 
	@s_a_template_name varchar(100),
	@s_a_DomainId varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    Select 
		 template_name
		,template_file_name
		,template_path
		,template_tag_array 
		,ISNULL(BasePathId,0) AS BasePathId
	from tbl_template_word 
	where (LTRIM(RTRIM(template_file_name)) = LTRIM(RTRIM(@s_a_template_name)) OR 
	 LTRIM(RTRIM(SUBSTRING(template_file_name, 0, CHARINDEX('.', template_file_name)))) = LTRIM(RTRIM(SUBSTRING(@s_a_template_name, 0, CHARINDEX('.', @s_a_template_name))))) and DomainId= @s_a_DomainId
END
