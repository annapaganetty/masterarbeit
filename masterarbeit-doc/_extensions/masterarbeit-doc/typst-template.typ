
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
   if lof {
    block(above: 0em, below: 2em)
    [#v(100pt, weak: true)
     #text(size: 30pt, weight: 600,"Abbildungsverzeichnis")
     #v(60pt, weak: true)
     #outline( 
      title: none,
      target: figure.where(kind: "quarto-float-fig")
    );
    ]
  }
  pagebreak()
  // Tabellenverzeichnis
  if lot {
    block(above: 0em, below: 2em)
    [#v(100pt, weak: true)
     #text(size: 30pt, weight: 600,"Tabellenverzeichnis")
     #v(60pt, weak: true)
     #outline( 
      title: none,
      target: figure.where(kind: "quarto-float-tbl")
    );
    ]
  }

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

  set list(indent: 24pt, body-indent: 5pt)
  set enum(indent: 24pt, body-indent: 5pt)
  show link: set text(font: "New Computer Modern Mono")

//  if abstract != none { 
//    block(inset: 2em)[ 
//    #text()[Abbildung] #h(1em) #abstract 
//    ] 
//  }
// set figure: it => box(



  // Configure figure captions 
  show figure.caption: it => box(
    inset: (left: 1.5em, right: 1.5em, top: 0.5em, bottom: 0.5em),
    if it.kind == "quarto-float-tbl" {
      align(left)[*Tabelle~#it.counter.display()*#it.separator#it.body]}
    else if it.kind == "quarto-float-fig"{
      align(left)[*Abbildung~#it.counter.display()*#it.separator#it.body]
    }
    )

  // show figure.supplement: it => (
  //   if it.kind == "quarto-float-tbl" {
  //     [*Tabelle*]}
  //   else if it.kind == "quarto-float-fig"{
  //     [*Abbildung*]
  // })

  // Gleichungen 
  show math.equation: set block(below: 15pt, above: 15pt)
  show math.equation: set text(weight: 400)
  set math.equation(supplement: [Gl.])

  set table(stroke:none)

  // Configure paragraph properties.
  set par(justify: true, leading: 0.58em)
  show par: set block(spacing: 1.5em)

  // Hauptteil des Dokuments
   set page(numbering: "1",
          header: locate(loc => {
          let i = counter(page).at(loc).first()
          if i == 5 { return }
          align(right, emph(text(size: 12pt)[Kapitel 1: Einleitung]))}))
  counter(page).update(1)
  v(29pt, weak: true)
  body
}
