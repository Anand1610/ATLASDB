CREATE TABLE [dbo].[JL_Not_In_System] (
    [Client_Id]          NVARCHAR (255) NULL,
    [Client_Name]        NVARCHAR (255) NULL,
    [Bill_Id]            NVARCHAR (255) NULL,
    [Bill_Mailed_On]     NVARCHAR (255) NULL,
    [Billed_Amt]         FLOAT (53)     NULL,
    [Paid_Amt]           FLOAT (53)     NULL,
    [Balance]            FLOAT (53)     NULL,
    [Doctor_Name]        NVARCHAR (255) NULL,
    [Office_Name]        NVARCHAR (255) NULL,
    [Service_Date_Start] NVARCHAR (255) NULL,
    [Service_Date_End]   NVARCHAR (255) NULL
);

