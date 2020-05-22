USE [LS_ATLAS_DB_PROJECT]
GO
/****** Object:  StoredProcedure [dbo].[CreateGBBDocumentStructure]    Script Date: 5/22/2020 1:32:45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

 ALTER PROCEDURE [dbo].[CreateGBBDocumentStructure]
 @NodeName varchar(1000)=''  ,
 @FilePath varchar(1000)=''  ,
 @DocumentName varchar(1000)='P_8177_201607011026332633.pdf',
 @Case_id varchar(100)='',
 @BasePathId int =0,
 @UserId INT
 AS
 BEGIN


 SET @UserId =(Select top 1 UserId from IssueTracker_Users where UserName ='system')
 
 set @BasePathId = (SELECT top 1 AtlasbasPathID FROM dbo.[tblBasePathAtlasGybMap] where GybBasePathid=@BasePathId)

 Declare @Domainid varchar(30)=(select top 1 DomainiD from tblcase with(nolock) where case_id=@Case_id)

 declare @i_l_max_id int 
 Declare @Nodes Table
 (
 nodeid int,
 NodeName varchar(500)
 )
 insert into @Nodes(nodeid,NodeName)
 select * from SplitString(@NodeName,'/')

   DECLARE @TotalCount INT = 0  
   DECLARE @Counter INT = 0
   SET @TotalCount = ISNULL((SELECT MAX(nodeid) FROM @Nodes),0)  

     declare @NodeiD int 

	   DECLARE @Parent_ID INTEGER , @NodeLevel  INTEGER  
  
      --SET @Parent_ID = ( SELECT min(NodeID) FROM tblTags (NOLOCK)  
      -- WHERE CASEID = @Case_id  
      -- AND ParentID IS NULL  
      --)  
    
	  --IF (@Parent_ID IS NULL)  
	  --BEGIN  
	  -- INSERT INTO tblTags (PARENTID, NODENAME,CASEID, DOCTYPEID, NODEICON, NODELEVEL, EXPANDED)          
	  -- VALUES (null, @Case_id, @Case_id, null, 'Folder.gif', 0,1)       
	  -- SET @Parent_ID=@@IDENTITY      
	  --END  

	DECLARE @s_l_NotesDesc VARCHAR(MAX)
	DECLARE @i_l_node_id INT
	
	SET @i_l_node_id = (SELECT top 1 NodeID from tblTags WHERE CaseID = @Case_id AND NodeName = @Case_id and ParentID is null)
	
	IF  (@i_l_node_id is null)
	BEGIN
		EXEC sp_createDefaultDocTypesForTree   @Case_id, @Case_id
		
	END
	SET @i_l_node_id = (SELECT top 1 NodeID from tblTags WHERE CaseID = @Case_id AND NodeName = @Case_id and ParentID is null)
	

	 if not exists(SELECT top 1 CaseID FROM tblTags (NOLOCK)  
     WHERE CASEID = @Case_id  
     AND NodeName ='Addition Documents from GreenBills' AND ParentID =@i_l_node_id and NodeLevel=1)
	 BEGIN
     INSERT INTO tblTags(NodeName,Expanded,ParentID,CaseID,NodeLevel, DomainId)           
     --SELECT 'Addition Documents from GreenBills', 0 , @i_l_node_id,@Case_id,1 FROM @Nodes   
     --WHERE nodeid = 0  

	  SELECT 'Addition Documents from GreenBills', 0 , @i_l_node_id,@Case_id,1 , @DomainId
  

	 set @NodeiD=SCOPE_IDENTITY()
	 END 
	 ELSE
	 BEGIN
	 set @NodeiD=( SELECT top 1 NodeID FROM tblTags (NOLOCK)  
     WHERE CASEID = @Case_id  
     AND NodeName ='Addition Documents from GreenBills' AND ParentID =@i_l_node_id and NodeLevel=1)
	 END
	 
	 SET @Nodelevel  = 2

   WHILE(@Counter <= @TotalCount)  
   BEGIN  
     
	 IF NOT EXISTS( SELECT top 1 NodeID FROM tblTags (NOLOCK)  
     WHERE CASEID = @Case_id  
     AND NodeName =( SELECT NodeName FROM @Nodes   
     WHERE nodeid = @Counter ) AND NodeLevel=( @Nodelevel  
    ) and (parentid = (Select nodeid from tbltags where CaseID=@Case_id  and  nodelevel=@Nodelevel-1 and NodeName=( SELECT NodeName FROM @Nodes   
     WHERE nodeid = @Counter-1)) or parentid=@NodeiD))
	 BEGIN
     INSERT INTO tblTags(NodeName,Expanded,ParentID,CaseID,NodeLevel, DomainId)           
     SELECT NodeName, 0 , @NodeiD,@Case_id,@Nodelevel,@Domainid FROM @Nodes   
     WHERE nodeid = @Counter  
	 set @NodeiD=SCOPE_IDENTITY()
	 END
	 ELSE
     BEGIN
	 set @NodeiD=(SELECT top 1 NodeID FROM tblTags (NOLOCK)  
     WHERE CASEID = @Case_id  
     AND NodeName =( SELECT NodeName FROM @Nodes   
     WHERE nodeid = @Counter ) AND NodeLevel=( @Nodelevel ) and (parentid = (Select nodeid from 
	 tbltags where CaseID=@Case_id  and  nodelevel=@Nodelevel-1 and NodeName=( SELECT NodeName FROM @Nodes   
     WHERE nodeid = @Counter-1)) or parentid=@NodeiD))
	 END
	 SET @Counter = @Counter + 1
	 SET @Nodelevel=@Nodelevel + 1
	 END

	  DECLARE @i_l_duplicate INT = 0    

     --SELECT @i_l_duplicate = COUNT(*) FROM tblDocImages WHERE FilePath = @FilePath AND Filename = @DocumentName   

	  SELECT @i_l_duplicate = COUNT(*) FROM tblDocImages WHERE FilePath = @FilePath AND Filename = @DocumentName   
	 and imageid in (select Imageid from tblImageTag where TagId in (select Nodeid from tbltags where caseId=@Case_id))

	IF(@i_l_duplicate = 0)      
	BEGIN    


	INSERT INTO  tblDocImages(Filename,FilePath,OCRData,Status,from_flag, BasePathId, DomainID)                
    VALUES (@DocumentName,@FilePath  ,'',1  ,1, @BasePathId, @DomainID)  
                
    SET @i_l_max_id = SCOPE_IDENTITY()              
         
    INSERT INTO tblImageTag(ImageID,TagID,LoginID,DateInserted,DateModified,DateScanned, DomainID)            
    VALUES (@i_l_max_id,@NodeiD,@UserId,GETDATE(),NULL, NULL, @DomainID)  


	       
		
		--SET @s_l_NotesDesc = @DocumentName + ' uploaded at ' + @FilePath  
		--exec dbo.F_Add_Activity_Notes @s_a_Case_Id=@Case_id,@s_a_Notes_Type='Activity',@s_a_NDesc= @s_l_NotesDesc,@s_a_user_Id='System',@i_a_ApplyToGroup = 0


	END

	END
	


