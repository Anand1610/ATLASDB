


CREATE PROCEDURE [dbo].[CPTCode_Delete]
( 
	@i_a_CPT_ATUO_ID		  INT,
	@s_a_Case_ID	VARCHAR(100),
    @s_a_CPTCode	      VARCHAR(100),
    @s_a_DomainID		  VARCHAR(50),
	@s_a_Created_By_User  VARCHAR(100)
  
)

AS
BEGIN
	 DECLARE @s_l_message				NVARCHAR(500),
			 @s_l_notes_desc			NVARCHAR(500)
			
	 BEGIN
	
			BEGIN TRAN
	        
	        DELETE FROM BILLS_WITH_PROCEDURE_CODES  WHERE CPT_ATUO_ID = @i_a_CPT_ATUO_ID  and  DomainID =@s_a_DomainID 
	        
			SET @s_l_message	= 'CPT deleted'
			SET @s_l_notes_desc = 'CPT deleted - ' + @s_a_CPTCode 

		    set @s_l_notes_desc = 'CPT Details deleted : '+ ISNULL(@s_a_CPTCode,'')
			exec LCJ_AddNotes @DomainId=@s_a_DomainID, @case_id=@s_a_Case_ID,@notes_type='Activity' ,@NDesc=@s_l_notes_desc,@user_id=@s_a_Created_By_User,@applytogroup=0
		      
		    
		    COMMIT TRAN 
		
		SELECT @s_l_message AS [MESSAGE]
		
	 END	
END

