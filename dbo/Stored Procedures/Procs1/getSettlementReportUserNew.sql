/*  Created by : Deepak VDescription : New SPDate: 4/24/2020Last Change By: Deepak V*/
CREATE PROCEDURE [dbo].[getSettlementReportUserNew]--[getSettlementReportUser] 'AF','07/12/2019','11/21/2019','jescobar',0
(
	@DomainId NVARCHAR(50),
	@dt1 varchar(50),
	@dt2 varchar(50),
	--@user_id varchar(100),
	@setdisp int
)
as
begin
SET NOCOUNT ON
	declare
	@user_id varchar(200),
	@insid int,
	@iname varchar(200),
	@cnt int,
	@bal money,
	@bal_fs money,
	@setamt money,
	@setint money,
	@setff money,
	@setaf money,
	@settot money,
	@setper float,
	@FeeSchedule money,
	@setper_fs float,
	@Settlement_Type varchar(100),
	@Collection_fee money

	set @cnt = 0 
	set @bal = 0
	SET @bal_fs = 0
	set @setper = 0
	SET @setper_fs =0


	create table #temp(
	user_id varchar(200),
	InsuranceCompany_Id int,
	InsuranceCompany_Name varchar(200),
	cnt int,
	balance money,
	sett_amt_total money,
	sett_int_total money,
	sett_ff_total money,
	sett_af_total money,
	total money,
	setper float,
	balance_fs money,
	setper_fs float,
	Settlement_Type varchar(100),
	Collection_fee money
	)

	CREATE TABLE #userIdList
	(
		UserId VARCHAR(100)
	)
	INSERT INTO #userIdList
	select distinct user_id
	from tblsettlements
	where CAST(FLOOR(CAST(settlement_date AS FLOAT))AS DATETIME) >= @dt1 
	and CAST(FLOOR(CAST(settlement_date AS FLOAT))AS DATETIME) <= @dt2 
	and settlement_total > 0 and DomainId= @DomainId

	declare
	mycur cursor local for

	select distinct
	s.User_Id,
	i.InsuranceCompany_Id,
	insurancecompany_name,
	isnull(sum(settlement_amount),0.00),
	isnull(sum(settlement_int),0.00),
	isnull(sum(settlement_ff),0.00),
	isnull(sum(settlement_af),0.00),
	isnull(sum(settlement_total),0.00),
	isnull (sum(Fee_Schedule),0.00),
	isnull(Settlement_Type,''),
	isnull(sum(Provider_Billing*Settlement_Amount/100),0.00) as Collection_fee
	from tblSettlements s  inner join tblcase c on c.case_id=s.Case_Id
	left outer join tblInsuranceCompany i on i.InsuranceCompany_Id=c.InsuranceCompany_Id
	left outer join tblSettlement_Type ts on ts.SettlementType_Id=s.Settled_Type
	left outer join tblProvider p on p.Provider_Id = c.Provider_Id 
	WHERE CAST(FLOOR(CAST(settlement_date AS FLOAT))AS DATETIME) >= @dt1 
	and CAST(FLOOR(CAST(settlement_date AS FLOAT))AS DATETIME) <= @dt2
	and User_id IN (SELECT UserId FROM #userIdList)
	and settlement_amount > 0 
	and s.DomainId = @DomainId
	and ISNULL(c.IsDeleted,0) = 0
	group by insurancecompany_name,i.insurancecompany_id,Settlement_Type,s.User_Id
	order by insurancecompany_name

	open mycur
	fetch next from mycur into @user_id,@insid,@iname,@setamt,@setint,@setff,@setaf,@settot,@FeeSchedule,@Settlement_Type,@Collection_fee
	while @@fetch_status=0
	begin

	select 
		@cnt = count(case_id) 
	from 
		tblcase a 
	where case_id  in 
			(select case_id from tblsettlements 
			LEFT OUTER JOIN dbo.tblSettlement_Type on dbo.tblSettlements.Settled_Type = dbo.tblSettlement_Type.SettlementType_Id
			where  isnull(Settlement_Type,'')=@Settlement_Type AND
			CAST(FLOOR(CAST(settlement_date AS FLOAT))AS DATETIME) >= @dt1 
			and CAST(FLOOR(CAST(settlement_date AS FLOAT))AS DATETIME) <= @dt2
			and User_id = @user_id
			and settlement_amount > 0 
			and dbo.tblSettlements.DomainId=@DomainId
			) and insurancecompany_id = @insid and DomainId=@DomainId and ISNULL(IsDeleted,0) = 0

	select @bal = isnull(sum(convert(money,claim_amount)-convert(money,paid_amount)),0.00) 
	from tblcase a 
	where case_id  in (select case_id 
						from tblsettlements 
						LEFT OUTER JOIN dbo.tblSettlement_Type on dbo.tblSettlements.Settled_Type = dbo.tblSettlement_Type.SettlementType_Id
						where  isnull(Settlement_Type,'')=@Settlement_Type AND
						CAST(FLOOR(CAST(settlement_date AS FLOAT))AS DATETIME) >= @dt1 
						and CAST(FLOOR(CAST(settlement_date AS FLOAT))AS DATETIME) <= @dt2
						and User_id = @user_id
						and settlement_amount > 0 
						and tblSettlements.DomainId=@DomainId
	) and insurancecompany_id = @insid and a.DomainId=@DomainId and ISNULL(IsDeleted,0) = 0
	
	
	select @bal_fs = isnull(sum(convert(money,Fee_Schedule)-convert(money,paid_amount)),0.00) from tblcase a 
	where case_id  in (select case_id 
						from tblsettlements 
					LEFT OUTER JOIN dbo.tblSettlement_Type on dbo.tblSettlements.Settled_Type = dbo.tblSettlement_Type.SettlementType_Id
					where  isnull(Settlement_Type,'')=@Settlement_Type AND 
					CAST(FLOOR(CAST(settlement_date AS FLOAT))AS DATETIME) >= @dt1 
					and CAST(FLOOR(CAST(settlement_date AS FLOAT))AS DATETIME) <= @dt2
					and User_id = @user_id
					and settlement_amount > 0 
					and dbo.tblSettlements.DomainId=@DomainId
	) and insurancecompany_id = @insid and DomainId=@DomainId and ISNULL(IsDeleted,0) = 0

	select @setper = CASE 
         WHEN @bal = 0.00 THEN 0
         ELSE (@setamt + @setint) * 100 / isnull(@bal,1.00)
        END
        
    select @setper_fs = CASE 
         WHEN @bal_fs = 0.00 THEN 0
         ELSE (@setamt + @setint) * 100 / isnull(@bal_fs,1.00)
        END

	insert into #temp
	select @user_id,@insid,@iname,@cnt,@bal,@setamt,@setint,@setff,@setaf,@settot,@setper,@bal_fs,@setper_fs,@Settlement_Type,@Collection_fee

	set @cnt = 0
	set @bal = 0
	set @bal_fs = 0
	set @setper = 0
	set @setper_fs =0

	fetch next from mycur into @user_id,@insid,@iname,@setamt,@setint,@setff,@setaf,@settot,@FeeSchedule, @Settlement_Type,@Collection_fee
	end
	close mycur
	deallocate mycur

	if @setdisp = 0
	select * from #temp
	if @setdisp = 1
	select * from #temp where setper <= 0
	if @setdisp = 2
	select * from #temp where setper > 0 and setper < 70
	if @setdisp = 3
	select * from #temp where setper > 70 

	drop table #temp
	DROP TABLE #userIdList

end