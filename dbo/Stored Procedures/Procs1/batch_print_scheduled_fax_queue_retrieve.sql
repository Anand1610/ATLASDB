CREATE PROCEDURE [dbo].[batch_print_scheduled_fax_queue_retrieve]  
AS  
BEGIN  
 SELECT TOP 1
		pk_bp_fax_queue_id,
		pk_bp_ef_status_id,  
		DomainID=Q.Domain_Id,  
		fk_bp_ef_status_id=Q.fk_bp_ef_status_id,  
		FaxNumber,  
		SentByUser,  
		SentOn,  
		IsAddedtoQueue=ISNULL(IsAddedtoQueue,0),  
		isDeleted=ISNULL(Q.isDeleted,0),    
		FaxQueueID,  
		PhysicalBasePath=(SELECT TOP 1 BP.PhysicalBasePath FROM tblBasePath BP JOIN tblApplicationSettings APS ON BP.BasePathId = APS.ParameterValue WHERE ParameterName = 'BasePathId'),  
		FilePath=(SELECT TOP 1 FilePath FROM tblDocImages DI WHERE DI.ImageID = R.documentImageID
		
		---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
		and DI.IsDeleted=0
        ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
		
		),  
		NodeID=(SELECT TOP 1 T.NodeID FROM tblTags T JOIN tblImageTag IT ON T.NodeID = IT.TagID WHERE T.CaseID = R.case_Id AND T.DomainId = R.DomainID AND IT.ImageID = R.documentImageID
		---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
		AND   IT.IsDeleted=0 
        ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
		),  
		SZ_CASE_ID=R.case_Id,  
		BasePathId=(SELECT TOP 1 BP.BasePathId FROM tblBasePath BP JOIN tblApplicationSettings APS ON BP.BasePathId = APS.ParameterValue WHERE ParameterName = 'BasePathId'),  
		SentByUserID=(SELECT TOP 1 U.UserId FROM IssueTracker_Users U WHERE LOWER(U.UserName) = LOWER(SentByUser) AND U.DomainId = Q.Domain_Id)  
 FROM  
	  tbl_batch_print_fax_queue Q  
	  JOIN tbl_batch_print_offline_email_fax_status R ON Q.fk_bp_ef_status_id = R.pk_bp_ef_status_id  
 WHERE  
	  LOWER(ISNULL(R.FaxStatus,'')) = 'scheduled' AND  
	  ISNULL(Q.isDeleted,0)   = 0   AND  
	  ISNULL(R.isDeleted,0)   = 0   AND  
	  ISNULL(IsAddedtoQueue,0)  = 1   
 ORDER BY  
	pk_bp_ef_status_id ASC  
END 
-------------------------------------------------------------------------------------------------------------------------
