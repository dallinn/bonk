(function($){
	$(document).ready(function(){
		$('.bn_chart_area .bn_chart_value').text($('#chart-area').data('max')+'k');
		var doughnutData = [
			{
				value: $('#chart-area').data('max'),
				color:"#fff",
				highlight: "#fff",
				label: "Red"
			},
			{
				value: $('#chart-area').data('min'),
				color: "#9dc077",
				highlight: "#9dc077",
				label: "Green"
			}
		];
		if($('#chart-area').length){
			var ctx = document.getElementById("chart-area").getContext("2d");
			window.myDoughnut = new Chart(ctx).Doughnut(doughnutData, {
				responsive : true,
				segmentShowStroke : false,
				percentageInnerCutout : 85,			

			});	
		}
		

		$('.bn_chart_area .btn-link').on('click', function(e){
			minValue = myDoughnut.segments[0].value;
			maxValue = myDoughnut.segments[1].value;
			
			if($(this).hasClass('bn_chart_plus')){
				if(minValue<1 || maxValue>100){}else{
					myDoughnut.segments[0].value = minValue+1;
					myDoughnut.segments[1].value = maxValue-1;
					// Would update the first dataset's value of 'Green' to be 10
					$('.bn_chart_area .bn_chart_value').text(myDoughnut.segments[0].value+'k')
				
				}
			}else{
				if(minValue<=1 || maxValue>100){

				}else{
					myDoughnut.segments[0].value = minValue-1;
					myDoughnut.segments[1].value = maxValue+1;
					// Would update the first dataset's value of 'Green' to be 10
					$('.bn_chart_area .bn_chart_value').text(myDoughnut.segments[0].value+'k')
					myDoughnut.update();

				}
			}
			myDoughnut.update();
			
			
			return false;
		})
		

		$('.bn_logo_slider').slick({
				"slidesToShow": 1, 
				"slidesToScroll": 1, 
				"autoplay":true, 
				"autoplaySpeed":5000, 
				"pauseOnHover":false, 
				"dots":true, 
				"arrows":false
			});
		
		$('.bn_whitebx_logo_slider').slick({
				"slidesToShow": 2, 
				"slidesToScroll": 1, 
				"autoplay":true, 
				"autoplaySpeed":5000, 
				"pauseOnHover":false, 
				//"dots":true, 
				"arrows":false,
				rows:2,
				responsive: [
			    {
			      breakpoint: 1024,
			      settings: {
			        slidesToShow: 1,			        
			      }
			    },
			    {
			      breakpoint: 767,
			      settings: {
			        slidesToShow: 2
			        
			      }
			    },
			    {
			      breakpoint: 480,
			      settings: {
			        slidesToShow: 1,
			        slidesToScroll: 1,
			        rows:1
			      }
			    }			    
			  ]
			});
		
		
		$('.bn_testimonials_slider').slick({
				"slidesToShow": 3, 
				"slidesToScroll": 1, 
				"autoplay":true, 
				"autoplaySpeed":5000, 
				"pauseOnHover":false, 
				//"dots":true, 
				"arrows":false,
				//rows:1,
				responsive: [
			    {
			      breakpoint: 1024,
			      settings: {
			        slidesToShow: 2,			        
			      }
			    },
			    {
			      breakpoint: 650,
			      settings: {
			        slidesToShow: 1
			        
			      }
			    },
			    {
			      breakpoint: 480,
			      settings: {
			        slidesToShow: 1,
			        slidesToScroll: 1,
			        //rows:1
			      }
			    }			    
			  ]
			});

		$('.bn_smooth_scroll').bind('click', function(event) {
	        var $anchor = $(this);
	       $('html, body').stop().animate({
		            scrollTop: $($anchor.attr('href')).offset().top
		        }, 1800);
	        event.preventDefault();
	    });

	    $('#bn_extra_course').on('shown.bs.collapse', function () {
		  setTimeout(function(){
		  	$('html, body').stop().animate({
	            scrollTop: $('#bn_extra_course').offset().top
	        }, 1800);
		  }, 500)
		});


		})

	
	$(window).scroll(function(){
		var nav = $('.navbar');
	    var top = 50;
	    if ($(window).scrollTop() >= top) {

	        nav.addClass('bn_sticky');

	    } else {
	        nav.removeClass('bn_sticky');
	    }
	})
})(jQuery)