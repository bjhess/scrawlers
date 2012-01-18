// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
Object.extend(String.prototype, {
	simpleFormat: function() {
		return "<p>" +
					 this.gsub(/\r\n?/, "\n").gsub(/\n\n+/, "</p>\n\n<p>").gsub(/([^\n]\n)(?=[^\n])/, '#{1}<br />') +
					 "</p>";
  },

	wordCount: function() {
    var word_count = 0;
    this.scan(/(\w|-)+/, function(match){ word_count++ });
    return word_count;
	}
});

function updateWordCount() {
  var word_count = $F('story_body').wordCount();
  var word_count_span = $('word_count');
  word_count_span.innerHTML = word_count;
  if(word_count > 100) {
    word_count_span.addClassName('over');
  }
  if(word_count <= 100) {
    word_count_span.removeClassName('over');
  }
}

function validateComment() {
  if($F('comment_body').strip().blank()) {
    $('note_button').innerHTML = "Enter a note!";
    $('comment_body').activate();
    return false;
  } else {
    return true;
  }
}

function validateResponse(comment_id) {
  if($F('comment_response_' + comment_id + '_body').strip().blank()) {
    $('comment_response_' + comment_id + '_body').activate();
    $('comment_response_' + comment_id + '_body').form.down('button[type=submit]').innerHTML = "Enter a response!";
    return false;
  } else {
    return true;
  }
}