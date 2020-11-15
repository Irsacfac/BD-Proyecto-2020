USE [Proyecto];
GO
DROP PROCEDURE  IF EXISTS dbo.CargarBeneficiarios;
GO
CREATE PROCEDURE dbo.CargarBeneficiarios
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY
		DECLARE
			@tipo_Documento XML = NULL
			, @doc INT = 0
			--Tabla variable
		DECLARE 
			@VariableTabla TABLE (Sec INT IDENTITY(1,1), ValDocIdent VARCHAR(100), NumeroCuenta INT, Parentesco INT, Porcentaje INT)
		--Cargar datos a la tabla variable
		SELECT @tipo_Documento = od	FROM OPENROWSET (BULK 'D:\S3\Proyecto2020\Datos_Tarea1 v2.1.xml', SINGLE_BLOB) AS TiposDoc(od) --pone la direccion donde se encuentra
		EXEC sp_xml_preparedocument @doc OUTPUT, @tipo_Documento
		INSERT INTO @VariableTabla(ValDocIdent
								, NumeroCuenta
								, Parentesco
								, Porcentaje
								)				--selecciona la tabla a llenar y las columnas 
		SELECT * FROM OPENXML (@doc, 'Datos/Beneficiarios/Beneficiario')						--encabezado a buscar
		WITH( ValDocIdent [VARCHAR](100)'@ValorDocumentoIdentidadBeneficiario'
			, NumeroCuenta [INT]'@NumeroCuenta'
			, Parentesco [INT]'@ParentezcoId'
			, Porcentaje [INT]'@Porcentaje'
			);						--Se ingresan los datos a la tabla variable
		
		--Pasar datos de la tabla variable a la Beneficiario
		DECLARE 
			@lo1 INT
			, @hi1 INT
			, @ValDocIdent VARCHAR(100)
			, @NumeroCuenta INT
			, @ParentescoId INt
			, @Porcentaje INT
			, @PersonaId INT
			, @CuentaAhorroId INT;
		SELECT @lo1=MIN(Sec), @hi1=MAX(Sec)
		FROM @VariableTabla
		WHILE @lo1<=@hi1
		BEGIN
			SELECT
				@ValDocIdent = VT.ValDocIdent
				, @NumeroCuenta = VT.NumeroCuenta
				, @ParentescoId = VT.Parentesco
				, @Porcentaje = VT.Porcentaje
			FROM @VariableTabla VT
			WHERE Sec = @lo1
			
			SELECT @PersonaId = P.Id
			FROM [dbo].[Personas] P
			WHERE P.ValDocIdentidad = @ValDocIdent
			
			SELECT @CuentaAhorroId = CA.Id
			FROM[dbo].[CuentaAhorro] CA
			WHERE CA.NumeroDeCuenta = @NumeroCuenta

			INSERT [dbo].[Beneficiarios](PersonaId
										, CuentaAhorroId
										, ParentescoId
										, Porcentaaje
										)
			VALUES(@PersonaId
			, @CuentaAhorroId
			, @ParentescoId
			, @Porcentaje
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
--EXEC dbo.CargarBeneficiarios
--SELECT * FROM [dbo].[Beneficiarios]