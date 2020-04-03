CREATE PROCEDURE [dbo].[procInsertPOMImage] --1,'test.pdf','2010\Sep\13','admin','12'
(
	@DomainId VARCHAR(50),
	@POM_ID INT,
	@filename varchar(200),
	@filepath varchar(40),
	@UserName VARCHAR(50),
	@LOGINID varchar(40),
	@BasePathId int
)
as
Begin
	declare @cid varchar(100)
	DECLARE @index integer
	set @index = 0	
	
	DECLARE @s_l_POMType VARCHAR(100)


	SELECT TOP 1 @s_l_POMType =  ISNULL(POMType,'') FROM tblPomCase WHERE POM_ID = @POM_ID


	DECLARE @status_change_table table (
		 Case_Id varchar(500)
		 )
	insert into @status_change_table 
	SELECT CASE_ID FROM TBLPOMCASE (NOLOCK) WHERE POM_ID = @POM_ID AND DomainId = @DomainId
	
	WHILE @index != (select COUNT (DISTINCT Case_Id) from @status_change_table) 
	BEGIN
	
		set @cid = (Select top 1 Case_Id from @status_change_table)

				EXEC [SP_NEW_FILE_INSERT_ASSOCIATION]
				 @DomainId = @DomainId ,       
				 @s_a_case_id =  @cid,          
				 @s_a_node_name = 'PROOF OF MAILING' ,          
				 @s_a_filename = @filename,          
				 @s_a_file_path =@filepath   ,      
				 @i_a_user_id = @LOGINID,   
				 @i_a_BasePathId=@BasePathId,
				 @i_a_from_flag =10;    

		Insert into tblnotes (Notes_Desc,	Notes_Type,	Notes_Priority,	Case_Id,	Notes_Date,	User_Id,	DomainId) values ('Stamped POM uploaded','Activity',1,@cid,getdate(),@UserName,@DomainId)
		
		DELETE FROM @status_change_table where case_id = @cid
		PRINT  @cid
		set @cid= null
	END

	
	  ---- UPDATE STATUS FOR GLF DOMAIN
		Insert into tblnotes (Notes_Desc,	Notes_Type,	Notes_Priority,	Case_Id,	Notes_Date,	User_Id,	DomainId)
		SELECT 'Status changed from ACTIVE BILLING POM GENERATED to ACTIVE BILLING POM RECEIVED','Activity',1,Case_Id,getdate(),@UserName,@DomainId
		FROM tblcase
		WHERE 
			DomainId= @DomainId
			AND status = 'ACTIVE BILLING POM GENERATED'
			AND CASE_ID IN (SELECT CASE_ID from tblPomCase WHERE  POM_ID = @POM_ID and DomainId = @DomainId)


		UPDATE TBLCASE 
		SET STATUS='ACTIVE BILLING POM RECEIVED' 
		WHERE 
			DomainId= @DomainId
			AND status = 'ACTIVE BILLING POM GENERATED'
			AND CASE_ID IN (SELECT CASE_ID from tblPomCase WHERE  POM_ID = @POM_ID and DomainId = @DomainId)
	-----------
	---- UPDATE STATUS FOR Other DOMAIN
		Insert into tblnotes(Notes_Desc,	Notes_Type,	Notes_Priority,	Case_Id,	Notes_Date,	User_Id,	DomainId)
		SELECT 'Status changed from BILLING POM GENERATED to BILLING SENT','Activity',1,Case_Id,getdate(),@UserName,@DomainId
		FROM tblcase
		WHERE 
			DomainId= @DomainId
			AND status = 'BILLING POM GENERATED'
			AND CASE_ID IN (SELECT CASE_ID from tblPomCase WHERE  POM_ID = @POM_ID and DomainId = @DomainId)


		UPDATE TBLCASE 
		SET STATUS='BILLING SENT'
		WHERE 
			DomainId= @DomainId
			AND status = 'BILLING POM GENERATED'
			AND CASE_ID IN (SELECT CASE_ID from tblPomCase WHERE  POM_ID = @POM_ID and DomainId = @DomainId)
	-----------
		
	UPDATE TBLPOM SET pom_scan_date = GETDATE(), pom_scan_by = @UserName, POM_ReceivedFileName = @filename WHERE POM_ID_New = @POM_ID and DomainId = @DomainId

End

