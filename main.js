$(document).ready(function() {
  $('#parse').click(function() {
    try {
      var myCodeMirror = $(".CodeMirror")[0].CodeMirror
      var source = myCodeMirror.getValue()

      out.className = "unhidden";
      
      // Import: Change: $('#input').val() -> source, i forget it, again 
      var result = parser.parse(source);
      $('#output').html(JSON.stringify(result,undefined,2));
    } catch (e) {
      $('#output').html('<div class="error"><pre>\n' + String(e) + '\n</pre></div>');
    }
  });
});

  

