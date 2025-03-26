---
title: "Matrixdir: a file-first approach for chat programs"
---

## Motivation

In my email setup I have a nice separation between synchronising emails from my mail server, viewing my emails locally, and another program responsible for sending emails.
This split is commonly called: mail retrieval agent ([MRA](https://en.wikipedia.org/wiki/Mail_retrieval_agent)) and mail delivery agent ([MDA](https://en.wikipedia.org/wiki/Message_delivery_agent)), message user agent ([MUA](https://en.wikipedia.org/wiki/Email_client)), and message submission agent ([MSA](https://en.wikipedia.org/wiki/Message_submission_agent)) and mail transfer agent ([MTA](https://en.wikipedia.org/wiki/Message_transfer_agent)).
I like it, it keeps things separate and means that I don't have to have my 'email client' open all the time to receive email, but its downloaded and ready for my perusal offline whenever I like.
Synchronising it to my device also means that I have a local archive and don't need to repeatedly 'export' my data from the service.
One other key factor in this is that there is a defined standard for storing emails on a filesystem that other email programs are compatible with and can share.
This standard is called [maildir](https://en.wikipedia.org/wiki/Maildir) (yes, there are extensions, and other standards like [mbox](https://en.wikipedia.org/wiki/Mbox) but I'll keep it simple here).

Now, I increasingly chat with people over instant messaging, not uncommon I know.
However, my chats here are locked away in various apps in various clients, some of which are considerably more open than others.
So, I'd like to try and bring my data out of those services and be more local to my devices and plaintext for ease.
Plaintext means that other applications can do things like implementing search over messages, and I can easily take backups of them.

There are multiple chat programs I use, but I want one standard filesystem layout for them, and then synchronisation programs can pull data down and lay it out there.
Then we can have viewers of this data, like what I've thought about with [Chatters](https://github.com/jeffa5/chatters), that can view messages from any chat system.

But of course, I don't want to create another standard for messages themselves.
The [Matrix protocol](https://matrix.org/) does have a nice ['bridge'](https://matrix.org/ecosystem/bridges/) concept to integrate with other chat systems which gives me confidence that the Matrix format would be a suitable one for the messages.
I imagine writing programs that synchronise messages from their respective chat servers and map them into the matrix format before storing on the filesystem.

## High level architecture

### Syncing messages down

I'd term this the chat retrieval agent (CRA).

> Chat system -> CRA -> matrixdir

Each CRA would be responsible for connecting to the chat system in question, downloading the messages for the user, and translating them into matrix format.
The messages would then be stored unencrypted on the filesystem.

### Viewing messages

I'd term this the chat user agent (CUA).

> matrixdir -> CUA

The CUA here is a viewer of messages for the user, it just reads data off disk and builds its ui from that.
It should be able to also watch the filesystem for new messages so that it doesn't have to reload everything.

### Sending messages

I'd term this the chat submission agent (CSA).

> CUA -> CSA -> Chat system

This is where I'm currently a bit fuzzy.
Keeping to how it works in email, and keeping login logic out of the CUA, I want the CUA to invoke a process to send a message or write to a socket or something, with the matrix format as input.
Then the CSA works out encrypting it or not, and sending it to the server.
What I'm unsure about is whether the message needs to be copied to the matrixdir at this point, or whether the CRA should get it during a sync (or if we do both how do we avoid duplicates).

## File layout and format

```
chats/
  lock.pid
  room1/
    <timestamp_millis>-events.jsonl
    attachments/
      <server-name>/
        <media-id>
  room2/
    <timestamp_millis>-events.jsonl
```

My proposal is that, during synchronisation, events are split by the 'room' that they are for (what chat the message is in), and there is a directory for the events in each room.
Within the directory for each room are files split by the CRA's chunking choice, but depict time slices of the events.
A file's name indicates the timestamp (in milliseconds) of the first event in its file, and should not include events from before this timestamp.
Events should be added to the latest timestamp file that is available.
The CRA is free to create new files based on, for example, each day, each week, or number of messages.
The CRA only appends new events to files, never modifying events that have already been written.
The particular format is JSON lines as the matrix messages can be arbitrary, and they have a convenient JSON representation which is self-describing, useful for use with tools like `jq`.
When initialising, the CRA must acquire the file lock on the `lock.pid` file in the root of the `chats` directory, and write its own process ID into the file.

Attachments are stored in an `attachments` directory next to the events file for each room.
The location within is determined from the [matrix content URI](https://spec.matrix.org/latest/client-server-api/#matrix-content-mxc-uris) (`mxc://<server-name>/<media-id>`).
This enables leaving the original event untouched while being able to check whether the attachment has been downloaded.

When a client (CUA) wants to view chats it can create a notify subscription on the event files for the rooms it is interested in, and maintain seek positions in them for where it has read to.
Then, when given a notification that a file has been updated, it can read from its seek position in that file, reading line-by-line to get the events.

Splitting the events by room means that a client can just load events for a room as needed.
Splitting events by arbitrary chunks allows the CRA to adapt to volumes within channels and avoid lots of tiny files for a room or having one large file for a room.

### Grievances

**This doesn't achieve maildir's nice atomicity through using the `mv` operation.**
The lack of atomicity in the writes could lead to incomplete data in the file.
This could occur when, for instance, the CRA crashes before fully writing an event.
A simple solution to this is for the CUAs to ignore invalid lines.
When the CRA starts up it should check that each event file ends in a newline to ensure that if corrupt entries exist in the last line that they can be skipped properly.
While it is tempting to provide a cleanup operation on the files, this invalidates the assumption that an event file is append-only.
Additionally, the file lock aims to avoid concurrent processes (that are cooperating with the protocol) from invalidating and concurrently appending to the same file.

**This is not intended to be the only storage for CUAs.**
This format cannot be everything to every client, thus they may need to implement their own caches for performance.
It does however aim to be solid starting point for them to rebuild caches from.

### Alternatives

**File per message.**
I envision this might lead to too many files and doesn't have an inherent ordering scheme compared to appending to the file.
File names could be ordered but I still think it might lead to too many files, particularly given that most chat messages are small.

**One big file.**
This prevents the clients from efficiently viewing events from a subset of rooms, such as on startup.

## Conclusion

I'd like to make some time to implement this in a Rust library, basic handling of the file layout things, and then try to integrate synchronising from a matrix server.
In fact, here's a work in progress repo: [matrixdir](https://github.com/jeffa5/matrixdir).
Once that's working I think it would be interesting to try and integrate other protocols via matrix bridges, hopefully minimising the work needed as they should already be able to transform things to and from the matrix protocol format.
Perhaps in parallel I would be able to make a start on moving chatters towards working with this new file format rather than having the synchronisation backends embedded in it.

If you have any comments on this proposal, or want to work on it in some way, let me know.
