;abstract Points or vectors
(define make-vect cons)
(define xcor car)
(define ycor cdr)

;abstract line segments
(define make-segment list)
(define start-segment first)
(define end-segment second)

;add(+) between vectors
(define (+vect v1 v2)
  (make-vect (+ (xcor v1) (xcor v2))
             (+ (ycor v1) (ycor v2))))

;change scale of vector
(define (scale-vect v factor)
  (make-vect (* factor (xcor v))
             (* factor (ycor v))))

;sub(-) between vectors
(define (-vect v1 v2)
  (+vect v1 (scale-vect v2 -1)))

;rotate vector
(define (rotate-vect v angle)
  (let ((c (cos angle))
        (s (sin angle)))
    (make-vect (- (* c (xcor v))
                  (* s (ycor v)))
               (+ (* c (ycor v))
                  (* s (xcor v)))))) 

;=== generate frame ===
;rectangle
(define make-rectangle list)
(define origin first)
(define x-axis second)
(define y-axis third)

;procedure drawing some point in a rectangle
(define (coord-map rect)
  (lambda (p)
    (+vect (origin rect)
           (+vect (scale-vect (x-axis rect) (xcor p))
                  (scale-vect (y-axis rect) (ycor p)))
           )
    ))

;picture abstraction
(define (make-picture seglist)
  (lambda (rect dc)
    (for-each
     (lambda (segment)
       (let* ((b (start-segment segment))
              (e (end-segment segment))
              (m (coord-map rect))
              (b2 (m b))
              (e2 (m e)))
         (send dc draw-line (xcor b2) (ycor b2)
                    (xcor e2) (ycor e2))))
         seglist)))

;define all points of George
(define p1 (make-vect .25 0))
(define p2 (make-vect .35 .5))
(define p3 (make-vect .3 .6))
(define p4 (make-vect .15 .4))
(define p5 (make-vect 0 .65))
(define p6 (make-vect .4 0))
(define p7 (make-vect .5 .3))
(define p8 (make-vect .6 0))
(define p9 (make-vect .75 0))
(define p10 (make-vect .6 .45))
(define p11 (make-vect 1 .15))
(define p12 (make-vect 1 .35))
(define p13 (make-vect .75 .65))
(define p14 (make-vect .6 .65))
(define p15 (make-vect .65 .85))
(define p16 (make-vect .6 1))
(define p17 (make-vect .4 1))
(define p18 (make-vect .35 .85))
(define p19 (make-vect .4 .65))
(define p20 (make-vect .3 .65))
(define p21 (make-vect .15 .6))
(define p22 (make-vect 0 .85))

(define george-lines
  (list (make-segment p1 p2)
        (make-segment p2 p3)
        (make-segment p3 p4)
        (make-segment p4 p5)
        (make-segment p6 p7)
        (make-segment p7 p8)
        (make-segment p9 p10)
        (make-segment p10 p11)
        (make-segment p12 p13)
        (make-segment p13 p14)
        (make-segment p14 p15)
        (make-segment p15 p16)
        (make-segment p17 p18)
        (make-segment p18 p19)
        (make-segment p19 p20)
        (make-segment p20 p21)
        (make-segment p21 p22)))


;make george and frame
(define george (make-picture george-lines))
(define origin1 (make-vect 0 0))
(define x-axis1 (make-vect 300 0))
(define y-axis1 (make-vect 0 300))
(define frame1
  (make-rectangle origin1
                  x-axis1
                  y-axis1))

;*** example: basic george ***
;(george frame1)

;=== operations on pictures (rotate, together, flip ..) ===
;auxilliary function(repeat)
(define (repeated f n)
  (if (= n 0)
      f
      (compose
       f (repeated f (- n 1)))))

(define (rotate90 pict)
  (lambda (rect dc)
    (pict (make-rectangle
           (+vect (origin rect)
                  (x-axis rect))
           (y-axis rect)
           (scale-vect (x-axis rect) -1))
          dc)))
(define rotate180 (repeated rotate90 1))

;overlapping two images
(define (together pict1 pict2)
  (lambda (rect dc)
    (pict1 rect dc)
    (pict2 rect dc)))

;*** example: together george ***
;((together george (rotate90 george)) frame1)

;draw two pictures of specific size(=a) next to each other
(define (beside pict1 pict2 a)
  (lambda (rect dc)
    (pict1
     (make-rectangle
      (origin rect)
      (scale-vect (x-axis rect) a)
      (y-axis rect))
     dc)
    (pict2
     (make-rectangle
      (+vect
       (origin rect)
       (scale-vect (x-axis rect) a))
      (scale-vect (x-axis rect) (- 1 a))
      (y-axis rect))
     dc)))

;stack the images vertically
(define (above pict1 pict2 a)
  ((repeated rotate90 0)
   (beside ((repeated rotate90 2) pict1)
           ((repeated rotate90 2) pict2)
           a)))


;*** exapmle : big brother ***
(define empty-picture (make-picture []))
(define big-brother
  (beside george
          (above empty-picture george .5)
          .5))

;flip picture
(define (flip pict)
  (lambda (rect dc)
    (pict (make-rectangle
           (+vect (origin rect) (x-axis rect))
           (scale-vect (x-axis rect) -1)
           (y-axis rect))
          dc)))

;*** example : acrobats ***
(define acrobats
  (beside george
          (rotate180 (flip george))
          .5))

;*** example : 4bats ***
(define 4bats
  (above acrobats
         (flip acrobats)
         .5))

;recursive combinations of pictures
;recursive upwards (n:Number of repetitions)
(define (up-push pict n)
  (if (= n 0)
      pict
      (above (up-push pict (- n 1)) pict .25)))

;recursive to right (n:Number of repetitions)
(define (right-push pict n)
  (if (= n 0)
      pict
      (beside pict
              (right-push pict (- n 1))
              .75)))

;recursive to corner (n:Number of repetitions)
;(define (corner-push pict n)
;  (if (= n 0)
;      pict
;      (let* ((top (beside (up-push pict n)
;                          (corner-push pict (- n 1))
;                          .75))
;             (bot (beside pict
;                          (right-push pict (- n 1))
;                          .75)))
;        (above bot top .25))))
(define (corner-push pict n)
  (if (= n 0)
      pict
      (above
       (beside
        (up-push pict n)
        (corner-push pict (- n 1))
        .75)
       (beside
        pict
        (right-push pict (- n 1))
        .75)
       .25)))
  

;*** example : corner-push 2-times with 4bats ***
(define (4pict p1 r1 p2 r2 p3 r3 p4 r4)
  (beside
   (above
    ((repeated rotate90 r1) p1)
    ((repeated rotate90 r2) p2)
    .5)
   (above
    ((repeated rotate90 r3) p3)
    ((repeated rotate90 r4) p4)
    .5)
   .5))
(define (4same p r1 r2 r3 r4)
  (4pict p r1 p r2 p r3 p r4))

;*** example : 4 pictures ***
;(4same george 0 1 2 3)

(define (square-limit pict n)
  (4same (corner-push pict n)
         2 1 3 0))

;*** example : square limit
;(square-limit 4bats 2)

;=== floating frame ===
;making frame window, canvas(paper) and DC(divice context)
(define frame (new frame% [label "Paint Language Example"]
                   [width 300]
                   [height 330]))
(define canvas (new canvas% [parent frame]
                    [paint-callback
                     (lambda (canvas dc)
                       (send dc set-pen red-pen)
                       (send dc set-brush no-brush)
                       (on-paint))]))
(define red-pen (make-object pen% "RED" 2 'solid)) ;color, bold, shape-line
(define no-brush (make-object brush% "Black" 'transparent))
(define dc (send canvas get-dc))


;=== test george ===
(define george (rotate180 (flip george)))
; together
(define friend (together george (rotate90 george)))
;big brother
(define friend
  (beside george
          (above george empty-picture .5)
          .5))
;acrobats
(define friend
  (beside george
          (rotate180 (flip george))
          .5))
;4bats
(define friend (above friend (flip friend) .5))
(define 4bats friend)

;up-push
(define friend (up-push george 2))

;right-push
(define friend (right-push george 2))

;corner-push
(define friend (corner-push 4bats 2))

;4same george
(define friend (4same george 0 1 2 3))

;square-limit george
(define friend (square-limit 4bats 2))

;define callback paint procedure
(define (on-paint) (friend frame1 dc))
;(define (on-paint) ((rotate180 (flip friend)) frame1 dc))

;making the frame visible
(send frame show #t)
                            
                   


