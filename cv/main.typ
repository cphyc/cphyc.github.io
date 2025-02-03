#import "cv.typ": *
#import "@preview/tablex:0.0.5": tablex, rowspanx, colspanx, cellx, vlinex, hlinex
#import "@preview/nth:0.2.0": nth
#import "@preview/fontawesome:0.1.0": *

#show regex("\bRamses\b"): smallcaps
#show regex("\bDyablo\b"): smallcaps
#show regex("\bPynbody\b"): smallcaps
#show regex("\bTangos\b"): smallcaps
#show regex("\byt\b"): smallcaps[Yt]

#show: CV.with(
  left: [
    #profile(
      name: [#underline[Corentin] Cadiou],
      jobtitle: [
        Assistant professor _Chargé de recherche_
      ]
    )
    
    #set text(size: fontSize.normalsize)

    #show_contacts(
      (
        (
          icon: "cake",
          fa-set: "Free Solid",
          text: [16/09/1992],
        ),
        (
          icon: "mars",
          fa-set: "Free Solid",
          text: [Male],
        ),
        (
          icon: "globe",
          fa-set: "Free Solid",
          text: [French],
        ),
        (
          icon: "envelope",
          fa-set: "Free Solid",
          text: [Institut d'Astrophysique de Paris (IAP)\
                 98 bis boulevard Arago\
                 75014 Paris, France
          ]
        ),
        (
          icon: "link",
          fa-set: "Free Solid",
          text: link("https://cphyc.github.io")[cphyc.github.io],
        ),
        (
          icon: "github",
          fa-set: "Brands",
          text: link("https://github.com/cphyc")[github.com/cphyc],
        ),
        (
          icon: "orcid",
          fa-set: "Brands",
          text: link("https://orcid.org/0000-0003-2285-0332")[0000-0003-
2285-0332],
        ),
        (
          icon: "phone",
          fa-set: "Free Solid",
          text: link("tel:+33 6 43 18 66 83")[+33 6 43 18 66 83],
        ),
        (
          icon: "envelope",
          fa-set: "Free Solid",
          text: link("mailto:corentin.cadiou@iap.fr")[corentin.cadiou\@iap.fr],
        ),
      )
    )

    #set text(size: fontSize.large)
    #profile_section("Science interests")
    galaxy formation\
    cosmic web\
    numerical simulations\
    cosmology

    #profile_section("Languages")
    #show_interests((
      (
        interest: "French (native)",
        score: 1,
      ),
      (
        interest: "English (C2)",
        score: 0.95,
      ),
      (
        interest: "German (B2)",
        score: 0.7,
      ),
      (
        interest: "Spanish & Swedish (A1)",
        score: 0.2,
      ),
    ))

    #profile_section("Numerical skills")
    == HPC
    #show_skills((
      "Ramses",
      "MPI", "OpenMP",
      "CUDA",
      )
    )

    // == Analysis
    // #show_skills(
    //   ("yt", "Pynbody", "Python")
    // )
    
    == Programming
    #show_skills((
      "Fortran",
      "C++",
      "Linux",
    ))

  ]
)

#show link: underline
#set par(justify: true)
// #show heading.where(level: 1): it => [
//   #v(-1em)
//   #it
//   #v(-.1em)
// ]

#v(1.5em)

= Research experience
#entryGroup(
    ..entry(
    date: [2025--now],
    title: [_Chargé de recherche_ (Assistant Professor)],
    location: [IAP, France #box(baseline: 30%, image(height: 1.5em, "images/IAP.png"))],
    description: [Permanent, 100%-research position. Recruited on a interdisciplinary project to develop high-performance computing and data science in astronomy.]
    ),
    ..entry(
    date: [2022--25],
    title: [Post-doctoral research],
    location: [Lund, Sweden #box(baseline: 30%, image(height: 1.5em, "images/Lund.png"))],
    description: [#v(-.5em) Working on the group of Prof. Agertz on the role of angular momentum in the formation of galactic disks. Start: 01/10/2022, end: 31/01/2025]
    ),
    ..entry(
    date: [2019--22],
    title: [Post-doctoral research],
    location: [UCL, London, UK #box(baseline: 0%, image(height: .5em, "images/UCL.png"))],
    description: [#v(-.5em)With Profs. Pontzen and Peiris, on ERC grant.]
    ),
    ..entry(
    date: [2016--19],
    title: [Post-graduate research],
    location: [IAP, Paris, France #box(baseline: 30%, image(height: 1.5em, "images/IAP_cropped.png"))],
    description: [#v(-1em)Supervisors: C.~Pichon and Y.~Dubois.]
    ),
)
#v(-0.5cm)

= Education
#entryGroup(
    ..entry(
        date: [2019],
        title: [PhD in Astrophysics],
        location: [Sorbonne \& IAP, Paris #box(baseline: 30%, image(height: 1.5em, "images/Sorbonne.png")) #box(baseline: 30%, image(height: 1.5em, "images/IAP_cropped.png"))],
        description: ["The impact of the large-scale structures of the Universe on dark matter halo and galaxy formation". Refereed by S.~White and A.~Dekel.]
    ),
    ..entry(
        date: [2016\
        #v(.75cm)],
        title: [Master's degree (Master 2) in Astronomy and Astrophysics],
        location: [\
        #h(1fr)Univ. Paris Diderot, Paris Observatory, Paris, France #box(baseline: 30%, image(height: 1.3em, "images/Université_Paris_Diderot_logo.svg")) #box(baseline: 30%, image(height: 1.3em, "images/Observatoire_de_Paris_logo.png"))],
        description: [] //Specialization in cosmology and numerical astrophysics.]
    ),
)
#v(-2.5em)
#entryGroup(
    ..entrynohl(
        date: [2015],
        title: [Diploma of the École Normale Supérieure (ENS)],
        location: [ENS, Paris #box(baseline: 30%, image(height: 1.5em, "images/ENS.png"))],
        description: [#v(-1em)Major in physics, minor in Computer Sciences]
    ),
    ..entrynohl(
        date: [2013],
        title: [Bachelor's degree, Physics],
        location: [Univ. Paris Diderot \& ENS, Paris #box(baseline: 30%, image(height: 1.3em, "images/Université_Paris_Diderot_logo.svg")) #box(baseline: 30%, image(height: 1.5em, "images/ENS.png"))],
        description: none
    ),
)

= Time allocations
Over my career, I have been *PI or co-I of projects securing #SI(90, "MCPU.hr")* (700,000€, assuming a price of 0.01€/CPU hr). My developments also enabled additional projects for a total of more than #SI(100, "MCPU.hr").
#v(-1em)
#entryGroup(
    //   ..entry(
    //     date: [2024--25],
    //     title: [Mergers shaping Milky Way-like galaxies (PI)],
    //     location: [LUMI, Sweden #box(baseline: 30%, image(height: 1em, "images/LUMI.png"))],
    //     description: [*PI* of an #SI(18, "Mcpu.hr") allocation on Swedish national infrastructures.]
    // ),
     ..entry(
        date: [2024],
        title: [(co-I) Harkonnens simulations],
        location: [#box(baseline: 10%, image(height: .9em, "images/BSC-blue.svg"))],
        description: [#v(-.5em)*#SI(20, "MCPU.hr") allocation* (Spanish national call). Suite of high-resolution simulations to support ESA's ARRAKIHS mission to investigate the nature of dark matter.]
    ),
    ..entry(
        date: [2024],
        title: [(PI) The role of mergers in shaping Milky-Way galaxies],
        location: [#box(baseline: 10%, image(height: .9em, "images/LUMI.svg"))],
        description: [#v(-.5em)*#SI(6, "MCPU.hr") allocation* (Swedish national call). Suite of high-resolution simulations focused on the role played by mergers in the formation of our galaxy.]
    ),
    ..entry(
        date: [2024],
        title: [(PI) How the cosmological environment drives galaxy properties],
        location: [#box(baseline: 30%, image(height: 1.5em, "images/Lund.png"))],
        description: [#v(-1em)*#SI(3.6, "MCPU.hr") allocation* (local call). Suite of simulations to unravel the role played by the cosmological environment in setting the properties of galaxies.]
    ),
    ..entry(
        date: [2023--25],
        title: [(co-I) MEGATRON project],
        location: [#box(baseline: 10%, image(height: 1em, "images/DIRAC.svg"))],
        description: [#v(-.5em)*Large #SI(50, "MCPU.hr") allocation* (UK national call), #nth(15) DiRAC call (PI: H.~Katz).
        Extreme-resolution cosmological simulation focused on circum-galactic physics.
      ]
    ),
    ..entry(
        date: [2021--22],
        title: [(PI) Angular momentum project],
        location: [#box(baseline: 10%, image(height: 1em, "images/DIRAC.svg"))],
        description: [#v(-.5em)*#SI(9.7, "MCPU.hr") allocation* (UK national call), #nth(13) DiRAC call.
        Demonstration of the feasibility of controlling the angular momentum of galaxies in a cosmological volume.
      ]
    ),
    ..entrynohl(
        date: [2021--24],
        title: [EDGE Project ('code builder' status)],
        location: [#box(baseline: 10%, image(height: 1em, "images/DIRAC.svg"))],
        description: [#v(-.5em)Automatically co-author of all publications that use my contributed code. #SI(40, "MCPU.hr") obtained (UK national call, PI: J.~Read).
          Suite state-of-the-art simulations of dwarf galaxies.
      ]
    ),
    ..entrynohl(
        date: [2020--21],
        title: [Obelisk simulation],
        location: [#box(baseline: 30%, image(height: 1.5em, "images/PRACE.png"))],
        description: [#v(-1em) Radiation-hydrodynamical cosmological simulation following the assembly of a proto-cluster. #SI(50, "MCPU.hr") obtained (Europe wide call, PI: M.~Trebitsch).]
    ),
    ..entrynohl(
        date: [2018--20],
        title: [CINES computational time allocation],
        location: [#box(baseline: 30%, image(height: 1.5em, "images/cines.png"))],
        description: [#v(-.8em)Co-I of a #SI(2, "MCPU.hr") subproject, #SI(25, "MCPU.hr") obtained (France national call, PI: M.~Volonteri).
        Investigation on the role of cosmological accretion on angular momentum accretion.
      ]
    ),
)
#set page(margin: 1cm)

= Awards and recognitions
#entryGroup(
    ..entry(
        date: [2024-26],
        title: [eSSENCE grant ($1 thin 100 thin 000 "kr" approx 95 thin 000 thin €$)],
        location: [Lund University, Sweden],
        description: [Research grant for the project: "Galaxy formation in the exascale era".]
    ),
    ..entry(
        date: [2024-26],
        title: [Fysiografen grant ($110 thin 000 "kr" approx 9 thin 500 thin €$)],
        location: [Lund University, Sweden],
        description: [Research grant for the project: "The formation of disk, from cosmic dawn to cosmic noon".]
    ),
    ..entry(
        date: [2023-25],
        title: [Fysiografen grant ($140 thin 000 "kr" approx  2 thin 000 thin €$)],
        location: [Lund University, Sweden],
        description: [Research grant for the project: "The role of environment in driving galaxy spin".]
    ),
    ..entry(
        date: [2018],
        title: [NumFOCUS New Contributor Award],
        location: [],
        description: [In recognition of my contributions to the yt project, the most widely-used Python package for analysing simulations.]
    ),
    ..entrynohl(
        date: [2016--19],
        title: [*ILP fellowship* ($5000 thin €$ per annum)],
        location: [],
        description: none
    ),
    ..entrynohl(
        date: [2012--19],
        title: [*ENS scholarship \& ENS doctoral fellowship*, prestigious full stipends awarded nationwide to 20 fellows.],
        location: [],
        description: []
    ),
)

= Responsibilities

#entryGroup(
    ..entryDivider()[International collaborations & code development for open-science],
    ..entry(
        date: [2023--now],
        title: [ARRAKIHS mission],
        location: [],
        description: [
          European Space Agency (ESA) space mission to shed light on the nature of dark matter, to be launched in 2030. Co-I of the Simulation Work Package to interpret the data.
        ]
    ),
    ..entry(
      date: [2023--now],
      title: ['Agora' collaboration],
      location: [],
      description: [
          Code comparison project aimed at finding which galaxy properties are robust predictions from the different models.
      ],
    ),
    //..entryDivider()[Code development for open-science],
    ..entry(
        date: [2022--now],
        title: ['Ginea' collaboration],
        location: [France],
        description: [Collaboration to develop the next-generation cosmological simulation code (Dyablo, to supersede Ramses). Personal contributions include key insight into input/output formats and coupling with post-processing tools.]
    ),
    // ..entrynohl(
    //     date: [2019--now],
    //     title: [Developer of the open-source packages Pynbody and Tangos to analyse cosmological simulations.],
    //     location: [],
    //     description: none
    // ),
    ..entrynohl(
        date: [2019--24],
        title: [Member of ERC GMGalaxies (2019--2022, PI: Pontzen).],
        location: [],
        description: none,
    ),
    ..entrynohl(
        date: [2016--24],
        title: [Member of ANR Spine (2016--2017, PI: Pichon) and SEGAL (2019-2024, PI: Pichon).],
        location: [],
        description: none,
    ),
    ..entrynohl(
        date: [2017--now],
        title: [*yt team member*, in charge of support of the Ramses code.],
        location: [],
        description: [yt is now the most widely used library to analyse astrophysical simulations. Personal contributions include support for the Ramses code, significant I/O performance improvements ($times 100$ faster for Ramses), community support.]
    ),

    ..entryDivider()[Community service],
    ..entry(
        date: [2022--now],
        title: [Member of the EAS Advisory Committee on Sustainability],
        location: [],
        description: [The European Astronomical Society (EAS) Sustainability Advisory Committee aims to investigate, communicate, and make recommendations to the Council on sustainability matters related to astronomy and astrophysics.]
    ),
    ..entry(
        date: [2020--now
        
        ~],
        title: [Reviewer for Astronomy and Astrophysics, Monthly Notices of the Royal Astronomical Society, Scipy's conference proceedings],
        location: [],
        description: none
    ),
    ..entrynohl(
        date: [2016--21],
        title: [Organizer of IAP pre-seminar and the 'Extragalactic Journal Club' ],
        location: [IAP, Paris, France & UCL, London, UK],
        description: []
    ),
)
#v(-2em)
#entryGroup(
    ..entryDivider()[Teaching and supervision],
    ..entry(
        date: [2020--24],
        title: [Master's student supervisions],
        location: [],
        description: [Supervision of 8 Master's students. The work of the students in bold led to a submitted paper:
        T.~Chérel (Lund, Master 2, 25--26);
        E.~Larsson (Lund, Master 2, 24--25);
        Z.~Khurij (Lund, Master 2, 24--25);
        A.~Storck (Lund, Master 2, 23--24);
        A.-M.~Söderman (Lund, Master, 23--24);
        *Z.~Kocjan* (UCL, MSc, 21--23);
        J.~Warbrick (UCL, MSci, 20--21);
        *E.~Pharabod* (Polytechnique, France, Master 2, 20--21).]
    ),
    ..entry(
        date: [2016--19],
        title: [Teaching Assistant],
        location: [Sorbonne Université, Paris, France],
        description: [Courses included: concept and methods of Physics at B.Sc. level (192 hours). Graded all written work, oral and final written exams and assisted with labs.]
    ),
)


= Outreach activities
#entryGroup(
  ..entry(
        date: [2019--now],
        title: [Outreach presentations *in high-schools, museums, for the general public, for open house days.*],
        location: [],
        description: [
          // In high schools (6 classes, _Låna en Forskare_, Sweden, children aged 11-17), at the Science Museum Lates (Science Museum, London, UK, general public, $tilde 200$ visitors), Preligens (tech company in Paris, France, $tilde 70$ attendees), UCL Diploma Club (science enthusiasts, UCL, London UK, $tilde 50$ attendees).
        ]
    ),
)
#v(-2em)
#entryGroup(
    ..entry(
        date: [2020--22],
        title: [Host and co-founder of the “Astronomy on Tap” London satellite],
        location: [],
        description: [Fortnightly general public online presentations (#link("https://www.youtube.com/channel/UCAbbb3jRWXrv-5Wjhd_OFuA")[online] due to the pandemic, more than 4,600 views). Awarded £1,000 by UCL Astronomy department to carry our activities.]
    ),
    ..entrynohl(
        date: [2020],
        title: [Scientific expertise to translate the general public book 'A History of the Universe in 100 stars'.],
        location: [],
        description: [
          //Translation: A. Gerstner, author: F. Freistetter.
        ]
    ),
    ..entry(
        date: [2019],
        title: [Speaker at the "Pint of Science" festival],
        location: [Paris, France],
        description: none
    ),
    ..entry(
        date: [2017--19],
        title: [_Journée de la Science_ (Open House days)],
        location: [Sorbonne Université, France],
        description: [Presented activities of the IAP, set up and performed hand-based experiments.]
    ),
)

= Visiting programs, schools and conferences

#include "conferences.typ"

#pagebreak()

= Publication list

#show highlight: it => text(fill: pblue)[*#it.body*]
#import "pub.include.typ": *
#publist((author) => text(fill: pblue)[*#author*])

