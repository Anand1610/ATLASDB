-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[get_docs_for_azure_upload]
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	
		Select  ImageId, Filename, FilePath, PhysicalBasePath+FilePath+Filename As PhysicalFilePath, d.BasePathId, BasePathType,
		StatusDone
		from
		tblDocImages(NOLOCK) d 
		left join tblBasePath(NOLOCK) b on b.BasePathId=d.BasePathId
		where b.BasePathType = 1 
		and d.statusdone is null 
		 ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
        AND d.IsDeleted=0  
        ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
		--and d.DomainId NOT in ('SA','DL','clo')
		and filename <> ''
		--and d.ImageId = 63942
END
