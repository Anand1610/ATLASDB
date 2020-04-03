CREATE PROCEDURE [dbo].[VERIFICATION_RESPONSE_FAX_QUEUE_SCHEDULED_RETRIEVE]  
AS  
BEGIN  
	IF(ISNULL((SELECT COUNT(*) FROM tbl_verification_response_fax_queue WHERE ISNULL(IsDeleted,0) = 0 AND ISNULL(IsAddedtoQueue,0) = 1 AND  ISNULL(inprogress_download,0) = 1),0) < 3)  
		BEGIN
			 SELECT TOP 2
			  pk_vr_fax_queue_id,  
			  DomainID=Q.DomainID,  
			  i_verification_id=Q.i_verification_id,  
			  FaxNumber,  
			  SentByUser,  
			  SentOn,  
			  IsAddedtoQueue=ISNULL(IsAddedtoQueue,0),  
			  isDeleted=ISNULL(isDeleted,0),    
			  FaxQueueID,  
			  PhysicalBasePath=(SELECT TOP 1 BP.PhysicalBasePath FROM tblBasePath BP JOIN tblApplicationSettings APS ON BP.BasePathId = APS.ParameterValue WHERE ParameterName = 'BasePathId'),  
			  FilePath=R.DomainID+'\'+R.SZ_CASE_ID+'\VERIFICATION RESPONSE\',  
			  NodeID=(SELECT TOP 1 T.NodeID FROM tblTags T WHERE T.CaseID = R.SZ_CASE_ID AND T.DomainId = R.DomainID AND LOWER(T.NodeName) = 'verification response'),  
			  SZ_CASE_ID=R.SZ_CASE_ID,  
			  BasePathId=(SELECT TOP 1 BP.BasePathId FROM tblBasePath BP JOIN tblApplicationSettings APS ON BP.BasePathId = APS.ParameterValue WHERE ParameterName = 'BasePathId'),  
			  SentByUserID=(SELECT TOP 1 U.UserId FROM IssueTracker_Users U WHERE LOWER(U.UserName) = LOWER(SentByUser) AND U.DomainId = Q.DomainID)  
			 FROM  
			  tbl_verification_response_fax_queue Q  
			  JOIN txn_verification_request R ON Q.i_verification_id = R.i_verification_id  
			 WHERE  
			  LOWER(R.FaxStatus)   = 'scheduled' AND  
			  ISNULL(isDeleted,0)   = 0   AND  
			  ISNULL(IsAddedtoQueue,0) = 1   AND
			  ISNULL(inprogress_download,0) = 0
			 ORDER BY  
			  pk_vr_fax_queue_id ASC  
	    END
	ELSE
		BEGIN
			 SELECT  TOP 1
			  pk_vr_fax_queue_id,  
			  DomainID=Q.DomainID,  
			  i_verification_id=Q.i_verification_id,  
			  FaxNumber,  
			  SentByUser,  
			  SentOn,  
			  IsAddedtoQueue=ISNULL(IsAddedtoQueue,0),  
			  isDeleted=ISNULL(isDeleted,0),    
			  FaxQueueID,  
			  PhysicalBasePath=(SELECT TOP 1 BP.PhysicalBasePath FROM tblBasePath BP JOIN tblApplicationSettings APS ON BP.BasePathId = APS.ParameterValue WHERE ParameterName = 'BasePathId'),  
			  FilePath=R.DomainID+'\'+R.SZ_CASE_ID+'\VERIFICATION RESPONSE\',  
			  NodeID=(SELECT TOP 1 T.NodeID FROM tblTags T WHERE T.CaseID = R.SZ_CASE_ID AND T.DomainId = R.DomainID AND LOWER(T.NodeName) = 'verification response'),  
			  SZ_CASE_ID=R.SZ_CASE_ID,  
			  BasePathId=(SELECT TOP 1 BP.BasePathId FROM tblBasePath BP JOIN tblApplicationSettings APS ON BP.BasePathId = APS.ParameterValue WHERE ParameterName = 'BasePathId'),  
			  SentByUserID=(SELECT TOP 1 U.UserId FROM IssueTracker_Users U WHERE LOWER(U.UserName) = LOWER(SentByUser) AND U.DomainId = Q.DomainID)  
			 FROM  
			  tbl_verification_response_fax_queue Q  
			  JOIN txn_verification_request R ON Q.i_verification_id = R.i_verification_id  
			 WHERE  
			  LOWER(R.FaxStatus)   = 'scheduled' AND  
			  ISNULL(isDeleted,0)   = -1   AND  
			  ISNULL(IsAddedtoQueue,0) = -1   AND
			  ISNULL(inprogress_download,0) = -1
			 ORDER BY  
			  pk_vr_fax_queue_id ASC  
		END
END  

