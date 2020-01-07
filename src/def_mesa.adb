package body def_mesa is

   protected body Mesa is

      -- Bloquea una silla si hay sillas disponibles
      entry sentarse when sillasOcupadas < 4 is
      begin
         sillasOcupadas := sillasOcupadas + 1;
      end sentarse;

      -- Enano come y libera la silla
      entry levantarse when comidaServida is
      begin
         sillasOcupadas := sillasOcupadas - 1;
         comidaServida := False;
      end levantarse;

      -- Blancaneus prepara la comida si no esta cocinando y hay 1 enano pidiendola
      entry prepararComida when (not cocinando) and (sillasOcupadas > 0) is
      begin
         cocinando := true;
      end prepararComida;

      -- Sirve la comida cocinada
      procedure servirComida is
      begin
         cocinando := false;
         comidaServida := true;
      end servirComida;

      -- Enano se va a dormir y contabilizamos cuantos se han ido a dormir
      procedure dormirEnano is
      begin
         enanosDurmiendo := enanosDurmiendo + 1;
      end dormirEnano;

      -- Blancaneus se va a dormir si hay 7 enanos durmiendo
      entry dormirBlancaneus when enanosDurmiendo > 6 is
      begin
         null;
      end dormirBlancaneus;

   end Mesa;

end def_mesa;
