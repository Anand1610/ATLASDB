CREATE PROCEDURE [dbo].[SP_NEW_NODE_TO_CASE_INSERT]    
(      
 @ParentID INT    = NULL,          
 @NodeName NVARCHAR(300) = '',          
 @CaseID  VARCHAR(MAX) = '',    
 @DomainId VARCHAR(300)    
)    
AS          
BEGIN    
 DECLARE @NodeLevel INT = 0    
    
 IF EXISTS(SELECT 1 FROM tblTags WHERE NodeName = @NodeName AND ParentID = @ParentID AND CaseID = @CaseID and DomainId=@DomainId)    
 BEGIN        
  SELECT 'Cannot Add, node name already exists...!!' AS message    
  RETURN    
 END    
    
 SELECT @NodeLevel = nodelevel+1 FROM tbltags WHERE nodeid=@ParentID and DomainId=@DomainId    
           
 INSERT INTO tblTags    
 (      
  NodeName,Expanded,ParentID,CaseID,NodeLevel,NodeIcon,DomainId    
 )             
 VALUES    
 (      
  @NodeName,1,@ParentID,@CaseID,@NodeLevel,'Folder.gif',@DomainId    
 )    
    
 SELECT 'New node added successfully..!!' AS message    
      
END      
