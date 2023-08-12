#!/usr/bin/env node

import fs from "node:fs";

function loadJSON(file) {
    let data = fs.readFileSync(file);
    return JSON.parse(data);
}

const bookmarks = loadJSON("/home/roosta/.config/google-chrome/Default/Bookmarks");
console.log(bookmarks);
