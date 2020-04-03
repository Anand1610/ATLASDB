CREATE PROCEDURE Case_Date_Motion_Mapping_Insert 
	@s_a_Case_Id varchar(50),
	@s_a_DomainId varchar(50),
	@s_a_UserId varchar(150),
	@i_a_Id int,
	@i_a_MotionTypeId int,
	@d_a_MotionHearingDate Datetime,
	@b_a_Motion_for_PL_or_DEF bit
AS
BEGIN
	Declare @CaseDateDetailId int;
	Declare @MotionType varchar(500);
	DECLARE @d_a_MotionHearingDate_old DATETIME
	Declare @OldMotionType varchar(500);
	Declare @OldMotion_for_PL_or_DEF bit;

	Select @MotionType = Name from tblMotionType Where MotionTypeId = @i_a_MotionTypeId

	IF @i_a_Id = 0
	BEGIN
	    If Not Exists(Select Auto_Id  from tblCase_Date_Details Where Case_Id = @s_a_Case_Id and DomainId = @s_a_DomainId)
		BEGIN
		  Exec Case_Date_Details_Insert @Auto_Id = 0, @Case_Id = @s_a_Case_Id, @DomainId = @s_a_DomainId, @CreatedBy = @s_a_UserId
		END

	    Select @CaseDateDetailId = Auto_Id from tblCase_Date_Details Where Case_Id = @s_a_Case_Id and DomainId = @s_a_DomainId

		Insert into tblCaseDateMotionMapping(CaseDateDetailsID, DomainId, MotionTypeId, MotionHearingDate, Motion_for_PL_or_DEF, CreatedBy, CreatedDate)
		values(@CaseDateDetailId, @s_a_DomainId, @i_a_MotionTypeId, @d_a_MotionHearingDate, @b_a_Motion_for_PL_or_DEF, @s_a_UserId, GETDATE())

		SET @i_a_Id = SCOPE_IDENTITY()

			Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
			Values(iif(@b_a_Motion_for_PL_or_DEF=0, 'Plaintiff ', 'Defendant ')+@MotionType +' Added. '+ CONVERT(VARCHAR(10), @d_a_MotionHearingDate, 101) + ' ' + RIGHT(CONVERT(VARCHAR, @d_a_MotionHearingDate, 100), 7), 'Workflow', 1, @s_a_Case_Id, GETDATE(), @s_a_UserId, @s_a_DomainId)
	END
	ELSE
	BEGIN
		SELECT TOP 1 @d_a_MotionHearingDate_old = MotionHearingDate, @OldMotionType =  Name, @OldMotion_for_PL_or_DEF = Motion_for_PL_or_DEF
		FROM tblCaseDateMotionMapping MM INNER JOIN tblMotionType MT ON MT.MotionTypeId = MM.MotionTypeId WHERE Id = @i_a_Id and MM.DomainId = @s_a_DomainId
		
		Update tblCaseDateMotionMapping set
			 MotionTypeId = @i_a_MotionTypeId,
			 MotionHearingDate = @d_a_MotionHearingDate,
			 Motion_for_PL_or_DEF = @b_a_Motion_for_PL_or_DEF,
			 UpdatedBy = @s_a_UserId,
			 UpdatedDate = GETDATE()
			 Where Id = @i_a_Id and DomainId = @s_a_DomainId

			 Update tblCaseWorkflowTriggerQueue set IsDeleted = 1 where MotionMappingId = @i_a_Id and DomainId = @s_a_DomainId

			 
			 IF @MotionType != @OldMotionType
				BEGIN
				    Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
					Values(iif(@b_a_Motion_for_PL_or_DEF=0, 'Plaintiff ', 'Defendant ') + @OldMotionType +' Updated To '+ @MotionType, 'Workflow', 1, @s_a_Case_Id, GETDATE(), @s_a_UserId, @s_a_DomainId)
				END

		    IF @OldMotion_for_PL_or_DEF != @b_a_Motion_for_PL_or_DEF
				BEGIN
					Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
					Values(iif(@OldMotion_for_PL_or_DEF=0, 'Plaintiff ', 'Defendant ') + @MotionType +' Updated From '+ iif(@OldMotion_for_PL_or_DEF=0, 'Plaintiff ', 'Defendant ') + ' To '+ iif(@b_a_Motion_for_PL_or_DEF=0, 'Plaintiff ', 'Defendant '), 'Workflow', 1, @s_a_Case_Id, GETDATE(), @s_a_UserId, @s_a_DomainId)
				END

			IF @d_a_MotionHearingDate_old != @d_a_MotionHearingDate
				BEGIN
					Insert into tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id, DomainId)
					Values(iif(@b_a_Motion_for_PL_or_DEF=0, 'Plaintiff ', 'Defendant ') + @MotionType +' Updated From '+CONVERT(VARCHAR(10), @d_a_MotionHearingDate_old, 101) + ' ' + RIGHT(CONVERT(VARCHAR, @d_a_MotionHearingDate_old, 100), 7)+' To '+ CONVERT(VARCHAR(10), @d_a_MotionHearingDate, 101) + ' ' + RIGHT(CONVERT(VARCHAR, @d_a_MotionHearingDate, 100), 7), 'Workflow', 1, @s_a_Case_Id, GETDATE(), @s_a_UserId, @s_a_DomainId)
				END
             
	END

	 Declare @TriggerTypeId int;
	 Declare @MotionTypeName varchar(500);
	

	 Select @TriggerTypeId = Id from tblTriggerType where Name = 'Motion Type'
	 Select @MotionTypeName = Name from tblMotionType where MotionTypeId = @i_a_MotionTypeId and DomainId = @s_a_DomainId

	  	 
	 If @b_a_Motion_for_PL_or_DEF = 0
	  BEGIN
	    Set @MotionTypeName = 'Plaintiff '+ @MotionTypeName;
	  END
	  ELSE
	  BEGIN
	   Set @MotionTypeName = 'Defendant '+ @MotionTypeName ;
	  END

	  Declare @IsManagedCase int = ISNULL((Select top 1 Portfolio_Type from tblcase cas (NOLOCK) inner join tbl_Portfolio pf (NOLOCK) ON pf.Id = Cas.PortfolioId Where cas.Case_Id=@s_a_Case_Id and cas.DomainId=@s_a_DomainId),0)
			
	 IF @IsManagedCase != 2 
	 BEGIN
			Insert into tblCaseWorkflowTriggerQueue
		    (Case_Id, DomainId, TriggerTypeId, InProgress, IsProcessed, IsDeleted, CreatedBy, CreatedDate, MotionMappingId, EmailSubject)
			values(@s_a_Case_Id, @s_a_DomainId, @TriggerTypeId, 0, 0, 0, @s_a_UserId, GETDATE(), @i_a_Id, @MotionTypeName)
	 END

END
