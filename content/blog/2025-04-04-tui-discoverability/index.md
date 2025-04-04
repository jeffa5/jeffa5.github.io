---
title: "Reflections on TUI discoverability"
---

_I talk about TUIs in this post, but it can equally apply to GUIs.
I'd love to see that happen too!_

Terminal User Interfaces (TUIs) primarily focus on power users who can spend a reasonable (to long) amount of time customising their setup and learning about the application's configuration mechanism and actions.
That generally works OK, through reading the documentation online, or through man pages.
What I struggle with though is that I may not be a power user for every application I want to use, but still like the TUI feel.
So how do we work with that across applications?

We want them to be flexible to users, allowing configuration of things, but with good defaults.
And we want the applications to be discoverable for new comers, or when new commands are added.
We don't always have time to read all of the documentation and its sometimes a nice experience if you can learn new things within the application itself.
I don't mean an in-app tutorial though.

So I generally see TUIs in one camp having limited configuration, hardwiring most things in.
This is fine when they are young but can lead to lots of different mechanisms for handling adding this customisability in at a later stage.
An instance of this might be that a key `<up>` maps to scrolling a list up, but I like vim-mode bindings so want to change it to `k`.
This then leads to some configuration item being set up to either

1. allow mapping an action in the app to a key (or sequence of keys)
2. or, allow mapping a key (or sequence of keys) to an action
3. or, as I think is now my preferred way, allow mapping a key (or sequence of keys) to a sequence of keypresses

All are sensible options, depending on the complexity, and level of power-user you want to support.
Option 1 keeps commands only having one keybinding and option 2 enables having multiple keys able to perform the same action.
I'll talk about option 3 in a bit, but it can feel a bit recursive (because it is!).

How do we chain actions here?
That's a key feature of shortcuts for me, they don't just have to perform one action, why not many.
Option 1 doesn't really give a way to sequence actions for the same keybinding.
Option 2 does, but requires creating a way to sequence them, and the actions have to be some magical list that the application has an understanding of.
Option 3 does, I can just map a key, `K` to `kk` to move up twice without me having to do anything else like explicitly write out the commands again.

Option 3 is also really nice when coupled with a command line, this is really where the discoverability bit comes in.
With a command line built-in to the application the previously obscure commands can be played around with in the application, not just the config file.
Continuing the basic example we might have some command like `:move-up` in our application, the `:` is used to engage _command mode_ for writing our commands.

Bringing in a nice user experience we can build command completion, flag completion, and argument completion, contextual to the command.
Simply this might mean that after typing `:m<tab>` I get a popover with a list of commands including `:move-up`.
Also, typing `:<tab>` I can get a list of all of the commands and have a play around.

From here we can extend to command history, building out something like a _repeat_ command, maybe even a mapping such as `:<up><enter>`, that focuses the command line, selects the previous entry, and executes it.
This discoverability is something that I miss when trying a lot of TUI applications, especially those that I want to spend time using.

The main project I think about when enjoying this experience is [aerc](https://aerc-mail.org/) which is a delight to interact with.
I've since also started stealing inspiration from it for my TUI chat client [chatters](https://github.com/jeffa5/chatters/), but that's on hold until I can work out some [matrixdir](../matrixdir) stuff.
