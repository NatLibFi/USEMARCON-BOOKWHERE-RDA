 /* jshint node: true */

// The script takes an Aleph check_doc_line -file as an input and gives a Usemarcon Format Checking Table (.chk) file as an output
'use strict';

var fs = require('fs');
var readline = require('readline');
var inputFile = process.argv[2];
var outputFile = process.argv[3];

var preamble = 'Format checking file for MARC 21 (RDA) Authority Records - generated on ' + new Date() + '\n\n'; 

if (!inputFile || !outputFile) {
  console.log('Usage: node createFormatCheckingTable.js inputfile outputfile');
  process.exit();
}

var rl = readline.createInterface({
  input: fs.createReadStream(inputFile)
});

var out = fs.createWriteStream(outputFile);
out.write(preamble);

rl.on('line', function (line) {
  if (line.indexOf('AL XX') === 0) {
    splitString(line, processLine);
  }
}).on('close', function () {
    console.log('Done!');
});

function splitString(line, callback) {
  var lineData = {};
  lineData.field = line.substring(11,14);
  lineData.col5 = line.substring(17, 18);
  lineData.col6 = line.substring(19, 20);
  lineData.col7 = line.substring(21, 22);
  callback(lineData);
}

// Kootaan kentän tiedot muuttujaan, kirjoitetaan ulos ja alustetaan kentän vaihtuessa

var currentField = {
  'field': '',
  'I1': '',
  'I2': '',
  'subfields': ''
};

function processLine(dataObject) {
  // Kenttä vaihtuu
  if (currentField.field !== dataObject.field) {
    flushData();
    currentField.field = dataObject.field;
  }
  if (dataObject.col5 === '-') {
    if (dataObject.col6 !== ' ' && currentField.I1.indexOf(dataObject.col6) < 0) { currentField.I1 += dataObject.col6; }
    if (dataObject.col7 !== ' ' && currentField.I2.indexOf(dataObject.col7) < 0) { currentField.I2 += dataObject.col7; }
    if ((dataObject.col6 === ' ' || dataObject.col6 === '') && currentField.I1.indexOf('_') < 0) { currentField.I1 += '_'; }
    if ((dataObject.col7 === ' ' || dataObject.col7 === '') && currentField.I2.indexOf('_') < 0) { currentField.I2 += '_'; }
  }
  if (dataObject.col5 !== '-') {
    currentField.subfields += ' | $' + dataObject.col5 + determineIfMandatory(dataObject.col6, dataObject.col7);
  }
}

function determineIfMandatory(code1, code2) {
  if (code1 === '0' && /[023456789-]/.test(code2)) { return '*'; }
  if (code1 === '0' && code2 === '1') { return '?'; }
  if (code1 === '1' && code2 === '1') { return '_'; }
  if (code1 === '1' && /[023456789-]/.test(code2)) { return '+'; }
}

function flushData() {
  if (/[0-9]/.test(currentField.field)) {
    out.write(currentField.field);
    if (currentField.field === '100') { out.write('_'); } else { out.write('*'); }
    out.write(' | I1=' + currentField.I1 + ' | I2=' + currentField.I2 + currentField.subfields);
    out.write(' |\n\n');
  }
  currentField = {
    'field': '',
    'I1': '',
    'I2': '',
    'subfields': ''
  };
}