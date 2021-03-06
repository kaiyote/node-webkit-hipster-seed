exports.config =
  # See docs at http://brunch.readthedocs.org/en/latest/config.html.
  conventions:
    assets: /^app[\/\\]+assets[\/\\]+/
    ignored: /^(app[\/\\]+styles[\/\\]+overrides|(.*?[\/\\]+)?[_]\w*)|(jade)/
  modules:
    definition: false
    wrapper: false
  paths:
    public: '_public'
  files:
    javascripts:
      joinTo:
        'js/app.js': /^app/
        'js/vendor.js': /^bower_components/
      order:
        after: [
          'app/app.coffee'
        ]
    stylesheets:
      joinTo:
        'css/app.css': /^(app|vendor|bower_components)/
      order:
        # make sure custom css comes after bootstrap, etc
        after: [
          'app/styles/app.styl'
        ]
  plugins:
    jade:
      pretty: yes # Adds pretty-indentation whitespaces to output (false by default)
  # Enable or disable minifying of result js / css files.
  minify: true
