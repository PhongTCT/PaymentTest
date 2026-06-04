-- Tạo Database
CREATE DATABASE [PRJ301];
GO

USE [PRJ301-04];
GO

-- Tạo table User
CREATE TABLE [user] (
    [userID]    VARCHAR(50)     NOT NULL,
    [fullName]  NVARCHAR(100)   NOT NULL,
    [password]  VARCHAR(255)    NOT NULL,
    [roleID]    VARCHAR(50)     NOT NULL,
    [status]    BIT             NOT NULL DEFAULT 1,
    CONSTRAINT PK_user PRIMARY KEY ([userID])
);
GO

-- Insert dữ liệu mẫu
INSERT INTO [user] ([userID], [fullName], [password], [roleID], [status]) VALUES
('admin',  N'Administrator', '123456', 'ADMIN', 1),
('user01', N'Nguyen Van A',  '123456', 'USER',  1),
('user02', N'Tran Thi B',    '123456', 'USER',  0);
GO
