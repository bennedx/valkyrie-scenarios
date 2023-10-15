# makebooks

**usage:**  makebooks *.book

Accepts a .book file, updates localization.{language}.txt, and creates one or more {name}.events.ini files.

## Installation



## Getting Started

### What is a Book?

A book is a set of multiple events strung together to make a book-like interface with pages and a table of contents (TOC). On the TOC, there can be a button for each page. Each button will automatically manage its "{action}" tag. Buttons can stay after reading or disappear. The buttons can be pressed in any order, or forced from top-to-bottom.

A book is made up of directives. A directive can be used to set the language, add pages, roll skill checks, and build the TOC. Parameters are separated by `|` symbols.

```
book|ordered|keep
```

### Kinds of Books

There are four kinds of books, determined by reading order and persistence. Reading order is `ordered`/`random`, and persistence is `keep`/`nokeep`.

`ordered`:  The pages must be read in order from first to last.

`random`:  The pages can be read in any order.

`nokeep`:  The page disappears after reading; it can only be read once.

`nokeep`:  The page does not disappear after reading; it can be read more than once.

These are the four kinds of books and their look and feel.

`ordered`|`nokeep`:  Pages are read in order and can only be read one time. By default, each time the book is started, the next page is read, then exits after hitting [Continue].

`ordered`|`keep`:  Pages are read in order and can be read more than one time. Each page is read in order. By default, a page costs an {action} on the first read, but does not after that. Buttons for each previously-read pages build up under the text. After reading, the TOC is re-opened with a new button added to the previously-read buttons.

`random`|`nokeep`:  All pages are available from the start and can be read in any order. Once read, the button for that page disappears.

`random`|`keep`:  All pages are available from the start and can be read in any order. Once read, the {action} is removed.

### Creating a Book

To create a book, use the `book` directive.

```
book|Journal|ordered|keep
```

This creates a book named `Journal`. It is an ordered/keep book, meaning the pages show up one-at-a-time but can be read over-and-over.

Now add some pages.

```
book|Journal|ordered|keep
page|Day 1|The townsfolk were up-in-arms about a monster, but...
page|Day 2|I thought I saw something large out of the corner of my eye. Whatever.
page|Day 3|I know what the townsfolk were talking about. Nope.
```



**book**|*name*|*order*|*persistence*|*[* **loop** *]*







## Examples



# Reference

## `book` Directive

Creates a book.

**book**|*name*|*order*|*persistence*|*[* **loop** *]*

| Parameter     | Usage                                                        |
| :------------ | ------------------------------------------------------------ |
| *name*        | The name of the book. This will become part of the names of the generated events; eg, the starting event for a book named "Journal" would be `EventJournalStart`. |
| *order*       | Either `ordered` or `random`.                                |
| *persistence* | Either `keep` or `nokeep`.                                   |
| **loop**      | Either `loop` or `noloop`. See below.                        |



What is makebooks?





debug

# define the outputs and language
language|English

book|Journal|ordered|keep

# page|name|text
#   name        The name of the page; this is the text that shows on buttons
#   text        The text to show when the button is pushed on the TOC

page|Read Page 1|\n25 October 1925\n\nI’ve decided to record what happens this week. After three generations of Smythes making the attempt, I think the Master will finally bring Our God into this world. This time, there will be no mistakes. His uncle failed 10 years ago, but the Master will not. We are gathering supplies, preparing the altar, and looking for the right people to help us. We will sacrifice His son in the ritual. He says it is painful to think about--His son is so young--but that is what sacrifice is. The Master is a great man.\n
    toc|The book looks new. When you flip through it, you see that there are only a few entries. The first one is last Sunday.
    
page|Read Page 2|\n26 October 1925\n\nThe Master told us that we could all die in the ritual. The hunger of Our God's arrival will drain us. But he thinks we can supply Its Greatness from another source. I hired a local cleaning company to come to the house the day of the ritual. They should protect us.\n
    toc|You wonder how a family could work tirelessly over so many generations to commit such evil.
    
page|Read Page 3|\n27 October 1925\n\nPreparations continue. The ritual will test the Master and maybe break him. He counts on the healing stone to see him through, but one of the church members lost it. The Master told me he will use her instead. He said it wasn't much of a sacrifice, but it would be enough when the time comes.\n
    toc|You are shocked to learn that you are here to protect their lives. You are determined to stop them from killing you.
    
page|Read Page 4|\n28 October 1925\n\nThe Master has prepared his son all week. The boy is isolated. The Master says his son's fear will provide the power needed to create the portal.\n\nThe boy's screaming kept me awake last night. It hurts to hear, but the Master told me this morning that power is drawing into him, making him stronger for Saturday.\n
    toc|These people are ruthless:  a member loses something and will pay for it with her life. These people must be stopped.
    
page|Read Page 5|\n29 October 1925\n\nKids broke into the house yesterday. One of the Brothers chased them off, but not before they broke into the basement. We secured the door with a special lock and cast a living darkness spell on the room. I piled boxes in front of the entrance to the place of power beneath the house. No one will find their way to the altar before Saturday.\n
    toc|His son?! How can he sacrifice his own son? The depth of this depravity inspires awe.
    operations|readAboutBasementDoorToCave,=,1 @FoundBasementDoorToCaveViaJournal,=,1
    
page|Read Page 6|\n30 October 1925\n\nThe cleaning crew will be here tomorrow to start on the house. Everything is prepared for the ritual; I can feel the fear and excitement building in all of us. Soon the world will belong to the One True God.\n\nThe Master's son continues to plead for his life during the day, then screams in the night. The Master told me in confidence the he yearns to stop, but that he must keep his commitment and see this through.\n\nThe boy has been moved to the dungeon outside the altar room. There is a hole in the wall that he stares through when he's not begging or screaming. The altar is visible through the hole; looking at it terrifies the boy. I can no longer hear him, but I can feel his fear from across the town. I will be strong.\n
    toc|There are two more entries. These people must be stopped.
    operations|readAboutCellHole,=,1 @FoundCellHoleViaJournal,=,1
    
page|Read Page 7|\n31 October 1925\n\nAll the preparations are made. Tonight we will bring Its power to this world.\n\nThis morning, the Master told me that something is bothering him, but that he cannot put his finger on what. He said something has changed, like there is another power in the house. My brethren have combed the house and can find nothing. I hope the Master is wrong.\n\nThe woman who lost the stone is already at the altar. Her husband pleaded with me to help him find the stone, so I'm going to search the chapel one more time. For his sake, I hope we find it.\n\nThe cleaning crew are due here momentarily. They will be here until they are... needed. The plan is set in motion.\n
    toc|We are here to feed their god, but that will not happen. We will put an end to this.

# is this correct? Or should it still be readJournal,=,1 VarReadJournal,=,1
	operations|@readJournal,=,1

# end|text
#   text                    Shows this text on the TOC when no pages are actionable; the only button reads 'Continue'

end|This evil must be stopped. What you've learned tells you when and where the ritual will take place. You must hurry.

# putting 'line' commands after 'end' adds them to the end event



# book|<event name/name of book>|{ Random | Ordered }|{ keep | nokeep }|{ single | repeat }
#   random / keep           Can do anything at random. Options show after use. {action} only shows when not yet used
#   random / nokeep         Can do anything at random.  After first use, it is removed
#   ordered / keep          Shows all previously read (no action) and only the next one (with action)
#   ordered / nokeep        Shows only the next one, no way to re-read messages.
#
#   single					At the end of each page, goes to Event<book>End
#   repeat					At the end of each page, go back to Event<book>Start

# other commands following page (or end) add more functionality to the generated events
#   test|<conditions>|alternate text        Allows substituting text when certain conditions are met; if no test passes, the main text is used
#   operations|<operations>                 Allows performing assignments on [continue], but only when it is an action
#   visible|<variable>                      A runtime variable determines whether or not to show this value; 0 == no show; > 0, show
#   notvisible|<variable>					Same as 'visible' but 0 == show and > 0 doesn't
#   toc|<text>                              This is the text shown on the TOC screen; rules:
#                                               1. Show the first {actionable} text entry found; if none,
#                                               2. Show the last non-actionable text entry found
#
# <conditions> are in modified VarOperation form: the test is the same as normal. In between can be AND or OR. If neither is present, AND is assumed.
# if you add conditions to an event, be sure to use 'vartests' instead of 'conditions'
#
#   exit                                    Transfers control directly to the end of the convo instead of the TOC

# Notes
# Every page has a disambiguating event named “JournalReadPage1”  The name is <bookname>ReadPage<index>
# For each “test”, a new event is created and listed in the disambiguating event; the last entry is always the text on the page line with no tests set
#
# For ordered/keep, a TOC is created for each page as action, and one for no actions at the end
# Each TOC is a disambiguator page; a separate TOC is generated for each test entry and the toc line
# If a page is optional (visible used), the TOC entries are duplicated with and without the  optional entry
#   Because each optional entry is on its own, using these grows the permutations logarithmically
#
# For operations on pages, each button is given a new event:  JournalReadPage1Continue (has operations), JournalReadPage1Cancel (no operations)
#
# Buttons:  Continue always goes back to EventJournalStart, Cancel always goes to EventJournalEnd (via operations events if necessary)
#
# For random/keep, a TOC is generated for each combination of actionable pages, so five questions expands to 2^5 events
#   If there are visible entries, each of those requires duplicating the TOC with and without those entries (five questions where one is optional gives 2^5 + 2^4 = 62 TOCs)
#   If there are test entries, each of those require duplicating all of the the TOC events, once for each entry; these will grow the event counts logarithmically
#   If more than one text is available, the entries are duplicated, once for each 'random' found
#
# For Ben:  two states: happy/angry, four questions, one optional question, and three random TOC's with two-state text
#    event-count = 2 states * 4 questions * 2 (w/wo) optional question * 2 ^ 3 random TOC's * 2 state text = 256 TOC events
#

# if an override TOC is given, that text is used

# -------------------------------------------------------------------------------------------------------
# Ben in the backyard
# only two questions can be asked before Ben finds his key; apologizing doesn't count
#    as a result, we only need toc entries for the first two items
#
# While this process was orignally designed for books, it works well for conversations as well.

book|BackyardBenBefore|random|nokeep

# adding 'line' commands here under 'book' puts those lines into the start event

    # this line is a cheat:  after PlaceDiningRoom, this will cause the book to “fall through” but it will not go through EventBackyardBenEnd
    line|conditions=exploredDiningRoom,==,0


page|“How long will it take us to look through the house?”|“How long, you ask? Well, the house is large. There are numerous rooms on the ground floor, a basement, and many rooms upstairs. Even when Peter was living here, it was only him and his daughter. The girl's mother died under suspicious circumstances when the girl was three. Never explained.”\n\nGain 1 {clue}.\n\n“Anyway, I'd guess you'll need a few hours just to look through the place and get your bearings. You'll want to check every drawer, cabinet, and box in the house--take as much time as you need. We need the whole house cleared out and spotless by the end of next week.”
    test|exploredBackdoorNicely,==,0|“Long enough,” he snaps. “There are numerous rooms on the ground floor, a basement, and many rooms upstairs. The place has always been too big for this family. Back when Peter was living here, it was only him and his daughter. The girl's mother died under suspicious circumstances when the girl was three. Never explained.\n\n“Anyway, you will take whatever time is necessary to look in every drawer, cabinet, and box in the house. You are thorough, aren't you? And you won't break anything else?”
    operations|talkedToBenHowLong,=,1 talkedToBenCount,+,1 @TalkedToBackyardBen,=,1
    toc|Benjamin is digging through his pockets for the key, but isn't having much luck finding it. You hear him muttering about it under his breath.
    
page|“What do you think happened to the children?”|“The children? I'm sure you read the papers. One of them was burned from head-to-toe. The other two were strangled. The burns were never explained. Nasty business. \n\n“Peter Smythe--the girl's father and the owner of this house--went missing that night. Most folks think he did something to the children and then ran away. Still hiding, they think.\n\n“What wasn't reported is that his brother, Henry, also disappeared that night. Folks in town figured they'd run off together to avoid difficult questions.”\n\nGain 1 {clue}.
    test|exploredBackdoorNicely,==,0|“The children? Two were strangled. The burns on the third were never explained. Nasty business.\n\n“Peter and his brother Henry both went missing that night. Most folks don't know about Henry. Left a lot of folks around town wondering what really happened. But we're not here to gossip.”
    operations|talkedToBenChildren,=,1 talkedToBenCount,+,1 @TalkedToBackyardBen,=,1
    toc|Benjamin is still digging through his pockets for the key

page|“Where were the children found?”|“The children were found just over there,” he says, pointing back the way you came. “They were in a pile; the girl's body was still smoking from the burns. Strangest thing:  she kept smoking until the next day. Coroner wasn't able to explain it. No one was.\n\n“Our family has lived here for generations--many of them in this house. We're upset to let it go, but no one lives here... or wants to after what happened.”\n\nGain 1 {clue}.\n\nBenjamin resumes searching for his keys.
    test|exploredBackdoorNicely,==,0|“The children were found just over there,” he grumbles, pointing back the way you came. “Not sure why it matters, but I'll tell you:  the girl who was burnt, she kept smoldering until the next day. Coroner couldn't explain it.”
    operations|talkedToBenWhere,=,1 talkedToBenCount,+,1 @TalkedToBackyardBen,=,1

page|“Why did you wait so long to sell the house?”|“Well, we tried right after the... trouble. No one would even come to look at it back then, but our priest, um, told us now is the right time.\n\nGain 1 {clue}.”
    test|exploredBackdoorNicely,==,0|“That's none of your concern,” he snaps.\n\nYou startle at his abrupt response. You and all investigators in your space suffer 1 horror ({will} negates).
    operations|talkedToBenSell,=,1 talkedToBenCount,+,1 @TalkedToBackyardBen,=,1
    
page|“I'm sorry about the gate”|“You should be more careful. The house is old and in poor repair, but some parts have already been repaired. But no real harm done--the gate can be repaired.”
    notvisible|exploredBackdoorNicely
    operations|exploredBackdoorNicely,=,1

# -----------------------------------------------------------------------------
book|BackyardBenAfter|random|nokeep

page|“Is the whole house this dirty?”|“Well,” he starts, “the house was quickly packed and closed 10 years ago. There has been no one here since then, so expect the worst.”\n\nYou are not encouraged.
    toc|Benjamin looks around the room, like is he trying to figure out what you are doing.
    test|exploredBackyardNicely,==,0|“Well,” he snaps, “the house sat unused these last 10 years. You were hired to clean, not criticize.”\n\nThis man clearly does not like you.
    
page|“There are footprints in the dust by that door...”|“I think the handyman was in the house yesterday. They must be his.”
    test|exploredBackyardNicely,==,0|“Then you should sweep it up. That's what you're here for, not to complain about dirt.”
    
page|“Is there anything else we need to know?”|“Oh, my, yes. Here's the key you'll need to open doors throughout the house.”\n\nGain the {c:QItemBrassKey} common item.\n\n“I should be going. Take your time and send someone to fetch me if you need anything.”\n\nRemove this person token.
    test|exploredBackyardNicely,==,0|“What? Oh, here's the key to the house. Don't lose it. I'm going to leave you to it.”\n\nWith disgust, he turns and carelessly drops the key in your direction. Put the {c:QItemBrassKey} common item in Ben's space, then remove Ben from the board.
    line|add=QItemBrassKey
    line|remove=TokenBackyardBenAfter
    operations|$mythosKey,=,1
    
    # the 'exit' command forces the conversation to stop, rather than allowing it to go back to the TOC
    exit

# --------------------------------------------------------------------------------------
book|DVMStopRitualBefore|ordered|keep
	line|conditions=goal,==,goalStopRitual ritual,==,0

page|Read Page 1|Page 1\n\nYou open the book to the first page. It's a table of contents. You quickly scan down and find the spell to close portals. In the margin, someone--probably your father--scrawled a note that reads, “My descendants will be able to read this book, but only at the appointed hour. I have seen to this.” \n\nGain 1 {clue} the first time you read this.
    toc|The {c:QItemDVM} looks old and worn with time.
    
page|Read Page 2|Page 2\n\nYou leaf through the book to find the ritual to close a portal. The first part is an overview and list of materials. You'll need a special knife, a chalice, a skull, some religious icons, and a number of herbs. There's also mention of an “elder sign,” but you aren't sure what that is.\n\nYou must find the {c:QItemRitualDagger} Common Item, {c:QItemRitualComponents} Unique Item, and {c:QItemElderSignPendant} Common Item.\n
    toc|The book seems to contain spells and {c:EventChosenInvestigator} might have special powers. The book is thick and should be looked at more carefully.

page|Read Page 3|Page 3\n\nYou flip the page. Here the book goes into detail about the dagger you'll use. There is a long list of steps to follow to prepare it. This will take some study. Gain 1 {clue}.\n\nThere is also a “blessing” you need to speak, but it is in a language you don't read or understand.
    toc|Closing a portal doesn't sound easy. Read on.
    
page|Read Page 4|Page 4\n\nThe next page delves into the importance of personal sacrifice. For this ritual, the sacrifice is small:  a few drops of your own blood. You shudder as you read about using your blood for the ritual. Suffer 1 Horror ({will} negates).
    toc|Each tool seems to need special attention. This will require more study.
    
page|Read Page 5|Page 5\n\nThe next page is where the power starts to manifest. This page talks about an incantation you'll use to begin collapsing the portal. This first part will weaken it. Even if the second half of the ritual is not completed, the portal will eventually collapse.\n\nSealing the portal will prevent another from being opened near the same location. We want to complete this ritual.\n\nWhen you get to the incantation, you realize it is written in the same language as the blessing. You think back to that margin scrawl and wonder if you'll be able to understand it later.
    toc|Adding your own blood to the ritual sends a chill down your spine. There's more.
    
page|Read Page 6|Page 6\n\nOnce the portal is weakened, it must be closed and sealed. Sealing it requires more blood and an elder sign. After reading this section, you understand how the elder sign will be used to close and seal the gate. You wonder how you will find such a thing.\n\nFortunately there is a picture of one next to the description. You'll keep an eye out as you wander the house.
    toc|You hope the margin scrawl on the first page is right--daggers and sacrifice are one thing, but the incantation is unreadable. There are only two more entries.
    
page|Read Page 7|Page 7\n\nThe final incantation will close and seal the portal permanently. Another portal could be opened, but not near this one. You think that the incantation is in the same language as the other two. You hope your father knew what he was talking about. Gain 1 {clue}.
    toc|Even more blood is required, and it may not be possible to complete the final part of the ritual. This is the last page of the ritual.
    
end|Now you know how to perform the ritual to close and seal a portal.

book|DVMStopRitualAfter|ordered|keep
	line|conditions=goal,==,goalStopRitual ritual,>,0




# ----------------------------------------------------------------------------------
book|DVMStopCultists|ordered|keep
	line|conditions=goal,==,goalStopCultists

page|Read Page 1|Page 1\n\nYou open the book to the first page. It's a table of contents. You quickly scan down and find the spell to open portals. On the inside cover, someone--probably {c:EventChosenInvestigator}'s father--has scrawled a note that reads, “Only my descendants will be able to read this book, and only at the appointed hour. I have seen to this.” \n\nGain 1 {clue} the first time you read this page.
    toc|The {c:QItemDVM} looks old and worn with time.
    
page|Read Page 2|Page 2\n\nYou leaf through the book and come across the ritual to open a portal. This part is an overview and list of materials. The list includes a special knife, a chalice, a human skull, some religious icons, and a number of herbs. There's also mention of an “elder sign,” but you aren't sure what that is.\n\n<i>I would do well to find things these first</i>, you think to yourself. 
    toc|The book seems to contain spells and you might have special powers. The book is thick and should be looked at more carefully.

page|Read Page 3|Page 3\n\nYou flip the page. Here the book goes into detail about the dagger needed to open the portal. You are surprised at how intricate the ritual is. There is also a section about blessing a knife, but when it gets to the actual blessing, it is written in a language you do not understand.
    toc|Opening a portal doesn't sound easy. Read on.
    
page|Read Page 4|Page 4\n\nThe next page delves into the importance of personal sacrifice. For this ritual, the required sacrifice is large. A cold chill runs down your spine as you realize that only a precious loved one is enough. <i>What kind of monster could do such a thing?</i> you wonder to yourself. The first time you read this, suffer 1 Horror ({will} negates), then gain 2 {clue} if you don't go Insane.
    toc|Each tool seems to need special attention. This will require more study.
    
page|Read Page 5|Page 5\n\nThe next page is where the power of the ritual starts to become clear. This page talks about an incantation that begins manifesting the portal in the sacrifice. The revulsion you feel steels your resolve to prevent this from happening again.\n\nWhen you get to the incantation, you realize it is written in the same language as the blessing. You think back to that margin scrawl and wonder if you'll be able to understand it later.
    toc|What kind of monster could kill a child for this? But there's still more.
    
page|Read Page 6|Page 6\n\nOnce the portal has manifested, it is weak and unstable. As you read further, the book discusses affixing the elder sign to the portal to stabilize it and hold it open. There is a also something about feeding the elder sign with additional sacrifice, but it isn't clear to you what that means. The book describes the artifact in great detail and how it is used in the ritual. A picture clearly shows what it looks like. The incantation itself is in the same language as the other two. You wonder if your father knew what he was talking about in the front of the book. Gain 2 {clue} the first time you read this page.\n\nYou'll keep an eye out as you wander the house. You must find this artifact before your uncle does if you are going to stop him. \n\nThe first time you read this, something falls out of the book as you turn the page:  gain the {c:QItemSpells} spell and 1 {clue}. 
    toc|You hope the margin scrawl in the cover of the book is right--daggers and sacrifice are one thing, but the incantation is unreadable. You also wonder where your uncle might be performing the ritual. There are only two more entries.

page|Read Page 7|Page 7\n\Finally, there is commentary and advice. One section discusses ley lines and how they allow you to draw more power for the ritual. The preferred date and time for the ritual is also discussed, with a full moon being the most important.\n\nIn the margin are notes about a place under the house that aligns with a ley line; there is also a list of years that would be good for the ritual.\n\nFinally, there is a paragraph about the importance of the {c:QItemElderSign}; if it cannot be used, the portal will not stabilize and will require constant, low-level sacrifice to remain open.
    toc|It sounds like even more blood is required, and for a moment you wonder where it will come from. Then you remember the journal:  it's you and probably the townfolk as lesser sacrifices. <i>Maybe if I keep them from finding the {c:QItemElderSign}...</i> This is the last page of the ritual.
    operations|dwmRead,=,1 @FoundCellHoleViaJournal,=,1 @DwmRead,=,1
    
end|Now you know what you need to do before your uncle does:  find the {c:QItemElderSign} and limit the number of townspeople who can be sacrificed for the portal.
    test|exploredTortureChamber,==,1|Now you know where the ritual will be performed and what is needed. You must stop the townspeople from helping your uncle!

# ----------------------------------------------------------------------------------
book|DVMRescueBoy|ordered|keep
	line|conditions=goal,==,goalRescueBoy

page|Read Page 1|Page 1\n\nYou open the book to the first page. It's a table of contents. You quickly scan down and find the spell to open portals. On the inside cover, someone--probably {c:EventChosenInvestigator}'s father--has scrawled a note that reads, “Only my descendants will be able to read this book, and only at the appointed hour. I have seen to this.” \n\nGain 1 {clue} the first time you read this page.
    toc|The {c:QItemDVM} looks old and worn with time.
    
page|Read Page 2|Page 2\n\nYou leaf through the book and come across the ritual to open a portal. This part is an overview and list of materials. The list includes a special knife, a chalice, a human skull, some religious icons, and a number of herbs. There's also mention of an “elder sign,” but you aren't sure what that is.\n\n<i>I would do well to find things these first</i>, you think to yourself. 
    toc|The book seems to contain spells and you might have special powers. The book is thick and should be looked at more carefully.

page|Read Page 3|Page 3\n\nYou flip the page. Here the book goes into detail about the dagger needed to open the portal. You are surprised at how intricate the ritual is. There is also a section about blessing a knife, but when it gets to the actual blessing, it is written in a language you do not understand.
    toc|Opening a portal doesn't sound easy. Read on.
    
page|Read Page 4|Page 4\n\nThe next page delves into the importance of personal sacrifice. For this ritual, the required sacrifice is large. A cold chill runs down your spine as you realize that only a precious loved one is enough. <i>What kind of monster could do such a thing?”</i> you wonder to yourself. The first time this is read, suffer 1 Horror ({will} negates), then gain 2 {clue} if you don't go Insane.
	test|journalReadPage4,==,1|Page 4\n\nThe next page delves into the importance of personal sacrifice. A cold chill runs down your spine as you realize that only a precious loved one is enough. <i>The boy from the journal!</i> you think to yourself. <i>He's here somewhere and we're going to find him.</i>\n\n The first time this is read, suffer 1 Horror ({will} negates), then gain 2 {clue} if you don't go Insane.
    toc|Each tool seems to need special attention. This will require more study.
    
page|Read Page 5|Page 5\n\nThe next page is where the power of the ritual starts to become clear. This page talks about an incantation that begins manifesting the portal in the sacrifice. The revulsion you feel steels your resolve to prevent this from happening again.\n\nWhen you get to the incantation, you realize it is written in the same language as the blessing. You think back to that margin scrawl and wonder if you'll be able to understand it later.
    toc|What kind of monster could kill a child for this? But there's still more.
    
page|Read Page 6|Page 6\n\nOnce the portal has manifested, it is weak and unstable. As you read further, the book discusses affixing the elder sign to the portal to stabilize it and hold it open. There is a also something about feeding the elder sign with additional sacrifice, but it isn't clear to you what that means. The book describes the artifact in great detail and how it is used in the ritual. A picture clearly shows what it looks like. The incantation itself is in the same language as the other two. You wonder if your father knew what he was talking about in the front of the book. Gain 2 {clue} the first time you read this page.\n\nYou'll keep an eye out as you wander the house. You must find this artifact before your uncle does if you are going to stop him. \n\nThe first time this is read, something falls out of the book as you turn the page:  gain the {c:QItemSpells} spell and 1 {clue}. 
    toc|You hope the margin scrawl in the cover of the book helps is right--daggers and sacrifice are one thing, but the incantation is unreadable. You also wonder where your uncle might be performing the ritual. There are two more entries.

page|Read Page 7|Page 7\n\Finally, there is commentary and advice. One section discusses ley lines and how they allow you to draw more power for the ritual. The preferred date and time for the ritual is also discussed, with a full moon being the most important.\n\nIn the margin are notes about a place under the house that aligns with a ley line; there is also a list of years that would be good for the ritual.
	test|journalReadPage4,==,1|Page 7\n\Finally, there is commentary and advice. One section discusses ley lines and how they allow you to draw more power for the ritual. The preferred date and time for the ritual is also discussed, with a full moon being the most important.\n\nIn the margin are notes about a place under the house that aligns with a ley line; there is also a list of years that would be good for the ritual. <i>The boy must be down there,</i> you think to yourself.
    toc|It sounds like even more blood is required, and for a moment you wonder where it will come from. Then you remember the journal:  it's you. This is the last page of the ritual.
    operations|@FoundCellHoleViaJournal,=,1 
    
end|<i>Maybe I need to explore a bit more to figure out what I need to do to stop this madness,</i> you think to yourself.
    test|exploredTortureChamber,==,1|Now you know where the ritual will be performed and what is needed. You must stop your uncle!
    test|readJournalPage4,==,1|You cannot allow a young boy to be sacrificed for this evil. You must find the artifacts before the townspeople do and, now that you think you know where the boy is, get him out of here too.

# ----------------------------------------------------------------------------------
# use this to manage Sarah's commentary and make it work across scenarios
# TOC: There are no TOC entries and this is ordered|nokeep:  this means the next page will be read each time it is opened
# The default page text entries for goal == goalStopRitual
# Note that the 'visible' directives may change during the game, so pages with visibility rules might show out of order if the expression changes

book|SarahPatter|ordered|nokeep

page|dvm|Sarah whispers to {c:EventChosenInvestigator}, “The {c:QItemDVM} is a spell book. It contains many powerful spells, including how to open and close portals, and how to interrupt a ritual that has been started. If you cannot stop {c:CustomMonsterDavidSmythe} in time, you may need to perform a closing ritual. Closing portals is easier than opening them but it takes time. With the portal open, many horrors could come through while you are trying to close it. You must be prepared. Read the book carefully and read it soon.”
	visible|foundDVM
	test|goal,==,goalRescueBoy|Sarah whispers to {c:EventChosenInvestigator}, “The {c:QItemDVM} is a spell book. It contains many powerful spells, including how to open and close portals. You should read it to better understand what is happening.”
	test|goal,==,goalStopCultists|Sarah whispers to {c:EventChosenInvestigator}, “The {c:QItemDVM} is a spell book. It contains many powerful spells, including how to open and close portals, and how to interrupt a ritual that has been started. I can feel our uncle's rage. He needs this book to open the portal, and tonight is his only chance to open it. We must be careful to keep it from his minions.”

page|candles|Sarah whispers to {c:EventChosenInvestigator}, “There’s a part of the house that is too dark to enter without light. The candles you found should help. If we move fast enough, maybe we can stop {c:CustomMonsterDavidSmythe} from opening the portal.”
	visible|foundCandles
	test|goal,==,goalRescueBoy|Sarah whispers to {c:EventChosenInvestigator}, “There's a part of the house that is too dark to enter without light. The candles you found should help. You should explore down there as soon as you can.”
	test|goal,==,goalStopCultists|Sarah whispers to {c:EventChosenInvestigator}, “There's a part of the house that is too dark to enter without light. The candles you found should help. You should explore down there as soon as you can.”

page|elder sign pendant|Sarah whispers to {c:EventChosenInvestigator}, “The {c:QItemElderSignPendant} is the most important part of the closing ritual. It seals the portal permanently. When the closing ritual was performed 10 years ago, our Uncle Henry was able to close the portal, but he died before he could seal it.”
	visible|foundElderSignPendant
	test|goal,==,goalRescueBoy|Sarah whispers to {c:EventChosenInvestigator}, “The {c:QItemElderSignPendant} is important for their plans tonight. It is used to either secure or close a portal. It is good we found it before they did.”
	test|goal,==,goalStopCultists|Sarah whispers to {c:EventChosenInvestigator}, “The {c:QItemElderSignPendant} is an important part of the opening ritual. If used correctly, it will hold the portal open indefinitely. When the opening ritual was performed 10 years ago, our Uncle Henry stopped it before the portal could be secured. Without the {c:QItemElderSignPendant}, the portal will require endless sacrifice to remain open.”

page|ritual components|Sarah reaches out as if to touch the {c:QItemRitualComponents} you found. “I recognize some of these items from the portal ritual. Both my father and the men who tried to stop my father brought similar items to help with the spells.”
	visible|foundRitualComponents

page|journal|Sarah looks down and sees you holding the {c:QItemJournal}. “The {c:QItemJournal}! I think its owner wrote down what is happening this week. You should read it carefully.”
	visible|foundJournal

page|1|Sarah whispers to {c:EventChosenInvestigator}, “You don’t remember me or what happened 10 years ago. I am your little sister.\n\n“I will tell you everything you need to know, but first I must tell you that {c:CustomMonsterDavidSmythe} will open a portal tonight and you must stop him; if you cannot stop him, you will need to close it.”
	test|goal,==,goalRescueBoy|Sarah whispers to {c:EventChosenInvestigator}, “You don’t remember me or what happened 10 years ago. I am your little sister.\n\n“I will tell you everything you need to know, but first I must tell you that {c:CustomMonsterDavidSmythe} will open a portal tonight. You must stop him.”
	test|goal,==,goalStopCultists|Sarah whispers to {c:EventChosenInvestigator}, “You don’t remember me or what happened 10 years ago. I am your little sister.\n\n“I will tell you everything you need to know, but first I must tell you that {c:CustomMonsterDavidSmythe} will open a portal tonight. You must stop him from making it permanent.”
    
page|2|Sarah whispers to {c:EventChosenInvestigator}, “The people in this town worship a darker god than most. Most of them want to bring their god to Earth. 10 years ago, my father cast a ritual to summon It. He opened a portal. The power it possessed was breathtaking and I was powerless to stop it. Somehow, Father summoned local townsfolk through the portal to protect his work, even after he was dead. As the portal, I could feel people and monsters approaching and passing through me from the other side.”

page|3|Sarah whispers to {c:EventChosenInvestigator}, “I could feel the god approach from the other side. Suddenly, a group of men broke into the altar chamber and began fighting the locals. One man went to the altar, killed our father, laid out some materials, and spoke words I didn’t understand. He closed the portal while his friends protected him from what came through it.”
    
page|4|Sarah whispers to {c:EventChosenInvestigator}, “Father believed that personal sacrifice was the most powerful magic. The portal is created by binding power to the body of a loved one. Father used me to summon the portal. The monsters came through me. When the portal closed, I died with it. The pain of the ritual so engulfed me that I can still feel it.”
    
page|5|Sarah whispers to {c:EventChosenInvestigator}, “You found out what was going to happen a week before the ritual. Members of Father’s church did something to you. After that, you followed orders without question. You helped Father bind me during the ritual. From what they said at the time, you probably cannot remember anything about the ritual or even before then. It's why you don't know who you are or remember what happened that night.”
    
page|6|Sarah whispers to {c:EventChosenInvestigator}, “The day of the ritual, two of my friends came to visit me. When Father told them I wasn’t allowed out, they sneaked to my window and jumped in when I opened it. Father was furious. I’m not sure who strangled them or who dragged them to the yard. I was burned alive when the portal closed, then my body was dumped with my friends'. It wasn't until then that I knew they were dead.”
    
page|7|Sarah whispers to {c:EventChosenInvestigator}, “I don’t know who the other men were, but the one who closed the portal was our uncle--Father’s brother. I think there’s something special about our family; there are things only we can do. It’s why Father could summon the portal, and why Uncle Henry could close it.\n\n“You should share the family abilities. You must trust yourself to know what to do.”

# ----------------------------------------------------------------------------------
# this is the ritual for goalStopRitual


# skillcheck|{number | passfail }  If number, this sets a quota; otherwise, it shows Pass/Fail buttons
#			For quotas, the readPageN variable is not set until the quota passes
#			For passfail, there are two other directives that can be used:
#				pass|eventname		gives the name of the event it branches to if the test passes
#				fail|eventname		same as pass, but if the test fails

book|DVMRitual|ordered|nokeep
	line|conditions=goal,==,goalStopRitual ritual,>,0 davidDead,>,0

page|start|The portal is open and you must close it quickly. If you have the {c:QItemRitualKnife}, the {c:QItemRitualComponents}, and the {c:QItemElderSignPendant}, you can start now.\n\nOnly {c:EventChosenInvestigator} can perform this ritual and only while standing at the altar. Are you ready to begin?
	continue|step1

page|step1|You turn to the correct place in the book and lay out the materials on the altar. The pattern is complicated and it takes a few minutes to get right. Your companions are under constant attack by cult members and you can feel the approach of something from the other side. You have to hurry.\n\nDrop the {c:QItemRitualComponents} Unique Item on the altar. It must stay on the altar for the duration of the ritual.\n\nThis step is complete.
	line|add=QItemRitualComponents
	freeaction
	continue|step2

page|step2|You bring out the {c:QItemRitualDagger}. There is a blessing to speak while holding it. You weren't able to read it before, but as your father wrote, you are able to read it now. That said, you aren't sure if you understand it; if you do, test {lore]; otherwise, test {will} to blunder through and hope for the best. For each Unique Item you have, you may roll 1 extra die.
	line|add=QItemRitualDagger

	# this turns the dialog into a test; if 'passfail' is given, then it's a one-time thing, but if it's a number, it sets a quota
	# the readPageN variable is not set on a quota until it is passed
	skillcheck|3
	pass|step2pass
	fail|step2fail

page|step2pass|As you repeat the incantation, the blade becomes heavier and brighter. The {c:QItemRitualKnife} is ready for what comes next.\n\nThis step is complete.
	line|add=QItemRitualDagger
	freeaction
	goto|step3

page|step2fail|You keep repeating the incantation but the {c:QItemRitualDagger} doesn't change. You'll need to keep trying.\n\nSuffer 1 facedown Damage and 1 facedown Horror ({will} negates either).
	line|add=QItemRitualDagger
	freeaction
	goto|step2

page|step3|You draw the knife across the palm of your hand. A drop of blood wells up and you suddenly wonder if you've drawn enough. Even what you've drawn is making you queasy ({will}). For each Unique Item you have, you may roll 1 extra die.
	line|add=QItemRitualDagger
	skillcheck|4
	pass|step3pass
	fail|step3fail

page|step3pass|You squeeze your hand into a tight fist and blood drips into the chalice. You can't see or hear the chalice change, but you can feel something happen to it.\n\nThis step is complete.
	line|add=QItemRitualDagger
	freeaction
	goto|step4

page|step3fail|A drop of blood spatters when it hits the cup, but nothing seems to happen. You're going to have to slice deeper. Suffer 2 Horror ({will} negates).
	line|add=QItemRitualDagger
	freeaction
	goto|step3
	
page|step4|You can read the first incantation but you aren't sure that you understand it; if you do, test {lore}; otherwise, test {will} and hope for the best. You may roll 1 extra die for each Unique Item you have.
	line|add=QItemDVM
	skillcheck|5
	pass|step4pass
	fail|step4fail

page|step4pass|You feel a welling of power as you speak the last word. The feeling inside you grows and you suddenly feel like you control the cosmos. The portal grows brighter and {c:TokenPortal} screams. You had forgotten about the boy--he will die in this ritual. Suffer 1 facedown Horror.\n\nAs the scream echos in the room, the portal grows dimmer and shrinks slightly. Where it was humming and stable before, it is sputtering, pulsing, and making an electrical sound. It has been weakened, but not closed. It will eventually collapse on its own, but you can do better.\n\nThis step is done.
	line|add=QItemDVM
	freeaction
	goto|step5

page|step4fail|You can feel something happen inside but it is not very strong and the portal has not changed. You'll have to try the incantation again.\n\nThe ritual is wearing you down. Suffer 1 facedown Damage and 1 facedown Horror ({strength} negates).
	line|add=QItemDVM
	freeaction
	goto|step4
	
page|step5|Now you need to draw more blood. You look at your hand and see that it has stopped bleeding. Cutting yourself again will take great courage. Test {will}. For each Unique Item you have, you may roll 1 extra die.
	line|add=QItemRitualDagger
	skillcheck|6
	pass|step5pass
	fail|step5fail

page|step5pass|You feel a welling of power as you speak the last word. The feeling inside you grows and you suddenly feel like you control the cosmos. The portal grows brighter and {c:TokenPortal} screams. You had forgotten about the boy--he will die in this ritual. Suffer 1 facedown Horror.\n\nAs your last word echos in the room, the portal grows dimmer and shrinks slightly. Where it was humming and stable before, now it sputters and pulses. It has been weakened, but not closed. It will eventually collapse on its own, but you can do better.\n\nThis step is done.
	line|add=QItemDVM
	freeaction
	goto|step6

page|step5fail|A single drop rises from the new slice but doesn't fall. You'll have to try again. Suffer 1 Horror ({will} negates).
	line|add=QItemDVM
	freeaction
	goto|step5
	
page|step6|As the portal weakens, the boy regains some strength. He is screaming in pain and terror again.\n\nYou must get this last part right to close and seal the portal. You look at the last incantation and, like the others, while you can read it, you aren't sure you understand it. If you do, test {lore}; otherwise, test {will} to muddle through. You may roll 1 extra die for each Unique Item you have.
	line|add=QItemDVM
	skillcheck|7
	pass|step6pass
	fail|step6fail

page|step6pass|As you complete the incantation, the portal and the {c:QItemElderSignPendant} continue pulsing together. The pendant rises into the air and slowly approaches the portal. The boy screams one last time as the elder sign makes contact with his forehead. The boy goes rigid, then the portal collapses and the boy falls to the ground dead.\n\nThe investigation is over.
	line|add=QItemDVM
	freeaction
	operations=result,=,fullWin
	goto|EventGameOverStart

page|step6fail|The boy is still screaming and the portal is still open. You know you are close, but you have to keep trying.\n\nSuffer 1 Damage and 1 Horror.
	line|add=QItemDVM
	freeaction
	goto|step6
	
# For goal == goalStopCultists
# this is run during the Mythos phase when the end-game starts

book|StopCultistsRitual|ordered|nokeep

#page1
page|ritualStarts|You freeze as something... <i>happens</> to the house. You aren't sure what it is, but fear clutches your gut as the feeling washes over you.\n\nThen, from deep in the house, you hear a boy screams in pain and terror. He stops abruptly and you feel something in the air, like electricity. The house shudders and everything goes quiet. Sarah's eyes widen and she whispers to {c:EventChosenInvestigator}, “He’s started. The ritual has started. We have to get to the {c:TileAltar} and stop Cousin David.”\n\nAs she finishes, a townsperson in cult robes runs by you, heading toward the altar.”\n\nSarah lights up. “We have the {c:QItemElderSign}. Without it, {c:CustomMonsterDavidSmythe} needs constant sacrifice to keep the gate open. We must kill his followers before they reach him.”
	
#page2
page|womanDies|You feel the power of the spell {c:CustomMonsterDavidSmythe} is casting. It both draws you closer and repulses you. A woman screams. The sound pierces the walls of the house, making the windows vibrate in their frames. You feel her take a deep, gasping breath, then she screams again. And again. And again. The screams send a chill through your gut. Each investigator takes 2 Horror ({will} negates).\n\nSarah whispers, “We need to find the ritual and stop {c:CustomMonsterDavidSmythe}.”

#page3
page|portalOpens|The woman’s screaming has stopped and, for a moment, it is silent again... as if the house were taking a breath. Then, though you cannot see it, you can feel the portal spring into being. You hear… <i>something</> moan in pain; you feel the vibrations of it through the house. You know in your gut it’s {c:CustomMonsterDavidSmythe}’s son.\n\nThe feeling of power grows stronger; it radiates through the floorboards and moves through the walls. Sarah whispers, “The portal is open, we have to stop him.”\n\nAs she speaks, another cultist brushes past you, heading toward the ritual.”
	line|operation=stopCultistsKillCount,=,0 stopCultistsKillGoal,=,2 stopCultistsKillGoal,*,#investigators stopCultistsKillGoal,+,2 stopCultistSacrificed,=,0 stopCultistsDavidContinues,=,#rnd3

#page4
page|davidContinues|Sarah whispers, “We must hurry. What he is summoning is getting closer. I can feel it.”
	test|stopCultistsDavidContinues,==,2|The house pulses with power, overwhelming you for a moment. You snap back to awareness as a cultist approaches. You ready yourself for another attack.
	test|stopCultistsDavidContinues,==,3|You stop for a moment and wonder, <i>How many cultists do we have to kill?! We've already killed {stopCultistsKillCount}.</i> Out of the corner of your eye you see another one coming. It's time to get back to work.
	operations|stopCultistsDavidContinues,=,#rnd3 readStopCultistsRitualPage5,=,0

#page5
page|repeatDavidContinues|
	# we are setting this page and previous one to unread (yeah, it's really unclean this way:  maybe add 'clear|davidContinues' as a command?
	operations|readStopCultistsRitualPage4,=,0 readStopCultistsRitualPage5,=,0
	goto|davidContinues

# for goal == goalRescueBoy
# this is run during the Mythos phase when the end game starts

book|RescueBoy|ordered|nokeep

#page1
page|startRescue|Sarah whispers to your nephew, “Let's head to the chapel to get you out.” She turns to you and says, “Let's go. We don't have much time before the boy is missed.”

#page2
page|hurryUp|Sarah hisses into your ear, “Hurry. {c:CustomMonsterDavidSmythe} will come looking for us soon.”
	line|conditions=exploredChapelViaCrypt,>,0 explored

#page3
page|clearChapel|You hear men approaching the chapel door. Everyone there runs; move any investigators in the {c:TileChapel} to the {c:TileCrypt}. Clear all Search, Explore, and Interact tokens from the {c:TileChapel}, then place a Sight token as indicated.

