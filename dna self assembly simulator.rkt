#lang typed/racket

(define-type Glue Symbol) ; Création d'un type Glue qui est un Symbol
(define-type TileColor Symbol) ; Création d'un type TileColor qui est un Symbol

; TYPE DE TUILE
(struct kindoftile ([glue-north : Glue] 
                   [glue-east : Glue]
                   [glue-south : Glue]
                   [glue-west : Glue]
                   [tile-color : TileColor]
                   [position : Integer]) 

#:transparent)
; STRUCTURE D'UNE TUILE
(struct tile ([kind : kindoftile] ; Structure d'une tuile
              [x : Integer]
              [y : Integer]
              [rotation : Integer] ; rotation de la position des glues : 0 = 0° ; 1 = 90° ; 2 = 180° ; 3 = 270° ; Ajouter les rotations miroirs
              )

#:transparent)
; DÉFINITION DU TYPE DE TUILE GRAINE
(define seed-kind (kindoftile 'a 'a 'a 'a 'SEED 0))
; DÉFINITION DU TYPE DE TUILE À ASSEMBLER (POUSSE)
(define sprout-kind (kindoftile 'a 'a 'a 'a 'SPROUT 0))

; CRÉATION DE L'ASSEMBLAGE GRAINE
(define seed-assembly (for/list ([i (in-range 3)]) ; création d'un assemblage linéaire
               : (Listof tile) 
               (tile seed-kind 0 i 0))) 

; AFFICHAGE DE L'ASSEMBLAGE GRAINE
(displayln "ASSEMBLAGE GRAINE : ")

(for ([elem seed-assembly])
  (displayln elem))
 
; ROTATION
(: rotation (-> kindoftile (Listof kindoftile)))
(define (rotation k)
  (define n (kindoftile-glue-north k))
  (define e (kindoftile-glue-east k))
  (define s (kindoftile-glue-south k))
  (define w (kindoftile-glue-south k))
  (define col (kindoftile-tile-color k))
  (list
   (kindoftile n e s w col 0)
   (kindoftile w n e s col 90)
   (kindoftile s w n e col 180)
   (kindoftile e s w n col 270)
   (kindoftile n w s e col 1)
   (kindoftile s e n w col 2)
   ))
(define sproutkindlist1 (rotation sprout-kind))

; DISPONIBILITÉ D'UNE POSITIONS

;MATCH 
(define (match-tile [tile : tile] [t : kindoftile])
  (append
   (if
   (equal? (kindoftile-glue-north (tile-kind tile)) (kindoftile-glue-south t)) (list (list (tile-x tile) (+ (tile-y tile) 1) (kindoftile-position t) ))  (list ) )
   (if
   (equal? (kindoftile-glue-south (tile-kind tile)) (kindoftile-glue-north t)) (list (list (tile-x tile)  (- (tile-y tile) 1) (kindoftile-position t) ))  (list ) )
   (if
   (equal? (kindoftile-glue-west (tile-kind tile)) (kindoftile-glue-east t)) (list (list (- (tile-x tile) 1)  (tile-y tile) (kindoftile-position t) ))  (list ) )
   (if
   (equal? (kindoftile-glue-east (tile-kind tile)) (kindoftile-glue-west t)) (list (list (+ (tile-x tile) 1) (tile-y tile) (kindoftile-position t) ))  (list ) )

  )
 )

;POSITIONS PROPOSÉES
(define proposed
  (apply append
         (for*/list ([elem seed-assembly]
                     [elem1 sproutkindlist1])
           : (Listof (Listof (Listof Integer)))
           ;faire une liste de kindoftile et matcher les élements de elem avec tous les éléments de la liste kindoftile
           (match-tile elem elem1)
           )))

; POSITOIONS OCCUPÉES
(define occupied (for/list ([elem seed-assembly])
                   : (Listof (Listof Integer))
                   (list (tile-x elem) (tile-y elem) )
            ))

; POSITIONS VALIDES
(define valid(for/list : (Listof (Listof Integer))

          ([valid proposed]

       #:unless (member valid occupied))
  valid))
(displayln " ");  mis en forme de la sortie
(displayln "Positions où peut-être placée la tuile pousse :")
(displayln valid)

(display "bonjour")