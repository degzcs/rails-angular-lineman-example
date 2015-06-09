angular.module('app').directive 'mAppLoading', ($animate) ->
  # Return the directive configuration.
  # I bind the JavaScript events to the scope.

  link = (scope, element, attributes) ->
    # Due to the way AngularJS prevents animation during the bootstrap
    # of the application, we can't animate the top-level container; but,
    # since we added "ngAnimateChildren", we can animated the inner
    # container during this phase.
    # --
    # NOTE: Am using .eq(1) so that we don't animate the Style block.
    $animate.leave(element.children().eq(1)).then ->
      # Remove the root directive element.
      element.remove()
      # Clear the closed-over variable references.
      scope = element = attributes = null
      return
    return

  {
    link: link
    restrict: 'C'
  }
