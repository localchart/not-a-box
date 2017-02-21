#lang racket/base
(require racket/pretty)

(define primitive-procs
  ;; Register primitives
  (let ([ns (make-base-namespace)])
    (parameterize ([current-namespace ns])
      (namespace-require 'racket/unsafe/ops)
      (namespace-require 'racket/flonum)
      (namespace-require 'racket/fixnum))
    (for/list ([s (in-list (namespace-mapped-symbols ns))]
               #:when (with-handlers ([exn:fail? (lambda (x) #f)])
                        (procedure? (eval s ns))))
      s)))

(call-with-output-file
 "primitive-procs.sls"
 #:exists 'truncate
 (lambda (o)
   (pretty-write
    `(library (primitive-procs)
      (export primitive-proc-list)
      (import (chezscheme))
      (define primitive-proc-list ',(sort primitive-procs symbol<?)))
    o)))