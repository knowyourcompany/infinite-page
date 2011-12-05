#= require jquery
#= require jquery_ujs
#= require underscore
#= require infinite_page
#= require_tree .

$(document).ready ->
  $('[data-behavior~=infinite_page]').infinitePage()