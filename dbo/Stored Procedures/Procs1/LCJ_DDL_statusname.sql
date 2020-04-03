CREATE PROCEDURE [dbo].[LCJ_DDL_statusname]
@DomainId NVARCHAR(50)  
As
 
Begin
	select  '' [EventStatusId], ' ---Select Event Status--- ' [EventStatusName]
	union
	select EventStatusid,EventStatusName from tblEventstatus WHERE DomainId=@DomainId
order by EventStatusName
end

