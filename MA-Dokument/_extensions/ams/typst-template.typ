
#let script-size = 7.97224pt
#let footnote-size = 8.50012pt
#let small-size = 9.24994pt
#let normal-size = 12pt
#let middle-size = 16pt
#let large-size = 25pt

#set text(lang: "de")
// This function gets your whole document as its `body` and formats
// it as an article in the style of the American Mathematical Society.
#let ams-article(
  title: "",
  paper-size: "a4",
  body,
) = {

  // Set the body font. AMS uses the LaTeX font.
  // set text(size: normal-size,font: "Arial")
  
  set text(weight: "light", size: 11pt,font: "New Computer Modern",lang: "ger")
  // Configure the page.
  set page(
    paper: paper-size,
    // Seitenränder
    margin:(
        top: 3.5cm,
        bottom: 4cm,
        left: 3cm,
        right: 2cm)
    ,

    header-ascent: 10pt,
    header: locate(loc => {
      let i = counter(page).at(loc).first()
      if i == 1 { return }
      set text(size: script-size)
      align(right, upper({ title }))
      
    }),
    // page number on the footer
    footer-descent: 12pt,
    footer: locate(loc => {
      let i = counter(page).at(loc).first()
      set text(size: script-size)
      align(center, text(size: script-size, [#i]))
    })
  )

  // Configure headings.
  set heading(numbering: "1.1.1")
  show heading: it => {
    // Create the heading numbering.
    // let number = if it.numbering != none {
    //   counter(heading).display(it.numbering)
    //   h(7pt, weak: true)
    // }
    if it.numbering == none {
        set text(size: 22pt, weight: 600)
        [   #it.body
            #v(700pt, weak: true)]
    }
    else {
      if it.level == 1 {
        set text(size: 22pt, weight: 600)
        [
          #v(15pt, weak: true)
          Kapitel
          #counter(heading).display(it.numbering)
          #v(50pt, weak: true)]
        set text(size: large-size, weight: 600)
          [#it.body
          #v(50pt, weak: true)]
      } else if it.level == 2 {
        set text(size: middle-size, weight: 600)
        [
          #v(40pt, weak: true)
          #counter(heading).display(it.numbering)
          #it.body
          #v(middle-size, weak: true)
        ]
      } else {
        set text(size: normal-size, weight: 600)
        [
          #v(15pt, weak: true)
          #counter(heading).display(it.numbering)
          #it.body
          #v(middle-size, weak: true)
        ]
      }
    }
  }

  set list(indent: 24pt, body-indent: 5pt)
  set enum(indent: 24pt, body-indent: 5pt)
  show link: set text(font: "New Computer Modern Mono")

  // Display the title and authors.
  // v(35pt, weak: true)
  // align({
  //   text(size: large-size, weight: 700, title)
  //   v(25pt, weak: true)
  // })
  // Configure equations.
  show math.equation: set block(below: 15pt, above: 15pt)
  show math.equation: set text(weight: 400)
  set math.equation(supplement: [Gl.])

  set table(stroke:none)

  // Configure paragraph properties.
  set par(justify: true, leading: 0.58em)
  show par: set block(spacing: 1.5em)

  // Display the article's contents.
  v(29pt, weak: true)
  body
}