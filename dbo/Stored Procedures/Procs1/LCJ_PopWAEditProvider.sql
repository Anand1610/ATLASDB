CREATE PROCEDURE [dbo].[LCJ_PopWAEditProvider]
(

@Provider_Id		nvarchar(100),
@Case_Id		nvarchar(100)

)

AS

UPDATE tblCase SET

		Provider_Id = @Provider_Id
		
WHERE 
		Case_Id = Rtrim(Ltrim(@Case_Id))

