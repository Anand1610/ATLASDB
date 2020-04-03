CREATE PROCEDURE Get_Nodes_Documents
	 @s_a_CaseId varchar(40),  
     @s_a_DomainId varchar(40),  
	 @s_a_Nodes varchar(2000)
AS
BEGIN
	SET NOCOUNT ON;

    DECLARE @s_l_PacketID VARCHAR(100) = ''  
    DECLARE @S_l_Packeted_Case_Ids VARCHAR(MAX)  
  
	 IF (Exists(Select Packet_Auto_ID from tblPacket(NOLOCK) where PacketID=@s_a_CaseId))  
		 BEGIN  
			SET @s_l_PacketID = @s_a_CaseId  
		 END  
	 ELSE  
		 BEGIN  
			  SET @s_l_PacketID = (SELECT  TOP 1 ISNULL(PacketID,'') FROM dbo.tblCase cas (NOLOCK)  
			  INNER  JOIN dbo.tblPacket(NOLOCK) pkt ON cas.FK_Packet_ID = pkt.Packet_Auto_ID   
			  WHERE CASE_ID = @s_a_CaseId)  
		 END  
  
	 IF (@s_l_PacketID  IS NULL or @s_l_PacketID = '')  
		 BEGIN  
		   Set @S_l_Packeted_Case_Ids = @s_a_CaseId  
		 END  
	ELSE  
	    BEGIN  
		       SET @S_l_Packeted_Case_Ids =  STUFF((SELECT ',' + CASE_ID FROM dbo.tblCase cas (NOLOCK) 
				   INNER  JOIN dbo.tblPacket pkt (NOLOCK) ON cas.FK_Packet_ID = pkt.Packet_Auto_ID   
				   WHERE PacketID = @s_l_PacketID and cas.DomainID = @s_a_DomainId  
				FOR XML PATH('')), 1, 1, '')  
	     END  

		 SELECT  
			 I.ImageID AS Image_Id,  
		     ('\'+FilePath+Filename)AS FilePath,
			 Filename,
			 nodename,  
             I.BasePathId,  
             Filename As FileName  
		 FROM   
		  TBLDOCIMAGES I (NOLOCK)  
		  Join tblImageTag IT (NOLOCK) on IT.ImageID=i.ImageID and IT.DomainId = I.DomainId  
		  Join tblTags T (NOLOCK) on T.NodeID = IT.TagID and IT.DomainId = T.DomainId  
		  Join tblBasePath B (NOLOCK) on B.BasePathId = I.BasePathId  
		 WHERE   
		  I.DomainId = @s_a_DomainId AND  
		  T.CaseID in  (SELECT items FROM dbo.STRING_SPLIT(@S_l_Packeted_Case_Ids,',')) AND   
		  LOWER(I.Filename) like '%.pdf%'  
		  AND NodeName in (Select s from SplitString(@s_a_Nodes, ','))
		  Order by NodeName 
END
