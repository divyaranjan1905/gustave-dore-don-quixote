# Gustave Doré's Illustrated _Don Quixote_
--------------------------------------------

## The Idea of the Project
This project is an attempt to republish Don Quixote with illustrations by Gustave Doré with good typography.

The book would be published both as a readable webpage (a web-book), Kindle-ready EPUB3 and as a printable PDF.  The goal is to achieve good typography in all the aforementioned formats without having to do extra work in porting, and this is achieved by means of using a markup-language by Matthew Butterick, called [Pollen](https://docs.racket-lang.org/pollen/). It is rather a DSL (Domain-Specific Language) based on Racket, which allows you to introduce programmable capacity into your text without having to deal with any overhead. One can access all of Racket, while still writing HTML, Markdown, or TeX as one likes.

The particular translation we would be using is the John Ormsby translation that is under public domain at the [Project Gutenberg](https://www.gutenberg.org/ebooks/996). The illustrations in the `image/` directory are also extracted from the same source.

## Goals
The goals of this project are the following:

- Bring better typography to the classic
- Keep the reading experience consistent across formats and mediums

To achieve the above, we use the magic of Pollen where "the book is a program" and can be configured according to your imagination while still being consistently ported in the desired formats.

## Inspirations

A direct inspiration for taking such an approach were the projects that have been produced using Pollen, primarily Matthew's books such as [_Beautiful Racket_](https://beautifulracket.com/) and [_Practical Typography_](https://practicaltypography.com/). The "publishing nerd" [Joel Duck's](https://joeldueck.com/) [_Secretary of Foreign Relations_](https://thelocalyarn.com/excursus/secretary/) was also a constant source of learning how to implement some basic things using Pollen. Moreover, his essay on web books titled [_The Unbearable Lightness of Web Pages_](https://thelocalyarn.com/excursus/secretary/posts/web-books.html) is worth reading even if you have no interest in Pollen.

In a less direct manner, other websites and books have influenced me quite a lot over the time in pushing me towards improving what I can do in my texts and websites. Gwern Branwen's [personal site](https://gwern.net/) has always been a source of awe and inspiration. Of course, I cannot help but acknowledge the influence from [Edward Tufte](https://www.edwardtufte.com/), this project's initial design was derived primarily from [tufte-css](https://github.com/edwardtufte/tufte-css).

Making entire books as websites has always been interesting to me, provided they aren't just heavy-JS loaded webpages with little typographical consideration. Books that are well-designed bring a lot of influence to the reader, and considering we spend a big chunk of our time on the web, we should try to make the experience of that better. And in this, I have formed a 'classical' (maybe Medieval?) taste in how books should be designed. Here are some of those books that have helped me in developing that taste:

- Richard Rutter's [_Web Typography_](https://book.webtypography.net/)
- Robert Bringhurt's [_The Elements of Typographic Style_](https://typographica.org/typography-books/the-elements-of-typographic-style-4th-edition/)
- Glenn Elert's [_Hypertexbook_](https://hypertextbook.com/)
- Dan & Joseph's [_Interactive Linear Algebra_](https://textbooks.math.gatech.edu/ila/)
- [The Stacks Project](https://stacks.math.columbia.edu/)
- Donald Knuth's [_Digital Typography_](https://www-cs-faculty.stanford.edu/~knuth/dt.html)
- Works of Leonardo da Vinci, and in particular this implementation of [_Codex Atlanticus_](https://codex-atlanticus.ambrosiana.it/#/)
- Works of [Nicholas Rougeux](https://www.c82.net/), in particular [_Werner's Nomenclature of Colours_](https://www.c82.net/work?id=371), [_Byrne's Euclid_](https://www.c82.net/work?id=372) and the [_Iconographic Encylopaedia_](https://www.c82.net/work?id=388)
- Paul Regnard's [_Iconographie photographique de la Salpêtrière : service de M. Charcot_](https://archive.org/details/b21912865_0001/) and the later rendition by Didi-Huberman, [_Invention of Hysteria_](https://mitpress.mit.edu/9780262541800/invention-of-hysteria/)
- Edward Brooke-Hitching's [_The Madman's Library_](https://www.goodreads.com/book/show/55278284-the-madman-s-library)
- Jeremy Keith's [_Resilient Web Design_](https://resilientwebdesign.com/)

## Licensing

All of the code in this repository is licensed under GPLv3 or above. The copy of Don Quixote itself is in public domain, and our new rendition of it shall be accessible digitally and in print under [CC BY-SA 4.0](https://creativecommons.org/licenses/by-sa/4.0/). This ensures free usage of the material, both the code and the finally produced book, for commercial and non-commercial uses as long as the required credit has been provided and the adaptations are also shared under the same license.

### Fonts

All the fonts that are used for the project, whether in web or in produced PDFs, are libre fonts licensed under OpenFontLicense or something similar. Check the directory of each font under `fonts/` to find the license copy for each of them respectively.
