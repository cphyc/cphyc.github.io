k#import "cv.typ": *
#import "@preview/tablex:0.0.9": tablex, rowspanx, colspanx, cellx, vlinex, hlinex
#import "@preview/nth:1.0.1": nth
#import "@preview/fontawesome:0.5.0": *

#show regex("\bRamses\b"): smallcaps
#show regex("\bDyablo\b"): smallcaps
#show regex("\bPynbody\b"): smallcaps
#show regex("\bTangos\b"): smallcaps
#show regex("\byt\b"): smallcaps[Yt]

So far, I have given *10 invited talks at conferences and seminars*, listed below. Poster presentations are highlighted as "#fa-icon("newspaper")".
#v(-.5em)

#let data = (
  "Invited talks": (
    (
        date: [03/2023],
        title: [$star$ Connecting Galaxies to Cosmology visiting Program],
        location: [KITP, Santa Barbara, USA],
        description: none
    ),
    (
        date: [10/2022],
        title: [$star$ #nth(10) Workshop on Cosmology and Structure Formation],
        location: [KIAS, Seoul, South Korea],
        description: none
    ),
    (
        date: [03/2022],
        title: [$star$ Cosmic Cartography],
        location: [_online_, Kavli IPMU, Kashiwa, Japan],
        description: none
    ),
    (
        date: [01/2021],
        title: [$star$ LCDM: Dark Matter In Cosmology],
        location: [_online_, Monthly meeting of London-based cosmologists],
        description: none
    ),
    (
        date: [11/2019],
        title: [$star$ Yonsei-IAP Workshop],
        location: [_online_],
        description: none
    ),
    (
        date: [03/2019],
        title: [$star$ yt workshop],
        location: [University of Illinois, Urbana, USA],
        description: none
    ),
    // (
    //     date: [06/2020],
    //     title: [$star$ yt workshop. Tutor of one of the 'hands-on' sessions],
    //     location: [_cancelled_, Royal Observatory, Edinburgh],
    //     description: none
    // ),
  ),
  "Invited seminars": (
    (
        date: [04/2023],
        title: [$star$ Kavli Institute for Theoretical Physics blackboard talk],
        location: [KITP, Santa Barbara, USA],
        description: [Prestigious talks intended to explain the science of one program to the other KITP program participants, locals, and scientists outside of a specialized field.]
    ),
    (
        date: [02/2022],
        title: [$star$ Berkeley Cosmology Seminar],
        location: [_online_, Berkeley, USA],
        description: none
    ),
    (
        date: [11/2021],
        title: [$star$ Oxford Cosmology Seminar],
        location: [Oxford, UK],
        description: none
    ),
  ),
  "Contributed talks": (
    (
        date: [03/2024],
        title: [Building Galaxies from Scratch],
        location: [University of Vienna, Austria],
        description: none
    ),
    (
        date: [06/2022],
        title: [#fa-icon("newspaper") EAS Meeting],
        location: [Valencia, Spain],
        description: none,
    ),
    (
        date: [07/2022],
        title: [#fa-icon("newspaper")  National Astronomy Meeting (NAM)],
        location: [Warwick, UK],
        description: none,
    ),
    (
        date: [01/2024],
        title: [#fa-icon("newspaper") D-LOCKS Meeting],
        location: [Technical University of Denmark, Copenhagen, Denmark],
        description: none,
    ),
    (
        date: [12/2023],
        title: [New Simulations for New Problems in Galaxy Formation],
        location: [Institut d'Astrophysique de Paris, France],
        description: none
    ),
    (
        date: [08/2023],
        title: [Santa Cruz Galaxy Workshop],
        location: [University of California Santa Cruz, USA],
        description: none
    ),
    (
        date: [06/2022],
        title: [Journées du PNCG (cosmology \& galaxies)],
        location: [Observatoire Astronomique de Strasbourg, France],
        description: none
    ),
    (
        date: [09/2021],
        title: [Ramses User Meeting],
        location: [_online_, Strasbourg Observatory, France],
        description: none
    ),
    (
        date: [07/2021],
        title: [Scipy 21: data analysis and code development in Python (900 participants)],
        location: [_online_],
        description: none
    ),
    (
        date: [12/2020],
        title: [RHytHM: ResearcH using yt Highlights Meeting.],
        location: [_online_],
        description: none
    ),
    (
        date: [11/2020],
        title: [KIAS Cosmology Workshop.],
        location: [_online_],
        description: none
    ),
    // (
    //     date: [08/2020],
    //     title: [#nth(16) Internat. Conference on the Dark Side of the Universe],
    //     location: [_cancelled_, ICTP, Kigali, Rwanda],
    //     description: none
    // ),
    // (
    //     date: [04/2020],
    //     title: [Cosmic Cartography 20: Exploring the Cosmic Web and Large-Scale Structure],
    //     location: [#h(.3em) _cancelled_, Kavli IPMU, Kashiwa, Japan],
    //     description: none
    // ),
    (
        date: [10/2019],
        title: [KIAS Internal Workshop],
        location: [KIAS, Seoul, South Korea],
        description: none
    ),
    (
        date: [09/2018],
        title: [West Coast Swings workshop],
        location: [ICRAR, Perth, Australia],
        description: none
    ),
    (
        date: [05/2018],
        title: [SPIN(E) ANR Meeting],
        location: [ROE, Edinburgh, UK],
        description: none
    ),
    (
        date: [09/2017],
        title: [SPIN(E) ANR Meeting],
        location: [Agay, France],
        description: none
    ),
    (
        date: [09/2017],
        title: [Ramses User Meeting],
        location: [Nice Observatory, Nice, France],
        description: none
    ),

    (
        date: [09/2016],
        title: [Ramses User Meeting],
        location: [CRAL, Lyon, France],
        description: none
    ),
  ),
  "Contributed seminars and journal clubs": (
    (
        date: [04/2017],
        title: [CITA Journal Club],
        location: [CITA, Toronto, Canada],
        description: none
    ),
    (
        date: [12/2021],
        title: ['FLAT' talk],
        location: [Durham, UK],
        description: none
    ),
    (
        date: [11/2021],
        title: [Cosmology Journal Club],
        location: [IAP, Paris, France],
        description: none
    ),
    (
        date: [11/2021],
        title: [Astrophysics Journal Club],
        location: [Racah Institute of Physics, Jerusalem, Israel],
        description: none
    ),
    (
        date: [10/2021],
        title: [Galaxy Coffee],
        location: [MPIA, Heidelberg, Germany],
        description: none
    ),
    (
        date: [09/2021],
        title: [Cambridge Cosmology Seminar],
        location: [_online_, Institute of Astronomy, Cambridge, UK],
        description: none
    ),
    (
        date: [12/2018],
        title: [Journal club \& visiting program],
        location: [Astrophysics Department, Oxford, UK],
        description: none
    ),
    (
        date: [04/2018],
        title: [CRAL journal club],
        location: [CRAL, Lyon, France],
        description: none
    ),
    (
        date: [10/2017],
        title: [KIAS journal club],
        location: [KIAS, Seoul, South Korea],
        description: none
    ),
  ),
)

// Display all this
#entryGroup(
  ..data.keys().map(key => {
    (
      ..entryDivider()[#key],
      ..data.at(key).sorted(
        key: el => {
          let date = el.at("date")
          let (month, year) = date.text.split("/").map(it => int(it))
          -(year * 12 + month)
        }
      ).map(el => entrynohl(..el))
      .flatten()
    )
  }).flatten()
)