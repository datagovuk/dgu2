exports.config = {
  // See http://brunch.io/#documentation for docs.
  files: {
     javascripts: {
       joinTo: {
         "js/app.js": /^(web\/static\/js)|(node_modules)/,
         "js/jquery.min.js": ["web/static/vendor/jquery.min.js"],
       }
     },
    stylesheets: {
       joinTo: {
         "css/app.css": /^(web\/static\/css)/,
       },
       order: {
         after: ["web/static/css/app.css"] // concat app.css last
       }
     },
    templates: {
      joinTo: "js/app.js"
    }
  },

  conventions: {
    // This option sets where we should place non-css and non-js assets in.
    // By default, we set this to "/web/static/assets". Files in this directory
    // will be copied to `paths.public`, which is "priv/static" by default.
    assets: /^(web\/static\/assets)/,

    // Don't compile the js files elm produces as side-effects
    ignored: [ /^(web\/static\/elm\/elm-stuff)/ ]
  },

  // Phoenix paths configuration
  paths: {
    // Dependencies and current project directories to watch
    watched: [
      "web/static/",
      "test/static"
    ],

    // Where to compile files to
    public: "priv/static"
  },

  // Configure your plugins
  plugins: {
    babel: {
      // Do not use ES6 compiler in vendor code
      ignore: [/web\/static\/vendor/]
    },
    elmBrunch: {
      mainModules: ["web/static/elm/SearchBox.elm"],
      outputFolder: "priv/static/js",
      outputFile: "elm.js"
    }
  },

  modules: {
    autoRequire: {
      "js/app.js": ["web/static/js/app"]
    }
  },

  npm: {
    enabled: true
  }
};

