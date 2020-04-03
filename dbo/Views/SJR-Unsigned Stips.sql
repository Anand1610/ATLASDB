CREATE VIEW [dbo].[SJR-Unsigned Stips]
AS
SELECT     TOP (100) PERCENT dbo.tblcase.Case_Id, dbo.tblInsuranceCompany.InsuranceCompany_Name, dbo.tblProvider.Provider_Name, dbo.tblcase.Status, 
                      dbo.[SJR-SETTLEMENTS_FULL].Settl_date, dbo.[SJR-SETTLEMENTS_FULL].User_Id AS [Settled By], dbo.[SJR-SETTLEMENTS_FULL].SettledWith, 
                      dbo.tblcase.Ins_Claim_Number, 'P=' + CONVERT(varchar(10), SUM(dbo.[SJR-SETTLEMENTS_FULL].Settlement_Amount)) 
                      + ' \I=' + CONVERT(varchar(10), SUM(dbo.[SJR-SETTLEMENTS_FULL].Settlement_Int)) + ' \AF=' + CONVERT(varchar(10), 
                      SUM(dbo.[SJR-SETTLEMENTS_FULL].Settlement_Af)) + ' \FF=' + CONVERT(varchar(10), SUM(dbo.[SJR-SETTLEMENTS_FULL].Settlement_Ff)) 
                      AS Sett_details, dbo.tblcase.InjuredParty_LastName + N',' + dbo.tblcase.InjuredParty_FirstName AS InjuredParty, 
                      dbo.tblcase.IndexOrAAA_Number
FROM         dbo.tblcase INNER JOIN
                      dbo.tblProvider ON dbo.tblcase.Provider_Id = dbo.tblProvider.Provider_Id INNER JOIN
                      dbo.tblInsuranceCompany ON dbo.tblcase.InsuranceCompany_Id = dbo.tblInsuranceCompany.InsuranceCompany_Id INNER JOIN
                      dbo.[SJR-SETTLEMENTS_FULL] ON dbo.tblcase.Case_Id = dbo.[SJR-SETTLEMENTS_FULL].Case_Id
WHERE     (dbo.tblcase.Case_Id NOT IN
                          (SELECT     dbo.tblImages.Case_Id
                            FROM          dbo.tblImages INNER JOIN
                                                   dbo.tblSettlements ON dbo.tblImages.Case_Id = dbo.tblSettlements.Case_Id
                            WHERE      (dbo.tblImages.DocumentId = '145')
                            GROUP BY dbo.tblImages.Case_Id)) AND (DATEDIFF(d, dbo.[SJR-SETTLEMENTS_FULL].Settl_date, GETDATE()) > 7)
GROUP BY dbo.tblcase.Case_Id, dbo.tblInsuranceCompany.InsuranceCompany_Name, dbo.tblProvider.Provider_Name, dbo.tblcase.Status, 
                      dbo.[SJR-SETTLEMENTS_FULL].Settl_date, dbo.[SJR-SETTLEMENTS_FULL].User_Id, dbo.[SJR-SETTLEMENTS_FULL].SettledWith, 
                      dbo.tblcase.Ins_Claim_Number, dbo.tblcase.InjuredParty_LastName + N',' + dbo.tblcase.InjuredParty_FirstName, 
                      dbo.tblcase.IndexOrAAA_Number
HAVING      (dbo.tblcase.Status IN ('SETTLED', 'collection')) AND (SUM(dbo.[SJR-SETTLEMENTS_FULL].Settlement_Amount) 
                      + SUM(dbo.[SJR-SETTLEMENTS_FULL].Settlement_Int) > 0)
ORDER BY dbo.tblInsuranceCompany.InsuranceCompany_Name

GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[26] 4[15] 2[18] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1 [50] 4 [25] 3))"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1 [50] 2 [25] 3))"
      End
      Begin PaneConfiguration = 3
         NumPanes = 3
         Configuration = "(H (4 [30] 2 [40] 3))"
      End
      Begin PaneConfiguration = 4
         NumPanes = 2
         Configuration = "(H (1 [56] 3))"
      End
      Begin PaneConfiguration = 5
         NumPanes = 2
         Configuration = "(H (2 [66] 3))"
      End
      Begin PaneConfiguration = 6
         NumPanes = 2
         Configuration = "(H (4 [50] 3))"
      End
      Begin PaneConfiguration = 7
         NumPanes = 1
         Configuration = "(V (3))"
      End
      Begin PaneConfiguration = 8
         NumPanes = 3
         Configuration = "(H (1[56] 4[18] 2) )"
      End
      Begin PaneConfiguration = 9
         NumPanes = 2
         Configuration = "(H (1 [75] 4))"
      End
      Begin PaneConfiguration = 10
         NumPanes = 2
         Configuration = "(H (1[66] 2) )"
      End
      Begin PaneConfiguration = 11
         NumPanes = 2
         Configuration = "(H (4 [60] 2))"
      End
      Begin PaneConfiguration = 12
         NumPanes = 1
         Configuration = "(H (1) )"
      End
      Begin PaneConfiguration = 13
         NumPanes = 1
         Configuration = "(V (4))"
      End
      Begin PaneConfiguration = 14
         NumPanes = 1
         Configuration = "(V (2))"
      End
      ActivePaneConfig = 0
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "tblcase"
            Begin Extent = 
               Top = 30
               Left = 303
               Bottom = 145
               Right = 593
            End
            DisplayFlags = 280
            TopColumn = 27
         End
         Begin Table = "tblProvider"
            Begin Extent = 
               Top = 329
               Left = 406
               Bottom = 444
               Right = 618
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblInsuranceCompany"
            Begin Extent = 
               Top = 58
               Left = 0
               Bottom = 173
               Right = 265
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SJR-SETTLEMENTS_FULL"
            Begin Extent = 
               Top = 174
               Left = 38
               Bottom = 282
               Right = 237
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      Begin ParameterDefaults = ""
      End
      Begin ColumnWidths = 15
         Width = 284
         Width = 3165
         Width = 2400
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
         Width = 1500
      End
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 3870
         Alias = 2010
         Table = 2895
         Output = 720
         Append = 1400
         NewValue = 1170
    ', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'SJR-Unsigned Stips';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane2', @value = N'     SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 2295
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'SJR-Unsigned Stips';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 2, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'SJR-Unsigned Stips';

