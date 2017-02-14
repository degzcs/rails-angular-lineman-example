/* Exports a function which returns an object that overrides the default &
 *   plugin file patterns (used widely through the app configuration)
 *
 * To see the default definitions for Lineman's file paths and globs, see:
 *
 *   - https://github.com/linemanjs/lineman/blob/master/config/files.coffee
 */
module.exports = function(lineman) {
  //Override file patterns here
  return {
    pages: {source: 'generated/pages/**/*.*'},
    js: {
      bower: [
        "bower_components/angular/angular.js",
        "bower_components/angular-animate/angular-animate.js",
        "bower_components/angular-aria/angular-aria.js",
        "bower_components/angular-breadcrumb/dist/angular-breadcrumb.js",
        "bower_components/ng-file-upload/angular-file-upload-all.js",
        "bower_components/angular-material/angular-material.js",
        "bower_components/angular-material-mocks/angular-material-mocks.js",
        "bower_components/angular-messages/angular-messages.js",
        "bower_components/angular-resource/angular-resource.js",
        "bower_components/angular-router/angular-router.js",
        "bower_components/angular-strap/dist/angular-strap.js",
        "bower_components/angular-ui-router/release/angular-ui-router.js",
        "bower_components/satellizer/satellizer.js",
        "bower_components/undescore/undescore.js",
      ],
      vendor: [
        "vendor/js/**/*.js"
      ],
      app: [
        "app/js/app.js",
        "app/js/**/*.js"
      ]
    },
    webfonts: {
      "root": "fonts"
    },
    less: {
      compile: {
        options: {
          paths: ["vendor/css/normalize.css", "vendor/css/**/*.css", "app/css/**/*.less"]
        }
      }
    }
  };
};
