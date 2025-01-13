import argparse
import dataclasses
from datetime import date
from textwrap import dedent, indent
from typing import Any, List, Optional, Sequence
import urllib
from itertools import chain

import ads

TEMPLATE = dict(
    latex=dedent(
        r"""
        \noindent\
        {prefix}
        \textbf{{“{title}”}},
        {authors}, \emph{{{publication_status}}}{pub_details} ({year}).%,
        % \myhref{{{arxiv_link}}}{{{arxiv_link}}}
    """
    ),
    typst=dedent(
        """\
        + {prefix} “*{title}*”,
          {authors}, _{publication_status}{pub_details}_, ({year}).\
    """
    ),
)


_SKIP = -999
REPLACEMENTS = {
    # "Monthly Notices of the Royal Astronomical Society": "MNRAS",
    # "Astronomy and Astrophysics": "A\&A",
    "Zenodo": _SKIP,
    "arXiv e-prints": "submitted to Monthly Notices of the Royal Astronomical Society",
}


def replace(key: str) -> str:
    dummy = object()
    val = REPLACEMENTS.get(key, dummy)

    if val is dummy:
        val = (
            key.replace("_", r"\_")
            .replace("&", r"\&")
            .replace("^", r"\^")
            .replace("#", r"\#")
        )

    return val


def get_arxiv(paper: ads.search.Article) -> str:
    arxiv = paper.arxivid
    if arxiv is None:
        for tmp in paper.identifier:
            if tmp.startswith("arXiv"):
                _, arxiv = tmp.split("arXiv:")

    if arxiv is None:
        arxiv = ""
    return arxiv


def get_papers(author: str) -> List[ads.search.Article]:
    papers = ads.SearchQuery(
        q=f"(author:'{author}') collection:astronomy",
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
class StatsResult:
    first_author: int
    contributor: int
    citations: int
    h_index: int
    paper_list: str
    submitted_list: str
    npublished: int
    nsubmitted: int


def normalize_author(author: str, main_author: str, format: str) -> str:
    auth = author.split(",")[0]
    if auth == main_author:
        if format == "latex":
            auth = f"\\hl{{{main_author}}}"
        elif format == "typst":
            auth = f"#hl_author[{main_author}]"
    return auth


def process_papers(
    papers: List[ads.search.Article], main_author: str, *, format: str
) -> StatsResult:
    tot_citations = 0

    max_pos = 0
    for paper in papers:
        for i, author in enumerate(paper.author):
            if author.startswith(main_author):
                max_pos = max(max_pos, i + 1)
                break

    max_pos = 1000  # min(max_pos, 10)

    submitted_list, paper_list = [], []
    stats = []
    year = None
    new_year = False
    npublished, nsubmitted = 0, 0
    for paper in papers:
        if year is None or year != paper.year:
            year = paper.year
            new_year = True

        tot_citations += paper.citation_count if paper.citation_count else 0

        authors = normalize_author(paper.author[0], main_author, format)
        iend = min(max_pos + 1, len(paper.author))
        for i, author in enumerate(paper.author[1 : iend - 1]):
            authors += ", " + normalize_author(author, main_author, format)
        if len(paper.author) > 1:
            if len(paper.author) > max_pos:
                authors += " et al"
            else:
                authors += r"~\& " + normalize_author(
                    paper.author[iend - 1], main_author, format
                )

        arxiv = get_arxiv(paper)

        publication_status = replace(paper.pub)
        if publication_status == _SKIP:
            continue

        title: str = (
            paper.title[0]
            .replace("&gt;", ">")
            .replace("_", r"\_")
            .replace("&", r"\&")
            .replace("^", r"\^")
            .replace("#", r"\#")
        )
        prefix = ""
        if not publication_status.startswith("submitted"):
            publication_status = f"in {publication_status}"

        if publication_status.startswith("submitted"):
            the_list = submitted_list
        else:
            the_list = paper_list

        if any(_.startswith(main_author) for _ in paper.author[:2]):
            if not publication_status.startswith("submitted"):
                npublished += 1
            else:
                nsubmitted += 1

        if not publication_status.startswith("submitted"):
            try:
                start_page = int(paper.page[0])
            except ValueError:
                start_page = paper.page[0]
            except TypeError:
                start_page = None
            if paper.page_count is not None and isinstance(start_page, int):
                page = f"{start_page}-{start_page + paper.page_count}"
            else:
                page = start_page or None
            details = (
                [paper.volume] if paper.volume else [],
                [paper.issue] if paper.issue else [],
                [page] if page else [],
            )
            # This happens for advanced publications
            if any(details):
                pub_details = ", " + ", ".join(chain(*details))
            elif paper.doi:
                pub_details = f", doi: {paper.doi[0]}"
            else:
                pub_details = ""
        else:
            pub_details = ""

        the_list.append(
            TEMPLATE[format].format(
                prefix=prefix,
                year=year,
                title=title,
                authors=authors,
                publication_status=publication_status,
                arxiv=arxiv,
                arxiv_link=f"https://arxiv.org/abs/{arxiv}",
                pub_details=pub_details,
            )
        )

        new_year = False

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
        if any(_.startswith(main_author) for _ in p.author[:2])
        and replace(p.pub) is not _SKIP
    )
    contributor = sum(
        1
        for p in papers
        if (not any(_.startswith(main_author) for _ in p.author[:2]))
        and replace(p.pub) is not _SKIP
    )

    # Published
    sep = "\n"

    return StatsResult(
        first_author=first_author,
        contributor=contributor,
        citations=citations,
        h_index=h_index,
        submitted_list=sep.join(submitted_list),
        paper_list=sep.join(paper_list),
        npublished=npublished,
        nsubmitted=nsubmitted,
    )


def highlight(s: Any, format: str) -> str:
    if format == "latex":
        return f"\\hl{{{s}}}"
    elif format == "typst":
        return f"#highlight[{s}]"
    else:
        raise ValueError(f"Unknown format {format}")


def emph(s: Any, format: str) -> str:
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


def format_results(stats: StatsResult, author: str, *, format: str) -> str:
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
        + (
            (sub_sec("Submitted articles") + stats.submitted_list)
            if len(stats.submitted_list) > 0
            else ""
        )
        + "\n\n"
        + sub_sec("Published articles")
        + stats.paper_list
    )

    if format == "typst":
        # Wrap everything into a variable
        content = (
            "#import \"@preview/nth:0.2.0\": nth\n" +
            "#let publist = (hl_author) => [\n" +
            indent(content, "    ") +
            "\n]\n"
        )
    return content


def main(argv: Optional[Sequence]) -> int:
    parser = argparse.ArgumentParser(description="Get the list of papers from ADS")
    parser.add_argument("-o", "--output", type=str, default="papers.tex")
    parser.add_argument("-a", "--author", type=str, default="Cadiou, C")
    parser.add_argument(
        "-f", "--format", type=str, choices=TEMPLATE.keys(), default="latex"
    )

    args = parser.parse_args(argv)

    papers = get_papers(args.author)
    main_author = normalize_author(args.author, "Noone", args.format)
    res = process_papers(papers, main_author, format=args.format)
    content = format_results(res, args.author, format=args.format)

    with open(args.output, "w") as f:
        f.write(content)

    return 0


if __name__ == "__main__":
    import sys

    sys.exit(main(sys.argv[1:]))
