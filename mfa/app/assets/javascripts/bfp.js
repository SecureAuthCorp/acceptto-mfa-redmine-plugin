jQuery.externalScript = function(url, options) {
  // allow user to set any option except for dataType, cache, and url
  options = $.extend(options || {}, {
    dataType: "script",
    cache: true,
    url: url
  });
  // Use $.ajax() since it is more flexible than $.getScript
  // Return the jqXHR object so we can chain callbacks
  return jQuery.ajax(options);
};

acceptto_fp_src = 'https://dbfp.acceptto.com/acceptto-fp.js';
eguardian_fp_src = 'https://dbfp.acceptto.com/eguardian-fp.js';

$.externalScript(eguardian_fp_src).done(function(script, textStatus) {
  console.log('eguardian_fp Script loading: ' + textStatus );
  $.externalScript(acceptto_fp_src).done(function(script, textStatus) {
    console.log('acceptto-fp Script loading: ' + textStatus );
  });
});
