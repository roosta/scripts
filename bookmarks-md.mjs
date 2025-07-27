#!/usr/bin/env node
// Copyright (c) 2025 Daniel Berg <mail@roosta.sh>
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of
// this software and associated documentation files (the "Software"), to deal in
// the Software without restriction, including without limitation the rights to
// use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies
// of the Software, and to permit persons to whom the Software is furnished to do
// so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
// BEGIN_DOC
// ### [bookmarks-md.mjs](./bookmarks-md.mjs)
//
// Parse chrome bookmark json, it looks for a folder in the bookmark_bar that
// is called `capture`. It'll go through each outputting to stdout each bookmark
// as a markdown formatted string.

// Rationale: I don't main google-chrome, I use it on some other machines, and
// sometimes I stuble on something interesting in chrome I'd like to put in my
// notes, so I put it in a folder called `capture` to be processed later. Using
// this script I can save script output in my notes (markdown)
//
// Usage
// ```sh
// node bookmarks-md.mjs
// ```
// 
// License [MIT](./LICENSES/MIT-LICENSE.txt)
// END_DOC

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

