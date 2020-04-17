CREATE PROCEDURE [dbo].[LCJ_GetEditedDocs]
(
@Case_id varchar(50)
)
as 
begin
Select TG.NodeID[Node Id],TD.Filename [File Name],TD.ImageID[Image Id] from tblTags TG 
join tblImageTag TT on TG.NodeId=TT.TagID 
join tblDocImages TD on TD.ImageID=TT.ImageID
where TG.NodeType='SVDLET' and CaseID=@Case_Id 
---Start of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
  AND TT.IsDeleted =0   AND TD.IsDeleted=0  
---End   of  changes for LSS-470 done on 5 APRIL 2020  By Tushar Chandgude  
Order By Td.ImageID
end

