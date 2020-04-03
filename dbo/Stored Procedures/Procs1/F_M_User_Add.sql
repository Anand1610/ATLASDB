CREATE PROCEDURE [dbo].[F_M_User_Add]
(
   @DomainId VARCHAR(50),
   @i_a_User_Id int,
   @s_a_user VARCHAR(100),
   @s_a_Role VARCHAR(100),
   @i_a_Role_Id int,
   @s_a_FirstName VARCHAR(100),
   @s_a_LastName VARCHAR(100),
   @s_a_Password VARCHAR(100),
   @s_a_Email VARCHAR(200),
   @b_a_Active bit,
   @s_a_UserName NVARCHAR(100)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @i_l_result					INT
	DECLARE @s_l_message				NVARCHAR(500)
	DECLARE @s_l_UserType VARCHAR(200)
	DECLARE @s_l_notes_desc		NVARCHAR(MAX)
	
	SET @s_l_UserType  = (SELECT RoleType FROM IssueTracker_Roles WHERE RoleName = @s_a_Role and DomainId=@DomainId)
	IF(@i_a_User_Id = 0)
	BEGIN
	    IF EXISTS(SELECT USERNAME FROM IssueTracker_Users  WHERE UserName = @s_a_user and DomainId=@DomainId)
	    BEGIN
	       SET @s_l_message	=  'User already exists..!!!'
		   SET @i_l_result		=  SCOPE_IDENTITY()
	    END
	    ELSE
	    BEGIN
	          BEGIN TRAN
		      INSERT INTO IssueTracker_Users 
		      (
			      UserName,
			      UserPassword,
			      RoleId,
			      Email,
			      DisplayName,
			      UserTypeLogin,
			      UserType,
			      IsActive,
			      first_name,
			      last_name,
			      UserRole,
				  DomainId
		      )
		      VALUES
		      (
                  @s_a_user,
                  @s_a_Password,
                  @i_a_Role_Id,
                  @s_a_Email,
                  @s_a_LastName +' '+ @s_a_FirstName,
                  @s_a_user,
                  @s_l_UserType,
                  @b_a_Active, 
                  @s_a_FirstName,
                  @s_a_LastName,
                  @s_a_Role,
				  @DomainId
		      )
		      SET @s_l_message	=  'User details saved successfuly'
		      SET @i_l_result		=  SCOPE_IDENTITY()
		      
		      
		      SET @s_l_notes_desc = 'Added UserName-'+	 @s_a_user	+
                            ', UserPassword-'+ @s_a_Password +
                            ', Email-'+ @s_a_Email	+
                            ', UserTypeLogin-'+ @s_a_user+
                            ', UserType-'+  @s_l_UserType+
                            ', IsActive-'+ CONVERT(VARCHAR(10),@b_a_Active)+
                            ', last_name-'+ @s_a_FirstName+
                            ', first_name-'+ @s_a_LastName+
                            ', UserRole-'+ @s_a_Role+
                            ', DomainId-'+ @DomainId


		      EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_user_Id=@s_a_UserName,@s_a_notes_type='User',@DomainId=@DomainId
		      COMMIT TRAN 
	    END		
	END
	ELSE
	BEGIN
		BEGIN TRAN
		
		UPDATE IssueTracker_Users 
		SET 
			 UserName	=	    @s_a_user,
             UserPassword	=	@s_a_Password,
             RoleId	=	        @i_a_Role_Id,
             Email	=	        @s_a_Email,
             DisplayName	=	@s_a_LastName +' '+ @s_a_FirstName,
             UserTypeLogin	=	@s_a_user,
             UserType	=	    @s_l_UserType,
             IsActive	=	    @b_a_Active, 
             first_name	=	    @s_a_FirstName,
             last_name	=	    @s_a_LastName,
             UserRole	=	    @s_a_Role,
			 DomainId	=		@DomainId

		WHERE 
		     UserId = @i_a_User_Id
			 AND DomainId=@DomainId
		
		SET @s_l_message	=  'User details updated successfuly'
		SET @i_l_result	=  @i_a_User_Id
		
		SET @s_l_notes_desc = 'Updated UserName-'+	 @s_a_user	+
                            ', UserPassword-'+ @s_a_Password +
                            ', Email-'+ @s_a_Email	+
                            ', UserTypeLogin-'+ @s_a_user+
                            ', UserType-'+  @s_l_UserType+
                            ', IsActive-'+ CONVERT(VARCHAR(10),@b_a_Active)+
                            ', last_name-'+ @s_a_FirstName+
                            ', first_name-'+ @s_a_LastName+
                            ', UserRole-'+ @s_a_Role+
                            ', DomainId-'+ @DomainId
            
		      EXEC F_AdminNotes_Add @s_a_notes_desc=@s_l_notes_desc,@s_a_user_Id=@s_a_UserName,@s_a_notes_type='User',@DomainId=@DomainId
		                                         
		COMMIT TRAN			
	END
	SELECT @s_l_message AS [MESSAGE], @i_l_result AS [RESULT]	

END

