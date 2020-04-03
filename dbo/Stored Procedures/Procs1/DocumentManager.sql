create PROC [dbo].[DocumentManager]
@NodeID INT = 0,
@ParentID INT,
@NodeName NVARCHAR(600),
@CaseID varchar(50),
@NodeIcon NVARCHAR(100), 
@NodeLevel INT,
@Expanded BIT,
@DomainId varchar(10),
@Flag NVARCHAR(100)
AS
BEGIN

IF(@Flag = 'AddNewNode')
BEGIN
if not exists (select NodeID from  tblTags where ParentID=@ParentID and NodeName=@NodeName)
begin
	INSERT INTO tblTags
	(
	ParentID,
	NodeName,
	CaseID,
	NodeIcon,
	NodeLevel,
	Expanded,
	DomainId
	)
	VALUES
	(
	@ParentID,
	@NodeName,
	@CaseID,
	@NodeIcon,
	@NodeLevel,
	@Expanded,
	@DomainId
	)
	SELECT SCOPE_IDENTITY()
End
Else
begin
select 0
End
END
END