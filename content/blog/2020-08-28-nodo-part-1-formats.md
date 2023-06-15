---
title: Nodo Part 1 - Formats
---

- [Nodo Part 0 - An Exploration](@/blog/2020-08-21-nodo-part-0-an-exploration.md)
- [Git Repo](https://github.com/jeffa5/nodo)

To begin implementing Nodo we need to make a start with Rust. This means
creating a new workspace and some subdirs for crates. I'll use a workspace to
ease the management of multiple crates (I'm planning one for the core and
another for each frontend).

All formats we want to implement will need to implement a `trait`. So we can
separate the functionality into two traits:

```rust
pub trait Parse {
    type ParseError;

    fn parse(s: &str) -> Result<Nodo, Self::ParseError>;
}

pub trait Render {
    type RenderError;

    fn render<W: std::io::Write>(n: &Nodo, w: &mut W) -> Result<(), Self::RenderError>;
}
```

These together tell us that each formatter can provide a `parse` function and a
`render` function. So if a particular formatter only implements the `Parse`
trait then it may not be able to be rendered yet. This is fine in it's other
form too, `Render` without `Parse`, as that can be for example the JSON API,
which may need to read from a Markdown file and just return the JSON
formatting.

For an implementation of these traits I've started with just the `markdown`
module. This is going to be the main format for now at least. We can use a
simple unit struct to give us something to implement our traits on:

```rust
pub struct Markdown;
```

And then implement the traits like so, for full code reference see the Git Repo
link:

```rust
impl Parse for Markdown {
    type ParseError = ParseError;

    fn parse(s: &str) -> Result<Nodo, Self::ParseError> {
        let mut opts = Options::empty();
        opts.insert(Options::ENABLE_TASKLISTS);
        opts.insert(Options::ENABLE_STRIKETHROUGH);
        let blocks = parse_blocks(&mut (Parser::new_ext(s, opts)).peekable())?;
        Ok(Nodo { blocks })
    }
}

impl Render for Markdown {
    type RenderError = RenderError;

    fn render<W: std::io::Write>(n: &Nodo, w: &mut W) -> Result<(), Self::RenderError> {
        render_blocks(&n.blocks, "", w)?;
        Ok(())
    }
}
```

With some `enum` error types, defined using the
[`thiserror`](https://github.com/dtolnay/thiserror) crate, very simple. These
can then be called (when the trait is in scope) with `Markdown::parse(...)` and
`Markdown::render(...)`, respectively. I used the `std::io::Write` trait for
the `render` function so that we don't have to explicitly write it all to a
`String`, and can instead go straight to a file.  This could have been mimicked
with `std::io::Read`, or a relative of, and the `parse` function, however the
[`pulldown_cmark`](https://github.com/raphlinus/pulldown-cmark) crate doesn't
provide such a utility so it wouldn't have made as much sense. I may change
this to allow other parsers to read straight from a file or other compatible
source though.

So far there have been some unexplained things such as the implementations of
`Nodo`, `ParseError` and `RenderError`. These are not so important as I don't
want to get into all of the parsing logic too much but more outlay my high
level thoughts, yes I've written the code, no it is likely not in a finished
state, whatever that means.

One other thing I'd like to briefly mention was my experience implementing the
functionality here. Rust gives us powerful mechanisms to manipulate our
structures as well as ensuring we aren't being too silly with them, mostly here
was a lot of `match` statements. This just gives me confidence in the code as
well as a nice way of seeing how many cases you have left to implement, a
little welcome motivation.

Oh, and getting to use peekable was nice. I needed it for checking if a list
item has a `TaskListMarker` and parsing _tight_ paragraphs which don't come
with much warning and also don't have a nice tagged ending, stumped me for a
while.

Next, I need to think whether I want to have a CLI or work on the internals
some more...
