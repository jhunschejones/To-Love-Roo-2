# To Love Roo (v2)

## Overview
This repo houses a lightweight web app featuring Sinatra 2 and ActiveRecord 6. It's a re-build of a fun little project that I used to leave notes for my partner when we're working from different locations, and we've been joying it very much!

## Lessons learned
I've worked on a several Rails codebases lately and wanted to take a detour into Sinatra-land to see how realistic this lighter framework could be for building a real web application. This notes app seemed the perfect opportunity to do this since it needed a re-build pretty badly and since the small domain scale made Rails seem like overkill.

I've used Sinatra for test apps a time or two, and I've helped maintain a couple larger legacy Sinatra codebases at work. Going into this project, I knew Sinatra was not going to come out of the box with everything I needed, like Rails does, and that this would mean I would spend some time jiggering the pieces together to get both a working development environment and a fully featured app.

To my surprise, there was plenty of documentation and tooling available to accomplish just what I needed! I had to learn almost all of it as I went along, but I was able to get where I needed to go. The final project has basic server-side code reloading, DB migrations and seeds, basic user authentication, integration with some of my go-to Ruby web libraries like ActiveRecord and Puma, and a decently intuitive project structure with my go-to scripts for quickly running the app or test suite. To top it off, I brought in rspec to write my controller tests, and found I was able to get the whole package working together in a relatively short timeframe!

The original app I was re-building here makes loose use of the Vue.js framework via CDN to spice up the note page. I re-created the word-counter and other functionality in an ejs template without much hassle, and found Vue pretty fun to work with again in this capacity. The actual "heavy-lifting" the framework is doing for me could be replaced with a spot of custom JS for sure, but it just felt right to leave the original heart in the app as I moved it over to this new body. _(I also updated the UI from Bootstrap to Bulma, my current go-to for basic UI components in project apps.)_

## Reflections
It's great to be more comfortable with another Ruby web framework, especially one that feels so capable of bridging the gap between a basic Rack app and a full-blown Rails app. I would definitely come back again to build in Sinatra if I encountered a domain of the right scale, and I've already taken advantage of some of the approaches I learned building this app to create some cool testing APIs at work! I'd call that a win-win in my book.
