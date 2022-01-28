#! /usr/bin/env racket
#lang racket

(require racket/runtime-path)
(require left-pad)

(define-runtime-path NODE_DIR "_nodes/")

(define (path-remove-extension path)
  (path-replace-extension path #""))

(define (node-path->uid-string path)
  (path->string (path-remove-extension path)))

(define DIGIT_TABLE
  (string->list "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"))

(define BASE
  (length DIGIT_TABLE))

(define (uid-string->int uid)
  (define digits (string->list uid))
  (for/fold ([sum 0]
             [place 1]
             #:result sum)
            ([x (in-list (reverse digits))])
    (values
     (+ sum (* place (index-of DIGIT_TABLE x)))
     (* BASE place))))

(define (int->uid-string ix)
  (do ([digits
        (list)
        (cons (list-ref DIGIT_TABLE (modulo n BASE)) digits)]
       [n ix (quotient n BASE)])
    ((<= n 0)
     (left-pad (list->string digits) 4 "0"))))

(define (node-path->int path)
  (uid-string->int (node-path->uid-string path)))

(define (uid-committed? uid-string)
  (not (string-prefix? uid-string "_")))

(define all-committed-uids
  (filter
   uid-committed?
   (map
    node-path->uid-string
    (directory-list NODE_DIR))))

(define next-uid-string
  (int->uid-string
   (+ 1
      (apply max (map uid-string->int all-committed-uids)))))

(printf "Next node: ~a\n" next-uid-string)
