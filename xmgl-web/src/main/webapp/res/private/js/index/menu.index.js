var onlyOpenTitle="首页";//不允许关闭的标签的标题
String.prototype.trim = function() { 
	return this.replace(/(^\s*)|(\s*$)/g, "");
};
/**
 * 初始化左侧
 * 当前最多支持五级
 */
function InitLeftMenu(contextPath) {  
	var menHtml="";   
	menHtml=menHtml+'<li class="sub_00"><a class="now" href="javascript:void(0);" ><b class="icon-00"></b><span>首页</span></a></li>'; 
    var postion="";
    var menuName="";  
	$.each(_menus.menus, function(i, n) {
    	postion=n.menuid;
    	menuName=n.menuname;
    	url=n.url;
    	url=contextPath+url;
    	menHtml=menHtml+'<li class="sub_00"><a class="sub_01" href="javascript:void(0);" title="'+menuName+'" rel="'+url+'" onclick="clickMenu(this);"><b class="icon-'+postion+'"></b><span>'+menuName+'</span></a><ul class="sub_02">'; 
        $.each(n.menus, function(j, o) {
        	menuName=o.menuname;
        	url=o.url;
        	url=contextPath+url;
        	menuid=o.menuid;  
        	menHtml+='<li><a class="sub_03"  href="javascript:void(0);" title="'+menuName+'" rel="'+url+'" onclick="clickMenu(this);">'+menuName+'</a>'; 
        	if(o.menus && o.menus.length>0) { 
        		menHtml += '<ul>'; 
				$.each(o.menus,function(k,p){
					menuName=p.menuname;
		        	url=p.url;
		        	url=contextPath+url;
		        	menuid=p.menuid;    
		        	menHtml += '<li><a ref="'+p.menuid+'" href="javascript:void(0);" title="'+menuName+'" rel="'+url+'" onclick="clickMenu(this);">'+menuName+'</a>' ;
		        	if(p.menus && p.menus.length>0) { 
		        		menHtml += '<ul>'; 
						$.each(p.menus,function(k,h){
							menuName=h.menuname;
				        	url=h.url;
				        	menuid=h.menuid;    
				        	menHtml += '<li><a ref="'+h.menuid+'" href="javascript:void(0);" title="'+menuName+'" rel="'+url+'" onclick="clickMenu(this);">'+menuName+'</a>' ;
				        	if(h.menus && h.menus.length>0) { 
				        		menHtml += '<ul>'; 
								$.each(h.menus,function(k,j){
									menuName=j.menuname;
						        	url=j.url;
						        	url=contextPath+url;
						        	menuid=j.menuid;    
						        	menHtml += '<li><a ref="'+j.menuid+'" href="javascript:void(0);" title="'+menuName+'" rel="'+url+'" onclick="clickMenu(this);">'+menuName+'</a></li>' ;
								});
								menHtml += '</ul>';
				        	}
				        	menHtml+='</li>'; 
						});
						menHtml += '</ul>';
		        	}
		        	menHtml+='</li>'; 
				});
				menHtml += '</ul>';
        	}
        	menHtml+='</li>'; 
        });
		menHtml+='</ul>'; 
        menHtml += '</li>'; 
    });    
	$("#navMenu").html(menHtml);
}

function InitLeftMenu2(contextPath) {
	var menHtml='<li class="fisrt_level"><b class="icon-00"></b><a class="xz" href="javascript:void(0);" title="首页">首页</a></li>';   
    var postion="";
    var menuName="";
    $.each(_menus.menus, function(i, n) {
    	postion=n.menuid;
    	menuName=n.menuname;
    	url=n.url;
    	url=contextPath+url;
    	menHtml+='<li><b class="icon-'+postion+'"></b><a class="xz" href="javascript:void(0);" title="'+menuName+'" rel="'+url+'" onclick="clickMenu(this);">'+menuName+'</a>';
    	if(n.menus && n.menus.length>0) {
    	 	menHtml+='<ul class="er">';
        	$.each(n.menus, function(j, o) {
        		menuName=o.menuname;
            	url=o.url;
            	url=contextPath+url;
            	menuid=o.menuid;
            	if (o.menus && o.menus.length>0) {
            		menHtml+='<li class="e_li"><a href="javascript:void(0);" title="'+menuName+'" rel="'+url+'" onclick="clickMenu(this);"><span class="ss"></span> '+menuName+'</a>';
            	} else {
            		menHtml+='<li class="e_li"><a href="javascript:void(0);" title="'+menuName+'" rel="'+url+'" onclick="clickMenu(this);"><span class="ss"></span> '+menuName+'</a>';
            	}
            	if(o.menus && o.menus.length>0) {
            		menHtml+='<ul class="thr">';
            		$.each(o.menus, function(k,p){
            			menuName=p.menuname;
                    	url=p.url;
                    	url=contextPath+url;
                    	menuid=p.menuid;
            			menHtml+='<li class="e_li"><a href="javascript:void(0);" title="'+menuName+'" rel="'+url+'" onclick="clickMenu(this);">'+menuName+'</a></li>';
            		});
            		menHtml+='</ul>';
            		menHtml+='</li>';
            	}
        	});
        	menHtml+='</ul>';
        	menHtml+='</li>';
    	}
    	//console.log('--->'+menHtml)
    });
    
    $('#navMenu').html(menHtml);
}

function selectIndex() {
	$("#mainTabs").tabs("select","首页");
}
/**
 * 初始化系统菜单
 * @return
 */
function initSysMenu() {
	var html='<ul>';
	html+='<li><div class="sidebar-toggler hidden-phone"></div></li>'; //隐藏
	
	html+='<li><form class="sidebar-search">'+ //搜索
			'<div class="input-box">'+
			'  <a href="javascript:;" class="remove"></a>'+
			'  <input type="text" placeholder="搜索..." />'+
			'  <input type="button" class="submit" value=" " />'+
			'</div>'+
			'</form>'+
		  '</li>';
	
	html+='<li class="start active ">'+ //首页固定
			'  <a href="javascript:;">'+
			'  <i class="icon-home"></i>'+
			'  <span class="title">首页</span>'+
			'  <span class="selected"></span>'+
			'  </a>'+
			'</li>';
	
	//一级菜单
	$.each(_menus.menus, function(i, n) {
		if (null!=n.menus && n.menus.length>0) {
			html+='<li class="has-sub ">';
		} else {
			html+='<li class="">';
		}
		html+='<a href="javascript:;" title="'+n.menuname+'" >'+
				'<i class="icon-bookmark-empty"></i>'+ 
				'<span class="title">'+n.menuname+'</span>'+
				'<span class="arrow "></span>'+
				'</a>';
		if (null!=n.menus && n.menus.length>0) {
			html+='<ul class="sub">';
			//二级菜单
			$.each(n.menus, function(j, o) {
				html+='<li><a href="javascript:;" onclick="clickMenu(this);" title="'+o.menuname+'" rel="'+o.url+'">'+o.menuname+'</a></li>';
			});
			html+='</ul>';
		}
    	html+='</li>';
	});
	html+='<li class="exit"><a href="javascript:;"><i class="icon-user"></i><span class="title">退出</span></a></li>';
	html+='</ul>';
	document.getElementById("sysMenu").innerHTML = html;
}

function addTab(subtitle,url,icon){ 
	var close = false;
	if (subtitle == onlyOpenTitle) {
		close = false;
	} else {
		close = true;
	}
	if (!$('#mainTabs').tabs('exists', subtitle)) {
		$('#mainTabs').tabs('add',{
			title: subtitle,
			content: createFrame(url, subtitle),
			closable: close,
			iconCls:icon
		}); 
	} else { 
		$('#mainTabs').tabs('close', subtitle);
		$('#mainTabs').tabs('add',{
			title: subtitle,
			content: createFrame(url, subtitle),
			closable: close,
			iconCls:icon
		}); 
	}
	tabClose();
	tabCloseEven();
}
function getCurTabName()
{
	var tab = $('#mainTabs').tabs('getSelected');
	var title=tab.panel('options').title;
	return title;
}

function clickMenu(obj) {
	if(obj.rel=="" || typeof(obj.rel) == "undefined")
		return; 
	if(obj.rel.indexOf("/?")>=0)
		return ;
    addTab(obj.title.trim(), obj.rel , "", false);
}
 
//获取左侧导航的图标
function getIcon(menuid) {
	var icon = 'icon ';
	$.each(_menus.menus, function(i, n) {
		$.each(n.menus, function(j, o) {
		 	if(o.menuid==menuid){
				icon += o.icon;
			}
		});
	});
	return icon;
}

function find(menuid) {
	var obj=null;
	$.each(_menus.menus, function(i, n) {
		 $.each(n.menus, function(j, o) {
		 	if(o.menuid==menuid){
				obj = o;
			}
		 });
	});
	return obj;
}



function createFrame(url, subtitle) {
	return '<iframe src="'+url+'" allowTransparency="true" id="'+subtitle+'_frm" name="'+subtitle+'_frm" style="border: 0; width: 100%; height: 100%; overflow:hidden;z-index:0;" frameBorder="0"></iframe>';
}

function tabClose() {
	/*为选项卡绑定右键*/
	$(".tabs-inner").bind('contextmenu',function(e) {
		e.preventDefault();
		$('#mm').menu('show', {
			left: e.pageX,
			top: e.pageY
		});
		var subtitle =$(this).children(".tabs-closable").text();
		$('#mm').data("currtab",subtitle);
		$('#mainTabs').tabs('select',subtitle);
		return false;
	});
}

//绑定右键菜单事件
function tabCloseEven() {
    $('#mm').menu({
        onClick: function (item) {
            closeTab(item.id);
        }
    });
    return false;
}

function closeCurTab(title) {
	var currentTab = $('#mainTabs').tabs('getSelected');
	var title = currentTab.panel('options').title;
	$('#mainTabs').tabs('close', title);
}
function doReloadChildFrameByTabName(panelTitle)
{
	var frameName=panelTitle+"_frm";
	if(frameName.indexOf("sub_") >= 0 )  
	{  
		window.frames['学员详细信息_frm'].frames[frameName].doReloadPage(); 
	}else{
		window.frames[frameName].doReloadPage(); 
	}  
}
function doReloadChildFrameByTabNameLoad(panelTitle,param)
{
	var frameName=panelTitle+"_frm";
	if(frameName.indexOf("sub_") >= 0 )  
	{  
		window.frames['学员详细信息_frm'].frames[frameName].doReloadPage(param); 
	}else{
		window.frames[frameName].doReloadPage(param); 
	}  
}
function closeTab(action) {
    var alltabs = $('#mainTabs').tabs('tabs');
    var currentTab =$('#mainTabs').tabs('getSelected');
	var allTabtitle = [];
	$.each(alltabs,function(i,n){
		allTabtitle.push($(n).panel('options').title);
	});
	var close=false;
    switch (action) {
        case "refresh":
            var iframe = $(currentTab.panel('options').content);
            var src = iframe.attr('src');
    		if (currentTab.panel('options').title==onlyOpenTitle) {
    			close=false;
    		} else {
    			close=true;
    		}
            $('#mainTabs').tabs('update', {
                tab: currentTab,
                options: {
	    			content:createFrame(src),
	    			closable:close
                }
            });
            break;
        case "close":
            var currtab_title = currentTab.panel('options').title;
            if (currtab_title!=onlyOpenTitle)
            	$('#mainTabs').tabs('close', currtab_title);
            break;
        case "closeall":
            $.each(allTabtitle, function (i, n) {
                if (n != onlyOpenTitle){
                    $('#mainTabs').tabs('close', n);
				}
            });
            break;
        case "closeother":
            var currtab_title = currentTab.panel('options').title;
            $.each(allTabtitle, function (i, n) {
                if (n != currtab_title && n != onlyOpenTitle) {
                    $('#mainTabs').tabs('close', n);
				}
            });
            break;
        case "closeright":
            var tabIndex = $('#mainTabs').tabs('getTabIndex', currentTab);

            if (tabIndex == alltabs.length - 1){
            	$.messager.alert('系统提示','亲，后边没有啦 ^@^!!');
                return false;
            }
            $.each(allTabtitle, function (i, n) {
                if (i > tabIndex) {
                    if (n != onlyOpenTitle)
                        $('#mainTabs').tabs('close', n);
                }
            });
            break;
        case "closeleft":
            var tabIndex = $('#mainTabs').tabs('getTabIndex', currentTab);
            if (tabIndex == 1) {
                $.messager.alert('系统提示','亲，前边那个上头有人，咱惹不起哦。 ^@^!!');
                return false;
            }
            $.each(allTabtitle, function (i, n) {
                if (i < tabIndex) {
                    if (n != onlyOpenTitle) 
                        $('#mainTabs').tabs('close', n);
                }
            });
            break;
        case "exit":
            $('#closeMenu').menu('hide');
            break;
    }
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

    $(".time").html(time);

    var timer = setTimeout("clockon()", 200);
}
