CREATE VIEW [dbo].[SJR_Treatment_view]
as
SELECT     Case_Id, convert(varchar(20),DateOfService_Start) + ' - ' + convert(varchar(20),DateOfService_End) AS DOS
FROM         tblTreatment
GROUP BY Case_Id, convert(varchar(20),DateOfService_Start) + ' - ' + convert(varchar(20),DateOfService_End)
