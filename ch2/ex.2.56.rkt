#lang racket/base

(define (variable? x) (symbol? x))

(define (same-variable? v1 v2)
  (and (variable? v1) (variable? v2) (eqv? v1 v2)))

(define (=number? exp num) (and (number? exp) (= exp num)))

(define (make-sum a1 a2)
  (cond [(=number? a1 0) a2]
        [(=number? a2 0) a1]
        [(and (number? a1) (number? a2)) (+ a1 a2)]
        [else (list '+ a1 a2)]))

(define (make-product m1 m2)
  (cond [(or (=number? m1 0) (=number? m2 0)) 0]
        [(=number? m1 1) m2]
        [(=number? m2 1) m1]
        [(and (number? m1) (number? m2)) (* m1 m2)]
        [else (list '* m1 m2)]))

(define (make-exponentiation b n)
  (cond [(=number? n 0) 0]
        [(=number? n 1) b]
        [else (list '^ b n)]))

(define (sum? x) (and (pair? x) (eqv? (car x) '+)))

(define (addend s) (cadr s))

(define (augend s) (caddr s))

(define (product? x) (and (pair? x) (eqv? (car x) '*)))

(define (multiplier p) (cadr p))

(define (multiplicand p) (caddr p))

(define (exponentiation? x) (and (pair? x) (eqv? (car x) '^)))

(define (base exp) (cadr exp))

(define (exponent exp) (caddr exp))

(define (deriv exp var)
  (cond [(number? exp) 0]
        [(variable? exp)
         (if (same-variable? exp var) 1 0)]
        [(sum? exp)
         (make-sum (deriv (addend exp) var)
                   (deriv (augend exp) var))]
        [(product? exp)
         (make-sum (make-product (multiplier exp)
                                 (deriv (multiplicand exp) var))
                   (make-product (deriv (multiplier exp) var)
                                 (multiplicand exp)))]
        [(exponentiation? exp)
         (make-product (make-product (exponent exp)
                                     (make-exponentiation (base exp)
                                                          (- (exponent exp) 1)))
                       (deriv (base exp) var))]
        [else (error "unknown expression type -- DERIV" exp)]))

(module+ test
  (require rackunit)

  (check-equal? (deriv '(+ x 3) 'x) 1)
  (check-equal? (deriv '(* x y) 'x) 'y)
  (check-equal? (deriv '(* (* x y) (+ x 3)) 'x) '(+ (* x y) (* y (+ x 3))))
  (check-equal? (deriv '(^ (+ (* 2 x) 1) 2) 'x) '(* (* 2 (+ (* 2 x) 1)) 2)))