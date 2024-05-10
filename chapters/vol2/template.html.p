<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8"/>
    <title>◊(hash-ref metas 'title)</title>
    ◊; To use paths a bit smoothly
    ◊(define path-prefix (if (string-contains (symbol->string here) "/") "../../" ""))

    <link rel="stylesheet" type="text/css" href="◊|path-prefix|css/tufte.css"/>
    <meta name="viewport" content="width=device-width, initial-scale=1">
  </head>

  <body>◊(->html doc #:splice? #t)
    ◊(define prev-page (previous here))
    ◊when/splice[prev-page]{
    <div id="prev">← <a href="◊|prev-page|">◊(select 'h1 prev-page)</a></div>}
    ◊(define next-page (next here))
    ◊when/splice[next-page]{
    <div id="next"><a href="◊|next-page|">◊(select 'h1 next-page)</a> →</div>}
  </body>
</html>
