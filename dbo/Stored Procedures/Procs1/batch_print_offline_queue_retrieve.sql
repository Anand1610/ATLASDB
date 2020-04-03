CREATE PROCEDURE [dbo].[batch_print_offline_queue_retrieve]  
(  
 @i_a_fk_batch_type_id INT  
)  
AS  
BEGIN   
 SET NOCOUNT ON;  
 IF(ISNULL((SELECT COUNT(*) FROM tbl_batch_print_offline_queue WHERE ISNULL(IsDeleted,0) = 0 AND ISNULL(is_processed,0) = 0 AND ISNULL(in_progress,0) = 1 AND fk_batch_type_id = @i_a_fk_batch_type_id),0) < 2)  
 BEGIN  
    SELECT TOP 1  
    pk_batch_print_Id,  
    Q.[DomainId],  
    [printing_type],  
    [case_ids],  
    [node_name],  
    [changed_status],  
    is_upload_docs,  
    [fk_configured_by_id],  
    configured_date,  
    is_processed,  
    processed_date,  
    file_name,  
    file_path,  
    configuredBy=U.DisplayName,  
    Email,  
    fk_batch_type_id,  
    fk_template_id,  
    entity_type_ids,  
    BT.Name AS batch_type,  
    template_tag_array,  
    template_path,  
    template_name,  
    EmailFrom,  
    Password,  
    SMTP_Port_Number,  
    SMTP_Server_Name,  
    isSSLEnabled,  
    ReplyToEmailId,  
    CompanyType,  
    ISNULL(w.BasePathId,0) AS BasePathId,
	ISNULL(InSequence, 0) AS InSequence
    FROM   
    [dbo].[tbl_batch_print_offline_queue] Q  
    JOIN IssueTracker_Users U ON U.UserId = Q.fk_configured_by_id  
    JOIN tbl_batch_type BT ON BT.ID = Q.fk_batch_type_id  
    LEFT JOIN tbl_template_word W ON W.pk_template_id = Q.fk_template_id  
    LEFT JOIN tblDomainEmailSettings DS ON DS.Domain_Id = Q.DomainId  
    LEFT JOIN tbl_Client C ON C.DomainId = Q.DomainId  
    WHERE  
    ISNULL(IsDeleted,0)  = 0 AND   
    ISNULL(is_processed,0) = 0 AND   
    ISNULL(in_progress,0) = 0 AND  
    fk_batch_type_id  = @i_a_fk_batch_type_id AND  
       Q.pk_batch_print_Id not in (Select QueueSourceId from tblTriggerTypeErrorLog tel (NOLOCK) Where ISNULL(IsResolved,0) = 0 and tel.DomainId = q.DomainId and tel.QueueType = 2)  
   ORDER BY  
    pk_batch_print_Id ASC  
 END  
 ELSE  
 BEGIN  
   --This will always return empty result  
   SELECT TOP 1  
    pk_batch_print_Id,  
    Q.[DomainId],  
    [printing_type],  
    [case_ids],  
    [node_name],  
    [changed_status],  
    is_upload_docs,  
    [fk_configured_by_id],  
    configured_date,  
    is_processed,  
    processed_date,  
    file_name,  
    file_path,  
    configuredBy=U.DisplayName,  
    Email,  
    fk_batch_type_id,  
    fk_template_id,  
    entity_type_ids,  
    BT.Name AS batch_type,  
    template_tag_array,  
    template_path,  
    template_name,  
    ISNULL(w.BasePathId,0) AS BasePathId,
	ISNULL(InSequence, 0) AS InSequence
    FROM   
    [dbo].[tbl_batch_print_offline_queue] Q  
    JOIN IssueTracker_Users U ON U.UserId = Q.fk_configured_by_id  
    JOIN tbl_batch_type BT ON BT.ID = Q.fk_batch_type_id  
    LEFT JOIN tbl_template_word W ON W.pk_template_id = Q.fk_template_id  
    WHERE  
    ISNULL(IsDeleted,0)  = -1 AND   
    ISNULL(is_processed,0) = -1 AND   
    ISNULL(in_progress,0) = -1  
   ORDER BY  
    pk_batch_print_Id ASC      
 END  
   SET NOCOUNT OFF;  
END  
  