# Thoughts on notes and todos

I often find myself a bit lost with what I have going on, what needs doing and
what state things are in. I make notes on pieces of paper which are nice, small
and physical, but easily lost, missed and forgotten. I also have some notes on
Google's Keep, these mostly get forgotten about though. I primarily spend my
computer time on the command line or in a TUI of some sort or other. My paper
notes solution doesn't work there and doesn't stay with me when I move places
or computers. My Keep collection stays with me but also isn't where I want it,
in the terminal.

I like writing markdown files in my editor, keeping them easily readable by
anyone while still retaining some pretty formatting. Sometimes I use task lists
to give myself some todos inline, again, these get forgotten about.

I also want to be able to programmatically interact with my notes and todos so
that I can write things around them and automate stuff.

There are a few online notes services which work online, there are a few CLI
programs for tasks that work on the CLI and occasionally have a syncing option
to the web or another machine. None of these seem to fit me though, perhaps I
just haven't spent enough time in them.

## A loose list of wants

- CLI interface using `$EDITOR` for composition
- notes and todos in the same place
- inline todos in notes
- priority handling with due dates, potentially repetition
- hierarchical grouping of notes and todos
- syncing to other machines, with a native way of interacting with them there,
  e.g. a website
- plaintext formats, like markdown, for sharing with people
- conversion to json or something for sharing with machines
- having sub-spaces for public, private and collaborative items

## Experimentation

I might as well have a go at building something that might start to fit these
criteria, mainly just for fun and learning. Perhaps I'll find an existing
application that does what I want out of the box, who knows. Maybe I'll explore
more what I want out of the tool too.
