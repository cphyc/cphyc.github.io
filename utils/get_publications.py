import argparse
import dataclasses
from datetime import date
from textwrap import dedent, indent
from typing import List, Optional, Sequence
import urllib
import re
from pathlib import Path

import ads
from jinja2 import Environment
from jinja2.utils import select_autoescape

root = Path(__file__).parent.parent

_SKIP = -999
REPLACEMENTS = {
    "Monthly Notices of the Royal Astronomical Society": "MNRAS",
    "Astronomy and Astrophysics": "A\&A",
    "Zenodo": _SKIP,
    "arXiv e-prints": "submitted",
}


def replace(key: str) -> str:
    dummy = object()
    val = REPLACEMENTS.get(key, dummy)

    if val is dummy:
        val = (
            key.replace("_", "\_")
            .replace("&", "\&")
            .replace("^", "\^")
            .replace("#", "\#")
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
    authors: list[Author]
    title: str
    journal: str
    year: int

@dataclasses.dataclass(frozen=True)
class StatsResult:
    first_author: int
    contributor: int
    citations: int
    h_index: int
    papers: list[PaperInfo]
    npublished: int
    nsubmitted: int

def normalize_author(author: str) -> Author:
    try:
        last, first = (_.strip() for _ in author.split(","))
    except ValueError:
        last, first = author, ""
    first = re.sub(r"([A-Za-z])[A-Za-z]*(?!\.)", r"\1.", first)
    return Author(first=first, last=last)


def process_papers(papers: List[ads.search.Article], main_author: Author) -> StatsResult:
    tot_citations = 0

    max_pos = 0
    for paper in papers:
        for i, author in enumerate(paper.author):
            if normalize_author(author) == main_author:
                max_pos = max(max_pos, i + 1)
                break

    max_pos = min(max_pos, 10)

    all_papers: list[PaperInfo] = []
    stats = []
    year = None
    npublished, nsubmitted = 0, 0
    for paper in papers:
        if year is None or year != paper.year:
            year = paper.year

        tot_citations += paper.citation_count

        authors = [normalize_author(paper.author[0])]
        iend = min(max_pos + 1, len(paper.author))
        for i, author in enumerate(paper.author[1 : iend - 1]):
            authors.append(normalize_author(author))
        if len(paper.author) > max_pos:
            authors.append(Author(first="", last="et al"))

        arxiv = get_arxiv(paper)

        publication_status = replace(paper.pub)
        if publication_status == _SKIP:
            continue

        if any(normalize_author(_) == main_author for _ in paper.author[:2]):
            if publication_status != "submitted":
                npublished += 1
            else:
                nsubmitted += 1

        title = (
            paper.title[0]
            .replace("&gt;", ">")
            .replace("_", "\_")
            .replace("&", "\&")
            .replace("^", "\^")
            .replace("#", "\#")
        )

        all_papers.append(
            PaperInfo(
                year=year,
                url=f"https://arxiv.org/abs/{arxiv}",
                authors=authors,
                title=title,
                journal=paper.pub,
            )
        )

        stats.append(paper.citation_count)

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
        if any(normalize_author(_) == main_author for _ in p.author[:2])
        and replace(p.pub) is not _SKIP
    )
    contributor = sum(
        1
        for p in papers
        if (not any(normalize_author(_) == main_author for _ in p.author[:2]))
        and replace(p.pub) is not _SKIP
    )

    return StatsResult(
        first_author=first_author,
        contributor=contributor,
        citations=citations,
        h_index=h_index,
        papers=all_papers,
        npublished=npublished,
        nsubmitted=nsubmitted,
    )


def format_results(stats: StatsResult, author: str) -> str:
    last_check = date.today().strftime(r"%d %B %Y")

    author_str = urllib.parse.quote(author)

    env = Environment(autoescape=select_autoescape())

    with open("utils/publications.template.html", "r") as f:
        template = env.from_string(f.read())

    return template.render(
        stats=stats,
        last_check=last_check,
        author=author_str,
        highlight_author="Cadiou"
    )



def main(argv: Optional[Sequence]) -> int:
    parser = argparse.ArgumentParser(description="Get the list of papers from ADS")
    parser.add_argument("-o", "--output", type=str, default=root / "publications" / "index.html")
    parser.add_argument("-a", "--author", type=str, default="Cadiou, C")

    args = parser.parse_args(argv)

    papers = get_papers(args.author)
    main_author = normalize_author(args.author)
    res = process_papers(papers, main_author)
    content = format_results(res, args.author)

    out = Path(args.output)
    if not out.parent.exists():
        out.parent.mkdir()

    out.write_text(content)

    return 0


if __name__ == "__main__":
    import sys

    sys.exit(main(sys.argv[1:]))
