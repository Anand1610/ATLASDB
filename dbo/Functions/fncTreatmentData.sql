CREATE FUNCTION [dbo].[fncTreatmentData](@Treatment_ID int,@type varchar(100))
returns varchar(8000) as
BEGIN
 DECLARE @treatmentData VARCHAR(200)
 DECLARE @OutputString VARCHAR(8000)
 

 
	if @type='PeerReviewDoctor'
	Begin
		DECLARE CURTreatmentDetails CURSOR
		FOR
		select distinct (Doctor_Name) as Doctor_Name from TblReviewingDoctor where doctor_id in(select distinct(doctor_id) from  TXN_CASE_PEER_REVIEW_DOCTOR where treatment_id = @Treatment_ID)
	END 
	ELSE
	bEGIN
		DECLARE CURTreatmentDetails CURSOR
		FOR
		SELECT DISTINCT(DENIALREASONS_TYPE)  FROM dbo.tblDenialReasons WHERE DENIALrEASONS_ID IN (SELECT DENIALrEASONS_ID FROM TXN_TBLTREATMENT WHERE TREATMENT_ID = @Treatment_ID)
	END


 OPEN CURTreatmentDetails
 
 set @OutputString = ''
 FETCH CURTreatmentDetails INTO @treatmentData
 
 set @OutputString = ','
 WHILE @@FETCH_STATUS = 0
  BEGIN
   set @OutputString = @OutputString +  @treatmentData + ','
   FETCH CURTreatmentDetails INTO @treatmentData
  END
  CLOSE CURTreatmentDetails
 DEALLOCATE CURTreatmentDetails

 if  len(@OutputString) >1
  set @OutputString = LEFT(@OutputString, LEN(ltrim(rtrim(@OutputString))) - 5)

 RETURN @OutputString 
END
