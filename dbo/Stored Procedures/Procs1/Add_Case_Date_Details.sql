CREATE PROCEDURE [dbo].[Add_Case_Date_Details] 
	@Case_Id nvarchar(40),
	@DomainID varchar(40),          
	@oldValue nvarchar(200),          
	@newValue nvarchar(200),          
	@fieldName nvarchar(200),
	@fieldLabelName nvarchar(2000),
	@user_id nvarchar(50)
AS
BEGIN
	SET NOCOUNT ON;
		DECLARE @Query nvarchar(2000);
		DECLARE @Desc nvarchar(2000);

		IF NOT EXISTS (SELECT Case_Id FROM tblcase_Date_Details(nolock) WHERE Domainid = @DomainID and Case_Id = @Case_Id)
		BEGIN
			INSERT INTO tblcase_Date_Details (DomainID, Case_Id) 
			VALUES (@DomainID, @Case_Id)
		END
	 
		IF (@oldValue != ISNULL(@newValue, ''))
		BEGIN
			IF ISNULL(@newValue, '') = ''
			BEGIN 
				SET @Query = 'UPDATE tblcase_Date_Details SET ' + @fieldName + '= NULL where Case_Id in ('''+@Case_Id + ''') and domainid =''' + @DomainID + ''''
			END
			ELSE
			BEGIN
				SET @Query = 'UPDATE tblcase_Date_Details SET ' + @fieldName + '= ''' + @newvalue + ''' where Case_Id in ('''+@Case_Id + ''') and domainid =''' + @DomainID + ''''  
			END
		   
			--IF ISNULL(@oldValue, '') = ''
			--BEGIN
			--	SET @Desc = @fieldLabelName +' ' + ISNULL(@newValue, '');
			--	--Set @Desc = @fieldLabelName +' added ' + ISNULL(@newValue, '');
			--END
			--ELSE
			--BEGIN
				SET @Desc = @fieldLabelName +' changed from '+ @oldValue + ' To ' + ISNULL(@newValue, '');
			--Set @Desc = @fieldLabelName +' updated from '+ @oldValue + ' To ' + ISNULL(@newValue, '');
			--END
			
			PRINT @Query

			EXEC sp_Executesql @Query
		   if(@fieldName='Date_Rebuttal_Uploaded_To_AAA')
		   begin
				exec LCJ_AddNotes @DomainID=@DomainID,@case_id=@Case_Id,@Notes_Type='PopUp',@Ndesc = @Desc,@user_Id=@User_Id,@ApplyToGroup = 0 
		   end
		   else
		   begin
				EXEC LCJ_AddNotes @DomainID=@DomainID,@case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @Desc,@user_Id=@User_Id,@ApplyToGroup = 0 
		   END
END  
END
