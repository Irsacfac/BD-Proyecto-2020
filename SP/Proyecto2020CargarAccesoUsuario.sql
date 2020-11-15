USE [Proyecto];
GO
DROP PROCEDURE  IF EXISTS dbo.CargarAccesoUsuario;
GO
CREATE PROCEDURE dbo.CargarAccesoUsuario
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		DECLARE
			@tipo_Documento XML = NULL
			, @doc INT = 0
			--Tabla variable
		DECLARE 
			@VariableTabla TABLE (Sec INT IDENTITY(1,1), Usuario VARCHAR(20), NumeroCuenta INT)
		--Cargar datos a la tabla variable
		SELECT @tipo_Documento = od	FROM OPENROWSET (BULK 'D:\S3\Proyecto2020\Datos_Tarea1 v2.1.xml', SINGLE_BLOB) AS TiposDoc(od) --pone la direccion donde se encuentra
		EXEC sp_xml_preparedocument @doc OUTPUT, @tipo_Documento
		INSERT INTO @VariableTabla(Usuario
								, NumeroCuenta
								)				--selecciona la tabla a llenar y las columnas 
		SELECT * FROM OPENXML (@doc, 'Datos/Usuarios_Ver/UsuarioPuedeVer')						--encabezado a buscar
		WITH( Usuario [VARCHAR](20)'@User'
			, NumeroCuenta [INT]'@NumeroCuenta'
			);						--Se ingresan los datos a la tabla variable
		
		--Pasar datos de la tabla variable a la tabla Usuarios
		DECLARE 
			@lo1 INT
			, @hi1 INT
			, @Usuario VARCHAR(20)
			, @NumCuenta INT
			, @UsuarioId INT
			, @CuentaAhorroId INT;
		SELECT @lo1=MIN(Sec), @hi1=MAX(Sec)
		FROM @VariableTabla
		WHILE @lo1<=@hi1
		BEGIN
			SELECT
				@Usuario = VT.Usuario
				, @NumCuenta = VT.NumeroCuenta
			FROM @VariableTabla VT
			WHERE Sec = @lo1
			
			SELECT @UsuarioId = U.Id
			FROM[dbo].[Usuarios] U
			WHERE U.Usuario = @Usuario

			SELECT @CuentaAhorroId = CA.Id
			FROM[dbo].[CuentaAhorro] CA
			WHERE CA.NumeroDeCuenta = @NumCuenta

			INSERT [dbo].[AccesoUsuario](UsuarioId
										, CuentaAhorroId)
			VALUES(@UsuarioId
				, @CuentaAhorroId
			)
			SET @lo1=@lo1+1
		END
		--SELECT * FROM @VariableTabla
	END TRY

	BEGIN CATCH

	END CATCH
SET NOCOUNT OFF
END
GO
--EXEC dbo.CargarAccesoUsuario
--SELECT * FROM [dbo].[AccesoUsuario]