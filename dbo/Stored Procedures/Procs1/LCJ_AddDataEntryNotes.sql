CREATE PROCEDURE [dbo].[LCJ_AddDataEntryNotes]-- 'priya','admin','PRIYA17-101380'
(
@DomainId VARCHAR(50),
@USER_ID VARCHAR(50),
@CASE_ID VARCHAR(50)
)
AS
BEGIN
INSERT INTO tblNotes
(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id,DomainId)
  VALUES   
 ('CASE OPENED','G',0,@CASE_ID,getdate(),@user_id,@DomainId)
END
