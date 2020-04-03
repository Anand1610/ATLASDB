CREATE PROCEDURE [dbo].[Update_Cases_Transferred_Status]--[Update_Cases_Transferred_Status] 'LIT','AAA OPEN','FH11-82954','tech','','Activity'
	@DomainId VARCHAR(50),
	@initial_status varchar(100),
	@status varchar(100),
	@case_id varchar(20),
	@User_Id varchar(50),
    @Note_Desc VARCHAR(2000),
    @Note_Type varchar(50)
AS
BEGIN
	Declare @NDesc varchar(max)
	Declare @NDesc_init varchar(max)
    Declare @count as int
    Declare @patientname as VARCHAR(100)
    Declare @Init_Status as VARCHAR(50)
    Declare @DOA as VARCHAR(100)
    Declare @ClaimAmt as VARCHAR(100) 
	declare @Old_Status varchar(200)
    set @patientname=(select InjuredParty_LastName+' '+InjuredParty_FirstName from tblcase where case_id=@case_id)
    set @DOA=(select convert(VARCHAR(50),Accident_Date,103) from tblcase  where case_id=@case_id and DomainId=@DomainId)
    set @ClaimAmt=(select Claim_Amount from tblcase  where case_id=@case_id and DomainId=@DomainId)

    set @count=(select count(*) from tblcase  where DomainId=@DomainId and InjuredParty_LastName+' '+InjuredParty_FirstName=@patientname and convert(VARCHAR(50),Accident_Date,103)=@DOA and Claim_Amount=@ClaimAmt)

if @count=2
begin
set @Init_Status=(select initial_status from tblcase  where DomainId=@DomainId and InjuredParty_LastName+' '+InjuredParty_FirstName=@patientname and convert(VARCHAR(50),Accident_Date,103)=@DOA and Claim_Amount=@ClaimAmt and case_id<>@case_id)

if(@Init_Status='ARB')
set @initial_status='LIT'
else
set @initial_status='ARB'
end
print @initial_status
    set @NDesc = 'Status changed from '+ (select status from tblcase  where case_id = @Case_Id and DomainId=@DomainId) +' to ' + @status
	set @NDesc_init = 'Initial_Status changed from '+(select initial_status from tblcase  where DomainId=@DomainId and case_id = @Case_Id)+ ' to '+ @initial_status
	
	if(@status<>'')
	begin
	DECLARE @oldStatusHierarchy int
	DECLARE @newStatusHierarchy int
	Select top 1 @Old_Status = Status From tblcase with(nolock) where DomainId=@DomainId and Case_id=@case_id
	SET @oldStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@Old_Status)
	SET @newStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@status)

	if(@newStatusHierarchy>=@oldStatusHierarchy OR ((@newStatusHierarchy = 0 OR @oldStatusHierarchy = 0) AND @DomainID in ('AMT','PDC')))
    BEGIN
		update tblcase 
		set status = @status
		where case_id = @case_id
		and DomainId=@DomainId
	
		insert into tblNotes (DomainId,Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id)
		values (@DomainId,@NDesc,'Activity',1,@Case_Id,getdate(),@User_Id)

	END
	ELSE
	BEGIN
		declare @Description VARCHAR(200) ='Status Hierarchy Constraint error :Status cannot be changed from ' + @Old_Status + ' to ' + @status + ','   
			EXEC F_Add_Activity_Notes   @DomainID =@DomainId  
								,@s_a_case_id = @case_id    
			  ,@s_a_notes_type = 'Activity'    
			  ,@s_a_ndesc = @Description  
			  ,@s_a_user_Id = @User_Id   
			  ,@i_a_applytogroup = 0  

	END


	End
	
	if(@initial_status<>'')
	begin



	update tblcase 
	set initial_status = @initial_status
	where case_id = @case_id
	and DomainId=@DomainId
	
	insert into tblNotes (DomainId,Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id)
	values (@DomainId,@NDesc_init,'Activity',1,@Case_Id,getdate(),@User_Id)
	End   
	
    if(@Note_Desc<>'')
	begin
	insert into tblNotes (DomainId,Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id)
	values (@DomainId,@Note_Desc,@Note_Type,1,@Case_Id,getdate(),@User_Id)
	End
    
END

