
CREATE PROCEDURE [dbo].[Change_Status] --[Change_Status]'admin'
	
	@LOGIN_USERNAME VARCHAR(50)
	
AS
BEGIN
		declare @CASE_ID as VARCHAR(max) 
		declare @desc as  VARCHAR(500)
		--declare @LOGIN_USERID AS INT		
		DECLARE @strsql as VARCHAR(max) 
		declare @index integer
		 DECLARE @Old_Case_Status VARCHAR(300) 
		 DECLARE @newStatusHierarchy int
	DECLARE @oldStatusHierarchy int
set @index = 1		
create table #temp(
 Case_Id VARCHAR(500)
 )
 insert into #temp 
select Case_ID from tblcase WHERE  (convert(money,Claim_Amount) - convert(money,Paid_Amount) ) <=0  and Status not like '%close%' and DomainId ='DL' and gb_case_id is not null
begin
while @index <= (select COUNT (*) from #temp) 
begin

	set @CASE_ID=(Select a.Case_Id from (SELECT ROW_NUMBER() OVER (ORDER BY Case_Id ASC) AS RowNum,Case_Id FROM #temp)a where a.RowNum =@index)
	--if NOT Exists(select case_id from tblNotes where Case_Id = @CASE_ID and Notes_Desc = 'Initial_Status changed from ARB to CLOSED')
	--BEGIN	
	SET @Old_Case_Status=(select Status from tblCase WHERE DomainID ='DL' AND Case_Id =@CASE_ID)
	SET @oldStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID ='DL' and Status_Type=@CASE_ID)
   SET @newStatusHierarchy =(Select  Status_Hierarchy from  tblStatus where  DomainID ='DL' and Status_Type=@CASE_ID)

		if(@newStatusHierarchy>=@oldStatusHierarchy)
		BEGIN
			update tblcase set Initial_Status='CLOSED' , Status ='CLOSED - RETURNED TO CLIENT' where Case_Id =@CASE_ID
			DECLARE @NotesDESC VARCHAR(1000)
			SET @NotesDESC ='Our LawFirm cannot pursue paid bill(s).'

			insert into tblnotes (Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id)
			values (@NotesDESC,'Provider',1,@CASE_ID,getdate(),@LOGIN_USERNAME)
		ENd
		--values (@NotesDESC,'Activity',1,@CASE_ID,getdate(),@LOGIN_USERNAME)
	
	--END		

	  set @index = @index + 1
end
end
END

