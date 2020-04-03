CREATE PROCEDURE [dbo].[Get_Court_Detail]   
 @s_a_CaseId varchar(50),  
 @S_a_DomainId varchar(50)  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
  
    Select   
 TOP 1 ISNULL(Court_Misc ,'') AS  Court_Misc
 from tblcase c   
 left join tblCourt co on co.Court_Id = c.Court_Id   
 LEFT OUTER  JOIN dbo.tblPacket pkt ON c.FK_Packet_ID = pkt.Packet_Auto_ID   
 where (c.Case_Id = @s_a_CaseId OR pkt.PacketID = @s_a_CaseId)  
 and c.DomainId = @S_a_DomainId  
  
END  