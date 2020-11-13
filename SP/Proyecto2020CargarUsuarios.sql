USE [Proyecto];
GO
DROP PROCEDURE  IF EXISTS dbo.CargarUsuarios;
GO
CREATE PROCEDURE dbo.CargarUsuarios
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		DECLARE
			@tipo_Documento XML = NULL
			, @doc INT = 0			--Tabla variable		DECLARE 
			@VariableTabla TABLE (Sec INT IDENTITY(1,1), ValDocIdent VARCHAR(100), Usuario VARCHAR(20), Contraseña VARCHAR(20), isAdministrador BIT)
		--Cargar datos a la tabla variable
		SELECT @tipo_Documento = od	FROM OPENROWSET (BULK 'D:\S3\Proyecto2020\Datos_Tarea1 v2.xml', SINGLE_BLOB) AS TiposDoc(od) --pone la direccion donde se encuentra
		EXEC sp_xml_preparedocument @doc OUTPUT, @tipo_Documento
		INSERT INTO @VariableTabla(ValDocIdent
								, Usuario
								, Contraseña
								, isAdministrador
								)				--selecciona la tabla a llenar y las columnas 
		SELECT * FROM OPENXML (@doc, 'Datos/Usuarios/Usuario')						--encabezado a buscar
		WITH( ValDocIdent [VARCHAR](100)'@ValorDocumentoIdentidad'
			, Usuario [VARCHAR](20)'@User'
			, Contraseña [VARCHAR](20)'@Pass'
			, isAdministrador [BIT]'@EsAdministrador'
			);						--Se ingresan los datos a la tabla variable
		
		--Pasar datos de la tabla variable a la tabla Usuarios
		DECLARE 
			@lo1 INT
			, @hi1 INT
			, @ValDocIdent VARCHAR(100)
			, @Usuario VARCHAR(20)
			, @Contraseña VARCHAR(20)
			, @isAdministrador BIT
			, @PersonaId INT;
		SELECT @lo1=MIN(Sec), @hi1=MAX(Sec)
		FROM @VariableTabla
		WHILE @lo1<=@hi1
		BEGIN
			SELECT
				@ValDocIdent = VT.ValDocIdent
				, @Usuario = VT.Usuario
				, @Contraseña = VT.Contraseña
				, @isAdministrador = VT.isAdministrador
			FROM @VariableTabla VT
			WHERE Sec = @lo1
			
			SELECT @PersonaId = P.Id
			FROM[dbo].[Personas] P
			WHERE P.ValDocIdentidad = @ValDocIdent

			INSERT [dbo].[Usuarios](PersonaId
										, Usuario
										, Contraseña
										, isAdministrador
										)
			VALUES(@PersonaId
			, @Usuario
			, @Contraseña
			, @isAdministrador
			)
			SET @lo1=@lo1+1
		END
		SELECT * FROM @VariableTabla
	END TRY

	BEGIN CATCH

	END CATCH
SET NOCOUNT OFF
END
GO
EXEC dbo.CargarUsuarios
SELECT * FROM [dbo].[Usuarios]