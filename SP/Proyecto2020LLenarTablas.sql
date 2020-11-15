USE [Proyecto];
GO
DROP PROCEDURE  IF EXISTS dbo.LLenarTablas;
GO
CREATE PROCEDURE dbo.LLenarTablas
AS
BEGIN
SET NOCOUNT ON
	--Se limpian las tablas
	EXEC [dbo].[LimpiarTablas]
	--LLamar SPs de llenado de tablas
	EXEC [dbo].[CargarTipoDoc]
	EXEC [dbo].[CargarTipoMoneda]
	EXEC [dbo].[CargarParentezcos]
	EXEC [dbo].[CargarTipoCuentaAhorro]
	
	EXEC [dbo].[CargarPersonas]
	EXEC [dbo].[CargarCuentaAahorro]
	EXEC [dbo].[CargarBeneficiarios]
	EXEC [dbo].[CargarEstadosDeCuenta]
	EXEC [dbo].[CargarUsuarios]
	EXEC [dbo].[CargarAccesoUsuario]
SET NOCOUNT OFF
END
GO
--EXEC dbo.LLenarTablas
--SELECT * FROM [dbo].[AccesoUsuario]
--SELECT * FROM [dbo].[Usuarios]
--SELECT * FROM [dbo].[EstadoDeCuenta]
--SELECT * FROM [dbo].[Beneficiarios]
--SELECT * FROM [dbo].[CuentaAhorro]
--SELECT * FROM [dbo].[Personas];