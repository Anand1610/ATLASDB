CREATE PROCEDURE [dbo].[F_Get_ARBFILED]   --[dbo].[F_Get_ARBFILED] '01/14/2015','01/16/2015','1','4425'
(
	@dt_From nvarchar(50),
	@dt_To nvarchar(50),
	@rblArb INT,
	@InsuranceCompany_Id NVARCHAR(200)
)
AS  
	BEGIN
	DECLARE @strsql VARCHAR(MAX)
		IF (@rblArb = '1')
		BEGIN
			SET @strsql  = 'SELECT LCJ.Case_Id,LCJ.InsuranceCompany_Name,Convert(varchar,IT.DateInserted,101) as DateInserted,I.Filename,I.FilePath from TBLDOCIMAGES I  
			Inner Join tblImageTag IT on IT.ImageID=i.ImageID  
			Inner Join tblTags T on T.NodeID=IT.TagID 
			INNER JOIN dbo.LCJ_VW_CaseSearchDetails LCJ ON T.CaseID=LCJ.Case_Id
			Where FilePath like ''%ARB Docs%'' and Filename like ''%_ARB_FILED_%''  and Filename like ''%.pdf''
			and LCJ.INSURANCE_NAME not in ( ''ALLSTATE INSURANCE COMPANY'',''GEICO INSURANCE COMPANY'') AND IT.IsDeleted=0 and I.IsDeleted=0 '
		---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
             -- and IT.IsDeleted=0 and I.IsDeleted=0   added
            ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude 
		
		END  
		ELSE
		IF (@rblArb = '0')
		BEGIN
			SET @strsql  = 'SELECT LCJ.Case_Id,LCJ.InsuranceCompany_Name,Convert(varchar,IT.DateInserted,101) as DateInserted,I.Filename,I.FilePath from TBLDOCIMAGES I    
			Inner Join tblImageTag IT on IT.ImageID=i.ImageID  
			Inner Join tblTags T on T.NodeID=IT.TagID 
			INNER JOIN dbo.LCJ_VW_CaseSearchDetails LCJ ON T.CaseID=LCJ.Case_Id
			Where IT.IsDeleted=0 and I.IsDeleted=0 AND FilePath like ''%ARB Docs%'' and Filename like ''%AAA DEMAND PACKET%''  and Filename like ''%.pdf'''
			---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
             --IT.IsDeleted=0 and I.IsDeleted=0 and  added
            ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude 
		END
		if @dt_From <>'1/1/0001' and @dt_To<>'1/1/0001' and @dt_From<>'' and @dt_To<>''
		begin  
			set @strsql = @strsql + '  and DateInserted Between ''' + @dt_From + ''' and ''' + @dt_To + ''' '
		end 
		if @InsuranceCompany_Id <> '0' and @InsuranceCompany_Id <> '' and @InsuranceCompany_Id <> '''0''' and @InsuranceCompany_Id <> ''''''
		begin  
			set @strsql = @strsql + '  AND LCJ.InsuranceCompany_Id IN (' + @InsuranceCompany_Id + ')'  
		end 
		print(@strsql)
		EXEC(@strsql)
	END
	SET NOCOUNT OFF;

