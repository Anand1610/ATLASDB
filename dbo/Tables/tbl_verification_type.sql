CREATE TABLE [dbo].[tbl_verification_type] (
    [vr_type_Id]        INT           IDENTITY (1, 1) NOT NULL,
    [verification_type] VARCHAR (150) NULL,
    CONSTRAINT [PK_tbl_verification_type] PRIMARY KEY CLUSTERED ([vr_type_Id] ASC)
);

