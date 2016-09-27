const Elm = require('../../elm/src/Main');

const elmDiv = document.querySelector('#main_container');

if (elmDiv) {
  Elm.Main.embed(elmDiv);
}