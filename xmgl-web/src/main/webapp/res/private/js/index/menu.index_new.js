function InitLeftMenu(contextPath) {
	var menHtml="";   
    var postion="";
    var menuName="";
    $.each(_menus.menus, function(i, n) {
    	postion=n.menuid;
    	menuName=n.menuname;
    	url=n.url;
    	url=contextPath+url;
    	//默认图标
    	menuIconClass = "fa fa-truck"
    	if(n.menuIcon)
    	{
    		menuIconClass = n.menuIcon;
    	}
    	menHtml+='<li><a href="javascript:void(0);" ><i class="'+ menuIconClass +'"></i><span class="nav-label">'+menuName+'</span><span class="fa arrow"></a>';
    	if(n.menus && n.menus.length>0) {
    	 	menHtml+='<ul class="nav nav-second-level">';
        	$.each(n.menus, function(j, o) {
        		menuName=o.menuname;
            	url=o.url;
            	url=contextPath+url;
            	menuid=o.menuid;
            	if (o.menus && o.menus.length>0) {
            		menHtml+='<li><a  href="javascript:void(0);"> '+menuName+'<span class="fa arrow"></span></a>';
            	} 
            	else{
            		menHtml+='<li><a class="J_menuItem"  href="' +url+ '"> '+menuName+'</a></li>';
            	}
            		
            	if(o.menus && o.menus.length>0) {
            		menHtml+='<ul class="nav nav-third-level">';
            		$.each(o.menus, function(k,p){
            			menuName=p.menuname;
                    	url=p.url;
                    	url=contextPath+url;
                    	menuid=p.menuid;
            			menHtml+='<li><a class="J_menuItem"  href="' +url+ '">'+menuName+'</a></li>';
            		});
            		menHtml+='</ul>';
            		menHtml+='</li>';
            	}
        	});
        	menHtml+='</ul>';
        	menHtml+='</li>';
    	}
//    	console.log('--->'+menHtml)
    });
    
    $('#side-menu').append(menHtml);
}



function clockon() {
    var now = new Date();
    var year = now.getFullYear(); //getFullYear getYear
    var month = now.getMonth();
    var date = now.getDate();
    var day = now.getDay();
    var hour = now.getHours();
    var minu = now.getMinutes();
    var sec = now.getSeconds();
    var week;
    month = month + 1;
    if (month < 10) month = "0" + month;
    if (date < 10) date = "0" + date;
    if (hour < 10) hour = "0" + hour;
    if (minu < 10) minu = "0" + minu;
    if (sec < 10) sec = "0" + sec;
    var arr_week = new Array("星期日", "星期一", "星期二", "星期三", "星期四", "星期五", "星期六");
    week = arr_week[day];
    var time = "";
    time = year + "年" + month + "月" + date + "日" + "<br />" + hour + ":" + minu + ":" + sec + " " + week;

    $("#time").html(time);

    var timer = setTimeout("clockon()", 200);
}


