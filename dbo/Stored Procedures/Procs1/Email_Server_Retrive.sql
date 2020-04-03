
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================

CREATE PROCEDURE [dbo].[Email_Server_Retrive] 
	-- Add the parameters for the stored procedure here
	@DomainId nvarchar(50),
	@s_a_Type varchar(200)

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT
		autoid
		, from_email_id
		, password
		, smtp_port
		, type
		, smtp_server
		, CC
		, BCC
		, mail_subject
		, mail_body
		, to_email_id 
		, Status
		, node_id
		, to_email_id
		, NodeName
	from Email_Server 
	--left join tblStatus ON Email_Server.StatusId=tblStatus.Status_Id
	left join MST_DOCUMENT_NODES ON Email_Server.node_id=MST_DOCUMENT_NODES.NodeID
	 where Email_Server.DomainID=@DomainId
	 AND (@s_a_Type = '' or type = @s_a_Type)
END

