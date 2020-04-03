
CREATE Proc UpdateCaseID-- UpdateCaseID @DomainID='JL'
@DomainID varchar(50)
as
begin	
	
		DECLARE @MaxCase_ID VARCHAR(100)
		DECLARE @MaxCaseAuto_ID INT
		DECLARE @AtlasJLCaseID VARCHAR(50)
		--DECLARE @DOMAINID VARCHAR(100)
		--set @DOMAINID='JL'
		DECLARE @TotalCount INT = 0
		DECLARE @Counter INT = 1

		select distinct   caseid,AtlasCaseID into #tempCases FROM [XN_TEMP_GBB_ALL_RFA_JL] t(NOLOCK)
		where AtlasCaseID like 'ACT%' and  AtlasCaseID not in('ACT-JL-107386',
		'ACT-JL-107181',
		'ACT-JL-106090',
		'ACT-JL-106091',
		'ACT-JL-106606',
		'ACT-JL-106661',
		'ACT-JL-106648',
		'ACT-JL-108385',
		'ACT-JL-108386',
		'ACT-JL-107972',
		'ACT-JL-107924',
		'ACT-JL-107676',
		'ACT-JL-107629',
		'ACT-JL-107630',
		'ACT-JL-107559',
		'ACT-JL-107036',
		'ACT-JL-108048',
		'ACT-JL-108039',
		'ACT-JL-107806',
		'ACT-JL-107300',
		'ACT-JL-107498',
		'ACT-JL-107433',
		'ACT-JL-107328',
		'ACT-JL-107323',
		'ACT-JL-107253',
		'ACT-JL-107223',
		'ACT-JL-107188',
		'ACT-JL-107187',
		'ACT-JL-108597',
		'ACT-JL-108509',
		'ACT-JL-108508',
		'ACT-JL-108498',
		'ACT-JL-106677',
		'ACT-JL-106674',
		'ACT-JL-106670',
		'ACT-JL-106636',
		'ACT-JL-106615',
		'ACT-JL-107079',
		'ACT-JL-107045',
		'ACT-JL-106965',
		'ACT-JL-106949',
		'ACT-JL-106869',
		'ACT-JL-106837',
		'ACT-JL-106786',
		'ACT-JL-106774',
		'ACT-JL-108357',
		'ACT-JL-108345',
		'ACT-JL-108342',
		'ACT-JL-108296',
		'ACT-JL-108264',
		'ACT-JL-108216',
		'ACT-JL-108134',
		'ACT-JL-108114',
		'ACT-JL-107983',
		'ACT-JL-107947',
		'ACT-JL-107897',
		'ACT-JL-107786',
		'ACT-JL-107777',
		'ACT-JL-107698',
		'ACT-JL-107643',
		'ACT-JL-107170',
		'ACT-JL-107144',
		'ACT-JL-107107',
		'ACT-JL-107091',
		'ACT-JL-107237',
		'ACT-JL-106583',
		'ACT-JL-106107',
		'ACT-JL-106183',
		'ACT-JL-106098',
		'ACT-JL-107373',
		'ACT-JL-106781',
		'ACT-JL-107028',
		'ACT-JL-107003',
		'ACT-JL-106994',
		'ACT-JL-106771',
		'ACT-JL-106730',
		'ACT-JL-106729',
		'ACT-JL-107071',
		'ACT-JL-107975',
		'ACT-JL-107975',
		'ACT-JL-107556',
		'ACT-JL-107534',
		'ACT-JL-107528',
		'ACT-JL-107520',
		'ACT-JL-107506',
		'ACT-JL-107260',
		'ACT-JL-107100',
		'ACT-JL-106781',
		'ACT-JL-106874',
		'ACT-JL-107180',
		'ACT-JL-107397',
		'ACT-JL-108559',
		'ACT-JL-106828',
		'ACT-JL-107428',
		'ACT-JL-107291',
		'ACT-JL-107373',
		'ACT-JL-106183',
		'ACT-JL-106098',
		'ACT-JL-108154',
		'ACT-JL-108155',
		'ACT-JL-106983',
		'ACT-JL-107490',
		'ACT-JL-107489',
		'ACT-JL-106859',
		'ACT-JL-108087',
		'ACT-JL-106612',
		'ACT-JL-108372',
		'ACT-JL-107194',
		'ACT-JL-107830',
		'ACT-JL-107831',
		'ACT-JL-107829',
		'ACT-JL-108585',
		'ACT-JL-106665',
		'ACT-JL-107028',
		'ACT-JL-107029',
		'ACT-JL-107336',
		'ACT-JL-107846',
		'ACT-JL-106583',
		'ACT-JL-106583',
		'ACT-JL-108064',
		'ACT-JL-108140',
		'ACT-JL-106816',
		'ACT-JL-107996',
		'ACT-JL-106681',
		'ACT-JL-106618',
		'ACT-JL-107534',
		'ACT-JL-108460',
		'ACT-JL-106610',
		'ACT-JL-108491',
		'ACT-JL-107162',
		'ACT-JL-106626',
		'ACT-JL-107339',
		'ACT-JL-107024',
		'ACT-JL-108220',
		'ACT-JL-107019',
		'ACT-JL-107685',
		'ACT-JL-108225',
		'ACT-JL-108266',
		'ACT-JL-107229',
		'ACT-JL-107238',
		'ACT-JL-107453',
		'ACT-JL-107879',
		'ACT-JL-107170',
		'ACT-JL-107307',
		'ACT-JL-107597',
		'ACT-JL-106619',
		'ACT-JL-107911',
		'ACT-JL-106982',
		'ACT-JL-107474',
		'ACT-JL-107473',
		'ACT-JL-108311',
		'ACT-JL-108199',
		'ACT-JL-108200',
		'ACT-JL-106977',
		'ACT-JL-106841',
		'ACT-JL-107865',
		'ACT-JL-106805',
		'ACT-JL-107195',
		'ACT-JL-107750',
		'ACT-JL-106594',
		'ACT-JL-107585',
		'ACT-JL-107125',
		'ACT-JL-106937',
		'ACT-JL-106938',
		'ACT-JL-106729',
		'ACT-JL-107835',
		'ACT-JL-107494',
		'ACT-JL-107495',
		'ACT-JL-107388',
		'ACT-JL-108588',
		'ACT-JL-108587',
		'ACT-JL-108010',
		'ACT-JL-108011',
		'ACT-JL-107522',
		'ACT-JL-107627',
		'ACT-JL-107656',
		'ACT-JL-107955',
		'ACT-JL-108080',
		'ACT-JL-107341',
		'ACT-JL-108474',
		'ACT-JL-106809',
		'ACT-JL-107393',
		'ACT-JL-106628',
		'ACT-JL-107774',
		'ACT-JL-108219',
		'ACT-JL-107080',
		'ACT-JL-108351',
		'ACT-JL-107370',
		'ACT-JL-107623',
		'ACT-JL-107845',
		'ACT-JL-106574',
		'ACT-JL-107382',
		'ACT-JL-107871',
		'ACT-JL-108419',
		'ACT-JL-108350',
		'ACT-JL-106711',
		'ACT-JL-108477',
		'ACT-JL-108529',
		'ACT-JL-107925',
		'ACT-JL-107978',
		'ACT-JL-106745',
		'ACT-JL-106580',
		'ACT-JL-106557',
		'ACT-JL-108085',
		'ACT-JL-107659',
		'ACT-JL-107956',
		'ACT-JL-106620',
		'ACT-JL-107231',
		'ACT-JL-107780',
		'ACT-JL-106789',
		'ACT-JL-106577',
		'ACT-JL-106875',
		'ACT-JL-107842',
		'ACT-JL-107230',
		'ACT-JL-107878',
		'ACT-JL-107346',
		'ACT-JL-106686',
		'ACT-JL-108365',
		'ACT-JL-107318',
		'ACT-JL-107461',
		'ACT-JL-106721',
		'ACT-JL-107219',
		'ACT-JL-107545',
		'ACT-JL-107945',
		'ACT-JL-106592',
		'ACT-JL-106559',
		'ACT-JL-106601',
		'ACT-JL-107483',
		'ACT-JL-106955',
		'ACT-JL-106637',
		'ACT-JL-106931',
		'ACT-JL-106107',
		'ACT-JL-107429',
		'ACT-JL-107003',
		'ACT-JL-107002',
		'ACT-JL-108447',
		'ACT-JL-106858',
		'ACT-JL-107136',
		'ACT-JL-106914',
		'ACT-JL-107986',
		'ACT-JL-107987',
		'ACT-JL-108090',
		'ACT-JL-106940',
		'ACT-JL-107927',
		'ACT-JL-107311',
		'ACT-JL-107115',
		'ACT-JL-107160',
		'ACT-JL-107867',
		'ACT-JL-106748',
		'ACT-JL-107520',
		'ACT-JL-107519',
		'ACT-JL-107715',
		'ACT-JL-107714',
		'ACT-JL-107958',
		'ACT-JL-108183',
		'ACT-JL-107128',
		'ACT-JL-107129',
		'ACT-JL-107173',
		'ACT-JL-108320',
		'ACT-JL-107759',
		'ACT-JL-108391',
		'ACT-JL-108390',
		'ACT-JL-108135',
		'ACT-JL-106924',
		'ACT-JL-106994',
		'ACT-JL-106993',
		'ACT-JL-106730',
		'ACT-JL-108112',
		'ACT-JL-106795',
		'ACT-JL-107464',
		'ACT-JL-108221',
		'ACT-JL-108235',
		'ACT-JL-108236',
		'ACT-JL-108201',
		'ACT-JL-106847',
		'ACT-JL-108546',
		'ACT-JL-108306',
		'ACT-JL-108530',
		'ACT-JL-106688',
		'ACT-JL-107772',
		'ACT-JL-106771',
		'ACT-JL-106824',
		'ACT-JL-108172',
		'ACT-JL-108173',
		'ACT-JL-108581',
		'ACT-JL-107185',
		'ACT-JL-106737',
		'ACT-JL-106738',
		'ACT-JL-106904',
		'ACT-JL-107054',
		'ACT-JL-107053',
		'ACT-JL-106093',
		'ACT-JL-107396',
		'ACT-JL-108189',
		'ACT-JL-108570',
		'ACT-JL-107264',
		'ACT-JL-108347',
		'ACT-JL-107367',
		'ACT-JL-108610',
		'ACT-JL-107090',
		'ACT-JL-108058',
		'ACT-JL-107066',
		'ACT-JL-107556',
		'ACT-JL-108583',
		'ACT-JL-107067',
		'ACT-JL-108271',
		'ACT-JL-108038',
		'ACT-JL-106718',
		'ACT-JL-107525',
		'ACT-JL-107526',
		'ACT-JL-108251',
		'ACT-JL-107326',
		'ACT-JL-106804',
		'ACT-JL-108387',
		'ACT-JL-107313',
		'ACT-JL-108607',
		'ACT-JL-108606',
		'ACT-JL-108094',
		'ACT-JL-108093',
		'ACT-JL-108452',
		'ACT-JL-107246',
		'ACT-JL-107644',
		'ACT-JL-107164',
		'ACT-JL-106792',
		'ACT-JL-107826',
		'ACT-JL-107510',
		'ACT-JL-108215',
		'ACT-JL-107243',
		'ACT-JL-106967',
		'ACT-JL-106632',
		'ACT-JL-106719',
		'ACT-JL-107719',
		'ACT-JL-107718',
		'ACT-JL-106902',
		'ACT-JL-108455',
		'ACT-JL-106631',
		'ACT-JL-108464',
		'ACT-JL-108465',
		'ACT-JL-108441',
		'ACT-JL-108443',
		'ACT-JL-108442',
		'ACT-JL-108195',
		'ACT-JL-108505',
		'ACT-JL-106817',
		'ACT-JL-108609',
		'ACT-JL-107280',
		'ACT-JL-106926',
		'ACT-JL-107486',
		'ACT-JL-107487',
		'ACT-JL-108338',
		'ACT-JL-108341',
		'ACT-JL-106878',
		'ACT-JL-108046',
		'ACT-JL-107646',
		'ACT-JL-106813',
		'ACT-JL-108352',
		'ACT-JL-108492',
		'ACT-JL-107342',
		'ACT-JL-108402',
		'ACT-JL-107598'
		)
		and  isnull(AtlasCaseID,'')<>''
		--select * from #tempCases
		select  ROW_NUMBER() OVER (
		ORDER BY caseid
		) row_num,caseid,AtlasCaseID  into #tempCasesNew from #tempCases
		where  AtlasCaseID not in(select NEW_ID from ChangedCaseID)
      -- select * from #tempCasesNew
		select @TotalCount=count(*) from #tempCasesNew
		

		WHILE (@Counter <= @TotalCount)
		BEGIN

		

		DECLARE @caseid VARCHAR(50)
		DECLARE @AtlasCaseID VARCHAR(100)
		select @caseid=caseid,@AtlasCaseID=AtlasCaseID from #tempCasesNew
		where row_num=@Counter


					SET @MaxCaseAuto_ID = (
							SELECT max(convert(int,RIGHT(Case_ID, LEN(Case_ID) - 5)))+1
								FROM tblCase(NOLOCK)
								WHERE DomainId = @DomainID
									AND Case_ID NOT LIKE 'ACT%'
							)
					SET @AtlasJLCaseID = UPPER(@DomainID) + RIGHT(CAST(DATEPART(year, GETDATE()) AS NVARCHAR), 2) + '-' + CAST(@MaxCaseAuto_ID AS NVARCHAR)

				print @AtlasJLCaseID

				set @Counter=@Counter+1
				insert into ChangedCaseID values (@AtlasCaseID,@AtlasJLCaseID)
				BEGIN TRY
				BEGIN TRANSACTION
				update tblcase set case_id=@AtlasJLCaseID where case_id=@AtlasCaseID and DomainId=@DomainID
				update TXN_VERIFICATION_REQUEST set SZ_CASE_ID=@AtlasJLCaseID where SZ_CASE_ID=@AtlasCaseID and DomainId=@DomainID
				update tblTreatment set case_id=@AtlasJLCaseID where case_id=@AtlasCaseID and DomainId=@DomainID
				update tblCase_Date_Details set case_id=@AtlasJLCaseID where case_id=@AtlasCaseID and DomainId=@DomainID
				update tblCase_additional_info set case_id=@AtlasJLCaseID where case_id=@AtlasCaseID and DomainId=@DomainID
				update tblTransactions set case_id=@AtlasJLCaseID where case_id=@AtlasCaseID and DomainId=@DomainID
				update tblSettlements set case_id=@AtlasJLCaseID where case_id=@AtlasCaseID and DomainId=@DomainID

				update [XN_TEMP_GBB_ALL_RFA_JL] set AtlasCaseID=@AtlasJLCaseID where caseid= @caseid and  AtlasCaseID=@AtlasCaseID and DomainId=@DomainID
				update tblNotes set  case_id=@AtlasJLCaseID where case_id=@AtlasCaseID and DomainId=@DomainID
				update tblTags set  NodeName=@AtlasJLCaseID where NodeName=@AtlasCaseID and DomainId=@DomainID
				update tblTags set  CaseID=@AtlasJLCaseID where CaseID=@AtlasCaseID and DomainId=@DomainID
				COMMIT TRANSACTION
				END TRY
				BEGIN CATCH
					ROLLBACK TRANSACTION

					PRINT '43'

					DECLARE @ErrorMessage VARCHAR(max)
					DECLARE @LogDescription VARCHAR(max)

					SET @ErrorMessage = ERROR_MESSAGE()
					SET @LogDescription = 'Exception : ' + @ErrorMessage

					INSERT INTO [dbo].[tblRFA_JL_LOGS] ([Description])
					VALUES (@LogDescription)

					RAISERROR (
							@ErrorMessage
							,16
							,1
							)
				END CATCh
		END

			
		drop table #tempCasesNew
		drop table #tempCases

END
