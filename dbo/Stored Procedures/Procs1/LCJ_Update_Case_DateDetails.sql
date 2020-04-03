
CREATE PROCEDURE [dbo].[LCJ_Update_Case_DateDetails]
@DomainId NVARCHAR(50),
@Case_Id nvarchar(200),        
@oldValue nvarchar(200),        
@newValue nvarchar(200),        
@fieldName nvarchar(200),        
@user_id nvarchar(50),        
@oldTextName nvarchar(200),        
@newTextName nvarchar(200)
AS
BEGIN
	declare        
	@st nvarchar(200),
	 @desc varchar(200)
	SET NOCOUNT ON;

		if(@fieldName='Settlement_Date')
		BEGIN
			if exists(Select Case_Id from tblSettlements where  Case_Id in (@Case_Id) and DomainId=@DomainId)
			begin 
				set @st = 'update  tblSettlements set ' + @fieldName + '= ''' + @newvalue + ''' where Case_Id in ('''+@Case_Id +''') and DomainId='''+@DomainId+''''     
				exec sp_Executesql @st 
			end
			else
			begin
				set @st='insert into tblSettlements(Case_Id,DomainId,User_Id,'+@fieldName+') values('''+@Case_Id+''','''+@DomainId+''','''+@user_id+''',''' + @newvalue + ''')' 
				exec sp_Executesql @st
			end	
			if(@oldValue='')
				set @oldValue=''
				 
			set @desc = ''+@fieldName +  ' Changed From '+@oldValue+' To ' + @newvalue + ' '   
			exec LCJ_AddNotes @DomainId=@DomainId,@case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @desc,@user_Id=@User_Id,@ApplyToGroup = 0  	
			RETURN	
		END
	
  --- Start

	    
		IF EXISTS(SELECT * FROM sys.columns WHERE Name =@fieldName AND OBJECT_ID = OBJECT_ID(N'tblcase'))
		BEGIN
			-- PRINT 'Column Exists in tblcase'
				if exists(select * from tblCase where Case_Id = @Case_Id and DomainId = @DomainId)
				begin
						set @st = 'update tblCase set ' + @fieldName + '= ''' + @newvalue + ''' where Case_Id in ('''+@Case_Id +''') and DomainId='''+@DomainId+''''     
						exec sp_Executesql @st 
				end
				else
				begin
						set @st = 'insert into tblCase(Case_Id,DomainId,'+  @fieldName + ') values('''+@Case_Id+''','''+@DomainId+''',''' + @newvalue + ''')'     
						exec sp_Executesql @st
				end
				if(@oldValue='')
						set @oldValue=''

				
				set @desc = ''+@fieldName +  ' Changed From '+@oldValue+' To ' + @newvalue + ' '   
				exec LCJ_AddNotes @DomainId=@DomainId,@case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @desc,@user_Id=@User_Id,@ApplyToGroup = 0 
				RETURN	  	
		END  
		ELSE IF EXISTS(SELECT * FROM sys.columns WHERE Name =@fieldName AND OBJECT_ID = OBJECT_ID(N'tblCase_Date_Details'))
		BEGIN
			--PRINT 'Column Exists in tblCase_Date_Details'
			    if exists(select * from tblCase_Date_Details where Case_Id = @Case_Id and DomainId = @DomainId)
				begin
						set @st = 'update tblCase_Date_Details set ' + @fieldName + '= ''' + @newvalue + ''' where Case_Id in ('''+@Case_Id +''') and DomainId='''+@DomainId+''''     
						exec sp_Executesql @st 
				end
				else
				begin
						set @st = 'insert into tblCase_Date_Details(Case_Id,DomainId,'+  @fieldName + ') values('''+@Case_Id+''','''+@DomainId+''',''' + @newvalue + ''')'     
						exec sp_Executesql @st
				end
				if(@oldValue='')
						set @oldValue=''		  

				set @desc = ''+@fieldName +  ' Changed From '+@oldValue+' To ' + @newvalue + ' '   
				exec LCJ_AddNotes @DomainId=@DomainId,@case_id=@Case_Id,@Notes_Type='Activity',@Ndesc = @desc,@user_Id=@User_Id,@ApplyToGroup = 0 
				RETURN	
		END 
  --- End
	
END
