#show: masterarbeit-doc.with(
  title: "$title$",
  lang: "$lang$",
  font: "$font$",
  font-size: "$font-size$",
  $if(bibliography)$
    bibliography-file: "$bibliography$",
  $endif$
)
