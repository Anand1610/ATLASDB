CREATE PROCEDURE [dbo].[get_batch_print_images] -- [get_batch_print_images] 'GLF19-108508','localhost','Initial Submission'
	 @s_a_CaseId	varchar(50),
	 @s_a_DomainId	varchar(50),
	 @s_a_BatchType varchar(100)
AS
BEGIN
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	
	SET NOCOUNT ON;

	 DECLARE @s_l_PacketID VARCHAR(100) = ''
	 DECLARE @S_l_Packeted_Case_Ids VARCHAR(MAX)

    IF (Exists(Select Packet_Auto_ID from tblPacket(NOLOCK) where PacketID=@s_a_CaseId))
	BEGIN
	   SET @s_l_PacketID = @s_a_CaseId
	END
	ELSE
	BEGIN
		SET @s_l_PacketID = (SELECT  TOP 1 ISNULL(PacketID,'') FROM dbo.tblCase cas (NOLOCK)
		INNER  JOIN dbo.tblPacket(NOLOCK) pkt ON cas.FK_Packet_ID = pkt.Packet_Auto_ID 
		WHERE CASE_ID = @s_a_CaseId)
	END

	IF(@s_l_PacketID  IS NULL or @s_l_PacketID = '')
	BEGIN
	  Set @S_l_Packeted_Case_Ids = @s_a_CaseId
	END
	ELSE
	BEGIN
	 SET @S_l_Packeted_Case_Ids =  STUFF((SELECT ',' + CASE_ID FROM dbo.tblCase cas
								   INNER  JOIN dbo.tblPacket pkt (NOLOCK) ON cas.FK_Packet_ID = pkt.Packet_Auto_ID 
								   WHERE PacketID = @s_l_PacketID and cas.DomainID = @s_a_DomainId
								FOR XML PATH('')), 1, 1, '')
	END

	DECLARE @tblBatchImages AS TABLE
	(
		Image_Id INT,
		FilePath VARCHAR(2000),
		Sequence_No INT,
		DateInserted DATETIME,
		nodename varchar(100),
		BasePathId INT,
		FileName VARCHAR(500)
	)
	----- Need only one copy of summons and complaint
	INSERT INTO @tblBatchImages
	SELECT 
	0 as Image_Id, 
	Exhibit As FilePath,
    Sequence_No=bod.Sequence_No,
	'1990-01-01' AS DateInserted,
	'' as nodename,
	0 as BasePathId,
	'' As FileName
	from 
		tblBatchOrientDocs bod (NOLOCK)
	where 
	    (ISNULL(Exhibit,'')<>'') 
		AND bod.DomainId	=	@s_a_DomainId 
		AND LTRIM(RTRIM(bod.Batch_Type))=@s_a_BatchType 
		AND Docs_Name = 'SUMMONS AND COMPLAINT'
	INSERT INTO @tblBatchImages
	SELECT TOP 1
		I.ImageID AS Image_Id,
		(FilePath+Filename)AS FilePath,
		--(B.PhysicalBasePath+FilePath+Filename)AS Filename,
		Sequence_No=bod.Sequence_No,
		IT.DateInserted,
		nodename,
		I.BasePathId,
		Filename As FileName
	from 
		TBLDOCIMAGES I (NOLOCK)
		Join tblImageTag IT (NOLOCK) on IT.ImageID=i.ImageID and IT.DomainId = I.DomainId
		Join tblTags T (NOLOCK) on T.NodeID = IT.TagID and IT.DomainId = T.DomainId
		Join tblBasePath B (NOLOCK) on B.BasePathId = I.BasePathId
		join tblBatchOrientDocs bod (NOLOCK) ON LOWER(bod.Docs_Name) = LOWER(T.NodeName) AND bod.DomainId = T.DomainId
	where 
		I.DomainId	=	@s_a_DomainId AND
		T.CaseID	in 	(SELECT items FROM dbo.STRING_SPLIT(@S_l_Packeted_Case_Ids,',')) AND
		LTRIM(RTRIM(bod.Batch_Type))=@s_a_BatchType AND 
		LOWER(I.Filename) like '%.pdf%'
		AND NodeName = 'SUMMONS AND COMPLAINT'
	order by
		Sequence_No, DateInserted desc
	-----Otehr documents except Summons and complaint---------------------------------------------------------------------------
	INSERT INTO @tblBatchImages
	SELECT 
		0 as Image_Id, 
		Exhibit As FilePath,
		Sequence_No=bod.Sequence_No,
		'1990-01-01' AS DateInserted,
		'' as nodename,
		0 as BasePathId,
		'' as FileName
	from 
		tblBatchOrientDocs bod (NOLOCK)
	where 
	    (ISNULL(Exhibit,'')<>'') 
		AND bod.DomainId	=	@s_a_DomainId 
		AND LTRIM(RTRIM(bod.Batch_Type))=@s_a_BatchType 
		AND Docs_Name <> 'SUMMONS AND COMPLAINT'
	UNION

    SELECT
		I.ImageID AS Image_Id,
		(FilePath+Filename)AS FilePath,
		--(B.PhysicalBasePath+FilePath+Filename)AS Filename,
		Sequence_No=bod.Sequence_No,
		IT.DateInserted,
		nodename,
		I.BasePathId,
		Filename As FileName
	from 
		TBLDOCIMAGES I (NOLOCK)
		Join tblImageTag IT (NOLOCK) on IT.ImageID=i.ImageID and IT.DomainId = I.DomainId
		Join tblTags T (NOLOCK) on T.NodeID = IT.TagID and IT.DomainId = T.DomainId
		Join tblBasePath B (NOLOCK) on B.BasePathId = I.BasePathId
		join tblBatchOrientDocs bod (NOLOCK) ON LOWER(bod.Docs_Name) = LOWER(T.NodeName) AND bod.DomainId = T.DomainId
	where 
		I.DomainId	=	@s_a_DomainId AND
		T.CaseID	in 	(SELECT items FROM dbo.STRING_SPLIT(@S_l_Packeted_Case_Ids,',')) AND
		LTRIM(RTRIM(bod.Batch_Type))=@s_a_BatchType AND 
		LOWER(I.Filename) like '%.pdf%'
		AND NodeName <> 'SUMMONS AND COMPLAINT'
	order by
	Sequence_No, DateInserted asc

	SELECT * FROM @tblBatchImages ORDER BY Sequence_No ASC,DateInserted asc 
	

		--SELECT 
	--0 as Image_Id, 
	--Exhibit As FileName,
 --   Sequence_No=bod.Sequence_No,
	--IT.DateInserted,
	--'' as nodename
	--from 
	--	TBLDOCIMAGES I (NOLOCK)
	--	Join tblImageTag IT (NOLOCK) on IT.ImageID=i.ImageID and IT.DomainId = I.DomainId
	--	Join tblTags T (NOLOCK) on T.NodeID = IT.TagID and IT.DomainId = T.DomainId
	--	Join tblBasePath B (NOLOCK) on B.BasePathId = I.BasePathId
	--	join tblBatchOrientDocs bod (NOLOCK) ON LOWER(bod.Docs_Name) = LOWER(T.NodeName) AND bod.DomainId = T.DomainId
	--where 
	--    (Exhibit is not null and Exhibit<>'') AND
	--	I.DomainId	=	@s_a_DomainId AND
	--	T.CaseID	in 	(SELECT items FROM dbo.STRING_SPLIT(@S_l_Packeted_Case_Ids,',')) AND
	--	LTRIM(RTRIM(bod.Batch_Type))=@s_a_BatchType AND 
	--	LOWER(I.Filename) like '%.pdf%'
	--	AND NodeName <> 'SUMMONS AND COMPLAINT'
	--	Union


END
