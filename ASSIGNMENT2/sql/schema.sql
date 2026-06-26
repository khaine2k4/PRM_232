-- Optional manual setup for the SQL Server side.
-- The app creates these automatically via SqlServerService, but you can run
-- this by hand in SSMS / Azure Data Studio if you prefer.

IF DB_ID('Assignment2Todo') IS NULL
    CREATE DATABASE [Assignment2Todo];
GO

USE [Assignment2Todo];
GO

IF OBJECT_ID('dbo.Users', 'U') IS NULL
CREATE TABLE dbo.Users (
    id            NVARCHAR(64)  NOT NULL PRIMARY KEY,
    email         NVARCHAR(256) NOT NULL UNIQUE,
    passwordHash  NVARCHAR(256) NOT NULL,
    displayName   NVARCHAR(256) NULL,
    createdAt     DATETIME2     NOT NULL
);
GO

IF OBJECT_ID('dbo.Tasks', 'U') IS NULL
CREATE TABLE dbo.Tasks (
    id           NVARCHAR(64)  NOT NULL PRIMARY KEY,
    userId       NVARCHAR(64)  NOT NULL,
    title        NVARCHAR(512) NOT NULL,
    description  NVARCHAR(MAX) NULL,
    isCompleted  BIT           NOT NULL DEFAULT 0,
    priority     NVARCHAR(16)  NOT NULL DEFAULT 'low',
    category     NVARCHAR(128) NULL,
    createdAt    DATETIME2     NOT NULL,
    dueDate      DATETIME2     NULL,
    updatedAt    DATETIME2     NOT NULL
);
GO
