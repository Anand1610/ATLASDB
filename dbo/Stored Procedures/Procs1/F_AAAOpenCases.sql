CREATE PROCEDURE [dbo].[F_AAAOpenCases]--[F_AAAOpenCases] '0','FH11-86759,FH07-42372'







	-- Add the parameters for the stored procedure here   [F_AAAOpenCases] 'AAA OPEN',''







											--EXEC F_AAAOpenCases 'AAA OPEN','' 







(







	@Status nvarchar(50),







	@Case_id varchar(200)







	--@chk varchar(10)







)







AS







DECLARE @strsql as varchar(8000)







DECLARE @Cases AS NVARCHAR(MAX)







set @Cases=REPLACE (@Case_id,',',''',''')







BEGIN







	SET NOCOUNT ON;







	BEGIN







		set @strsql ='select distinct C.Case_Id AS [Case_ID],







		Initial_Status AS [Case_Status],







		status AS [Current_Status],







		injuredparty_name as  [Patient_Name],







		provider_name AS [Provider],







		Provider_GroupName AS [Provider_Group],







		INSURANCE_NAME AS [Insurance_Company],







		(SELECT COUNT(*) FROM tblImages WHERE case_id =C.case_id and DeleteFlag=0 and filename not like ''%.pdf'' and filename not like ''%Select%''and filename <> '''') AS [Scan_Docs_Images],







		(SELECT COUNT(filename) from dbo.TBLDOCIMAGES I  







		Inner Join dbo.tblImageTag IT on IT.ImageID=i.ImageID  







		Inner Join dbo.tblTags T on T.NodeID=IT.TagID and T.CaseID=c.Case_Id 







		WHERE Filename like ''%.pdf'' and I.IsDeleted=0 and IT.IsDeleted=0) AS [DM_Files],







		LTRIM(RTRIM(N.User_Id)) AS [Case_Opener],







		Date_Opened AS [Date_Opened],







		CASE WHEN date_status_changed is null then  datediff(dd,Date_Opened,GETDATE())  ELSE datediff(dd,date_status_changed,GETDATE()) END AS [Status_Age]







		from LCJ_VW_CaseSearchDetails  c 







		INNER JOIN tblNotes N on N.Case_Id = C.Case_Id and N.Notes_Desc = ''Case Opened''







		where  1=1'







		  
 ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
			 --and I.IsDeleted=0 and IT.IsDeleted=0 added
			---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude






		if @Case_id <> ''  







		begin  







			set @strsql = @strsql + ' AND C.Case_Id in(''' + @Cases + ''')'              







		end  







		







		if @Status <> '' and @Status <> '0'  







		begin  







			set @strsql = @strsql + '  AND Status = ''' + @Status + ''''         







		end 







	END







print (@strsql)







exec (@strsql)







END

