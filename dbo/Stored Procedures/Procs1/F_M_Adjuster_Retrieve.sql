CREATE PROCEDURE [dbo].[F_M_Adjuster_Retrieve]
		(
			@i_a_Adjuster_id	INT
		)

AS
BEGIN
	 IF (@i_a_Adjuster_id<>0)	
		BEGIN
			SELECT tbladjusters.Adjuster_Id,tbladjusters.Adjuster_LastName,tbladjusters.Adjuster_FirstName,tbladjusters.InsuranceCompany_Id,tbladjusters.Adjuster_Phone,tbladjusters.Adjuster_Fax,tbladjusters.Adjuster_Email,tbladjusters.Adjuster_Extension,tbladjusters.Adjuster_Address,tblInsuranceCompany.InsuranceCompany_Name
            FROM tblAdjusters  inner join tblInsuranceCompany  on tbladjusters.InsuranceCompany_Id=tblInsuranceCompany.InsuranceCompany_Id  WHERE Adjuster_Id=@i_a_Adjuster_id ORDER BY tblAdjusters.Adjuster_FirstName
		END
		
	 IF (@i_a_Adjuster_id=0)	
		BEGIN
			SELECT  tbladjusters.Adjuster_Id,tbladjusters.Adjuster_LastName,tbladjusters.Adjuster_FirstName,tbladjusters.InsuranceCompany_Id,tbladjusters.Adjuster_Phone,tbladjusters.Adjuster_Fax,tbladjusters.Adjuster_Email,tbladjusters.Adjuster_Extension,tbladjusters.Adjuster_Address,tblInsuranceCompany.InsuranceCompany_Name
            FROM tblAdjusters  inner join tblInsuranceCompany  on tbladjusters.InsuranceCompany_Id=tblInsuranceCompany.InsuranceCompany_Id  WHERE Adjuster_Id <>0 ORDER BY tblAdjusters.Adjuster_FirstName
		END
END

