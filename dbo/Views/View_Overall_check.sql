CREATE VIEW [dbo].[View_Overall_check]
AS
SELECT     SUM(CONVERT(MONEY, dbo.tblcase.Claim_Amount) - CONVERT(MONEY, dbo.tblcase.Paid_Amount)) AS BALANCE, 
                      SUM(dbo.[SJR-SETTLEMENTS].Sett_tot) AS SETTL, SUM(dbo.[SJR-SETTLED_PAYMENTS].Payments) AS PAY, SUM(dbo.[SJR-SETTLEMENTS].Sett_tot) 
                      - SUM(dbo.[SJR-SETTLED_PAYMENTS].Payments) AS BAL, SUM(dbo.[SJR-SETTLED_PAYMENTS].Payments) / SUM(dbo.[SJR-SETTLEMENTS].Sett_tot) 
                      * 100 AS R, SUM(CONVERT(MONEY, dbo.tblcase.Claim_Amount) - CONVERT(MONEY, dbo.tblcase.Paid_Amount) - dbo.[SJR-SETTLEMENTS].Sett_tot) 
                      AS Expr1
FROM         dbo.tblcase LEFT OUTER JOIN
                      dbo.[SJR-SETTLEMENTS] ON dbo.tblcase.Case_Id = dbo.[SJR-SETTLEMENTS].Case_Id LEFT OUTER JOIN
                      dbo.[SJR-SETTLED_PAYMENTS] ON dbo.tblcase.Case_Id = dbo.[SJR-SETTLED_PAYMENTS].Case_Id

GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[41] 4[27] 2[14] 3) )"
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
               Top = 23
               Left = 348
               Bottom = 226
               Right = 622
            End
            DisplayFlags = 280
            TopColumn = 53
         End
         Begin Table = "SJR-SETTLEMENTS"
            Begin Extent = 
               Top = 13
               Left = 675
               Bottom = 98
               Right = 827
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "SJR-SETTLED_PAYMENTS"
            Begin Extent = 
               Top = 60
               Left = 98
               Bottom = 145
               Right = 250
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
      Begin ColumnWidths = 9
         Width = 284
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
         Column = 8055
         Alias = 1065
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 1350
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View_Overall_check';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'VIEW', @level1name = N'View_Overall_check';

