CREATE PROCEDURE [dbo].[LCJ_UPDATE_DOCUMENT_DATA]
(
		@documentID NVARCHAR(20),
		@imageID INT
)

AS
	update tblImages set DocumentID=@documentID where imageid=@imageID

