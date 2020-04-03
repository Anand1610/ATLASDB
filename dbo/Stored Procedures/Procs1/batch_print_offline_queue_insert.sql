CREATE PROCEDURE [dbo].[batch_print_offline_queue_insert]  
 @s_a_domain_id   VARCHAR(MAX),  
 @s_a_printing_type  varchar(150),  
 @s_a_case_ids   VARCHAR(MAX),  
 @s_a_node_name   VARCHAR(MAX),  
 @s_a_changed_status     VARCHAR(250),  
 @b_a_is_upload_docs  BIT,  
 @i_a_configured_by_id INT,  
 @dt_a_configured_date DATETIME,  
 @i_a_template_id  INT,  
 @s_a_entity_type_ids VARCHAR(MAX),  
 @i_a_batch_type_id  INT,
 @b_a_in_sequence  BIT
AS  
BEGIN  
      
 IF @i_a_batch_type_id != 3 and Not Exists(Select * from tblDomainEmailSettings Where Domain_Id = @s_a_domain_id)  
 BEGIN  
   SELECT 'Domain email settings required.' AS result  
   return;  
 END  
  
 Declare @Packet_Cases varchar(max);  
 Declare @s_a_case_ids_new varchar(max);  
  
 Select @Packet_Cases = COALESCE(@Packet_Cases + ',',' ')+ c.Case_Id from tblCase c left join tblPacket p on p.Packet_Auto_ID=c.FK_Packet_ID   
    where (c.FK_Packet_ID is not null) and LTRIM(RTRIM(c.Case_Id)) in (Select LTRIM(RTRIM(s)) from SplitString(@s_a_case_ids,','))  
  
  
 if(Ltrim(Rtrim(@Packet_Cases)) !='' or @Packet_Cases is not null)  
 BEGIN  
    Select @s_a_case_ids_new = COALESCE(@s_a_case_ids_new + ',',' ')+ s  from SplitString(@s_a_case_ids, ',') where LTRIM(RTRIM(s)) not in(Select LTRIM(RTRIM(s)) from SplitString(@Packet_Cases, ','))  
   set @s_a_case_ids = LTRIM(RTRIM(@s_a_case_ids_new))  
 END  
  
  
    If(Ltrim(Rtrim(@s_a_case_ids)) !='')  
    BEGIN  
  Insert into tbl_batch_print_offline_queue(  
   DomainId  
  ,printing_type  
  ,case_ids  
  ,node_name  
  ,changed_status  
  ,is_upload_docs  
  ,fk_configured_by_id  
  ,configured_date  
  ,is_processed  
  ,processed_date  
  ,file_name  
  ,file_path  
  ,fk_batch_type_id  
  ,fk_template_id  
  ,entity_type_ids  
  ,IsDeleted  
  ,InSequence
  )  
  values  
  (  
    @s_a_domain_id  
    ,(CASE WHEN ISNULL(@s_a_printing_type,'') = '---Select Type of Printing---' THEN '' ELSE @s_a_printing_type END)  
    ,@s_a_case_ids  
    ,@s_a_node_name  
    ,@s_a_changed_status  
    ,@b_a_is_upload_docs  
    ,@i_a_configured_by_id  
    ,@dt_a_configured_date  
    ,0  
    ,null  
    ,''  
    ,''  
    ,@i_a_batch_type_id  
    ,(CASE WHEN ISNULL(@i_a_template_id,0) = 0 THEN NULL ELSE @i_a_template_id END)  
    ,@s_a_entity_type_ids  
    ,0  
	,@b_a_in_sequence
  )  
       
  if(Ltrim(Rtrim(@Packet_Cases)) ='' or @Packet_Cases is null)  
  BEGIN  
    SELECT 'Offline request saved successfully..!!' AS result  
  END  
  ELSE  
  BEGIN  
    SELECT 'Offline request for cases without packet saved successfully and '+ @Packet_Cases + ' are packet cases. Please refer given packet case table.' AS result  
  END  
  
    END  
    ELSE  
    BEGIN  
     SELECT @Packet_Cases + ' are packet cases. Please refer given packet case table.' AS result  
    END  
  
    if(Ltrim(Rtrim(@Packet_Cases)) !='' or @Packet_Cases is not null)  
    BEGIN  
   Select CaseIds = STUFF((SELECT N', ' + Case_Id   
     FROM tblCase AS c1  
     WHERE c1.FK_Packet_ID = c.FK_Packet_ID   
   and LTRIM(RTRIM(c1.Case_Id)) in (Select LTRIM(RTRIM(s)) from SplitString(@Packet_Cases, ','))   
     ORDER BY  c1.Case_Id   
     FOR XML PATH(N''), TYPE).value(N'.[1]', N'nvarchar(max)'), 1, 2, N''), PacketID from tblCase c inner join tblPacket p on p.Packet_Auto_ID=c.FK_Packet_ID   
     where LTRIM(RTRIM(Case_Id)) in (Select LTRIM(RTRIM(s)) from SplitString(@Packet_Cases, ',')) group by PacketID, FK_Packet_ID  
    END  
  
END  