
CREATE PROCEDURE [dbo].[F_Template_Column_Name_And_Case_Data_OK] -- F_Template_Column_Name_And_Case_Data 'TEST2','0','TEST217-12007'
	@DomainId varchar(50),
	@i_a_type int,
	@s_a_case_id varchar(100)=null
	
AS  
BEGIN	
	DECLARE @tblPacketInfoInOneRow TABLE 
			(
				PACKET_ID VARCHAR(MAX),
				PROVIDER_NAME_ALL VARCHAR(MAX),
				PROVIDER_ADDRESS_ALL VARCHAR(MAX),
				PROVIDER_NAME_1 VARCHAR(MAX),
				BALANCE_1 Float,				 
				DATEOFSERVICE_START_1 VARCHAR(MAX),				
				DATEOFSERVICE_END_1 VARCHAR(MAX),
				PROVIDER_NAME_2 VARCHAR(MAX),
				BALANCE_2 Float,
				DATEOFSERVICE_START_2 VARCHAR(MAX),
				DATEOFSERVICE_END_2 VARCHAR(MAX)
			)

	if(@i_a_type = 0)
	BEGIN	
		DECLARE @Packet_ID VARCHAR(1000) ='TEST2-PKT17-100001' 

		SET @Packet_ID = (SELECT MAX(ISNULL(PacketID,'')) FROM dbo.tblPacket pkt INNER JOIN tblCase cas on pkt.Packet_Auto_ID  = cas.FK_Packet_ID WHERE cas.Case_Id = @s_a_case_id)

		IF @Packet_ID <> ''
		BEGIN

			DECLARE @PROVIDER_NAME_ALL VARCHAR(MAX),
					@PROVIDER_ADDRESS_ALL VARCHAR(MAX),
					@PROVIDER_NAME_1 VARCHAR(MAX),
					@BALANCE_1 Float,
					@DATEOFSERVICE_START_1 VARCHAR(MAX),					
					@DATEOFSERVICE_END_1 VARCHAR(MAX),
					@PROVIDER_NAME_2 VARCHAR(MAX),					 
					@BALANCE_2 FLoat, 					
					@DATEOFSERVICE_START_2 VARCHAR(MAX),
					@DATEOFSERVICE_END_2 VARCHAR(MAX)

			DECLARE @tblPacketCasesAll TABLE 
			( 
				AutoID INT IDENTITY(1,1),
				CASE_ID VARCHAR(MAX),
				PROVIDER_NAME VARCHAR(MAX), 
				BALANCE float, 
				DATEOFSERVICE_START VARCHAR(MAX), 
				DATEOFSERVICE_END VARCHAR(MAX)
			)
			INSERT INTO @tblPacketCasesAll
			SELECT 
				CASE_ID,
				pro.PROVIDER_NAME,
				convert(varchar,(convert(Money, (CONVERT(FLOAT, isnull(cas.CLAIM_AMOUNT,0)) - CONVERT(FLOAT, isnull(cas.PAID_AMOUNT,0)))))) AS BALANCE_AMOUNT,
				CONVERT(NVARCHAR(12),CONVERT(DATETIME, cas.DATEOFSERVICE_START), 101) AS DATEOFSERVICE_START,
				CONVERT(NVARCHAR(12), CONVERT(DATETIME, cas.DATEOFSERVICE_END), 101) AS DATEOFSERVICE_END
			FROM dbo.tblPacket pkt
			INNER JOIN tblCase cas on pkt.Packet_Auto_ID  = cas.FK_Packet_ID
			INNER JOIN DBO.TBLINSURANCECOMPANY ins ON cas.INSURANCECOMPANY_ID = ins.INSURANCECOMPANY_ID 
			INNER JOIN  DBO.TBLPROVIDER pro ON cas.PROVIDER_ID = pro.PROVIDER_ID 
			WHERE PacketID = @Packet_ID

			--SELECT * FROM @tblPacketCasesAll

			
			--*****************************************************--
			SELECT @PROVIDER_NAME_1=PROVIDER_NAME, 
					@BALANCE_1= BALANCE, 
					@DATEOFSERVICE_START_1= DATEOFSERVICE_START,
					@DATEOFSERVICE_END_1=	DATEOFSERVICE_END 
			FROM @tblPacketCasesAll
			WHERE AutoID = 1
			--*****************************************************--
			SELECT @PROVIDER_NAME_2=PROVIDER_NAME, 
					@BALANCE_2= BALANCE, 
					@DATEOFSERVICE_START_2= DATEOFSERVICE_START,
					@DATEOFSERVICE_END_2=	DATEOFSERVICE_END 
			FROM @tblPacketCasesAll
			WHERE AutoID = 2

			--*****************************************************--

			
			
			SELECT 
				@PROVIDER_NAME_ALL = COALESCE(@PROVIDER_NAME_ALL,' ') + Provider_Name + ' and ' ,
				@PROVIDER_ADDRESS_ALL = COALESCE(@PROVIDER_ADDRESS_ALL,'') + Provider_Name+' \line '+Provider_Local_Address+' \line '+Provider_Local_City+' ' + Provider_Local_State+' ' + Provider_Local_Zip + ' \line\line ' 
			FROM dbo.tblPacket pkt
			INNER JOIN tblCase cas on pkt.Packet_Auto_ID  = cas.FK_Packet_ID
			INNER JOIN DBO.TBLINSURANCECOMPANY ins ON cas.INSURANCECOMPANY_ID = ins.INSURANCECOMPANY_ID 
			INNER JOIN  DBO.TBLPROVIDER pro ON cas.PROVIDER_ID = pro.PROVIDER_ID 
			WHERE PacketID = @Packet_ID

			--SET @PROVIDER_NAME_ALL =  LEFT(@PROVIDER_NAME_ALL, LEN(@PROVIDER_NAME_ALL)-4)
			SET @PROVIDER_NAME_ALL =  REPLACE(@PROVIDER_NAME_ALL+ '-','and -','')
			
			--*****************************************************--
			
			INSERT INTO @tblPacketInfoInOneRow (PACKET_ID, PROVIDER_NAME_ALL, PROVIDER_ADDRESS_ALL, 
			PROVIDER_NAME_1, BALANCE_1, DATEOFSERVICE_START_1, DATEOFSERVICE_END_1,
			PROVIDER_NAME_2, BALANCE_2, DATEOFSERVICE_START_2, DATEOFSERVICE_END_2)

			SELECT @PACKET_ID, @PROVIDER_NAME_ALL, @PROVIDER_ADDRESS_ALL,
			@PROVIDER_NAME_1, @BALANCE_1, @DATEOFSERVICE_START_1, @DATEOFSERVICE_END_1,
			@PROVIDER_NAME_2, @BALANCE_2, @DATEOFSERVICE_START_2, @DATEOFSERVICE_END_2
			

			select top 1 *
			from  LCJ_VW_CaseSearchDetails_RTF 
			LEFT OUTER JOIN @tblPacketInfoInOneRow ON PACKETID =PACKET_ID
			where LCJ_VW_CaseSearchDetails_RTF.case_id = @s_a_case_id AND DomainId = @DomainId
		END
		ELSE
			select top 1 *  from  LCJ_VW_CaseSearchDetails_RTF 
			LEFT OUTER JOIN @tblPacketInfoInOneRow ON PACKETID =PACKET_ID
			where LCJ_VW_CaseSearchDetails_RTF.case_id = @s_a_case_id AND DomainId = @DomainId
	END
	ELSE IF(@i_a_type = 1)
	BEGIN
		SELECT UPPER(COLUMN_NAME) AS COLUMN_NAME FROM MST_TEMPLATES_COLUMN
	END

		
		--SELECT TOP 500 UPPER(COLUMN_NAME) COLUMN_NAME FROM INFORMATION_SCHEMA.Columns where TABLE_NAME = 'LCJ_VW_CaseSearchDetails_RTF'
END


