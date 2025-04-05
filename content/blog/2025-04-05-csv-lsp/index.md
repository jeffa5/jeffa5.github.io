---
title: "CSV Language Server"
---

Language servers, part of the language server protocol (LSP), enable enriching plain text documents to provide navigation, completion, or extra hints, among other things.
Typically we see them for programming languages, enabling us to complete function names, jump to definitions, and get type hints inline.
But why stop there?

In the line of enriching content, I had a thought about making a language server for CSV files.
These are a great plain text format that sort of resembles spreadsheets, you get rows and columns with cells of data.
We typically have a header row at the top for names of the columns, and then data in the cells below.
This data is normally just plain data, even if we add some spreadsheet function into it, like `=SUM(A2:A5)`.
That's nice, it's quick and easy to view, but what if we wanted to do a quick bit of spreadsheet work and didn't need the full spreadsheet program, wouldn't it be nice to have it just in the editor.

Here's where the language server comes in.
I propose having the language server utilise the inlay hints (I think that's a reasonable thing to use) to show the result of these computations.
This might limit the functionality to more basic functions, but anything more advanced I think should be either in a full spreadsheet program, or done with code parsing the CSV file.
This would also include the normal completion of spreadsheet functions, and maybe some hover help information too.

```csv
Item,Amount
food,20
drink,5
travel,30
accommodation,55
,=SUM(B2:B5)
```

Might become (using `>` for the inlay hint part):

```csv
Item         ,Amount
food         ,20
drink        ,5
travel       ,30
accommodation,55
             ,=SUM(B2:B5) > 110
```

A formatter would be nice to align the columns and add spacing, but we can leave that to another project.
Maybe inlay hints could be used to do this without modifying the spacing in the actual file...

CSV isn't necessarily a perfect format, but this might just be enough to play around with.
