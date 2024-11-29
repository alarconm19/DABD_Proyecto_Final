--Jugador Constraints & Foreign Keys
ALTER TABLE DABD.dbo.Jugador ADD CONSTRAINT Jugador_Equipo_FK FOREIGN KEY (NumEquipo) REFERENCES DABD.dbo.Equipo(NumEquipo) ON DELETE SET NULL ON UPDATE SET NULL;
ALTER TABLE DABD.dbo.Jugador ADD CONSTRAINT Jugador_Categoria_FK FOREIGN KEY (NumCategoria) REFERENCES DABD.dbo.Categoria(NumCategoria) ON DELETE CASCADE ON UPDATE CASCADE;

--Partido Constraints & Foreign Keys
ALTER TABLE DABD.dbo.Partido ADD CONSTRAINT Partido_Arbitro_FK FOREIGN KEY (Arbitro_DNI) REFERENCES DABD.dbo.Arbitro(DNI) ON DELETE SET NULL ON UPDATE SET NULL;
ALTER TABLE DABD.dbo.Partido ADD CONSTRAINT Partido_Cancha_FK FOREIGN KEY (IDCancha) REFERENCES DABD.dbo.Cancha(IDCancha) ON DELETE SET NULL ON UPDATE SET NULL;
ALTER TABLE DABD.dbo.Partido ADD CONSTRAINT Partido_Fecha_FK FOREIGN KEY (IDFecha) REFERENCES DABD.dbo.Fecha(IDFecha) ON DELETE SET NULL ON UPDATE SET NULL;
ALTER TABLE DABD.dbo.Partido ADD CONSTRAINT Partido_Equipo_FK FOREIGN KEY (IDVisitante) REFERENCES DABD.dbo.Equipo(NumEquipo);
ALTER TABLE DABD.dbo.Partido ADD CONSTRAINT Partido_Equipo_FK_1 FOREIGN KEY (IDLocal) REFERENCES DABD.dbo.Equipo(NumEquipo);
ALTER TABLE DABD.dbo.Partido WITH NOCHECK ADD CONSTRAINT EquiposDiferentes_CHECK CHECK (IDVisitante <> IDLocal);

--Equipo Constraints & Foreign Keys
ALTER TABLE DABD.dbo.Equipo ADD CONSTRAINT Equipo_Division_FK FOREIGN KEY (NumDivision) REFERENCES DABD.dbo.Division(NumDivision);
ALTER TABLE DABD.dbo.Equipo ADD CONSTRAINT Equipo_Categoria_FK FOREIGN KEY (NumCategoria) REFERENCES DABD.dbo.Categoria(NumCategoria);
ALTER TABLE DABD.dbo.Equipo ADD CONSTRAINT Equipo_Torneo_FK FOREIGN KEY (IDTorneo) REFERENCES DABD.dbo.Torneo(IDTorneo);

--Torneo Constraints & Foreign Keys
ALTER TABLE DABD.dbo.Torneo ADD CONSTRAINT Torneo_Categoria_FK FOREIGN KEY (NumCategoria) REFERENCES DABD.dbo.Categoria(NumCategoria);
ALTER TABLE DABD.dbo.Torneo ADD CONSTRAINT Torneo_Division_FK FOREIGN KEY (NumDivision) REFERENCES DABD.dbo.Division(NumDivision);

--Gol Constraints $ Foreign Keys
ALTER TABLE DABD.dbo.Gol ADD CONSTRAINT Gol_Jugador_Participa_Partido_FK FOREIGN KEY (IDPartido,NroSocio) REFERENCES DABD.dbo.Jugador_Participa_Partido(IDPartido,NroSocio);

--Infraction
ALTER TABLE DABD.dbo.Infraction ADD CONSTRAINT Infraction_Jugador_Participa_Partido_FK FOREIGN KEY (IDPartido,NroSocio) REFERENCES DABD.dbo.Jugador_Participa_Partido(IDPartido,NroSocio);

--Fecha
ALTER TABLE DABD.dbo.Fecha ADD CONSTRAINT Fecha_Rueda_FK FOREIGN KEY (IDRueda) REFERENCES DABD.dbo.Rueda(IDRueda);

--Jugador_Participa_Partido
ALTER TABLE DABD.dbo.Jugador_Participa_Partido ADD CONSTRAINT Jugador_Participa_Partido_Jugador_FK FOREIGN KEY (NroSocio) REFERENCES DABD.dbo.Jugador(NroSocio);
ALTER TABLE DABD.dbo.Jugador_Participa_Partido ADD CONSTRAINT Jugador_Participa_Partido_Partido_FK FOREIGN KEY (IDPartido) REFERENCES DABD.dbo.Partido(IDPartido);

--Fixture
ALTER TABLE DABD.dbo.Fixture ADD CONSTRAINT Fixture_Rueda_FK FOREIGN KEY (IDRueda) REFERENCES DABD.dbo.Rueda(IDRueda);
ALTER TABLE DABD.dbo.Fixture ADD CONSTRAINT Fixture_Torneo_FK FOREIGN KEY (IDTorneo) REFERENCES DABD.dbo.Torneo(IDTorneo);

--DirectorTecnico
ALTER TABLE DABD.dbo.DirectorTecnico ADD CONSTRAINT DirectorTecnico_Equipo_FK FOREIGN KEY (NumEquipo) REFERENCES DABD.dbo.Equipo(NumEquipo);
