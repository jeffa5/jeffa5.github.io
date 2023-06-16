---
title: Nodo Part 0 - An Exploration
---

I've just published a brief [post](@/blog/2020-08-16-thoughts-on-notes-and-todos.md) about notes and todos in which I
outline some ways I want to interact with my notes and todos. I'm going to try
and keep up with the development of the tool I experiment with here to outline
to myself why I'm making decisions and for anyone else that finds it useful.

So, without further ado, Nodo (notes and todos) is my intended notes and todo
management tool. I must briefly preface this with saying that I have already
tried building Nodo, twice, and have a semi-working version in OCaml at the
moment. I first tried creating it in Rust but as I was a bit too new to Rust
then it felt rather strenuous for a tool that should at its core be very
simple. Due to slightly more familiarity with OCaml, and the fact that it has
lots of the nice functional programming aspects, I decided to recreate it,
getting somewhat further than I did with the Rust version.

Now I'm back to Rust land and wanting to give it another go with all of the
safety and correctness it can offer me. In addition I want it to be fast and
efficient, all things which Rust seems built for.

To start things off, I have a few ideas for the design:

1. I want the notes and todos (nodos from now on) to be stored in plaintext
   files, one file per nodo. This makes sharing with other users, as well as
   manipulation via other tools, easy.

2. I want some sort of history, like git, probably git. This means that if for
   some reason I delete a bit and later want to revert to that I can, and I can
   do so with native git commands. This will hopefully help with the syncing
   issue as well, though may pose some challenges for more advanced use cases.

3. There needs to be a core library for most of the common operations such as
   parsing, querying, formatting, etc. Then various frontends can be built to
   use this same logic and just implement the UX elements they need.

4. As for formats I want to use Markdown and the core should be able to
   translate this to other formats such as HTML and JSON, probably. Any other
   formats would then be added to the core library, or I may try and have some
   ability to optionally include them.

Now for some potential execution examples:

Showing the current nodos. Displays attributes and task completion status.

```sh
$ nodo
review [repeats:daily]
ideas
nodo
├─ bugs [0/1]
└─ syncing [1/5 due:tomorrow priority:1]
```

Open a nodo for editing or create it if it doesn't exist.

```sh
$ nodo edit ideas
```

Move a nodo to the archive, keeping it around for viewing but hiding from normal view.

```sh
$ nodo archive nodo/syncing
```

Sync the current set of nodos.

```sh
$ nodo sync
```

As well as some moving and deleting commands.

I think this should at least allow for a start for things and I can rework them
later as needed.
