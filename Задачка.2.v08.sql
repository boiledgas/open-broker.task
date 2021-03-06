set nocount on
set ansi_nulls on
set quoted_identifier on
go

--/*
------------------------------------------------------------------
-- �������� ���������
------------------------------------------------------------------
if schema_id('Test') is null
  exec('create schema [Test]')
go

if object_id('[Test].[Contracts]') is null
  create table [Test].[Contracts]
  (
    [Id]          int   not null identity(1,1),
    [Type_Id]     int   not null,
    [Client_Id]   int   not null,
    [DateFrom]    date  not null,
    [DateTo]      date      null,
    primary key clustered ([Id])
  )
go

/*
��������! � ������ �������-������� � ������������ �������, ����������, ���� ���.

-----------------------------------------------------
������ 2. ������: v08
-----------------------------------------------------
�������� ������, ������� ������ ������ ���� ��������������� � ��������� ��������
(�.�., ����� ����� ��������� ������ ���� ������� ���� ������� ����) �����
@DateBegin � @DateEnd ������������, ����� � ������� ��� ���� �� ���� �������� ������� ���� @Type_Id.
������, ��� � ������� ����� ���� ��������� ����������� ���������.

��������� ������ ���� ����������� � ��������� ����:
-- Client_Id        -- ������
-- First_Date       -- ���� ������ ������������ ������� �������� ��������(-��) ��������� ����
-- Last_Date        -- ���� ��������� ������������ ������� �������� ��������(-��) ��������� ����

--*/

------------------------------------------------------------------
-- ���������
------------------------------------------------------------------
declare
  @Type_Id    int   = 1,
  @DateBegin  date  = '20000601',
  @DateEnd    date  = '20010131'

------------------------------------------------------------------
-- �������� ������
------------------------------------------------------------------
select [Info] = '�������� ������', * 
from [Test].[Contracts]
where [Type_Id] = @Type_Id

------------------------------------------------------------------
-- ���������
------------------------------------------------------------------
select 
	[Client_Id]        -- ������
	, [First_Date]       -- ���� ������ ������������ ������� �������� ��������(-��) ��������� ����
	, [Last_Date]        -- ���� ��������� ������������ ������� �������� ��������(-��) ��������� ����
