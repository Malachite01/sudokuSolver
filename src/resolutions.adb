with Ada.Text_IO;         use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with affichage; use affichage;

package body resolutions is

  -----------------------
   -- estChiffreValable --
   -----------------------

   function estChiffreValable (g : in Type_Grille; v : Integer; c : Type_Coordonnee) return Boolean is
   begin
      if not caseVide(g, c) then
         raise CASE_NON_VIDE;
      end if;
      if not appartientChiffre(obtenirChiffresDUneLigne(g, obtenirLigne(c)), v)
        and not appartientChiffre(obtenirChiffresDUneColonne(g, obtenirColonne(c)), v)
        and not appartientChiffre(obtenirChiffresDUnCarre(g, obtenirCarre(c)), v) then
         return true;
      end if;
      return False;
   end estChiffreValable;

   -------------------------------
   -- obtenirSolutionsPossibles --
   -------------------------------

   function obtenirSolutionsPossibles (g : in Type_Grille; c : in Type_Coordonnee) return Type_Ensemble is
      solutionPossible : Type_Ensemble;
   begin
      if not caseVide(g, c) then
         raise CASE_NON_VIDE;
      end if;
      solutionPossible := construireEnsemble;
      for i in 1..9 loop
         if estChiffreValable(g, i, c) then
               ajouterChiffre(solutionPossible,i);
         end if;
      end loop;
      return solutionPossible;
   end obtenirSolutionsPossibles;

   ------------------------------------------
   -- rechercherSolutionUniqueDansEnsemble --
   ------------------------------------------

   function rechercherSolutionUniqueDansEnsemble
     (resultats : in Type_Ensemble) return Integer
   is
      v: integer := 1;
      v2: integer := 0;
   begin
      if nombreChiffres(resultats) > 1 then
         raise PLUS_DE_UN_CHIFFRE;
      end if;
      if ensembleVide(resultats) then
         raise ENSEMBLE_VIDE;
      end if;
     for i in 1..9 loop
         if appartientChiffre(resultats, v) then
            v2 :=v;
         end if;
         v := v + 1;
      end loop;
      return v2;
   end rechercherSolutionUniqueDansEnsemble;

  --------------------
   -- resoudreSudoku --
   --------------------

   procedure resoudreSudoku (g : in out Type_Grille; trouve : out Boolean; cpt: out Integer) is
      ligne: integer;
      colonne: integer;
      c: Type_Coordonnee;
      e: Type_Ensemble; --Ensemble des possibilitées
      v: integer;
      startBackTrack: Boolean := false;
      unNombre: Boolean := true;
      tabCoordonnee: coordonneeTab;
      cptCoordonnee: integer := 0;
      tabEnsemble: ensembleTab;
      cptEnsemble: integer := 0;
      ligne2: integer;
      colonne2: integer;
      nbValeurPoseTour: boolean := true;
   begin
      cpt:= 0;
      trouve := false;
      while not estRemplie(g) loop
         while nbValeurPoseTour = true loop
            nbValeurPoseTour := false;
         --boucle pour poser les valeur unique (potentiellement en ss prog)
         ligne := 1;
         while ligne <= 9 loop
            colonne := 1;
            while colonne <= 9 loop
               c := construireCoordonnees(ligne, colonne);
               if caseVide(g, c) then
                  e := obtenirSolutionsPossibles(g, c);
                  if nombreChiffres(e) = 1 then
                     v := rechercherSolutionUniqueDansEnsemble(e);
                     fixerChiffre(g, c, v,cpt);
                     nbValeurPoseTour := true;
                     retirerChiffre(e, v);
                     cptCoordonnee := cptCoordonnee + 1;
                     tabCoordonnee(cptCoordonnee) := c;
                     cptEnsemble := cptEnsemble + 1;
                     tabEnsemble(cptEnsemble) := e;
                  end if;
               end if;
               colonne := colonne + 1;
            end loop;
            ligne := ligne + 1;
            end loop;
         end loop;

         --boucle pour lancer le backtracking
         ligne := 1;
         while ligne <= 9 and nbValeurPoseTour = false loop
            colonne := 1;
            while colonne <= 9 and nbValeurPoseTour = false loop
               c := construireCoordonnees(ligne, colonne);
               if caseVide(g, c) then
                  e := obtenirSolutionsPossibles(g, c);
                  if nombreChiffres(e) > 1 then
                     v := plusGrandeValeur(e);
                     fixerChiffre(g, c, v,cpt);
                     nbValeurPoseTour := true;
                     retirerChiffre(e, v);
                     cptCoordonnee := cptCoordonnee + 1;
                     tabCoordonnee(cptCoordonnee) := c;
                     cptEnsemble := cptEnsemble + 1;
                     tabEnsemble(cptEnsemble) := e;
                     ligne2 := ligne;
                     colonne2 := colonne;
                  -- Si il n'y a pas de possibilitées alors on  reviens en arrière jusqu'à notre dernier choix
                  elsif nombreChiffres(e) = 0 then
                     while nombreChiffres(tabEnsemble(cptEnsemble)) = 0 loop
                        viderCase(g, tabCoordonnee(cptCoordonnee));
                        cptEnsemble := cptEnsemble - 1;
                        cptCoordonnee := cptCoordonnee - 1;
                     end loop;
                     viderCase(g, tabCoordonnee(cptCoordonnee));
                     v := plusGrandeValeur(tabEnsemble(cptEnsemble));
                     fixerChiffre(g, tabCoordonnee(cptCoordonnee), v,cpt);
                     nbValeurPoseTour := true;
                     retirerChiffre(tabEnsemble(cptEnsemble), v);
                     ligne := ligne2;
                     colonne := colonne2;
                  end if;
               end if;
               colonne := colonne + 1;
            end loop;
            ligne := ligne + 1;
         end loop;
      end loop;
      trouve := true;
      put(" compteur d'iteration:");
      put(cpt);
      afficherGrille(g);
   end resoudreSudoku;


end resolutions;
