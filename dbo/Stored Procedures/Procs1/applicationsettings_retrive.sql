-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[applicationsettings_retrive] -- / applicationsettings_retrive @s_a_Type=N'DocumentUploadLocationPhysical',@s_a_DomainID=N'GLF'
	-- Add the parameters for the stored procedure here
	@s_a_DomainID VARCHAR(50),
	@s_a_Type VARCHAR(50)

AS
BEGIN
	
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT * FROM tblApplicationSettings WHERE DomainId = @s_a_DomainID AND ParameterName =  @s_a_Type 
END
