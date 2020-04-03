CREATE PROCEDURE [dbo].[F_Template_Default_Node_Id_Retrieve]   
(  
  @DomainId nvarchar(50),
  @i_a_template_id int=90,    
  @s_a_case_id varchar(100) =''  
)  
AS    
BEGIN    
SET NOCOUNT ON   
 Begin  
	 declare @i_a_node_id  int  
	 declare @s_a_node_name  varchar(500) 
	 Declare @i_a_Result  int 
	 declare @s_a_Template_File_Name  varchar(max) 
	 set @i_a_node_id=(select isnull(fk_default_node_id,0) from MST_TEMPLATES  where I_TEMPLATE_ID=@i_a_template_id AND DomainId = @DomainId)  
	 
	 set @s_a_Template_File_Name=(select isnull(SZ_TEMPLATE_FILENAME,'') from MST_TEMPLATES  where I_TEMPLATE_ID=@i_a_template_id AND DomainId = @DomainId)  
	 
	 

	 if(isnull( @i_a_node_id,0)!=0)  
	 begin  
		  set @s_a_node_name=(select isnull(nodename,0) from dbo.MST_DOCUMENT_NODES  where NodeID=@i_a_node_id AND DomainId = @DomainId)  
		  select @i_a_Result= nodeid from dbo.tbltags  where CaseID=@s_a_case_id and nodename =@s_a_node_name  and DomainId=@DomainId
		  select @i_a_Result as Result,@s_a_Template_File_Name as TEMPLATE_FILENAME
	 end  
	 else  
	 begin  
		select 0 As Result,@s_a_Template_File_Name as TEMPLATE_FILENAME
	 end  
 end  
   
 SET NOCOUNT OFF    
END

