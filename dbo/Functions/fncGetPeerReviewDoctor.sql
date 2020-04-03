CREATE FUNCTION [dbo].[fncGetPeerReviewDoctor](@DomainId NVARCHAR(50), @Case_id varchar(50))
returns varchar(8000) as
BEGIN
 DECLARE @doctorname VARCHAR(200)
 DECLARE @OutputString VARCHAR(8000)
 
 DECLARE CURPeerReviewDoctor CURSOR
 FOR select distinct (Doctor_Name) as Doctor_Name 
	 from TblReviewingDoctor 
	 where DomainId=@DomainId and doctor_id in(select distinct(doctor_id) 
						from  TXN_CASE_PEER_REVIEW_DOCTOR
						where DomainId=@DomainId and treatment_id in (select treatment_id 
											   from tbltreatment 
											   where case_id= @Case_id and DomainId=@DomainId))

 OPEN CURPeerReviewDoctor
 
 set @OutputString = ''
 FETCH CURPeerReviewDoctor INTO @doctorname
 
 set @OutputString = ''
 WHILE @@FETCH_STATUS = 0
  BEGIN
   set @OutputString = @OutputString +  @doctorname + ', '
   FETCH CURPeerReviewDoctor INTO @doctorname
  END
  CLOSE CURPeerReviewDoctor
 DEALLOCATE CURPeerReviewDoctor

 if  len(@OutputString) >1
  set @OutputString = LEFT(@OutputString, LEN(ltrim(rtrim(@OutputString))) - 1)

 RETURN @OutputString 
END
