-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
-- DROP  PROCEDURE [dbo].[LCJ_GetProviderDocs] 
CREATE PROCEDURE [dbo].[Provider_Documents_Retrive] -- Provider_Documents_Retrive 'localhsot',''
	-- Add the parameters for the stored procedure here
	@DomainId nvarchar(50),
	@Provider_Id int
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT (VirtualBasePath+'\'+File_Path+FileName) as File_Path
		, FileName
		, CreatedDate
		, ProviderDoc_Type
		, UserName 
		, Provider_Documents.BasePathId
		, File_Path + FileName AS FilePathWithName
	from Provider_Documents(NOLOCK) 
	INNER JOIN Provider_Document_Type(NOLOCK) on Provider_Documents.DocType_ID=Provider_Document_Type.Doc_Id
	LEFT OUTER JOIN IssueTracker_Users(NOLOCK) on Provider_Documents.CreatedBy=IssueTracker_Users.UserName and IssueTracker_Users.DomainId= @DomainId
	LEFT JOIN tblBasePath BP (NOLOCK) on BP.BasePathId = Provider_Documents.BasePathId
	--LEFT OUTER JOIN tblApplicationSettings settings ON Provider_Document_Type.DomainId =  settings.DomainId and ParameterName = 'DocumentUploadLocation' 
	where Provider_Documents.DomainId=@DomainId AND Provider_Id=@Provider_Id
END
---------------------------------------------------------------------------------------------
