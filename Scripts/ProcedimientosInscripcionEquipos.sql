--Contiene todos los procedimientos necesarios para crear un equipo
--y el director técnico.

--Procedimiento para crear un equipo
CREATE PROCEDURE InsertarEquipo
    @NumDivision INT,
    @NumCategoria INT,
    @Nombre VARCHAR(50)
AS
BEGIN
    BEGIN TRY

        IF NOT EXISTS (SELECT 1 FROM AFDB.dbo.Division WHERE NumDivision = @NumDivision)
        BEGIN
            PRINT 'Error: La división especificada no existe.';
            RETURN;
        END

        IF NOT EXISTS (SELECT 1 FROM AFDB.dbo.Categoria WHERE NumCategoria = @NumCategoria)
        BEGIN
            PRINT 'Error: La categoría especificada no existe.';
            RETURN;
        END

        INSERT INTO AFDB.dbo.Equipo (NumDivision, NumCategoria, Nombre)
        VALUES (@NumDivision, @NumCategoria, @Nombre);

        PRINT 'Equipo registrado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al registrar el equipo: ' + ERROR_MESSAGE();
    END CATCH
END;


--Procedimiento para ingresar un director tecnico.
--Se puede dejar en 0 el valor para no asignarle un equipo.
CREATE PROCEDURE CrearDirectorTecnico
    @Nombre VARCHAR(50),
    @NumEquipo INT = 0 --Valor por defecto
AS
BEGIN
    BEGIN TRY
        IF @NumEquipo = 0
            SET @NumEquipo = NULL;

        INSERT INTO AFDB.dbo.DirectorTecnico (Nombre, NumEquipo)
        VALUES (@Nombre, @NumEquipo);

        PRINT 'Director técnico registrado correctamente.';
    END TRY
    BEGIN CATCH
        PRINT 'Error al registrar el director técnico: ' + ERROR_MESSAGE();
    END CATCH
END;


--Procedimiento para asignar un director tecnico a un equipo.
CREATE PROCEDURE AsignarDirectorTecnicoAEquipo
    @NumDT INT,
    @NumEquipo INT
AS
BEGIN
    BEGIN TRY
        -- Verifica si el director técnico ya está asignado a un equipo
        DECLARE @EquipoActual INT;

        SELECT @EquipoActual = NumEquipo
        FROM AFDB.dbo.DirectorTecnico
        WHERE NumDT = @NumDT;

        IF @EquipoActual IS NOT NULL
        BEGIN
            PRINT 'El director técnico ya está asignado al equipo con ID: ' + CAST(@EquipoActual AS VARCHAR);
        END
        IF NOT EXISTS (SELECT 1 FROM AFDB.dbo.Equipo WHERE NumEquipo = @NumEquipo)
        BEGIN
            PRINT 'Error: El equipo especificado no existe.';
            RETURN;
        END
        ELSE
        BEGIN
            -- Si no lo está, entonces se asigna a un nuevo equipo
            UPDATE AFDB.dbo.DirectorTecnico
            SET NumEquipo = @NumEquipo
            WHERE NumDT = @NumDT;

            PRINT 'Director técnico asignado al equipo correctamente.';
        END
    END TRY
    BEGIN CATCH
        PRINT 'Error al asignar el director técnico: ' + ERROR_MESSAGE();
    END CATCH
END;

