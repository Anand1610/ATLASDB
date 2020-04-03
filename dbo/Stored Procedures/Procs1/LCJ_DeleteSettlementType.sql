CREATE PROCEDURE [dbo].[LCJ_DeleteSettlementType]
(

@DomainId		 nvarchar(50),
@Settlement_Type nvarchar(100)

)


AS

DELETE from tblSettlement_Type  where Settlement_Type = + Rtrim(Ltrim(@Settlement_Type)) and DomainId=@DomainId

