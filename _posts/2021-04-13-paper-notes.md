---
title: Notes on papers
---

This is a collection of notes on writing a paper.
Some of these may apply more generally to writing but no promises.
The target for this is an academic paper written in LaTeX.

Of course, this is not all my own advice but things I have learned and picked up from friends and colleagues.
Many thanks.

### Write one line per sentence (or one sentence per line)

This makes it easier to skim through a document and see particularly long sentences.
These can often be broken down into multiple sentences for a clearer message.
If there are long links in the way then maybe try detexifying the source first.

### Have a self-referential layout

The structure of the abstract should reflect the structure of the sections in the paper.
This is similar with the introduction but it may add more context, this follows the general to specific principle.
The conclusion may be a similar style again but in reverse, specific to general.

### Link the introduction to the layout

The introduction is a key part of the paper that people will read first.
This shouldn't be boring or too lengthy so give the reader a guide to the paper.
It doesn't need a pointer paragraph at the end of it to say the section headings again.
Instead, point out your key contributions with reference to the sections, much more interesting and useful.

### Use booktabs for tables

That is all.

### Use a non-breaking space between text and cite/ref

In LaTeX: `~`, e.g. `some smart paper~\cite{smarts}`.

### Ensure figures are referenced in the text and pull their weight

If a figure isn't referenced then when should the reader look at it?
The reference should tie the figure into the discussion and so it should be relevant and beneficial to that discussion.
Figures also take space in the paper so plan to include only the most pertinent.
Take care as besides distracting the user they can be confusing and detrimental if not clearly thought out or explained.

### Consistent citations

All the citations in the bibliography should be in a consistent style.
For instance, all first names in full rather than initials, conference proceedings in common format with common fields filled out where possible.

### Captions above tables and below figures

[See here for a reference](https://tex.stackexchange.com/questions/3243/why-should-a-table-caption-be-placed-above-the-table).

### Use `\Description` for improving accessibility

This is more than a caption and should describe what happens in the figure, it is _describing_ the figure.

### Some other useful advice

- [ACM best practices](https://www.acm.org/publications/taps/latex-best-practices)
- [Capra style guide](https://capra.cs.cornell.edu/styleguide/)
