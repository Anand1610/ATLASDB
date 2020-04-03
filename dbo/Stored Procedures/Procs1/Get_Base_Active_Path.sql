CREATE PROCEDURE [dbo].[Get_Base_Active_Path]  
	@Flag VARCHAR(100) = NULL
AS  
BEGIN  
	SET NOCOUNT ON  

	IF(@Flag = 'AtlasBasePath')
	BEGIN
		SELECT BasePathId, 
				PhysicalBasePath, 
				VirtualBasePath 
		FROM	[dbo].[tblBasePath]   
		WHERE	BasePathId = (SELECT ParameterValue FROM [tblApplicationSettings] WHERE ParameterName='BasePathId')  
	END
	ELSE IF (@FLAG = 'GetAllGybAtlasPathData')
	BEGIN
		SELECT	b.AtlasBasPathID, 
				b.GybBasePathID,
				b.GBApplicationType
		FROM	[dbo].[tblBasePath] a 
		JOIN	[dbo].[tblBasePathAtlasGybMap] b ON a.BasePathId = b.AtlasBasPathID
	END
	ELSE
	BEGIN
		SELECT	BasePathId, 
				PhysicalBasePath, 
				VirtualBasePath 
		FROM	[dbo].[tblBasePath]   
		WHERE	BasePathId = (SELECT ParameterValue FROM [tblApplicationSettings] WHERE ParameterName='BasePathId')  
	END
END  
  