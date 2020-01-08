-- Practica 2: Blancaneus y los 7 enanitos
-- Autores: Adrian Castellanos y Michelle Vlad
-- https://youtu.be/fg_XMla_HOk

with Text_Io; use  Text_Io;
with def_mesa; use def_mesa;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

procedure Main is

   -- Datos Compartidos

   ENANOS : constant integer := 7; -- Cantidad de hilos de tipo enanos tenemos que lanzar
   enanosCasa : integer := 0; -- Cantidad de enanos que hay en la casa
   enanosDurnmiendo : integer := 0; -- Cantidad de enanos que se han ido a dormir

   -- Tipos protegidos para la SC

   monitor : Mesa;

   -- Task de Blancaneus
   -- Declaramos todas las acciones que hace Blancaneus
   -- Pasea (mientras no haya enanos en casa), prepara la comida, sirve la
   -- comida y se va a dormir cuando todos los enanos se han ido a dormir

   task type Blancaneus is
      entry Start;
   end Blancaneus;

   task body Blancaneus is
   begin

      accept Start do
         Put_Line ("BON DIA som na Blancaneus"); -- Accion con la que empieza Blancaneus
      end Start;

      -- Bucle infinito donde Blancaneus comprueba las tareas que tiene que hacer
      -- hasta que los enanos se han ido a dormir
      loop
         if enanosCasa = 0 then -- No hay enanos a los que atender
            Put_Line("Blancaneus se'n va a fer una passejada");
            delay(2.0);
         else
            monitor.prepararComida; -- Blancaneus queda bloqueada mientras cocina
            Put_Line("Blancaneus cuina per un nan");
            delay(5.0);
            monitor.servirComida; -- Blancaneus se desbloquea cuando ha servido la comida
         end if;
         exit when enanosDurnmiendo = ENANOS - 1; -- Sale del bucle cuando hay 7 enanos durmiendo (0..6)
      end loop;

      -- Blancaneus se va a dormir porque hay enanosDurmiendo = 7
      monitor.dormirBlancaneus;
      Put_Line("Blancaneus se'n va a dormir " & enanosDurnmiendo'Img);

   end Blancaneus;


   -- Task de Enano
   -- Declaramos todas las acciones que hace un Enano
   -- Va a trabajar, pide turno para sentarse, pide turno para comer, come,
   -- , repide el proceso 2 veces y se va a dormir.
   -- Cada task de tipo enano tiene un indice asociado

   task type Enano is
      entry Start (Idx : in integer);
   end Enano;

   task body Enano is
      My_Idx : integer;
   begin
      accept Start (Idx : in integer) do
         My_Idx := Idx; -- Guardamos el indice de la tarea que se ha lanzado
         Put_Line("BON DIA som nan " & My_Idx'img);
      end Start;

      -- Hacemos un bucle que se ejecuta 2 veces para realizar la rutina de trabajar/comer
      for i in 0..1 loop
         Put_Line("Nan " & My_Idx'img & " treballa a la mina");
         delay (10.0); -- Tiempo que esta trabajando el enano en la mina
         Put_Line("Nan " & My_Idx'img & " espera per una cadira");
         enanosCasa := enanosCasa + 1; -- Aumentan los enanos que hay en casa

         monitor.sentarse; -- Se bloquea la task hasta que haya silla disponible
         Put_Line("Nan " & My_Idx'img & " ja seu");
         Put_Line("Nan " & My_Idx'img & " espera torn per menjar");
         monitor.levantarse; -- La comida esta servida y come y esta listo para liberar la silla

         Put_Line("-----> Nan " & My_Idx'img & " menja!!!");
         delay(2.0);
         enanosCasa := enanosCasa - 1; -- Enano ya no ha acabdo de comer
      end loop;

      -- Enano ha acabado sus tareas por el dia y acaba
      monitor.dormirEnano;
      enanosDurnmiendo := enanosDurnmiendo + 1;
      Put_Line("Nan " & My_Idx'img & " se'n va a DORMIR" & enanosDurnmiendo'Img & "/7");

   end Enano;

   -- Array de las 7 tareas de enanos
   type Enanitos is array (1..ENANOS) of Enano;
   en : Enanitos;
   b : Blancaneus;
begin
   -- Start las tareas de los personajes
   b.Start;
   for Idx in 1..ENANOS loop
      en(Idx).Start(Idx);
   end loop;

end Main;
