Noteminder - My Simple Notes & Reminders App

Hi there! 👋

I was so tired of jumping between my Notes app and my Reminders app just to keep track of one idea. So, I decided to build my own solution: Noteminder.

It's a native iOS app that combines a simple, freeform note-taking area with a real, actionable reminder system. The whole point is to have one single, clean place to write down your thoughts and assign a due date. This project is my journey into learning native iOS development, built from scratch using SwiftUI and SwiftData.

What's Under the Hood? (The Tech & Features)

This app might look simple, but there's a ton of stuff going on to make it work. I focused on using Apple's most modern frameworks to build it right. Here’s a breakdown of the key pieces I put together:

TabView (The Bottom Navigation Bar)
This is the classic bottom tab bar. It's the app's main navigation, letting you quickly hop between your main item list and the search page.

SwiftData (The Brains of the App)
This was the big one! Instead of just using fake "dummy" data, this app uses SwiftData to actually save, edit, and delete every item.

@Model: I basically created a "blueprint" called TodoItem that tells SwiftData what to save (the title, body, due date, etc.).

@Query: This is pure magic. It's a "live list" that just grabs all the items from the database and automatically updates the screen if anything changes.

modelContext: This is my "database manager." It's the tool I use to actually make changes, like modelContext.insert(newItem) or modelContext.delete(item).

Smart Sections (Just like the real Reminders App)
I didn't want one giant, messy list. So, I wrote filtering logic to automatically sort all the open tasks into helpful sections like "Due Today," "Due Tomorrow," "Upcoming," and "No Date." It makes it so much easier to see what's important.

NavigationStack & List
This is the classic combo for any iOS app. It's what lets you tap an item in the list and "push" to the detail/edit screen.

An Explicit "Save" Button (The "Safe" Edit)
This was a big one for me. I hate when apps save too fast and you make a mistake. Here, when you edit an item, the app uses @State to make a temporary copy. It only saves your changes back to the database when you actually hit that Save button. (This screen also has the Delete button, of course!)

searchable (The Search Tab)
I got this feature almost "for free" thanks to SwiftUI. It's a built-in tool that hooks right into my SwiftData @Query to filter the entire database in real-time, as you type.

My Journey & Thanks

Starting this project as a total beginner... was a lot. It was definitely ambitious, but building this app step-by-step, feature-by-feature, has been the most incredible way to learn. I've gone from a blank screen to a real, working app that I can actually use, and that feels amazing.

I couldn't have figured this all out by myself. I want to give a huge, genuine thanks to all my mentors and the people who helped me when I got stuck, answered my (many) questions, and kept me going.

A very special and personal thanks to Matteo Altobello. Your patience and willingness to teach me not just the "how" but the "why" made all the difference. Thank you for guiding me through this process and helping me turn an idea into a real product.
