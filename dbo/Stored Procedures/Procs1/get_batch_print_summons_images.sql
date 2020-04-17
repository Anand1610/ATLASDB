-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[get_batch_print_summons_images]
	 @s_a_CaseId varchar(50),
	 @s_a_DomainId varchar(50)
AS
BEGIN
	
	SET NOCOUNT ON;

	CREATE TABLE #TEMP(Image_Id int, Filename NVARCHAR(500))

 IF EXISTS(select * from TBLDOCIMAGES I Join tblImageTag IT on IT.ImageID=i.ImageID Join tblTags T on T.NodeID = IT.TagID and T.CaseID= @s_a_CaseId and I.DomainId = @s_a_DomainId and NodeName in ('A.O.B') and Filename like '%.pdf%'
  ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
   where I.IsDeleted=0 AND IT.IsDeleted=0  
---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude 
 )
  BEGIN
	INSERT INTO #TEMP
	SELECT 0,'exhibits\Summons\A Exhibit.pdf'
	UNION
	 SELECT 
	   I.ImageID ,(B.PhysicalBasePath+FilePath+Filename)AS Filename  
	 from 
	  TBLDOCIMAGES I
	  Join tblImageTag IT on IT.ImageID=i.ImageID and IT.DomainId = I.DomainId
	  Join tblTags T on T.NodeID = IT.TagID and T.CaseID= @s_a_CaseId and NodeName in ('A.O.B') and Filename like '%.pdf%'  and IT.DomainId = T.DomainId
	  Join tblBasePath B on B.BasePathId = I.BasePathId
	  where I.DomainId = @s_a_DomainId
	       ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
   AND I.IsDeleted=0 AND IT.IsDeleted=0  
      ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
  END

  IF EXISTS(select * from TBLDOCIMAGES I Join tblImageTag IT on IT.ImageID=i.ImageID Join tblTags T on T.NodeID = IT.TagID and T.CaseID= @s_a_CaseId and I.DomainId = @s_a_DomainId and NodeName in ('Bills') and Filename like '%.pdf%'
    ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
    where I.IsDeleted=0 AND IT.IsDeleted=0  
  ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude
  )
  BEGIN
	INSERT INTO #TEMP
	SELECT 0,'exhibits\Summons\B Exhibit.pdf'
	UNION
	SELECT 
	   I.ImageID ,(B.PhysicalBasePath+FilePath+Filename)AS Filename  
	 from 
	  TBLDOCIMAGES I
	  Join tblImageTag IT on IT.ImageID=i.ImageID and IT.DomainId = I.DomainId
	  Join tblTags T on T.NodeID = IT.TagID and T.CaseID= @s_a_CaseId and NodeName in ('Bills') and Filename like '%.pdf%' and IT.DomainId = T.DomainId
	  Join tblBasePath B on B.BasePathId = I.BasePathId
	  where I.DomainId = @s_a_DomainId
	      ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
  AND I.IsDeleted=0 AND IT.IsDeleted=0  
      ---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude 
   END

   IF NOT EXISTS(select * from TBLDOCIMAGES I Join tblImageTag IT on IT.ImageID=i.ImageID Join tblTags T on T.NodeID = IT.TagID and T.CaseID= @s_a_CaseId and I.DomainId = @s_a_DomainId  and NodeName in ('A.O.B') and Filename like '%.pdf%'
     ---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
     where I.IsDeleted=0 AND IT.IsDeleted=0  
---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
   )
	BEGIN
	  UPDATE #TEMP SET Filename='exhibits\Summons\A Exhibit.pdf' WHERE Image_Id =0
	END

select * from #TEMP
DROP TABLE #TEMP

END
