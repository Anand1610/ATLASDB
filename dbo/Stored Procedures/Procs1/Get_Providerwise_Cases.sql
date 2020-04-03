CREATE PROCEDURE [dbo].[Get_Providerwise_Cases]
	@Provider_ID varchar(100),
	@Case_Id varchar(50),
	@DomainId varchar(50),
	@Old_CaseId varchar(50),
	@IndexorAAA_No varchar(50),
	@Patient varchar(100),
	@SearchType varchar(50)

AS
BEGIN

	SET NOCOUNT ON;
	if(@SearchType='Search_New')
  begin
  SELECT CASE_ID FROM TBLCASE WHERE DomainID= @DomainId and case_id  like '%'+@Case_Id + '%' and Provider_Id in (SELECT s FROM dbo.SplitString(@Provider_ID,','))
  end
  else if(@SearchType='Search_Old')
  begin
  SELECT CASE_ID FROM TBLCASE WHERE DomainID= @DomainId and CASE_CODE like '%' + @Old_CaseId + '%'  and Provider_Id in (SELECT s FROM dbo.SplitString(@Provider_ID,','))
  end
  else if(@SearchType='Search_IndexorAAANumber')
  begin
  SELECT CASE_ID FROM TBLCASE WHERE DomainID=@DomainId and indexoraaa_number like '%' + @IndexorAAA_No + '%'  and Provider_Id in (SELECT s FROM dbo.SplitString(@Provider_ID,','))
  end
  else if(@SearchType='Search_Patient')
  begin
  SELECT CASE_ID FROM TBLCASE WHERE DomainID= @DomainId and (injuredparty_lastname like '%' + @Patient + '%' or injuredparty_firstname like '%' + @Patient + '%')  and Provider_Id in (SELECT s FROM dbo.SplitString(@Provider_ID,','))
  end
END
