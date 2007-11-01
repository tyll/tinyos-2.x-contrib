; build - builds the scheme code of a module injection to 
;   statically compile into the SensorScheme runtime

(require   "sensor-net.scm" "modules.scm" "symmap.scm"
           (only (lib "1.ss" "srfi") take drop)
           (only (lib "13.ss" "srfi") string-drop-right string-contains string-reverse)
           (lib "pretty.ss" "mzlib"))
(require (lib "cmdline.ss"))


; first some defines that are in fact configuration values, 
; will become program parameters later.
(define base-config "../sensorscheme/configurations/default.bcf")
(define code-module "radioblink-test.scm")
(define app-dir "../../../apps/SensorSchemeApp")

(define out-config #f)

; then get the config files loaded in
(define-values (all symmap) (read-base-conf base-config (empty-symmap)))


(define (serial-recv line)
  (define (string->byte-list s)
    (if (> (string-length s) 1)
        (cons (string->number (string-take s 2) 16) (string->byte-list (string-drop s 2)))
        '()))
  (printf "received line: ~s~n" line)
  (string->byte-list line))

(define (make-c-const string)
  (define (byte-const byte)
    (string-append "0x" 
                   (let ((s (number->string byte 16)))
                     (if (= (string-length s) 1) (string-append "0" s) s)) 
                   ", "))
  (define (bytes-split byte-list n)
    (if (> (length byte-list) n) 
        (cons (take byte-list n) (bytes-split (drop byte-list n) n))
        (list byte-list)))
  
  (string-append 
   "#ifndef INITMESSAGE_H\n#define INITMESSAGE_H\n\nconst uint16_t initSize = "
   (number->string (+ (length string) 1))
   ";\nconst uint8_t  initMessage[] = {0xC0, \n"
   (string-drop-right (apply string-append (map (lambda (s) (string-append "        " (apply string-append (map byte-const s)) "\n")) (bytes-split string 8))) 3) "};\n\n#endif\n"))


(define (main cmdline)
  (command-line (car cmdline) (cdr cmdline)
                (once-each 
                 [("-b" "--base") l-base-config "the base config file" 
                                  (set! base-config l-base-config)]
                 [("-m" "--module") l-code-module "the module to include in the new config" 
                                    (set! code-module l-code-module)]
                 [("-a" "--appdir") l-app-dir "the directory where the TinyOS app resides" 
                                   (set! app-dir l-app-dir)]
                 [("-o" "--out") l-out-config "the file to output the built configuration" 
                                 (set! out-config l-out-config)]))
  
  (set! out-config (string-append (string-drop-right 
                                   base-config 
                                   (+ 1 (string-contains (string-reverse base-config) ".")))
                                  "-"
                                  (string-drop-right
                                   code-module 
                                   (+ 1 (string-contains (string-reverse code-module) ".")))
                                  ".bcf"))
  (printf "base-config: ~a~ncode-module: ~a~napp-dir: ~a~nout-config: ~a~n" 
          base-config code-module app-dir out-config)
  (let-values (((code-lines new-cache) (select-module code-module all)))
    (let ((code `(eval-handler ((%lambda% () ,@code-lines)))))
      (with-output-to-file (string-append app-dir "/InitMessage.h")
        ; code to compile into binary image
        (lambda () (display (make-c-const (net-encode code symmap)))) 'replace)
      (with-output-to-file (string-append app-dir "/InitMessage.scm")
        ; simulation version
        (lambda () (pretty-print code)) 'replace)
      (with-output-to-file out-config 
        ; build message with injector and code
        (lambda () (pretty-print (build-base-conf new-cache symmap))) 'replace))))

;(main (cons (path->string program) (current-command-line-arguments)))
