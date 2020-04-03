CREATE FUNCTION [dbo].[SJR-ENTRY_PROD](@START_DATE nvarchar(50),
@END_DATE nvarchar(50),
@USER_ID nvarchar(50) =null)
RETURNS TABLE
AS
RETURN ( SELECT     CONVERT(DATETIME, CONVERT(char(12), tblcase.Date_Opened, 1)) AS Date, COUNT(DISTINCT tblcase.Case_Id) AS Cases, 
                      COUNT(DISTINCT tblTreatment.Treatment_Id) AS Bills, SUM(DISTINCT CONVERT(money, ISNULL(tblTreatment.Claim_Amount, 0)) - CONVERT(money, 
                      ISNULL(tblTreatment.Paid_Amount, 0))) AS BALANCE, (COUNT(DISTINCT tblcase.Case_Id) * 250 + COUNT(DISTINCT tblTreatment.Treatment_Id) * 60) 
                      * 1.3 / 3600 AS Productive_hours, (COUNT(DISTINCT tblcase.Case_Id) * 250 + COUNT(DISTINCT tblTreatment.Treatment_Id) * 60) 
                      * 1.3 / 3600 / 7 AS EFFICIENCY, CASE WHEN LEFT(dbo.tblNotes.User_Id, 3) = 'la-' THEN 'LAW ALLIES' ELSE dbo.tblNotes.User_Id END AS USER_ID, 
                      ((COUNT(DISTINCT tblcase.Case_Id) * 4 + COUNT(DISTINCT tblTreatment.Treatment_Id)) * SUM(DISTINCT CONVERT(money, 
                      ISNULL(tblTreatment.Claim_Amount, 0)) - CONVERT(money, ISNULL(tblTreatment.Paid_Amount, 0)))) / ((DATEDIFF(d, @start_date, @end_date) + 1) 
                      * 10000) AS EFF_INDEX
FROM         tblcase INNER JOIN
                      tblNotes ON tblcase.Case_Id = tblNotes.Case_Id LEFT OUTER JOIN
                      tblTreatment ON tblcase.Case_Id = tblTreatment.Case_Id
GROUP BY CONVERT(DATETIME, CONVERT(char(12), tblcase.Date_Opened, 1)), tblNotes.Notes_Desc, tblNotes.User_Id
HAVING      (tblNotes.Notes_Desc = N'CASE OPENED') AND (CONVERT(DATETIME, CONVERT(char(12), tblcase.Date_Opened, 1)) BETWEEN @START_DATE AND 
                      @END_DATE) AND (tblNotes.User_Id LIKE '%' + ISNULL(@USER_ID, N'') + '%'))

GO
EXECUTE sp_addextendedproperty @name = N'MS_DefaultView', @value = 0x02, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'FUNCTION', @level1name = N'SJR-ENTRY_PROD';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPane1', @value = N'[0E232FF0-B466-11cf-A24F-00AA00A3EFFF, 1.00]
Begin DesignProperties = 
   Begin PaneConfigurations = 
      Begin PaneConfiguration = 0
         NumPanes = 4
         Configuration = "(H (1[40] 4[20] 2[20] 3) )"
      End
      Begin PaneConfiguration = 1
         NumPanes = 3
         Configuration = "(H (1[50] 4[25] 3) )"
      End
      Begin PaneConfiguration = 2
         NumPanes = 3
         Configuration = "(H (1[50] 2[25] 3) )"
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
         Configuration = "(H (1[75] 4) )"
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
      ActivePaneConfig = 8
   End
   Begin DiagramPane = 
      Begin Origin = 
         Top = 0
         Left = 0
      End
      Begin Tables = 
         Begin Table = "tblcase"
            Begin Extent = 
               Top = 6
               Left = 38
               Bottom = 119
               Right = 327
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblTreatment"
            Begin Extent = 
               Top = 6
               Left = 365
               Bottom = 119
               Right = 573
            End
            DisplayFlags = 280
            TopColumn = 0
         End
         Begin Table = "tblNotes"
            Begin Extent = 
               Top = 6
               Left = 611
               Bottom = 119
               Right = 781
            End
            DisplayFlags = 280
            TopColumn = 0
         End
      End
   End
   Begin SQLPane = 
   End
   Begin DataPane = 
      PaneHidden = 
      Begin ParameterDefaults = ""
      End
      RowHeights = 220
   End
   Begin CriteriaPane = 
      Begin ColumnWidths = 12
         Column = 1440
         Alias = 900
         Table = 1170
         Output = 720
         Append = 1400
         NewValue = 1170
         SortType = 1350
         SortOrder = 1410
         GroupBy = 1350
         Filter = 2205
         Or = 1350
         Or = 1350
         Or = 1350
      End
   End
End
', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'FUNCTION', @level1name = N'SJR-ENTRY_PROD';


GO
EXECUTE sp_addextendedproperty @name = N'MS_DiagramPaneCount', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'FUNCTION', @level1name = N'SJR-ENTRY_PROD';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Filter', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'FUNCTION', @level1name = N'SJR-ENTRY_PROD';


GO
EXECUTE sp_addextendedproperty @name = N'MS_FilterOnLoad', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'FUNCTION', @level1name = N'SJR-ENTRY_PROD';


GO
EXECUTE sp_addextendedproperty @name = N'MS_HideNewField', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'FUNCTION', @level1name = N'SJR-ENTRY_PROD';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderBy', @value = NULL, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'FUNCTION', @level1name = N'SJR-ENTRY_PROD';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderByOn', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'FUNCTION', @level1name = N'SJR-ENTRY_PROD';


GO
EXECUTE sp_addextendedproperty @name = N'MS_OrderByOnLoad', @value = 1, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'FUNCTION', @level1name = N'SJR-ENTRY_PROD';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Orientation', @value = 0x00, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'FUNCTION', @level1name = N'SJR-ENTRY_PROD';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TableMaxRecords', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'FUNCTION', @level1name = N'SJR-ENTRY_PROD';


GO
EXECUTE sp_addextendedproperty @name = N'MS_TotalsRow', @value = 0, @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'FUNCTION', @level1name = N'SJR-ENTRY_PROD';

