
CREATE PROCEDURE [dbo].[tickets_sp_ddl_priority]
AS
BEGIN
	SELECT
		i_priority_id [ID],
		sz_priority [Text] 
	FROM mst_ticket_priority 
	ORDER BY i_ddl_sequence ASC
END
