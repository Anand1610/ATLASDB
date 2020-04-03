CREATE PROCEDURE [dbo].[Get_Summon_Processed_Cases]
   --@s_a_DomainId varchar(50)
AS
BEGIN
    
	--Declare @s_a_DomainId varchar(50);

	--DECLARE SummonCursor CURSOR READ_ONLY
	--FOR
	--Select distinct DomainId from tbl_Client Where lower(CompanyType)='funding'

	--OPEN SummonCursor
	--FETCH NEXT FROM SummonCursor INTO @s_a_DomainId
	
	--WHILE @@FETCH_STATUS = 0
	-- BEGIN
	--	EXEC Create_Case_Date_Details_If_Not_Exists @s_a_DomainId

	--	FETCH NEXT FROM SummonCursor INTO @s_a_DomainId
	-- END

	-- CLOSE SummonCursor
 --    DEALLOCATE SummonCursor

     --- 
	 DECLARE @tblCaseDateUpate AS TABLE
	 (
		processed_date DATETIME,
		CASE_ID VARCHAR(50),
		DomainID VARCHAR(50)
	 )
	 INSERT INTO @tblCaseDateUpate
	 Select max(processed_date) as processed_date, cd.Case_Id, cd.DomainId AS DomainId
	 from tblCase_Date_Details cd 
	 inner join tbl_batch_print_offline_queue b on CHARINDEX(cd.Case_Id,b.case_ids) >0
     inner join tbl_Client cl on cl.DomainId = cd.DomainId
	 where lower(CompanyType)='funding'	--cd.DomainId = @s_a_DomainId and b.DomainId = @s_a_DomainId 
		and  Complaint_Print_Date is null 
		and  printing_type in ('Summons Complaint MRI With Exhibits','Summons Complaint With Exhibits') and is_processed = 1 
		and processed_date is not null
	 group by cd.Case_Id, cd.DomainId



	Update cd
	set Complaint_Print_Date = processed_date
	FROM tblCase_Date_Details cd
	INNER JOIN @tblCaseDateUpate t on cd.case_id = t.case_id
    and  cd.DomainId = t.Domainid

	

	 SELECT distinct t1.CASE_ID,t2.Status_Hierarchy,t1.DomainID into #temp 
	 FROM  @tblCaseDateUpate t1
	 join tblStatus t2 on t1.DomainID=t2.DomainId and t2.Status_Type='Complaint Printed'

	Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
	select 'Complaint Print Date Added : '+Convert(varchar(20),processed_date,101), 'Workflow', 1, case_id, GETDATE(), 'admin', Domainid 
	FROM @tblCaseDateUpate
	
	UNION 
	
	select 'Status Changed To : Complaint Printed' +Convert(varchar(20),processed_date,101), 'Workflow', 1, cas.case_id, GETDATE(), 'admin', cas.Domainid 
	from tblcase cas
	INNER JOIN @tblCaseDateUpate t on cas.case_id = t.case_id and cas.Domainid= t.domainid 
	INNER JOIN tbl_Client cl on cas.DomainID = cl.DomainId
	join tblStatus ts on  cas.Status=ts.Status_Type
	join #temp on cas.Case_Id=#temp.CASE_ID and ts.Status_Hierarchy<=#temp.Status_Hierarchy
	WHERE status <> 'complaint printed' and  cl.CompanyType= 'funding'


	update cas
	set Status = 'Complaint Printed'
	from tblcase cas
	INNER JOIN @tblCaseDateUpate t on cas.case_id = t.case_id and cas.Domainid= t.domainid 
	INNER JOIN tbl_Client cl on cas.DomainID = cl.DomainId
	left join tblStatus ts on  cas.Status=ts.Status_Type
	join #temp on cas.Case_Id=#temp.CASE_ID and ts.Status_Hierarchy<=#temp.Status_Hierarchy
	WHERE status <> 'complaint printed' and  cl.CompanyType= 'funding'

	--Declare @Old_Status varchar(150);
	--Select @Old_Status = Status from tblcase(NOLOCK) where Case_Id = @s_a_Case_Id and DomainId = @s_a_DomainId

	--IF lower(@Old_Status) !='complaint printed' and  lower(@s_a_DomainId) = 'amt'
	--BEGIN
	--	--Update tblcase set Status = 'Complaint Printed' where Case_Id = @s_a_Case_Id and DomainId = @s_a_DomainId

	--	--exec LCJ_AddNotes @DomainId=@s_a_DomainId, @case_id=@s_a_Case_Id,@Notes_Type='Workflow',@Ndesc = 'Status Changed To : Complaint Printed', @user_Id='admin', @ApplyToGroup = 0  
	--END
		
END
