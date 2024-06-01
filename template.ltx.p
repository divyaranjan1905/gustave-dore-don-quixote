\documentclass{tufte-handout}
\title{◊(print-if (select-from-metas 'title metas) "~a")}
\author{◊(print-if (select-from-metas 'author metas) "~a")}
\date{◊(unless (not (select-from-metas 'doc-publish-date metas)) (pubdate->english (select-from-metas 'doc-publish-date metas)))}  % if the \date{} command is left out, the current date will be used



\begin{document}
\maketitle
◊(require racket/list)
◊(apply string-append (filter string? (flatten doc)))
\end{document}
