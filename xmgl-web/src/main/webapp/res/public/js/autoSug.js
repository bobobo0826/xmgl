
(function($){
	$.fn.autoMail = function(options){
		var opts = $.extend({}, $.fn.autoMail.defaults, options);
		return this.each(function(){
			var $this = $(this);
			var o = $.meta ? $.extend({}, opts, $this.data()) : opts;
			var top = $this.offset().top + $this.height() + 6;
			var left = $this.offset().left;
			
			var $mailBox = $('<div id="mailBox" style="top:'+top+'px;left:'+left+'px;width:'+$this.width()+'px"></div>');
			$('body').append($mailBox);
			
			function setEmailLi(index){
				$('#mailBox li').removeClass('cmail').eq(index).addClass('cmail');
			}
			
			var emails = o.emails;
			var init = function(input) {
				input.attr('autocomplete','off');
				
				var emailList = '<p><span>最近搜索&nbsp;&nbsp;&nbsp;&nbsp;<a href="javascript:void(0);" style="text-decoration:underline;color:#b3b3e3;" onclick="delLocal(\''+$this.attr("id")+'\')">清除记录</a></span></p>';
				emailList += '<ul>';
				if (input.val() != "") {
					for(var i = 0; i < emails.length; i++) {
						if (emails[i].indexOf(input.val()) > -1)
							emailList += '<li style="text-decoration:underline;">'+emails[i]+'</li>';
					}
				} else {
					for(var i = 0; i < emails.length; i++) {
						emailList += '<li style="text-decoration:underline;">'+emails[i]+'</li>';
					}
				}
				emailList += '</ul>';
				$mailBox.html(emailList).show(0);
				
				//添加鼠标事件
				$('#mailBox li').hover(function(){
					$('#mailBox li').removeClass('cmail');
					$(this).addClass('cmail');
				},function(){
					$(this).removeClass('cmail');
				}).click(function(){
					input.val($(this).html());
					$mailBox.hide(0);
				});
			};
			//当前高亮下标
			var eindex = -1;
			//监听事件
			$this.focus(function() {
				init($this);
			}).blur(function() {
				setTimeout(function(){
					$mailBox.hide(0);
				},100);
			}).keyup(function(event){
				
				if(event.keyCode == 40) { //上键
					eindex ++;
					if(eindex >= $('#mailBox li').length){
						eindex = 0;
					}
					setEmailLi(eindex);
				
				} else if(event.keyCode == 38) { //下键
					eindex --;
					if(eindex < 0){
						eindex = $('#mailBox li').length-1;
					}
					setEmailLi(eindex);
				}
				else {
					eindex = -1;
					init($this);
					$mailBox.hide(0);
				}
			}).keydown(function(event){
				if(event.keyCode == 13){
					if(eindex >= 0) {
						$this.val($('#mailBox li').eq(eindex).html());
						doQuery();//执行查询
					}
				}
			});
		});
	};
	$.fn.autoMail.defaults = {
		emails:[]
	};
})(jQuery);


function delLocal(id) {
	if (localStorage) {
		if (id=="_orgaName")
			localStorage.removeItem("orgNames");
		else if (id=="_contName")
			localStorage.removeItem("cntNames");
	}
	$("#mailBox li").remove();
}