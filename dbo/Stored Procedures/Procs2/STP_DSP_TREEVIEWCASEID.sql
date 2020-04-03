CREATE PROCEDURE  [dbo].[STP_DSP_TREEVIEWCASEID]    
	 @DomainId NVARCHAR(50),
	 @PARENTID INT=null,    
	 @NODENAME NVARCHAR(300)=null,      
	 @CASEID NVARCHAR(50)='',    
	 @DOCTYPEID INT=null,    
	 @NODEICON NVARCHAR(50)='Folder.gif',      
	 @NODELEVEL INT=1,    
	 @EXPANDED BIT=1,    
	 @NODEIDOUT INT  =0 OUTPUT   
AS    
begin    
SET NOCOUNT ON    
    
DECLARE @NODEID as INT    
    
-- IF LEN(@CASEID)>3     
--  BEGIN      
--   SET @CASEID = (SELECT SUBSTRING ( @CASEID , CHARINDEX('-',@CASEID,0)+1,LEN(@CASEID)))     
--  END    
    
 --   SET @NODEID=0    
	--SELECT @NODEID= NODEID FROM tblTags WHERE CASEID=@CASEID and DomainId=@DomainId
 --   PRINT @NODEID  
	--IF (@NODEID=0)    
 --   BEGIN    
	--	BEGIN TRANSACTION    
	--		INSERT INTO tblTags (PARENTID, NODENAME,CASEID, DOCTYPEID, NODEICON, NODELEVEL, EXPANDED, DomainId)    
	--		VALUES (null, @NODENAME, @CASEID, null, @NODEICON, 0,@EXPANDED, @DomainId)    
     
	--		IF @@ERROR<>0    
	--		BEGIN    
	--			ROLLBACK TRANSACTION    
	--			RETURN    
	--		END    
      
	--		EXEC sp_createDefaultDocTypesForTree @DomainId, @CASEID, @NODENAME    
       
	--	   IF @@ERROR<>0    
	--	   BEGIN    
	--		ROLLBACK TRANSACTION    
	--		RETURN    
	--	   END          
	--		COMMIT TRANSACTION    
	--END    
	--ELSE
	--BEGIN
		EXEC sp_createDefaultDocTypesForTree @DomainId, @CASEID, @NODENAME  
	--END
--else
--begin
--	EXEC sp_createDefaultDocTypesForTree @CASEID, @CASEID
--end 
-- INSERT INTO tblTags (PARENTID, NODENAME,CASEID, DOCTYPEID, NODEICON, NODELEVEL, EXPANDED)    
-- SELECT @NODEID,DOCTYPENAME, @CASEID,DOCID, @NODEICON, @NODELEVEL,1 FROM tblDefaultDocTypes     
-- WHERE DOCID not in (SELECT isnull(DOCTYPEID,0) FROM tbltags WHERE CASEID=@CASEID)    
     
 SET @NODEIDOUT=SCOPE_IDENTITY()    
end

