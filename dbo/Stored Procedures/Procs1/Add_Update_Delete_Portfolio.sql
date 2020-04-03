CREATE PROCEDURE [dbo].[Add_Update_Delete_Portfolio]    
(
	@Id int = 0,
	@Name varchar(50) = NULL,
	@RhPercentage int = 0,
	@Description varchar(200) = NULL,
	@ProgramId int = 0,
	@DomainId varchar(50),
	@Action varchar(10),
	@Portfolio_Type int = 0
) 
AS    
BEGIN  
if( @Action ='Insert')
 Begin
	insert into  [dbo].[tbl_Portfolio](Name,Description,Reserved_Percentage,ProgramId,DomainId, Portfolio_Type) 
	values (@Name,@Description,@RhPercentage,@ProgramId,@DomainId, @Portfolio_Type)
 end 

 if( @Action ='UpdateRec')
 Begin
  update [dbo].[tbl_Portfolio] 
  set Name=@Name,Description=@Description,
	  Reserved_Percentage=@RhPercentage,
	  ProgramId=@ProgramId,
	  Portfolio_Type=@Portfolio_Type
	  where Id= @Id 
 end 

 if( @Action ='Delete')
 Begin
  Delete from  [dbo].[tbl_Portfolio] where Id=@Id
 end 

 if( @Action ='Select')
 Begin
     Select 
		 po.Id
		,po.Name
		,po.Description
		,po.Reserved_Percentage
		,pr.Name as ProgramName
		,Portfolio_Type = Case isnull(Portfolio_Type,0)
						  When 1 Then 'Managed'
						  When 2 Then 'Unmanaged'
						  Else ''
						  END
		from [dbo].[tbl_Portfolio] po left join [dbo].[tbl_Program] pr on po.ProgramId = pr.Id  where po.DomainId=@DomainId
 end 

 if( @Action ='GetSingle')
 Begin
  select po.Id,po.Name,po.Description,po.Reserved_Percentage,po.ProgramId,pr.Name as ProgramName,Portfolio_Type from [dbo].[tbl_Portfolio] po left join [dbo].[tbl_Program] pr on po.ProgramId = pr.Id   where po.Id=@Id
 end 

END
