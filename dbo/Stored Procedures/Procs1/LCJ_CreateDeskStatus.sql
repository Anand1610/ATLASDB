CREATE PROCEDURE[dbo].[LCJ_CreateDeskStatus]
(
@DomainId nvarchar(50),
@UserId  nvarchar(3000),
@Status_Abr nvarchar(3000)
)
AS
begin
    cREATE TABLE #USERTABLE(USERID VARCHAR(50))
    declare @Delimiter varchar(2),
	    @ST NVARCHAR(1000)
    set @Delimiter = ','
    DECLARE @INDEX INT
    DECLARE @SLICE nvarchar(4000)
    -- HAVE TO SET TO 1 SO IT DOESNT EQUAL Z
    --     ERO FIRST TIME IN LOOP
    SELECT @INDEX = 1
    -- following line added 10/06/04 as null
    --      values cause issues
    IF @UserId IS NULL RETURN
    WHILE @INDEX !=0


        BEGIN	
        	-- GET THE INDEX OF THE FIRST OCCURENCE OF THE SPLIT CHARACTER
        	SELECT @INDEX = CHARINDEX(@Delimiter,@UserId)
        	-- NOW PUSH EVERYTHING TO THE LEFT OF IT INTO THE SLICE VARIABLE
        	IF @INDEX !=0
        		SELECT @SLICE = LEFT(@UserId,@INDEX - 1)
        	ELSE
        		SELECT @SLICE = @UserId
        	-- PUT THE ITEM INTO THE RESULTS SET
         INSERT INTO #USERTABLE 
	 select UserName from issuetracker_users where userid = @slice and DomainId=@DomainId

        	-- CHOP THE ITEM REMOVED OFF THE MAIN STRING
        	SELECT @UserId = RIGHT(@UserId,LEN(@UserId) - @INDEX)
        	-- BREAK OUT IF WE ARE DONE
        	IF LEN(@UserId) = 0 BREAK
    	END
	
	--WRITE ROUTINE FOR LOOPING AND INSERTING INTO CASE DESK----
	DECLARE
	@USERID2 VARCHAR(50)
	DECLARE
	MYCUR CURSOR LOCAL FOR
	SELECT USERID FROM #USERTABLE
	OPEN MYCUR
	FETCH NEXT FROM MYCUR INTO @USERID2
	WHILE @@FETCH_STATUS=0
	BEGIN
		SET @ST = 'SELECT ''' + @userid2 + ''',A.DESK_id, ''' + @DomainId + ''' FROM TBLDESK A INNER JOIN TBLstatus B ON A.DomainId = B.DomainId AND A.DESK_NAME=B.status_type WHERE '''+@DomainId+''' = A.DomainId AND status_abr IN (''' + REPLACE(@status_abr,',',''',''') + ''') AND A.DESK_ID NOT IN (SELECT DESK_ID FROM TBLUSERDESK WHERE USERNAME = ''' + @USERID2 + ''')'
		insert into tbluserdesk
		EXECUTE SP_EXECUTESQL @ST
	FETCH NEXT FROM MYCUR INTO @USERID2
	END
	CLOSE MYCUR
	DEALLOCATE MYCUR
	DROP TABLE #USERTABLE
		


end

