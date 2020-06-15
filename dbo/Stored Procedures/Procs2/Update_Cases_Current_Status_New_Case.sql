/*
Updated By :Atul jadhav
Updated Date : 06/15/2020
Change:Added Batch code
*/

Create PROCEDURE [dbo].[Update_Cases_Current_Status_New_Case]
@DomainId NVARCHAR(50),
@status varchar(100)='',
@case_status varchar(100)='',
@Cases CaseSearch readonly,
@User_Id varchar(50),
@Desc nvarchar(2000)='',
@NoteType varchar(100)='',
@CourtId varchar(100)='',
@DefendantID varchar(100)='',
@ProviderID int=0,
@IndexOrAAAno varchar(100)='',
@InsuranceCompany_Id varchar(100)='',
@Portfolio_Id varchar(20)='',
@Adjuster_Id int=0,
@Attorney_Id varchar(50)='',
@StatusDisposition varchar(1000)='',
@batchcode varchar(100)=''
AS	
BEGIN
declare   @Notes table (Notes_Desc varchar(3000),Notes_Type varchar(50),Notes_Priority varchar(50),Case_Id varchar(50),Notes_Date datetime,User_Id varchar(50),  DomainId varchar(50))
	declare @satushierachy int
	set @satushierachy=(select isnull(Status_Hierarchy,0) from tblStatus where DomainId=@DomainId and Status_Type =@status)
	print @status


	if(@Attorney_Id <>'')
	begin
	declare @Attorney varchar(500)
		set @Attorney=( SELECT ISNULL( tbl_AttorneyFirm.Name, '') from tbl_AttorneyFirm where DomainId=@DomainId and Id=@Attorney_Id)

		  insert into @Notes 
		   SELECT 'Attorney changed from '+ ISNULL( t3.Name, '') +' to ' +  ISNULL(@Attorney,'') 
		 ,'Activity',1,t1.Case_Id,getdate(),@User_Id,@DomainId
		 from  tblcase t1 
		 JOIN @Cases t2  On t1.Case_Id = t2.CaseId 
		 left join  tbl_AttorneyFirm t3  on t3.Id=t1.Attorney_Id
		 where t1.Attorney_Id<>@Attorney_Id
	end
	
	if(@Adjuster_Id <>0)
	begin
	declare @Adjuster varchar(500)
		set @Adjuster=( SELECT ISNULL( tblAdjusters.Adjuster_LastName, '')+' '+ ISNULL( tblAdjusters.Adjuster_FirstName, '') from tblAdjusters where DomainId=@DomainId and Adjuster_Id=@Adjuster_Id)

		  insert into @Notes 
		   SELECT 'Adjuster changed from '+ ISNULL( t3.Adjuster_LastName, '')+' '+ ISNULL( t3.Adjuster_FirstName, '') +' to ' +  ISNULL(@Adjuster,'') 
		 ,'Activity',1,t1.Case_Id,getdate(),@User_Id,@DomainId
		 from  tblcase t1 
		 JOIN @Cases t2  On t1.Case_Id = t2.CaseId 
		 left join  tblAdjusters t3  on t3.Adjuster_Id=t1.Adjuster_Id
		 where t1.Adjuster_Id<>@Adjuster_Id
	end
	if(@CourtId <>'')
	begin
		declare @Court_Name varchar(500)
		set @Court_Name=( SELECT Upper(ISNULL( tblcourt.Court_Name, '')) from tblcourt where DomainId=@DomainId and Court_Id=@CourtId)

		  insert into @Notes 
		   SELECT 'Court changed from '+ ISNULL(t3.Court_Name,'') +' to ' +  ISNULL(@Court_Name,'') 
		 ,'Activity',1,t1.Case_Id,getdate(),@User_Id,@DomainId
		 from  tblcase t1 
		 JOIN @Cases t2  On t1.Case_Id = t2.CaseId 
		 left join  tblcourt t3  on t3.Court_Id=t1.Court_Id
		 where t1.Court_Id<>@CourtId 		 	 
	end

	if(@DefendantID <>'')
	begin
		declare @Defendant_Name varchar(100)
		set @Defendant_Name=( SELECT Upper(ISNULL( tblDefendant.Defendant_Name, '')) from tblDefendant where DomainId=@DomainId and Defendant_id=@DefendantID)

		insert into @Notes 
		SELECT 'Defendant changed from '+ ISNULL(t3.Defendant_Name,'') +' to ' +  ISNULL(@Defendant_Name,'') 
		,'Activity',1,t1.Case_Id,getdate(),@User_Id,@DomainId
		from  tblcase t1 
		JOIN @Cases t2  On t1.Case_Id = t2.CaseId 
		left join  tblDefendant t3  on t3.Defendant_id=t1.Defendant_id
		where t1.Defendant_id<>@DefendantID 		
		
	enD
	
	if(@ProviderID<>0)
	begin
	declare @Provider_Name varchar(200)
	set @Provider_Name=( SELECT Upper(ISNULL( tblProvider.Provider_Name, '')) from tblProvider where DomainId=@DomainId and Provider_Id=@ProviderID)

		insert into @Notes 
		SELECT 'Provider changed from '+ ISNULL(t3.Provider_Name,'') +' to ' +  ISNULL(@Provider_Name,'') 
		,'Activity',1,t1.Case_Id,getdate(),@User_Id,@DomainId
		from  tblcase t1 
		JOIN @Cases t2  On t1.Case_Id = t2.CaseId 
		left join  tblProvider t3  on t3.Provider_Id=t1.Provider_Id
		where t1.Provider_Id<>@ProviderID 
	end

	if(@InsuranceCompany_Id<>0)
	begin
		declare @InsuranceCompany_Name varchar(250)
	   set @InsuranceCompany_Name=( SELECT Upper(ISNULL( tblInsuranceCompany.InsuranceCompany_Name, '')) from tblInsuranceCompany where DomainId=@DomainId and InsuranceCompany_Id=@InsuranceCompany_Id)
	  
	   insert into @Notes 
		SELECT 'Insurance changed from '+ ISNULL(t3.InsuranceCompany_Name,'') +' to ' +  ISNULL(@InsuranceCompany_Name,'') 
		,'Activity',1,t1.Case_Id,getdate(),@User_Id,@DomainId
		from  tblcase t1 
		JOIN @Cases t2  On t1.Case_Id = t2.CaseId 
		left join  tblInsuranceCompany t3  on t3.InsuranceCompany_Id=t1.InsuranceCompany_Id
		where t1.InsuranceCompany_Id<>@InsuranceCompany_Id 

	end
	if(@Portfolio_Id<>0)
	begin
		declare @Name varchar(50)
		set @Name=( SELECT Upper(ISNULL( tbl_Portfolio.Name, '')) from tbl_Portfolio where DomainId=@DomainId and Id=@Portfolio_Id)
		insert into @Notes 
		SELECT 'Portfolio changed from '+ ISNULL(t3.Name,'') +' to ' +  ISNULL(@Name,'') 
		,'Activity',1,t1.Case_Id,getdate(),@User_Id,@DomainId
		from  tblcase t1 
		JOIN @Cases t2  On t1.Case_Id = t2.CaseId 
		left join  tbl_Portfolio t3  on t3.Id=t1.PortfolioId
		where t1.PortfolioId<>@Portfolio_Id 

	end

	if(@IndexOrAAAno<>0)
	begin

		  insert into @Notes 
		SELECT 'IndexOrAAA Number changed from '+ ISNULL(t1.IndexOrAAA_Number,'') +' to ' +  ISNULL(@IndexOrAAAno,'') 
		,'Activity',1,t1.Case_Id,getdate(),@User_Id,@DomainId
		from  tblcase t1 
		JOIN @Cases t2  On t1.Case_Id = t2.CaseId 
		where t1.IndexOrAAA_Number<>@IndexOrAAAno
		
		
	end

	if(@case_status<>'')
	begin
		 insert into @Notes 
		SELECT 'Initial Status  changed from '+ ISNULL(t1.Initial_Status,'') +' to ' +  ISNULL(@case_status,'') 
		,'Activity',1,t1.Case_Id,getdate(),@User_Id,@DomainId
		from  tblcase t1 
		JOIN @Cases t2  On t1.Case_Id = t2.CaseId 
		where t1.Initial_Status<>@case_status
	end

	 

	if(@batchcode<>'')
	begin
		 insert into @Notes 
		SELECT 'batchcode changed from '+ ISNULL(t1.batchcode,'') +' to ' +  ISNULL(@batchcode,'') 
		,'Activity',1,t1.Case_Id,getdate(),@User_Id,@DomainId
		from  tblcase t1 
		JOIN @Cases t2  On t1.Case_Id = t2.CaseId 
		where t1.batchcode<>@batchcode
	end
	if(@StatusDisposition<>'')
	begin
		 insert into @Notes 
		SELECT 'Status Disposition changed from '+ ISNULL(t1.StatusDisposition,'') +' to ' +  ISNULL(@StatusDisposition,'') 
		,'Activity',1,t1.Case_Id,getdate(),@User_Id,@DomainId
		from  tblcase t1 
		JOIN @Cases t2  On t1.Case_Id = t2.CaseId 
		where t1.StatusDisposition<>@StatusDisposition
	end

	 if(@status<>'')
	begin
		declare @satushierachyN int
		set @satushierachyN=(select isnull(Status_Hierarchy,0) from tblStatus where DomainId=@DomainId and Status_Type =@status)
		insert into @Notes 
		sELECT 'Status Changed  from '+ ISNULL(t1.status,'') +' to ' +  ISNULL(@status,'') 
		,'Activity',1,t1.Case_Id,getdate(),@User_Id,@DomainId
		from  tblcase t1 
		JOIN @Cases t2  On t1.Case_Id = t2.CaseId
		left join tblStatus t3 on t1.DomainId=t3.DomainId and t3.Status_Type=t1.status 
		where t1.status <>@status and isnull(t3.Status_Hierarchy,0)>=@satushierachyN
	end
	if(@Desc<>'')
    begin
		insert  into @Notes		
		select @Desc,@NoteType,1,CaseId,getdate(),@User_Id,@DomainId
		from @Cases
	end
	
	insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id,DomainId) 
	select Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id,DomainId from  @Notes
	
	Update 
		t1 
		set 
		t1.Court_Id=case when @CourtId ='' then t1.Court_Id else @CourtId end,
		t1.Defendant_ID=case when @DefendantID ='' then t1.Defendant_ID else @DefendantID end,
		t1.Provider_Id=case when @ProviderID ='' then t1.Provider_Id else @ProviderID end,
		t1.InsuranceCompany_Id=case when @InsuranceCompany_Id ='' then t1.InsuranceCompany_Id else @InsuranceCompany_Id end,
		t1.PortfolioId=case when @Portfolio_Id ='' then t1.PortfolioId else @Portfolio_Id end,
		t1.IndexOrAAA_Number=case when @IndexOrAAAno ='' then t1.IndexOrAAA_Number else @IndexOrAAAno end,
		t1.Initial_Status=case when @case_status ='' then t1.Initial_Status else @case_status end,
		[Status]=case when @status ='' then t1.Status else case when @satushierachy>= isnull(t3.Status_Hierarchy,0) then @status else t1.Status end end,
		t1.Adjuster_Id= case when @Adjuster_Id <>0  then  @Adjuster_Id else t1.Adjuster_Id end,
		t1.Attorney_Id= case when @Attorney_Id =''  then t1.Attorney_Id else @Attorney_Id end,
		t1.StatusDisposition= case when @StatusDisposition='' then t1.StatusDisposition else @StatusDisposition end,
		t1.batchcode=case when @batchcode='' then t1.batchcode else @batchcode end
		
		from tblcase t1
		join @Cases t2 on t2.CaseId=t1.Case_Id
		left join  tblStatus t3 on t1.DomainId=t3.DomainId and t3.Status_Type=t1.status
	where t1.DomainId =@DomainId
END