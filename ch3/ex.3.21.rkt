#lang racket/base

(define (front-ptr queue) (mcar queue))
(define (rear-ptr queue) (mcdr queue))
(define (set-front-ptr! queue item) (set-mcar! queue item))
(define (set-rear-ptr! queue item) (set-mcdr! queue item))
(define (empty-queue? queue) (null? (front-ptr queue)))
(define (make-queue) (mcons '() '()))

(define (front-queue queue)
  (if (empty-queue? queue)
      (error "FRONT called with an empty queue" queue)
      (mcar (front-ptr queue))))

(define (insert-queue! queue item)
  (let ([new-pair (mcons item '())])
    (cond [(empty-queue? queue)
           (set-front-ptr! queue new-pair)
           (set-rear-ptr! queue new-pair)
           queue]
          [else
           (set-mcdr! (rear-ptr queue) new-pair)
           (set-rear-ptr! queue new-pair)
           queue])))

(define (delete-queue! queue)
  (cond [(empty-queue? queue)
         (error "DELETE! called with an empty queue" queue)]
        [else
         (set-front-ptr! queue (mcdr (front-ptr queue)))
         queue]))

(define (print-queue queue)
  (display "(queue ")

  (define (iter n)
    (if (eq? n (rear-ptr queue))
        (display (mcar n))
        (begin (display (mcar n))
               (display " ")
               (iter (mcdr n)))))
  (when (not (empty-queue? queue))
    (iter (front-ptr queue)))
  (display ")"))

(module+ test
  (require support/testing)

  (define q1 (make-queue))

  (check-output
   (lines "(queue a)"
          "(queue a b)"
          "(queue b)"
          "(queue )")
   (print-queue (insert-queue! q1 'a)) (newline)
   (print-queue (insert-queue! q1 'b)) (newline)
   (print-queue (delete-queue! q1)) (newline)
   (print-queue (delete-queue! q1)) (newline)))