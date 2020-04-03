--SP_CHECK_COPY_TO_CASE '1908',0
CREATE PROCEDURE [dbo].[SP_CHECK_COPY_TO_CASE]
(
	@DomainId NVARCHAR(50),
	@SZ_DESTINATION_CASE_ID VARCHAR(MAX)='SSBW-AUTO-ACC-7082',
	@s_a_image_id			INT
)
AS
BEGIN
		DECLARE @s_a_case_id		VARCHAR(MAX) = ''
		DECLARE @i_l_dest_nodeid	INT = 0
		DECLARE @s_l_source_path	VARCHAR(MAX) = ''
		DECLARE @s_l_file_name		VARCHAR(MAX) = ''
	
		SELECT @s_a_case_id = pk_case_id FROM IRIS.dbo.tbl_case_details WHERE file_number = @SZ_DESTINATION_CASE_ID
		IF(@s_a_case_id <> '')
		BEGIN
				EXEC SP_TBL_TAGS_NEW_CASE_NODE_INSERT @s_a_case_id
			
				SELECT @i_l_dest_nodeid	= nodeid FROM tblTags WHERE CaseID = @s_a_case_id and ParentID IS NULL and DomainId=@DomainId
				
				SELECT @s_l_source_path = B.PhysicalBasePath + FilePath + Filename,@s_l_file_name = Filename FROM tblDocImages I Left Join tblBasePath B on I.BasePathId=B.BasePathId
				WHERE ImageID = @s_a_image_id and DomainId=@DomainId
		END
		SELECT @i_l_dest_nodeid AS nodeid,@s_a_case_id AS case_id,@s_l_source_path AS source_path,@s_l_file_name AS file_name
END

