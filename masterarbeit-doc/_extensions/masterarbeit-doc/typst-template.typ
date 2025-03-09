
#let script-size = 7.97224pt
#let footnote-size = 8.50012pt
#let small-size = 9.24994pt
#let normal-size = 12pt
#let middle-size = 16pt
#let large-size = 25pt

#let masterarbeit-doc(
  title: none,
  lang:none,
  font:none,
  font-size:none,
  paper-size: "a4",
  body,
) = {
  // Schriftart und Sprache
  set text(weight: "light", 
          size: 11pt,
          font: font,
          lang: lang)
  // Seitengröße und -ränder
  set page(
    paper: paper-size,
    // Seitenränder
    margin:(top: 3.5cm, bottom: 4cm, left: 3cm, right: 2cm),

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

  set heading(numbering: "1.")

  // Configure headings.
  // set heading(numbering: section-numbering)
  // show heading: it => {
  //   // Create the heading numbering.
  //   // let number = if it.numbering != none {
  //   //   counter(heading).display(it.numbering)
  //   //   h(7pt, weak: true)
  //   // }
  //   if it.numbering == none {
  //       set text(size: 22pt, weight: 600)
  //       [   #it.body
  //           #v(700pt, weak: true)]
  //   }
  //   else {
  //     if it.level == 1 {
  //       set text(size: 22pt, weight: 600)
  //       [
  //         #v(15pt, weak: true)
  //         Kapitel
  //         #counter(heading).display(it.numbering)
  //         #v(50pt, weak: true)]
  //       set text(size: large-size, weight: 600)
  //         [#it.body
  //         #v(50pt, weak: true)]
  //     } else if it.level == 2 {
  //       set text(size: middle-size, weight: 600)
  //       [
  //         #v(40pt, weak: true)
  //         #counter(heading).display(it.numbering)
  //         #it.body
  //         #v(middle-size, weak: true)
  //       ]
  //     } else {
  //       set text(size: normal-size, weight: 600)
  //       [
  //         #v(15pt, weak: true)
  //         #counter(heading).display(it.numbering)
  //         #it.body
  //         #v(middle-size, weak: true)
  //       ]
  //     }
  //   }
  // }

  set list(indent: 24pt, body-indent: 5pt)
  set enum(indent: 24pt, body-indent: 5pt)
  show link: set text(font: "New Computer Modern Mono")

  // Gleichungen 
  show math.equation: set block(below: 15pt, above: 15pt)
  show math.equation: set text(weight: 400)
  set math.equation(supplement: [Gl.])

  set table(stroke:none)

  // Configure paragraph properties.
  set par(justify: true, leading: 0.58em)
  show par: set block(spacing: 1.5em)

  // Hauptteil des Dokuments
  v(29pt, weak: true)
  body
}
// // This is an example typst template (based on the default template that ships
// // with Quarto). It defines a typst function named 'article' which provides
// // various customization options. This function is called from the 
// // 'typst-show.typ' file (which maps Pandoc metadata function arguments)
// //
// // If you are creating or packaging a custom typst template you will likely
// // want to replace this file and 'typst-show.typ' entirely. You can find 
// // documentation on creating typst templates and some examples here: 
// //   - https://typst.app/docs/tutorial/making-a-template/
// //   - https://github.com/typst/templates

// #let article(
//   title: none,
//   authors: none,
//   date: none,
//   abstract: none,
//   cols: 1,
//   margin: (x: 1.25in, y: 1.25in),
//   paper: "us-letter",
//   lang: "en",
//   region: "US",
//   font: (),
//   fontsize: 11pt,
//   sectionnumbering: none,
//   toc: false,
//   doc,
// ) = {
//   set page(
//     paper: paper,
//     margin: margin,
//     numbering: "1",
//   )
//   set par(justify: true)
//   set text(lang: lang,
//            region: region,
//            font: font,
//            size: fontsize)
//   set heading(numbering: sectionnumbering)

//   if title != none {
//     align(center)[#block(inset: 2em)[
//       #text(weight: "bold", size: 1.5em)[#title]
//     ]]
//   }

//   if authors != none {
//     let count = authors.len()
//     let ncols = calc.min(count, 3)
//     grid(
//       columns: (1fr,) * ncols,
//       row-gutter: 1.5em,
//       ..authors.map(author =>
//           align(center)[
//             #author.name \
//             #author.affiliation \
//             #author.email
//           ]
//       )
//     )
//   }

//   if date != none {
//     align(center)[#block(inset: 1em)[
//       #date
//     ]]
//   }

//   if abstract != none {
//     block(inset: 2em)[
//     #text(weight: "semibold")[Abstract] #h(1em) #abstract
//     ]
//   }

//   if toc {
//     block(above: 0em, below: 2em)[
//     #outline(
//       title: auto,
//       depth: none
//     );
//     ]
//   }

//   if cols == 1 {
//     doc
//   } else {
//     columns(cols, doc)
//   }
// }
