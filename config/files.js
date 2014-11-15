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
    js: {
      vendor: [
        "vendor/js/jquery.js",
        "vendor/js/jquery.growl.js",
        //"vendor/js/bootstrap.js",
        //"vendor/js/jasny-bootstrap.js",
        "vendor/js/ark.js",
        "vendor/js/async.js",
        "vendor/js/angular.js",
        "vendor/js/angular-resource.js",
        //"vendor/js/angular-route.js",
        "vendor/js/angular-ui-router.js",
        "vendor/js/ui-bootstrap-tpls.js",
	 	"vendor/js/ui-bootstrap-tpls.js",
	 	"vendor/js/ng-grid-2.0.11.debug.js",
        "vendor/js/angular-idle.js",
        "vendor/js/angularjs-gravatardirective.js",
        "vendor/js/validate.js",
        "vendor/js/xeditable.js",
        "vendor/js/angular-translate.min.js",
        "vendor/js/angular-translate-loader-static-files.min.js",
        "vendor/js/jsonpath.js",
        "vendor/js/d3.js",
        "vendor/js/nv.d3.js",
        "vendor/js/angularjs-nvd3-directives.js",
        "vendor/js/angular-pageslide-directive.js"
      ],
      app: [
        "app/js/app.js",
        "app/js/**/*.js"
      ]
    },

//    less: {
//      compile: {
//        options: {
//          paths: ["vendor/css/normalize.css", "vendor/css/**/*.css", "app/css/**/*.less"]
//        }
//      }
//    },

    css: {
      vendor: [
        "vendor/css/jquery.growl.css",
        "vendor/css/bootstrap.css",
        //"vendor/css/jasny-bootstrap.css",
        "vendor/css/font-awesome.css",
        "vendor/css/ark.css",
        "vendor/css/xeditable.css",
        "vendor/css/ng-grid.css",
        "vendor/css/nv.d3.css"
      ],
      app: [
        //TODO: make main.css compatible with ng-grid
	"app/css/dice.css",
        "app/css/main.css",
        "app/css/forms.css",
        "app/css/layout.css",
        "app/css/my-ng-grid.css",
        "app/css/toolbar.css",
        "app/css/footer.css",
        "app/css/market.css",
        "app/css/spinner.css",
        "app/css/help.css"
      ]
    }

  };
};


