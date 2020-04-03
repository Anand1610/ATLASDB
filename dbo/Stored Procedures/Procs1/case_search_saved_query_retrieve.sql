CREATE PROCEDURE [dbo].[case_search_saved_query_retrieve] -- [case_search_saved_query_retrieve] 'localhost',1111
(
	@DomainID		VARCHAR(100),
	@i_a_fk_user_id	INT = 1
)
AS
BEGIN
	SELECT
		ROW_NUMBER() OVER (ORDER BY pk_search_query_id) As s_no,
		pk_search_query_id,
		query.domainid,
		column_value,
		column_name,
		query_name,
		userid,
		modified_userid,
		create_date=CONVERT(VARCHAR,create_date,101),
		modified_date=CONVERT(VARCHAR,modified_date,101),
		providersel,
		insurancesel,
		currentstatussel,
		initialstatussel,
		case_id,
		oldcaseid,
		injuredname,
		insuredname,
		policyno,
		claimno,
		billnumber,
		indexoraaano,
		denailreasonid,
		courtsel,
		defendantsel,
		reviewingdoctor,
		providergroupsel,
		insurancegroupsel,
		date_opened_from,
		date_opened_to,
		dos_from,
		dos_to,
		date_status_changed_from,
		date_status_changed_to,
		Final_Status,
		forum,
		injuredfirstname,
		injuredlastname,
		insuredfirstname,
		insuredlastname,
		packetid,
		adjusterfirstname,
		adjusterlastname,
		accidentdate,
		accountno,
		checknumber,
		paymentdatefrom,
		paymentdateto,
		filledunfiled,
		specialityid,
		attorneyfirmid,
		rebuttalstatusid,
		casetypeid,
		locationid,
		PortfolioId [PortfolioName],
		--PF.Name PortfolioName ,
		Date_AAA_Arb_Filed,
		Date_BillSent,
		Packet_Indicator
	FROM
		case_search_saved_query query

		--left join tbl_portfolio PF (NOLOCK)on query.PortfolioId=PF.id
	WHERE 
		query.domainid	=	@DomainID AND 
		UserID		=	@i_a_fk_user_id
	ORDER BY
		pk_search_query_id ASC
END
