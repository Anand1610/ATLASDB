CREATE PROCEDURE [dbo].[Get_PacketDetail] 
    @s_a_DomainId varchar(50),
	@s_a_Case_Id varchar(50),
	@i_a_PageSize int = 10,
	@i_a_PageNumber int =1
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	declare @Min_DOS_Start DATETIME
    declare @Max_DOS_End DATETIME
	Declare @PacketId int;
	declare @Claim_Amount nvarchar(50)
	declare @Fee_Schedule nvarchar(50)
	declare @Paid_Amount nvarchar(50)
	declare @Balance decimal(18,2)

	Select @PacketId = FK_Packet_ID from tblcase WITH(NOLOCK) where DomainId=@s_a_DomainId and  Case_Id=@s_a_Case_Id 

	
	if @PacketId is not null
	 BEGIN

	 set @Min_DOS_Start=(select min(DateOfService_Start)as DOS_Start from tbltreatment (NOLOCK) where Case_Id in (Select Case_Id from tblCase(NOLOCK) where FK_Packet_ID=@PacketId))  
	 set @Max_DOS_End=(select max(DateOfService_End)as DOS_End from tbltreatment (NOLOCK) where Case_Id in (Select Case_Id from tblCase(NOLOCK) where FK_Packet_ID=@PacketId))  
	
	 Select @Claim_Amount = ISNULL(convert(nvarchar,SUM(trmt.Claim_Amount)),'N/A')
		  , @Fee_Schedule = ISNULL(convert(nvarchar,SUM(trmt.Fee_Schedule)),'N/A')
		  , @Paid_Amount = ISNULL(convert(nvarchar,SUM(trmt.Paid_Amount)),'N/A') 
		  , @Balance = (isnull(SUM(trmt.Claim_Amount),0) - isnull(SUM(trmt.Paid_Amount),0) - (select ISNULL(sum(Transactions_Amount),0) from tblTransactions tr where (tr.Case_Id=@s_a_Case_Id or tr.Case_Id in (Select Case_Id from tblcase(NOLOCK) cas1 where @PacketId != 0 and cas1.FK_Packet_ID=@PacketId)) and tr.DomainId=@s_a_DomainId and tr.Transactions_Type in ('C','I')))
		  from 
   tblcase cas (NOLOCK) left outer join 
   tblTreatment (NOLOCK) trmt on cas.Case_Id = trmt.Case_Id where (cas.Case_Id = @s_a_Case_Id or (@PacketId != 0 and FK_Packet_ID=@PacketId)) and cas.DomainId = @s_a_DomainId


	 Select 
		 Case_Id
		,FK_Packet_ID
		,PacketID
		, @Claim_Amount as Claim_Amount
		, @Fee_Schedule as Fee_Schedule
		, @Paid_Amount As Paid_Amount
		, ISNULL(convert(nvarchar,@Min_DOS_Start,101),'N/A')[DOS_Start]
        , ISNULL(convert(nvarchar,@Max_DOS_End,101),'N/A') [DOS_End]
		, @Balance as Total_Balance
	  from tblcase c WITH(NOLOCK) inner join tblPacket p WITH(NOLOCK) on p.Packet_Auto_ID=c.FK_Packet_ID
	  where c.DomainId=@s_a_DomainId and c.FK_Packet_ID = @PacketId
	  ORDER BY Case_Id
      OFFSET @i_a_PageSize * (@i_a_PageNumber - 1) ROWS
      FETCH NEXT @i_a_PageSize ROWS ONLY;

	   Select 
		 CEILING(CAST(count(Case_Id) As float)/CAST(@i_a_PageSize As float)) As TotalPages
	  from tblcase c WITH(NOLOCK) inner join tblPacket p WITH(NOLOCK) on p.Packet_Auto_ID=c.FK_Packet_ID
	  where c.DomainId=@s_a_DomainId and c.FK_Packet_ID = @PacketId

   END

END
