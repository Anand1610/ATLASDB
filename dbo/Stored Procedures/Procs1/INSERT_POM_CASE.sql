CREATE PROCEDURE [dbo].[INSERT_POM_CASE]
	@DomainId VARCHAR(50),
	@pom_id AS VARCHAR(50),
	@case_id AS VARCHAR(50),
	@User_Id as varchar(50),
	@FileName as varchar(500),
	@BasePathID INT,
	@POMType VARCHAR(50)
AS
BEGIN

		 DECLARE @s_l_Status VARCHAR(500) 
		 DECLARE @newStatusHierarchy int
	     DECLARE @oldStatusHierarchy int
		SET @s_l_Status = (SELECT top 1 status From tblCASE (NOLOCK) WHERE Case_ID = @case_id AND DomainId = @DomainId)
		SET @oldStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@s_l_Status)
		--IF(@s_l_Status <> 'WC BILLS')
		--BEGIN
		--	DELETE FROM TBLPOMCASE WHERE CASE_ID=@case_id and DomainId =@DomainId 
		--END


		DECLARE @dt_Date_Bill_Sent  DATETIME 
		SET @dt_Date_Bill_Sent = (select MAX(POM_Date_Bill_Send) from tblPOM (NOLOCK) WHERE POM_ID_New = @pom_id and DomainId = @DomainId)
		
		INSERT INTO TBLPOMCASE
		(
			DomainId,
			pom_id,
			case_id,
			POM_FileName,
			BasePathID,
			POMType
		)
		VALUES
		(
			@DomainId,
			@pom_id,
			@case_id,
			@FileName,
			@BasePathID,
			@POMType
		)
		
		DECLARE @s_l_Status_New VARCHAR(100)
		DECLARE @DESC AS VARCHAR(500) = ''

		IF @DomainId = 'GLF'AND @POMType = 'POM'
		BEGIN
			set @DESC = 'Status changed to ACTIVE BILLING POM GENERATED'
			SET @s_l_Status_New = 'ACTIVE BILLING POM GENERATED' 
		END
		ELSE IF @POMType = 'POM'
		BEGIN
			set @DESC = 'Status changed to BILLING POM GENERATED' 
			SET @s_l_Status_New = 'BILLING POM GENERATED'
		END
		ELSE IF @POMType = 'Verification POM' 
		BEGIN
		     set @DESC = 'Status changed to BILLING VR POM GENERATED'
			 SET @s_l_Status_New = 'BILLING VR POM GENERATED'
		END
		SET @newStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID =@DomainID and Status_Type=@s_l_Status_New)
		 --if(@newStatusHierarchy>=@oldStatusHierarchy)
		 if(@newStatusHierarchy>=@oldStatusHierarchy OR ((@newStatusHierarchy = 0 OR @oldStatusHierarchy = 0) AND @DomainID in ('AMT','PDC')))
		BEGIN
			UPDATE TBLCASE SET STATUS=@s_l_Status_New WHERE CASE_ID=@case_id and Status <> 'WC BILLS' and DomainId =@DomainId
		end
		
		IF((SELECT count(case_id) FROM TBLPOMCASE (NOLOCK) WHERE CASE_ID=@case_id and DomainId =@DomainId) > 1 AND @s_l_Status = 'WC BILLS')
		BEGIN
			--if(@newStatusHierarchy>=@oldStatusHierarchy)
			if(@newStatusHierarchy>=@oldStatusHierarchy OR ((@newStatusHierarchy = 0 OR @oldStatusHierarchy = 0) AND @DomainID in ('AMT','PDC')))
			BEGIN
				UPDATE TBLCASE SET STATUS=@s_l_Status_New WHERE CASE_ID=@case_id and DomainId =@DomainId
			END
		END

		 IF @POMType = 'POM'
		 BEGIN
			UPDATE tblTreatment 
			SET Date_BillSent =@dt_Date_Bill_Sent,
				pom_created_date = getdate(),
				  pom_id	=	@pom_id  
			WHERE CASE_ID=@case_id
		 END
		
		

		
		IF(@DESC <> '')
			exec LCJ_AddNotes @DomainId= @DomainId, @case_id=@case_id,@Notes_Type='Activity',@Ndesc = @DESC,@user_Id=@User_Id,@ApplyToGroup = 0        

END
