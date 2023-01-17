pragma Ada_2012;
package body TAD_ensemble is

   ------------------------
   -- construireEnsemble --
   ------------------------

   function construireEnsemble return Type_Ensemble is
      e : Type_Ensemble;
   begin
      for i in 1..9 loop
         e(i) := False;
      end loop;
      return e;
   end construireEnsemble;

   ------------------
   -- ensembleVide --
   ------------------

   function ensembleVide (e : in Type_Ensemble) return Boolean is
   begin
      for i in 1..9 loop
         if e (i) then
            return False;
         end if;
      end loop;
      return True;
   end ensembleVide;

   -----------------------
   -- appartientChiffre --
   -----------------------

   function appartientChiffre
     (e : in Type_Ensemble; v : in Integer) return Boolean
   is
   begin
      if not e (v) then
         return False;
      end if;
      return True;
   end appartientChiffre;

   --------------------
   -- nombreChiffres --
   --------------------

   function nombreChiffres (e : in Type_Ensemble) return Integer is
      compteur : Integer;
   begin
      compteur := 0;
      for i in 1..9 loop
         if e (i) then
            compteur := compteur + 1;
         end if;
      end loop;
      return compteur;
   end nombreChiffres;

   --------------------
   -- ajouterChiffre --
   --------------------

   procedure ajouterChiffre (e : in out Type_Ensemble; v : in Integer) is
   begin
      if appartientChiffre (e, v) then
         raise APPARTIENT_ENSEMBLE;
      end if;
      e (v) := True;
   end ajouterChiffre;

   --------------------
   -- retirerChiffre --
   --------------------

   procedure retirerChiffre (e : in out Type_Ensemble; v : in Integer) is
   begin
      if not appartientChiffre (e, v) then
         raise NON_APPARTIENT_ENSEMBLE;
      end if;
      e (v) := False;
   end retirerChiffre;

   --------------------
   -- plusPetiteValeur --
   --------------------

   function plusGrandeValeur (e : in Type_Ensemble) return integer is
      plusPetiteValeurPosable: integer;
   begin
      for i in 1..9 loop
         if e(i) then
            plusPetiteValeurPosable := i;
         end if;
      end loop;
      return plusPetiteValeurPosable;
   end plusGrandeValeur;
end TAD_ensemble;
