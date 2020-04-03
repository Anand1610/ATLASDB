CREATE PROCEDURE [dbo].[batch_print_offline_queue_update]
	@s_a_domain_id				VARCHAR(50),
	@i_a_pk_batch_print_id		INT,
	@dt_processed_date			DATETIME,
	@s_a_file_name				VARCHAR(MAX),
	@s_a_file_path				VARCHAR(MAX),
	@s_a_processed_ids			VARCHAR(MAX)
AS
BEGIN 
SET NOCOUNT ON
	Declare @failed_caseIds varchar(max);

	Select 
		@failed_caseIds = COALESCE(@failed_caseIds + ',',' ') + LTRIM(RTRIM(s)) 
	from 
		SplitString((Select case_ids from tbl_batch_print_offline_queue where pk_batch_print_Id=@i_a_pk_batch_print_id and DomainId=@s_a_domain_id), ',')
    where LTRIM(RTRIM(s)) not in (Select LTRIM(RTRIM(s)) from SplitString(@s_a_processed_ids, ',') )
	
	UPDATE tbl_batch_print_offline_queue 
	SET
		is_processed			=	1, --CASE WHEN ISNULL(@failed_caseIds,'') = '' THEN 1 ELSE 0 END,
		in_progress				=   0,
		processed_date			=	CASE WHEN ISNULL(@failed_caseIds,'') = '' THEN @dt_processed_date ELSE NULL END,
		file_name				=	@s_a_file_name,
		file_path				=	@s_a_file_path,
		processed_case_ids		=   @s_a_processed_ids,
        failed_case_ids			=   @failed_caseIds
	WHERE
		 pk_batch_print_Id		=	@i_a_pk_batch_print_id AND 
		 DomainId    			=	@s_a_domain_id

    
	IF ISNULL(@s_a_processed_ids, '') != '' AND Exists(Select 1 From tbl_Client(NOLOCK) Where DomainId = @s_a_domain_id and lower(CompanyType)='funding') AND
	   Exists(Select 1 From tbl_batch_print_offline_queue(NOLOCK) Where pk_batch_print_Id =	@i_a_pk_batch_print_id AND DomainId = @s_a_domain_id
				AND printing_type in ('Summons Complaint MRI With Exhibits','Summons Complaint With Exhibits'))
		BEGIN
			DECLARE @tblCaseDateUpate AS TABLE
			 (
				processed_date DATETIME,
				CASE_ID VARCHAR(50),
				DomainID VARCHAR(50)
			 )

			 INSERT INTO @tblCaseDateUpate
			 Select max(processed_date) as processed_date, cd.Case_Id, cd.DomainId AS DomainId
			 from tblCase_Date_Details cd 
			 inner join tbl_batch_print_offline_queue b on pk_batch_print_Id = @i_a_pk_batch_print_id AND CHARINDEX(cd.Case_Id,@s_a_processed_ids) >0
			 inner join tbl_Client cl on cl.DomainId = cd.DomainId
			 where lower(CompanyType)='funding'
				and  Complaint_Print_Date is null 
				and  printing_type in ('Summons Complaint MRI With Exhibits','Summons Complaint With Exhibits') and is_processed = 1 
				and processed_date is not null
			 group by cd.Case_Id, cd.DomainId

			Update cd
			set Complaint_Print_Date = processed_date
			FROM tblCase_Date_Details cd
			INNER JOIN @tblCaseDateUpate t on cd.case_id = t.case_id
			and  cd.DomainId = t.Domainid

			Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
			select 'Complaint Print Date Added : '+Convert(varchar(20),processed_date,101), 'Workflow', 1, case_id, GETDATE(), 'admin', Domainid 
			FROM @tblCaseDateUpate
			UNION 
			select 'Status Changed To : Complaint Printed' +Convert(varchar(20),processed_date,101), 'Workflow', 1, cas.case_id, GETDATE(), 'admin', cas.Domainid 
			from tblcase cas
			INNER JOIN @tblCaseDateUpate t on cas.case_id = t.case_id and cas.Domainid= t.domainid 
			INNER JOIN tbl_Client cl on cas.DomainID = cl.DomainId
			WHERE status <> 'complaint printed' and  cl.CompanyType= 'funding'
			DECLARE @newStatusHierarchy int
			SET @newStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@s_a_domain_id and Status_Type='complaint printed')
			update cas
			set Status = 'Complaint Printed'
			from tblcase cas
			INNER JOIN @tblCaseDateUpate t on cas.case_id = t.case_id and cas.Domainid= t.domainid 
			INNER JOIN tbl_Client cl on cas.DomainID = cl.DomainId
		    LEFT JOIN tblStatus ts on ts.Status_Type=cas.Status 
			WHERE lower(status) <> 'complaint printed' 
			and  cl.CompanyType= 'funding'
			and	 @newStatusHierarchy>=ts.Status_Hierarchy
		END
SET NOCOUNT OFF  
END
