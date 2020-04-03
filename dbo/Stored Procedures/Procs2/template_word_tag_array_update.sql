
CREATE PROCEDURE [dbo].[template_word_tag_array_update] 
(
	 @s_a_DomainID			varchar(50)		=	'',
	 @i_a_pk_template_id	INT,
	 @s_a_template_tags		VARCHAR(MAX),
	 @s_a_created_by  		varchar(100)	=	'admin'	
)
AS  
BEGIN  
SET NOCOUNT ON
	DECLARE @i_l_result	INT
	DECLARE @s_l_message	NVARCHAR(500)

	UPDATE tbl_template_word
	SET 
		template_tag_array	=	@s_a_template_tags,
		modified_by_user	=	@s_a_created_by,
		modified_date		=	GETDATE()
	WHERE 
		pk_template_id		=	@i_a_pk_template_id
		and DomainID		=	@s_a_DomainID

	SET @s_l_message	=  'Template details updated successfully'
	SET @i_l_result	=  @i_a_pk_template_id		
			
	SELECT @s_l_message AS [MESSAGE], @i_l_result AS [RESULT]	
SET NOCOUNT OFF  
END
