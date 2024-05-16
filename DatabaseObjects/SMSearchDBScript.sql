USE [master]
GO
CREATE DATABASE [SMSearchDB]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'SMSearchDB', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SHADHINSERVER\MSSQL\DATA\SMSearchDB.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'SMSearchDB_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.SHADHINSERVER\MSSQL\DATA\SMSearchDB_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT
GO
ALTER DATABASE [SMSearchDB] SET COMPATIBILITY_LEVEL = 150
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [SMSearchDB].[dbo].[sp_fulltext_database] @action = 'enable'
end

GO

USE [SMSearchDB]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SMSearchLog](
	[SearchId] [uniqueidentifier] NOT NULL,
	[UserName] [nvarchar](max) NULL,
	[DateSearched] [datetime2](7) NOT NULL,
	[SearchText] [nvarchar](max) NULL,
 CONSTRAINT [PK_SMSearchLog] PRIMARY KEY CLUSTERED 
(
	[SearchId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[tbl_UserSearchHistory](
	[Id] [uniqueidentifier] NOT NULL,
	[UserCode] [varchar](100) NULL,
	[ContentId] [varchar](50) NULL,
	[Type] [varchar](10) NULL,
	[CreateDate] [datetime] NOT NULL,
	[IsDeleted] [bit] NULL,
	[TrackType] [varchar](10) NULL,
 CONSTRAINT [PK_tbl_UserSearchHistory_1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[tbl_UserSearchHistory] ADD  CONSTRAINT [DF_tbl_UserSearchHistory_Id]  DEFAULT (newid()) FOR [Id]
GO
USE [master]
GO
ALTER DATABASE [SMSearchDB] SET  READ_WRITE 
GO
