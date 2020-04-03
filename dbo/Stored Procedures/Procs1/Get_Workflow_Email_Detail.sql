-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE Get_Workflow_Email_Detail
	@s_a_CaseId varchar(50),
	@s_a_DomainId varchar(50),
	@s_a_AssociatedEntity varchar(500)
AS
BEGIN
	
	SET NOCOUNT ON;
     
	 If @s_a_AssociatedEntity = 'adjuster'
	 BEGIN
		Select (isnull(Adjuster_FirstName, '') +' '+ isnull(Adjuster_LastName, '')) as AttorneyName, Adjuster_Email as EmailAddress 
		from 
		tblcase(NOLOCK) c inner join tblAdjusters a on a.Adjuster_Id = c.Adjuster_Id
		where Case_Id=@s_a_CaseId and c.DomainId = @s_a_DomainId
	 END
	ELSE If @s_a_AssociatedEntity = 'plaintiff attorney'
	 BEGIN
	   Select a.Assigned_Attorney as AttorneyName, Assigned_Attorney_Email as EmailAddress
	   from 
	   tblcase(NOLOCK) c inner join Assigned_Attorney a on a.PK_Assigned_Attorney_ID = c.Assigned_Attorney
	   where Case_Id=@s_a_CaseId and c.DomainId = @s_a_DomainId
	 END
	ELSE If @s_a_AssociatedEntity = 'opposing counsel attorney'
	 BEGIN
	  Select '' as AttorneyName, '' as EmailAddress
	  --Select a.Attorney_FirstName as FirstName, Attorney_LastName as LastName, Attorney_Email as EmailAddress
	  --from 
	  --tblcase(NOLOCK) c inner join tblAttorney_Master a on a.Attorney_Id = c.Attorney_Id
	  --where Case_Id=@s_a_CaseId and c.DomainId = @s_a_DomainId
	 END
	 ELSE
	 BEGIN
	  Select '' as AttorneyName, '' as EmailAddress
	 END

END
