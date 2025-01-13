/*
 * Twenty Seconds Curriculum Vitae in Typst
 * Author: Xiaoliang Wang
 * Date: 2023-08-04
 * License: MIT (see included file LICENSE)
 */

#import "@preview/fontawesome:0.1.0": *
#import "@preview/tablex:0.0.5": tablex, rowspanx, colspanx, cellx
 
#let headercolor = gray
#let pblue = rgb("#433594ff")
#let gray80 = rgb("#333333") // \color{black!80}
#let sidecolor = rgb("#E7E7E7")
#let mainblue = rgb("#433594ff")
#let maingray = rgb("#B9B9B9")

#let fontSize = (
  tiny: 5pt,
  scriptsize: 7pt,
  footnotesize: 8pt,
  small: 9pt,
  normalsize: 10pt,
  large: 12pt,
  Large: 14pt,
  LARGE: 17pt,
  huge: 20pt,
  Huge: 25pt,
)


#let _num_fmt = (value, separate_thousands: true) => {
    let splitter = (s, from_head: true) => {
        let N = s.len()
        if N <= 3 {
            return s
        }
        let out = ()
        let M = calc.rem(N, 3)
        if (from_head) { 
            if M > 0 {
                out += (s.slice(0, count: M), )
            }
        } else {
            M = 0
        }

        for i in range(0, calc.quo(N, 3)) {
            out = (..out, s.slice(3 * i + M, count:3))
        }
        if (not from_head) {
            let M = calc.rem(N, 3)
            if M > 0 {
                out = (..out, s.slice(N - M, count: M))
            }
        }
        out.join(" thin ")
    }
     // Parse the value
    let val = (
        str(value)
        // Parse 1e10, ...
        .replace(regex("(\d+(\.\d*)?)[eE]([+-]?\d+)"), it => {
            it.captures.at(0) + " times 10^(" + it.captures.at(2) + ")"
        })
        // Parse e10
        .replace(regex("[eE]([+-]?\d+)"), it => {
            "10^(" + it.captures.at(0) + ")"
        })
    )
    if (separate_thousands) {
        if val.contains(".") {
            let (l, h) = val.split(".")
            val = splitter(l, from_head: true) + "." + splitter(h, from_head: false)
        } else  {
            val = splitter(val)
        }
    }
    val
}

#let num = (value, separate_thousands: true) => {
    eval(_num_fmt(value, separate_thousands: separate_thousands), mode: "math")
}

#let knownUnits = (:)
#let SI = (value, unit, knownUnits: knownUnits, separate_thousands: false) => {
    // Parse the value
    let val = _num_fmt(value, separate_thousands: separate_thousands)

    // Parse the units
    let uu = (
        unit
        .replace(".", " ")
        .replace(regex("([a-zA-Z]+)"), it => {
            let u = it.captures.at(0)
            if u in knownUnits {
                knownUnits.at(u)
            } else {
                "upright(\"" + u + "\")"
            }
        })
        .split(" ")
        .join(" thin ")
    )
    eval(val + " thick " + uu, mode: "math")
}

#let profile(
  name: [],
  jobtitle: "",
) = {
  text(fill: pblue, size: fontSize.huge, name) // {\Huge\color{pblue}\cvname}
  linebreak()
  v(2mm)
  text(fill: gray80, size: fontSize.large, jobtitle) // {\Large\color{black!80}\cvjobtitle}
}

#let profile_section(title) = {
  v(3mm)
  align(left)[
    #text(size: fontSize.huge, fill: gray80)[#title]
    #box(width: 1fr, baseline: -0.5em, line(length: 100%, stroke: gray80))
  ]
}

// score is 1 base
#let progress(score) = {
  let radius = (top-left: 3pt, bottom-left: 3pt, rest: 0pt)
  if (score == 1) {
    radius.top-right = 3pt
    radius.bottom-right = 3pt
  }
  box(rect(
    height: 6pt,
    width: score * 100%,
    fill: mainblue,
    radius: radius,
  ))
  box(rect(
    height: 6pt,
    width: (1 - score) * 100%,
    fill: maingray,
    radius: (top-right: 3pt, bottom-right: 3pt, rest: 0pt)
  ))
}

/*
  interest item is dictionary
  (
    interest: "AI",
    score: 0.6 // 1.0 based percentage
  )
*/
#let show_interests(interests) = {
  set text(size: fontSize.large, fill: gray80)
  for interest in interests {
    text(interest.interest)
    linebreak()
    progress(interest.score)
  }
}

/*
  skills item is a list
*/
#let show_skills(skills) = {
  skills.map(skill => {
    box(
      rect(
        radius: 2pt,
        stroke: 1pt + black,
        fill: rgb(255, 255, 255, 120),
      )[#skill]
    )
  }).join(" ")
}

/*
  contact item is dictionary
  (
    icon: "linkedin",
    fa-set: "Brands", // or "Free" or "Free Solid"
    text: "https://www.linkedin.com/in/someone",
  )
*/
#let show_contacts(contacts) = {
  v(3mm)
  let c = ()
  for contact in contacts {
    c.push(fa-icon(contact.icon, fa-set: contact.at("fa-set", default: "Free"), fill: pblue))
    c.push(contact.text)
  }

  grid(
    columns: (auto, auto),
    column-gutter: .2em,
    row-gutter: 1.5em,
    ..c
  )
}

#let body_section(slice: 3, title) = {
  let (header, tailer) = (title.slice(0, slice), title.slice(slice))
  set text(size: fontSize.Large)
  block[
    #v(3mm)
    #strong()[
      #text(fill: pblue, header)#text(fill: headercolor, tailer)
    ]
  ]
}

/*
#1 period, like From - To
#2 title
#3 note, basic note
#4 addtional_note
#5 body: the main body
*/
#let entryGroup(..args) = {
    tablex(
        columns: (1.7cm, 1fr),
        width: 100%,
        align: left + horizon,
        column-gutter: 0pt,
        auto-vlines: false,
        auto-hlines: false,
        ..args,
    )
}
#let entrynohl(title: [], location: [], date: [], description: none) = {
    let ret = (
        text(size: fontSize.small)[#date],
        [
            #set text(size: fontSize.normalsize)
            #title#h(1fr)#text(gray, location)
        ]
    )
  if (description != none) {
    ret += ([], [
      #set text(size: fontSize.small)
      #description
    ])
  }

  ret
}

#let entry(title: [], location: [], date: [], description: none) = {
  entrynohl(title: [*#title*], location: location, date: date, description: description)
}

#let entryDivider(content) = {
  (colspanx(2)[— #text(size: fontSize.normalsize, strong(content))], ())
}

#let secondPage = {

}

#let CV(
  left: [],
  right,
) = {
    let margin = 0.5cm
    let width = 6cm
    set page(
        margin: (
            left: width + margin,
            rest: margin,
        )
    )
    place(
        top,
        dx: - width - margin,
        dy: - margin,
        block(
            fill: sidecolor,
            width: width,
            height: 100% + margin + margin,
            pad(
                top: 1cm,
                left: 1cm,
                rest: 0.5cm,
                left
            )
        ),
    )
    [
        #show heading.where(level: 1): it => body_section(it.body.text)
        #show heading.where(level: 2): it => [ — #text(size: fontSize.large, it.body)]
        #right
    ]
}