CREATE PROCEDURE [dbo].[Get_Complaint_Template_Name]
	@s_a_CaseId varchar(50),
	@s_a_DomainId varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

  IF Exists(Select c.Case_Id from tblcase(NOLOCK) c 
   left join tblProvider(NOLOCK) p ON p.Provider_Id=c.Provider_Id
   left join tblCourt(NOLOCK) cr ON cr.Court_Id=c.Court_Id
   where 
   case_id=@s_a_CaseId and c.DomainId=@s_a_DomainId 
   and Provider_Name='North Shore Injury Center, Inc.' and  Court_Name like '%District%')
   BEGIN
	   Select 'NS Complaint Template.docx' as Template_Name 
   END
   ELSE IF Exists(Select c.Case_Id from tblcase(NOLOCK) c
   left join tblCourt(NOLOCK) cr ON cr.Court_Id=c.Court_Id
   where 
   case_id=@s_a_CaseId and c.DomainId=@s_a_DomainId
   and  Court_Name like '%circuit%')
   BEGIN
	   Select 'CIR CT Complaint - with Assignment  Template.docx' as Template_Name
   END
   ELSE
   BEGIN
	  Select 'Complaint_Form.docx' as Template_Name
   END

END
