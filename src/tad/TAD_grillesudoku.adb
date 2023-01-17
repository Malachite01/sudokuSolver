pragma Ada_2012;
package body TAD_grilleSudoku is

   ----------------------
   -- construireGrille --
   ----------------------

   function construireGrille return Type_Grille is
      g       : Type_Grille;
   begin
     for colonne in 1..9 loop
         for ligne in 1..9 loop
            g (ligne, colonne) := 0;
         end loop;
      end loop;
      return g;
   end construireGrille;

   --------------
   -- caseVide --
   --------------

   function caseVide
     (g : in Type_Grille; c : in Type_Coordonnee) return Boolean
   is
   begin
      if g (obtenirLigne (c), obtenirColonne (c)) = 0 then
         return True;
      else
         return False;
      end if;
   end caseVide;

   --------------------
   -- obtenirChiffre --
   --------------------

   function obtenirChiffre
     (g : in Type_Grille; c : in Type_Coordonnee) return Integer
   is
   begin
      if caseVide(g, c) then
         raise OBTENIR_CHIFFRE_NUL;
      end if;
      return g (obtenirLigne (c), obtenirColonne (c));
   end obtenirChiffre;

   --------------------
   -- nombreChiffres --
   --------------------

   function nombreChiffres (g : in Type_Grille) return Integer is
      c               : Type_Coordonnee;
      nbChiffreGrille : Integer := 0;
   begin
      for ligne in 1..9 loop
         for colonne in 1..9 loop
            c := construireCoordonnees (ligne, colonne);
            if g (obtenirLigne (c), obtenirColonne (c)) /= 0 then
               nbChiffreGrille := nbChiffreGrille + 1;
            end if;
         end loop;
      end loop;
      return nbChiffreGrille;
   end nombreChiffres;

   ------------------
   -- fixerChiffre --
   ------------------

   procedure fixerChiffre
     (g : in out Type_Grille; c : in Type_Coordonnee; v : in Integer; cpt : in out Integer)
   is
   begin
      if g (obtenirLigne (c), obtenirColonne (c)) /= 0 then
         raise FIXER_CHIFFRE_NON_NUL;
      end if;
      g (obtenirLigne (c), obtenirColonne (c)) := v;
      cpt:= cpt+1;
   end fixerChiffre;

   ---------------
   -- viderCase --
   ---------------

   procedure viderCase (g : in out Type_Grille; c : in out Type_Coordonnee) is
   begin
      if g (obtenirLigne (c), obtenirColonne (c)) = 0 then
         raise VIDER_CASE_VIDE;
      end if;
      g (obtenirLigne (c), obtenirColonne (c)) := 0;
   end viderCase;

   ----------------
   -- estRemplie --
   ----------------

   function estRemplie (g : in Type_Grille) return Boolean is
      valeurCase : Integer;
   begin
      for i in 1..9 loop
         for i2 in 1..9 loop
            valeurCase := g (i, i2);
            if valeurCase = 0 then
               return False;
            end if;
         end loop;
      end loop;
      return True;
   end estRemplie;

   ------------------------------
   -- obtenirChiffresDUneLigne --
   ------------------------------

  function obtenirChiffresDUneLigne
     (g : in Type_Grille; numLigne : in Integer) return Type_Ensemble
   is
      c: Type_Coordonnee;
      ensembleLigne: Type_Ensemble;
   begin
      ensembleLigne := construireEnsemble;
      for i in 1..9 loop
         c := construireCoordonnees(numLigne,i);
         if not caseVide(g,c) then
            ajouterChiffre(ensembleLigne,obtenirChiffre(g,c));
         end if;
      end loop;
      return ensembleLigne ;
   end obtenirChiffresDUneLigne;

   --------------------------------
   -- obtenirChiffresDUneColonne --
   --------------------------------

   function obtenirChiffresDUneColonne
     (g : in Type_Grille; numColonne : in Integer) return Type_Ensemble is
      c: Type_Coordonnee;
      ensembleColonne: Type_Ensemble;
   begin
      ensembleColonne := construireEnsemble;
      for i in 1..9 loop
         c := construireCoordonnees(i, numColonne);
         if not caseVide(g,c) then
            ajouterChiffre(ensembleColonne,obtenirChiffre(g,c));
         end if;
      end loop;
      return ensembleColonne;
   end obtenirChiffresDUneColonne;


   -----------------------------
   -- obtenirChiffresDUnCarre --
   -----------------------------

   function obtenirChiffresDUnCarre
     (g : in Type_Grille; numCarre : in Integer) return Type_Ensemble
   is
      c: Type_Coordonnee;
      ensembleCarre: Type_Ensemble;
      ligne: integer;
      colonne: integer;
   begin
      ensembleCarre := construireEnsemble;
      c := obtenirCoordonneeCarre(numCarre);
      ligne := obtenirLigne(c);
      colonne := obtenirColonne(c);
      for i in 1..3 loop
         for z in 1..3 loop
           c := construireCoordonnees(i+ligne-1,z+colonne-1);
           if not caseVide(g,c) then
              ajouterChiffre(ensembleCarre,obtenirChiffre(g,c));
            end if;
         end loop;
      end loop;
      return ensembleCarre;
   end obtenirChiffresDUnCarre;

end TAD_grilleSudoku;
