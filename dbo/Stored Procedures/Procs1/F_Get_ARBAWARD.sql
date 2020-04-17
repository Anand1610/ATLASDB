
CREATE PROCEDURE [dbo].[F_Get_ARBAWARD]   --[dbo].[F_Get_ARBFILED] '06/04/2016','06/14/2016','0',0
(
	@dt_From DATETIME,
	@dt_To DATETIME,
	@pro_id INT,
	@pro_grp VARCHAR(200)
)
AS  
	BEGIN
	
		IF (@pro_id != '0')
		BEGIN
			SELECT LCJ.Case_Id,Provider_Name,tblDocImages.FilePath,tblDocImages.Filename,Convert(varchar,tblImageTag.DateInserted,101) as DateInserted FROM tblDocImages with(nolock) 
			LEFT OUTER JOIN tblImageTag   with(nolock)
			ON tblDocImages.imageid=tblImageTag.imageid
			LEFT OUTER JOIN tblTags   with(nolock)
			ON tblTags.NodeID = tblImageTag.TagID
			INNER JOIN dbo.tblCase lcj  with(nolock) ON lcj.Case_Id=tblTags.CaseID
			INNER JOIN  dbo.tblInsuranceCompany WITH (NOLOCK) ON lcj.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id   
            INNER JOIN dbo.tblProvider WITH (NOLOCK) ON lcj.Provider_Id = dbo.tblProvider.Provider_Id 
			WHERE ISNULL(lcj.IsDeleted,0) = 0  AND NodeName in ('Arbitration Awards','MASTER ARBITRATION AWARD') 
			AND lcj.Provider_Id=@pro_id AND DateInserted BETWEEN @dt_From AND @dt_To
			---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
		    and tblDocImages.IsDeleted=0 AND tblImageTag.IsDeleted=0
            ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
 
		END  
		ELSE
		IF (@pro_grp != '0')
		BEGIN
			SELECT LCJ.Case_Id,pro.Provider_Name,pro.Provider_GroupName, tblDocImages.FilePath,tblDocImages.Filename, Convert(varchar,tblImageTag.DateInserted,101) as DateInserted 
			FROM tblDocImages  with(nolock)
			LEFT OUTER JOIN tblImageTag  with(nolock)
			ON tblDocImages.imageid=tblImageTag.imageid
			LEFT OUTER JOIN tblTags   with(nolock)
			ON tblTags.NodeID = tblImageTag.TagID
			INNER JOIN dbo.tblCase lcj   with(nolock) ON lcj.Case_Id=tblTags.CaseID
			INNER JOIN  dbo.tblInsuranceCompany  WITH (NOLOCK) ON lcj.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id   
            INNER JOIN dbo.tblProvider pro WITH (NOLOCK) ON lcj.Provider_Id =pro.Provider_Id
			INNER JOIN dbo.TblProvider_Groups pro_grp  with(nolock) ON pro_grp.Provider_Group_Name=pro.Provider_GroupName
			WHERE  ISNULL(lcj.IsDeleted,0) = 0 AND NodeName in ('Arbitration Awards','MASTER ARBITRATION AWARD')  AND pro.Provider_GroupName=@pro_grp AND DateInserted BETWEEN @dt_From AND @dt_To
			---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
		    and tblDocImages.IsDeleted=0 AND tblImageTag.IsDeleted=0 
            ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
		END
		IF (@pro_id = '0' and @pro_grp = '0')
		BEGIN
			SELECT LCJ.Case_Id,pro.Provider_Name,tblDocImages.FilePath,tblDocImages.Filename,Convert(varchar,tblImageTag.DateInserted,101) as DateInserted FROM tblDocImages 
			 with(nolock)
			LEFT OUTER JOIN tblImageTag  with(nolock)
			ON tblDocImages.imageid=tblImageTag.imageid
			LEFT OUTER JOIN tblTags  with(nolock)
			ON tblTags.NodeID = tblImageTag.TagID
			INNER JOIN dbo.tblCase lcj  with(nolock) ON lcj.Case_Id=tblTags.CaseID
			INNER JOIN  dbo.tblInsuranceCompany WITH (NOLOCK) ON lcj.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id   
            INNER JOIN dbo.tblProvider pro WITH (NOLOCK) ON lcj.Provider_Id =pro.Provider_Id
			WHERE ISNULL(lcj.IsDeleted,0) = 0 AND NodeName in ('Arbitration Awards','MASTER ARBITRATION AWARD') AND DateInserted BETWEEN @dt_From AND @dt_To
			 ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
		    and tblDocImages.IsDeleted=0 AND tblImageTag.IsDeleted=0
            ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
 
		END  
	END
	SET NOCOUNT OFF;

