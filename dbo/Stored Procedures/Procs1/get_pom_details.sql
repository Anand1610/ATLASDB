CREATE PROCEDURE get_pom_details
(
	@DomainId varchar(40),
	@Case_Id varchar(40),
	@i_treatment_id int
)
AS
BEGIN 
	select 
	 Case WHEN Date_BillSent IS NULL THEN '' ELSE CONVERT(VARCHAR(10),Date_BillSent,101) END AS [POM Stamped Date],
	 Case WHEN pom_created_date IS NULL THEN '' ELSE CONVERT(VARCHAR(10),pom_created_date,101) END AS [POM Created Date],
	 pom_id  AS [POM ID]
	 from tblTreatment WHERE Treatment_Id = @i_treatment_id
END