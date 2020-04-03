/****** Object:  Stored Procedure dbo.SP_InsertImage    Script Date: 1/31/2005 5:22:47 AM ******/
CREATE PROCEDURE [dbo].[SP_InsertImage](@ImagePath nvarchar(255),@Filename nvarchar(100),@DocumentID nvarchar(20),
@CaseId nvarchar(50),@ScanDate nvarchar(50),@UserId nvarchar(50),@RecordDescriptor nvarchar(220))
as

begin

declare
@st nvarchar(1000)

create table #tempt(caseid varchar(100))

set @ImagePath=ltrim(rtrim(@ImagePath))
set @Filename=ltrim(rtrim(@Filename))
set @DocumentID=ltrim(rtrim(@DocumentID))
set @CaseId=ltrim(rtrim(@CaseId))
set @ScanDate=ltrim(rtrim(@ScanDate))
set @UserId=ltrim(rtrim(@UserId))
set @RecordDescriptor=ltrim(rtrim(@RecordDescriptor))

if  left(@CaseId,2) <> 'FH' 
BEGIN
	/*set @st = 'SELECT CASE_ID FROM TBLCASE WHERE CASE_ID like ''%' + @CASEID + ''''
This code was disabled because it does not recognize 4 digit ids*/
	set @st = 'SELECT CASE_ID FROM TBLCASE WHERE CASE_AUTOID ='+ @CASEID 
	--print @st
	insert into #tempt
	exec sp_executesql @st
	
	select @caseid = caseid from #tempt

END

insert into tblImages(ImagePath,Filename,DocumentID,Case_Id,ScanDate,UserId,RecordDescriptor)
 values(@ImagePath,@Filename,@DocumentID,@CaseId,@ScanDate,@UserId,@RecordDescriptor)

end

