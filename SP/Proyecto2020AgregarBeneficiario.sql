USE [Proyecto];
GO
DROP PROCEDURE  IF EXISTS dbo.AgregarBeneficiario;
GO
CREATE PROCEDURE dbo.AgregarBeneficiario
	@inValDocIdent VARCHAR(100)
	, @inNumeroCuenta INT
	, @inParentesco INT
	, @inPorcentaje INT
	, @outBeneficiarioId INT OUTPUT
	, @outResultCode INT OUTPUT
AS
BEGIN
SET NOCOUNT ON
	BEGIN TRY

	--Codigo para pruebas

--DECLARE @RC int
--DECLARE @inValDocIdent varchar(100)
--DECLARE @inNumeroCuenta int
--DECLARE @inParentesco int
--DECLARE @inPorcentaje int
--DECLARE @outBeneficiarioId int
--DECLARE @outResultCode int

---- TODO: Set parameter values here.

--EXECUTE @RC = [dbo].[AgregarBeneficiario] 
--   @inValDocIdent
--  ,@inNumeroCuenta
--  ,@inParentesco
--  ,@inPorcentaje
--  ,@outBeneficiarioId OUTPUT
--  ,@outResultCode OUTPUT

--SELECT @outBeneficiarioId, @outResultCode

		--Validaciones
		SELECT @outResultCode = 0

		IF NOT EXISTS (SELECT 1 FROM [dbo].[Personas] WHERE ValDocIdentidad=@inValDocIdent)
		BEGIN
			SET @outResultCode = 50001 --Valor Ingresado no se puede encontrar en la tabla correspondiente
			RETURN
		END

		IF NOT EXISTS (SELECT 1 FROM [dbo].[CuentaAhorro] WHERE NumeroDeCuenta=@inNumeroCuenta)
		BEGIN
			SET @outResultCode = 50001 --Valor Ingresado no se puede encontrar en la tabla correspondiente
			RETURN
		END
		--Mapeo con llave no primaria
		DECLARE
			@PersonaID INT
			, @CuentaAhorroID INT

		SELECT @PersonaId = P.Id
		FROM [dbo].[Personas] P
		WHERE P.ValDocIdentidad = @inValDocIdent
			
		SELECT @CuentaAhorroId = CA.Id
		FROM[dbo].[CuentaAhorro] CA
		WHERE CA.NumeroDeCuenta = @inNumeroCuenta

		INSERT iNTO [dbo].[Beneficiarios](PersonaId
									, CuentaAhorroId
									, ParentescoId
									, Porcentaaje
									)
		VALUES(@PersonaId
		, @CuentaAhorroId
		, @inParentesco
		, @inPorcentaje
		);

		SET @outBeneficiarioId = SCOPE_IDENTITY();
	END TRY

	BEGIN CATCH

	END CATCH
SET NOCOUNT OFF
END
GO