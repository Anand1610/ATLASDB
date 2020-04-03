-- =============================================
-- Author:		<Author,,Name>
-- ALTER date: <ALTER Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SP_IP_Details_Insert]
	-- Add the parameters for the stored procedure here
(
	@DomainId NVARCHAR(50),
	@UserID		varchar(50),
	@REMOTE_ADDR	nvarchar(2000),
	@IPAdd		nvarchar(500)
)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
    
    DECLARE @UserName VARCHAR(50)
    SET @UserName =(SELECT TOP 1 UserName FROM IssueTracker_Users WHERE UserId = @UserID and DomainId=@DomainId)
    
    
	INSERT INTO tbl_IP_Tracker(UserName, UserId, REMOTE_ADDR,IPAdd,DomainId, Login_Date)
	VALUES(@UserName,@UserID,@REMOTE_ADDR,@IPAdd,@DomainId,GETDATE())
	

	
END

