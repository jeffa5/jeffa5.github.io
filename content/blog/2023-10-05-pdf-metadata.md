---
title: Analysing PDF metadata on arXiv
draft: true
---

## The background

Metadata is commonly used for providing additional information in files that is typically also readable by computer programs.
It can be very useful for automated extraction of things, such as the now popular machine learning, if for some reason you wanted to train a model to predict the next title based on your favourite papers locally.
But I don't want to do that, at least not yet.
I just want to have a tool that knows how to read a PDF file's metadata and use some of that data for keeping track of my paper collection.
Seems simple: files include metadata, machines can extract that data, and I can write some glue code.

But the problem is, not all files include the metadata.

I can understand not all people bother to include metadata fields for quick things they put into a PDF, but for things such as published academic papers I would hope otherwise, with more care taken.
To me, it is a mark of care.

Sure, there are automated tools for trying to extract common pieces of metadata from the main content of files but I don't want some heuristic things, I want what the author put the title as, or their own names.
Conveniently, these academic papers are uploaded to repositories that **require** them to input basic information such as the title and authors of the paper.
Because the platforms have the data themselves, they could easily add it to the PDF file if it doesn't already exist.
Now, I don't have any particular influence over these repositories, and I can understand them wanting to not interfere with the built artifacts (for reproducibility or otherwise), so we can switch back to the original authors...

Rather than just speaking from my experience of downloading papers, I thought I'd try and have a look at some data.
ArXiv is a popular repository for papers in my field, particularly because it is open-access.
They handily publish archives of their PDFs, grouped by the year and month they were submitted, so we can play around with some of that.
That also happens to be a lot of papers, so I've just selected a few `yearmonth`s and worked with those.
You can find the scripts for processing, if you want to try with more data for instance, on my GitHub: https://github.com/jeffa5/arxiv-pdf-meta.

## The data

## The plots
