% -- Encoding UTF-8 without BOM

\ProvidesClass{cv-style}[2015/02/27 CV class]
\NeedsTeXFormat{LaTeX2e}

\DeclareOption{espanol}{\def\@cv@espanol{}}
\DeclareOption{french}{\def\@cv@french{}}
\DeclareOption{print}{\def\@cv@print{}}
\DeclareOption*{%
  \PassOptionsToClass{\CurrentOption}{article}%
}
\ProcessOptions\relax
\LoadClass{article}

%----------------------------------------------------------------------------------------
% Colors %
%----------------------------------------------------------------------------------------

\RequirePackage{xcolor}

\definecolor{white}{RGB}{255,255,255}

\definecolor{darkgray}{HTML}{111100}
\definecolor{gray}{HTML}{4D4D4D}
\definecolor{lightgray}{HTML}{999999}
\definecolor{verylightgray}{HTML}{eaeaea}

\definecolor{blue}{HTML}{66D9EE}
\definecolor{red}{HTML}{FA2772}
\definecolor{darkred}{HTML}{900335}
\definecolor{orange}{HTML}{FE9720}
\definecolor{green}{HTML}{A7E22E}
\definecolor{purple}{HTML}{9358FE}
\definecolor{aquamarine}{HTML}{36AF90}
\definecolor{titlecolor}{HTML}{9a424c}

\definecolor{date}{HTML}{A4A4A4}

\ifdefined\@cv@print
  \colorlet{blue}{gray}
  \colorlet{red}{gray}
  \colorlet{orange}{gray}
  \colorlet{green}{gray}
  \colorlet{purple}{gray}
  \colorlet{aquamarine}{gray}
  \colorlet{fillheader}{white}
  \colorlet{header}{gray}
\else
  \colorlet{blue}{titlecolor}
  \colorlet{red}{titlecolor}
  \colorlet{orange}{titlecolor}
  \colorlet{green}{titlecolor}
  \colorlet{purple}{titlecolor}
  \colorlet{aquamarine}{titlecolor}
  \colorlet{fillheader}{titlecolor}
  \colorlet{header}{white}
\fi
\colorlet{textcolor}{gray}
\colorlet{headercolor}{gray}

%----------------------------------------------------------------------------------------
% Fonts %
%----------------------------------------------------------------------------------------

\RequirePackage[quiet]{fontspec}
\RequirePackage[math-style=TeX]{unicode-math}

\newfontfamily\bodyfont{Libertinus Serif}[Ligatures=TeX, Numbers=OldStyle]
\newfontfamily\bodyfontit{Libertinus Serif Italic}[Ligatures=TeX, Numbers=OldStyle]
\newfontfamily\thinfont{Libertinus Serif Display}[Ligatures=TeX, Numbers=OldStyle]
\newfontfamily\headingfont{Libertinus Serif Bold}[Ligatures=TeX, Numbers=OldStyle]

% \setmainfont{Libertinus Serif}
% \setsansfont{Libertinus Sans}
% \setmathfont{Libertinus Math}
% \setmonofont{Libertinus Mono}

\newcommand{\italica}[1]{%
    {\color{gray}\bodyfontit #1}%
}

%----------------------------------------------------------------------------------------
% Header %
%----------------------------------------------------------------------------------------

\RequirePackage{tikz}

\newcommand{\header}[3]{%
  \begin{tikzpicture}[remember picture,overlay]
    \node [rectangle, fill=fillheader, anchor=north, minimum width=\paperwidth, minimum height=3cm] (box) at (current page.north){};
    \node [anchor=center, minimum height=2.5cm] (centeredbox) at (box) {};
    \node [anchor=north] (name) at (centeredbox.north) {%
      \fontsize{40pt}{65pt}\color{header}%
      {\thinfont #1}{\bodyfont \ #2}
    };
    \node [anchor=south] (subline) at (centeredbox.south) {%
      \fontsize{20pt}{45pt}\color{header}%
      {\thinfont #3}
    };
  \end{tikzpicture}
  \vspace{2.1cm}
  \vspace{-2\parskip}
}

%----------------------------------------------------------------------------------------
%	Last updated command %
%----------------------------------------------------------------------------------------

\RequirePackage[absolute,overlay]{textpos}
\RequirePackage{polyglossia}

\newcommand{\sethyphenation}[3][]{%
  \sbox0{\begin{otherlanguage}[#1]{#2}
    \hyphenation{#3}\end{otherlanguage}}}
%\sethyphenation[<options>]{<language>}{<list of words separated by spaces>}

\ifdefined\@cv@french
  \setdefaultlanguage{french}
  \def\lastupdatedtext{Dernière mise à jour le}
\else
  \setdefaultlanguage[variant=british]{english}
  \def\lastupdatedtext{Last Updated on}
\fi

\setlength{\TPHorizModule}{0.01\paperwidth}
\setlength{\TPVertModule}{0.01\paperwidth}

\newcommand{\lastupdated}{
  \begin{textblock}{10}(11.3, 0.05)
    \raggedleft
    \fontsize{8pt}{10pt}\color{date}\thinfont 
    \lastupdatedtext{} \today
  \end{textblock}}

%----------------------------------------------------------------------------------------
% Structure %
%----------------------------------------------------------------------------------------
\RequirePackage{parskip}

\newcounter{colorCounter}
\def\@sectioncolor#1#2#3{%
  {%
    \color{red} #1#2#3%
  }%
  \stepcounter{colorCounter}%
}

\renewcommand{\section}[1]{
  {\par\vspace{\parskip}
  {%
    {%
      \LARGE\headingfont\color{headercolor}%
      \@sectioncolor #1%
      \nopagebreak%
    }
  }
  \par\vspace{\parskip}}
}

\renewcommand{\subsection}[2]{
  \par\vspace{.5\parskip}%
  \Large\headingfont\color{headercolor} #2%
  \par\vspace{.25\parskip}%
}

\newcommand{\jobtitle}[1]{%
    {\color{gray}\bodyfontit #1}%
}

\pagestyle{empty}

%----------------------------------------------------------------------------------------
% List environment %
%----------------------------------------------------------------------------------------
\RequirePackage{longtable}
\RequirePackage{ifmtarg}
\RequirePackage{makecell}
\newenvironment{entrylist}[1][3pt]{%
  \setlength{\tabcolsep}{#1}
  \begin{longtable}{@{\extracolsep{\fill}}ll}
}{%
  \end{longtable}
}
\renewcommand{\bfseries}{\headingfont\color{darkgray}}
\newcommand{\entry}[4]{%
  #1&\parbox[t]{12.8cm}{%
    \textbf{#2}%
    \hfill%
    {\footnotesize\addfontfeature{Color=lightgray} #3}\\%
    #4\vspace{\parsep}%
  }\\}
\newcommand{\paper}[4]{%
  \def\arxiv{#4}%
  \ifx\empty\arxiv
    ``#1'', #2, \emph{#3}.
  \else
  ``#1'', #2, \emph{#3}, #4.
  \fi
}
\newcommand{\entryshort}[3]{%
  #1&\parbox[t]{12.8cm}{%
    \textbf{#2}%
    \hfill%
    {\footnotesize\addfontfeature{Color=lightgray} #3}%
    \vspace{\parsep}
  }\\}
\newcommand{\entrynohl}[4]{%
  #1&\parbox[t]{12.8cm}{%
    #2%
    \hfill%
    {\footnotesize\addfontfeature{Color=lightgray} #3}\\%
    #4\vspace{\parsep}%
  }\\}
\newcommand{\entryshortnohl}[3]{%
  #1&\parbox[t]{12.8cm}{%
    {#2}%
    \hfill%
    {\footnotesize\addfontfeature{Color=lightgray} #3}%
    \vspace{\parsep}
  }\\}

%----------------------------------------------------------------------------------------
% Side block %
%----------------------------------------------------------------------------------------

\setlength{\TPHorizModule}{1cm}
\setlength{\TPVertModule}{1cm}
\newenvironment{aside}{%
  \let\oldsection\section
  \renewcommand{\section}[1]{
    \par\vspace{\baselineskip}{\Large\headingfont\color{headercolor} ##1}
    \vspace{.75\parskip}
  }
  % \begin{textblock}{3.6}(1, 2.87)
  \begin{textblock}{3.6}(1, 2.915)
  \begin{flushright}
  \obeycr
}{%
  \restorecr
  \end{flushright}
  \end{textblock}
  \let\section\oldsection
}

%----------------------------------------------------------------------------------------
% Other tweaks %
%----------------------------------------------------------------------------------------

\RequirePackage[
  paper=a4paper,
  %left=5.6cm,
  left=5.2cm,
  top=1cm,
  right=1cm,
  bottom=1cm,
  nohead,
  nofoot
]{geometry}
% \RequirePackage[
% linkcolor=red,
% colorlinks=true,
% hidelinks
% ]{hyperref}
