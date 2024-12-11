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



#let article(
  title: none,
  authors: none,
  date: none,
  abstract: none,
  cols: 1,
  margin: (x: 1.25in, y: 1.25in),
  paper: "us-letter",
  lang: "en",
  region: "US",
  font: (),
  fontsize: 11pt,
  sectionnumbering: none,
  toc: false,
  toc_title: none,
  toc_depth: none,
  doc,
) = {
  set page(
    paper: paper,
    margin: margin,
    numbering: "1",
  )
  set par(justify: true)
  set text(lang: lang,
           region: region,
           font: font,
           size: fontsize)
  set heading(numbering: sectionnumbering)

  if title != none {
    align(center)[#block(inset: 2em)[
      #text(weight: "bold", size: 1.5em)[#title]
    ]]
  }

  if authors != none {
    let count = authors.len()
    let ncols = calc.min(count, 3)
    grid(
      columns: (1fr,) * ncols,
      row-gutter: 1.5em,
      ..authors.map(author =>
          align(center)[
            #author.name \
            #author.affiliation \
            #author.email
          ]
      )
    )
  }

  if date != none {
    align(center)[#block(inset: 1em)[
      #date
    ]]
  }

  if abstract != none {
    block(inset: 2em)[
    #text(weight: "semibold")[Abstract] #h(1em) #abstract
    ]
  }

  if toc {
    let title = if toc_title == none {
      auto
    } else {
      toc_title
    }
    block(above: 0em, below: 2em)[
    #outline(
      title: toc_title,
      depth: toc_depth
    );
    ]
  }

  if cols == 1 {
    doc
  } else {
    columns(cols, doc)
  }
}
#show: doc => article(
  title: [DGL einer Platte nach der Kirchhoffsche Plattentheorie],
  lang: "de",
  sectionnumbering: "1.1.a",
  toc_title: [Inhaltsverzeichnis],
  toc_depth: 3,
  cols: 1,
  doc,
)


= Annahmen, Grundgleichungen und Verschiebungsfeld
<annahmen-grundgleichungen-und-verschiebungsfeld>
Die Platte, als ebenes Flächentragwerk, zeichnet sich durch ausschließlich senkrecht zur Plattenmittelebene wirkende Beanspruchungen aus. Zudem ist die Plattendicke $h$ signifikant kleiner, verglichen mit den Abmessungen in der Plattenebene. Die zu Grunde liegende Theorie wurde von Gustav Kirchhoff im Jahr 1850 zum ersten Mal formuliert \[1\]. Entsprechend der Annahmen von Bernoulli in Bezug auf einen elastischen Stab, geht Kirchhoff von folgenden zwei grundlegenden kinematischen Annahmen aus: \

- eine Normale, welche im unverformten Zustand senkrecht zur Plattenmittelebene ist, bleibt auch im verformten Zustand senkrecht zu der neutralen Achse. Die Durchbiegung der verformten Platte im Abstand $z$ zur neutralen Achse wird durch $ w = w (x , y) $ beschrieben.
- der Plattenquerschnitt ist im verformten und unverformten Zustand eben und verwölbt sich nicht. Dies entspricht der Hypothese vom Ebenebleiben des Querschnitts beim Euler-Bernoulli-Balken.

BILD

Die partielle Ableitung von $w (x , y)$ nach $x$, beziehungsweise $y$, gibt die Neigung der neutralen Ebene an. Der Winkel des Steigungsdreiecks von $frac(diff w, diff y)$ oder $frac(diff w, diff x)$ an der Stelle $(x , y)$ der Ebene, entspricht dem Verdrehwinkel der Fläche an der Stelle $(x , y)$ um die x-Achse oder y-Achse. In Abhängigkeit der Verdrehwinkel

#math.equation(block: true, numbering: "(1)", [ $ theta_x (x , y) = a r c t a n (- frac(diff w, diff x)) $ ])<eq-black-scholes>

und #math.equation(block: true, numbering: "(1)", [ $ theta_y (x , y) = a r c t a n (- frac(diff w, diff y)) $ ])<eq-black-scholes>

werden die horizontalen Verschiebungen des Punktes P #math.equation(block: true, numbering: "(1)", [ $ u (x , y , z) = s i n (theta_x (x , y)) dot.op z $ ])<eq-black-scholes>

und #math.equation(block: true, numbering: "(1)", [ $ v (x , y , z) = s i n (theta_y (x , y)) dot.op z $ ])<eq-black-scholes>

berechnet. Unter der weiteren Annahme, dass die Verschiebungen und die Verdrehungen klein sind gilt $s i n (theta_x) approx theta$ und $s i n (theta_y) approx theta$ und es ergibt sich der Zusammenhang #math.equation(block: true, numbering: "(1)", [ $ u (x , y , z) = - z dot.op frac(diff w (x , y), diff x) $ ])<eq-black-scholes> #math.equation(block: true, numbering: "(1)", [ $ v (x , y , z) = - z dot.op frac(diff w (x , y), diff y) . $ ])<eq-black-scholes>

Die Gesetztmäßigkeiten nach Gl.2.1, Gl.2.5 und Gl.2.6 werden in der Literatur auch als Verschiebungsfeld nach der Kirchhoffschen Plattentheorie bezeichnet. \[2\]

= Verzerrungsfeld
<verzerrungsfeld>
Entsprechend der Kirchhoffschen Plattentheorie verschwindet die Dehnung $epsilon.alt_(z z)$ auf Grund der Annahme der gleichbleibenen Plattendicke $h$ sowie die beiden Schubverzerrungen $gamma_(x z)$ und $gamma_(y z)$ als Folge des Ebenbleibens der Querschnitte. Übrig bleiben die Dehnungen $epsilon.alt_(x x)$, $epsilon.alt_(y y)$ und die Verzerrung $gamma_(x y)$. #math.equation(block: true, numbering: "(1)", [ $ epsilon.alt_(x x) & = frac(diff u, diff x) = - z dot.op frac(diff^2 w, diff x^2)\
epsilon.alt_(y y) & = frac(diff v, diff y) = - z dot.op frac(diff^2 w, diff y^2)\
gamma_(x y) & = frac(diff u, diff x) + frac(diff v, diff y) = - 2 z dot.op frac(diff^2 w, diff x diff y)\
 $ ])<eq-black-scholes>

Krümmungen #math.equation(block: true, numbering: "(1)", [ $ kappa_(x x) & = frac(diff^2 w, diff x^2)\
kappa_(y y) & = frac(diff^2 w, diff y^2)\
kappa_(x y) & = (- 2) (?) frac(diff^2 w, diff x diff y)\
 $ ])<eq-black-scholes>

Vektorschreibweise #math.equation(block: true, numbering: "(1)", [ $ kappa = mat(delim: "[", kappa_(x x); kappa_(y y); kappa_(x y)) = mat(delim: "[", frac(diff^2 w, diff x^2); frac(diff^2 w, diff y^2); frac(diff^2 w, diff x diff y)) $ ])<eq-black-scholes>

Spannungen

#math.equation(block: true, numbering: "(1)", [ $ sigma_(x x) & = frac(E, 1 - nu^2) dot.op (epsilon.alt_(x x) + nu dot.op epsilon.alt_(y y))\
sigma_(y y) & = frac(E, 1 - nu^2) dot.op (nu dot.op epsilon.alt_(x x) + epsilon.alt_(y y))\
tau_(x y) & = frac(E, 2 dot.op (1 + nu)) dot.op gamma_(x y) med $ ])<eq-black-scholes>

= Schnittgrößen
<schnittgrößen>
Die Biegemomente in der Platte ergeben sich zu #math.equation(block: true, numbering: "(1)", [ $ m_(x x) & = integral_(- h \/ 2)^(h \/ 2) z dot.op underbrace(frac(E, 1 - nu^2) dot.op (epsilon.alt_(x x) + nu dot.op epsilon.alt_(y y)), sigma_(x x)) dot.op d z\
m_(y y) & = integral_(- h \/ 2)^(h \/ 2) z dot.op underbrace(frac(E, 1 - nu^2) dot.op (nu dot.op epsilon.alt_(x x) + epsilon.alt_(y y)), sigma_(y y)) dot.op d z\
m_(x y) & = integral_(- h \/ 2)^(h \/ 2) z dot.op underbrace(frac(E, 2 dot.op (1 + nu)) dot.op gamma_(x y), tau_(x y)) dot.op d z .\
 $ ])<eq-black-scholes>

Mit der Konstanten $D = frac(E dot.op h^3, 12 dot.op (1 - nu^2))$ werden die Biegemomente mit den Krümmungen $kappa$ wie folgt vereinfacht dargestellt. #math.equation(block: true, numbering: "(1)", [ $ m_(x x) & = D dot.op (kappa_(x x) + nu dot.op kappa_(y y)) &  & = D dot.op (frac(diff^2 w, diff x^2) + nu dot.op frac(diff^2 w, diff y^2))\
m_(y y) & = D dot.op (nu dot.op kappa_(x x) + kappa_(y y)) &  & = D dot.op (nu dot.op frac(diff^2 w, diff x^2) + frac(diff^2 w, diff y^2))\
m_(x y) & = D dot.op frac(1 - nu, 2) dot.op kappa_(x y) &  & = D dot.op frac(1 - nu, 2) dot.op (- 2 frac(diff^2 w, diff x diff y)) $ ])<eq-black-scholes>

Die Querkräfte ergeben sich aus den dritten Ableitungen der Verschiebung $w$ #math.equation(block: true, numbering: "(1)", [ $ q_(x x) & = D dot.op (frac(diff^3 w, diff x^3) + nu dot.op frac(diff^3 w, diff y^3))\
q_(y y) & = D dot.op (nu dot.op frac(diff^3 w, diff x^3) + frac(diff^3 w, diff y^3))\
 $ ])<eq-black-scholes>

= Gleichgewichtsbeziehungen & Plattengleichung
<gleichgewichtsbeziehungen-plattengleichung>
#math.equation(block: true, numbering: "(1)", [ $ frac(diff Q_(x x), diff x) + frac(diff Q_(y y), diff y) + q & = 0\
frac(diff M_(x x), diff x) + frac(diff M_(x y), diff y) - Q_(x x) & = 0\
frac(diff M_(y y), diff y) + frac(diff M_(x y), diff y) - Q_(y y) & = 0\
 $ ])<eq-black-scholes>

Setzt man die Gleichungen der Schnittgrößen in die Gleichgewichtsbeziehungen ein erhält man die Differentialgleichung #cite(<Randwertproblem>) und somit die schwache Form beziehungsweise die Plattengleichung nach Kirchhoff mit den unten aufgeführten Randbedingungen.

Das Randwertproblem wird als Divergenz des Gradienten von $w$ wie folgt ausgedrückt: #math.equation(block: true, numbering: "(1)", [ $ D dot.op Delta Delta w (x , y) = q $ ])<eq-black-scholes>
