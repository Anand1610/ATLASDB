CREATE PROCEDURE [dbo].[Billing_Packet_DeleteCase]   
 -- Add the parameters for the stored procedure here  
 @DomainID VARCHAR(50),  
 @s_a_Caption VARCHAR(1024),  
 @s_a_MultipleCase_ID VARCHAR(1024),   
 @s_a_UserName VARCHAR(40)  
AS  
BEGIN  
 -- SET NOCOUNT ON added to prevent extra result sets from  
 -- interfering with SELECT statements.  
 SET NOCOUNT ON;  
  
    -- Insert statements for procedure here  
	 DECLARE @i_l_result INT  
	 DECLARE @s_l_message VARCHAR(500)  
	 DECLARE @s_l_Existing_Packet_IDS VARCHAR(1000) = ''  
  

	DECLARE @tblPacketDel AS TABLE
	(
		CaseID VARCHAR(100),
		Packeted_Case_ID VARCHAR(100)
	)

	INSERT INTO @tblPacketDel
	SELECT Case_ID, Packeted_Case_ID FROM Billing_Packet (NOLOCK) 
	WHERE Billing_Packet.Case_ID IN (SELECT s FROM dbo.SplitString(@s_a_MultipleCase_ID,',')) 


 IF EXISTS (Select CaseID FROM @tblPacketDel)  
 BEGIN  
  
  BEGIN TRAN  
	  -- Delete case from tbltreatment  
	   Delete from tblTreatment where  ACT_Case_ID IN (SELECT CaseID FROM @tblPacketDel) AND DomainId=@DomainID  
	   
	    Delete from txn_tbltreatment  where treatment_id 
	   in (select Treatment_Id from tblTreatment where  ACT_Case_ID IN (SELECT CaseID FROM @tblPacketDel) AND DomainId=@DomainID)

   
	  -- Unpacket the packded cases  
  
	 --  DECLARE @tblDateStatusChagne TABLE  
	 --  (  
		--CASE_ID VARCHAR(100),  
		--DomainID VARCHAR(100),  
		--Date_Status_Changed DATETIME  
	 --  )  
  
	 --  INSERT INTO @tblDateStatusChagne  
	 --  SELECT case_id, DomainID, Date_Status_Changed  FROM tblcase (NOLOCK) 
	 --  WHERE DomainID =@DomainID AND Case_Id IN (SELECT CaseID FROM @tblPacketDel)

	   SELECT	Case_Id,Date_Status_Changed
		INTO	#temp
		FROM	tblcase
		WHERE	DomainID =@DomainID 
		AND		Case_Id IN (SELECT CaseID FROM @tblPacketDel)
		AND		Status = 'IN ARB OR LIT'
  
	   UPDATE	tblCase   
	   SET		Status = Old_Status  
	   WHERE	DomainID =@DomainID 
	   AND		Case_Id IN (SELECT CaseID FROM @tblPacketDel) 
	   AND		Status = 'IN ARB OR LIT'

	   UPDATE	CAS
		SET		CAS.Date_Status_Changed = tcd.Packeted_Status_Date
		FROM	TBLCASE CAS 
		JOIN	#temp ON CAS.Case_Id = #temp.Case_Id
		JOIN	tblCase_Date_Details tcd ON	tcd.Case_Id = #temp.Case_Id
  
	   --UPDATE CAS  
	   --SET Date_Status_Changed = DT.Date_Status_Changed  
	   --FROM TBLCASE CAS   
	   --INNER JOIN @tblDateStatusChagne DT ON CAS.Case_Id = DT.CASE_ID  
	   --WHERE CAS.DomainID =@DomainID
	   --AND CAS.Case_Id IN (SELECT CaseID FROM @tblPacketDel) 
  
	   -- // DELETE Documents ---------------------  
	   DECLARE @tblTagIdDelete TABLE (ImageID INT)  
	   INSERT INTO @tblTagIdDelete   
  
		SELECT  I.ImageID from dbo.TBLDOCIMAGES I (NOLOCK)
		INNER JOIN dbo.tblImageTag IT on IT.ImageID=i.ImageID and IT.DomainID = I.DomainID
		INNER JOIN dbo.tblTags T on T.NodeID = IT.TagID and T.DomainID = T.DomainID
		WHERE T.DomainID = @DomainID
		AND T.CaseID IN (SELECT DISTINCT Packeted_Case_ID FROM @tblPacketDel)
		AND I.ACT_CASE_ID IN (SELECT DISTINCT CaseID FROM @tblPacketDel)  


	   DELETE FROM TBLDOCIMAGES where DomainID = @DomainID AND imageID IN (select ImageID from @tblTagIdDelete)  
  
	   DELETE FROM  tblImageTag WHERE DomainID = @DomainID AND TagID IN (select ImageID from @tblTagIdDelete)  
  
  
	   INSERT INTO tblNotes(Notes_Desc,Notes_Type,Notes_Priority,Case_Id,Notes_Date,User_Id,DomainID)  
	   SELECT 'Cases '+ CaseID + ' unpacketed', 'Activity', 1, Packeted_Case_ID, getdate(),@s_a_UserName, @DomainID  
	   FROM @tblPacketDel 
  
	   -- Delete case from billin packet  
	   Delete from Billing_Packet where DomainID = @DomainID AND Case_ID IN (SELECT CaseID FROM @tblPacketDel) AND DomainId=@DomainID    
   
  
		  -- Update Auto_Billing_Packet and Auto_Billing_Packet_Info table  
		  --EXEC Auto_Billing_Packet_Insert  
	   -- EXEC Auto_Billing_Case_Insert @DomainID,@s_a_MultipleCase_ID  
         
  
		SET @s_l_message = 'Cases deleted successfully from Packets. PacketIDs - '+ @s_l_Existing_Packet_IDS + ' CaseIDs - '+@s_a_MultipleCase_ID  
		SET @i_l_result  =  0   
  
	COMMIT TRAN  
 END  
 ELSE  
 BEGIN  
     SET @s_l_message = 'Packet not found. No data available for '+ @DomainID+ ' => '+ @s_a_MultipleCase_ID   
	SET @i_l_result  =  0  
 END  


    Declare @Packeted_Case_ID varchar(50) =  (select top 1 Packeted_Case_ID FROM @tblPacketDel)

	  
	   
       exec Update_Denial_Case @Packeted_Case_ID


 SELECT @s_l_message AS [Message], @i_l_result AS [RESULT]  
END  
   
  
  
  