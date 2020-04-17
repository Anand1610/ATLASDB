CREATE PROCEDURE [dbo].[get_summons_images]--get_summons_images 'Fh07-42372' 
(  
   @CaseId NVARCHAR(50)
)  
as  
BEGIN 
CREATE TABLE #TEMP(Image_Id int, Filename NVARCHAR(500))

IF EXISTS(select * from TBLDOCIMAGES I Join tblImageTag IT on IT.ImageID=i.ImageID Join tblTags T on T.NodeID = IT.TagID and T.CaseID= @CaseId and NodeName in ('A.O.B') and Filename like '%.pdf%'
 ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
	  WHERE I.IsDeleted=0 AND IT.IsDeleted=0	
      ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
)
BEGIN
	INSERT INTO #TEMP
	SELECT 0,'exhibits\Summons\A Exhibit.pdf'
	UNION
	SELECT 
	   I.ImageID ,(FilePath+Filename)AS Filename  
	 from 
	  TBLDOCIMAGES I
	  Join tblImageTag IT on IT.ImageID=i.ImageID
	  Join tblTags T on T.NodeID = IT.TagID and T.CaseID= @CaseId and NodeName in ('A.O.B') and Filename like '%.pdf%'
	   ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
	  WHERE I.IsDeleted=0 AND IT.IsDeleted=0	
      ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
END

IF EXISTS(select * from TBLDOCIMAGES I Join tblImageTag IT on IT.ImageID=i.ImageID Join tblTags T on T.NodeID = IT.TagID and T.CaseID= @CaseId and NodeName in ('Bills') and Filename like '%.pdf%'
 ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
	  WHERE I.IsDeleted=0 AND IT.IsDeleted=0	
      ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
)
BEGIN
	INSERT INTO #TEMP
	SELECT 0,'exhibits\Summons\B Exhibit.pdf'
	UNION
	SELECT 
	   I.ImageID ,(FilePath+Filename)AS Filename  
	 from 
	  TBLDOCIMAGES I
	  Join tblImageTag IT on IT.ImageID=i.ImageID
	  Join tblTags T on T.NodeID = IT.TagID and T.CaseID= @CaseId and NodeName in ('Bills') and Filename like '%.pdf%'
	   ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
	  WHERE I.IsDeleted=0 AND IT.IsDeleted=0	
      ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
END
  
IF NOT EXISTS(select * from TBLDOCIMAGES I Join tblImageTag IT on IT.ImageID=i.ImageID Join tblTags T on T.NodeID = IT.TagID and T.CaseID= @CaseId and NodeName in ('A.O.B') and Filename like '%.pdf%'
 ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
	  WHERE I.IsDeleted=0 AND IT.IsDeleted=0	
      ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
)
BEGIN
  UPDATE #TEMP SET Filename='exhibits\Summons\A Exhibit.pdf' WHERE Image_Id =0
END

select * from #TEMP
DROP TABLE #TEMP
END

