#
#Override application configuration here. Common examples follow in the comments.
#

module.exports = (lineman) ->
	# NgTemplate config
  	ngtemplates: app:
      options: base: 'generated/templates'
      src: 'generated/templates/**/*.html'
      dest: '<%= files.ngtemplates.dest %>'

    #Whtcher config
    watch:
      ngtemplates:
        files: 'app/templates/**/*.haml'
        tasks: [
          'haml'
          'ngtemplates'
          'concat_sourcemap:js'
        ]
      pages:
        files:[
          '<%= files.pages.source %>',
          'app/pages/*.haml',
        ]
        tasks: [
          'haml'
          'pages:dev'
        ]
    # Server config
    server:
      pushState: false
      apiProxy:
        enabled: true
        host: 'localhost'
        port: 3000
    # Sass config
    enableSass: true
    sass: options: bundleExec: false
    concat_sourcemap:
      js: src: [
        '<%= files.js.vendor %>'
        '<%= files.coffee.generated %>'
        '<%= files.js.app %>'
        '<%= files.ngtemplates.dest %>'
      ]
      css: src: [
        '<%= files.less.generated %>'
        '<%= files.sass.generatedVendor %>'
        '<%= files.css.vendor %>'
        '<%= files.sass.generatedApp %>'
        '<%= files.css.app %>'
      ]
    # Haml config
    haml:
      options: language: 'coffee'
      pages: files: [ {
        expand: true
        cwd: 'app/pages'
        src: [ '**/*.haml' ]
        dest: 'generated/pages/'
        ext: '.html'
      } ]
    webfonts:
      files:
        "vendor/fonts/": "vendor/fonts/**/*.*"
    # pages: dist: files: '../public/index.html': 'app/templates/homepage.*'