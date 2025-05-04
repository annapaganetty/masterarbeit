#let script-size = 7.97224pt
#let footnote-size = 8.50012pt
#let small-size = 9.24994pt
#let normal-size = 12pt
#let middle-size = 16pt
#let large-size = 25pt
#set text(lang:"DE")
#let masterarbeit-doc(
  title: none,
  lang:none,
  font:none,
  font-size:none,
  paper-size: "a4",
  toc: true,
  lot: true,
  lof: true,
  region: "DE",
  bibliography-file: "references.bib",
  body,
) = {
  set text(lang: "de")
  // Schriftart und Sprache
  set text(weight: "light", 
          size: 11pt,
          font: font,
          lang: "DE",
          region: region)
  // Seitengröße und -ränder
  set page(
    paper: paper-size,
    // Seitenränder
    margin:(top: 3.5cm, bottom: 4cm, left: 3cm, right: 2cm),
    header-ascent: 30pt,
    footer-descent: 12pt,
  )

 include "titelblatt.qmd"
 pagebreak()
 set page(numbering: "i",
          header: locate(loc => {
          let i = counter(page).at(loc).first()
          if i == 3 { return }
          align(right, emph(text(size: 12pt)[Inhaltsverzeichnis]))}))
 counter(page).update(3)
 if toc {
    show outline.entry.where(level: 1): it => {
      strong[
        #v(2em, weak: true)
        #it.body
        #h(1fr)
        #it.page
      ]
    }
    block(above: 0em, below: 2em)
    [#v(100pt, weak: true)
     #text(size: 30pt, weight: 600,"Inhaltsverzeichnis")
     #v(60pt, weak: true)
     #outline( 
      title: none,
      depth: 3,
      indent: 2em
    );
    ]
  }
  pagebreak()
  // Abbildungsverzeichnis
  set page(header: align(right, emph(text(size: 12pt)[Abbildungsverzeichnis])))
  if lof {
      show outline.entry: it => context {
        if it.element.has("kind") {
          let loc = it.element.location()
          if counter(figure.where(kind: it.element.kind)).at(loc).first() == 1 {
            v(1em)
          }
          show link: set text(rgb("000000"))
          link(loc,
            box(it.body.children.at(2), width: 2.6em) // figure number
            + it.body.children.slice(4).join()        // figure caption
            + box(it.fill, width: 1fr)
            + it.page
          )
        } else {
          it
        }
      }
    block(above: 0em, below: 2em)
    [#v(100pt, weak: true)
     #text(size: 30pt, weight: 600,"Abbildungsverzeichnis")
     #v(60pt, weak: true)
     #outline( 
      title: none,
      depth: 2,
      indent: 2em,
      target: figure.where(kind: "quarto-float-fig")
    );
    ]
  }
  
  pagebreak()

  // Tabellenverzeichnis
  set page(header: align(right, emph(text(size: 12pt)[Tabellenverzeichnis])))
  if lot {
          show outline.entry: it => context {
            if it.element.has("kind") {
            let loc = it.element.location()

          if counter(figure.where(kind: it.element.kind)).at(loc).first() == 1 {
            v(1em)
          }

          show link: set text(rgb("000000"))
          link(loc,
            box(it.body.children.at(2), width: 2.6em) // figure number
            + it.body.children.slice(4).join()        // figure caption
            + box(it.fill, width: 1fr)
            + it.page
          )
    } else {
      it
    }
  }
    block(above: 0em, below: 2em)
    [#v(100pt, weak: true)
     #text(size: 30pt, weight: 600,"Tabellenverzeichnis")
     #v(60pt, weak: true)
     #outline( 
      title: none,
      depth: 1,
      indent: 2em,
      target: figure.where(kind: "quarto-float-tbl")
    );
    ]
  }
  set page(header: align(right, emph(text(size: 12pt)[])))

  pagebreak()
  set heading(numbering: "1.1.1")
  // Einstellung für Überschriften
  show heading.where(level: 1): it => {
    if it.numbering == none{{
    set text(size: large-size, weight: 600)
    [ #it.body
      #v(50pt, weak: true)]}}}
  show heading.where(level: 1): it => {
    if it.numbering != 0{
    if it.numbering != none {
    set text(size:22pt, weight: 60)
    [ #v(80pt, weak: true)
      Kapitel
      #counter(heading).display(it.numbering)
      #v(50pt, weak: true)]
    set text(size: large-size, weight: 600)
    [ #it.body
      #v(50pt, weak: true)]}}}
  show heading.where(level: 2): it => {
    set text(size: middle-size, weight: 600)
    [ #v(40pt, weak: true)
      #counter(heading).display(it.numbering)
      #it.body
      #v(middle-size, weak: true)]}
  show heading.where(level: 3): it => {  
    set text(size: 14pt, weight: 600)
    [ #v(20pt, weak: true)
      #counter(heading).display(it.numbering)
      #it.body
      #v(middle-size, weak: true)]}

  // set supplement to KAPITEL
  set heading(supplement: "Kapitel")

  set list(indent: 24pt, body-indent: 5pt)
  set enum(indent: 24pt, body-indent: 5pt)
  show link: set text(font: "New Computer Modern Mono")

  show heading.where(level: 1): it => {
    counter(math.equation).update(0)
    counter(figure.where(kind: "quarto-float-fig")).update(0)
    counter(figure.where(kind: "quarto-float-tbl")).update(0)
    it
  }

  set figure(numbering: (..num) =>
    numbering("1.1.a", counter(heading).get().first(), num.pos().first())
  )

  // Configure figure captions 
  show figure.caption: it => box(
    inset: (left: 1.5em, right: 1.5em, top: 0.5em, bottom: 0.5em),
    if it.kind == "quarto-float-tbl" {
      align(left)[*Tabelle~#it.counter.display()*#it.separator#it.body]}
    else if it.kind == "quarto-float-fig"{
      align(left)[*Abbildung~#it.counter.display()*#it.separator#it.body]
    }
    )

  // Gleichungen 
  show math.equation: set text(weight: 400)
  // Gleichungsreferenzen mit Link 
  show ref: it => {
    let eq = math.equation
    let el = it.element
    if el != none and el.func() == eq {
      // Override equation references.    Aktuell Section number nicht von dem Kapitel wo die gl. steht
      link(el.location(),[Gl.~(#counter(heading.where(level: 1)).at(el.location()).first().#numbering("1.1",counter(eq).at(el.location()).first()))])
    } else {
      // Other references as usual.
      it
    }
  }
  // Gleichung mit Nummerierung 
  show math.equation:it => {
    if it.fields().keys().contains("label") == true{
      show math.equation: set block(below: -10pt, above: 15pt)
      [#it.body.children.slice(1).join()~#h(1fr)~(#counter(heading).get().first().#counter(math.equation).get().first())]
      block(below: 10pt)
    } else {
      show math.equation: set block(below: 15pt, above: 15pt)
      it
    }
  }

  set table(stroke:none)

  // Configure paragraph properties.
  set par(justify: true, leading: 0.58em)
  show par: set block(spacing: 1.5em)

  // Hauptteil des Dokuments
  body
  // Display bibliography.
  set bibliography(style: "american-society-of-civil-engineers", title: text(11pt)[Literatur],full:true)
  // Display the bibliography

  show bibliography: set text(11pt)
  show bibliography: set par(leading: 0.58em)
  set block(spacing: 2em)
  show bibliography: pad.with(top:10pt,x: 5pt)

  set page(numbering: "1",header: align(right, emph(text(size: 12pt)[Literatur])))
  v(100pt, weak: true)
  text(size: 30pt, weight: 600,"Literatur")
  v(60pt, weak: true)
  bibliography("references.bib", title: text(11pt)[Literatur])

}
