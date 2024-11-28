--Jugador Constraints & Foreign Keys
ALTER TABLE AFDB.dbo.Jugador ADD CONSTRAINT Jugador_Equipo_FK FOREIGN KEY (NumEquipo) REFERENCES AFDB.dbo.Equipo(NumEquipo) ON DELETE SET NULL ON UPDATE SET NULL;
ALTER TABLE AFDB.dbo.Jugador ADD CONSTRAINT Jugador_Categoria_FK FOREIGN KEY (NumCategoria) REFERENCES AFDB.dbo.Categoria(NumCategoria) ON DELETE CASCADE ON UPDATE CASCADE;

--Partido Constraints & Foreign Keys
ALTER TABLE AFDB.dbo.Partido ADD CONSTRAINT Partido_Arbitro_FK FOREIGN KEY (Arbitro_DNI) REFERENCES AFDB.dbo.Arbitro(DNI) ON DELETE SET NULL ON UPDATE SET NULL;
ALTER TABLE AFDB.dbo.Partido ADD CONSTRAINT Partido_Cancha_FK FOREIGN KEY (IDCancha) REFERENCES AFDB.dbo.Cancha(IDCancha) ON DELETE SET NULL ON UPDATE SET NULL;
ALTER TABLE AFDB.dbo.Partido ADD CONSTRAINT Partido_Fecha_FK FOREIGN KEY (IDFecha) REFERENCES AFDB.dbo.Fecha(IDFecha) ON DELETE SET NULL ON UPDATE SET NULL;
ALTER TABLE AFDB.dbo.Partido ADD CONSTRAINT Partido_Equipo_FK FOREIGN KEY (IDVisitante) REFERENCES AFDB.dbo.Equipo(NumEquipo);
ALTER TABLE AFDB.dbo.Partido ADD CONSTRAINT Partido_Equipo_FK_1 FOREIGN KEY (IDLocal) REFERENCES AFDB.dbo.Equipo(NumEquipo);
ALTER TABLE AFDB.dbo.Partido WITH NOCHECK ADD CONSTRAINT EquiposDiferentes_CHECK CHECK (IDVisitante <> IDLocal);

--Equipo Constraints & Foreign Keys
ALTER TABLE AFDB.dbo.Equipo ADD CONSTRAINT Equipo_Division_FK FOREIGN KEY (NumDivision) REFERENCES AFDB.dbo.Division(NumDivision);
ALTER TABLE AFDB.dbo.Equipo ADD CONSTRAINT Equipo_Categoria_FK FOREIGN KEY (NumCategoria) REFERENCES AFDB.dbo.Categoria(NumCategoria);
ALTER TABLE AFDB.dbo.Equipo ADD CONSTRAINT Equipo_Torneo_FK FOREIGN KEY (IDTorneo) REFERENCES AFDB.dbo.Torneo(IDTorneo);

--Torneo Constraints & Foreign Keys
ALTER TABLE AFDB.dbo.Torneo ADD CONSTRAINT Torneo_Categoria_FK FOREIGN KEY (NumCategoria) REFERENCES AFDB.dbo.Categoria(NumCategoria);
ALTER TABLE AFDB.dbo.Torneo ADD CONSTRAINT Torneo_Division_FK FOREIGN KEY (NumDivision) REFERENCES AFDB.dbo.Division(NumDivision);

--Gol Constraints $ Foreign Keys
ALTER TABLE AFDB.dbo.Gol ADD CONSTRAINT Gol_Jugador_Participa_Partido_FK FOREIGN KEY (IDPartido,NroSocio) REFERENCES AFDB.dbo.Jugador_Participa_Partido(IDPartido,NroSocio);

--Infraction
ALTER TABLE AFDB.dbo.Infraction ADD CONSTRAINT Infraction_Jugador_Participa_Partido_FK FOREIGN KEY (IDPartido,NroSocio) REFERENCES AFDB.dbo.Jugador_Participa_Partido(IDPartido,NroSocio);

--Fecha
ALTER TABLE AFDB.dbo.Fecha ADD CONSTRAINT Fecha_Rueda_FK FOREIGN KEY (IDRueda) REFERENCES AFDB.dbo.Rueda(IDRueda);

--Jugador_Participa_Partido
ALTER TABLE AFDB.dbo.Jugador_Participa_Partido ADD CONSTRAINT Jugador_Participa_Partido_Jugador_FK FOREIGN KEY (NroSocio) REFERENCES AFDB.dbo.Jugador(NroSocio);
ALTER TABLE AFDB.dbo.Jugador_Participa_Partido ADD CONSTRAINT Jugador_Participa_Partido_Partido_FK FOREIGN KEY (IDPartido) REFERENCES AFDB.dbo.Partido(IDPartido);

--Fixture
ALTER TABLE AFDB.dbo.Fixture ADD CONSTRAINT Fixture_Rueda_FK FOREIGN KEY (IDRueda) REFERENCES AFDB.dbo.Rueda(IDRueda);
ALTER TABLE AFDB.dbo.Fixture ADD CONSTRAINT Fixture_Torneo_FK FOREIGN KEY (IDTorneo) REFERENCES AFDB.dbo.Torneo(IDTorneo);

--DirectorTecnico
ALTER TABLE AFDB.dbo.DirectorTecnico ADD CONSTRAINT DirectorTecnico_Equipo_FK FOREIGN KEY (NumEquipo) REFERENCES AFDB.dbo.Equipo(NumEquipo);
