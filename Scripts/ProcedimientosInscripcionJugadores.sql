--Procedimiento completo para insertar un nuevo jugador.
--Tiene un valor opcional que es el numero del equipo, se puede
--dejar en 0 para no asignar ninguno, en cuyo caso el valor será nulo.

CREATE PROCEDURE InsertarJugador
	@DNI INT,
    @Nombre VARCHAR(50),
    @Apellido VARCHAR(50),
    @Direccion VARCHAR(100),
    @URLFotoPerf VARCHAR(255),
    @FechaNac DATE,
    @Telefono VARCHAR(15),
    @NumEquipo INT = 0 -- Valor opcional.
AS
BEGIN
    BEGIN TRY
        -- Se calcula la edad del jugador para poder asignarle la categoria correspondiente.
        DECLARE @Edad INT = DATEDIFF(YEAR, @FechaNac, GETDATE());

       	-- Esta es una verificacion que se hace por si el jugador aun no cumplió
       	-- en ese año.
        IF (MONTH(@FechaNac) > MONTH(GETDATE()) OR
           (MONTH(@FechaNac) = MONTH(GETDATE()) AND DAY(@FechaNac) > DAY(GETDATE())))
        BEGIN
            SET @Edad = @Edad - 1;
        END

        -- Se busca la categoría correspondiente según la edad del jugador.
        DECLARE @NumCategoria INT;
        SELECT TOP 1 @NumCategoria = NumCategoria
        FROM DABD.dbo.Categoria
        WHERE @Edad BETWEEN EdadMaxima AND EdadMinima;

        -- Lanza un error si no se encuentra una categoria para el jugador.
        IF @NumCategoria IS NULL
        BEGIN
            THROW 50001, 'No hay una categoría disponible para la edad del jugador.', 1;
        END

        IF @NumEquipo > 0
        BEGIN
	        IF NOT EXISTS (SELECT 1 FROM DABD.dbo.Equipo WHERE NumEquipo = @NumEquipo)
	        BEGIN
	            THROW 50005, 'El equipo especificado no existe.', 1;
	        END

            -- Se verifica que el equipo pertenece a la categoría asignada al jugador.
            DECLARE @CategoriaEquipo INT;
            SELECT @CategoriaEquipo = NumCategoria
            FROM DABD.dbo.Equipo
            WHERE NumEquipo = @NumEquipo;

            IF @CategoriaEquipo IS NULL OR @CategoriaEquipo != @NumCategoria
            BEGIN
                THROW 50002, 'El equipo no pertenece a la categoría correspondiente del jugador.', 1;
            END

            -- Tambien se verifica que el equipo no pase a tener más de 11 jugadores.
            DECLARE @CantidadJugadores INT;
            SELECT @CantidadJugadores = COUNT(*)
            FROM DABD.dbo.Jugador
            WHERE NumEquipo = @NumEquipo;

            IF @CantidadJugadores >= 11
            BEGIN
                THROW 50003, 'El equipo ya tiene el máximo de 11 jugadores.', 1;
            END
        END


        INSERT INTO DABD.dbo.Jugador
            (DNI, Nombre, Apellido, Direccion, URLFotoPerf, FechaNac, Telefono, NumCategoria, NumEquipo)
        VALUES
            (@DNI, @Nombre, @Apellido, @Direccion, @URLFotoPerf, @FechaNac, @Telefono, @NumCategoria,
            CASE WHEN @NumEquipo > 0 THEN @NumEquipo ELSE NULL END);

        PRINT 'Jugador registrado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al registrar el jugador: ' + ERROR_MESSAGE();
    END CATCH
END;


--Procedimiento completo para asignar un jugador a un equipo.
--Similar al de arriba, osea se hacen los mismos chequeos.

CREATE PROCEDURE AsignarJugadorAEquipo
    @NroSocio INT,
    @NumEquipo INT
AS
BEGIN
    BEGIN TRY

        IF NOT EXISTS (SELECT 1 FROM DABD.dbo.Jugador WHERE NroSocio = @NroSocio)
        BEGIN
            THROW 50004, 'El jugador especificado no existe.', 1;
        END


        IF NOT EXISTS (SELECT 1 FROM DABD.dbo.Equipo WHERE NumEquipo = @NumEquipo)
        BEGIN
            THROW 50005, 'El equipo especificado no existe.', 1;
        END


        DECLARE @CategoriaJugador INT, @CategoriaEquipo INT;
        SELECT @CategoriaJugador = NumCategoria
        FROM DABD.dbo.Jugador
        WHERE NroSocio = @NroSocio;

        SELECT @CategoriaEquipo = NumCategoria
        FROM DABD.dbo.Equipo
        WHERE NumEquipo = @NumEquipo;

        IF @CategoriaEquipo != @CategoriaJugador
        BEGIN
            THROW 50006, 'El equipo no pertenece a la misma categoría que el jugador.', 1;
        END


        DECLARE @CantidadJugadores INT;
        SELECT @CantidadJugadores = COUNT(*)
        FROM DABD.dbo.Jugador
        WHERE NumEquipo = @NumEquipo;

        IF @CantidadJugadores >= 11
        BEGIN
            THROW 50007, 'El equipo ya tiene el máximo de 11 jugadores.', 1;
        END


        UPDATE DABD.dbo.Jugador
        SET NumEquipo = @NumEquipo
        WHERE NroSocio = @NroSocio;

        PRINT 'Jugador asignado al equipo correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al asignar el jugador al equipo: ' + ERROR_MESSAGE();
    END CATCH
END;
