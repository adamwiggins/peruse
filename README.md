Peruse, a feed reader for finding something good to read
========================================================

If you are 1. a hacker and 2. have nearly given up on reading news RSS because
all feed readers suck, then Peruse may be for you.  Read on.

The problem
-----------

Most feed readers (such as the most popular, Google Reader) have some problems:

* They look and act like inboxes.  Showing unread counts makes you feel like
reading news is a task to be accomplished, rather than a relaxing passtime to
be done as little or as much as you like.
* They don't automatically learn what you like and dislike.  Amazon and Netflix
are smart enough to tailor your experience based on what you've enjoyed in the
past, why not your feed reader?
* Feeds with high volume tend to drown out feeds with low volume.  Daring
Fireball or Megan McArdle, good as they are, end up drowning out Paul Graham
essays due to the relative frequency of posts.  If I've got fifty unread
articles from Daring Fireball and one unread article from Paul Graham, I don't
want to have a miniscule 1/51 chance of reading the latter.
* They are not accessible on multiple devices.  Desktop feed readers don't help
you when you're on the go (the main time I want to read feeds); mobile readers
can't be accessed on your main system.
* Google Reader, a web app, can be accessed from both desktop and mobile.  But
it's gotten so javascript heavy that it loads slowly when cell receiption is
weak, and clutters the screen with widgets.

The solution
------------

Peruse is my solution.  Is it yours?  See if you agree with my approach:

* Peruse doesn't have any direct way to view the number of unread articles or
feeds.
* You train Peruse over time by rating posts thumbs up, meh, or thumbs down.
Highly rated feeds will show posts more often.  Low-rated feeds will show posts
less and less, until some point they stop appearing altogether.
* Peruse first picks a feed to show an article from, then an article from that
feed's unread list.  Number of unread posts in the feed matters not at all as
long as there is at least one unread post in each.
* Peruse has an extremely simple, streamlined web interface.  It's fast to load
and does not use any ajax.  C'mon, it's the digital equivalent of a newspaper.
It doesn't need to be complicated.
* Peruse is a Sinatra app which you can run locally (if you like) or deploy to
someplace on the Internet to access from anywhere (recommended).  It doesn't
have multi-user capability; this is intended for one user, a hacker who
considers running a Ruby web app a completely ordinary thing to do.

Try it out
----------

    git clone git://github.com/adamwiggins/peruse.git
    cd peruse
    bundle install
    rake db:migrate
	 bundle exec stalk jobs.rb &
	 bundle exec clockwork clock.rb
    bundle exec thin start

Browse to: http://localhost:3000/  You can now add some feeds manually, or
import an OPML file.  Instructions are in the app for importing from Google
Reader.

Ratings
-------

Rating options are presented at the bottom of each article:

Thumbs up - Select if you found the article enjoyable, enriching, or
thought-provoking.  It means "more like this in the future."

Meh - Select if you found the article boring or otherwise lacking in new
information or intellectual stimulation.  It means "this is filler, in the
future I only want to read something like this if there's nothing better to be
had."

Thumbs down - Select if you found the article completely lacking in anything of
interest or otherwise meriting your attention.  It manes "don't bother me with
things like this in the future."

No opinion - Select if you don't feel like stating an opinion, you just want to
mark it read and get something else to read.  Won't affect articles you are
given in the future.

