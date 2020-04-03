CREATE FUNCTION [dbo].[fncGetStatus](@DomainId varchar(50),@Year varchar(10),@Month varchar(10),@Day varchar(10))
returns varchar(8000) as
BEGIN
 DECLARE @EventStatusName VARCHAR(20)
 DECLARE @StatusCount VARCHAR(100)
 DECLARE @OutputString VARCHAR(8000)
 
 -- Events
 DECLARE CUR_CREATE_INSERT_SCRIPT CURSOR
 FOR SELECT ST.EventStatusName,COUNT(EVENT_ID) [STATUSCOUNT] FROM TBLEVENT EVT 
 JOIN tblEventStatus ST ON EVT.EVENTSTATUSID = ST.EventStatusId
 WHERE EVT.DomainId=@DomainId AND year(CONVERT(DATE,EVENT_DATE)) = @YEAR AND month(CONVERT(DATE,EVENT_DATE)) = @MONTH and day(CONVERT(DATE,EVENT_DATE)) = @DAY
 GROUP BY ST.EventStatusName,CONVERT(DATE,EVENT_DATE)

 OPEN CUR_CREATE_INSERT_SCRIPT
 
 set @OutputString = ''
 FETCH CUR_CREATE_INSERT_SCRIPT INTO @EventStatusName , @StatusCount
 
 set @OutputString = '<table border=0 class=''statuscell''>'
 WHILE @@FETCH_STATUS = 0
  BEGIN
   set @OutputString = @OutputString +  '<tr><td class=''statuscell''>'+@EventStatusName +'</td><td class=''statuscell''>'+@StatusCount+'</td></tr>'
   FETCH CUR_CREATE_INSERT_SCRIPT INTO @EventStatusName , @StatusCount
  END
  CLOSE CUR_CREATE_INSERT_SCRIPT
 DEALLOCATE CUR_CREATE_INSERT_SCRIPT
 
 -- Courts
 DECLARE @COURT_Venue VARCHAR(800)
 DECLARE @CourtCount VARCHAR(100)
 DECLARE CUR_COURT CURSOR FOR 
	SELECT COURT_Venue,COUNT(*) AS COUNT_COURT 
	FROM TBLEVENT TE 
	INNER JOIN TBLCASE TCA ON TE.CASE_ID = TCA.CASE_ID 
	INNER JOIN TBLCOURT TCO ON TCA.COURT_ID = TCO.COURT_ID
	WHERE TE.DomainId = @DomainId AND YEAR(CONVERT(DATE,EVENT_DATE)) = @YEAR AND MONTH(CONVERT(DATE,EVENT_DATE)) = @MONTH AND DAY(CONVERT(DATE,EVENT_DATE)) = @DAY
	and TCA.court_id not in ('3','6')
	GROUP BY COURT_Venue,CONVERT(DATE,EVENT_DATE)

 OPEN CUR_COURT
 FETCH CUR_COURT INTO @COURT_Venue , @CourtCount
set @OutputString = @OutputString + '<tr><td class=''statuscell''>------------------</td></tr>'
 WHILE @@FETCH_STATUS = 0
  BEGIN
   set @OutputString = @OutputString +  '<tr><td class=''statuscell''>'+@COURT_Venue +'</td><td class=''statuscell''>'+@CourtCount+'</td></tr>'
   FETCH CUR_COURT INTO @COURT_Venue , @CourtCount
  END
  CLOSE CUR_COURT
 DEALLOCATE CUR_COURT
 
 set @OutputString = @OutputString + '</table>'
 RETURN @OutputString 
END
