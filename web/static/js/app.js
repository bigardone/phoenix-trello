const Elm = require('../../elm/src/Main');

const elmDiv = document.querySelector('#main_container');

if (elmDiv) {
  const jwt = localStorage.getItem('phoenixAuthToken');
  const app = Elm.Main.embed(elmDiv, { jwt: jwt });

  app.ports.saveToken.subscribe((token) => localStorage.setItem('phoenixAuthToken', token));
  app.ports.deleteToken.subscribe(() => localStorage.removeItem('phoenixAuthToken'));
}
