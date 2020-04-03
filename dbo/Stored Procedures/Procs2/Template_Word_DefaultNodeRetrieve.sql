CREATE PROCEDURE [dbo].[Template_Word_DefaultNodeRetrieve]   --[Template_Word_DefaultNodeRetrieve] 'test',1,'TEST17-100001'
(  
	@DomainId VARCHAR(50),
	@i_a_template_id int =90,    
	@s_a_case_id varchar(50) =''  
)  
AS      
BEGIN  
	SET NOCOUNT ON 
		DECLARE @i_a_node_id_master  int, @i_a_node_id_case int = 0
		DECLARE @s_a_node_name  varchar(500),@s_a_Template_FileName VARCHAR(200), @s_a_Template_Path varchar(500) 
		DECLARE @s_l_template_tag_array  VARCHAR(MAX)
		DECLARE @s_a_Template_Status VARCHAR(300)
		DECLARE @i_a_BasePathId int

		set @i_a_node_id_master=(select isnull(fk_default_node_id,0) from tbl_template_word where pk_template_id=@i_a_template_id and DomainId=@DomainId)  
		
		SELECT TOP 1 
			@s_a_Template_FileName	=	template_file_name, 
			@s_a_Template_Path		=	template_path,
			@s_l_template_tag_array =	template_tag_array,
			@s_a_Template_Status    =   Status_Id,
			@i_a_BasePathId			=	ISNULL(BasePathId,0)
		FROM 
			tbl_template_word 
		WHERE 
			pk_template_id			=	@i_a_template_id and 
			DomainId				=	@DomainId
		
		 IF(isnull( @i_a_node_id_master,0)!=0)  
		 BEGIN  
			Set @s_a_node_name=(select isnull(nodename,0) from dbo.MST_DOCUMENT_NODES where NodeID = @i_a_node_id_master and DomainId=@DomainId)  
			SET @i_a_node_id_case = (select Min(NodeId) from dbo.tbltags where CaseID=@s_a_case_id and nodename =@s_a_node_name)
		 END  
		 
		  Select @i_a_node_id_case As Result, @s_a_Template_FileName as TEMPLATE_FILENAME, @s_a_Template_Path as TEMPLATE_PATH, 
		  @s_l_template_tag_array as TEMPLATE_TAG_ARRAY, @s_a_Template_Status AS Template_Status, @i_a_BasePathId AS BasePathId

		 SET NOCOUNT OFF  
END  
