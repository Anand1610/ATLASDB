
CREATE FUNCTION [dbo].[fncGetOperatingDoctor](@DomainId NVARCHAR(50), @Case_id varchar(50))
returns varchar(8000) as
BEGIN
 DECLARE @doctorname VARCHAR(200)
 DECLARE @OutputString VARCHAR(8000)
 
 DECLARE CURPeerReviewDoctor CURSOR
 FOR select distinct (Doctor_Name) as Doctor_Name 
	 from tblOperatingDoctor 
	 where DomainId=@DomainId and doctor_id in(select distinct(treatingDoctor_ID) 
						from  tblTreatment
						where DomainId=@DomainId AND Case_Id = @Case_Id )

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
