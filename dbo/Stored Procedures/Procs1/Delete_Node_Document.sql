-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[Delete_Node_Document] 
	-- Add the parameters for the stored procedure here
	@DomainId nvarchar(50),
	@i_a_Image_id bigint,
	@s_a_UserName NVARCHAR(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @i_l_result INT
	DECLARE @s_l_message VARCHAR(500)
	DECLARE @s_l_Existing_Tag_IDS VARCHAR(max) = ''
	Declare @s_l_Existing_Case_ID nvarchar(200)=''

	SELECT @s_l_Existing_Tag_IDS=  convert(nvarchar(255), tblTags.NodeID )  FROM tblTags 
	INNER JOIN tblImageTag ON tblImageTag.TagID = tblTags.NodeID and tblImageTag.DomainId = tblTags.DomainID 
	WHERE tblTags.DomainID = @DomainID AND tblImageTag.ImageID=@i_a_Image_id 

	   BEGIN TRAN
	IF (ISNuLL(@s_l_Existing_Tag_IDS,'') != '')
	BEGIN

	SELECT @s_l_Existing_Case_ID=  convert(nvarchar(255), CaseID)  FROM tblTags	 
	WHERE tblTags.DomainID = @DomainID AND NodeID=convert(bigint, @s_l_Existing_Tag_IDS) 

	delete from tblTags where NodeID =convert(bigint, @s_l_Existing_Tag_IDS) 

	END

	delete from tblImageTag where domainid=@DomainId AND ImageID= @i_a_Image_id
	delete from  tblDocImages where domainid=@DomainId AND ImageID= @i_a_Image_id


	INSERT INTO tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id,DomainID)
	values('Document deleted for ImageID -'+convert(nvarchar(255), @i_a_Image_id)+ ' AND Case ID -'+@s_l_Existing_Case_ID,'Activity',1,@s_l_Existing_Case_ID,getdate(),@s_a_UserName, @DomainID)

	  SET @s_l_message	= 'Document Deleted successfully for Case ID -'+ @s_l_Existing_Case_ID
				SET @i_l_result		=  0 
	COMMIT TRAN

	SELECT @s_l_message AS [Message], @i_l_result AS [RESULT]

END
