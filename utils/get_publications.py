import argparse
import dataclasses
import re
import urllib
from datetime import date
from pathlib import Path
from textwrap import dedent, indent
from typing import List, Optional, Sequence

import ads
from jinja2 import Environment
from jinja2.utils import select_autoescape

root = Path(__file__).parent.parent

_SKIP = -999
REPLACEMENTS = {
    "Monthly Notices of the Royal Astronomical Society": "MNRAS",
    "Astronomy and Astrophysics": r"A\&A",
    "Zenodo": _SKIP,
    "arXiv e-prints": "submitted",
}

# Additional replacements for CV format
CV_REPLACEMENTS = {
    "Zenodo": _SKIP,
    "arXiv e-prints": "submitted",
}

# Typst/LaTeX templates
TEMPLATE = dict(
    latex=dedent(
        r"""
        \noindent\
        {prefix}
        \textbf{{"{title}"}},
        {authors}, \emph{{{publication_status}}}{pub_details} ({year}).%,
        % \myhref{{{arxiv_link}}}{{{arxiv_link}}}
    """
    ),
    typst_arxiv=dedent(
        """\
        + {prefix} "*{title}*",
          {authors}, _#link("{arxiv_link}")[{publication_status}{pub_details}]_, ({year}).\
    """
    ),
    typst=dedent(
        """\
        + {prefix} "*{title}*",
          {authors}, _{publication_status}{pub_details}_, ({year}).\
    """
    ),
)


def replace(key: str, format: str = "html") -> str:
    dummy = object()

    # Use CV-specific replacements for LaTeX/Typst formats
    replacements = CV_REPLACEMENTS if format in ["latex", "typst"] else REPLACEMENTS
    val = replacements.get(key, dummy)

    if val is dummy:
        val = key.replace("_", r"\_").replace("&", r"\&").replace("^", r"\^").replace("#", r"\#")

    return str(val)


def get_arxiv(paper: ads.search.Article) -> str:
    arxiv = paper.arxivid
    if arxiv is None:
        for tmp in paper.identifier:
            if tmp.startswith("arXiv"):
                _, arxiv = tmp.split("arXiv:")

    if arxiv is None:
        arxiv = ""
    return arxiv


def get_papers(author: str, year_range: tuple[int, int]) -> List[ads.search.Article]:
    query = f"(author:'{author}') collection:astronomy"
    if year_range:
        query += f" year:[{year_range[0]} TO {year_range[1]}]"
    papers = ads.SearchQuery(
        q=query,
        fl=[
            "title",
            "citation_count",
            "author",
            "id",
            "year",
            "arxivid",
            "pub",
            "identifier",
            "volume",
            "issue",
            "page",
            "page_count",
            "doi",
        ],
        sort="date",
        max_pages=10,
    )

    return list(sorted(papers, key=lambda p: (p.year, get_arxiv(p)), reverse=True))


@dataclasses.dataclass(frozen=True)
class Author:
    first: str
    last: str


@dataclasses.dataclass(frozen=True)
class PaperInfo:
    url: str
    authors: List[Author]
    title: str
    journal: str
    year: int


@dataclasses.dataclass(frozen=True)
class StatsResult:
    first_author: int
    contributor: int
    citations: int
    h_index: int
    papers: List[PaperInfo]
    paper_list: str = ""  # For formatted output (LaTeX/Typst)
    submitted_list: str = ""  # For formatted output (LaTeX/Typst)
    npublished: int = 0
    nsubmitted: int = 0


def normalize_author(author: str, main_author: str = "", format: str = "") -> Author:
    """Normalize author name to Author dataclass"""
    try:
        last, first = (_.strip() for _ in author.split(","))
    except ValueError:
        last, first = author, ""
    first = re.sub(r"([A-Za-z])[A-Za-z]*(?!\.)", r"\1.", first)
    return Author(first=first, last=last)


def normalize_author_for_format(author: str, main_author: str, format: str) -> str:
    """Format author name with highlighting for main author"""
    auth = author.split(",")[0]
    if auth == main_author:
        if format == "latex":
            auth = f"\\hl{{{main_author}}}"
        elif format == "typst":
            auth = f"#hl_author[{main_author}]"
    return auth


def process_papers(papers: List[ads.search.Article], main_author: Author, format: str = "html") -> StatsResult:
    tot_citations = 0

    max_pos = 0
    for paper in papers:
        for i, author in enumerate(paper.author):
            if normalize_author(author) == main_author:
                max_pos = max(max_pos, i + 1)
                break

    if format in ["latex", "typst"]:
        max_pos = 1000  # For CV format, include more authors
    else:
        max_pos = min(max_pos, 10)  # For HTML format, limit authors

    all_papers: List[PaperInfo] = []
    submitted_list, paper_list = [], []
    stats = []
    year = None
    npublished, nsubmitted = 0, 0

    for paper in papers:
        if year is None or year != paper.year:
            year = paper.year

        tot_citations += paper.citation_count if paper.citation_count else 0

        # Process authors for HTML format
        html_authors = [normalize_author(paper.author[0])]
        iend = min(max_pos + 1, len(paper.author))
        for i, author in enumerate(paper.author[1 : iend - 1]):
            html_authors.append(normalize_author(author))
        if len(paper.author) > max_pos:
            html_authors.append(Author(first="", last="et al"))
        elif len(paper.author) > 1 and iend > 1:
            html_authors.append(normalize_author(paper.author[iend - 1]))

        # Process authors for LaTeX/Typst format
        if format in ["latex", "typst"]:
            formatted_authors = normalize_author_for_format(paper.author[0], main_author.last, format)
            for i, author in enumerate(paper.author[1 : iend - 1]):
                formatted_authors += ", " + normalize_author_for_format(author, main_author.last, format)
            if len(paper.author) > 1:
                if len(paper.author) > max_pos:
                    formatted_authors += " et al"
                else:
                    formatted_authors += r"~\& " + normalize_author_for_format(
                        paper.author[iend - 1], main_author.last, format
                    )

        arxiv = get_arxiv(paper)
        publication_status = replace(paper.pub, format)

        if publication_status == _SKIP:
            continue

        # Count publications
        if any(normalize_author(_) == main_author for _ in paper.author[:2]):
            if publication_status != "submitted":
                npublished += 1
            else:
                nsubmitted += 1

        title = (
            paper.title[0]
            .replace("&gt;", ">")
            .replace("_", r"\_")
            .replace("&", r"\&")
            .replace("^", r"\^")
            .replace("#", r"\#")
        )

        # Create PaperInfo for HTML format
        all_papers.append(
            PaperInfo(
                year=year,
                url=f"https://arxiv.org/abs/{arxiv}" if arxiv else "",
                authors=html_authors,
                title=title,
                journal=paper.pub,
            )
        )

        # Create formatted entries for LaTeX/Typst
        if format in ["latex", "typst"]:
            prefix = ""

            # Determine publication details
            pub_details = ""
            if hasattr(paper, "volume") and paper.volume:
                pub_details += f", {paper.volume}"
            if hasattr(paper, "page") and paper.page:
                if isinstance(paper.page, list):
                    pub_details += f", {paper.page[0]}"
                else:
                    pub_details += f", {paper.page}"

            match (format, arxiv):
                case ("latex", _):
                    template = TEMPLATE["latex"]
                case ("typst", ""):
                    template = TEMPLATE["typst"]
                case ("typst", e) if e != "":
                    template = TEMPLATE["typst_arxiv"]
                case _:
                    raise ValueError(f"Unknown format/arxiv combination: {format}/{arxiv}")

            formatted_entry = template.format(
                prefix=prefix,
                title=title,
                authors=formatted_authors,
                publication_status=publication_status,
                year=year,
                arxiv=arxiv,
                arxiv_link=f"https://arxiv.org/abs/{arxiv}" if arxiv else "",
                pub_details=pub_details,
            )

            if publication_status == "submitted" or "submitted" in publication_status:
                submitted_list.append(formatted_entry)
            else:
                paper_list.append(formatted_entry)

        stats.append(paper.citation_count if paper.citation_count else 0)

    # Compute sum of citations
    citations = sum(stats)

    # Compute h-index
    stats = sorted(stats, reverse=True)
    h_index = 0
    for s in stats:
        if s > h_index:
            h_index += 1
        else:
            break

    # Compute first/co-author and contribution
    first_author = sum(
        1
        for p in papers
        if any(normalize_author(_) == main_author for _ in p.author[:2]) and replace(p.pub, format) is not _SKIP
    )
    contributor = sum(
        1
        for p in papers
        if (not any(normalize_author(_) == main_author for _ in p.author[:2])) and replace(p.pub, format) is not _SKIP
    )

    # Join formatted lists
    sep = "\n"

    return StatsResult(
        first_author=first_author,
        contributor=contributor,
        citations=citations,
        h_index=h_index,
        papers=all_papers,
        submitted_list=sep.join(submitted_list),
        paper_list=sep.join(paper_list),
        npublished=npublished,
        nsubmitted=nsubmitted,
    )


def highlight(s, format: str) -> str:
    if format == "latex":
        return f"\\hl{{{s}}}"
    elif format == "typst":
        return f"#highlight[{s}]"
    else:
        raise ValueError(f"Unknown format {format}")


def emph(s, format: str) -> str:
    if format == "latex":
        return f"\\emph{{{s}}}"
    elif format == "typst":
        return f"_{s}_"
    else:
        raise ValueError(f"Unknown format {format}")


def href(url: str, text: str, format: str) -> str:
    if format == "latex":
        return f"\\href{{{url}}}{{{text}}}"
    elif format == "typst":
        return f'#link("{url}")[{text}]'
    else:
        raise ValueError(f"Unknown format {format}")


def format_results(stats: StatsResult, author: str, format: str = "html") -> str:
    if format == "html":
        # HTML format using Jinja2 template
        last_check = date.today().strftime(r"%d %B %Y")
        author_str = urllib.parse.quote(author)

        env = Environment(autoescape=select_autoescape())

        with open(root / "utils" / "publications.template.html", "r") as f:
            template = env.from_string(f.read())

        return template.render(stats=stats, last_check=last_check, author=author_str, highlight_author="Cadiou")

    elif format in ["latex", "typst"]:
        # LaTeX/Typst format using direct string formatting
        last_check = date.today().strftime(r"\nth{%d} %B %Y" if format == "latex" else "#nth({%d}) %B %Y")

        author_str = urllib.parse.quote(author)
        AA_str = r"A\&A" if format == "latex" else "A&A"

        if stats.nsubmitted == 0:
            published = rf"all published in MNRAS and {AA_str}"
        else:
            published = f"{highlight(stats.npublished, format)} already published in MNRAS and {AA_str}"

        url = (
            "https://ui.adsabs.harvard.edu/search/filter_database_fq_database=AND&filter_database_fq_database=database%3A%22astronomy%22"
            "&fq=%7B!type%3Daqp%20v%3D%24fq_database%7D&fq_database=(database%3A%22astronomy%22)&p_=0&"
            f"q=((author%3A%22{author_str}%22))&sort=date%20desc%2C%20bibcode%20desc"
        )

        if format == "latex":
            url_txt = r"{\setul{1pt}{.4pt}\setulcolor{red}\ul{source: NASA/ADS}}."
            sub_sec = lambda name: rf"\quad\textbf{{\large {name}}}\quad\hrulefill\n\n"
        elif format == "typst":
            url_txt = "source: NASA/ADS."
            sub_sec = lambda name: f"== {name}\n\n"

        content = (
            dedent(
                rf"""
                I have submitted {highlight(stats.first_author, format)} articles as lead or co-lead author ({published}).
                I also contributed to {highlight(stats.contributor, format)} other articles.
                My papers have been cited {highlight(stats.citations, format)} times ({emph("h", format)}-index of {stats.h_index} as
                of {last_check}), {href(url, url_txt, format)}
                """
            )
            + "\n\n"
            + ((sub_sec("Submitted articles") + stats.submitted_list) if len(stats.submitted_list) > 0 else "")
            + "\n\n"
            + sub_sec("Published articles")
            + stats.paper_list
        )

        if format == "typst":
            # Wrap everything into a variable
            content = (
                '#import "@preview/nth:0.2.0": nth\n'
                + "#let publist = (hl_author) => [\n"
                + indent(content, "    ")
                + "\n]\n"
            )
            content += """
#if sys.inputs.keys().len() == 0 [
  #import "cv.typ": *
  #show highlight: it => text(fill: pblue)[*#it.body*]
  #set par(justify: true)
  #show link: underline

  = Publication list
  #publist(author => text(fill: pblue)[*#author*])
]
"""
        return content

    else:
        raise ValueError(f"Unknown format: {format}")


def cleanup_content(content: str) -> str:
    """Remove trailing whitespaces and ensure file ends with a newline"""
    # Split into lines, strip trailing whitespace from each line, rejoin
    lines = [line.rstrip() for line in content.splitlines()]

    # Join lines back together and ensure single trailing newline
    cleaned_content = "\n".join(lines)

    # Ensure file ends with exactly one newline
    if not cleaned_content.endswith("\n"):
        cleaned_content += "\n"

    return cleaned_content


def main(argv: Optional[Sequence]) -> int:
    parser = argparse.ArgumentParser(description="Get the list of papers from ADS")
    parser.add_argument(
        "-o",
        "--output",
        type=str,
        default=None,
        help="Output file path (default: publications/index.html for html, papers.tex for latex, papers.typ for typst)",
    )
    parser.add_argument("-a", "--author", type=str, default="Cadiou, C")
    parser.add_argument(
        "-y", "--year-range", type=int, nargs=2, default=None, help="Year range for publications (e.g., 2020 2024)"
    )
    parser.add_argument(
        "-f",
        "--format",
        type=str,
        choices=["html", "latex", "typst"],
        default="html",
        help="Output format (html, latex, or typst)",
    )

    args = parser.parse_args(argv)

    # Set default output path based on format
    if args.output is None:
        if args.format == "html":
            args.output = root / "publications" / "index.html"
        elif args.format == "latex":
            args.output = "papers.tex"
        elif args.format == "typst":
            args.output = "papers.typ"

    papers = get_papers(args.author, args.year_range)
    main_author = normalize_author(args.author)
    res = process_papers(papers, main_author, format=args.format)
    content = format_results(res, args.author, format=args.format)

    # Clean up content: remove trailing whitespaces and ensure newline at end
    cleaned_content = cleanup_content(content)

    out = Path(args.output)
    if not out.parent.exists():
        out.parent.mkdir(parents=True)

    out.write_text(cleaned_content)

    return 0


if __name__ == "__main__":
    import sys

    sys.exit(main(sys.argv[1:]))
