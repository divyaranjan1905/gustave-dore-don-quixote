#lang racket

(require pollen/decode
         pollen/setup
         ;; pollen/html
         pollen/tag
         txexpr)

(provide root)
(provide (all-defined-out))

(module setup racket/base
  (provide (all-defined-out))
  (define poly-targets '(html ltx pdf)))

#|
The function below is used to produce the necessary <root> tag in the X-exp that gets produced which will then take other different tags.

Check Pollen documentation section 7.7:
https://docs.racket-lang.org/pollen/third-tutorial.html#(part._.Decoding_markup_with_a_root_tag_function)
|#

(define (root . elements)
  (case (current-poly-target)
    [(ltx pdf)
     (define first-pass (decode-elements elements
					 #:inline-txexpr-proc (compose1 txt-decode)
					 #:string-proc (compose1 ltx-escape-str smart-quotes smart-dashes)
                                         #:exclude-tags '(script style figure txt-noescape)))
     (make-txexpr 'body null (decode-elements first-pass #:inline-txexpr-proc txt-decode))]

    [else
     (define first-pass (decode-elements elements
                                         #:txexpr-elements-proc decode-paragraphs))
     (make-txexpr 'body null
                  (decode-elements first-pass
                                   #:block-txexpr-proc detect-newthoughts
                                   #:inline-txexpr-proc hyperlink-decoder
                                   #:string-proc (compose1 smart-quotes smart-dashes)
                                   #:exclude-tags '(script style)))]))

#|
Function for links
|#
(define (link url text) `(a ((href ,url)) ,text))

#| Functions for lists |#
(define items (default-tag-function 'ul))
(define item (default-tag-function 'li 'p))


#|
Handle $,% and # properly		; ; ; ; ; ;
|#
(define (ltx-escape-str str)
  (regexp-replace* #px"([$#%&])" str "\\\\\\1"))

#|
We use a smarter way to manage LaTeX code, converting it into a valid X-expression rather than a string. So it allows using other tag functions more smoothly. Joel's solution woks pretty nicely, so we'll be using that. ; ; ; ;
|#

(define (txt-decode xs)
  (if (member (get-tag xs) '(txt txt-noescape))
      (get-elements xs)
      xs))


#|
detect-newthoughts: it is called by the root function above. ; ; ; ; ;
The ◊newthought tag is basically implementing the \newthought command from tufte-latex. ; ; ; ; ;
This is inspired from `try-pollen' repository of Joel Deuck. ; ; ; ; ;
|#

(define (detect-newthoughts block-xpr)
  (define is-newthought? (λ(x) (and (txexpr? x)
                                    (eq? 'span (get-tag x))
                                    (attrs-have-key? x 'class)
                                    (string=? "newthought" (attr-ref x 'class)))))
  (if (and(eq? (get-tag block-xpr) 'p)	; Is it a <p> tag?
          (findf-txexpr block-xpr is-newthought?)) ; Does it contain a <span class="newthought">?
      (attr-set block-xpr 'class "pause-before") ; Add the ‘pause-before’ class
      block-xpr))                                  ; Otherwise return it unmodified


#|
These are the functions that are required to produce particular things (such as blockquote, newthought, figures and so on) in the different outputs. There are conditionals to ensure that the produced output is particular to the format. So for example, in the definition of `blockquote' the function gives `\newthought' command when the `current-poly-target` is LaTeX or PDF and gives the `class=newthought` when the target is html.

Most of these are taken and slightly modified from `try-pollen` Joel Deuck.
|#

(define (p . words)
  (case (current-poly-target)
    [(ltx pdf) `(txt ,@words)]
    [else `(p ,@words)]))

(define (blockquote . words)
  (case (current-poly-target)
    [(ltx pdf) `(txt "\\begin{quote}" ,@words "\\end{quote}")]
    [else `(blockquote ,@words)]))

(define (newthought . words)
  (case (current-poly-target)
    [(ltx pdf) `(txt "\\newthought{" ,@words "}")]
    [else `(span [[class "newthought"]] ,@words)]))

(define (smallcaps . words)
  (case (current-poly-target)
    [(ltx pdf) `(txt "\\smallcaps{" ,@words "}")]
    [else `(span [[class "smallcaps"]] ,@words)]))

(define (∆ . elems)
  (case (current-poly-target)
    [(ltx pdf) `(txt-noescape "$" ,@elems "$")]
    [else `(span "\\(" ,@elems "\\)")]))

(define (center . words)
  (case (current-poly-target)
    [(ltx pdf) `(txt "\\begin{center}" ,@words "\\end{center}")]
    [else `(div [[style "text-align: center"]] ,@words)]))

(define (section title . text)
  (case (current-poly-target)
    [(ltx pdf) `(txt "\\section*{" ,title "}"
                 "\\label{sec:" ,title ,(symbol->string (gensym)) "}"
                 ,@text)]
    [else `(section (h2 ,title) ,@text)]))

(define (index-entry entry . text)
  (case (current-poly-target)
    [(ltx pdf) `(txt "\\index{" ,entry "}" ,@text)]
    [else
      (case (apply string-append text)
        [("") `(a [[id ,entry] [class "index-entry"]])]
        [else `(a [[id ,entry] [class "index-entry"]] ,@text)])]))


;;; This is for figures and sidenotes and the like that come with Tufte styling
(define (numbered-note . text)
    (define refid (number->string (equal-hash-code (car text))))
    (case (current-poly-target)
      [(ltx pdf)
       `(txt "\\footnote{" ,@(latex-no-hyperlinks-in-margin text) "}")]
      [else
        `(@ (label [[for ,refid] [class "margin-toggle sidenote-number"]])
            (input [[type "checkbox"] [id ,refid] [class "margin-toggle"]])
            (span [(class "sidenote")] ,@text))]))

(define (margin-figure source . caption)
    (define refid (number->string (equal-hash-code source)))
    (case (current-poly-target)
      [(ltx pdf)
       `(txt "\\begin{marginfigure}"
             "\\includegraphics{" ,source "}"
             "\\caption{" ,@(latex-no-hyperlinks-in-margin caption) "}"
             "\\end{marginfigure}")]
      [else
        `(@ (label [[for ,refid] [class "margin-toggle"]] 8853)
            (input [[type "checkbox"] [id ,refid] [class "margin-toggle"]])
            (span [[class "marginnote"]] (img [[src ,source]]) ,@caption))]))

(define (margin-note . text)
    (define refid (number->string (equal-hash-code (car text))))
    (case (current-poly-target)
      [(ltx pdf)
       `(txt "\\marginnote{" ,@(latex-no-hyperlinks-in-margin text) "}")]
      [else
        `(@ (label [[for ,refid] [class "margin-toggle"]] 8853)
            (input [[type "checkbox"] [id ,refid] [class "margin-toggle"]])
            (span [[class "marginnote"]] ,@text))]))


(define (figure source #:fullwidth [fullwidth #f] . caption)
  (case (current-poly-target)
    [(ltx pdf)
     (define figure-env (if fullwidth "figure*" "figure"))
     `(txt "\\begin{" ,figure-env "}"
           "\\includegraphics{" ,source "}"
           "\\caption{" ,@(latex-no-hyperlinks-in-margin caption) "}"
           "\\end{" ,figure-env "}")]
    [else (if fullwidth
              ; Note the syntax for calling another tag function, margin-note,
              ; from inside this one. Because caption is a list, we need to use
              ; (apply) to pass the values in that list as individual arguments.
              `(figure [[class "fullwidth"]] ,(apply margin-note caption) (img [[src ,source]]))
              `(figure ,(apply margin-note caption) (img [[src ,source]])))]))

(define (code . text)
  (case (current-poly-target)
    [(ltx pdf) `(txt "\\texttt{" ,@text "}")]
    [else `(span [[class "code"]] ,@text)]))

(define (blockcode . text)
  (case (current-poly-target)
    [(ltx pdf) `(txt "\\begin{verbatim}" ,@text "\\end{verbatim}")]
    [else `(pre [[class "code"]] ,@text)]))

(define (ol . elements)
  (case (current-poly-target)
    [(ltx pdf) `(txt "\\begin{enumerate}" ,@elements "\\end{enumerate}")]
    [else `(ol ,@elements)]))

(define (ul . elements)
  (case (current-poly-target)
    [(ltx pdf) `(txt "\\begin{itemize}" ,@elements "\\end{itemize}")]
    [else `(ul ,@elements)]))

(define (li . elements)
  (case (current-poly-target)
    [(ltx pdf) `(txt "\\item " ,@elements)]
    [else `(li ,@elements)]))

(define (sup . text)
  (case (current-poly-target)
    [(ltx pdf) `(txt "\\textsuperscript{" ,@text "}")]
    [else `(sup ,@text)]))


(define (grey . text)
  (case (current-poly-target)
    [(ltx pdf) `(txt "\\textcolor{gray}{" ,@text "}")]
    [else `(span [[style "color: #777"]] ,@text)]))


;; This is for hyperlinks
(define (latex-no-hyperlinks-in-margin txpr)
  ; First define a local function that will transform each ◊hyperlink
  (define (cleanlinks inline-tx)
      (if (eq? 'hyperlink (get-tag inline-tx))
        `(txt ,@(cdr (get-elements inline-tx))
              ; Return the text with the URI in parentheses
              " (\\url{" ,(ltx-escape-str (car (get-elements inline-tx))) "})")
        inline-tx)) ; otherwise pass through unchanged
  ; Run txpr through the decode-elements wringer using the above function to
  ; flatten out any ◊hyperlink tags
  (decode-elements txpr #:inline-txexpr-proc cleanlinks))

(define (hyperlink-decoder inline-tx)
  (define (hyperlinker url . words)
    (case (current-poly-target)
      [(ltx pdf) `(txt "\\href{" ,url "}" "{" ,@words "}")]
      [else `(a [[href ,url]] ,@words)]))

  (if (eq? 'hyperlink (get-tag inline-tx))
      (apply hyperlinker (get-elements inline-tx))
      inline-tx))

#|
From Joel Deuck's `try-pollen`:
Just because we can, here's a tag function for typesetting the LaTeX logo
in both HTML and (obv.) LaTeX.
|#
(define (Latex)
  (case (current-poly-target)
    [(ltx pdf)
     `(txt "\\LaTeX\\xspace")]      ; \xspace adds a space if the next char is not punctuation
    [else `(span [[class "latex"]]
                 "L"
                 (span [[class "latex-sup"]] "a")
                 "T"
                 (span [[class "latex-sub"]] "e")
                 "X")]))

; In HTML the <i> and <em> tags won't look much different. But when outputting to
; LaTeX, ◊i will italicize multiple blocks of text, where ◊emph should be
; used for words or phrases that are intended to be emphasized. In LaTeX,
; if the surrounding text is already italic then the emphasized words will be
; non-italicized.
;   A similar approach is offered for boldface text.
;
(define (i . text)
  (case (current-poly-target)
    [(ltx pdf) `(txt "{\\itshape " ,@text "}")]
    [else `(i ,@text)]))

(define (emph . text)
  (case (current-poly-target)
    [(ltx pdf) `(txt "\\emph{" ,@text "}")]
    [else `(em ,@text)]))

(define (b . text)
  (case (current-poly-target)
    [(ltf pdf) `(txt "{\\bfseries " ,@text "}")]
    [else `(b ,@text)]))

(define (strong . text)
  (case (current-poly-target)
    [(ltx pdf) `(txt "\\textbf{" ,@text "}")]
    [else `(strong ,@text)]))

#|

I'm going to need something for verses and poetry too, and Joel has got this covered as *
|#
(define verse
    (lambda (#:title [title ""] #:italic [italic #f] . text)
     (case (current-poly-target)
      [(ltx pdf)
       (define poem-title (if (non-empty-string? title)
                              (apply string-append `("\\poemtitle{" ,title "}"))
                              ""))

       ; Replace double spaces with "\vin " to indent lines
       (define poem-text (string-replace (apply string-append text) "  " "\\vin "))

       ; Optionally italicize poem text
       (define fmt-text (if italic (format "{\\itshape ~a}" (latex-poem-linebreaks poem-text))
                                   (latex-poem-linebreaks poem-text)))

       `(txt "\n\n" ,poem-title
             "\n\\settowidth{\\versewidth}{"
             ,(longest-line poem-text)
             "}"
             "\n\\begin{verse}[\\versewidth]"
             ,fmt-text
             "\\end{verse}\n\n")]
      [else
        (define pre-attrs (if italic '([class "verse"] [style "font-style: italic"])
                                     '([class "verse"])))
        (define poem-xpr (if (non-empty-string? title)
                             `(pre ,pre-attrs
                                   (p [[class "poem-heading"]] ,title)
                                   ,@text)
                             `(pre ,pre-attrs
                                   ,@text)))
        `(div [[class "poem"]] ,poem-xpr)])))

(define (longest-line str)
  (first (sort (string-split str "\n")
               (λ(x y) (> (string-length x) (string-length y))))))

(define (latex-poem-linebreaks text)
  (regexp-replace* #px"([^[:space:]])\n(?!\n)" ; match newlines that follow non-whitespace
                                               ; and which are not followed by another newline
                   text
                   "\\1 \\\\\\\\\n"))
