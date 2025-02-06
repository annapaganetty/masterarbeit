
#let script-size = 7.97224pt
#let footnote-size = 8.50012pt
#let small-size = 9.24994pt
#let normal-size = 12pt
#let large-size = 15pt

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
  // set text(size: normal-size,font: "Arial")
  set text(weight: "light", size: 11pt,font: "New Computer Modern")
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

    // The page header should show the page number and list of
    // authors, except on the first page.
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
  set heading(numbering: "1.")
  show heading: it => {
    // Create the heading numbering.
    // let number = if it.numbering != none {
    //   counter(heading).display(it.numbering)
    //   h(7pt, weak: true)
    // }

    // Level 1 headings are centered and smallcaps.
    // The other ones are run-in.
    set text(size: large-size, weight: 400)
    if it.level == 0 {
      set text(size: large-size, weight: 600)
      [
        #v(15pt, weak: true)
        #counter(heading).display(it.numbering)
        #it.body
        #v(normal-size, weak: true)
      ]
    } else {
      set text(size: normal-size, weight: 600)
      [
        #v(15pt, weak: true)
        #counter(heading).display(it.numbering)
        #it.body
        #v(normal-size, weak: true)
      ]
    }
  }

  set list(indent: 24pt, body-indent: 5pt)
  set enum(indent: 24pt, body-indent: 5pt)
  show link: set text(font: "New Computer Modern Mono")

  // Configure equations.
  show math.equation: set block(below: 15pt, above: 15pt)
  show math.equation: set text(weight: 400)
  set math.equation(supplement: [Gl.])

  // Configure citation and bibliography styles.
  set bibliography(style: "apa", title: "References")

  set table(stroke:none)

  // show figure.where(kind: table): set figure.caption(position: top)
  // show figure: it => {
  //   set align(center)
  //   v(15pt, weak: true)
  //   it.body 
  //   it.caption
  //   v(15pt, weak: true)
  // } 
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
  // show figure: it => {
  //   set align(center)
  //   if figure.where(kind:table) != true {
  //     [
  //       #v(15pt, weak: true)
  //       #it.body
  //       #smallcaps[Abbildung]
  //       #counter(figure).display(it.numbering)
  //       #[: ]
  //       #it.caption
  //       #v(15pt, weak: true)
  //     ]      
  //   } else {
  //     [
  //       #v(15pt, weak: true)
  //       #it.body
  //       #smallcaps[Tabelle]
  //       #counter(figure.where(kind:table)).display(it.numbering)
  //       #[: ]
  //       #it.caption
  //       #v(15pt, weak: true)
  //     ] 
  //   } 
  // } 


  // Display the title and authors.
  v(35pt, weak: true)
  align(center, upper({
    text(size: large-size, weight: 700, title)
    v(25pt, weak: true)
    text(size: footnote-size, author-string)
  }))

  // Configure paragraph properties.
  set par(justify: true, leading: 0.58em)
  show par: set block(spacing: 1.5em)

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