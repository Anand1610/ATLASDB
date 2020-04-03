CREATE PROCEDURE [dbo].[GetCaseCalculation] 
	@s_a_CaseId varchar(50),
	@s_a_DomainId varchar(50),
	@s_a_Court_Misc varchar(50)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
    
    DECLARE @s_l_PacketID VARCHAR(100) = ''
	DECLARE @S_l_Packeted_Case_Ids VARCHAR(MAX)

	IF (Exists(Select Packet_Auto_ID from tblPacket where PacketID=@s_a_CaseId))
	BEGIN
	   SET @s_l_PacketID = @s_a_CaseId
	END
	ELSE
	BEGIN
		SET @s_l_PacketID = (SELECT  TOP 1 ISNULL(PacketID,'') FROM dbo.tblCase cas
		INNER  JOIN dbo.tblPacket pkt ON cas.FK_Packet_ID = pkt.Packet_Auto_ID 
		WHERE CASE_ID = @s_a_CaseId)
	END

	IF(@s_l_PacketID  IS NULL or @s_l_PacketID = '')
	BEGIN
	  Set @S_l_Packeted_Case_Ids = @s_a_CaseId
	END
	ELSE
	BEGIN
	 SET @S_l_Packeted_Case_Ids =  STUFF((SELECT ',' + CASE_ID FROM dbo.tblCase cas
								   INNER  JOIN dbo.tblPacket pkt ON cas.FK_Packet_ID = pkt.Packet_Auto_ID 
								   WHERE PacketID = @s_l_PacketID and cas.DomainID = @s_a_DomainId
								FOR XML PATH('')), 1, 1, '')
	END

   IF @s_a_Court_Misc != 'SUFFOLK' and @s_a_Court_Misc != 'NASSAU'
   BEGIN
    SELECT 
		 b.DateOfService_Start
		,b.DateOfService_End
		,b.claim_amount-b.paid_amount as [balanceTreatment] 
		,convert(decimal(38,2),b.Claim_Amount)[Claim_Amount]
		,INS_CLAIM_NUMBER
		,b.paid_amount
		FROM tblcase a 
		LEFT OUTER JOIN tbltreatment b ON a.case_id=b.case_id WHERE a.Case_Id in (SELECT items FROM dbo.STRING_SPLIT(@S_l_Packeted_Case_Ids,',')) and a.DomainId=@s_a_DomainId
		and b.claim_amount-b.paid_amount > 0.00 ORDER BY B.DATEOFSERVICE_START
   END
   ELSE
    BEGIN
		 SELECT 
		 MIN(b.DateOfService_Start) as DateOfService_Start
		,Max(b.DateOfService_End) as DateOfService_End
		,sum(b.claim_amount-b.paid_amount) as [balanceTreatment] 
		,sum(convert(decimal(38,2),b.Claim_Amount))[Claim_Amount]
		,INS_CLAIM_NUMBER
		,sum(b.paid_amount) As paid_amount
		FROM tblcase a 
		LEFT OUTER JOIN tbltreatment b ON a.case_id=b.case_id WHERE a.Case_Id in (SELECT items FROM dbo.STRING_SPLIT(@S_l_Packeted_Case_Ids,',')) and a.DomainId=@s_a_DomainId
		and b.claim_amount-b.paid_amount > 0.00 
		group by a.Case_Id, INS_CLAIM_NUMBER
	END

END
