
CREATE PROCEDURE [dbo].[DSP_SelectAzureBasePathId] 
	
AS
BEGIN
	
	SET NOCOUNT ON;
	if exists(select * from tblBasePath where BasePathType=2)
	begin
    select BasePathId from tblBasePath where BasePathType=2
	end
END
