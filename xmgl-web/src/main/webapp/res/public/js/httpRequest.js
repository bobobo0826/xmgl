//httpRequest依赖jquery，使用前必须要倒入jquery
function HttpRequest(){
	////发送请求
	this.sendRequest=function(url,data){
		var result={};
	    $.ajax({
			url: url,
			type: 'post',
			cache: false,
			async:false, 
			data:data,
			success: function(response) { 
				result=response;
			}
		}); 
	    return result;
	};
} 
