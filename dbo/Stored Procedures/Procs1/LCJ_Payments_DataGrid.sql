CREATE PROCEDURE [dbo].[LCJ_Payments_DataGrid]

(
@DomainId nvarchar(50),
@Case_Id NVARCHAR(100)

)
AS

Select * from LCJ_VW_PaymentsGrid where Case_Id= + @Case_Id and DomainId=@DomainId

