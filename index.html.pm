#lang pollen

◊(define-meta title "Don Quixote")
◊(define-meta author "Miguel de Cervantes Saavedra")
◊(define-meta template "template-index.html")

◊main{
	◊div[#:class "cover"]{
		       ◊div[#:class "cover-bg"]{}
		       ◊div[#:class "cover-overlay"]{
					◊p{◊i{The Ingenious Gentleman,}}
					◊h1{◊span[#:class "initials"]{D}ON ◊span[#:class "initials"]{Q}UIXOTE}
		       		    	◊span[#:class "subtitle"]{◊i{Of} ◊i{La Mancha}}}
					◊a[#:href "./chapters/toc.html" #:class "link"]{
					◊button[#:type "button" #:class "cover-read-btn"]{Read}}}

	◊div[#:class "gustave-dore"]{
			 ◊div[#:class "cover"]{
			 ◊img[#:src "img/cover.jpg" #:class "img"]{}}

			 ◊h2{Reviving Don Quixote}

			 ◊p{Cervantes' classic tale has enchanted everyone for over centuries, but arguably among the most enchanted was Gustave Doré. Thus, the most celebrated illustrator of 19th century provided us with the most ◊i{definitive} visuals for ◊i{Don Quixote}. This revisualized edition of Doré attempts to revive those marvellous illustrations and provide the book with the typography that it deserves.}

	}

}
