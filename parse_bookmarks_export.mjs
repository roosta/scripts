#!/usr/bin/env node

// Parse chrome bookmark json, it looks for a folder in the bookmark_bar that
// is called capture. It'll go through each outputting to stdout each bookmark
// as a markdown formatted string.

// Rationale: I don't main google-chrome, I use it on some other machines, and
// sometimes I stuble on something interesting in chrome I'd like to put in my
// notes, so I put it in a folder called capture to be processed later. Using
// this script I can save script output in my notes (markdown)

import fs from "node:fs";

const home = "/home/roosta"

function loadJSON(file) {
    let data = fs.readFileSync(file);
    return JSON.parse(data);
}
const bookmarks = loadJSON(`${home}/.config/google-chrome/Default/Bookmarks`);
const capture = bookmarks.roots.bookmark_bar.children.find(x => x.name === "capture").children;

capture.forEach(x => {
  console.log(`[${x.name}](${x.url})`)
})

