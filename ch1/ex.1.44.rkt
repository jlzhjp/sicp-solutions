#lang racket/base

(provide smooth)

(require "../common.rkt")

(define dx 0.1)

(define (smooth f)
  (lambda (x)
    (average (f (- x dx))
             (f x)
             (f (+ x dx)))))

(module+ test)