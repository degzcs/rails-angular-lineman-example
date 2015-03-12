#
#Override application configuration here. Common examples follow in the comments.
#

module.exports = (lineman) ->
  {
  	# Server
    server:
      pushState: false
      apiProxy:
        enabled: true
        host: 'localhost'
        port: 3000
 	# Sass
 	# enableSass: true

    # Asset Fingerprints
    enableAssetFingerprint: true

    # Haml
    # remove pages generation, now it is handle
    removeTasks: 
    	dist: lineman.config.application.removeTasks.dist.concat('pages:dist')
    	common: lineman.config.application.removeTasks.common.concat('pages:dev')
    
    # ngTemplates config
    # ngtemplates: app:
    #   options: base: 'generated/templates'
    #   src: 'generated/templates/**/*.html'
    #   dest: '<%= files.ngtemplates.dest %>'

    # Watcher config
    # check if the templates and pages have been changed in order to render again
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
          'app/pages/*.html'
        ]
        tasks: [
          'haml'
        ]
  }
