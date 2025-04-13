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
#show: masterarbeit-doc.with(
  title: "Einleitung",
  lang: "",
  font: "New Computer Modern",
  font-size: "11pt",
)


= Einleitung
<einleitung>
== Motivation
<sec-motivation>
Wird die Finite Elemente Methode \(FEM), ohne ausreichende Kenntnisse über die Berechnungsmethode, als "Black-Box"- Methode, angewandt, sind häufig Fehler die Konsequenz \(s. Vortrag auf der 4. FEM-Tagung der TU Darmstadt im Jahr 1996). R.D. Cook, D.S. Malkus und M.E. Plesha warnen bereits in dem Jahr 1988 davor, dass den Ergebnissen der FE-Berechnung nur dann getraut werden kann, wenn der Anwender über konkretes Wissen, bezüglich des internen Berechnungsablaufs des Programms, verfügt und Kenntnis über die physikalischen Grundlagen hat.

#emph["Their results cannot be trusted if users have no knowledge of their internal workings and little understanding of the physical theories on which they are based."] - Cook et al.

Die Finite-Elemente-Methode \(FEM) hat sich als eine der leistungsfähigsten und vielseitigsten Techniken zur Analyse komplexer ingenieurtechnischer Probleme etabliert. Trotz der weit verbreiteten Anwendung der FEM in der Ingenieurpraxis ist die Literatur zu den spezifischen Verfahren und Methoden zur Anwendung der Kirchhoff-Plattentheorie oft unzureichend. Ein Mangel an klaren und umfassenden Erklärungen zu den notwendigen mathematischen und mechanischen Grundlagen kann die Entwicklung effizienter und präziser FEM-Modelle behindern. Aber auch der Anwender sollte ausreichende Kentnisse haben, über die komplexen Berechnungsvorgänge im Hintergrund eines FEM-Programms und den Ergebnissen nicht blind vertrauen.

#figure([
#box(width: 45%,image("00-pics/sleipner-A-platform.png"))
], caption: figure.caption(
position: bottom, 
[
Offshore Bohrplatform Sleipner A
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
numbering: "1", 
)
<fig-sleipner-A>


Der Schadenfall an der Bohrplattform Sleipner A \(@fig-sleipner-A) zeigt, dass auch Fehler mit schwerwiegenden Folgen gemacht werden können. Direkt nach dem Unfall ernannte der Besitzer der Plattform, die Firma Statoil, eine Ermittlungsgruppe. Es zeigte sich, dass bei der fehlerhaften Umsetzung der Finite Elemente Berechnung in einen Bewehrungsplan die Ursache für den Untergang lag.#footnote[https:\/\/www-users.cse.umn.edu/\~arnold/disasters/sleipner.html]

Für das Verständnis der FE-Methode ist es essentiell die Grundideen zu verinnerlichen. Die wesentlichen zwei Aspekte der Methode sind die Approximation einer Lösung durch Kombination von vordefinierten Funktionen und die stückweise Definition der Funktionen auf sogenannten Elementen. Die Kirchhoff-Plattentheorie stellt dabei, neben der Reissner-Mindlin Theorie, eine fundamentale Grundlage dar, um das Verhalten von dünnen Platten zu analysieren. Die vorliegende Masterarbeit zielt darauf ab, die theoretischen Grundlagen zur Formulierung von FEM-Methoden für Kirchhoff-Platten systematisch aufzubereitet und in der Programmiersprache JULIA zu implementieren.

Nicht zuletzt wird durch die Implementierung in JULIA ein modernes und leistungsfähiges Werkzeug genutzt, sondern auch die Möglichkeit geschaffen, die Ergebnisse offen zugänglich zu machen und zur Weiterentwicklung der FEM-Methoden beizutragen.

== Problemstellung
<sec-problemstellung>
Die Analyse von Plattentragwerken ist eine zentrale Aufgabe im Bauingenieurwesen, da sie in einer Vielzahl von Konstruktionen eine wesentliche Rolle spielen. Die Ingenieursliteratur zur Implementierung der FEM für Kirchhoff-Platten beschränkt sich oft auf rechteckige Elemente und ist auch hier teilweise lückenhaft. Für die Berechnung komplexer Strukturen ist die Formulierung für allgemeine Vierecke jedoch von wesentlicher Bedeutung.

Die Verträglichkeit der Rotation von benachbarten Elemente stellt bei der Finite Elemente Analyse eine besondere Herausforderung dar. Ist die Verträglichkeit bei benachbarten Rechteckelementen am gemeinsamen Knoten gegeben, sodass bei der Darstellung der Rotationen keine Knicke vorhanden sind, so wird bei dem Elementansatz von einer sogenannten $C^1$-Kontinuität gesprochen. Diese Kontinuität erfüllt der kubische Ansatz des Bogner-Fox-Schmitt Elements. Für die Berechnung allgemeiner Vierecke ist dieser Ansatz jedoch unbrauchbar, da der zusätzliche Freiheitsgrad $theta_(xi eta)$ störend wirkt.

Ziel dieser Arbeit ist die Herleitung einer ausgewählten Formulierung für allgemeine Vierecke, sowie die Implementierung in der Programmierumgebung JULIA. An ausgewählten Anwendungsbeispielen wird die Umsetzung verifiziert und dadurch eine offene und nachvollziehbare Lösung für die Anwendung der Kirchhoff-Plattentheorie geschaffen.

Zudem ist das grundlegende Verständnis der Finite Element Methode und etablierter Elementansätze von großer Wichtigkeit. Die Erläuterung numerischer Methoden für die Kirchhoffsche Plattentheorie ist, vor allem in der deutschsprachigen Literatur, bisher sehr lückenhaft. Daher stellt die Aufarbeitung theoretischer Grundlagen, die zur Formulierung der FEM für Kirchhoffplatten notwending sind ein weiteres Ziel dar. Dies beinhaltet sowohl mechanischen Zusammenhänge, als auch mathematische Verfahren.

== Gliederung der Arbeit
<sec-gliederung>
Die Grundlagen der Finite Elemente Methode sind in @sec-Grundlagen-FEM dargestellt. Dabei werden zunächst diverse Elementansätze für finite Elemente erläutert und deren Kontinuität dargestellt. Weiterhin werden die mathematischen Werkzeuge zur Anwendung der FEM beschrieben und in @sec-einfuehrungsbeispiel auf das Einführungsbeispiel angewandt.

Die zur Analyse notwendigen Differentialgleichungen einer Platte nach Kirchhoff werden in @sec-mech-math-grundlagen hergeleitet. Weiterhin sind die mathematisch relevanten Grundlagen für die aus der DGL entstehenden Funktionale sowie die Cialet’sche Definition eines finiten Elements in @sec-mech-math-grundlagen aufgeführt.

Für die Analyse von Plattentragwerken wird dann in @sec-fem-plattentragwerke zunächst die allgemeines schwache Form des Problems hergeleitet um danach die globale Steifigkeitsmatrix sowohl für das Rechteckelement nach Bogner Fox und Schmitt als auch für das allgemeine DKQ Element zu berechnen.

Die programmtechnische Umsetzung in der noch sehr neuen Programmierumgebung JULIA, sowie die Anwendung auf Beispiele zur Testung, sind in #strong[?\@sec-Umsetzung-Julia-Beispiele] dokumentiert.

#pagebreak()
#set page(header: align(right, emph(text(size: 12pt)[Kapitel 2: Grundidee der Finite Elemente Methode])))
= Grundidee der Finite Elemente Methode
<sec-Grundlagen-FEM>
Die Finite Elemente Methode ist seit vielen Jahren ein fester Bestandteil, bei der Berechnung komplexer Strukturen im Bauingenieurwesen. Dabei wird ein physikalisches Problem als idealisiertes, möglichst realitätsnahes mathematisches Modell dargestellt und durch numerische Berechnungsverfahren näherungsweise gelöst. Nicht nur in der Baubranche findet dieses Verfahren seine Anwendung, auch in der Luft- und Raumfahrtechnik, Automobil-, Elektronik- und Schifffahrtsindurstrie gewinnt die FEM immer weiter an Bedeutung.

Nachdem in @sec-einfuehrungsbeispiel, anhand eines Einführungsbeispiel, der Ablauf der Finite Elemente Analyse demonstriert wird, gibt @sec-einfuehrung-FEM einen allgemeineren Überblick über die FEM. Für die numerische Lösung zweidimensionaler Problem ist die Konstruktion von Basisfunktionen notwendig. Das mathematische Vorgehen, sowie die Forderungen nach bestimmten Kontinuitätsbedingungen werden in @sec-basis-funktionen vorgestellt. Dem Ablaufschema entsprechend wird desweiteren das Vorgehen der Approximation von Funktionen in @sec-approximation-funktionen erläutert. Abschließend wird in @sec-numerische-loesung das lineare Gleichungssystem, welches den zentralen Punkt der FEM bildet, hergeleitet.

== Einführungsbeispiel: Biegebalken
<sec-einfuehrungsbeispiel>
Um die grundlegenden Ideen der Finite Elemente Methode zu verstehen, wurde für das Einführungsbeispiel ein eindimensionales Problem gewählt. Im weiteren Verlauf der Arbeit wird diese Vorgehensweise auf zweidimensionale Aufgabenstellungen übertragen. Das nachfolgende Beispiel ist ein Biegebalken, welcher an beiden Seiten gelenkig gelagert ist siehe \(@fig-Einfuehrungsbeispiel). Um die physikalsche Problemstellung in ein mathematische Modell zu übertragen, werden einleitend die kinematischen Gleichungen und die Gleichgewichtsbeziehungen des Euler-Bernoulli-Balken hergeleitet. Ziel ist es, das Randwertproblem in Form einer Differentialgleichung mit Randbedingungen zu formulieren. Es wird häufig von der #emph[starken Form] des Problems geredet, welche die Grundlage für die Finite Elemente Analyse bildet.

#figure([
#box(width: 75%,image("00-pics/Balken-Beispiel.png"))
], caption: figure.caption(
position: bottom, 
[
Einführungsbeispiel: Biegebalken
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
numbering: "1", 
)
<fig-Einfuehrungsbeispiel>


=== Kinematische Gleichungen
<kinematische-gleichungen>
Die nachfolgend beschriebenen Zusammenhänge beruhen auf den beiden Bernoulli-Hypothesen. Die erste Hypothese besagt, dass der Querschnitt des Balkens im unverformten und im verformten Zustand eben ist und sich nicht verwölbt \(#emph[Ebenbleiben des Querschnitts];). Zudem wird davon ausgegangen, dass die Querschnittsfläche im verformten Zustand senkrecht zur neutralen Achse bleibt \(#emph[Senkrechtbleiben des Querschnitts];).

Die Durchbiegung des verformten Balken wird durch $w (x)$ beschrieben. Die Ableitung $w prime (x)$ gibt die Neigung der neutralen Achse an und entspricht somit dem Verdrehwinkel der Achse an der Stelle $x$. Es ergibt sich, entsprechend der Annahmen nach Bernoulli, der Zusammenhang #math.equation(block: true, numbering: "(1)", [ $ theta = - w prime (x) quad . $ ])<eq-verdrehwinkel>

Die horizontale Verschiebung des Punktes P, in Abhängigkeit der Balkenhöhenkoordinate $y$ und der Ableitung der Verformung, wird durch #math.equation(block: true, numbering: "(1)", [ $ u (x , y) = - y dot.c w prime (x) $ ])<eq-horizontale-verschiebung-balken>

beschrieben.

#figure([
#box(width: 60%,image("00-pics/Verformter-Balken.png"))
], caption: figure.caption(
position: bottom, 
[
verformter Balken
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)


Durch die weitere Annahmen von linear-elastischem Materialverhalten, ausgedrück durch das Hooksche Gesetz, ergibt sich in Abhängigkeit von dem Elastizitätsmodul $E$, der Durchbiegung $w (x)$ und dem Flächenträgheitsmoment #math.equation(block: true, numbering: "(1)", [ $ I_z = integral_A y^2 d A $ ])<eq-flaechentraegheitsmoment-balken>

das Schnittmoment #math.equation(block: true, numbering: "(1)", [ $ M_z = - E I dot.op w prime.double (x) quad . $ ])<eq-schnittmoment-balken>

=== Gleichgewichtsbeziehungen
<gleichgewichtsbeziehungen>
Bei der Betrachtung des Gleichgewichts an einem finiten Element der Größe $Delta x$, ergeben sich die Gleichgewichtsbedingungen #math.equation(block: true, numbering: "(1)", [ $  & sum V : quad V (x + Delta x) - V (x) + q_z dot.op Delta x & = 0\
 & sum M : quad M (x + Delta x) - M (x) - q_z dot.op frac(Delta x^2, 2) - V (x + Delta x) dot.op Delta x & = 0 . $ ])<eq-gleichgewichtsbeziehungen-balken>

Nach Division der Beziehungen mit $Delta x$ und Berechnung des Grenzwertes mittels $lim_(Delta x arrow.r 0)$, folgen durch Anwendung des Differentialquotienten die Zusammenhänge #math.equation(block: true, numbering: "(1)", [ $ V prime (x) & = - q_z (x)\
M prime (x) & = V (x)\
M prime.double (x) & = - q_z (x) $ ])<eq-zusammenhaenge-aus-GG>

#figure([
#box(width: 75%,image("00-pics/Schnittgroessen-balken.png"))
], caption: figure.caption(
position: bottom, 
[
Schnittgrößen am Bernoulli Balken
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)


=== Starke Form zur schwachen Form
<sec-Balken-stark-schwache-Form>
Aus den @eq-schnittmoment-balken und @eq-zusammenhaenge-aus-GG lässt sich für das Stabelement der Länge $L$ die #emph[starke Form] des Problems wie folgt formulieren: \

#block(
fill:luma(230),
inset:8pt,
radius:4pt,
[
#emph[Randwertproblem D \(Balken)] \
\
Gesucht ist die Funktion $w : [0 , L] arrow.r bb(R)$ welche die Differentialgleichung \
\
#math.equation(block: true, numbering: "(1)", [ $ E I dot.op w^(i v) (x) = - q_z (x) $ ])<eq-randwertproblem-balken>

und die Randbedingungen \
\
$  & w (0) = w_0 quad quad & o d e r quad quad & V_0 = - E I dot.op w prime.triple (0) = A_z\
 & w (L) = w_1 quad quad & o d e r quad quad & V_1 = - E I dot.op w prime.triple (L) = B_z\
 & w prime (0) = phi_0 quad quad & o d e r quad quad & M_0 = - E I dot.op w prime.double (0) = 0\
 & w prime (L) = phi_1 quad quad & o d e r quad quad & M_1 = - E I dot.op w prime.double (L) = 0 $

erfüllt.

])

Um die Idee der FEM umzusetzen, ist es notwendig das Problem in der sogenannten #emph[schwache Form] zu formulieren. Hierzu muss die Differentialgleichung aus @eq-randwertproblem-balken mit der Testfunktion $delta w : [0 , L] arrow.r bb(R)$ multipliziert werden und das Ergebnis dann auf beiden Seiten integriert werden, sodass daraus \
#math.equation(block: true, numbering: "(1)", [ $ E I dot.op integral_0^L w^(i v) (x) dot.op delta w (x) d x = integral_0^L - q_z (x) dot.op delta w (x) d x . $ ])<eq-basis-fe-loesung>

folgt. Nach zweifacher partieller Integration der linken Seite von @eq-basis-fe-loesung ergibt sich das Variationsproblem, bzw. die schwache Form, für den Biegebalken.

#block(
fill:luma(230),
inset:8pt,
radius:4pt,
[
#emph[Variationsproblem V \(Biegebalken)] \
\
Gesucht ist die Funktion $w : [0 , L] arrow.r bb(R)$, sodass #math.equation(block: true, numbering: "(1)", [ $ E I dot.op integral_0^L w prime.double (x) dot.op delta w prime.double (x) d x =\
- q_z dot.op integral_0^L delta w (x) d x + V_1 dot.op delta w (L) - V_0 dot.op delta w (0) - M_1 dot.op delta w prime (L) + M_0 dot.op delta w prime (0) $ ])<eq-variationsproblem-balken>

für \(fast) jede beliebige Testfunktionen $delta w$.

])

Das Variationsproblem lässt sich mit Hilfe von Funktionalen in eine generelle Form bringen, welche auch für andere physikalische Probleme die Basis darstellt. Die linke Seite der @eq-variationsproblem-balken wird als Bilinearform $a : V times V arrow.r bb(R)$ und die rechte Seite als Linearform $b : V arrow.r bb(R)$ definiert, wobei $V$ die Menge von Funktionen darstellt. Auf die Eigenschaften der verwendeten Funktionale wird im Zuge der Anwendung der FEM im zweidimensionalen Raum noch näher eingegangen.

#block(
fill:luma(230),
inset:8pt,
radius:4pt,
[
#emph[Abstraktes Variationsproblem \(Balken)] \
\
Gesucht ist die Funktion $w in V$, sodass #math.equation(block: true, numbering: "(1)", [ $ a (w , delta w) = b (delta w) quad forall quad delta w in V $ ])<eq-abstraktes-variationsproblem-balken>

])

Weiter kann das Abstrakte Variationsproblem des Balken auf den endlich großen Vektorraum $V_h$, welcher ein Unterraum von $V$ ist, reduziert werden. $V_h$ bezeichnet die Menge aller möglichen Linearkombinationen von $phi_1 , phi_2 , . . . , phi_N$ wobei $phi_i upright("mit") i = 1 . . . N$ die Basisfunktionen sind und $N$ die Dimension des Raums $V_h$. Die Näherungslösung von $w_h$ wird durch #math.equation(block: true, numbering: "(1)", [ $ w_h (x) = phi_1 (x) dot.op hat(w)_1 + phi_2 (x) dot.op hat(w)_2 + . . . + phi_N (x) dot.op hat(w)_N = sum_(i = 1)^N phi_i (x) dot.op hat(w)_i $ ])<eq-linearkombination>

mit #math.equation(block: true, numbering: "(1)", [ $  & V_h = L i n (phi_1 , phi_2 , . . . , phi_N) = { sum_(i = 1)^N phi_i dot.op hat(w)_i \| hat(w)_i in bb(R) } ,\
 & V_h subset V $ ])<eq-subspace>

ausgedrückt. Das sich daraus ergebende Problem wird #emph[abstracktes, diskretes Variationsproblem] bezeichnet. Das ursprüngliche #emph[Abstrakte Variationsproblem] bei dem eine Funktion $w in V$ gesucht wird, wird ersetzt, durch das Suchen nach den reele Zahlen $hat(w)_i$.

#block(
fill:luma(230),
inset:8pt,
radius:4pt,
[
#emph[Abstraktes, diskretes Variationsproblem \(Balken)] \
\
Gesucht ist eine Funktion $w_h in V_h$, sodass #math.equation(block: true, numbering: "(1)", [ $ a (w_h , delta w_h) = b (delta w_h) quad forall quad delta w_h in V_h $ ])<eq-abstraktes-diskretes-variationsproblem-balken>

])

Zur numerischen Lösung des abstrakten, diskreten Variationsproblems werden

$ delta w_h = sum_(i = 1)^N phi_i dot.op delta hat(w)_i quad quad upright("und") quad quad w_h = sum_(j = 1)^N phi_j dot.op hat(w)_j $

in @eq-abstraktes-diskretes-variationsproblem-balken eingesetzt. Es ergibt sich das Gleichungssystem #math.equation(block: true, numbering: "(1)", [ $ sum_(j = 1)^N a (phi_j , phi_i) dot.op hat(w)_j = b (phi_i) , quad upright("mit") quad j = 1 , . . . , N , $ ])<eq-weißnochnicht02>

wobei $N$ die Anzahl der Gleichungen angibt. Das lineare Gleichungssystem wird weitgehend in der Literatur durch #math.equation(block: true, numbering: "(1)", [ $ bold(K) bold(hat(w)) = bold(r) . $ ])<eq-gleichungssystem-balken>

mit $  & bold(K) &  & = K_(i j) &  & = a (phi_j , phi_i)\
 & bold(r) &  & = r_i &  & = b (phi_i) $

beschrieben. Hierbei wird $bold(K)$ als Gesamtsteifigkeitsmatrix bezeichnet und $bold(r)$ als Lastvektor. Der Verschiebungsvektor #strong[$hat(w)$] ist unbekannt und wird durch die Lösung des Gleichungssystems approximiert.

=== Assemblierung Steifigkeitsmatrix Biegebalken
<sec-ke-biegelbalken>
Bei der Finite Elemente Analyse eines Euler-Bernoulli-Balken wird dessen Definitionsbereich $Omega = [0 , l]$ in mehrere Elemente $Omega_e upright("mit") e = 1 , . . . , N_e$ unterteilt. Diese Elemente werden durch Knoten $x_n upright("mit") n = 1 , . . . , N_n$ verbunden, so dass im einfachsten Fall $Omega_e = [x_e , x_(e + 1)]$ gilt.

#figure([
#box(width: 100%,image("00-pics/Balkenelemente.png"))
], caption: figure.caption(
position: bottom, 
[
Balkenelement
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)


Als Basisfunktionen werden bei diesem Beispiel die Hermite-Polynomen genutzt. Um $C^1$-Kontinuität zwischen den Elementen $Omega_e$ zu erreichen, müssen, bei der Kombination der Basisfunktionen, sowohl die Verschiebung $w$, als auch die Ableitung der Verschiebung $w prime$ an den Knoten übereinstimmen. Die Freiheitsgrade eines Euler-Bernoulli-Balkenelements ergeben sich somit zu #math.equation(block: true, numbering: "(1)", [ $ hat(w)_e = mat(delim: "[", w_1; theta_1; w_2; theta_2; #none) , $ ])<eq-verschiebungsvektor>

mit Berücksichtigung der Vereinbarung aus @eq-verdrehwinkel. Die Hermite-Polynome bezogen auf das eindimensionale Referenzelement, mit dem Interval $Î := [- 1 , 1]$, sind in @fig-Hermite-Funktionen dargestellt.

#figure([
#box(width: 60%,image("00-pics/Hermite-Polynome.png"))
], caption: figure.caption(
position: bottom, 
[
Hermite Funktionen
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
numbering: "1", 
)
<fig-Hermite-Funktionen>


Für einen Euler-Bernoulli-Balken bedingt die Funktion $H_1$ den Verschiebungsfreiheitsgrad an dem Knoten 1 \($xi = - 1$) und die Funktionen $H_2$ den Verdrehungsfreiheitsgrad an dem selben Knoten. Die Funktionen $H_3$ und $H_4$ steuern zu den jeweiligen Freiheitsgrade an Knoten 2 \($xi = 1$) bei. Es gelten demnach die Bedingungen

#math.equation(block: true, numbering: "(1)", [ $ H_1 (- 1) & = 1 , quad & H_1 (1) = 0 , quad & H_1 prime (- 1) = 0 , quad & H_1 prime (1) = 0\
H_2 (- 1) & = 0 , quad & H_2 (1) = 1 , quad & H_2 prime (- 1) = 0 , quad & H_2 prime (1) = 0\
H_3 (- 1) & = 0 , quad & H_3 (1) = 0 , quad & H_3 prime (- 1) = 1 , quad & H_3 prime (1) = 0\
H_4 (- 1) & = 0 , quad & H_4 (1) = 0 , quad & H_4 prime (- 1) = 0 , quad & H_4 prime (1) = 1 ,\
 $ ])<eq-Bedingungen-Hermite>

Die kubischen Polynome #math.equation(block: true, numbering: "(1)", [ $ H_1 (xi) & = 1 / 4 (2 - 3 xi + xi^3)\
H_2 (xi) & = 1 / 4 (1 - xi - xi^2 + xi^3)\
H_3 (xi) & = 1 / 4 (2 + 3 xi - xi^3)\
H_4 (xi) & = 1 / 4 (- 1 - xi + xi^2 + xi^3)\
 $ ])<eq-Hermite-Funktionen>

erfüllen die Randbedingungen auf dem eindimensionalen Referenzelement. Bezogen auf das physikalische Element der Länge $l_e$ ergeben sich die Basisfuntionen zu #math.equation(block: true, numbering: "(1)", [ $  & H_1 (x) = 1 - 3 dot.op x^2 / l_e^2 + 2 dot.op x^3 / l_e^3\
 & H_2 (x) = x - 2 dot.op x^2 / l_e + x^3 / l_e^2\
 & H_3 (x) = 3 dot.op x^2 / l_e^2 - 2 dot.op x^3 / l_e^3\
 & H_4 (x) = - x^2 / l_e + x^3 / l_e^2 . $ ])<eq-hermite-Elementlaenge>

Für ein Element mit den Knoten $x_j$ und $x_(j + 1)$ gelten die Eigenschaften des #emph[Kronecker-Deltas] für die Formfunktionen $H_i$, beschrieben durch #math.equation(block: true, numbering: "(1)", [ $ phi_i (x_j) = delta_(i j) = cases(delim: "{", 1 quad & upright("für ") quad i = j, 0 quad & upright("für ") quad i eq.not j) $ ])<eq-konecker-delta-01>

und #math.equation(block: true, numbering: "(1)", [ $ phi_i prime (x_j) = delta_(i j) = cases(delim: "{", 1 quad & upright("für ") quad i = j, 0 quad & upright("für ") quad i eq.not j .) $ ])<eq-konecker-delta-02>

Die Länge des physikalischen Elements $Omega_e$ ergibt sich aus der Differenz zweier Knotenkoordinaten $ l_e = x_(j + 1) - x_j . $

Für die Berechnung der Steifigkeitsmatrix $bold(K)$ wird der Umrechnungsfaktor #math.equation(block: true, numbering: "(1)", [ $ F_e^(- 1) (x) = - 1 + 2 dot.op frac(x - x_e, l_e) quad quad quad upright("mit der Ableitung") quad quad quad F_e^(- 1) prime (x) = 2 / l_e $ ])<eq-umrechnungsfaktor>

benötigt, um die $xi$-Koordinate des Referenzelements in Abhängigkeit von der $x$-Koordinate des physikalischen Elements zu formulieren. Beispielhaft wird die Formfunktion $phi_3$ auf dem Element $Omega_2$ zwischen den Knoten $x_2$ und $x_3$ betrachtet \(siehe @fig-Basisfunktionen). Diese Funktion entspricht der Funktion $H_1$ der Hermite-Polynome Mithilfe des Umrechnungsfaktors wird $ phi_3 (x) = H_1 (F_2^(- 1)) #h(2em) forall #h(2em) x in Omega_2 $

definiert. Analog dazu können $phi_1$ zwischen den Knoten $x_1$ und $x_2$ \(Element $Omega_1$), $phi_5$ zwischen den Knoten $x_3$ und $x_4$ \(Element $Omega_3$), und alle weiteren #emph[ungeraden] Formfunktionen betrachtet werden. Auf dem Element $Omega_2$ werden zudem die Formfunktion $ phi_4 (x) = alpha dot.op H_2 (F_2^(- 1)) #h(2em) forall #h(2em) x in Omega_2 $

und dessen Ableitung $ phi_4 prime (x) = alpha dot.op H_2 (F_2^(- 1)) dot.op F_2^(- 1) prime (x) #h(2em) forall #h(2em) x in Omega_2 $

definiert. Durch das Einsetzen von @eq-umrechnungsfaktor in die Ableitung und die in @eq-konecker-delta-02 beschriebenen Eigenschaften der Formfunktionen, ergibt sich in allgemeiner Form $ alpha = l_e / 2 . $

Die Elementsteifigkeitsmatrix und der Elementlastvektor ergeben sich, mittels Anwendung der Kettenregel zur Berechnung der Ableitung der Formfunktionen $H_i$, zu #math.equation(block: true, numbering: "(1)", [ $ bold(K_(i j)^e) & = E I dot.op integral_(Omega_e) phi_i prime.double dot.op phi_j prime.double d x &  & = a_i^e dot.op a_j^e dot.op frac(16 E I, l_e^4) &  & integral_(x_e)^(x_(e + 1)) H_i (F_e^(- 1) (x)) prime.double dot.op H_j (F_e^(- 1) (x)) prime.double d x\
bold(r^e) & = q_z dot.op integral_(Omega_e) phi_i (x) d x &  & = a_i^e dot.op q_z dot.op &  & integral_(x_e)^(x_(e + 1)) H_i (F_e^(- 1) (x)) d x $ ])<eq-K-und-r-balken>

mit $ a_i^e = cases(delim: "{", 1 & upright("für ") quad i = upright("2,4,6,..."), l_e / 2 & upright("für ") quad i = upright("1,3,5,... ,")) $

Sowohl die finale Elementsteifigkeitsmatrix, als auch der finale Elementlastvektor, bezogen auf das Referenzelement, ergeben sich durch die Vereinbarung aus @eq-umrechnungsfaktor mit $xi = F_e^(- 1) (x)$ und Substitution des Differenzialoperators $ frac(d xi, d x) = F_e^(- 1) prime (x) = 2 / l_e #h(2em) arrow.r #h(2em) d x = l_e / 2 d xi $

zu #math.equation(block: true, numbering: "(1)", [ $ bold(K_(i j)^e) & = a_i^e dot.op a_j^e dot.op frac(8 E I, l_e^3) dot.op integral_(- 1)^1 H_i prime.double (xi) dot.op H_j prime.double (xi) d xi\
upright("und") bold(r^e) & = q_z dot.op frac(l e, 2) dot.op a_i integral_(- 1)^1 N_i (xi) d xi . $ ])<eq-lastvektor-final-balken>

#figure([
#box(width: 100%,image("00-pics/Hermite-Polynome-Balken.png"))
], caption: figure.caption(
position: bottom, 
[
Elementweise Basisfunktionen $phi_i$
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
numbering: "1", 
)
<fig-Basisfunktionen>


Für eine Element der Länge $l_e$ und konstanter Steifigkeit $E I$ ergibt sich die Elementsteifigkeitsmatrix zu #math.equation(block: true, numbering: "(1)", [ $ bold(K_(i j)^e) = frac(E I, l_e^3) dot.op mat(delim: "[", 12, 6 l_e, - 12, 6 l_e; 6 l_e, 4 l_e^2, - 6 l_e, 2 l_e^2; - 12, - 6 l_e, 12, - 6 l_e; 6 l_e, 2 l_e^2, - 6 l_e, 4 l_e^2; #none) . $ ])<eq-Kij-balken>

Bei einem Balkenelement, konstant belastet durch die Streckenlast $q_z$, wird der Lastvektor eines Elements durch #math.equation(block: true, numbering: "(1)", [ $ bold(r^e) = frac(q_z l_e, 2) dot.op mat(delim: "[", 1; l_e / 6; 1; - l_e / 6; #none) . $ ])<eq-re-balken>

beschrieben.

Die Lösung des Gleichungssystems @eq-gleichungssystem-balken gibt die Durchbiegung und die Verdrehung des Balkens an jedem Knoten an. Für einen Einfeldträger mit gelenkigen Auflagern an beiden Seiten und den folgenden Parametern

#block(
stroke:0.5pt + black,
inset:8pt,
[
$  & #h(2em) #h(2em) #h(2em) #h(2em) L = 20 &  & quad upright("m") &  & #h(2em) #h(2em) #h(2em) #h(2em) #h(2em) E = 35.000 dot.op 10^6 & quad upright("N/m")^2 #h(2em) #h(2em) #h(2em) #h(2em)\
 & #h(2em) #h(2em) #h(2em) #h(2em) b = 0.3 &  & quad upright("m") &  & #h(2em) #h(2em) #h(2em) #h(2em) #h(2em) I_y = 5.4 dot.op 10^(- 3) & quad upright("m")^4 #h(2em) #h(2em) #h(2em) #h(2em)\
 & #h(2em) #h(2em) #h(2em) #h(2em) h = 0.6 &  & quad upright("m") &  & #h(2em) #h(2em) #h(2em) #h(2em) #h(2em) q_z = - 10 dot.op 10^3 & quad upright("N/m") #h(2em) #h(2em) #h(2em) #h(2em)\
 $

])

ist in @fig-Durchbiegung-Balken die Durchbiegung mittels FEA für $N_e = 2 , 4 , 8 , 16 , 32$ Elemente dargestellt. Zum Vergleich ist die exakte Lösung der Durchbiegung des Einfeldträgers #math.equation(block: true, numbering: "(1)", [ $  & w (x) = frac(1 + xi overline(xi), 24 E I) xi overline(xi) q_z L^4\
 $ ])<eq-Durchbiegung-exakt-balken>

mit den Konstanten $  & xi = x / L\
 & overline(xi) = frac(L - x, L) $

und konstanter Streckenlast in demselben Diagramm zu sehen.

#figure([
#box(width: 100%,image("00-pics/Balken-Durchbiegung.png"))
], caption: figure.caption(
position: bottom, 
[
Exakte Lösung und FEA-Lösung
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
numbering: "1", 
)
<fig-Durchbiegung-Balken>


== Einführung in die Finite Elemente Methode \(FEM)
<sec-einfuehrung-FEM>
In der Baubranche findet die FEM vor Allem bei zwei- und dreidimensionalen Problemen Anwendung. Ein Beispiel für ein zweidimensionales Problem sind Plattentragwerke, welche durch dreieckige und viereckige Elemente abgebildet werden können. Die Lösung der Probleme ist in jedem Fall nur eine Näherung, dessen Güte abhängig von den gewählten Verschiebungsansätzen ist. Die Verschiebungsansätze der Finite Elemente beruhen auf der Annahme von Verschiebungsverläufen des Elements, den sogenannten Formfunktionen. Bei dem bilinearen Verschiebungsansatz ist der Verlauf beispielsweise geradlinig zwischen je zwei Knotenpunkten des Elements. Einen Überblick über weitere Elementansätze von quadratischen Elementen gibt @tbl-elementansaetze. Es sei darauf hingewiesen, dass die Aufreihung nicht vollständig ist.

#figure([
#figure(
align(center)[#table(
  columns: 4,
  align: (col, row) => (left,left,center,center,).at(col),
  inset: 6pt,
  [#strong[Elementansatz];], [#strong[Polynome];], [#strong[Elementknoten];], [#strong[Stetigkeit];],
  [linear],
  [$mat(delim: "[", 1, xi, eta)$],
  [$4$],
  [$C^0$],
  [quadratisch],
  [$mat(delim: "[", 1, xi, eta, xi^2, xi eta, eta^2)$],
  [$4$],
  [$C^0$],
  [LAGRANGE],
  [],
  [],
  [],
  [bilinear],
  [$mat(delim: "[", 1, xi, eta, xi eta)$],
  [$4$],
  [$C^0$],
  [quadratisch vollständig],
  [$mat(delim: "[", 1, xi, eta, xi^2, xi eta, eta^2, xi^2 eta, xi eta^2, xi^2 eta^2)$],
  [$9$],
  [$C^0$],
  [quadratisch unvollständig \(Serendipity)],
  [$mat(delim: "[", 1, xi, eta, xi^2, xi eta, eta^2, xi^2 eta, xi eta^2)$],
  [$8$],
  [$C^0$],
  [HERMITE],
  [],
  [],
  [],
  [kubisch vollständig],
  [$mat(delim: "[", 1, xi, eta, xi^2, xi eta, eta^2, xi^3, xi^2 eta, xi eta^2, eta^3, xi^3 eta, xi eta^3)$],
  [$4$],
  [$C^1$],
  [kubisch unvollständig],
  [$mat(delim: "[", 1, xi, eta, xi^2, xi eta, eta^2, xi^3, xi^2 eta, xi eta^2, eta^3, xi^3 eta, xi eta^3)$],
  [$4$],
  [semi-$C^1$],
)]
)

], caption: figure.caption(
position: bottom, 
[
Elementansätze in der FEM
]), 
kind: "quarto-float-tbl", 
supplement: "Table", 
numbering: "1", 
)
<tbl-elementansaetze>


Bereits in den frühen 1940er Jahren lässt sich die erste Anwendung der Finite Elemente Analyse verzeichnen. 1941 nutzte A. HRENNIKOF zum ersten mal zur Lösung eines 2D-Scheibenproblems ein Stabmodell, welches der heutigen FE-Methode ähnelt. Wenig später hat R. COURAND ein Paper publiziert \(1943), in dem Differentialgleichungen, durch den Ansatz von Testfunktionen auf dreieckigen Teilbereichen, gelöst werden. In den 1950er Jahren wurden die ersten Einsätze der Finite Elemente Methode in der Luft- und Raumfahrtindustrie verzeichnet. M.J. TURNER et al.~hat 1959 in dem JOURNAL OF THE AERONAUTICAL SCIENCES eine der frühesten Veröffentlichungen zu der Grundidee der FEM gemacht. Der Co-Autor R. W. CLOUGH publizierte ein weiteres Paper, welches zum ersten Mal die Formulierung #emph[Finite Elemente] nutzte. Neben den beiden genannten Autoren, sind weitere bedeutende Wissenschaftler, die zu der Entwicklung der FEM erheblich beigetragen haben, Ted Belytschko, Olgierd C. Zienkiewicz u.v.a.

Um einen ersten Überblick über die Finite Elemente Methode zu schaffen ist in @fig-Ablauf-FEM der formale Ablauf dargestellt, wie die FEM heutzutage bei der Lösung von Problemen eingebracht wird. In den meisten Fällen liegt das zu berechnende Bauteil als CAD-Modell vor. Aus diesem Modell soll im Vorgang des Preprozessing ein FE-Modell erstellt werden. Teil dessen ist die Generierung eines Netzes mit Finiten Elementen, der Zuweisung von Elementdaten und Materialinformationen, das Aufbringen von Lasten, sowie die Festlegung von Randbedingungen. Ein dadurch erstelltes lineares Gleichungssystem wird im Zuge der FEM gelöst. Die Ergebnisauswertung erfolgt im Postprozessor durch die Darstellung von Verformungen, Spannungen und Schnittgrößen.

#figure([
#box(width: 40%,image("00-pics/Ablauf-FEM.png"))
], caption: figure.caption(
position: bottom, 
[
formaler Ablauf
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
numbering: "1", 
)
<fig-Ablauf-FEM>


Der Ablauf der computergestützten numerischen Berechnung wurde bereits in @sec-einfuehrungsbeispiel anhand des Biegebalkens erläutert und wird in allgemeiner Form in dem Ablaufschema @fig-Ablauf-FEM-Berechnung visualisiert. Die Basisidee der Finite Elemente Methode ist die Lösung eines Problems möglichst genau zu approximieren. Die Approximation der gesuchten Lösungsfunktion $w_h = sum phi_i hat(w)_i$ erfolgt durch die Kombination von bereits bekannten Funktionen, welche elementweise definiert werden \(Schritt \(4), @fig-Ablauf-FEM-Berechnung). Hierfür muss das lineare Gleichungssystem, hergeleitet aus der schwachen Form des Problems $a (w , delta w) = b (delta w)$, gelöst werden. Die zweite Idee, auf der die FEM beruht, ist die Unterteilung des Gebiets in sogenannte Elemente, auf denen die Formfunkionen $phi_i$ definiert werden. Diese Basisfunktionen werden in @sec-FE-Lagrange bis @sec-FE-Hermite-konform für unterschiedliche Elementtypen hergeleitet.

#figure([
#box(width: 95%,image("00-pics/Ablauf-FEM-Berechnung.png"))
], caption: figure.caption(
position: bottom, 
[
Ablauf der Finite Elemente Berechnung
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
numbering: "1", 
)
<fig-Ablauf-FEM-Berechnung>


Die, auf dem physikalischen Problem basierenden, Grundgleichungen und Randbedingungen beschreiben die starke Form \(Schritt \(1), @fig-Ablauf-FEM-Berechnung), die in den meisten Fällen eine partielle Differentialgleichungen ist. Zwischen der Approximierten Lösung und der exakten Lösung entsteht der sogenannte Diskretisierungsfehler, d.h der Unterschied zwischen dem Designmodell und dem Analysemodell. Dieser Fehler kann durch die Feinheit des Finite Elemente Netzes größtenteils eingedämmt werden, wohingegen Fehler bei der Modellbildung und Ergebnisinterpretation alleine bei der Anwendung der Finite-Element-Methode geschehen. Auf diese Aspekte wird hier nicht weiterführend eingegangen sondern auf den Artikel \[…\] von WERKLE verwiesen.

== Basis Funktionen der finiten Elemente
<sec-basis-funktionen>
Für die Lösung von Variationsproblemen wird das gegebene Gebiet $Omega$ in endlich viele Teilgebiete zerlegt. In dieser Arbeit werden quadratische Elemente im zweidimensionalen, ebenen, Fall betrachtet. Der Begriff #emph[Element] hat hier zwei Bedeutungen: auf der einen Seite werden die geometrischen Teilgebiete als #emph[Element] bezeichnet, während mit #emph[Finiten Elementen] hingegen Funktionen gemeint sind#footnote[vgl. Braess, S. 57, Fußnote];. Nach Braess gibt es drei Merkmale, die bei der Definition eines Finite Elemente Raums am wichtigsten sind.

+ Geometrie der Teilgebiete: Dreiecks- bzw. Viereckselemente#footnote[In dieser Arbeit werden ausschließlich Viereckelemente behandelt]

+ Im zweidimensionalen Raum werden Funktionen mit zwei Variablen definiert, welche als #emph[Polynome vom Grad] $lt.eq t$ bezeichnet werden, wenn der höchste Exponent der Variaben $lt.eq t$ ist. Vollständige Polynome sind Finite Elemente, in denen alle Polynome vom Grad $lt.eq t$ enthalten sind.

+ Stetigkeits- und Differenzierbarkeitseigenschaften: Es wird von $C^k$-Elementen gesprochen, wenn die $k upright("te")$ Ableitung der Basisfunktionen stetig ist und dementsprechend keine Knicke aufweist.

Bei der Konstruktion der Basisfunktionen sind, je nach Anforderung, für die FEM vorrangig $C^(- 1)$-, $C^0$- und $C^1$-Funktionen von Bedeutung. Eine Funktion wird $C^n$-Funktion genannt, wenn die Ableitung vom Grad $j$ mit $0 lt.eq j lt.eq n$ stetig in allen Punkten ist. Beispiele dieser sind in @fig-c-funktionen dargestellt.

#figure([
#figure(
align(center)[#table(
  columns: 4,
  align: (col, row) => (center,center,center,left,).at(col),
  inset: 6pt,
  [Kontinuität], [Knicke], [Sprünge], [Kommentar],
  [$C^(- 1)$],
  [Ja],
  [Ja],
  [stückweise stetig],
  [$C^0$],
  [Ja],
  [Nein],
  [stückweise stetig differenzierbar],
  [$C^1$],
  [Nein],
  [Nein],
  [stetig differenzierbar],
)]
)

], caption: figure.caption(
separator: "", 
position: bottom, 
[
]), 
kind: "quarto-float-tbl", 
supplement: "Table", 
numbering: "1", 
)
<tbl-kontinuität>


Die Ableitung einer $C^0$ Funktionen ist stetig, außer in den Punkten an denen die Funktion einen Knick hat. Dementsprechend ist die Ableitung der $C^0$-Funktion eine $C^(- 1)$-Funktion, welche an den Knicken der $C^0$-Funktion einen Sprung aufweist. Generell ist die Ableitungen eine $C^n$ Funktion eine $C^(n - 1)$ Funktion.

#figure([
#box(width: 75%,image("00-pics/Kontinuitaer.png"))
], caption: figure.caption(
position: bottom, 
[
Beispiel von $C^(- 1)$-, $C^0$- und $C^1$-Funktionen
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
numbering: "1", 
)
<fig-c-funktionen>


Die Formfunktionen unterschiedlicher finite Elemente Ansätze, werden für die Lösung des Problems elementweise definiert. In @fig-kombi-basis-bilinear und @fig-kombi-basis-konf-hermite sind die Formfunktionen des bilinearen Elements und des konformen Hermite Elements auf einer $8 m times 8 m$ Platte mit 9 Elementen dargestellt. Bei dem bilinearen Ansatz ist erkennbar, dass es sich um $C^0$-Funktionen handelt, da #emph[Knicke] an den Elementkanten vorhanden sind.

#figure([
#box(width: 100%,image("00-pics/Basisfunktionen_Bilinear.png"))
], caption: figure.caption(
position: bottom, 
[
bilineareBasisfunktionen angewandt auf $8 m times 8 m$ Platte mit 9 Elementen
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
numbering: "1", 
)
<fig-kombi-basis-bilinear>


#figure([
#box(width: 100%,image("00-pics/Basisfunktionen_Hermite.png"))
], caption: figure.caption(
position: bottom, 
[
konforme Hermite Basisfunktionen angewandt auf $8 m times 8 m$ Platte mit 9 Elementen
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
numbering: "1", 
)
<fig-kombi-basis-konf-hermite>


Nachfolgend wird die Konstruktion der Basisfunktionen des bilineare Lagrange Element, das konforme und nicht konforme Hermite Rechteckelement und das Serendipityelement erläutert. Die Definition der Formfunktionen erfolgt auf dem Referenzelement, dargestellt jeweils für die verschiedenen Elementansätze in @fig-bilineares-element, @fig-BFS-element und @fig-ref-serendipity. Das Referenzelement wird in dem $xi - eta -$ Koordinatesystem definiert mit den Eckknoten $(- 1 , - 1) , (1 , - 1) , (1 , 1) upright("und") (- 1 , 1)$.

=== Lagrange Elemente \(Bilineares Rechteckelement)
<sec-FE-Lagrange>
Das bilineare Element ist das simpelste unter den Viereckelementen. Es basiert auf einer Polynomfunktion 2. Grades mit den Polynomen

#math.equation(block: true, numbering: "(1)", [ $ 1 , x , y , x y $ ])<eq-polynome-lagrange>

wobei der bilineare Term $x y$ aus der dritten Reihe des Pascalschen Dreiecks enthalten ist \(siehe ). Sei das betrachtete Element, ein Rechteck dessen Kanten parallel zu den Koordinatenachsen verlauft, so ist das Monom $x y$ ist an jeder Kante des Elementes linear, da entweder $x$ oder $y$ konstant sind. Die vier unbekannten Parameter können jeweils durch die vier Werte an den Ecken des Rechtecks eindeutig bestimmt werden. Das Ergebnis sind die Funktionen #math.equation(block: true, numbering: "(1)", [ $ N_1^e (x , y) & = 1 / A^e (x - x_2^e) (y - y_4^e) ,\
N_2^e (x , y) & = - 1 / A^e (x - x_1^e) (y - y_4^e) ,\
N_3^e (x , y) & = 1 / A^e (x - x_1^e) (y - y_1^e) ,\
N_4^e (x , y) & = - 1 / A^e (x - x_2^e) (y - y_1^e)\
 $ ])<eq-black-scholes>

für ein rechteckiges Element, wobei $A^e$ die Fläche des Elements bezeichnet. @fig-Lagrange-Formfunktionen veranschaulicht, dass bei dem beschriebenen Verschiebungsansatz der Verlauf geradlinig zwischen je zwei Knotenpunkten des Elements ist.

#figure([
#box(width: 40%,image("00-pics/BilinearesElement.png"))
], caption: figure.caption(
position: bottom, 
[
Bilineares Element
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
numbering: "1", 
)
<fig-bilineares-element>


Für das Referenzelement $T_(r e f) = [- 1 , 1]^2$ mit den Referenzkoordinaten $xi$ und $eta$, wie in @fig-bilineares-element definiert, ergeben sich die Formfunktionen #math.equation(block: true, numbering: "(1)", [ $ N_1 (xi , eta) & = 1 / 4 (xi eta - xi - eta + 1)\
N_2 (xi , eta) & = 1 / 4 (- xi eta + xi - eta + 1)\
N_3 (xi , eta) & = 1 / 4 (xi eta + xi + eta + 1)\
N_4 (xi , eta) & = 1 / 4 (- xi eta - xi + eta + 1) .\
 $ ])<eq-formfunktionen-bilinear>

Für allgemeine Vierecke ist der oben beschriebene bilineare Ansatz untauglich. Zudem kommt der Ansatz der Forderung nach $C^1$-Stetigkeit nicht nach. Für die Parametrisierung in @sec-Parametrisierung sind die in @eq-formfunktionen-bilinear beschriebenen Formfunktionen von wesentlicher Bedeutung.

#figure([
#box(width: 75%,image("00-pics/Lagrange-Formfunktionen.png"))
], caption: figure.caption(
position: bottom, 
[
bilineare Formfunktionen auf dem Referenzelement
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
numbering: "1", 
)
<fig-Lagrange-Formfunktionen>


=== konformes Hermite Rechteckelement \(Bogner-Fox-Schmitt)
<sec-FE-BFS>
Das konforme Hermite-Rechteckelement, oder auch Bogner-Fox-Schmit \(BFS) Element genannt, bezeichnet ein Vierknotenelement mit je vier Freiheitsgraden $ w_i , theta_(xi i) , theta_(eta i) quad u n d quad theta_(xi eta i) $

in den Eckknoten. Die Nummerierung der Knoten mit $i = 1 , 2 , 3 , 4$ ist in @fig-BFS-element dargestellt. Die Freiheitsgrade $theta_(xi i)$ und $theta_(eta i)$ entsprechen der Ableitung von $w_i$ nach $xi$ bzw. $eta$ an dem Knoten $i$. Durch den zusätzlichen Freiheitsgrad $theta_(xi eta i)$, also die Ableitung zweiten Grades von $w_i$ nach $xi$ und $eta$, wird die geforderte $C^1$-Kontinuität des Elementes erreicht. Die Ansatzfunktion der Verschiebung $w (x , y)$ wird durch eine vollständige Polynomfunktion mit den Polynomen $ 1 , x , y , x^2 , x y , y^2 , x^3 , x^2 y , x y^2 , y^3 , x^3 y , x^2 y^2 , x y^3 , x^3 y^2 , x^2 y^3 , x^3 y^3 $

beschrieben. Die Parameter der Ansatzfunktion sind jeweils durch die Funktionswerte samt deren Ableitungen, ausgedrückt durch die Freiheitsgrade, an den 4 Ecken des Rechtecks eindeutig bestimmt. Die sich ergebenen Ansatzfunktionen können ebenso als Tensorprodukts der, in @sec-ke-biegelbalken beschriebenen, Hermite Polynome beschrieben werden.

#figure([
#box(width: 40%,image("00-pics/BFS-Element.png"))
], caption: figure.caption(
position: bottom, 
[
Bogner-Fox-Schmit Element
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
numbering: "1", 
)
<fig-BFS-element>


In @fig-Bogner-Fox-Schmitt-Formfunktionen sind die Formfunktionen #math.equation(block: true, numbering: "(1)", [ $ N_(i , j) (xi , eta) = H_i (xi) H_j (eta) , quad i , j = 1 , 2 , 3 , 4 $ ])<eq-BFS-Formfunktionen>

dargestellt. Für die ausformulierten Basisfunktionen wird auf \[Quelle:Def Element\] verwiesen. Für reine Rechtecke ist der Bogner-Fox-Schmitt Ansatz sehr sinnvoll, nicht aber für allgemeine Vierecke, da dort der zusätzliche Freiheitsgrad $theta_(xi eta i)$ an den vier Knoten störend wirkt.

#figure([
#box(width: 75%,image("00-pics/Bogner-Fox-Schmitt-Element.png"))
], caption: figure.caption(
position: bottom, 
[
Bogner-Fox-Schmitt Formfunktionen auf dem Referenzelement
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
numbering: "1", 
)
<fig-Bogner-Fox-Schmitt-Formfunktionen>


=== Rechteckelement der Serendipity Klasse
<sec-FE-Hermite-konform>
Die Ansatzfunktion für $w (x , y)$ für das Rechteckelement der Serendipity Klasse basiert auf einer unvollständigen quadratischen Polynomfunktion mit den Polynomen \
$ 1 , x , y , x^2 , x y , y^2 , x^2 y , x y^2 quad . $

Das Element besteht, wie @fig-ref-serendipity zeigt, aus vier Eckknoten und vier Mittelknoten in der Mitte der jeweiligen Seiten. Die Forderung nach $C^1$-Stetigkeit der Ansatzfunktionen an den Rändern benachbarter Elemente wird nicht erfüllt.

\

#figure([
#box(width: 40%,image("00-pics/Serendipity.png"))
], caption: figure.caption(
position: bottom, 
[
Serendipityelement
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
numbering: "1", 
)
<fig-ref-serendipity>


Die sich ergebenen Formfunktionen $ N_1 (xi , eta) & = 1 / 4 (- xi^2 eta - xi eta^2 + xi^2 + xi eta + eta^2 - 1) & #h(2em) #h(2em) N_5 (xi , eta) & = 1 / 2 (xi^2 eta - xi^2 - eta + 1)\
N_2 (xi , eta) & = 1 / 4 (- xi^2 eta + xi eta^2 + xi^2 - xi eta + eta^2 - 1) & #h(2em) #h(2em) N_6 (xi , eta) & = 1 / 2 (- xi eta^2 - eta^2 + xi + 1)\
N_3 (xi , eta) & = 1 / 4 (xi^2 eta + xi eta^2 + xi^2 + xi eta + eta^2 - 1) & #h(2em) #h(2em) N_7 (xi , eta) & = 1 / 2 (xi^2 eta - xi^2 + eta + 1)\
N_4 (xi , eta) & = 1 / 4 (xi^2 eta - xi eta^2 + xi^2 - xi eta + eta^2 - 1) & #h(2em) #h(2em) N_8 (xi , eta) & = 1 / 2 (xi eta^2 - eta^2 - xi + 1)\
 $

sind in @fig-Serendipity-Formfunktionen dargestellt. Häufig finden die Formfunktionen der Serendipiy Klasse Anwendung bei der Berechnung von Strukturen, dessen Elemente isoparametrisch sind. Dies ist vorallem dann der Fall, wenn die Struktur eine unregelmäßige, unsymmetrische Geometrie hat und die Elemente dementsprechend schiefwinklig und in beliebiger Lage angeordnet sind. Auf die Formulierung für allgemeine Viereckelemente wird in @sec-Steifigkeitsmatrix-DKQ und @sec-Parametrisierung näher eingegangen.

#figure([
#box(width: 75%,image("00-pics/Serendipity-Formfunktionen.png"))
], caption: figure.caption(
position: bottom, 
[
Formfunktionen des Serendipity Elements auf dem Referenzelement
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
numbering: "1", 
)
<fig-Serendipity-Formfunktionen>


== Approximation von Funktionen
<sec-approximation-funktionen>
Die zwei wesentlichen Ideen der FEM-Lösung:

+ Konstruieren einer Näherungslösung durch die Kombination von vordefinierten Funktionen und
+ Funktionen stückweise definieren auf sogenannten Elementen

werden nachfolgend näher erläutert. Die schubstarre Kichrhhoff-Platte bildet die Basis dieser Arbeit. Bei dieser Plattentheorie wird die Verformung durch $w$ beschrieben. Die Verdrehungen $theta_x$ und $theta_y$ werden durch die Ableitung der Verformung beschrieben. Für die Näherungslösung der Verformung werden Basisfunktionen $phi_1 , phi_2 , . . . , phi_N$ gewählt, sodass $w_h$ durch die Funktion #math.equation(block: true, numbering: "(1)", [ $  & w_h (x , y) = phi_1 (x , y) dot.op hat(w)_1 + phi_2 (x , y) dot.op hat(w)_2 + . . . + phi_N (x , y) dot.op hat(w)_N = sum_(i = 1)^N phi_i (x , y) dot.op hat(w)_i $ ])<eq-linearkombination-platte>

approximiert wird. Das ursprüngliche Problem, eine Lösungsfunktionen zu finden, ist jetzt ersetzt worden durch das Problem, reele Zahlen $hat(w)_1 , hat(w)_2 , . . . , hat(w)_N$ zu finden. Die Summe in @eq-linearkombination-platte versteht sich als Linearkombination von Basisfunktionen. Bei der Definition des Abstrakten Variationsproblems wurde bereits der Raum $V$ eingeführt, welcher die Menge aller Funktionen auf dem Gebiet $Omega$ beschreibt. Der Raum $V$ ist unendlich dimensional. Die Menge aller möglichen Linearkombination von $phi_1 , phi_2 , . . . , phi_N$ ist der endlich dimensionale Vektorraum

#math.equation(block: true, numbering: "(1)", [ $  & V_h = L i n (phi_1 , phi_2 , . . . , phi_N) = { sum_(i = 1)^N phi_i dot.op hat(w)_i \| hat(w)_i in bb(R) } ,\
 $ ])<eq-subspace>

wobei $V_h$ ein Unterraum von $V$ ist und $N$ die Dimension des Raums $V_h$. Die Funktionen $phi_i$ sind die Elemente des Vektorraums $V_h$. Das sich daraus ergebende Problem wird #emph[abstracktes, diskretes Variationsproblem] bezeichnet.

#block(
fill:luma(230),
inset:8pt,
radius:4pt,
[
#emph[Abstraktes, diskretes Variationsproblem] \
\
Gesucht ist eine Funktion $w_h in V_h$, sodass #math.equation(block: true, numbering: "(1)", [ $ a (w_h , delta w_h) = b (delta w_h) quad forall quad delta w_h in V_h $ ])<eq-abstraktes-diskretes-variationsproblem>

])

Die zweite Idee basiert darauf, dass das gesamte System in mehrere Elemente aufgeteilt wird und die Funktionen elementweise definiert werden. Das Berechnungsgebiet $Omega$, in diesem Fall die Platte, wird in die Elemente $Omega_e , e = 1 , . . . , N_e$ unterteilt. In dieser Arbeit wird sich auf viereckige Plattenelemente beschränkt, sodass jedes Element mindestens vier Knoten hat, je nach Elementansatz aber auch acht oder mehr Knoten haben kann \(siehe @sec-basis-funktionen). Die Basisfunktionen $phi_1 , phi_2 , . . . , phi_N$ werden elementweise definiert. Die gesuchten reelen Zahlen $hat(w)_i in bb(R)$ werden Freiheitsgrade bzw. im englischen #emph[degrees of freedom] \(abgekürzt DOF) bezeichnet.

Für die Definition des Variationsproblems in @eq-abstraktes-diskretes-variationsproblem werden die Linear- und die Bilinearform genutzt. Um im weiteren Verlauf mit dem Variationsproblem weiterrechnen zu können wird kurz auf die Eigenschaften der genutzten Funktionale eingegangen. Diese beiden Funktionale gehören dem mathematischen Teilgebiet der Funktionalanalysis an. Als Funktional werden eine Funktion bzw. Abbildung bezeichnet, die den Vektorraum $V$ in seinem Skalarkörper $bb(K)$ abbilden. Die mathematische Definition ist nachfolgend dargestellt.

#block(
fill:luma(230),
inset:8pt,
radius:4pt,
[
#emph[Definition] \(Funktional): Sei $V$ ein $bb(K)$-Vektorraum mit $bb(K) in { bb(R) , bb(C) }$. Ein Funktional $T$ ist eine Abbildung $T : V arrow.r bb(K)$.

])

Sowohl die Linearform, als auch die Bilinearform, sind, wie der Name erkennen lässt, lineare Funktionale. Als Vektorraum $V$ wird die Menge von Funktionen die $V$ abbilden genannt. Die folgenden Rechenoperationen können auf die Funktionen

$quad quad quad f , g : bb(R)^n arrow.r bb(R)$

angewandt werden: $  & upright("Addition zweier Funktionen:") &  & quad h = f + g &  & quad quad upright("definiert") quad quad h (x) = f (x) + g (x)\
 & upright("Multiplikation mit einer Zahl:") &  & quad h = alpha dot.op f &  & quad quad upright("definiert") quad quad h (x) = alpha dot.op f (x) quad , quad alpha in bb(R)\
 $

Die Linearform $b (delta w)$ des abstrakten Variationsproblems \(Einführungsbeispiel @eq-abstraktes-variationsproblem-balken, Kirchhoff-Platte @eq-linearform) beschreibt eine Abbildung von dem Vektorraum $V arrow.r bb(R)$ mit den in @eq-eig-linearform-01 und @eq-eig-linearform-02 genannten Eigenschaften.

#math.equation(block: true, numbering: "(1)", [ $ b (u + v) = b (u) + b (v) &  & quad quad quad upright("(Additivität)") $ ])<eq-eig-linearform-01>

#math.equation(block: true, numbering: "(1)", [ $  & b (alpha dot.op u) = alpha dot.op b (u) &  & quad quad quad upright("(Homogenität)") $ ])<eq-eig-linearform-02>

Die Bilinearform $a (w , delta w)$ des abstrakten Variationsproblems beschreibt die Abbildung $V times V arrow.r bb(R)$, wobei beide Funktionen demselben Vektorraum $V$ entstammen. Gemäß der Definition einer Bilinearform sind beide Funtionen linear. Die Eigenschaften der Bilinearform ergeben sich analog zu #math.equation(block: true, numbering: "(1)", [ $ a (u + v , w) = a (u , w) + a (v , w) quad , $ ])<eq-eig-bilinearform-01>

#math.equation(block: true, numbering: "(1)", [ $ a (alpha dot.op u , v) = alpha dot.op a (u , v) quad , $ ])<eq-eig-bilinearform-02>

#math.equation(block: true, numbering: "(1)", [ $ a (u , v + w) = a (u , v) + a (u , w) quad , $ ])<eq-eig-bilinearform-03>

und #math.equation(block: true, numbering: "(1)", [ $ a (u , alpha dot.op v) = alpha dot.op a (u , v) quad . $ ])<eq-eig-bilinearform-04>

Weiterführend ist die Bilinearform #emph[positiv definit] für $ a (u , u) gt.eq 0 quad forall quad u in V $

und #emph[symmetrisch] für $ a (u , v) = a (v , u) quad . $

Ist die Bilinearform sowohl positiv definit als auch symmetrisch, so wird von einem Skalarprodukt gesprochen. Dies ist im Fall der Bilinearform $a (w , delta w)$ des abstrakten Variationsproblems gegeben.

== numerische Lösung
<sec-numerische-loesung>
Die Gleichung des abstrakten diskreten Variationsproblem gilt für alle Testfunktionen $delta w_h$. Für die numerische Lösung des Problems wird dieses durch $N$ Gleichungen mit $w_h$ als Unbekannte ersetzt. Dazu wird die Linearkombination

$ delta w_h = sum_(i = 1)^N phi_i dot.op delta hat(w)_i $

eingesetzen in @eq-abstraktes-diskretes-variationsproblem. Durch die zuvor besprochenen Funktionale, angewandt auf das vorliegenden Problem ist festzustellen, dass die Sätze

#block(
fill:luma(230),
inset:8pt,
radius:4pt,
[
#math.equation(block: true, numbering: "(1)", [ $ a (w_h , delta w_h) & = b (delta w_h) #h(2em) &  & forall delta w_h in V_h\
a (w_h , Sigma_(i = 1)^N phi_i dot.op delta hat(w)_i) & = b (Sigma_(i = 1)^N phi_i dot.op delta hat(w)_i) quad &  & forall quad delta w_h in V_h\
a (w_h , phi_i) & = b (phi_i) #h(2em) &  & i = 1 , . . . , N $ ])<eq-03>

])

äquivalent sind. Im zweiten Schritt wird

$ w_h = sum_(j = 1)^N phi_j dot.op hat(w)_j $

in die dritte Zeile von @eq-03 eingesetzt, dessen Ergebniss, nach gleicher Vorhergehensweise wie oben,

$ sum_(j = 1)^N underbrace(a (phi_j , phi_i), k_(i j)) dot.op hat(w)_j = underbrace(b (phi_i), r_i) $

ist. Für das Gesamtsystem ergibt sich das lineare Gleichungssystem

#math.equation(block: true, numbering: "(1)", [ $ bold(K) bold(hat(w)) = bold(r) . $ ])<eq-lin-gleichungssystem>

mit $  & bold(K) &  & = k_(i j) &  & = a (phi_j , phi_i)\
 & bold(r) &  & = r_i &  & = b (phi_i) quad upright("mit") quad i , j = 1 , . . . , N , $

$bold(K)$ bezeichnet die Gesamtsteifigkeitsmatrix, $bold(r)$ den Lastvektor und $bold(hat(w))$ den unbekannten, zu approixmierenden Verschiebungsvektor. Die Bilinearform \(@eq-bilinearform) wird für jedes einzelne Element ausgewertet, wodurch sich die jeweiligen Elementsteifigkeitsmatrizen ergeben. Durch die Assemblierung der Elementsteifigkeitsmatrizen lässt sich die globale Steifigkeitmatrix ableiten. Die gleiche Vorgehensweise wird bei der Assemblierung des globalen Lastvektors verwendet. Die entsprechenden Bezeichnungen für ein Element sind $bold(k_(i j)^e)$ für die Elementsteifigkeitsmatrix, $bold(r^e)$ für den Elementlastvektor und $bold(hat(w)^e)$ für den Knotenverschiebungsvektor \(siehe @tbl-Variablen).

#figure([
#figure(
align(center)[#table(
  columns: 3,
  align: (col, row) => (left,center,center,).at(col),
  inset: 6pt,
  [], [Gesamtsystem], [Element],
  [Bilinearform \(Variationsproblem)],
  [$a (w , delta w)$],
  [$a (w^e , delta w^e)$],
  [Steifigkeitsmatrix],
  [$bold(K)$],
  [$bold(k_(i j)^e)$],
  [Bilinearform \(Steifigkeitsmatrix)],
  [$a (phi_j , phi_i)$],
  [$a (phi_j^e , phi_i^e)$],
  [Lastvektor],
  [$bold(r)$],
  [$bold(r^e)$],
  [Verschiebungsvektor],
  [$bold(hat(w))$],
  [$bold(hat(w)^e)$],
)]
)

], caption: figure.caption(
position: bottom, 
[
Variablen des linearen Gleichungssystem für das Gesamtsystem und elementweise.
]), 
kind: "quarto-float-tbl", 
supplement: "Table", 
numbering: "1", 
)
<tbl-Variablen>


#pagebreak()
#set page(header: align(right, emph(text(size: 12pt)[Kapitel 3: Kirchhoffsche Plattentheorie])))
= Kirchhoffsche Plattentheorie
<sec-mech-math-grundlagen>
Die Differentialgleichung des physikalischen Problems bildet den Ausgangspunkt der Finite Elemente Berechnung. Bevor in @sec-fem-plattentragwerke die Finite Elemente Methode auf die schubstarren Platten angewandt wird, werden in diesem Kapitel die Grundgleichungen der Kirchhoffsche Platte erläutert. Verschiebungsfeld \(@sec-kinematik), Verzerrungsfeld \(@sec-verzerrung) und Gleichgewichtsbeziehungen \(@sec-gleichgewicht) werden auf Grundlage der Kirchhoffschen Plattentheorie hergeleitet und bilden zusammen mit dem Materialgesetz \(@sec-materialgesetz) die Basis für die Formulierung der Differentialgleichung.

Die Lösung der Differentialgleichung erfolgt gemäß @fig-Ablauf-FEM-Berechnung mittels Unterteilung des Problemgebiets in finite Elemente.

== Einführung Plattentragwerke
<sec-einfuehrung-plattentragwerke>
Tragwerke wie Wohnhäuser, Brücken, Lagerhallen und weitere, werden in Tragwerksstrukturen wie Balken, Platten und Scheiben unterteilt. Selten besteht ein Tragwerk aus nur einem Element. Überlicherweise besteht es aus einer Zusammenstellung mehrerer Elemente, welche sich gegenseitig beeinflussen. Ziel der Modellierung des Tragwerkes ist es, ein möglichst realitätsnahes Abbild zu schaffen, um somit die Tragfähigkeit beurteilen zu können. Plattentragwerke sind ein wesentlicher Teil bei der Modellierung von Tragwerksstrukturen.

Die Zustandsgrößen, d.h. die Verschiebungsgrößen sowie die äußeren Kraftgrößen, bechreiben das mechanische Verhalten eines Tragwerks und werden zur Formulierung der Grundgleichungen, d.h. den kinematischen Gleichungen, Gleichgewichtsbeziehungen und der Einführung eines Materialgesetzes, benötigt.

#figure([
#box(width: 90%,image("00-pics/Grundgleichungen.png"))
], caption: figure.caption(
position: bottom, 
[
Zustandsgrößen und Grundgleichungen der Platte
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
numbering: "1", 
)
<fig-zg-und-gg>


Zur Berechnung der Tragwerksstrukturen werden zwei wesentliche Vereinfachungen getroffen. Zum Einen wird das Werkstoffverhalten als linear angenommen, entsprechend dem Hookschen Gesetz. Zum Anderen werden die Geometrien, je nach räumlicher Ausdehnung, als eindimensionales Linienelement oder als zweidimensionales Flächenelement definiert. Bei den Flächenelementen wird in Platten- und Scheibenelemente unterschieden. Diese in der Realität dreidimensionalen Strukturen,zeichnen sich dadurch aus, dass Länge und Breite der Struktur deutlich größer als die Dicke sind. Die Flächen werden somit auf die zwei maßgebenden Dimensionen reduziert. Flächenelemente können, in Form von Platten und Scheiben, eben, oder, in Form von Schalen, gekrümmt sein.

Bei der Berechnung von Plattentragwerken in der Finite Elemente Analyse sind zwei Theorien von wesentlicher Bedeutung. Zum einen das Kirchhoffsche Plattenmodell und zum anderen das Reissner-Mindlin Plattenmodell. Die Unterschiede der beiden Modelle, sowie die Grundgleichungen für die Kirchhoffplatte werden im Folgenden definiert. Ziel ist es, die entsprechenden Differentialgleichungen der Kirchhoffplatte herzuleiten.

== Differentialgleichung der Kirchhoff Platte
<sec-kirchhoffschen-plattentheorie>
Die Platte, als ebenes Flächentragwerk, zeichnet sich durch ausschließlich senkrecht zur Plattenmittelebene wirkende Beanspruchungen aus. Zudem ist die Plattendicke $h$ signifikant kleiner, verglichen mit den Abmessungen in der Plattenebene. Die zu Grunde liegende Theorie wurde von Gustav Kirchhoff im Jahr 1850 zum ersten Mal formuliert \[1\]. Entsprechend der Annahmen von Bernoulli in Bezug auf einen elastischen Stab, geht Kirchhoff von folgenden zwei grundlegenden kinematischen Annahmen aus: \
- eine Normale, welche im unverformten Zustand senkrecht zur Plattenmittelebene ist, bleibt auch im verformten Zustand senkrecht zu der neutralen Achse. Die Durchbiegung der verformten Platte im Abstand $z$ zur neutralen Achse wird durch #math.equation(block: true, numbering: "(1)", [ $ w = w (x , y) $ ])<eq-verformung-w>

beschrieben.

- der Plattenquerschnitt ist im verformten und unverformten Zustand eben und verwölbt sich nicht. Dies entspricht der Hypothese vom Ebenebleiben des Querschnitts beim Euler-Bernoulli-Balken.

TODO: abbildungbeschriftung innerhalb Bild ändern #box(width: 90%,image("00-pics/Kirchhoff.png"))

#figure([
#box(width: 90%,image("00-pics/Reissner-Mindlin.png"))
], caption: figure.caption(
position: bottom, 
[
Verformung einer Reissner-Mindlin Platte
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)


Neben dem beschriebenen schubstarren Plattenmodell nach Kirchhoff, darf das Modell der schubweichen Platte nicht unerwähnt bleiben. Letzteres wird in der Fachliteratur vielfach als Reissner-Mindlin-Platte aufgeführt. Den wesentlichen Unterschied stellt die Normalenhypothese dar. Die Hypothese vom Ebenebleiben des Querschnitts bleibt bei der schubweichen Platte bestehen, wohingegen die Normalenhypothese fallengelassen wird. Infolgedessen sind die Biegewinkel $theta$ nicht mehr abhängig von der Durchbiegung und stellen unabhängige Freiheitsgrade dar. Eine weitere Folge sind transversale Schubverzerrungen, welche bei der Kirchhoff-Platte vernachlässigt werden. \

=== kinematische Gleichungen \(Verschiebungsfeld)
<sec-kinematik>
Zur Formulierung der kinematischen Gleichungen werden die partiellen Ableitung von $w (x , y)$ nach $x$, beziehungsweise $y$ berechnet, welche die Neigung der neutralen Ebene angeben. Der Winkel des Steigungsdreiecks von $frac(diff w, diff y)$ oder $frac(diff w, diff x)$ an dem Punkt $P (x , y)$ der Ebene, entspricht dem Verdrehwinkel der Fläche an dem Punkt $P (x , y)$ um die x-Achse oder y-Achse. In Abhängigkeit der Verdrehwinkel

#math.equation(block: true, numbering: "(1)", [ $ theta_x (x , y) = a r c t a n (- frac(diff w (x , y), diff y)) $ ])<eq-black-scholes-02>

und #math.equation(block: true, numbering: "(1)", [ $ theta_y (x , y) = a r c t a n (- frac(diff w (x , y), diff x)) $ ])<eq-black-scholes-03>

werden die horizontalen Verschiebungen des Punktes P #math.equation(block: true, numbering: "(1)", [ $ u (x , y , z) = s i n (theta_x (x , y)) dot.op z $ ])<eq-black-scholes-04>

und #math.equation(block: true, numbering: "(1)", [ $ v (x , y , z) = s i n (theta_y (x , y)) dot.op z $ ])<eq-black-scholes-05>

berechnet. Unter der weiteren Annahme, dass die Verschiebungen und die Verdrehungen klein sind gilt $s i n (theta_x) approx theta$ und $s i n (theta_y) approx theta$ und es ergeben sich die Zusammenhänge #math.equation(block: true, numbering: "(1)", [ $ u (x , y , z) = - z dot.op frac(diff w (x , y), diff x) $ ])<eq-verschiebung-u> #math.equation(block: true, numbering: "(1)", [ $ v (x , y , z) = - z dot.op frac(diff w (x , y), diff y) . $ ])<eq-verschiebung-v>

Die Gesetztmäßigkeiten nach @eq-verformung-w, @eq-verschiebung-u und @eq-verschiebung-v werden in der Literatur auch als Verschiebungsfeld nach der Kirchhoffschen Plattentheorie bezeichnet.

#figure([
#box(width: 100%,image("00-pics/Verschiebung.png"))
], caption: figure.caption(
position: bottom, 
[
Verdrehung und Verschiebung eines Punktes nach Kirchhoff
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
numbering: "1", 
)
<fig-horizontale-Verschiebung>


=== Materialgesetz
<sec-materialgesetz>
Die bisher betrachteten kinematischen Gleichungen sind unabhäging von materialspezifischen Eigenschaften. Um das mechanische Verhalten der Platte vollständig zu beschreiben, besteht die Notwendigkeit der Einführung eines Materialgesetztes. Bei der Betrachtung von linear-elastischem Materialverhalten, also einem linearen Zusammenhang zwischen Spannungen und Verzerrungen, kann das Material durch das #emph[verallgemeinerte Hooksche Gesetz] mit

\

#math.equation(block: true, numbering: "(1)", [ $ sigma = E dot.op epsilon.alt $ ])<eq-black-scholes-08>

und #math.equation(block: true, numbering: "(1)", [ $ tau = G dot.op gamma $ ])<eq-black-scholes-09>

dargestellt werden. Die Normalspannung $sigma$ und die Schubspannung $tau$ werden durch das Elastizitätsmodul $E$ bzw. das Schubmodul $G$ und die Dehung $epsilon.alt$ bzw. die Schubverzerrung $gamma$ ausgedrückt. Diese Gesetzmäßigkeiten gelten für Materialien, dessen Verhalten richtungsunabhängig ist \(isotropes Verhalten).

=== Verzerrungsfeld
<sec-verzerrung>
Aus dem Verschiebungsfeld nach Kirchhoff lässt sich das Verzerrungsfeld herleiten. Die Dehnungen

#math.equation(block: true, numbering: "(1)", [ $ epsilon.alt_(x x) & = frac(diff u, diff x) = - z dot.op frac(diff^2 w, diff x^2)\
epsilon.alt_(y y) & = frac(diff v, diff y) = - z dot.op frac(diff^2 w, diff y^2)\
 $ ])<eq-dehnungen>

beschreiben die Längenänderung der Platte in $x$- bzw. $y$-Richtung. Entsprechend der Kirchhoffschen Plattentheorie verschwindet die Dehnung $epsilon.alt_(z z)$ auf Grund der Annahme der gleichbleibenen Plattendicke $h$. Die Schubverzerrung #math.equation(block: true, numbering: "(1)", [ $ gamma_(x y) & = frac(diff u, diff y) + frac(diff v, diff x) = - 2 z dot.op frac(diff^2 w, diff x diff y) ,\
 $ ])<eq-schubverzerrung-gleitung>

oder auch Gleitung, beschreibt eine Winkeländerung. Konsistent mit den in @eq-verschiebung-u und @eq-verschiebung-v getroffenen Annahmen, als Folge des Ebenbleibens der Querschnitte, ergeben sich die Schubverzerrungen #math.equation(block: true, numbering: "(1)", [ $ gamma_(x z) & = frac(diff u, diff z) - frac(diff w, diff x) = frac(diff w, diff x) - frac(diff w, diff x) = 0\
gamma_(y z) & = frac(diff v, diff z) - frac(diff w, diff y) = frac(diff w, diff y) - frac(diff w, diff y) = 0 .\
 $ ])<eq-schubverzerrung>

Durch die Definition der Krümmungen mit #math.equation(block: true, numbering: "(1)", [ $ kappa_(x x) & = - frac(diff^2 w, diff x^2)\
kappa_(y y) & = - frac(diff^2 w, diff y^2)\
kappa_(x y) & = - 2 frac(diff^2 w, diff x diff y)\
 $ ])<eq-kruemmung>

kann das Verzerrungsfeld nach der Kirchhoffschen Plattentheorie als Vektor-Matrix-Produkt mit #math.equation(block: true, numbering: "(1)", [ $ mat(delim: "[", epsilon.alt_(x x); epsilon.alt_(y y); gamma_(x y)) = z kappa = z mat(delim: "[", kappa_(x x); kappa_(y y); kappa_(x y)) = - z mat(delim: "[", frac(diff^2 w, diff x^2); frac(diff^2 w, diff y^2); - 2 frac(diff^2 w, diff x diff y)) $ ])<eq-black-scholes>

beschrieben werden. Bei der isotropen Platte mit linear-elastischem Materialverhalten lässt sich das Spannungsfeld aus dem oben beschriebenem Verzerrungsfeld herleiten. Die Spannungen #math.equation(block: true, numbering: "(1)", [ $ sigma_(x x) & = frac(E, 1 - nu^2) dot.op (epsilon.alt_(x x) + nu dot.op epsilon.alt_(y y))\
sigma_(y y) & = frac(E, 1 - nu^2) dot.op (nu dot.op epsilon.alt_(x x) + epsilon.alt_(y y))\
tau_(x y) & = frac(E, 2 dot.op (1 + nu)) dot.op gamma_(x y) med $ ])<eq-spannungen>

sind linear veränderlich über die Plattendicken $h$.

#strong[TODO:] auf Widersprüche der Kirchhoff Plattentheorie eingehen

\

=== Schnittgrößen
<sec-schnittgrößen>
Resultierend aus den Spannungskomponenten $sigma_(x x)$,$sigma_(y y)$ und $tau_(x y)$ ergeben sich die Biegemomente $m_(x x)$ und $m_(y y)$ und das Drillmoment $m_(x y)$, definiert als Moment pro Längeneinheit. Die Momente lassen sich durch Integration der Spannungen über die Höhe der Platte und Multiplikation mit dem Hebelarm $z$ zu #math.equation(block: true, numbering: "(1)", [ $ m_(x x) & = integral_(- h \/ 2)^(h \/ 2) z dot.op underbrace(frac(E, 1 - nu^2) dot.op (epsilon.alt_(x x) + nu dot.op epsilon.alt_(y y)), sigma_(x x)) dot.op d z\
m_(y y) & = integral_(- h \/ 2)^(h \/ 2) z dot.op underbrace(frac(E, 1 - nu^2) dot.op (nu dot.op epsilon.alt_(x x) + epsilon.alt_(y y)), sigma_(y y)) dot.op d z\
m_(x y) & = integral_(- h \/ 2)^(h \/ 2) z dot.op underbrace(frac(E, 2 dot.op (1 + nu)) dot.op gamma_(x y), tau_(x y)) dot.op d z\
 $ ])<eq-black-scholes>

berechnen. Die isotrope Plattensteifigkeit #math.equation(block: true, numbering: "(1)", [ $ D = frac(E dot.op h^3, 12 dot.op (1 - nu^2)) $ ])<eq-plattensteifigkeit>

und die in @eq-kruemmung definierten Krümmungen $kappa$ erlauben eine vereinfachte Darstellung der Momente #math.equation(block: true, numbering: "(1)", [ $ m_(x x) & = D dot.op (kappa_(x x) + nu dot.op kappa_(y y)) &  & = D dot.op (frac(diff^2 w, diff x^2) + nu dot.op frac(diff^2 w, diff y^2))\
m_(y y) & = D dot.op (nu dot.op kappa_(x x) + kappa_(y y)) &  & = D dot.op (nu dot.op frac(diff^2 w, diff x^2) + frac(diff^2 w, diff y^2))\
m_(x y) & = D dot.op frac(1 - nu, 2) dot.op kappa_(x y) &  & = D dot.op frac(1 - nu, 2) dot.op (- 2 frac(diff^2 w, diff x diff y)) . $ ])<eq-black-scholes>

#figure([
#box(width: 100%,image("00-pics/Biegemoment.png"))
], caption: figure.caption(
position: bottom, 
[
Normalspannungen und resultierende Biegemomente
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)


#figure([
#box(width: 100%,image("00-pics/Drillmomente.png"))
], caption: figure.caption(
position: bottom, 
[
eben Schubspannungen und resultierende Drillmomente
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)


Um die Querkräfte zu berechnen werden im Normalfall die transversalen Schubspannungen über die Plattendicke $h$ integriert. Bei der Kirchhoffschen Plattentheorie ist dies nicht möglich, da, wie in @eq-schubverzerrung dargestellt, die Schubverzerrungen und somit die Schubspannungen gemäß der getroffenen Annahmen verschwinden. Die Querkräfte ergeben sich allein aus den Gleichgewichtsbedingungen \(s. Kapitel Gleichgewichtsbeziehungen) und lassen sich aus der dritten Ableitung der Verschiebung $w$ zu #math.equation(block: true, numbering: "(1)", [ $ q_(x x) & = D dot.op (frac(diff^3 w, diff x^3) + nu dot.op frac(diff^3 w, diff y^3))\
q_(y y) & = D dot.op (nu dot.op frac(diff^3 w, diff x^3) + frac(diff^3 w, diff y^3))\
 $ ])<eq-black-scholes>

berechnen.

#figure([
#box(width: 100%,image("00-pics/Querkraft.png"))
], caption: figure.caption(
position: bottom, 
[
transversale Schubspannungen und resultierende Querkräfte
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)


=== Gleichgewichtsbeziehungen & Plattengleichung
<sec-gleichgewicht>
Betrachtet wird zunächst ein Schnittelement einer Platte mit den Abmessungen $Delta x$ und $Delta y$, welches durch eine senkrecht zur Mittelebene angreifende Flächenlast $p (x , y)$ belastet wird. In @fig-schnittgroessen sind die Schnittgrößen welche am positiven sowie am negativen Schnittufer des Elements angreifen dargestellt. Die Definitionen der Schnittgrößen sind in @tbl-schnittgroessen abgebildet.

#figure([
#figure(
align(center)[#table(
  columns: 4,
  align: (col, row) => (auto,auto,auto,auto,).at(col),
  inset: 6pt,
  [], [Schnittufer $+$], [], [Schnittufer $-$],
  [$M_x$],
  [$m_(x x) dot.op Delta y$],
  [$M_(x + Delta x)$],
  [$(m_(x x) + frac(diff m_(x x), diff x) dot.op Delta x) Delta y$],
  [$M_y$],
  [$m_(y y) dot.op Delta x$],
  [$M_(y + Delta y)$],
  [$(m_(y y) + frac(diff m_(y y), diff y) dot.op Delta y) Delta x$],
  [$M_(x y)$],
  [$m_(x y) dot.op Delta y$],
  [$M_(x y + Delta x)$],
  [$(m_(x y) + frac(diff m_(x y), diff x) dot.op Delta x) Delta y$],
  [$M_(y x)$],
  [$m_(y x) dot.op Delta x$],
  [$M_(y x + Delta y)$],
  [$(m_(y x) + frac(diff m_(y x), diff y) dot.op Delta y) Delta x$],
  [$Q_x$],
  [$q_(x x) dot.op Delta y$],
  [$Q_(x + Delta x)$],
  [$(q_(x x) + frac(diff q_(x x), diff x) dot.op Delta x) Delta y$],
  [$Q_y$],
  [$q_(y y) dot.op Delta x$],
  [$Q_(y + Delta y)$],
  [$(q_(y y) + frac(diff q_(y y), diff y) dot.op Delta y) Delta x$],
)]
)

], caption: figure.caption(
position: bottom, 
[
Schnittgrößen
]), 
kind: "quarto-float-tbl", 
supplement: "Table", 
numbering: "1", 
)
<tbl-schnittgroessen>


\
\
\
\
Bei der Grenzbetrachtung $Delta x arrow.r 0$ und $Delta y arrow.r 0$ ergeben sich die Gleichgewichtsbeziehungen #math.equation(block: true, numbering: "(1)", [ $ frac(diff Q_(x x), diff x) + frac(diff Q_(y y), diff y) + q & = 0\
frac(diff M_(x x), diff x) + frac(diff M_(x y), diff y) - Q_(x x) & = 0\
frac(diff M_(y y), diff y) + frac(diff M_(x y), diff y) - Q_(y y) & = 0 .\
 $ ])<eq-gleichgewichtsbeziehungen>

Durch das Einsetzen der in Gleichungen 18 definierten Momente $m_(x x)$, $m_(y y)$ und $m_(x y)$ in die Gleichgewichtsbeziehungen, sowie das Ersetzen der Ausdrücke $Q_(x x)$ und $Q_(y y)$ in der ersten Gleichgewichtsbeziehung \(@eq-gleichgewichtsbeziehungen) durch die Momentenausdrücke der zweiten und dritten Gleichgewichtsbeziehung \(@eq-gleichgewichtsbeziehungen),erhält man die Differentialgleichung aus @eq-randwertproblem. Dieses Randwertproblem wird auch als schwache Form des Problems bezeichnet.

#figure([
#box(width: 100%,image("00-pics/Schnittgroessen.png"))
], caption: figure.caption(
position: bottom, 
[
Schnittgrößen
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
numbering: "1", 
)
<fig-schnittgroessen>


#block(
fill:luma(230),
inset:8pt,
radius:4pt,
[
#emph[Randwertproblem \(D)] \

Gesucht ist die Funktion $w : [quad] arrow.r bb(R)^2$ welche die Differentialgleichung #math.equation(block: true, numbering: "(1)", [ $ D dot.op [frac(diff^4 w, diff x^4) + 2 dot.op frac(diff^2 w, diff x^2 diff y^2) + frac(diff^4 w, diff y^4)] = q $ ])<eq-randwertproblem>

und die Randbedingungen

#strong[TODO:] Randbedingungen

erfüllt. \

])

Das Randwertproblem wird als Divergenz des Gradienten von $w$ wie folgt ausgedrückt: #math.equation(block: true, numbering: "(1)", [ $ D dot.op Delta Delta w (x , y) = q $ ])<eq-black-scholes>

#pagebreak()
#set page(header: align(right, emph(text(size: 12pt)[Kapitel 4: Finite Elemente für schubstarre Platten])))
= Finite Elemente für schubstarre Platten
<sec-fem-plattentragwerke>
Anknüpfend an das, in @sec-mech-math-grundlagen hergeleitete Randwertproblem, erfolgt in @sec-vorbereitung die Herleitung der schwachen Form für die Kirchhoff-Platte. Ziel ist es das Variationsproblem und die daraus resultierende Bilinearform und Linearform zu formulieren. Abgeleitet aus dem Variationsproblem wird in @sec-Steifigkeitsmatrix-BFS und @sec-Steifigkeitsmatrix-DKQ die globale Steifigkeitsmatrix für das Bogner-Fox-Schmitt Element und das Discrete Kirchhoff Quadrilateral Element hergeleitet. Die Formulierung der Steifigkeitsmatrizen der beiden Element bilden die Basis für die Implementierung in das in @sec-Umsetzung-Julia beschriebene Programm.

== Vorbereitung
<sec-vorbereitung>
=== Herleitung der schwachen Form
<sec-schwache-form>
Die Basis der Finite Element Methode bildet die schwache Form des Problems. Ausgehend von der Differentialgleichung der Kirchhoffplatte, ausgedrückt durch den Laplace-Operator,

#math.equation(block: true, numbering: "(1)", [ $ D dot.op Delta Delta w = q $ ])<eq-diffgl-laplace>

ergibt sich nach Multiplikation mit der Testfunktion $delta w : Omega arrow.r bb(R)$

#math.equation(block: true, numbering: "(1)", [ $ D dot.op (w_(, x x x x) dot.op delta w + 2 dot.op w_(, x x y y) dot.op delta w + dot.op w_(, y y y y) dot.op delta w) = q dot.op delta w . $ ])<eq-diffgl-testfunk>

Nach der Integration beider Seiten über die Fläche $Omega$ und durch Anwendung der Summenregel für Integrale folgt #math.equation(block: true, numbering: "(1)", [ $ D dot.op [underbrace(integral_Omega w_(, x x x x) dot.op delta w quad d Omega, upright("1. Summand")) + underbrace(integral_Omega 2 dot.op w_(, x x y y) dot.op delta w quad d Omega, upright("2. Summand")) + underbrace(integral_Omega w_(, y y y y) dot.op delta w quad d Omega, upright("3. Summand"))] = integral_Omega q dot.op delta w quad d Omega . $ ])<eq-diffgl-testfunk-integral>

Die drei Summanden auf der linke Seite der Gleichung werden zweifach partiell integriert. Zudem wird angenommen, dass alle Ranterme, also Momente und Querkräfte an dem Rand des Gebiets $Omega$, $= 0$. Dadurch ergeben sich die Teilergebnisse für

$  & upright("den 1. Summanden")\
\
 & integral_Omega w_(, x x x x) dot.op delta w quad d Omega &  & = - integral_Omega delta w_(, x x) dot.op w_(, x x) quad d Omega\
\
\
 & upright("den 2. Summanden")\
\
 & integral_Omega 2 dot.op w_(, x x y y) dot.op delta w quad d Omega &  & = integral_Omega 2 dot.op delta w_(, x y) dot.op w_(, x y) quad d Omega\
\
\
 & upright("und den 3. Summanden")\
\
 & integral_Omega w_(, y y y y) dot.op delta w quad d Omega &  & = - integral_Omega delta w_(, y y) dot.op w_(, y y) quad d Omega $

Das Zusammenführen der Teilergebnisse ergibt das nachfolgend dargestellte Variationsproblem für die Kirchhoffplatte.

#block(
fill:luma(230),
inset:8pt,
radius:4pt,
[
#emph[Variationsproblem \(V)] \

Gesucht ist die Funktion $w : Omega arrow.r bb(R)$, sodass \
\
#math.equation(block: true, numbering: "(1)", [ $ integral_Omega D (w_(, x x) delta w_(, x x) + 2 w_(, x y) delta w_(, x y) + w_(, y y) delta w_(, y y)) quad d Omega = integral_Omega q dot.op delta w quad d Omega $ ])<eq-variationsproblem>

\
für jede \(fast) beliebige Testfunktion $delta w : Omega arrow.r bb(R)$.

])

Im Fall der Kirchhoffplatte ist die Bilinearform

#math.equation(block: true, numbering: "(1)", [ $  & a (w , delta w) &  & = integral_Omega D (w_(, x x) delta w_(, x x) + 2 w_(, x y) delta w_(, x y) + w_(, y y) delta w_(, y y)) quad d Omega\
 $ ])<eq-bilinearform>

und die Linearform

#math.equation(block: true, numbering: "(1)", [ $ b (delta w) = integral_Omega q dot.op delta w quad d Omega . $ ])<eq-linearform>

== Assemblierung/Herleitung der globalen Steifigkeitsmatrix
<sec-assemblierung-steifigkeitsmatrix>
Die Entwicklung des linearen Gleichungssystems für ein System aus mehreren Plattenelementen geschieht über die Assemblierung der zuvor hergeleiteten und für die einzelnen Elemente ausgewertete Bilinearformen, den Elementsteifigkeitsmatrizen.

Der klassische Ansatz verwendet hierzu eine nodale Basis P nach Gleichung 3.40 aus Kapitel 3.3 auf den Elementen. Dabei entspricht eine der verwendeten lokale Basisfunktionen der Elemente φe i einem globalen Freiheitsgrad di.

=== BFS-Rechteckelement
<sec-Steifigkeitsmatrix-BFS>
Wie in @sec-FE-BFS bereits beschrieben, hat das konforme Rechteckelement vier Knoten und an jedem Knoten vier Freiheitsgrade, sodass der Knotenverschiebungsvektor eines Elements

#math.equation(block: true, numbering: "(1)", [ $ bold(hat(w)^e) = mat(delim: "[", w_1, theta_(x 1), theta_(y 1), theta_(x y 1), w_2, theta_(x 2), theta_(y 2), theta_(x y 2), w_3, theta_(x 3), theta_(y 3), theta_(x y 3), w_4, theta_(x 4), theta_(y 4), theta_(x y 4))^T $ ])<eq-knotenverschiebungsvekor-BFS>

ist. Für die Herleitung der globalen Steifigkeitsmatrix mit dem Elementansatz des Bogner-Fox-Schmitt Rechteckelements wird das abstrakte, diskrete Variationsproblem, durch das Skalarprodukt von Momentenvektor

$ bold(m) = mat(delim: "[", m_(x x); m_(y y); m_(x y)) #h(2em) #h(2em) upright("und Krümmungsvektor") #h(2em) #h(2em) bold(kappa) = mat(delim: "[", kappa_(x x); kappa_(y y); 2 kappa_(x y)) $

ausgedrückt. Das Ergebnis ist die Formulierung #math.equation(block: true, numbering: "(1)", [ $ a (w , delta w) = integral_Omega bold(m) dot.op bold(kappa) d Omega = integral_Omega (m_(x x) kappa_(x x) + 2 m_(x y) kappa_(x y) + m_(y y) kappa_(y y)) d Omega . $ ])<eq-bilinearform-Skalarprodukt-m-kappa>

für die Bilinearform. Der Krümmungsvektor kann gemäß @eq-kruemmung durch die zweiten Ableitungen der Verschiebung $w_h$ bzw. durch die ersten Ableitungen der Verdrehungen $theta_(x h)$ und $theta_(y h)$ ausgedrückt werden. Bezogen auf ein Element ergibt sich, durch die Linearkombination für $w_h$ \(@eq-linearkombination-platte) und den Knotenverschiebungsvektor $bold(hat(w)^e)$ \(#strong[?\@eq-knotenverschiebungsvekor];), die Formulierung des Krümmungsvektors für das Element $i$

#math.equation(block: true, numbering: "(1)", [ $ bold(kappa_i) = bold(B_b) bold(hat(w)^e) $ ])<eq-kruemmungsvekor-mit-B-Matrix>

mit der B-Matrix $ bold(B_b) = mat(delim: "[", 0, frac(diff phi_1, diff x), 0, 0, 0, frac(diff phi_2, diff x), 0, 0, 0, frac(diff phi_3, diff x), 0, 0, dots.h.c, 0, frac(diff phi_16, diff x), 0, 0; 0, 0, frac(diff phi_1, diff y), 0, 0, 0, frac(diff phi_2, diff y), 0, 0, 0, frac(diff phi_3, diff y), 0, dots.h.c, 0, 0, frac(diff phi_16, diff y), 0; 0, frac(diff phi_1, diff y), frac(diff phi_1, diff x), 0, 0, frac(diff phi_2, diff y), frac(diff phi_2, diff x), 0, 0, frac(diff phi_3, diff y), frac(diff phi_3, diff x), 0, dots.h.c, 0, frac(diff phi_16, diff y), frac(diff phi_16, diff x), 0; #none) . $

Der Momentenvektor kann dementsprechend durch

#math.equation(block: true, numbering: "(1)", [ $ bold(m_i) = bold(D_b) bold(kappa_i) = bold(D_b) bold(B_b) bold(hat(w)^e) $ ])<eq-momentenvekor-mit-B-Matrix>

mit $ bold(D_b) = D mat(delim: "[", 1, nu, 0; nu, 1, 0; 0, 0, frac(1 - nu, 2)) $

beschrieben werden, mit der isotropen Plattensteifigkeit $D$ \(s. @eq-plattensteifigkeit). Mit den Formulierungen aus @eq-kruemmungsvekor-mit-B-Matrix und @eq-momentenvekor-mit-B-Matrix, eingesetzt in @eq-bilinearform-Skalarprodukt-m-kappa, ergibt sich die elementweise Formulierung der Bilinearform zu $ a (w^e , delta w^e) & = integral_Omega bold(B_b)^T bold(D_b) bold(B_b) bold(hat(w)^e) quad d Omega\
 $

Diese Formulierung wird in der Literatur im Regelfall durch die Elementsteifigkeitsmarix

#math.equation(block: true, numbering: "(1)", [ $ bold(k_(i j)^e) = a (phi_j^e , phi_i^e) = integral_(Omega^e) bold(B)_b^T bold(D_b) bold(B)_b d Omega $ ])<eq-elementsteifigkeitsmatrix>

ausgedrückt.

=== DKQ Element
<sec-Steifigkeitsmatrix-DKQ>
Gitter, die bei der FE-Methode generiert werden, sind üblicherweise nicht gleichmäßig. Die Elemente haben nicht immer dieselebe Größe und Form, weshalb eine Lösung für die Berechnung von allgemeinen Viercken notwendig ist. Die in diesem Kapitel gemachten Formulierungen für ein isoparametrisches Element basieren auf dem von JEAN-LOUIS BATOZ und MABROUK BEN TAHARS veröffentlichtem Paper "Evaluation of a new quadrilateral thin plate bending element" aus dem Jahr 1981. Das vorgestellte Element ist ein Vierknotenelement mit je 3 Freiheitsgraden je Ecke. Die Geometrie ist in @fig-geometrie-DKQ dargestellt.

#figure([
#box(width: 70%,image("00-pics/Geometrie-BTP.png"))
], caption: figure.caption(
position: bottom, 
[
Geometrie des DKQ-Elements
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
numbering: "1", 
)
<fig-geometrie-DKQ>


Dieses sogenannte DKQ \(#emph[discrete Kirchhoff quadrilateral];) Element basiert auf den folgenden Annahmen:

+ Die Verdrehungen $beta_x$ um die $y$-Achse und $beta_y$ um die $x$-Achse sind als Ableitungen der Linearkombination aus @eq-linearkombination-platte zu verstehen. #math.equation(block: true, numbering: "(1)", [ $  & beta_x & quad = - w ,_x & quad = theta_y & quad = frac(diff sum_(i = 1)^8 phi_i (x , y) dot.op hat(w)_i, diff x)\
   & beta_y & quad = - w ,_y & quad = - theta_x & quad = frac(diff sum_(i = 1)^8 phi_i (x , y) dot.op hat(w)_i, diff x)\
   $ ])<eq-betaX-betaY> Als Formfunktionen $phi_i (x , y)$ dienen die Funktionen des in #strong[?\@sec-finite-elemente] vorgestellten Serendipity-Elements, abhängig von den Variablen $xi$ und $eta$. Die Freiheitsgrade des Serendipity-Elements sind die Verformungen $hat(w)_i$ mit $i = 1 , . . . , 8$, wobei $i$ die Nummer des Knotens nach @fig-geometrie-DKQ angibt.

+ Entsprechend der Kirchhoff Theorie sind die Verdrehungen an den

#block[
#set enum(numbering: "a)", start: 1)
+ Eckknoten $i$ #math.equation(block: true, numbering: "(1)", [ $  & beta_(x_i) = - w ,_(x_i)\
   & beta_(y_i) = - w ,_(y_i) #h(2em) upright("mit") i = 1 , 2 , 3 , 4 , $ ])<eq-verdrehungen-beta-i> \(Ableitungen der Verformung $w$ nach $x$ und nach $y$ an den Knoten $i$) und an den
+ Mittelknoten $k$ #math.equation(block: true, numbering: "(1)", [ $  & beta_(s_k) = - w ,_(s_k)\
   & beta_(n_k) = - w ,_(n_k) #h(2em) upright("mit") k = 5 , 6 , 7 , 8 , $ ])<eq-verdrehungen-beta-k> \(Ableitungen der Verformung $w$ nach $s$ und nach $n$ an den Knoten $k$), wobei $s$ die Koordinate entlang der Elementseite ist und $n$ die senkrechte Achse zur $s$-Achse. \(siehe Abb.)
]

#block[
#set enum(numbering: "1.", start: 3)
+ $beta_s$ ist die Verdrehung um die $n$-Achse. Nach BATOZ und TAHAR wird, zur Bestimmung von $beta_s$ an dem Knoten $k$, die Verformung $w$ entlang der Elementkanten als kubische Funktion ausgedrückt. Zur Bestimmung der Funktion dritten Grades wird die allgemeine Form $ w (s) = a s^3 + b s^2 + c s + d $ mit den Randbedingungen $  & w (s_i) = w_i &  & #h(2em) w prime (s_i) = w ,_(s i)\
   & w (s_j) = w_j &  & #h(2em) w prime (s_j) = w ,_(s j) $ gelöst. Für die Verdrehung um die n-Achse ergibt sich #math.equation(block: true, numbering: "(1)", [ $ w ,_(s k) = w prime (0) = frac(- 3, l_(i j)) (w_i - w_j) - 1 / 4 (w ,_(s i) + w ,_(s j)) $ ])<eq-verdrehungen-beta-x-Formel> wobei $k = 5 , 6 , 7 , 8$ die Mittelknoten der Elementkanten $i j = 12 , 23 , 34 , 41$ sind. $l_(i j)$ ist die Länge der Seiten $i j$.

+ $beta_n$ ist die Verdrehung um die $s$-Achse und wird entlang der Elementkanten durch eine lineare Funktion $ w prime (s) = a x + b $ mit den Randbedingungen \
  $ w prime (s_i) = w ,_(n i) &  & #h(2em) w prime (s_j) = w ,_(n j) $ ausgedrückt. Es ergibt sich somit $ w ,_(n_k) = w prime (0) = - 1 / 2 (w ,_(n i) + w ,_(n j)) $
]

#block(
fill:luma(230),
inset:8pt,
radius:4pt,
[
Zusammengefasst sind die die Verdrehungen der Knoten \
#math.equation(block: true, numbering: "(1)", [ $  & #h(2em) #h(2em) #h(2em) beta_(x_i) = - w ,_(x_i)\
 & #h(2em) #h(2em) #h(2em) beta_(y_i) = - w ,_(y_i) &  & upright("mit") i = 1 , 2 , 3 , 4\
 & #h(2em) #h(2em) #h(2em) beta_(s_k) = - w ,_(s_k) = frac(- 3, l_(i j)) (w_i - w_j) - 1 / 4 (w ,_(s i) + w ,_(s j))\
 & #h(2em) #h(2em) #h(2em) beta_(n_k) = - w ,_(n_k) = - 1 / 2 (w ,_(n i) + w ,_(n j)) &  & upright("mit") k = 5 , 6 , 7 , 8 $ ])<eq-verdrehungen-beta>

])

Die Formeln für die die Verdrehungen an den Eckknoten um die $x$-Achse und die $y$-Achse und für die Verdrehung an den Mittelknoten um die $s$-Achse und die $n$-Achse sind vorhanden. Da bei isoparametrischen Elementen die Elementkanten nicht parallel zu den Koordinatenachsen verlaufen ist eine Umrechnung der Verdrehung der Mittelknoten, auf die Verdrehung um die $x$- und $y$-Achse notwendig.

Nach geometrischer Umrechnung der Verdrehung an den Mittelknoten, von $w ,_(s_k)$ und $w ,_(n_k)$ zu

$  & w ,_(x_k) = - c o s (gamma_k) dot.op w ,_(n_k) + s i n (gamma_k) dot.op w ,_(s_k) #h(2em) #h(2em) upright("und")\
 & w ,_(y_k) = - s i n (gamma_k) dot.op w ,_(n_k) - c o s (gamma_k) dot.op w ,_(s_k) #h(2em) #h(2em) upright("mit") gamma_k = gamma_(i j)\
 $

wird die Linearkombination aus @eq-betaX-betaY aufgeteilt in Eck- und Mittelknoten mit

$  & beta_x = - sum_(i = 1)^4 phi_i (x , y) dot.op w ,_(x_i) - sum_(k = 5)^8 phi_i (x , y) dot.op w ,_(x_k)\
 & beta_y = - sum_(i = 1)^4 phi_i (x , y) dot.op w ,_(y_i) - sum_(k = 5)^8 phi_i (x , y) dot.op w ,_(y_k)\
 $

und Einsetzen der Vereinbarungen aus @eq-verdrehungen-beta berechnet. Es ergibt sich durch extrahieren des Knotenverschiebungsvektor

#math.equation(block: true, numbering: "(1)", [ $ bold(hat(w)^e) = mat(delim: "[", w_1, theta_(x 1), theta_(y 1), w_2, theta_(x 2), theta_(y 2), w_3, theta_(x 3), theta_(y 3), w_4, theta_(x 4), theta_(y 4))^T $ ])<eq-knotenverschiebungsvekor-DKQ>

die Formulierung $  & beta_x = mat(delim: "[", H_1^x, H_2^x, H_3^x, H_4^x, H_5^x, H_6^x, H_7^x, H_8^x, H_9^x, H_10^x, H_11^x, H_12^x) bold(hat(w)^e)\
 & beta_y = mat(delim: "[", H_1^y, H_2^y, H_3^y, H_4^y, H_5^y, H_6^y, H_7^y, H_8^y, H_9^y, H_10^y, H_11^y, H_12^y) bold(hat(w)^e) $

mit

$ H_1^x & = 3 / 2 (phi_5 a_5 - phi_8 a_8) & #h(2em) #h(2em) H_1^y & = 3 / 2 (phi_5 d_5 - phi_8 d_8)\
H_2^x & = phi_5 b_5 + phi_8 b_8 & #h(2em) #h(2em) H_2^y & = - phi_1 + phi_5 e_5 + phi_8 e_8\
H_3^x & = phi_1 - phi_5 c_5 - phi_8 c_8 & #h(2em) #h(2em) H_3^y & = - phi_5 b_5 - phi_8 b_8\
H_4^x & = 3 / 2 (phi_6 a_6 - phi_5 a_5) & #h(2em) #h(2em) H_4^y & = 3 / 2 (phi_6 d_6 - phi_5 d_5)\
H_5^x & = phi_6 b_6 + phi_5 b_5 & #h(2em) #h(2em) H_5^y & = - phi_2 + phi_6 e_6 + phi_5 e_5\
H_6^x & = phi_2 - phi_6 c_6 - phi_5 c_5 & #h(2em) #h(2em) H_6^y & = - phi_6 b_6 - phi_5 b_5\
H_7^x & = 3 / 2 (phi_7 a_7 - phi_6 a_6) & #h(2em) #h(2em) H_7^y & = 3 / 2 (phi_7 d_7 - phi_6 d_6)\
H_8^x & = phi_7 b_7 + phi_6 b_6 & #h(2em) #h(2em) H_8^y & = - phi_3 + phi_7 e_7 + phi_6 e_6\
H_9^x & = phi_3 - phi_7 c_7 - phi_6 c_6 & #h(2em) #h(2em) H_9^y & = - phi_7 b_7 - phi_6 b_6\
H_10^x & = 3 / 2 (phi_8 a_8 - phi_7 a_7) & #h(2em) #h(2em) H_10^y & = 3 / 2 (phi_8 d_8 - phi_7 d_7)\
H_11^x & = phi_8 b_8 + phi_7 b_7 & #h(2em) #h(2em) H_11^y & = - phi_4 + phi_8 e_8 + phi_7 e_7\
H_12^x & = phi_4 - phi_8 c_8 - phi_7 c_7 & #h(2em) #h(2em) H_12^y & = - phi_8 b_8 - phi_7 b_7 $

und

$  & a_k = frac(- s i n (gamma_(i j)), l_(i j)) &  & #h(2em) #h(2em) d_k = frac(c o s (gamma_(i j)), l_(i j))\
 & b_k = - 3 / 4 c o s (gamma_(i j)) s i n (gamma_(i j))\
 & c_k = - 1 / 2 c o s (gamma_(i j))^2 - 1 / 4 s i n (gamma_(i j))^2 &  & #h(2em) #h(2em) e_k = - 1 / 2 s i n (gamma_(i j))^2 + 1 / 4 c o s (gamma_(i j))^2\
 $

Ausgehen von der Formulierung aus @eq-bilinearform-Skalarprodukt-m-kappa und der Berechnung des Krümmungsvektors entsprechend @eq-kruemmungsvekor-mit-B-Matrix, ergibt sich die B-Matrix für das isoparametrische Element zu

#math.equation(block: true, numbering: "(1)", [ $ bold(B_b) = mat(delim: "[", frac(diff H_1^x, diff x), frac(diff H_2^x, diff x), dots.h.c, frac(diff H_12^x, diff x); frac(diff H_1^y, diff y), frac(diff H_2^y, diff y), dots.h.c, frac(diff H_12^y, diff y); frac(diff H_1^x, diff y) + frac(diff H_1^y, diff x), frac(diff H_2^x, diff y) + frac(diff H_2^y, diff x), dots.h.c, frac(diff H_12^x, diff y) + frac(diff H_12^y, diff x); #none) . $ ])<eq-B-Matrix-DQT>

Die Formulierung der Elementsteifigkeitsmatrizen stimmt mit der Formulierung für das BFS-Element aus @eq-elementsteifigkeitsmatrix überein.

=== Parametrisierung DKQ
<sec-Parametrisierung>
Die in dem vorrangehenden Kapitel hergelteitet Formulierung für allgemeine Vierecke bezieht sich auf das Referenzkoordinatensystem mit $xi$ - und $eta$-Achse, da die verwendeten Formfunktionen in diesem System definiert sind. Nach @eq-B-Matrix-DQT wird eine Ableitung der H-Funktionen nach $x$ und $y$ gefordert. Um eine Berechnung von allgemeinen Finite-Elemente-Gittern zu ermöglichen, muss also die Umrechnung der Referenzkoordinaten $xi$ und $eta$ zu den physikalischen Koordinaten $x$ und $y$, und andersherum, hergeleitet werden. Ziel ist die Projektion des physikalischen Elements $ Omega_e := { (x , y) in bb(R)^2 } $

auf das Referenzelement $ hat(Omega)_e := { (xi , eta) in bb(R)^2 \| - 1 lt.eq xi , eta lt.eq 1 } . $

wie in @fig-parametrisierung dargestellt.

#figure([
#box(width: 100%,image("00-pics/Parametrisierung.png"))
], caption: figure.caption(
position: bottom, 
[
Abbildung des Raums $hat(Omega)$ auf $Omega$
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
numbering: "1", 
)
<fig-parametrisierung>


Sei $(xi , eta)$ ein beliebiger Punkt auf dem Referenzelement, so werden durch

#math.equation(block: true, numbering: "(1)", [ $ bold(F) (xi , eta) = mat(delim: "[", x (xi , eta); y (xi , eta); #none) = mat(delim: "[", F_x (xi , eta); F_y (xi , eta); #none) = mat(delim: "[", sum_(i = 1)^n N_i (xi , eta) dot.op x_i; sum_(i = 1)^n N_i (xi , eta) dot.op y_i; #none) $ ])<eq-black-scholes-01>

die physikalischen Koordinaten auf dem Element $Omega$ beschrieben. Die vier linearen Formfunktionen entsprechenen den in Kapitel … besprochenen Funktionen des bilinearen Elements, dargestellt in @fig-Lagrange-Formfunktionen und beschrieben durch @eq-formfunktionen-bilinear. Um die physikalischen Koordinaten $(x , y)$ zu den Referenzkoordinaten $(xi , eta)$ umzurechnen, ist das Umkehren der Funktionen $F_x (xi , eta)$ und $F_y (xi , eta)$ zu #math.equation(block: true, numbering: "(1)", [ $ bold(F^(- 1)) (x , y) = mat(delim: "[", xi (x , y); eta (x , y); #none) = mat(delim: "[", F_x^(- 1) (x , y); F_y^(- 1) (x , y); #none) $ ])<eq-f-1>

notwendig. Ziel der Parametrisierung ist die Umrechnung beliebiger Formfunktionen. Seien $N_i (xi , eta)$ die Formfunktionen definiert auf dem Referenzelement, so sind

#math.equation(block: true, numbering: "(1)", [ $  & phi_I (x , y) = N_i (xi (x , y) , eta (x , y)) ,\
 $ ])<eq-phi-I>

die Formfunktionen defniert auf dem physikalischen Element, wobei $i$ und $I$ je nach Elementansatz variieren. Zur Berechnung der Elementsteifigkeitsmatrix, werden die Ableitungen

#math.equation(block: true, numbering: "(1)", [ $ phi_(I ,_x) (x , y) = mat(delim: "[", F_(x ,_x)^(- 1) (x , y), F_(y ,_x)^(- 1) (x , y)) mat(delim: "[", N_(i ,_xi) (F_x^(- 1) (x , y) , F_y^(- 1) (x , y)); N_(i ,_eta) (F_x^(- 1) (x , y) , F_y^(- 1) (x , y))) $ ])<eq-phi-I-Ableitung-x> #math.equation(block: true, numbering: "(1)", [ $ phi_(I ,_y) (x , y) = mat(delim: "[", F_(x ,_y)^(- 1) (x , y), F_(y ,_y)^(- 1) (x , y)) mat(delim: "[", N_(i ,_xi) (F_x^(- 1) (x , y) , F_y^(- 1) (x , y)); N_(i ,_eta) (F_x^(- 1) (x , y) , F_y^(- 1) (x , y))) $ ])<eq-phi-I-Ableitung-y>

benötigt, die mithilfe der Kettenregel zusammengefasst und durch die Formulierung aus @eq-f-1 vereinfacht zum Matrix-Vektor-Produkt #math.equation(block: true, numbering: "(1)", [ $ mat(delim: "[", phi_(I ,_x) (x , y); phi_(I ,_y) (x , y)) = underbrace(mat(delim: "[", xi_(,_x) (x , y), eta_(,_x) (x , y); xi_(,_y) (x , y), eta_(,_y) (x , y)), bold(J)_(F^(-) 1)) mat(delim: "[", N_(i ,_xi) (xi (x , y) , eta (x , y)); N_(i ,_eta) (xi (x , y) , eta (x , y))) . $ ])<eq-Ableitung-phi-I-gesamt>

zusammengefasst werden. Der Ausdruck #math.equation(block: true, numbering: "(1)", [ $ nabla phi_I = bold(J)_(F^(- 1)) dot.op nabla N_i $ ])<eq-Ableitung-phi-I-Nabla>

ergibt sich durch eine weitere Vereinfachung mit Hilfe des Nabla-Operators.

Die Jacobi-Matrix der inversen Funktionen $F_x^(- 1)$ und $F_y^(- 1)$ #math.equation(block: true, numbering: "(1)", [ $ bold(J)_(F^(- 1)) (x , y) = mat(delim: "[", xi_(,_x) (x , y), eta_(,_x) (x , y); xi_(,_y) (x , y), eta_(,_y) (x , y)) = mat(delim: "[", frac(diff F_x^(- 1) (x , y), diff x), frac(diff F_y^(- 1) (x , y), diff x); frac(diff F_x^(- 1) (x , y), diff y), frac(diff F_y^(- 1) (x , y), diff y)) $ ])<eq-JF-1>

fasst die Ableitung von $F_x^(- 1)$ und $F_y^(- 1)$ nach $x$ und nach $y$ in einer Matrix zusammen. Für die Funktionen $F_x$ und $F_y$ ist die entsprechende Ableitungsmatrix

#math.equation(block: true, numbering: "(1)", [ $ bold(J)_F & = mat(delim: "[", x_(,_xi) (xi , eta), y_(,_xi) (xi , eta); x_(,_eta) (xi , eta), y_(,_eta) (xi , eta)) = mat(delim: "[", frac(diff F_x (xi , eta), diff xi), frac(diff F_y (xi , eta), diff xi); frac(diff F_x (xi , eta), diff eta), frac(diff F_y (xi , eta), diff eta))\
 & = mat(delim: "[", sum_(i = 1)^4 frac(N_i (xi , eta), diff xi) dot.op x_i^e, sum_(i = 1)^4 frac(N_i (xi , eta), diff xi) dot.op y_i^e; sum_(i = 1)^4 frac(N_i (xi , eta), diff eta) dot.op x_i^e, sum_(i = 1)^4 frac(N_i (xi , eta), diff eta) dot.op y_i^e) $ ])<eq-JF>

$N_i$ mit $i = 1 , 2 , 3 , 4$ bezeichnet in diesem Fall die vier linearen Formfunktionen des bilinearen Elementansatzes, welche für die Parametrisierung notwendig sind. Sei die Jacobi-Matrix vereinfacht ausgedrückt

$ bold(J)_F = mat(delim: "[", J_11, J_12; J_21, J_22) $

und die inverse Jacobi-Matrix

$ bold(J)_F^(- 1) = frac(1, d e t (bold(J))) mat(delim: "[", J_22, - J_12; - J_21, J_11) = mat(delim: "[", j_11, j_12; j_21, j_22) $

so sind die Komponenten der Jacobi-Matrix

$ J_11 & = 1 / 4 dot.op (- x_1^e + x_2^e + x_3^e - x_4^e + eta (x_1^e - x_2^e + x_3^e - x_4^e))\
J_12 & = 1 / 4 dot.op (- y_1^e + y_2^e + y_3^e - y_4^e + eta (y_1^e - y_2^e + y_3^e - y_4^e))\
J_21 & = 1 / 4 dot.op (- x_1^e - x_2^e + x_3^e + x_4^e + xi (x_1^e - x_2^e + x_3^e - x_4^e))\
J_22 & = 1 / 4 dot.op (- y_1^e - y_2^e + y_3^e + y_4^e + xi (y_1^e - y_2^e + y_3^e - y_4^e))\
 $

und die Komponenten der inversen Transformationsmatrix $ j_11 & = frac(1, d e t (bold(J))) dot.op J_22 , quad & j_12 = frac(1, d e t (bold(J))) dot.op J_12 ,\
j_21 & = frac(1, d e t (bold(J))) dot.op J_21 , quad & j_22 = frac(1, d e t (bold(J))) dot.op J_11 .\
 $

mit der Determinanten $ d e t (bold(J)) = J_11 J_22 - J_21 J_12 $

Da, entsprechend dem #emph[inverse function theorem];, die Jacobi-Matrix der inversen Funktionen $F_x^(- 1)$ und $F_y^(- 1)$ gleich der inversen Jacobi-Matrix der Funktionen $F_x$ und $F_y$ ist,

#math.equation(block: true, numbering: "(1)", [ $ bold(J)_(F^(- 1)) = (bold(J)_F)^(- 1) , $ ])<eq-inverse-function-theorem>

ergibt sich die Parametrisierung der Formfunktionen aus @eq-Ableitung-phi-I-gesamt zu

$ mat(delim: "[", phi_(I ,_1) (x , y); phi_(I ,_2) (x , y)) = mat(delim: "[", j_11, j_12; j_21, j_22) mat(delim: "[", N_(i ,_x) (xi (x , y) , eta (x , y)); N_(i ,_y) (xi (x , y) , eta (x , y))) . $

Bezogen auf das DKQ-Element aus @sec-Steifigkeitsmatrix-DKQ ist die Parametrisierte B-Matrix

$ bold(B_b) = mat(delim: "[", j_11 H_(i ,_xi)^x + j_12 H_(i ,_eta)^x; j_21 H_(i ,_xi)^y + j_22 H_(i ,_eta)^y; j_11 H_(i ,_xi)^y + j_12 H_(i ,_eta)^y + j_21 H_(i ,_xi)^x + j_22 H_(i ,_eta)^x, ) $

und die dementsprechende Formulierung für die Elementsteifigkeitsmatrizen bezogen auf das Referenzelement

#math.equation(block: true, numbering: "(1)", [ $ bold(k_(i j)^e) = a (phi_j^e , phi_i^e) & = integral_(- 1)^1 integral_(- 1)^1 bold(B)_e^T bold(D_b) bold(B)_e d e t [J] quad d xi eta $ ])<eq-elementsteifigkeitsmatrix_DKQ>

#pagebreak()
#set page(header: align(right, emph(text(size: 12pt)[Kapitel 5: Umsetzung in JULIA])))
= Umsetzung in JULIA
<sec-Umsetzung-Julia>
Im Folgenden wird der Aufbau des Programmcodes schematisch erläutert sowie zentrale Teile des Quelltextes dargestellt. Da die verwendete Programmiersprache JULIA noch sehr jung ist, wird in @sec-JULIA eine kurze Einführung in die Sprache gegeben.

== Programmiersprache JULIA
<sec-JULIA>
JUlIA ist eine, seit 2009 am Massachusetts Institute of Technology \(MIT) entwickelte, dynamische Programmiersprache für numerische und wissenschaftliche Berechnungen. Die Veröffentlichung wurde im Februar 2012 bekannt gegeben. Mittlerweile wurde das Open-Source Programm bereits über 45 Millionen mal heruntergeladen und beinhalten über 10000 Packages. Außerdem können Libarys von anderen Programmiersprachen wie beispielsweise Python, C++, R und Fortran genutzt werden. Ziel der Entwickler war es eine Programmiersprache zu schaffen, die sowohl eine benutzerfreundliche Umgebung hat, als auch leistungsfähig wie C und Fortran ist.

JULIA beschreibt sich selber als#footnote[www.julialang.org] \
- Fast - Schnell \
- Dynamic - Dynamisch \
- Reproducible - Nachvollziehbar \
- Composable - Ausbaubar / Erweiterbar \
- General - Allgemein \
- Open Source \

Die Programmiersprache hat einen LLVM \(Low-Level Virtual Machine) basierten Just-in-Time Kompiler wodurch eine #emph[hohe Ausführungsgeschwindigkeit] erzielt wird, die in vielen Fällen mit der von C und Fortran vergleichbar ist.

Die Syntax von Julia ist ähnlich der von MATLAB und Python, was sie für Nutzer aus diesen Umfeldern leicht zugänglich macht. Eine Deklaration von Typen ist in der Juliaumgebung nicht notwendig, dank ihrer dynamischen Typisierung. Trotzdem ermöglicht Julia auch die Verwendung von statischen Typen, wenn dies erforderlich ist.

Obwohl Julia im Vergleich zu etablierten Programmiersprachen wie Python oder R eine jüngere Sprache ist, hat sie ein wachsendes Zahl von Paketen und Bibliotheken, die eine breite Palette von Anwendungsbereichen abdecken. Die Julia-Community ist sehr aktiv, und viele Pakete sind speziell auf wissenschaftliche und technische Berechnungen ausgerichtet.

Als #emph[Open-Source] Projekt mit über 1000 Mitwirkenden hat Julia das Potenzial Durch die stetige Weiterentwicklung eine führende Rolle in der Programmierwelt für numerische und technische Anwendungen zu spielen.

Der Quellcode von Julia ist auf GitHub verfügbar.

== Plattenelementtypen in aktueller Finite-Element-Software
<sec-kommerzielle-Software>
\

Zu den bekanntesten Finite Elemente Softwares gehören ADINA und ANSYS, welche, neben der Lösung von statischen und dynamischen Aufgabenstellungen der linearen und nichtlinearen Strukturmechanik, primär in der Strömungsmechanik, und bei der Lösung multiphysikalischer Probleme eingesetzt werden. Diese beiden Programme gelten als Vertreter der General-Purpose Software, wohingegen InfoCAD, RFEM, SAP2000, SOFiSTiK, iTWO structure fem / TRIMAS und MircoFE speziell für die Tragwerksplanung entwickelte Programme sind. Die numerische Berechnung von Plattentragwerken durch die Finite ELemente Analyse basiert in allen Fällen entweder auf der Reissner-Mindlin Theorie oder der Kirchhoffplattentheorie. Neben der Wahl der Plattentheorie ist auch der Elementansatz von wesentlicher Bedeutung und variiert je nach kommerziellen Programm. Auf die Software von InfoCAD, RFEM und SAP2000 wird nachfolgend näher eingegangen.

#figure([
#figure(
align(center)[#table(
  columns: 2,
  align: (col, row) => (left,left,).at(col),
  inset: 6pt,
  [#emph[Software];], [#emph[Elementtyp Platten];],
  [#emph[ADINA];],
  [DKT-Element \(Kirchhoffsche Plattentheorie) \
  3-Knoten-Dreieck-Schalenelement \(Reissner-Mindlin-Plattentheorie) \
  -\> gemische Interpolation tensorieller Komponenten \(?) \
  4-Knoten-Viereck-Schalenelement \(Reissner-Mindlin-Plattentheorie) \
  -\> gemische Interpolation tensorieller Komponenten \(?) \
  Elemente höherer Ordnung],
  [#emph[ANSYS];],
  [schubweiche Dreieck-Plattenelemente \
  schubweiche Viereck-Plattenelemente],
  [#emph[InfoCad];],
  [DKT-Element \(Kirchhoffsche Plattentheorie) \
  DKQ-Element \(Kirchhoffsche Plattentheorie) ~alternativ auch Elemente mit gemischter Interpolation nach Reissner-Mindlin Plattentheorie],
  [#emph[RFEM];],
  [3-Knoten-Dreieck-Schalenelement \(Reissner-Mindlin-Plattentheorie) \
  4-Knoten-Viereck-Schalenelement \(Reissner-Mindlin-Plattentheorie)],
  [#emph[SAP2000];],
  [DKT-Element \(Kirchhoffsche Plattentheorie) \
  DKQ-Element \(Kirchhoffsche Plattentheorie) \
  3-Knoten-Dreieck-Schalenelement \(Reissner-Mindlin-Plattentheorie) \
  4-Knoten-Viereck-Schalenelement \(Reissner-Mindlin-Plattentheorie)],
  [#emph[SOFiSTiK];],
  [schubweiches 4-Knoten-Viereck-Plattenelement],
  [#emph[iTWO structure fem / TRIMAS];],
  [4-Knoten-Viereck-Schalenelement \
  9-Knoten-Viereck-Schalenelement \
  3-Knoten-Dreieck-Schalenelement \
  6-Knoten-Dreieck-Schalenelement],
  [#emph[MicroFe];],
  [Kirchhoff/Mindlin Elementansätze für dicke und dünne Platten und Faltwerke \(mbAEC, Produktflyer MicroFe)],
)]
)

], caption: figure.caption(
position: bottom, 
[
Finite-Elemente-Software und deren Elementtypen
]), 
kind: "quarto-float-tbl", 
supplement: "Table", 
numbering: "1", 
)
<tbl-FEM-Software>


#strong[InfoCAD]

InfoCAD bietet die Möglichkeit, sich zwischen „discrete Kirchhoff theory“ \(DKT) - Elementen und „Mindlin-Reissner“ \(MR) - Elemente zu entscheiden. Laut Benutzerhandbuch erfüllen alle Elementansätzt den Patch-Test. Bei der berechnung nach Kirchhoff werden nachdem die Verzerrungs-Verschiebungs-Beziehungen für die dicke Platte formuliert wurden, die Kirchhoff’schen Bedingungen für die dünne Platte an diskreten Punkten der Elementberandung eingeführt. "Dadurch können auch bei diesen Elementen die Unbekannten des Verformungsansatzes durch die Eckknotenverformungen ausgedrückt werden. Der Vorteil gegenüber einem reinen Verschiebungsansatz bei Plattenelementen zeigt sich in einem wesentlich verbesserten Konvergenzverhalten."#footnote[siehe Benutzerhandbuch InfoCAD];.

#strong[RFEM]

Auch bei RFEM ist die Wahl zwischen beiden Plattentheorien möglich. Empfohlen wird die Nutzung der Kirchhofftheorie für die Berechnung dünnerer Platten wie Stahlbleche. Dicke Platten und Schalen des Massivbaus sollten auf Grundlage der Reissner-Mindlin Theorie berechnet werden. Eine genaue Beschreibung der verwendeten Plattenelemente erfolgt in dem Handbuch von RFEM 6 nicht. Lediglich die Viereckigen Schalenelemente, basierend auf der Reissner-Mindlin Theorie werden vorgestellt. "Basierend aufeiner gemischten Interpolation der transversalen Verschiebungen, Querschnittsdrehungen und transversalen Schubverzerrungen werden die von Bathe und Dvorkin \[3\] vorgestellten MITC-Elemente \(Mixed Interpolationof Tensorial Components) verwendet: MITC3+ für Dreiecke, MITC4 für Vierecke."#footnote[siehe Benutzerhandbuch RFEM]

#strong[SAP2000]

Bei SAP2000 handelt es sich um eine amerikansiche Software die entwickelt und vertrieben wird über Computers and Structures Inc.~\(CSi), Walnut Creek, CA, USA. Neben den US-Amerikanischen Normen ist auch der Eurocode in dem Programm hinterlegt und ermöglicht die Nutzung in Deutschland. Sowohl für die Reissner-Mindlin Theorie, als auch für die Kirchhoffsche Plattentheorie enthält SAP2000 eine 3-Knoten-Dreieckelement und ein 4-Knoten-Viereckelement.

== Programmstruktur
<sec-Programmstruktur>
Umsetzung in JULIA entsprechend dem mathematischen Konzept welches in den vorangegangenden Kapiteln ausführlich beschrieben wurde.

Die Abbildung zeigt den schematischen Aufbau des Programms anhand der einzelnen Programmteile, welche in den folgenden Unterkapiteln näher betrachtet werden.

== Programmteile
<sec-Programmteile>
Nachfolgend werden die Programmteile vorgestellt

=== Parameter
<sec-Parameter>
Als erstes werden die Parameter der zu berechnenden Platte in einer Parameterliste mit Variablen festgelegt.

````markdown
```{julia}
p = @var Params()
p.lx = 8
p.ly = 8
p.q = 5e3
p.ν = 0.2
p.h = 0.2
p.E = 31000e6;
```
````

Die Definition der Parameter p.lx und p.ly ist nicht zwingendermaßen notwendig. Bei einer rechteckigen Platte kann anhand dessen, durch die in @sec-Berechnungsgebiet beschriebene Funktion #emph[makemeshonrectangle\()];, ein FE-Netz für die Platte der Länge p.lx und der Breite p.ly erzeugt werden. Die Parameter p.q, p.ν, p.h und p.E beschreiben die einwirkende Flächelast $q$, die Querdehnzahl $nu$, die Plattendicke $h$ und das Elastizitätsmodul des Materials $E$.

=== Gebiet $Omega$
<sec-Berechnungsgebiet>
Die Definition eines Netzes erfolgt mit Hilfe der MMJMesh.Meshes Bilbliothek. Für die Beispiele in Kapitel… sind die nachfolgenden drei Funktionen wichtig. Zur Erzeugung einer einfachen rechteckigen Platte mit den Längen lx und ly und einem gleichmäßiges Netz mit gleichgroßen Elementen wird die Funktion #emph[makemeshonrectangle\(lx, ly, nx, ny)] genutzt. Die Eingabeparameter #emph[nx] und #emph[ny] geben die Anzahl der Unterteilungen je Seite an.

````markdown
```{julia}
m = makemeshonrectangle(lx, ly, nx, ny)
```
````

#figure([
#box(width: 80%,image("00-pics/mesh-rect.png"))
], caption: figure.caption(
position: bottom, 
[
FE-Netz erzueugt mit der Funktion #emph[makemeshonrectangle]
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
numbering: "1", 
)
<fig-makemeshonrectangle>


Alternativ kann die Platte und das FE-Netz mit selbstdefinierten Koordinaten #emph[coords] und der Verbindung von vier Knoten zu einem Element durch #emph[elts] erzeugt werden.

````markdown
```{julia}
coords = [0.0 20.0 40.0 0.0  20.0 40.0 0.0  20.0 40.0;
          0.0 0.0  0.0  10.0 10.0 10.0 20.0 20.0 20.0]
elts = [[1,2,5,4],[2,3,6,5],[4,5,8,7],[5,6,9,8]]
m = Mesh(coords, elts, 2);
```
````

#figure([
#box(width: 80%,image("00-pics/mesh-coords-elts.png"))
], caption: figure.caption(
position: bottom, 
[
FE-Netz erzeugt mit der Funktion #emph[Mesh\()]
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
numbering: "1", 
)
<fig-Mesh>


Alternativ kann eine .msh Datei eingepflegt werden mit

````markdown
```{julia}
m = Mesh("complex-plate.msh")
```
````

#figure([
#box(width: 80%,image("00-pics/complex-plate.png"))
], caption: figure.caption(
position: bottom, 
[
FE-Netz aus complex-plate.msh Datei
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
numbering: "1", 
)
<fig-Mesh>


=== Formfunktionen
<formfunktionen>
#strong[Hermite-Elemente]

````markdown
```{julia}
function hermiteelement(V;conforming=true)
    if conforming
        m = 16
        P = mmonomials(2, 3, QHat  ,type = Int)
        N = vcat(
            [   [ValueAtLF(p), 
                PDerivativeAtLF(p, [1, 0]), 
                PDerivativeAtLF(p, [0, 1]), 
                PDerivativeAtLF(p, [1, 1])]
                for p in eachcol(V)]...
            )
    else 
        m = 12
        P = mmonomials(2, 3, QHat , (p1, p2) -> p1 + p2 <= 4 && p1 * p2 <4,type = Int)
        N = vcat(
            [   [ValueAtLF(p), 
                PDerivativeAtLF(p, [1, 0]), 
                PDerivativeAtLF(p, [0, 1])]
                for p in eachcol(V)]...
        )
    end
    Imatrix = Matrix{Int}(I, m, m)
    M = [n(p) for p in P, n in N]
    Minv = (M \ Imatrix) #round.(...., digits=10) 
    H4 = (Minv*P)
    return H4
end;
```
````

#strong[Lagrange-Elemente]

````markdown
```{julia}
function lagrangeelement(V)
        m = 4
        P = mmonomials(2, 1, QHat  ,type = Int)
        N = vcat(
            [   [ValueAtLF(p)]
                for p in eachcol(V)]...
            )
        Imatrix = Matrix{Int}(I, m, m)
        M = [n(p) for p in P, n in N]
        Minv = simplifyx.(M \ Imatrix)
        L4 = Minv*P
    return L4
end;
```
````

#strong[Serendipity-Elemente]

````markdown
```{julia}
function serendipityelement(V)
    W = Array{Int64,2}(undef, 2,4)
    for i = 1:3
            W[1,i] = (V[1,i] + V[1,i+1]) * 0.5
            W[2,i] = (V[2,i] + V[2,i+1]) * 0.5
    end
    W[1,4] = (V[1,4] + V[1,1]) * 0.5
    W[2,4] = (V[2,4] + V[2,1]) * 0.5
    P = mmonomials(2, 2, QHat,(p1, p2) -> p1 + p2 < 4, type = Int)
    N = vcat(
        [   ValueAtLF(p)
            for p in eachcol(V)],
        [   [ValueAtLF(q)]
            for q in eachcol(W)]...
    )
    M = [n(p) for p in P, n in N]
    S8 = inv(M)*P
    return S8
end;
```
````

=== Elementsteifigkeitsmatrizen & Elementlastvektoren
<elementsteifigkeitsmatrizen-elementlastvektoren>
für Bogner-Fox-Schmitt Formulierung

für allgemeine Vierecke:

````markdown
```{julia}
using MMJMesh.Geometries
# Gauss points for numerical integration
const gaussWeights = ones(4)
const gaussPoints = 1 / sqrt(3) * [[-1, -1], [1, -1], [1, 1], [-1, 1]]

# Shape functions and gradients
V = [ -1 1 1 -1; -1 -1 1 1]
const N = MappingFromComponents(lagrangeelement(V)...)

# Element matrix
function plateKe(p)
    function keFunc(e)
        D = p.E*p.h^3 / 12*(1-p.ν^2) * [1 p.ν 0; p.ν 1 0; 0 0 (1-p.ν)/2]
        Ke = zeros(12,12)
        jF = jacobian(parametrization(geometry(e)))
        
        Hx = MappingFromComponents(btpHx(e)...) # 12 Element Vektor mit Hx Funktionen 
        Hy = MappingFromComponents(btpHy(e)...) # 12 Element Vektor mit Hy Funktionen 
        ∇ξN = MMJMesh.Mathematics.TransposeMapping(jacobian(Hx))
        ∇ηN = MMJMesh.Mathematics.TransposeMapping(jacobian(Hy))

        for (ξ, w) ∈ zip(gaussPoints, gaussWeights)
            # Jacobi matrix ausgewertet an der Stelle ξ
            J = jF(ξ)
            ∇ₓN = (inv(J') * ∇ξN(ξ))
            ∇yN = (inv(J') * ∇ηN(ξ)) 
            B = [∇ₓN[1,:]', ∇yN[2,:]', ∇yN[1,:]'+ ∇ₓN[2,:]']
            Ke += w * B' * D * B * det(J)
        end
        return Ke
    end
    return keFunc
end;
```
````

Die Funktionen Hx und Hy werden wie in Kapitel … beschrieben hergeleitet. Ke \= Gl. \(16) aus dem Paper von Batoz und Tahar.

=== Randbedingungen
<randbedingungen>
````markdown
```{julia}
function applyDirichletBCs!(fixedNodes, K, r, fixed = [true])
    dofs = fixedDOFs(fixedNodes,fixed)
    r[dofs] .= 0
    K[dofs, :] .= 0
    K[diagind(K)[dofs]] .= 1
    return nothing 
end;
```
````

=== Assemblierung Steifigkeitsmatrix
<assemblierung-steifigkeitsmatrix>
````markdown
```{julia}
function assembleKr(s, nf)
    N = nnodes(s) * nf
    K = zeros(N, N)
    r = zeros(N)

    for e ∈ elements(s)
        # Indexvektor
        nI = nodeindices(e)
        I = fill(1, nf * 4)      # Vektor (mit 1 gefüllt)
        for i = 1:nf
            I[i+0*nf] = nI[1] * nf - nf + i
            I[i+1*nf] = nI[2] * nf - nf + i
            I[i+2*nf] = nI[3] * nf - nf + i
            I[i+3*nf] = nI[4] * nf - nf + i
        end
        # Berechnung ke für jedes Element
        kef = data(e, :kefunc)
        Ke = kef(e)
        # Addition von ke auf die globale Steifigkeitsmatrix K
        K[I, I] += Ke

        # Berechnung re für jedes Element
        ref = data(e, :refunc)
        re = ref(e)
        # Addition von re auf den globalen Lastvektor
        r[I] += re
    end
    return K, r
end;
```
````

=== Postprozessor
<postprozessor>
für die Formulierung allgemeiner Vierecke werden die Schnittgrößen von den Verdrehungen $beta_x$ und $beta_y$ abgeleitet gemäß Batoz und Tahar, da für die Verschiebung w keine weiteren Aussagen getätigt werden.

````markdown
```{julia}
function postprocessor(params, wHat)
    return (face, name) -> begin

        # Plate properties
        h = params.h
        E = params.E
        ν = params.ν
        D = E*h^3 / 12*(1-ν^2) 

        # Element displacement function
            # Indices
        idxs = idxDOFs(nodeindices(face), 3)
        idxsWe = idxs[1:3:end]  

        V = [ -1 1 1 -1; -1 -1 1 1]
        we = sum(wHat[idxsWe] .* lagrangeelement(V))

        # first Derivatives of w = beta 
        βx = -sum(btpHx(face) .* wHat[idxs]) # Beta x = -wx
        βy = -sum(btpHy(face) .* wHat[idxs]) # Beta y = -wy

        # Quick return
        name == :w && return we

        # Derivatives
        wxx = ∂x(βx)
        wyy = ∂y(βy)
        wxy = ∂y(βx) + ∂x(βy)
        Δw = wxx + wyy

        # Return
        name == :βx && return βx
        name == :βx && return βx
        name == :wxx && return wxx
        name == :wyy && return wyy
        name == :wxy && return wxy
        name == :Δw && return Δw

        # Section forces (Altenbach et al. p176)
        mx = -1e-3 * D * (wxx + ν * wyy)
        my = -1e-3 * D * (ν * wxx + wyy)
        mxy = -1e-3 * D * (1 - ν) * wxy
        qx = -1e-3 * D * ∂x(Δw)
        qy = -1e-3 * D * ∂y(Δw)

        # Return
        name == :mx && return mx
        name == :my && return my
        name == :mxy && return mxy
        name == :qx && return qx
        name == :qy && return qy

        # Unknown label
        error("Unkown function: ", name)
    end
end;
```
````

#strong[Umsetzung in JULIA] Einführung in Julia für FEM Implementierung der Formulierung für rechteckige Elemente Code-Struktur und wichtige Funktionen Implementierung für allgemeine Vierecke Herausforderungen und Lösungen

#pagebreak()
#set page(header: align(right, emph(text(size: 12pt)[Kapitel 6: Anwendungsbeispiele])))
= Anwendungsbeispiele
<sec-anwendungsbeispiele>
== Patch-Test
<patch-test>
constant state of stresses on the rectangular plate Lasten auf die rechteckige Platte mit 5 Elementen aufbringen so dass sich ein kosntanter Spannungszustand einsdtellt.

Wird hier eingesetzt um zu überprüfen, ob das Programm funktioniert und zu validieren.

=== Eingabewerte
<eingabewerte>
Die rechteckige Platte wird in 5 allgemeine Vierecke unterteilt. Die Außenabmessungen entsprechen Abbildung 3 aus \[Quelle:Batoz Tahar\]. Auch die Innenabmessungen sind an das Beispiel angelehnt. Um das Mesh zu erzeugen wird die Funktion 'makequadrilateralMesh\(p)' aufgerufen. Die Abmessungen sind Abbildung … zu entnehmen.

#block[
```julia
function makequadrilateralMesh(p)
    coords = [0.0 (9/50 * p.lx) (18/25 * p.lx) p.lx 0.0  
              (9/25 * p.lx) (18/25 * p.lx) p.lx;
              0.0 (2/10 * p.ly) (4/10 * p.ly) 0.0  
              p.ly (7/10 * p.ly) (7/10 * p.ly) p.ly]
    elts = [[1,4,3,2],[3,4,8,7],[6,7,8,5],[1,2,6,5],[2,3,7,6]]
    m = MMJMesh.Meshes.Mesh(coords, elts, 2)
    return m
end
```

#block[
```
makequadrilateralMesh (generic function with 1 method)
```

]
]
TODO: Abbildung Mesh mit Abmessungen und Lasten

An den Eckpunkten wird jeweils um die y-Achse ein Moment von 20 und umd die x-Achse ein Moment von 10 angesetz, so dass sich über die Länge verteilt ein Moment von 1 ergibt. Dementsprechend wird erwartet, dass sich bei den Ergebnissen sowohl um die x- als auch um die y-Achse ein Momenten Verlauf von konstant 1 einstellt.

== Beispiel 1: allseitig eingespannte Platte
<beispiel-1-allseitig-eingespannte-platte>
Als erstes Beispiel dient eine allseitig eingespannte Platte die durch eine konstante Flächenlast belastet wird. Das statische System sowie das FE-Netz sind in @fig-Beispiel-01-BFS dargestellt. Die gewählte Struktur ermöglicht den Vergleich mit den Werten der Czerny-Tafeln um die Plausibilität der Ergebnisse zu prüfen. Sowohl eine Finite Elemente Berechnung mittels des Elementansatzes nach Bogner Fox und Schmitt \(BFS-Element), als auch nach Batoz und Tahar \(DKQ-Element) wird angewandt. Zur weiteren Validierung erfolgt eine weitere Berechnung mit dem kommerziellen Programm MicroFE der Firma #emph[mb AEC Software GmbH];.

#figure([
#block[
#grid(columns: 2, gutter: 2em,
  [
#figure([
#box(width: 80%,image("00-pics/Beispiel-01-BFS.png"))
], caption: figure.caption(
position: bottom, 
[
quadratische Platte | 8m x 8m mit 400 Elementen
]), 
kind: "quarto-subfloat-fig", 
supplement: "", 
numbering: "(a)", 
)
<fig-Beispiel-01-FE-Netz>


]
)
]
], caption: figure.caption(
position: bottom, 
[
allseitig eingespannte quadratische Platte
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)
<fig-Beispiel-01-BFS>


Für die Berechnung der $8 m times 8 m$ großen Platte werden die in @tbl-Eingabedaten angegebenen Eingangsparameter zugrunde gelegt.

#figure([
#figure(
align(center)[#table(
  columns: 2,
  align: (col, row) => (left,left,).at(col),
  inset: 6pt,
  [Plattendicke],
  [$d = 0.2 upright(" m")$],
  [Elastizitätsmodul],
  [$E = 31.000 upright(" N/mm")^2$],
  [Flächenlast],
  [$p = 5 upright(" kN")$],
  [],
  [$nu = 0.0$],
)]
)

], caption: figure.caption(
position: bottom, 
[
Daten zum Beispiel "allseitig eingespannte Platte"
]), 
kind: "quarto-float-tbl", 
supplement: "Table", 
numbering: "1", 
)
<tbl-Eingabedaten>


Aus den Czerny-Tafeln \(Tafel 2.2.6.1, "Starre Einspannung der vier Ränder") ergeben sich folgende Werte:

#math.equation(block: true, numbering: "(1)", [ $  & m_(x_(e r m)) &  & = - frac(p dot.op l_x^2, 19.4) &  & = - 16494.85 &  & upright("Nm")^2\
 & m_(x_m) &  & = frac(p dot.op l_x^2, 56.8) &  & = 5633.80 &  & upright("Nm")^2\
 & m_(y_(e r m)) &  & = - frac(p dot.op l_x^2, 19.4) &  & = - 16494.85 &  & upright("Nm")^2\
 & m_(y_(m a x)) &  & = frac(p dot.op l_x^2, 56.8) &  & = 5633.80 &  & upright("Nm")^2\
 & q_(x_(e r m)) &  & = plus.minus frac(p dot.op l_x, 2.24) &  & = plus.minus 17857.14 &  & upright("Nm")\
 & q_(y_(e r m)) &  & = plus.minus frac(p dot.op l_x, 2.24) &  & = plus.minus 17857.14 &  & upright("Nm")\
 & w_(m a x) &  & = frac(p dot.op l_x^4, E dot.op d^3) dot.op 0.0152 &  & = 0.001255 &  & upright("m")\
 $ ])<eq-werte-czerny-tafeln>

Die Einspannmomente im Randmittelpunkt des starr eingespannten Plattenrandes sind $m_(x_(e r m))$ und $m_(y_(e r m))$. Die Feldmomente in Plattenmitte $m_(x_m)$ und $m_(y_m)$ und die größten Feldmomente im Plattenmittenschnitt $m_(x_(m a x))$, $m_(y_(m a x))$ stimmen bei der symmetrischen Platte überein. Die Biegemomentenverläufe in @fig-Biegemomente-BFS spiegeln dies wieder. Die Stützkräfte in Randmitte der starr eingespannten Plattenränder $q_(x_(e r m))$ und $q_(y_(e r m))$ sind in @fig-Querkräfte-BFS dargestellt .

=== Berechnung nach Bogner Fox Schmitt
<berechnung-nach-bogner-fox-schmitt>
Die resultierende Verformungsfigur in überhöhter Darstellung ist in Abbildung 5.12 dargestellt. Die maximale Durchbiegung in Feldmitte, ermittelt durch die FE-Berechnung beträgt $w_(m a x) = 0.00125 m$ und weicht bezogen auf den Tabellenwert aus @eq-werte-czerny-tafeln um $0.0297 %$ ab.

#figure([
#block[
#grid(columns: 2, gutter: 2em,
  [
#figure([
#box(width: 80%,image("00-pics/Beispiel-01-BFS-mx.png"))
], caption: figure.caption(
position: bottom, 
[
$m_x$ \[kNm\]
]), 
kind: "quarto-subfloat-fig", 
supplement: "", 
numbering: "(a)", 
)
<fig-BFS-mx>


]
,
  [
#figure([
#box(width: 80%,image("00-pics/Beispiel-01-BFS-mx-glatt.png"))
], caption: figure.caption(
position: bottom, 
[
$m_x$ geglättet \[kNm\]
]), 
kind: "quarto-subfloat-fig", 
supplement: "", 
numbering: "(a)", 
)
<fig-BFS-mx-Glatt>


]
,
  [
#figure([
#box(width: 80%,image("00-pics/Beispiel-01-BFS-my.png"))
], caption: figure.caption(
position: bottom, 
[
$m_y$ \[kNm\]
]), 
kind: "quarto-subfloat-fig", 
supplement: "", 
numbering: "(a)", 
)
<fig-BFS-my>


]
,
  [
#figure([
#box(width: 80%,image("00-pics/Beispiel-01-BFS-my-glatt.png"))
], caption: figure.caption(
position: bottom, 
[
$m_y$ geglättet \[kNm\]
]), 
kind: "quarto-subfloat-fig", 
supplement: "", 
numbering: "(a)", 
)
<fig-BFS-my-Glatt>


]
,
  [
#figure([
#box(width: 80%,image("00-pics/Beispiel-01-BFS-mxy.png"))
], caption: figure.caption(
position: bottom, 
[
$m_(x y)$ \[kNm\]
]), 
kind: "quarto-subfloat-fig", 
supplement: "", 
numbering: "(a)", 
)
<fig-BFS-mxy>


]
,
  [
#figure([
#box(width: 80%,image("00-pics/Beispiel-01-BFS-mxy-glatt.png"))
], caption: figure.caption(
position: bottom, 
[
$m_(x y)$ geglättet \[kNm\]
]), 
kind: "quarto-subfloat-fig", 
supplement: "", 
numbering: "(a)", 
)
<fig-BFS-mxy-Glatt>


]
)
]
], caption: figure.caption(
position: bottom, 
[
Biegemomente Platte Bogner Fox Schmitt
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)
<fig-Biegemomente-BFS>


#figure([
#block[
#grid(columns: 2, gutter: 2em,
  [
#figure([
#box(width: 80%,image("00-pics/Beispiel-01-BFS-qx.png"))
], caption: figure.caption(
position: bottom, 
[
qx
]), 
kind: "quarto-subfloat-fig", 
supplement: "", 
numbering: "(a)", 
)
<fig-BFS-qx>


]
,
  [
#figure([
#box(width: 80%,image("00-pics/Beispiel-01-BFS-qx-glatt.png"))
], caption: figure.caption(
position: bottom, 
[
qx geglättet
]), 
kind: "quarto-subfloat-fig", 
supplement: "", 
numbering: "(a)", 
)
<fig-BFS-qx-Glatt>


]
,
  [
#figure([
#box(width: 80%,image("00-pics/Beispiel-01-BFS-qy.png"))
], caption: figure.caption(
position: bottom, 
[
qy
]), 
kind: "quarto-subfloat-fig", 
supplement: "", 
numbering: "(a)", 
)
<fig-BFS-qy>


]
,
  [
#figure([
#box(width: 80%,image("00-pics/Beispiel-01-BFS-qy-glatt.png"))
], caption: figure.caption(
position: bottom, 
[
qy geglättet
]), 
kind: "quarto-subfloat-fig", 
supplement: "", 
numbering: "(a)", 
)
<fig-BFS-qy-Glatt>


]
)
]
], caption: figure.caption(
position: bottom, 
[
Querkräfte Platte Bogner Fox Schmitt
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)
<fig-Querkräfte-BFS>


=== Berechnung nach Batoz und Tahar
<berechnung-nach-batoz-und-tahar>
#figure([
#block[
#grid(columns: 2, gutter: 2em,
  [
#figure([
#box(width: 80%,image("00-pics/Beispiel-01-BT-mx.png"))
], caption: figure.caption(
position: bottom, 
[
$m_x$ \[kNm\]
]), 
kind: "quarto-subfloat-fig", 
supplement: "", 
numbering: "(a)", 
)
<fig-BFS-mx>


]
,
  [
#figure([
#box(width: 80%,image("00-pics/Beispiel-01-BT-mx-glatt.png"))
], caption: figure.caption(
position: bottom, 
[
$m_x$ geglättet \[kNm\]
]), 
kind: "quarto-subfloat-fig", 
supplement: "", 
numbering: "(a)", 
)
<fig-BFS-mx-Glatt>


]
,
  [
#figure([
#box(width: 80%,image("00-pics/Beispiel-01-BT-my.png"))
], caption: figure.caption(
position: bottom, 
[
$m_y$ \[kNm\]
]), 
kind: "quarto-subfloat-fig", 
supplement: "", 
numbering: "(a)", 
)
<fig-BFS-my>


]
,
  [
#figure([
#box(width: 80%,image("00-pics/Beispiel-01-BT-my-glatt.png"))
], caption: figure.caption(
position: bottom, 
[
$m_y$ geglättet \[kNm\]
]), 
kind: "quarto-subfloat-fig", 
supplement: "", 
numbering: "(a)", 
)
<fig-BFS-my-Glatt>


]
,
  [
#figure([
#box(width: 80%,image("00-pics/Beispiel-01-BT-mxy.png"))
], caption: figure.caption(
position: bottom, 
[
$m_(x y)$ \[kNm\]
]), 
kind: "quarto-subfloat-fig", 
supplement: "", 
numbering: "(a)", 
)
<fig-BFS-mxy>


]
,
  [
#figure([
#box(width: 80%,image("00-pics/Beispiel-01-BT-mxy-glatt.png"))
], caption: figure.caption(
position: bottom, 
[
$m_(x y)$ geglättet \[kNm\]
]), 
kind: "quarto-subfloat-fig", 
supplement: "", 
numbering: "(a)", 
)
<fig-BFS-mxy-Glatt>


]
)
]
], caption: figure.caption(
position: bottom, 
[
Biegemomente Platte Batoz & Tahar
]), 
kind: "quarto-float-fig", 
supplement: "Figure", 
)
<fig-Biegemomente-BTP>


#pagebreak()
muss noch eingefügt werden: numerische Integration numerische-integration.qmd \(an der STelle wo es auftaucht, oder Verweis auf eine Quelle)
