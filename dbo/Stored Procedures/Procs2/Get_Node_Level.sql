/*    ==Scripting Parameters==

 Created By = Abhay.W
 Created Date = 04/29/2020
*/

CREATE PROCEDURE [dbo].[Get_Node_Level]
(
	@DomainId	VARCHAR(10),
	@NodeId		INT
)
AS
BEGIN
	SELECT NodeLevel From MST_DOCUMENT_NODES WHERE DomainId = @DomainId AND NodeID = @NodeId
END