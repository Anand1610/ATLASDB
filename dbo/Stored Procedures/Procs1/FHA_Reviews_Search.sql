-- =============================================
-- Author:		Serge Rosenthal
-- ALTER date: 03/30/2009
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[FHA_Reviews_Search]
@Doctor varchar(100),@Provider varchar(100),@Insurance varchar(100),@Service_Type varchar(50), @Review_Date_Start	varchar(20)	, @Review_Date_End varchar(20)
AS
BEGIN
	
	SET NOCOUNT ON;

if @Review_Date_Start is null or @Review_Date_Start ='' set @Review_Date_Start='1/1/1900'
if @Review_Date_End is null or @Review_Date_End ='' set @Review_Date_End= CONVERT(VARCHAR(20),GETDATE(),101)


 SELECT     TblReviewingDoctor.Doctor_Name, tblProvider.Provider_Name, tblInsuranceCompany.InsuranceCompany_Name, tblServiceType.ServiceDesc, 
                      TblReviews.Case_id, TblReviews.Review_Date
FROM         TblReviewingDoctor INNER JOIN
                      tblcase INNER JOIN
                      tblProvider ON tblcase.Provider_Id = tblProvider.Provider_Id INNER JOIN
                      tblInsuranceCompany ON tblcase.InsuranceCompany_Id = tblInsuranceCompany.InsuranceCompany_Id INNER JOIN
                      TblReviews ON tblcase.Case_Id = TblReviews.Case_id INNER JOIN
                      tblServiceType ON TblReviews.Service_type = tblServiceType.ServiceType_ID ON TblReviewingDoctor.Doctor_id = TblReviews.Review_Doctor
WHERE (TblReviewingDoctor.Doctor_Name like '%' + isnull(@Doctor,'') + '%') AND (tblProvider.Provider_Name like '%' + isnull(@Provider,'') + '%')
		AND (tblInsuranceCompany.InsuranceCompany_Name like '%' + isnull(@Insurance,'') + '%') AND (tblServiceType.ServiceDesc like '%' + isnull(@Service_Type,'') + '%')
		AND (CONVERT(VARCHAR(20),TblReviews.Review_Date,101) between  @Review_Date_Start and @Review_Date_End)
END

