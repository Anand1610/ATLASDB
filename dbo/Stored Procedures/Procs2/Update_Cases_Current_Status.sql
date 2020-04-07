--Update_Cases_Current_Status '0PEN-OK-BPO','INITIAL BILLING','FH07-42372','tech','test23233','{CLOSED}','8'
CREATE PROCEDURE [dbo].[Update_Cases_Current_Status]
	@DomainId VARCHAR(50),
	@status varchar(100),
	@case_status varchar(100)='',
	@case_id varchar(20),
	@User_Id varchar(50),
    @Desc VARCHAR(2000)='',
    @NoteType varchar(100)='',
    @CourtId varchar(100)='',
	@DefendantID varchar(100)='',
    @ProviderID int=0,
	@IndexOrAAAno varchar(100)='',
	@InsuranceCompany_Id varchar(100)='',
	@Portfolio_Id varchar(20)='',
	@DefAttorneyFile varchar(100)='',
	@StatusDisposition varchar(1000)=''

AS
BEGIN
    Declare @NDesc varchar(max),
    --@Description VARCHAR(2000),
	@old_stat_hierc int,  
	@new_stat_hierc int,
	@motion_stat_hierc smallint,
	@PROVIDER_ID VARCHAR(50) ,
	@provider_ff nchar(10),
	@status_bill money,
	@status_bill_type VARCHAR(20),
	@status_bill_notes varchar(200),
	@st varchar(MAX)

	DECLARE @OldValue VARCHAR(100), @newValue VARCHAR(100)

		----------Start Status Disposition--------------------
    if(@StatusDisposition <>'')
	begin
		
		SET @OldValue = (SELECT StatusDisposition FROM tblCase WHERE Case_ID = @Case_Id and DomainId = @DomainId) 
		SET @newValue = @StatusDisposition 
		
		IF ISNULL(@OldValue,'') <> ISNULL(@newValue,'')
		BEGIN
		
			SET @NDesc ='StatusDisposition changed from '+ ISNULL(@OldValue,'') +' to ' + ISNULL(@newValue,'')
			 
			update tblcase set StatusDisposition = @StatusDisposition	where Case_Id =@case_id	and DomainId = @DomainId
			
			Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				values (@NDesc,'Activity',1,@Case_Id,getdate(),@User_Id,@DomainId)
			 
		END
		
	end


    
 ----------END Status Disposition Change--------------------



	if(@CourtId <>'')
	begin

	    SET @OldValue = (SELECT Upper(ISNULL(Court_Name, '')) from tblCourt WHERE Court_Id in (SELECT Court_Id FROM tblcase WHERE Case_Id = @Case_Id and DomainId=@DomainId	))
		SET @newValue = (SELECT Upper(ISNULL(Court_Name, '')) from tblCourt WHERE Court_Id = @CourtId and DomainId=@DomainId)

		IF ISNULL(@OldValue,'') <> ISNULL(@newValue,'')
		BEGIN
			Set @NDesc = 'Court changed from '+  @OldValue +' to ' + @newValue
			update tblcase set Court_Id = @CourtId	where Case_Id = @case_id and DomainId=@DomainId	

		    insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
		    values (@NDesc,'Activity',1,@Case_Id,getdate(),@User_Id,@DomainId)
	   END
	end

	---      START Defendant CHANGE -------------------
	if(@DefendantID <>'')
	begin
	
		SET @OldValue = (SELECT Upper(ISNULL(Defendant_DisplayName, '')) from tblDefendant WHERE Defendant_Id in (SELECT Defendant_Id FROM tblcase WHERE Case_Id = @Case_Id and DomainId=@DomainId	))
		SET @newValue = (SELECT Upper(ISNULL(Defendant_DisplayName, '')) from tblDefendant WHERE Defendant_Id = @DefendantID and DomainId=@DomainId)

		IF ISNULL(@OldValue,'') <> ISNULL(@newValue,'')
		BEGIN
		
			set @NDesc = 'Defendant changed from '+ ISNULL(@OldValue,'') +' to ' + ISNULL(@newValue,'')
			
			update tblcase set Defendant_ID =@DefendantID where Case_Id =@case_id and DomainId=@DomainId	
			
			 Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
			 values (@NDesc,'Activity',1,@Case_Id,getdate(),@User_Id,@DomainId)
		END
	end
	---      END Defendant CHANGE --------------------	
    ---- START PROVIDER CHANGE-----------------------
	if(@ProviderID<>0)
	begin
		SET @OldValue = (SELECT Upper(ISNULL(Provider_Name, '')) from tblProvider WHERE Provider_Id in (SELECT Provider_Id FROM tblcase WHERE Case_Id = @Case_Id and DomainId=@DomainId	))
		SET @newValue = (SELECT Upper(ISNULL(Provider_Name, '')) from tblProvider WHERE Provider_Id = @ProviderID and DomainId=@DomainId)

		IF ISNULL(@OldValue,'') <> ISNULL(@newValue,'')
			BEGIN
		
				set @NDesc = 'Provider changed from '+ ISNULL(@OldValue,'') +' to ' + ISNULL(@newValue,'')
			
				update tblcase set Provider_Id =@ProviderID where Case_Id =@case_id and DomainId=@DomainId		
			    
				Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				values (@NDesc,'Activity',1,@Case_Id,getdate(),@User_Id,@DomainId)
				--exec LCJ_AddNotes @DomainId=@DomainId, @case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @NDesc, @user_Id=@User_Id, @ApplyToGroup = 0  
			END
	end
	----END PROVIDER CHANGE
	----- START Insurance Company Change----------------

	if(@InsuranceCompany_Id<>'')
	Begin
	 SET @OldValue = (SELECT Upper(ISNULL(InsuranceCompany_Name, '')) from tblInsuranceCompany WHERE InsuranceCompany_Id in (SELECT InsuranceCompany_Id FROM tblcase WHERE Case_Id = @Case_Id and DomainId=@DomainId	))
	 SET @newValue = (SELECT Upper(ISNULL(InsuranceCompany_Name, '')) from tblInsuranceCompany WHERE InsuranceCompany_Id = @InsuranceCompany_Id and DomainId=@DomainId)
	
	   IF ISNULL(@OldValue,'') <> ISNULL(@newValue,'')
		BEGIN
		    set @NDesc = 'Insurance Company changed from '+ ISNULL(@OldValue,'') +' to ' + ISNULL(@newValue,'')

			update tblcase set InsuranceCompany_Id = @InsuranceCompany_Id where Case_Id =@case_id and DomainId=@DomainId
			
			Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
			values (@NDesc,'Activity',1,@Case_Id,getdate(),@User_Id,@DomainId)
			--exec LCJ_AddNotes @DomainId=@DomainId, @case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @NDesc, @user_Id=@User_Id, @ApplyToGroup = 0  

		END
	End

	-----------End Insurance Company Change-------------

		----------Start Portfolio Change--------------------
  if(@Portfolio_Id<>'')  
 Begin  
  SET @OldValue = (SELECT Upper(ISNULL( Name, '')) from tbl_Portfolio WHERE ID in (SELECT Portfolioid FROM tblcase WHERE Case_Id = @Case_Id and DomainId=@DomainId ))  
  SET @newValue = (SELECT Upper(ISNULL(Name, '')) from tbl_Portfolio WHERE ID = @Portfolio_Id and DomainId=@DomainId)    
   
    IF ISNULL(@OldValue,'') <> ISNULL(@newValue,'')  
  BEGIN  
      set @NDesc = 'Portfolio changed from '+ ISNULL(@OldValue,'') +' to ' + ISNULL(@newValue,'')  
  
   update tblcase set PortfolioId = @Portfolio_Id where Case_Id =@case_id and DomainId=@DomainId  
     
   Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)  
   values (@NDesc,'Activity',1,@Case_Id,getdate(),@User_Id,@DomainId)  
   --exec LCJ_AddNotes @DomainId=@DomainId, @case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @NDesc, @user_Id=@User_Id, @ApplyToGroup = 0    
  
  END  
 End 

    
 ----------END Portfolio Change--------------------

 ----------Start DefAttorneyFile Change--------------------  
  
  if(@DefAttorneyFile <>'')  
 begin  
    
  SET @OldValue = (SELECT Attorney_FileNumber FROM tblCase WHERE Case_ID = @Case_Id and DomainId = @DomainId)   
  SET @newValue = @DefAttorneyFile   
    
  IF ISNULL(@OldValue,'') <> ISNULL(@newValue,'')  
  BEGIN  
    
   SET @NDesc ='Attorney_FileNumber changed from '+ ISNULL(@OldValue,'') +' to ' + ISNULL(@newValue,'')  
      
   update tblcase set Attorney_FileNumber = @DefAttorneyFile where Case_Id =@case_id and DomainId = @DomainId  
     
   Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)  
    values (@NDesc,'Activity',1,@Case_Id,getdate(),@User_Id,@DomainId)  
      
  END  
    
 end  
  
  
      
 ----------END DefAttorneyFile Change--------------------  

		
    ---      START INDEX OR AAA CHANGE ------------------
	if(@IndexOrAAAno <>'')
	begin
		
		SET @OldValue = (SELECT IndexOrAAA_Number FROM tblCase WHERE Case_ID = @Case_Id and DomainId = @DomainId) 
		SET @newValue = @IndexOrAAAno 
		
		IF ISNULL(@OldValue,'') <> ISNULL(@newValue,'')
		BEGIN
		
			SET @NDesc ='Index/AAA/NAM# changed from '+ ISNULL(@OldValue,'') +' to ' + ISNULL(@newValue,'')
			 
			update tblcase set IndexOrAAA_Number =@IndexOrAAAno	where Case_Id =@case_id	and DomainId = @DomainId
			
			Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
				values (@NDesc,'Activity',1,@Case_Id,getdate(),@User_Id,@DomainId)
			--exec LCJ_AddNotes @DomainId=@DomainId, @case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @NDesc, @user_Id=@User_Id, @ApplyToGroup = 0 
		END
		
	end
	---      END INDEX OR AAA CHANGE --------------------	

	if(@case_status<>'')
	begin
	  set @NDesc = 'Initial Status changed from '+ (select Initial_Status from tblcase where case_id = @Case_Id) +' to ' + @case_status
	   update tblcase
	   set  Initial_Status = @case_status
	   where case_id = @case_id
   	
	   insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
	   values (@NDesc,'Activity',1,@Case_Id,getdate(),@User_Id,@DomainId)
    end
        
	if(@Desc<>'')
    begin
    insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id,DomainId)
	values (@Desc,@NoteType,1,@Case_Id,getdate(),@User_Id,@DomainId)
	end
	
	if(@status<>'')
	begin
	
			DECLARE @oldStatus VARCHAR(500)
			DECLARE @newStatus VARCHAR(500)

			SET @oldStatus = (select status from tblcase where case_id = @Case_Id and DomainId=@DomainId)
			SET @newStatus=@status
	

            SELECT @old_stat_hierc = STATUS_HIERARCHY FROM Tblstatus INNER JOIN TBLcase ON dbo.tblcase.status = dbo.tblstatus.status_Type
			where dbo.tblcase.case_id=@Case_id AND dbo.tblcase.status=@oldStatus  and tblcase.DomainId=@DomainId

		
			SELECT @new_stat_hierc = STATUS_HIERARCHY ,@status_bill = auto_bill_amount ,@status_bill_type = auto_bill_type,
				   @status_bill_notes=auto_bill_notes
			FROM Tblstatus
			 where status_type=@newStatus
			  and DomainId=@DomainId


			if(@oldStatus <> @newStatus)
			BEGIN
			 IF (dbo.CheckStatusHierarchy(@Case_id, @oldStatus, @newStatus, @User_Id, @DomainId) = 1 OR @DomainId not in ('PDC','AMT'))
    BEGIN
    UPDATE tblcase SET STATUS = @newStatus WHERE CASE_ID = @Case_Id AND DomainId = @DomainId  
    set @NDesc = 'Status changed from ' + @oldStatus + ' to ' + @newStatus     
    Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)  
    values (@NDesc,'Activity',1,@Case_Id,getdate(),@User_Id,@DomainId) 
	END
	ELSE
	BEGIN
    declare @Description VARCHAR(200) ='Status Hierarchy Constraint error :Status cannot be changed from ' + @OldStatus + ' to ' + @NewStatus + ',' 
    EXEC F_Add_Activity_Notes   @DomainID =@DomainID
	                           ,@s_a_case_id = @Case_Id  
							   ,@s_a_notes_type = 'Activity'  
							   ,@s_a_ndesc = @Description
							   ,@s_a_user_Id = @User_Id 
							   ,@i_a_applytogroup = 0  
	END
				--exec LCJ_AddNotes @DomainId=@DomainId,@case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @NDesc,@user_Id=@User_Id,@ApplyToGroup = 0  
			end

			--if(@User_Id<>'ljainarine')
			-- BEGIN
				--IF ((@new_stat_hierc < @old_stat_hierc) OR (@new_stat_hierc < 900 AND @motion_stat_hierc = 1)) and @user_id <>'srosenthal'
				--BEGIN
				--	set @NDesc = 'Status Hierarchy Constraint error :status cannot be changed from ' + @oldStatus + ' to ' + @newStatus +'.  >>XM-003'       
				--	exec LCJ_AddNotes @case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @NDesc,@user_Id=@User_Id,@ApplyToGroup = 0
				--	RETURN
				--END
			 -- END
			--IF @status_bill > 0
			--BEGIN

			--	SELECT @provider_id=tblcase.provider_id ,@provider_ff = tblProvider.provider_ff 
			--	FROM   tblProvider INNER JOIN tblcase ON tblProvider.Provider_Id = tblcase.Provider_Id
			--	WHERE tblcase.case_id =@case_id  and tblcase.DomainId=@DomainId


			--	INSERT INTO TBLTRANSACTIONS(CASE_ID,TRANSACTIONS_TYPE,TRANSACTIONS_DATE,TRANSACTIONS_AMOUNT,TRANSACTIONS_DESCRIPTION,PROVIDER_ID,TRANSACTIONS_FEE,USER_ID, DomainId)
			--	VALUES (@case_id,@status_bill_type,GETDATE(),@status_bill,@status_bill_notes,@PROVIDER_ID,@status_bill,@USER_ID,@DomainId)

			--	set @NDesc = 'Payment/Transaction posted :'+ CONVERT(VARCHAR(20),@status_bill) +' '+'('+ @status_bill_type +') Desc-> ' + @status_bill_notes + '. New Status-> '+ @newStatus + ' .' 
			--	exec LCJ_AddNotes @DomainId=@DomainId, @case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @NDesc,@user_Id=@User_Id,@ApplyToGroup = 0
   --        END
	 	
		 
		
	
	END

	
End

