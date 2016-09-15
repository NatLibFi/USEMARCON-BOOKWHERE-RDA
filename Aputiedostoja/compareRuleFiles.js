/* jshint node: true */

"use strict";

let fs = require("fs");
let _ = require("underscore");

let bib = fs.readFileSync("ma21RDA_bibl.rul", "utf-8").split("\n");
let aukt = fs.readFileSync("ma21RDA_aukt.rul", "utf-8").split("\n");

function trimArray(array) {
  return _.filter(_.map(array, i => i.trim()), x => x.length > 10);
}

function getKeys(array) {
  return _.map(array, i => i.substr(0,9));
}

function toObject(array) {
  return _.object(getKeys(trimArray(array)), trimArray(array));
}

const bibObject = toObject(bib);
const autkObject = toObject(aukt);

let out = fs.createWriteStream("tableComparison.log");

for (let key in autkObject) {
  if (bibObject[key] !== autkObject[key]) {
    let line = "Mismatch in rule files:\nBibliographic:\n" + bibObject[key] + "\nAuthority:\n" + autkObject[key] + "\n--------------------\n";
    console.log(line);
    out.write(line);
  }
}
