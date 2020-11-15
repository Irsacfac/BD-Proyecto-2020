USE [Proyecto];
GO
DROP PROCEDURE  IF EXISTS dbo.LimpiarTablas;
GO
CREATE PROCEDURE dbo.LimpiarTablas
AS
BEGIN
SET NOCOUNT ON
	--borrando las filas de las tablas
	DELETE [dbo].[AccesoUsuario]
	DELETE [dbo].[Usuarios]
	DELETE [dbo].[EstadoDeCuenta]
	DELETE [dbo].[Beneficiarios]
	DELETE [dbo].[CuentaAhorro]
	DELETE [dbo].[Personas]
	--reiniciar Id
	DBCC CHECKIDENT (AccesoUsuario, RESEED, 0)
	DBCC CHECKIDENT (Usuarios, RESEED, 0)
	DBCC CHECKIDENT (EstadoDeCuenta, RESEED, 0)
	DBCC CHECKIDENT (Beneficiarios, RESEED, 0)
	DBCC CHECKIDENT (CuentaAhorro, RESEED, 0)
	DBCC CHECKIDENT (Personas, RESEED, 0)
SET NOCOUNT OFF
END
GO
--EXEC dbo.LimpiarTablas
--SELECT * FROM [dbo].[AccesoUsuario]
--	, [dbo].[Usuarios]
--	, [dbo].[EstadoDeCuenta]
--	, [dbo].[Beneficiarios]
--	, [dbo].[CuentaAhorro]
--	, [dbo].[Personas];