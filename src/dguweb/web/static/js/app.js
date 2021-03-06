// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import "phoenix_html"

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"


const searchBoxElement = document.querySelector('#search-box');

if (searchBoxElement) {
  var searchBox = searchBoxElement.querySelector('input')
  var searchQuery = searchBox.value;
  var placeholder = searchBox.getAttribute('placeholder');
  searchBoxElement.innerHTML = '';
  const searchBox =
    Elm.SearchBox.embed(
      searchBoxElement,
      { initialSearchQuery: searchQuery, placeholder: placeholder }
    );

  // called when return key hit in the form
  searchBox.ports.hitReturn.subscribe(selector => {
    const nodes = document.querySelectorAll(selector);
    if (nodes.length === 1 && document.activeElement !== nodes[0]) {
      nodes[0].click();
    } else {
      document.querySelector('#search-form').submit();
    }
  });
}