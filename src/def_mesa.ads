package def_mesa is

   protected type Mesa is

      entry sentarse;
      entry levantarse;
      entry prepararComida;
      procedure servirComida;
      procedure dormirEnano;
      entry dormirBlancaneus;

   private

      sillasOcupadas : integer := 0; -- Sillas ocupadas por los enanos
      cocinando : boolean := false; -- Situaci�n de Blancaneus
      comidaServida :Boolean := False; -- Situaci�n de si la comida del enano esta lista
      enanosDurmiendo : Integer := 0; -- Cuantos enanos hay durmiendo

   end Mesa;

end def_mesa;
