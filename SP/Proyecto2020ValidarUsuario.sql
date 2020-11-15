USE [Proyecto];
GO
DROP PROCEDURE  IF EXISTS dbo.ValidarUsuario;
GO
CREATE PROCEDURE dbo.ValidarUsuario
	@inUsuario VARCHAR(20)
	, @inContraseña VARCHAR(20)
	, @outUsuarioId INT OUTPUT
	, @outResultCode INT OUTPUT
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY

	--Codigo para pruebas
--DECLARE @RC int
--DECLARE @inUsuario varchar(20)
--DECLARE @inContraseña varchar(20)
--DECLARE @outUsuarioId int
--DECLARE @outResultCode int

---- TODO: Set parameter values here.

--EXECUTE @RC = [dbo].[ValidarUsuario] 
--   @inUsuario
--  ,@inContraseña
--  ,@outUsuarioId OUTPUT
--  ,@outResultCode OUTPUT

		--Validaciones
		SELECT @outResultCode = 0

		IF NOT EXISTS (SELECT 1 FROM [dbo].[Usuarios] WHERE Usuario=@inUsuario)
		BEGIN
			SET @outResultCode = 50010 --El usuario no existe
			RETURN
		END

		IF NOT EXISTS (SELECT 1 FROM [dbo].[Usuarios] WHERE Contraseña=@inContraseña)
		BEGIN
			SET @outResultCode = 50011 --Contraseña invalidad
			RETURN
		END
		--Mapeo con llave no primaria
		DECLARE
			@UsuarioId INT

		SELECT @UsuarioId = U.Id
		FROM [dbo].[Usuarios] U
		WHERE U.Usuario = @inUsuario
			

		SET @outUsuarioId = @UsuarioId;
	END TRY

	BEGIN CATCH

	END CATCH
SET NOCOUNT OFF
END
GO