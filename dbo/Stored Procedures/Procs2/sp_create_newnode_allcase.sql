CREATE PROCEDURE [dbo].[sp_create_newnode_allcase]
	
AS
BEGIN	
	SET NOCOUNT ON;
    DECLARE @nodeid as int
    DECLARE @date as datetime
    DECLARE @caseid as varchar(50)   
    
    DECLARE CUR CURSOR
    FOR select NodeID,CaseID,TSTAMP from tblTags where ParentID is null
    OPEN CUR
    FETCH CUR INTO @nodeid,@caseid,@date
    WHILE @@FETCH_STATUS = 0
    BEGIN
    if not EXISTS(SELECT * FROM tblTags WHERE NodeName ='ECF FOR PARTIES' and CaseID=@caseid )
    BEGIN
    INSERT INTO tblTags(NodeName,Expanded,ParentID,CaseID,NodeLevel)         
    VALUES('ECF FOR PARTIES',0,@nodeid,@caseid,1)  
    END            
    FETCH CUR INTO @nodeid,@caseid,@date
    END
    CLOSE CUR
    DEALLOCATE CUR
END

