CREATE PROCEDURE [dbo].[check_case_ids_exists] 
	 @DomainID		VARCHAR(50),
	 @CaseIds		VARCHAR(MAX)
AS
BEGIN
	CREATE TABLE #temp_case_ids
	(
		case_id		VARCHAR(50)
	)

	INSERT INTO #temp_case_ids
	SELECT  items FROM dbo.STRING_SPLIT(@CaseIds,',')

	SELECT STUFF((SELECT ', ' + ISNULL(case_id,'')
              FROM  #temp_case_ids WHERE case_id NOT IN 
			  (SELECT DISTINCT case_id FROM tblcase WHERE DomainId = @DomainID AND ISNULL(IsDeleted,0) = 0
			   Union
			   SELECT DISTINCT PacketID as case_id FROM tblPacket WHERE DomainId = @DomainID)
              FOR XML PATH ('')
             ), 1, 2, '') AS case_ids;
END