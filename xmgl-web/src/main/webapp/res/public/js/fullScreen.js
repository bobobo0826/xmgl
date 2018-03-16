function full()
{ 
	var fullScreenEnable = document.fullscreenEnabled || document.webkitFullscreenEnabled || document.mozFullScreenEnabled;
	if (fullScreenEnable) {
		var docElm = document.documentElement;
		if (docElm.requestFullscreen) { 
			docElm.requestFullscreen();
		}
		else if (docElm.msRequestFullscreen) { 
			docElm.msRequestFullscreen();
		}
		else if (docElm.mozRequestFullScreen) { 
			docElm.mozRequestFullScreen();
		}
		else if (docElm.webkitRequestFullScreen) {  
			docElm.webkitRequestFullScreen(); 
		}  
		
		document.getElementById('fullscreen').onclick = cancel; 
		document.getElementById('fullscreen').innerHTML = "退";
	}
	else
	{
		alert("该浏览器不支持全屏，或者版本过低！");
		
	}
}

function  cancel()
{  
	var fullScreenEnable = document.fullscreenEnabled || document.webkitFullscreenEnabled || document.mozFullScreenEnabled;
	if (fullScreenEnable) {
		if (document.exitFullscreen) {
			document.exitFullscreen();
		}
		else if (document.msExitFullscreen) {
			document.msExitFullscreen();
		}
		else if (document.mozCancelFullScreen) {
			document.mozCancelFullScreen();
		}
		else if (document.webkitCancelFullScreen) {
			document.webkitCancelFullScreen();
		}   
		document.getElementById('fullscreen').onclick = full; 
		document.getElementById('fullscreen').innerHTML = "全";
	}
	else
	{
		alert("该浏览器不支持全屏，或者版本过低！");
		
	}
}
    

   