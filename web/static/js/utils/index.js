import fetch from 'isomorphic-fetch';
import {polyfill}   from 'es6-promise';

polyfill();

export function getParentKey(key) {
  const parsedKey = key.match(/(.*)\..+/);
  return parsedKey ? parsedKey[1] : null;
}

export function checkStatus(response) {
  if (response.status >= 200 && response.status < 300) {
    return response;
  } else {
    var error = new Error(response.statusText);
    error.response = response;
    throw error;
  }
}

export function parseJSON(response) {
  return response.json();
}

export function httpGet(url) {
  const authToken = localStorage.phoenixAuthToken;

  return fetch(url, {
    headers: {
      Authorization: authToken,
      Accept: 'application/json',
      'Content-Type': 'application/json',
    },
  })
  .then(checkStatus)
  .then(parseJSON);
}

export function httpPost(url, data) {
  const authToken = localStorage.phoenixAuthToken;
  let body;
  let headers;

  if (data instanceof FormData) {
    body = data;
    headers = {};
  } else {
    body = JSON.stringify(data);
    headers = {
      Accept: 'application/json',
      'Content-Type': 'application/json',
    };
  }

  return fetch(url, {
    method: 'post',
    headers: { ...headers, Authorization: authToken },
    body: body,
  })
  .then(checkStatus)
  .then(parseJSON);
}

export function httpDelete(url) {
  const authToken = localStorage.phoenixAuthToken;

  return fetch(url, {
    method: 'delete',
    headers: {
      Authorization: authToken,
      Accept: 'application/json',
      'Content-Type': 'application/json',
    },
  })
  .then(checkStatus)
  .then(parseJSON);
}

export function setDocumentTitle(title) {
  document.title = `${title} | Phoenix Trello`;
}
