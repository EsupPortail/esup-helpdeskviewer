up.jQuery(document).ready(function() {
	  up.jQuery('div.helpdeskviewer-messages-mobile> div').hide();  
	  up.jQuery('div.helpdeskviewer-messages-mobile> h3').click(function() {
	    up.jQuery(this).next('div').slideToggle('slow')
	    .siblings('div:visible').slideUp('fast');
	  });
	});
