// Some definitions presupposed by pandoc's typst output.
#let blockquote(body) = [
  #set text( size: 0.92em )
  #block(inset: (left: 1.5em, top: 0.2em, bottom: 0.2em))[#body]
]

#let horizontalrule = [
  #line(start: (25%,0%), end: (75%,0%))
]

#let endnote(num, contents) = [
  #stack(dir: ltr, spacing: 3pt, super[#num], contents)
]

#show terms: it => {
  it.children
    .map(child => [
      #strong[#child.term]
      #block(inset: (left: 1.5em, top: -0.4em))[#child.description]
      ])
    .join()
}

// Some quarto-specific definitions.

#show raw.where(block: true): block.with(
    fill: luma(230), 
    width: 100%, 
    inset: 8pt, 
    radius: 2pt
  )

#let block_with_new_content(old_block, new_content) = {
  let d = (:)
  let fields = old_block.fields()
  fields.remove("body")
  if fields.at("below", default: none) != none {
    // TODO: this is a hack because below is a "synthesized element"
    // according to the experts in the typst discord...
    fields.below = fields.below.amount
  }
  return block.with(..fields)(new_content)
}

#let empty(v) = {
  if type(v) == "string" {
    // two dollar signs here because we're technically inside
    // a Pandoc template :grimace:
    v.matches(regex("^\\s*$")).at(0, default: none) != none
  } else if type(v) == "content" {
    if v.at("text", default: none) != none {
      return empty(v.text)
    }
    for child in v.at("children", default: ()) {
      if not empty(child) {
        return false
      }
    }
    return true
  }

}

#show figure: it => {
  if type(it.kind) != "string" {
    return it
  }
  let kind_match = it.kind.matches(regex("^quarto-callout-(.*)")).at(0, default: none)
  if kind_match == none {
    return it
  }
  let kind = kind_match.captures.at(0, default: "other")
  kind = upper(kind.first()) + kind.slice(1)
  // now we pull apart the callout and reassemble it with the crossref name and counter

  // when we cleanup pandoc's emitted code to avoid spaces this will have to change
  let old_callout = it.body.children.at(1).body.children.at(1)
  let old_title_block = old_callout.body.children.at(0)
  let old_title = old_title_block.body.body.children.at(2)

  // TODO use custom separator if available
  let new_title = if empty(old_title) {
    [#kind #it.counter.display()]
  } else {
    [#kind #it.counter.display(): #old_title]
  }

  let new_title_block = block_with_new_content(
    old_title_block, 
    block_with_new_content(
      old_title_block.body, 
      old_title_block.body.body.children.at(0) +
      old_title_block.body.body.children.at(1) +
      new_title))

  block_with_new_content(old_callout,
    new_title_block +
    old_callout.body.children.at(1))
}

#show ref: it => locate(loc => {
  let target = query(it.target, loc).first()
  if it.at("supplement", default: none) == none {
    it
    return
  }

  let sup = it.supplement.text.matches(regex("^45127368-afa1-446a-820f-fc64c546b2c5%(.*)")).at(0, default: none)
  if sup != none {
    let parent_id = sup.captures.first()
    let parent_figure = query(label(parent_id), loc).first()
    let parent_location = parent_figure.location()

    let counters = numbering(
      parent_figure.at("numbering"), 
      ..parent_figure.at("counter").at(parent_location))
      
    let subcounter = numbering(
      target.at("numbering"),
      ..target.at("counter").at(target.location()))
    
    // NOTE there's a nonbreaking space in the block below
    link(target.location(), [#parent_figure.at("supplement") #counters#subcounter])
  } else {
    it
  }
})

// 2023-10-09: #fa-icon("fa-info") is not working, so we'll eval "#fa-info()" instead
#let callout(body: [], title: "Callout", background_color: rgb("#dddddd"), icon: none, icon_color: black) = {
  block(
    breakable: false, 
    fill: background_color, 
    stroke: (paint: icon_color, thickness: 0.5pt, cap: "round"), 
    width: 100%, 
    radius: 2pt,
    block(
      inset: 1pt,
      width: 100%, 
      below: 0pt, 
      block(
        fill: background_color, 
        width: 100%, 
        inset: 8pt)[#text(icon_color, weight: 900)[#icon] #title]) +
      block(
        inset: 1pt, 
        width: 100%, 
        block(fill: white, width: 100%, inset: 8pt, body)))
}


#let script-size = 7.97224pt
#let footnote-size = 8.50012pt
#let small-size = 9.24994pt
#let normal-size = 10.00002pt
#let large-size = 11.74988pt

// This function gets your whole document as its `body` and formats
// it as an article in the style of the American Mathematical Society.
#let ams-article(
  // The article's title.
  title: "Paper title",

  // An array of authors. For each author you can specify a name,
  // department, organization, location, and email. Everything but
  // but the name is optional.
  authors: (),

  // Your article's abstract. Can be omitted if you don't have one.
  abstract: none,

  // The article's paper size. Also affects the margins.
  paper-size: "us-letter",

  // The path to a bibliography file if you want to cite some external
  // works.
  bibliography-file: none,

  // The document's content.
  body,
) = {
  // Formats the author's names in a list with commas and a
  // final "and".
  let names = authors.map(author => author.name)
  let author-string = if authors.len() == 2 {
    names.join(" and ")
  } else {
    names.join(", ", last: ", and ")
  }

  // Set document metadata.
  set document(title: title, author: names)

  // Set the body font. AMS uses the LaTeX font.
  set text(size: normal-size, font: "New Computer Modern")

  // Configure the page.
  set page(
    paper: paper-size,
    // The margins depend on the paper size.
    margin: if paper-size != "a4" {
      (
        top: (116pt / 279mm) * 100%,
        left: (126pt / 216mm) * 100%,
        right: (128pt / 216mm) * 100%,
        bottom: (94pt / 279mm) * 100%,
      )
    } else {
      (
        top: 117pt,
        left: 118pt,
        right: 119pt,
        bottom: 96pt,
      )
    },

    // The page header should show the page number and list of
    // authors, except on the first page. The page number is on
    // the left for even pages and on the right for odd pages.
    header-ascent: 14pt,
    header: locate(loc => {
      let i = counter(page).at(loc).first()
      if i == 1 { return }
      set text(size: script-size)
      grid(
        columns: (6em, 1fr, 6em),
        if calc.even(i) [#i],
        align(center, upper(
          if calc.odd(i) { title } else { author-string }
        )),
        if calc.odd(i) { align(right)[#i] }
      )
    }),

    // On the first page, the footer should contain the page number.
    footer-descent: 12pt,
    footer: locate(loc => {
      let i = counter(page).at(loc).first()
      if i == 1 {
        align(center, text(size: script-size, [#i]))
      }
    })
  )

  // Configure headings.
  set heading(numbering: "1.")
  show heading: it => {
    // Create the heading numbering.
    let number = if it.numbering != none {
      counter(heading).display(it.numbering)
      h(7pt, weak: true)
    }

    // Level 1 headings are centered and smallcaps.
    // The other ones are run-in.
    set text(size: normal-size, weight: 400)
    if it.level == 1 {
      set align(center)
      set text(size: normal-size)
      smallcaps[
        #v(15pt, weak: true)
        #number
        #it.body
        #v(normal-size, weak: true)
      ]
      counter(figure.where(kind: "theorem")).update(0)
    } else {
      v(11pt, weak: true)
      number
      let styled = if it.level == 2 { strong } else { emph }
      styled(it.body + [. ])
      h(7pt, weak: true)
    }
  }

  // Configure lists and links.
  set list(indent: 24pt, body-indent: 5pt)
  set enum(indent: 24pt, body-indent: 5pt)
  show link: set text(font: "New Computer Modern Mono")

  // Configure equations.
  show math.equation: set block(below: 8pt, above: 9pt)
  show math.equation: set text(weight: 400)

  // Configure citation and bibliography styles.
  set cite(style: "numerical", brackets: true)
  set bibliography(style: "apa", title: "References")

  show figure: it => {
    show: pad.with(x: 23pt)
    set align(center)

    v(12.5pt, weak: true)

    // Display the figure's body.
    it.body

    // Display the figure's caption.
    if it.has("caption") {
      // Gap defaults to 17pt.
      v(if it.has("gap") { it.gap } else { 17pt }, weak: true)
      smallcaps[Figure]
      if it.numbering != none {
        [ #counter(figure).display(it.numbering)]
      }
      [. ]
      it.caption
    }

    v(15pt, weak: true)
  }

  // Theorems.
  show figure.where(kind: "theorem"): it => block(above: 11.5pt, below: 11.5pt, {
    strong({
      it.supplement
      if it.numbering != none {
        [ ]
        counter(heading).display()
        it.counter.display(it.numbering)
      }
      [.]
    })
    emph(it.body)
  })

  // Display the title and authors.
  v(35pt, weak: true)
  align(center, upper({
    text(size: large-size, weight: 700, title)
    v(25pt, weak: true)
    text(size: footnote-size, author-string)
  }))

  // Configure paragraph properties.
  set par(first-line-indent: 1.2em, justify: true, leading: 0.58em)
  show par: set block(spacing: 0.58em)

  // Display the abstract
  if abstract != none {
    v(20pt, weak: true)
    set text(script-size)
    show: pad.with(x: 35pt)
    smallcaps[Abstract. ]
    abstract
  }

  // Display the article's contents.
  v(29pt, weak: true)
  body

  // Display the bibliography, if any is given.
  if bibliography-file != none {
    show bibliography: set text(8.5pt)
    show bibliography: pad.with(x: 0.5pt)
    bibliography(bibliography-file)
  }

  // The thing ends with details about the authors.
  show: pad.with(x: 11.5pt)
  set par(first-line-indent: 0pt)
  set text(7.97224pt)

  for author in authors {
    let keys = ("department", "organization", "location")

    let dept-str = keys
      .filter(key => key in author)
      .map(key => author.at(key))
      .join(", ")

    smallcaps(dept-str)
    linebreak()

    if "email" in author [
      _Email address:_ #link("mailto:" + author.email) \
    ]

    if "url" in author [
      _URL:_ #link(author.url)
    ]

    v(12pt, weak: true)
  }
}

// The ASM template also provides a theorem function.
#let theorem(body, numbered: true) = figure(
  body,
  kind: "theorem",
  supplement: [Theorem],
  numbering: if numbered { "1" },
)

// And a function for a proof.
#let proof(body) = block(spacing: 11.5pt, {
  emph[Proof.]
  [ ] + body
  h(1fr)
  box(scale(160%, origin: bottom + right, sym.square.stroked))
})
#show: ams-article.with(
  title: "Finite Elemente",
)


Für die Lösung von Variationsproblemen wird das gegebene Gebiet $Omega$ in endlich viele Teilgebiete zerlegt. In unserem zweidimensionalen, ebenen, Fall werden quadratische Elemente betrachtet. Der Begriff #emph[Element] hat hier zwei Bedeutungen: auf der einen Seite werden die geometrischen Teilgebiete als #emph[Element] bezeichnet, während mit #emph[Finiten Elementen] hingegen Funktionen gemeint sind \[Braess, S. 57, Fußnote\]. Nach Braess gibt es drei Merkmale, die bei der Definition eines Finite Elemente Raums am wichtigsten sind.

+ Geometrie der Teilgebiete: Dreiecks- bzw. Viereckselemente#footnote[In dieser Arbeit werden ausschließlich Viereckelemente behandelt]

+ Im zweidimensionalen Raum werden Funktionen mit zwei Variablen definiert, welche als #emph[Polynome vom Grad] $lt.eq t$ bezeichnet werden, wenn der höchste Exponent der Variaben $lt.eq t$ ist. Vollständige Polynome sind Finite Elemente, in denen alle Polynome vom Grad $lt.eq t$ enthalten sind.

+ Stetigkeits- und Differenzierbarkeitseigenschaften: Es wird von $C^k$-Elementen gesprochen, wenn … TODO

= Definition Finites Element
<definition-finites-element>
= Lagrange Elemente \(Bilineares Viereckelement)
<lagrange-elemente-bilineares-viereckelement>
Das bilineare Element ist das simpelste unter den Viereckelementen. Betrachten wir zunächst ein Rechteckelement, dessen Kanten parallel zu den Koordinatenachsen laufen. Mit der Ansatzfunktion #math.equation(block: true, numbering: "(1)", [ $ u (x , y) = a + b x + c y + d x y $ ])<eq-black-scholes>

erhalten wir ein Polynom 2. Grades, welches den bilinearen Term $x y$ aus der dritten Reihe des Pascalschen Dreiecks enthält. Das Monom $x y$ ist jedoch an jeder Kante des Elementes linear, da entweder $x$ oder $y$ konstant ist. Die vier unbekannten Parameter können jeweils durch die vier Werte an den Ecken ermittelt werden. Das Ergebnis sind die Funktionen #math.equation(block: true, numbering: "(1)", [ $ N_1^e (x , y) & = 1 / A^e (x - x_2^e) (y - y_4^e) ,\
N_2^e (x , y) & = - 1 / A^e (x - x_1^e) (y - y_4^e) ,\
N_3^e (x , y) & = 1 / A^e (x - x_1^e) (y - y_1^e) ,\
N_4^e (x , y) & = - 1 / A^e (x - x_2^e) (y - y_1^e)\
 $ ])<eq-black-scholes>

für ein rechteckiges Element, wobei $A^e$ die Fläche des Elements bezeichnet. Wie Abbildung… zeigt, sind die Funktionen an jeder Seite linear.

#figure([
#box(width: 40%,image("00-pics/BilinearesElement.png"))
], caption: figure.caption(
position: bottom, 
[
Bilineares Element
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)


Für das Referenzelement $T_(r e f) = [- 1 , 1]^2$ mit den Referenzkoordinaten $xi$ und $eta$, wie in Abbildung … definiert, ergeben sich die Formfunktionen #math.equation(block: true, numbering: "(1)", [ $ N_1 (xi , eta) & = 1 / 4 (xi eta - xi - eta + 1)\
N_2 (xi , eta) & = 1 / 4 (- xi eta + xi - eta + 1)\
N_3 (xi , eta) & = 1 / 4 (xi eta + xi + eta + 1)\
N_4 (xi , eta) & = 1 / 4 (- xi eta - xi + eta + 1) .\
 $ ])<eq-black-scholes>

Für allgemeine Vierecke ist der oben beschriebene bilineare Ansatz für Rechtecke untauglich, dieser wird näher im Kapitel … besprochen.

= konformes Hermite Viereckelement \(Bogner-Fox-Schmitt)
<konformes-hermite-viereckelement-bogner-fox-schmitt>
Das Bogner-Fox-Schmit \(BFS) Element bezeichnet ein Vierknotenelement mit je vier Freiheitsgraden $ w_i , theta_(xi i) , theta_(eta i) quad u n d quad theta_(xi eta i) $

in den Eckknoten. Die Nummerierung der Knoten mit $i = 1 , 2 , 3 , 4$ ist in Abbildung … dargestellt. Die Freiheitsgrade $theta_(xi i)$ und $theta_(eta i)$ entsprechen der Ableitung von $w_i$ nach $xi$ bzw. $eta$ an dem Knoten $i$. Durch den zusätzlichen Freiheitsgrad $theta_(xi eta i)$, also die Ableitung zweiten Grades von $w_i$ nach $xi$ und $eta$, wird die geforderte #emph[smoothness] des Elementes erreicht.

Wie in Figur … dargestellt, können die Formfunktionen des BFS Elements für die Freiheitsgrade am ersten Knoten durch das Produkt der eindimensionalen kubischen Hermite-Polynome konstruiert werden. Seien die kubischen Polynome #math.equation(block: true, numbering: "(1)", [ $ H_1 (xi) & = 1 / 4 (2 - 3 xi + xi^3)\
H_2 (xi) & = 1 / 4 (1 - xi - xi^2 + xi^3)\
H_3 (xi) & = 1 / 4 (2 + 3 xi - xi^3)\
H_4 (xi) & = 1 / 4 (- 1 - xi + xi^2 + xi^3)\
 $ ])<eq-black-scholes>

auf dem eindimensionalen Referenzelement, mit dem Interval $Î := [- 1 , 1]$ definiert, so werden die Bedingungen #math.equation(block: true, numbering: "(1)", [ $ H_1 (- 1) & = 1 , quad & H_1 (1) = 0 , quad & H_1 prime (- 1) = 0 , quad & H_1 prime (1) = 0\
H_2 (- 1) & = 0 , quad & H_2 (1) = 1 , quad & H_2 prime (- 1) = 0 , quad & H_2 prime (1) = 0\
H_3 (- 1) & = 0 , quad & H_3 (1) = 0 , quad & H_3 prime (- 1) = 1 , quad & H_3 prime (1) = 0\
H_4 (- 1) & = 0 , quad & H_4 (1) = 0 , quad & H_4 prime (- 1) = 0 , quad & H_4 prime (1) = 1 ,\
 $ ])<eq-black-scholes>

erfüllt. Für einen Euler-Bernoulli-Balken bedingt die Funktion $H_1$ den Verschiebungsfreiheitsgrad an dem Knoten 1 \($xi = - 1$) und die Funktionen $H_2$ den Verdrehungsfreiheitsgrad an dem selben Knoten. Die Funktionen $H_3$ und $H_4$ steuern zu den jeweiligen Freiheitsgrade an Knoten 2 \($xi = 1$) bei.

#figure([
#box(width: 60%,image("00-pics/Hermite-Polynome.png"))
], caption: figure.caption(
position: bottom, 
[
Hermite Funktionen
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)


Für die Basisfunktionen des Bogner-Fox-Schmit Elementes wird das Tensorprodukt der beschriebenen Hermite Polynome berechnet. Es ergeben sich 16 Funktionen, welche die Polynome #math.equation(block: true, numbering: "(1)", [ $ 1 , x , y , x^2 , x y , y^2 , x^3 , x^2 y , x y^2 , y^3 , x^3 y , x^2 y^2 , x y^3 , x^3 y^2 , x^2 y^3 , x^3 y^3 $ ])<eq-black-scholes>

enthalten.

$ N_(i , j) (xi , eta) = H_i (xi) H_j (eta) , quad i , j = 1 , 2 , 3 , 4 $

#figure([
#box(width: 40%,image("00-pics/BFS-Element.png"))
], caption: figure.caption(
position: bottom, 
[
Bogner-Fox-Schmit Element
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)


$ N_1 (xi , eta) & = 1 / 16 (xi^3 eta^3 - 3 xi^3 eta - 3 xi eta^3 + 2 xi^3 + 2 eta^3 + 9 xi eta - 6 xi - 6 eta + 4)\
N_2 (xi , eta) & = 1 / 16 (xi^3 eta^3 - xi^2 eta^3 - 3 xi^3 eta - xi eta^3 + 2 xi^3 + 3 xi^2 eta + eta^3 - 2 xi^2 + 3 xi eta - 2 xi - 3 eta + 2)\
N_3 (xi , eta) & = 1 / 16 (xi^3 eta^3 - xi^3 eta^2 - xi^3 eta - 3 xi eta^3 + xi^3 + 3 xi eta^2 + 2 eta^3 + 3 xi eta - 2 eta^2 - 3 xi - 2 eta + 2)\
N_4 (xi , eta) & = 1 / 16 (xi^3 eta^3 - xi^3 eta^2 - xi^2 eta^3 - xi^3 eta + xi^2 eta^2 - xi eta^3 + xi^3 + xi^2 eta + xi eta^2 + eta^3 - xi^2 + xi eta - eta^2 - xi - eta + 1)\
N_5 (xi , eta) & = 1 / 16 (- xi^3 eta^3 + 3 xi^3 eta + 3 xi eta^3 - 2 xi^3 + 2 eta^3 - 9 xi eta + 6 xi - 6 eta + 4)\
N_6 (xi , eta) & = 1 / 16 (xi^3 eta^3 + xi^2 eta^3 - 3 xi^3 eta - xi eta^3 + 2 xi^3 - 3 xi^2 eta - eta^3 + 2 xi^2 + 3 xi eta - 2 xi + 3 eta - 2)\
N_7 (xi , eta) & = 1 / 16 (- xi^3 eta^3 + xi^3 eta^2 + xi^3 eta + 3 xi eta^3 - xi^3 - 3 xi eta^2 + 2 eta^3 - 3 xi eta - 2 eta^2 + 3 xi - 2 eta + 2)\
N_8 (xi , eta) & = 1 / 16 (xi^3 eta^3 - xi^3 eta^2 + xi^2 eta^3 - xi^3 eta - xi^2 eta^2 - xi eta^3 + xi^3 - xi^2 eta + xi eta^2 - eta^3 + xi^2 + xi eta + eta^2 - xi + eta - 1)\
N_9 (xi , eta) & = 1 / 16 (xi^3 eta^3 - 3 xi^3 eta - 3 xi eta^3 - 2 xi^3 - 2 eta^3 + 9 xi eta + 6 xi + 6 eta + 4)\
N_10 (xi , eta) & = 1 / 16 (- xi^3 eta^3 - xi^2 eta^3 + 3 xi^3 eta + xi eta^3 + 2 xi^3 + 3 xi^2 eta + eta^3 + 2 xi^2 - 3 xi eta - 2 xi - 3 eta - 2)\
N_11 (xi , eta) & = 1 / 16 (- xi^3 eta^3 - xi^3 eta^2 + xi^3 eta + 3 xi eta^3 + xi^3 + 3 xi eta^2 + 2 eta^3 - 3 xi eta + 2 eta^2 - 3 xi - 2 eta - 2)\
N_12 (xi , eta) & = 1 / 16 (xi^3 eta^3 + xi^3 eta^2 + xi^2 eta^3 - xi^3 eta + xi^2 eta^2 - xi eta^3 - xi^3 - xi^2 eta - xi eta^2 - eta^3 - xi^2 + xi eta - eta^2 + xi + eta + 1)\
N_13 (xi , eta) & = 1 / 16 (- xi^3 eta^3 + 3 xi^3 eta + 3 xi eta^3 + 2 xi^3 - 2 eta^3 - 9 xi eta - 6 xi + 6 eta + 4)\
N_14 (xi , eta) & = 1 / 16 (- xi^3 eta^3 + xi^2 eta^3 + 3 xi^3 eta + xi eta^3 + 2 xi^3 - 3 xi^2 eta - eta^3 - 2 xi^2 - 3 xi eta - 2 xi + 3 eta + 2)\
N_15 (xi , eta) & = 1 / 16 (xi^3 eta^3 + xi^3 eta^2 - xi^3 eta - 3 xi eta^3 - xi^3 - 3 xi eta^2 + 2 eta^3 + 3 xi eta + 2 eta^2 + 3 xi - 2 eta - 2)\
N_16 (xi , eta) & = 1 / 16 (xi^3 eta^3 + xi^3 eta^2 - xi^2 eta^3 - xi^3 eta - xi^2 eta^2 - xi eta^3 - xi^3 + xi^2 eta - xi eta^2 + eta^3 + xi^2 + xi eta + eta^2 + xi - eta - 1)\
 $

= nicht konformes Hermite Viereckelement
<nicht-konformes-hermite-viereckelement>
#figure([
#box(width: 40%,image("00-pics/Serendipity.png"))
], caption: figure.caption(
position: bottom, 
[
Serendipityelement
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)


$ N_1 (xi , eta) & = 1 / 8 (- xi^3 eta - xi eta^3 + xi^3 + eta^3 + 4 xi eta - 3 xi - 3 eta + 2)\
N_2 (xi , eta) & = 1 / 8 (- xi^3 eta + xi^3 + xi^2 eta - xi^2 + xi eta - xi - eta + 1)\
N_3 (xi , eta) & = 1 / 8 (- xi eta^3 + xi eta^2 + eta^3 + xi eta - eta^2 - xi - eta + 1)\
N_4 (xi , eta) & = 1 / 8 (xi^3 eta + xi eta^3 - xi^3 + eta^3 - 4 xi eta + 3 xi - 3 eta + 2)\
N_5 (xi , eta) & = 1 / 8 (- xi^3 eta + xi^3 - xi^2 eta + xi^2 + xi eta - xi + eta - 1)\
N_6 (xi , eta) & = 1 / 8 (xi eta^3 - xi eta^2 + eta^3 - xi eta - eta^2 + xi - eta + 1)\
N_7 (xi , eta) & = 1 / 8 (- xi^3 eta - xi eta^3 - xi^3 - eta^3 + 4 xi eta + 3 xi + 3 eta + 2)\
N_8 (xi , eta) & = 1 / 8 (xi^3 eta + xi^3 + xi^2 eta + xi^2 - xi eta - xi - eta - 1)\
N_9 (xi , eta) & = 1 / 8 (xi eta^3 + xi eta^2 + eta^3 - xi eta + eta^2 - xi - eta - 1)\
N_10 (xi , eta) & = 1 / 8 (xi^3 eta + xi eta^3 + xi^3 - eta^3 - 4 xi eta - 3 xi + 3 eta + 2)\
N_11 (xi , eta) & = 1 / 8 (xi^3 eta + xi^3 - xi^2 eta - xi^2 - xi eta - xi + eta + 1)\
N_12 (xi , eta) & = 1 / 8 (- xi eta^3 - xi eta^2 + eta^3 + xi eta + eta^2 + xi - eta - 1)\
 $
