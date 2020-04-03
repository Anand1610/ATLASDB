CREATE PROCEDURE [dbo].[SP_WS_GET_FULL_PATH]  --'8239','CO00023'    
	@SZ_NODEID NVARCHAR(10),    
	@SZ_COMPANY_ID NVARCHAR(20) = NULL   
AS    
BEGIN    
 DECLARE @SZPATH NVARCHAR(4000)    
 DECLARE @NODELEVEL VARCHAR(10)    
    
 DECLARE @SZPARENTID NVARCHAR(10)    
 DECLARE @SZ_TEMP_PARENTID NVARCHAR(10)    
 DECLARE @NODENAME NVARCHAR(1000)    
     
 SET @NODELEVEL = 0    
     
 SELECT @NODELEVEL = NODELEVEL ,     
     @SZPARENTID = PARENTID ,     
     @NODENAME=NODENAME     
 FROM   TBLTAGS     
 WHERE NODEID=@SZ_NODEID    
     
	-- amod 07-01-2010. do not append the nodename if the user scans in the root folder
	IF @SZPARENTID IS NOT NULL
	BEGIN
		SET @SZPATH = @NODENAME    
	END
	ELSE
	BEGIN
		SET @SZPATH = ''
	END
	-- ends
     
	WHILE @NODELEVEL >= 1
	BEGIN  
		if(@NODELEVEL=1 and (SELECT PARENTID from tbltags WHERE NODEID=@SZPARENTID) is not null)  
		begin
			while (SELECT NODEID from tbltags WHERE NODEID=@SZPARENTID) is not null  
			begin         
			   SELECT @SZ_TEMP_PARENTID=PARENTID,@NODENAME=NODENAME FROM TBLTAGS WHERE NODEID=@SZPARENTID      
			   SET @SZPARENTID=@SZ_TEMP_PARENTID    
			   SET @SZPATH = @NODENAME + '\' + @SZPATH
				BREAK      -- added amod 07-01-2010 so that the nodename (root) is not appended
			end   
		end
		else
		begin
			SELECT @SZ_TEMP_PARENTID=PARENTID,@NODENAME=NODENAME FROM TBLTAGS WHERE NODEID=@SZPARENTID      
			SET @SZPARENTID=@SZ_TEMP_PARENTID    

			--amod 07-01-2010
			IF @SZ_TEMP_PARENTID IS NOT NULL 
			BEGIN
				SET @SZPATH = @NODENAME + '\' + @SZPATH   
			END
		end
		SET @NODELEVEL = @NODELEVEL - 1  
	END
	-- added amod 07-01-2010 - so that the case id is appended to the path and not root nodename
	declare @sz_case_id nvarchar(20)
	set @sz_case_id = (select caseid from tbltags where nodeid = @SZ_NODEID) --and sz_company_id = @SZ_COMPANY_ID
	set @szpath = rtrim(ltrim(@sz_case_id)) + '\' + @szpath
	-- ends
	-- (SELECT SZ_COMPANY_NAME FROM MST_BILLING_COMPANY WHERE SZ_COMPANY_ID = @SZ_COMPANY_ID) + '\' + 
 SELECT '/' + @SZPATH [PATH]    
END

