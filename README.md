# revenue-leak-detection

## Summary
Companies lose money all the time because their systems don't talk to each other correctly. A customer might pay on the Website, but the Database forgets to mark them as "Paid," or an App glitch charges someone $0 by mistake.
This system is designed to scan through over 1 million rows of data to find those leaks and get that money back.

## How it works
I seek to actually track the life of every payment by:
Checking if what we billed matches what was actually paid.
Identifying the "Where". Using source_system, I can tell if the errors are coming from the App, the Website, or Stripe
Knowing the "When". Using batch_id, I keep every data upload organized. If an upload fails, I can delete it and fix it without messing up the rest of the records

## Some features
I designed the tables to handle a massive amount of data without crashing
I use soft deletes using the "is_active" columns. In a real audit, we rarely delete data because we need to see the history of every customer to find patterns. (unless legally required to do so)
This entire project is built using free tools, proving you don't need a huge budget to solve a million dollar problem




