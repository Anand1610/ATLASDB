CREATE PROCEDURE [dbo].[LCJ_AddSettlements]
(
@DomainId NVARCHAR(50),
@Settlement_Amount 	money,
@Settlement_Int		money,
@Settlement_Af		money,
@Settlement_Ff		money,
@Settlement_Total 	money,
@Settlement_Date	datetime,
@Case_Id 		nvarchar(100),
@User_Id		nvarchar(50),
@SettledWith		nvarchar(400),
@Settlement_Notes	nvarchar(2000),
@Settled_Type       nvarchar(100),
@Settled_by       nvarchar(100),
@Treatment_Id		INT,
@Adjuster_Id 		int,    
@Adjuster_Attorney varchar(2),
@Settled_Percent    decimal(5,2)

)

AS
	declare @Settled_With_Name varchar(400)
	declare @Settled_With_Phone varchar(100)
	declare @Settled_With_Fax varchar(100)  

if @Treatment_Id = 0
begin
select @Treatment_Id = treatment_id from tbltreatment where case_id=@Case_Id and DomainId=@DomainId
end

	BEGIN  
   IF @Adjuster_Attorney = 'AD'  
     BEGIN  
        set @Settled_With_Name=(select Adjuster_FirstName + ' ' + Adjuster_LastName from tblAdjusters where Adjuster_Id= + cast(@Adjuster_Id as int) and DomainId=@DomainId)   
        set @Settled_With_Phone =(select Adjuster_Phone from tblAdjusters where Adjuster_Id= + cast(@Adjuster_Id as int) and DomainId=@DomainId)   
        set @Settled_With_Fax =(select Adjuster_Fax from tblAdjusters where Adjuster_Id= + cast(@Adjuster_Id as int) and DomainId=@DomainId)   
	
     END  
   ELSE  
     IF @Adjuster_Attorney = 'AT'  
       BEGIN  
            
          set @Settled_With_Name=(select Attorney_FirstName +' '+ Attorney_LastName from tblAttorney where Attorney_AutoId= + @Adjuster_Id and DomainId=@DomainId)   
          set @Settled_With_Phone =(select Attorney_Phone from tblAttorney where Attorney_AutoId= + @Adjuster_Id and DomainId=@DomainId)   
          set @Settled_With_Fax =(select Attorney_Fax from tblAttorney where Attorney_AutoId= + @Adjuster_Id and DomainId=@DomainId)   
       END 

ELSE  
     IF @Adjuster_Attorney = 'DF'  
       BEGIN  
            
          set @Settled_With_Name=(select Defendant_Name  from tblDefendant where Defendant_id = + @Adjuster_Id and DomainId=@DomainId)   
          set @Settled_With_Phone =(select Defendant_Phone from tblDefendant where Defendant_id= + @Adjuster_Id and DomainId=@DomainId)   
          set @Settled_With_Fax =(select Defendant_Fax from tblDefendant where Defendant_id= + @Adjuster_Id and DomainId=@DomainId)   
       END 
ELSE
	IF @Adjuster_Attorney = 'ATTORNEY'
	 BEGIN
		 set @Settled_With_Name= (Select TOP 1 ISNULL(Attorney_FirstName,'') + ' ' + ISNULL(Attorney_LastName,'') from tblAttorney_Master where Attorney_Id = @Adjuster_Id and DomainId = @DomainId)
		 set @Settled_With_Phone= (Select TOP 1 ISNULL(Attorney_Phone,'')  from tblAttorney_Master where Attorney_Id = @Adjuster_Id and DomainId = @DomainId)
		 set @Settled_With_Fax= (Select TOP 1 ISNULL(Attorney_Fax,'')  from tblAttorney_Master where Attorney_Id = @Adjuster_Id and DomainId = @DomainId)
	 END

INSERT INTO tblSettlements

(
	Settlement_Amount,
	Settlement_Int,
	Settlement_Af,
	Settlement_Ff,
	Settlement_Total,
	Settlement_Date,
	Case_Id,
	User_Id,
	Settlement_Notes,
	Settled_Type,
	Settled_by,
	SettledWith,
	Treatment_Id,
	Settled_With_Name,  
	Settled_With_Phone,  
	Settled_With_Fax,
	Settled_Percent,
	DomainId
)


VALUES

(

	
	@Settlement_Amount,
	@Settlement_Int,
	@Settlement_Af,
	@Settlement_Ff,
	@Settlement_Total,
	Convert(nvarchar(15), @Settlement_Date, 101),
	@Case_Id,
	@User_Id,
	@Settlement_Notes,
	@Settled_Type,
	@Settled_by,
	@SettledWith,
	@Treatment_Id,
	@Settled_With_Name,  
	@Settled_With_Phone,  
	@Settled_With_Fax,
	@Settled_Percent,
	@DomainId
)
		DECLARE @s_l_OldStatus NVARCHAR(200)
		DECLARE @s_l_NotesDesc NVARCHAR(1000)

		--if @Settlement_Int<>0.00 and @Settled_Type=8--Arb/Win
		--begin
		--	SET @s_l_OldStatus = (Select top 1 status from tblcase where Case_Id = @Case_Id and DomainId=@DomainId)
		--	SET @s_l_NotesDesc = 'Status changed from '+ @s_l_OldStatus +' to AAA - AWARD - WIN ' 
			
		--	UPDATE tblCase set Status='AAA - AWARD - WIN ' where Case_Id = @Case_Id and DomainId=@DomainId
		--	exec F_Add_Activity_Notes @DomainId=@DomainId,@s_a_Case_Id=@Case_Id,@s_a_Notes_Type='Activity',@s_a_NDesc= @s_l_NotesDesc,@s_a_user_Id=@User_Id,@i_a_ApplyToGroup = 0
		--end
		--else if @Settlement_Int<>0.00 and @Settled_Type=10--Arb/Partial Win
		--begin
		--	SET @s_l_OldStatus = (Select top 1 status from tblcase where Case_Id = @Case_Id and DomainId=@DomainId)
		--	SET @s_l_NotesDesc = 'Status changed from '+ @s_l_OldStatus +' to AAA - AWARD - PARTIAL WIN' 
			
		--	UPDATE tblCase set Status='AAA - AWARD - PARTIAL WIN' where Case_Id = @Case_Id and DomainId=@DomainId
		--	exec F_Add_Activity_Notes @DomainId=@DomainId,@s_a_Case_Id=@Case_Id,@s_a_Notes_Type='Activity',@s_a_NDesc= @s_l_NotesDesc,@s_a_user_Id=@User_Id,@i_a_ApplyToGroup = 0
		--end
		--else if @Settlement_Int=0.00
		--begin
		--	SET @s_l_OldStatus = (Select top 1 status from tblcase where Case_Id = @Case_Id and DomainId=@DomainId)
		--	SET @s_l_NotesDesc = 'Status changed from '+ @s_l_OldStatus +' to AAA - SETTLED - AWAITING PAYMENTS' 
			
		--	UPDATE tblCase set Status='AAA - SETTLED - AWAITING PAYMENTS' where Case_Id = @Case_Id and DomainId=@DomainId
		--	exec F_Add_Activity_Notes @DomainId=@DomainId,@s_a_Case_Id=@Case_Id,@s_a_Notes_Type='Activity',@s_a_NDesc= @s_l_NotesDesc,@s_a_user_Id=@User_Id,@i_a_ApplyToGroup = 0
		--end


		if @DomainId= 'GLF'
		begin
			SET @s_l_OldStatus = (Select top 1 status from tblcase where Case_Id = @Case_Id and DomainId=@DomainId)
			SET @s_l_NotesDesc = 'Status changed from '+ @s_l_OldStatus +' to SETTLED AWAIT STIP' 
			
			UPDATE tblCase set Status='SETTLED AWAIT STIP' where Case_Id = @Case_Id and DomainId=@DomainId
			exec F_Add_Activity_Notes @DomainId=@DomainId,@s_a_Case_Id=@Case_Id,@s_a_Notes_Type='Activity',@s_a_NDesc= @s_l_NotesDesc,@s_a_user_Id=@User_Id,@i_a_ApplyToGroup = 0
		end

		IF @Adjuster_Attorney = 'AD'  
				 BEGIN  
				   Update tblCase SET Adjuster_Id = + cast(@Adjuster_Id as int) WHERE Case_Id = + @Case_Id    and DomainId=@DomainId 
				 END  
				ELSE   
				IF @Adjuster_Attorney = 'AT'  
				 BEGIN  
				   Update tblCase SET Attorney_Id = + @Adjuster_Id WHERE Case_Id = + @Case_Id  and DomainId=@DomainId   
				 END
		IF @Adjuster_Attorney = 'DF'  
				 BEGIN  
				   Update tblCase SET Defendant_Id = + @Adjuster_Id WHERE Case_Id = + @Case_Id and DomainId=@DomainId    
				 END

		  IF @Adjuster_Attorney = 'ATTORNEY'
			BEGIN
			  IF Not Exists(Select * from tblAttorney_Case_Assignment Where Attorney_Id = @Adjuster_Id and Case_Id= @Case_Id and DomainId = @DomainId)
			  BEGIN
					Declare @AttorneyType int;
					Select Top 1 @AttorneyType = Attorney_Type_Id from tblAttorney_Master Where Attorney_Id = @Adjuster_Id and DomainId = @DomainId

					Insert into tblAttorney_Case_Assignment
					    (Attorney_Type_Id,Attorney_Id,Case_Id,DomainId,created_by_user,created_date)
					Values
					    (@AttorneyType, @Adjuster_Id, @Case_Id, @DomainId, @User_Id, GETDATE())

			  END
			END
		end

