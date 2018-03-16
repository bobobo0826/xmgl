//调度单详情选择部门start
function choseDept() {
	var url = '/permission/choseDept.action';
	url = encodeURI(encodeURI(url));
	windowName = "deptWindow";
	windowTitle = "选择";
	width = '30%';
	height = '70%';
	f_open(windowName, windowTitle, width, height, url, true);
}
function setDept(deptInfo, flag) {
	if (deptInfo == null || deptInfo == "")
		return;
	$("#dept_name").val(deptInfo.dept_name);
	$("#dept_id").val(deptInfo.id);
}
//分页显示浏览记录
function initGlanceBrowse(browse,imageUrl)
{
    var html="";
    if(browse.length>0){
        //页面先规定一页显示6个，后面有时间，再根据宽度写成动态的
        var length=Math.ceil((browse.length)/6);

        for(var i=1;i<=length;i++){
            if(i==1){
                html+="<li class='cur'>"+i+"</li>"
            }else{
                html+="<li>"+i+"</li>"
            }
            $("#lljl").html(html);
        }
        html="";
        var value=-5;
        for(var l=0;l<length;l++){
            if(l!=0){
                html+="<span style='display:none' class='browse'>";
            }else{
                html+="<span class='browse'>";
            }
            value+=5;
            for(var k=value;k<browse.length;k++){
            	if(browse[k].glance_over_photo!=null&&browse[k].glance_over_photo!="null"&&browse[k].glance_over_photo!="undefined"&&browse[k].glance_over_photo!=""){
               html += '<div class="col-sm-4" style="text-align:center;"><div class="form group"><p style="text-align:center"><img src="'+ imageUrl+browse[k].glance_over_photo+'" style="width:50px;height:50px;"/>'
                    +'</p><p style="text-align:center;line-height:0.8">'+browse[k].glance_over_name + '</p><p style="text-align:center">'+browse[k].glance_over_time+ '</p><br></div></div>';
            }else{
                    html += '<div class="col-sm-4" style="text-align:center;"><div class="form group"><p style="text-align:center"><img src="/res/public/img/icons/tx.png" style="width:50px;height:50px;"/>'
                        +'</p><p style="text-align:center;line-height:0.8">'+browse[k].glance_over_name + '</p><p style="text-align:center">'+browse[k].glance_over_time+ '</p><br></div></div>';
				}

                if(k>=value+5){
                    break;
                }

            }
            html+=" </span>";
        }
        $("#glance").html(html);
        var curr = 0;
        if ($(".scroll>ul.tip>li")) {
            $(".scroll>ul.tip>li").each(function(i) {
                $(this).click(function() {
                    curr = i;
                    $(".scroll>div.imgs>span.browse").eq(i).fadeIn("slow").siblings("span").hide();
                    $(this).siblings("li").removeClass("cur").end().addClass("cur");
                    return false;
                });
            });
        }
    }else{
        html="<div class='no_result'>暂时没人浏览该条日志</div>";
        $("#glance").html(html);
    }


}
//分页显示点赞记录
function initThumbsBrowse(browse,imageUrl){
    var html="";
    if(browse.length>0){
        //页面先规定一页显示3个，后面有时间，再根据宽度写成动态的
        var length=Math.ceil((browse.length)/3);
        for(var i=1;i<=length;i++){
            if(i==1){
                html+="<li class='cur'>"+i+"</li>"
            }else{
                html+="<li>"+i+"</li>"
            }

            $("#dz").html(html);
        }
        html="";
        var value=-2;
        for(var l=0;l<length;l++){
            if(l!=0){
                html+="<span style='display:none' class='browse'>";
            }else{
                html+="<span class='browse'>";
            }
            value+=2;
            for(var k=value;k<browse.length;k++){
                if(browse[k].thumbs_up_photo!=null&&browse[k].thumbs_up_photo!="null"&&browse[k].thumbs_up_photo!="undefined"&&browse[k].thumbs_up_photo!="") {
                    html += '<div class="col-sm-4"style="text-align:center;"><div class="form group"><p style="text-align:center"><img src="' + imageUrl + browse[k].thumbs_up_photo + '" style="width:50px;height:50px;"/>'
                        + '</p><p style="text-align:center;line-height:0.8">' + browse[k].thumbs_up_name + '</p><p style="text-align:center">' + browse[k].thumbs_up_time + '</p><br></div></div>';
                }else{
                    html += '<div class="col-sm-4" style="text-align:center;"><div class="form group"><p style="text-align:center"><img src="/res/public/img/icons/tx.png" style="width:50px;height:50px;"/>'
                        +'</p><p style="text-align:center;line-height:0.8">'+browse[k].thumbs_up_name + '</p><p style="text-align:center">'+browse[k].thumbs_up_time+ '</p><br></div></div>';
                }
                if(k>=value+2){
                    break;
                }

            }
            html+=" </span>";
        }
        $("#thumbs").html(html);
        var curr = 0;
        if ($(".scroll>ul.tip>li")) {
            $(".scroll>ul.tip>li").each(function(i) {
                $(this).click(function() {
                    curr = i;
                    $(".scroll>div.imgs>span.browse").eq(i).fadeIn("slow").siblings("span").hide();
                    $(this).siblings("li").removeClass("cur").end().addClass("cur");
                    return false;
                });
            });
        }
    }else{
        html="<div class='no_result'>暂时没人点赞该条日志</div>";
        $("#thumbs").html(html);
    }


}



//所有涉及到费用模块的删除
function delRow(rowIndex){
	   var rows=$("#bj").datagrid('getData').rows;
	   $("#bj").datagrid('deleteRow', rowIndex);
	   for(var k=rowIndex;k<rows.length;k++){
			$('#bj').datagrid('refreshRow', k);
	   }
	   calculatePrice();
}

// 如果是undefined情况转数字转成0
function returnNumber(value) {
	if (isEmpty(value) || value == 'undefined') {
		return 0;
	} else {
		return value;
	}
}


function mulsetTime(fromTime,toTime){
	for(var i=0;i<vehicleIdArray.length;i++){
		$("#fromTime_"+vehicleIdArray[i]+"vehicle").val(fromTime);
		$("#toTime_"+vehicleIdArray[i]+"vehicle").val(toTime);
	}
	for(var i=0;i<carrierIdArray.length;i++){
		$("#fromTime_"+carrierIdArray[i]+"carrier").val(fromTime);
		$("#toTime_"+carrierIdArray[i]+"carrier").val(toTime);
	}
	for(var i=0;i<companyIdArray.length;i++){
		$("#fromTime_"+companyIdArray[i]+"company").val(fromTime);
		$("#toTime_"+companyIdArray[i]+"company").val(toTime);
	}
}




function setOperatorInfo(object,bussinessId,entrustType) {
	var flag = true;
	var inputs = $("#operator_"+bussinessId+entrustType+" input");
	inputs.each(function() {
		if(object.id == $(this).attr('operator_id')){
			flag = false;
		}
	});
	if(flag){
		var html = '<span bussiness_id="'+bussinessId+'" entrust_type="'+entrustType+'">';
 		html += '<input type="hidden" operator_id="'+object.operator_id+'" operator="'+object.operator+'"/>';
 		html += object.operator+'&nbsp;<img src="/res/public/img/form/label_03.png" onclick="delDiv(this);" class="label-pic" >&nbsp;&nbsp;';
 		html += '</span>';
	    $("#operator_"+bussinessId+entrustType).append(html);
	}
}
function setOperator(object,bussinessId,entrustType) {
	var flag = true;
	var inputs = $("#operator_"+bussinessId+entrustType+" input");
	inputs.each(function() {
		if(object.id == $(this).attr('operator_id')){
			flag = false;
		}
	});
	if(flag){
		var html = '<span bussiness_id="'+bussinessId+'" entrust_type="'+entrustType+'">';
 		html += '<input type="hidden"  operator_id="'+object.id+'" operator="'+object.employee_name+'"/>';
 		html += object.employee_name+'&nbsp;<img src="/res/public/img/form/label_03.png" onclick="delDiv(this);" class="label-pic" >&nbsp;&nbsp;';
 		html += '</span>';
	    $("#operator_"+bussinessId+entrustType).append(html);
	}
}

function doAjax(url) {
	$.ajax({
		url : url,
		type : 'post',
		async : false,
		success : function(response) {
			result = JSON.parse(response)
			if (result.msgCode == "success") {
				$('#tt').datagrid('reload');
			}
			layer.msg(result.msgDesc);
		},
		error : function(result) {
			layer.msg("系统异常，请联系系统管理员");
		}
	});
}


// datagrid field突出显示(加红)
function redColor(value, row, index) {
	// 特殊处理运单待调度状态
	if (isEmpty(value)) {
		if (!isEmpty(row.transferstatus)) {
			var transferstatus = row.transferstatus.replace('中转', '调度');
			return '<span style="color:red">' + transferstatus + '</span>'
		}
	}
	return '<span style="color:red">' + value + '</span>'
}

// 特殊处理datagrid数据为undefined时候返回""
function getEValue(value) {
	if (!isEmpty(value)) {
		return value;
	} else {
		return "";
	}
}

function showSmallDetail(value, row, index) {
	return showNewContent(value, 10);
}


// 阿拉伯数字转中文大写
function ZDX(n) {
	if (!/^(0|[1-9]\d*)(\.\d+)?$/.test(n))
		return "数据非法";
	var unit = "千百拾亿千百拾万千百拾元角分", str = "";
	n += "00";
	var p = n.indexOf('.');
	if (p >= 0)
		n = n.substring(0, p) + n.substr(p + 1, 2);
	unit = unit.substr(unit.length - n.length);
	for (var i = 0; i < n.length; i++)
		str += '零壹贰叁肆伍陆柒捌玖'.charAt(n.charAt(i)) + unit.charAt(i);
	return str.replace(/零(千|百|拾|角)/g, "零").replace(/(零)+/g, "零").replace(
			/零(万|亿|元)/g, "$1").replace(/(亿)万|壹(拾)/g, "$1$2").replace(
			/^元零?|零分/g, "").replace(/元$/g, "元整");
}
function showLongDetail(value, row, index) {
	return showNewContent(value, 45);
}

// 返回指定格式化的数字字符串(比如:001,002)
function getNumberStr(number) {
	if (number < 10) {
		return ("00" + number);
	}
	if (number < 100 && number >= 10) {
		return ("0" + number);
	}
	if (number >= 100) {
		return (number);
	}
}


// 处理异常显示
function editException(value, row, index) {
	if (row.exceptioncode == 'YCZ') {
		return '<span style="color:red;" title="' + value + '">' + value
				+ '</span>';
	} else {
		return value;

	}

}
function formatFloatToTwo(value, row, index) {
	if (!isNaN(value)&&value!=null) {
		return parseFloat(value).toFixed(2);
	} else {
		return parseFloat(0).toFixed(2);
	}
}
// 生成UUID

function getUuid() {
	var s = [];
	var hexDigits = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
	for (var i = 0; i < 36; i++) {
		s[i] = hexDigits.substr(Math.floor(Math.random() * 0x10), 1);
	}
	s[14] = "4"; // bits 12-15 of the time_hi_and_version field to 0010
	s[19] = hexDigits.substr((s[19] & 0x3) | 0x8, 1); // bits 6-7 of the
	// clock_seq_hi_and_reserved
	// to 01
	s[8] = s[13] = s[18] = s[23] = "-";

	var uuid = s.join("");
	return uuid;
}
// 获取当前日期时间 格式为yyyy-MM-dd hh:mm
function getNowFormatTime() {
	var date = new Date();
	var seperator1 = "-";
	var seperator2 = ":";
	var year = date.getFullYear();
	var month = date.getMonth() + 1;
	var strDate = date.getDate();
    var hour = date.getHours();
    var min = date.getMinutes();
	if (month >= 1 && month <= 9) {
		month = "0" + month;
	}
	if (strDate >= 0 && strDate <= 9) {
		strDate = "0" + strDate;
	}
    if (hour >= 0 && hour <= 9) {
        hour = "0" + hour;
    }
    if (min >= 0 && min <= 9) {
        min = "0" + min;
    }
	var currentdate = year + seperator1 + month + seperator1 + strDate + " "
			+ hour + seperator2 +min;
	return currentdate;
}
// 返回当前日期 yyyy-MM-dd
function getNowDate() {
	var date = new Date();
	var seperator1 = "-";
	var month = date.getMonth() + 1;
	var strDate = date.getDate();
	if (month >= 1 && month <= 9) {
		month = "0" + month;
	}
	if (strDate >= 0 && strDate <= 9) {
		strDate = "0" + strDate;
	}
	var currentdate = date.getFullYear() + seperator1 + month + seperator1
			+ strDate + " ";
	return currentdate;
}

String.prototype.trim = function() {
	return this.replace(/(^\s*)|(\s*$)/g, "");
};
String.prototype.startWith = function(str) {
	var reg = new RegExp("^" + str);
	return reg.test(this);
};
String.prototype.endWith = function(str) {
	var reg = new RegExp(str + "$");
	return reg.test(this);
};
Date.prototype.format = function(format) {
	var o = {
		"M+" : this.getMonth() + 1, // month
		"d+" : this.getDate(), // day
		"h+" : this.getHours(), // hour
		"m+" : this.getMinutes(), // minute
		"s+" : this.getSeconds(), // second
		"q+" : Math.floor((this.getMonth() + 3) / 3), // quarter
		"S" : this.getMilliseconds()
	};
	if (/(y+)/.test(format)) {
		format = format.replace(RegExp.$1, (this.getFullYear() + "")
				.substr(4 - RegExp.$1.length));
	}
	for ( var k in o) {
		if (new RegExp("(" + k + ")").test(format)) {
			format = format.replace(RegExp.$1, RegExp.$1.length == 1 ? o[k]
					: ("00" + o[k]).substr(("" + o[k]).length));
		}
	}
	return format;
};
/*var emptyView = $.extend({}, $.fn.datagrid.defaults.view, {
	render : function(target, container, frozen) {
		$.fn.datagrid.defaults.view.render
				.call(this, target, container, frozen);
	},

	onAfterRender : function(target) {
		$.fn.datagrid.defaults.view.onAfterRender.call(this, target);
		var opts = $(target).datagrid('options');
		var vc = $(target).datagrid('getPanel').children('div.datagrid-view');
		vc.children('div.datagrid-empty').remove();
		if (!$(target).datagrid('getRows').length) {
			$(target).datagrid('resize', {
				width : "100%",
				height : "100",
			});
			$('.datagrid-footer-inner').hide();
			var d = $('<div class="datagrid-empty"></div>').html(
					opts.emptyMsg || 'no records').appendTo(vc);
			d.css({
				position : 'absolute',
				left : 0,
				top : 40,
				width : '100%',
				color : '#ff0000',
				textAlign : 'center'
			});
		} else {
			$(target).datagrid('resize', {
				width : "auto",
				height : "auto",
			});
			$('.datagrid-footer-inner').show();
		}
	}
});*/
function formatDatebox(value) {
	if (value == null || value == '')
		return '';
	var dt;
	if (value instanceof Date) {
		dt = value;
	} else {
		dt = new Date(value);
		if (isNaN(dt)) {
			// 这段是关键代码，将那个长字符串的日期值转换成正常的JS日期格式
			value = value.replace(/\/Date\((-?\d+)\)\//, '$1');
			dt = new Date();
			dt.setTime(value);
		}
	}
	var f = dt.format("yyyy-MM-dd");
	return f;
}
function formatDatebox1(value) {
	if (value == null || value == '')
		return '';
	var dt;
	if (value instanceof Date) {
		dt = value;
	} else {
		dt = new Date(value);
		if (isNaN(dt)) {
			// 这段是关键代码，将那个长字符串的日期值转换成正常的JS日期格式
			value = value.replace(/\/Date\((-?\d+)\)\//, '$1');
			dt = new Date();
			dt.setTime(value);
		}
	}
	var f = dt.format("yyyy-MM-dd hh:mm");
	return f;
}
/**
 * 解析输入的dateStr，返回Date类型。 dateStr: XXXX-XX-XX
 */
function parseDate(dateStr) {
	var strArray = dateStr.split("-");
	if (strArray.length == 3) {
		return new Date(strArray[0], strArray[1] - 1, strArray[2]);
	} else {
		return new Date();
	}
}
/*$.extend($.fn.datagrid.defaults.editors, {
	datebox : {
		init : function(container, options) {
			var input = $('<input type="text">').appendTo(container);
			input.datebox(options);
			return input;
		},
		destroy : function(target) {
			$(target).datebox('destroy');
		},
		getValue : function(target) {
			return $(target).datebox('getValue');
		},
		setValue : function(target, value) {
			$(target).datebox('setValue', formatDatebox(value));
		},
		resize : function(target, width) {
			$(target).datebox('resize', width);
		}
	}
});*/
function delHtmlTag(str) {
	str = str.replace(/<[^>]+>/g, '');// 去掉所有的html标记
	return str.replace(/\s+/g, "");
}
function shake(ele, times) {
	var i = 0, t = false, times = times || 2, srcColor = ele.css("color");
	if (t)
		return;
	t = setInterval(function() {
		i++;
		if (i % 2 == 0) {
			ele.css("color", srcColor);
		} else {
			ele.css("color", "F1273C");
		}
		if (i == 2 * times) {
			clearInterval(t);
		}
	}, 500);
}

function showinfo(e, title, info, width) {
	if (arguments.length == 4) {
		$("#showInfoDiv").find(".infopanel").css("width", width);
	}
	var evt = (window.event) ? window.event : e;
	$("#showInfoDiv #title").html(title);
	$("#showInfoDiv #info").html(info);
	$("#showInfoDiv").css("display", "inline");
	var top = evt.clientY + document.body.scrollTop;
	if (evt.clientY + $("#showInfoDiv>.infopanel")[0].clientHeight > document.body.clientHeight) {
		top -= $("#showInfoDiv>.infopanel")[0].clientHeight;
	}
	$("#showInfoDiv").css("top", top);
	var left = evt.clientX + document.body.scrollLeft + 30;
	if (evt.clientX + document.body.scrollLeft + 30
			+ $("#showInfoDiv>.infopanel")[0].clientWidth > document.body.clientWidth) {
		left = left - $("#showInfoDiv>.infopanel")[0].clientWidth - 60;
	}
	$("#showInfoDiv").css("left", left);
}
function hideinfo() {
	$("#showInfoDiv").css("display", "none");
}
function show(elem) {
	$(elem).css("display", "");
}
function hide(elem) {
	$(elem).css("display", "none");
}
function doTextOnfocus(obj, name) {
	if (!obj) {
		return true;
	}
	if ($(obj).val() == "请输入" + name) {
		$(obj).val("");
		$(obj).css("color", "black");
	}
	return true;
}
function doTextOnBlur(obj, name) {
	if (!obj) {
		return true;
	}
	if (!$(obj).val().trim() || $(obj).val().trim() == "请输入" + name) {
		$(obj).val("请输入" + name);
		$(obj).css("color", "gray");
	}
	return true;
}
function showprocess(title, msg) {
	$.messager.progress({
		title : title,
		msg : msg
	});
}
function showMsg(title, msg, timeout, showType) {
	$.messager.show({
		title : title,
		msg : msg,
		timeout : timeout,
		showType : showType
	});
}
function dopresscheck(e) {
	e = (e) ? e : ((window.event) ? window.event : "");
	var key = e.keyCode ? e.keyCode : e.which;
	if (key == 13) {
		var obj = event.srcElement ? event.srcElement : event.target;
		if ($(obj).val()) {
			doQuery();
		}
	}
}
function openWin(urlStr) {
	window.open(urlStr, "", "left=" + 0.2 * screen.width + ",top=" + 0.2
			* screen.height + ",height=" + 0.4 * screen.height + ",width="
			+ 0.5 * screen.width
			+ ",menubar=no,scrollbars=yes,location=no,status=yes");
}
function f_open1(href, title, width, height) {
	$('#newWindow').window({
		title : title,
		left : location.left,
		top : location.top,
		width : width,
		height : height,
		href : href,
		resizable : true,
		collapsible : true,
		maximizable : true,
		minimizable : true,
		closable : false
	});
	$('#newWindow').window('refresh');
	$('#newWindow').parent.window('open');
}
function f_open2(divName, title, width, height, href, modal) {
	if ($('#' + divName).length <= 0) {
		var div = "<div id='"
				+ divName
				+ "' class='easyui-window' align='center' style='overflow:hidden;width: "
				+ width
				+ "px; height: "
				+ height
				+ "px;'>"
				+ "<iframe id='"
				+ divName
				+ "_frm' scrolling='yes' frameborder='0' style='width:100%; height:100%;'></iframe>"
				+ "</div>";
		$(document.body).append(div);
	}
	$('#' + divName).window({
		title : title,
		shadow : false,
		left : location.left,
		top : location.top,
		width : width,
		height : height,
		modal : modal
	});
	$("#" + divName + "_frm").attr("src", href);
}

function f_open(divName, title, width, height, href, modal) {
	// iframe窗
	layer.open({
		type : 2,
		title : title,
		shadeClose : true,
		shade : false,
		maxmin : true, // 开启最大化最小化按钮
		area : [ width, height ],
		content : href
	});
}
function f_uploadOpen(divName, title, width, height, href, modal) {
	if ($('#' + divName).length <= 0) {
		var div = "<div id='"
				+ divName
				+ "' class='easyui-window' align='center' style='overflow:hidden;width: "
				+ width
				+ "px; height: "
				+ height
				+ "px;'>"
				+ "<iframe id='"
				+ divName
				+ "_frm' scrolling='yes' frameborder='0' style='width:100%; height:100%;'></iframe>"
				+ "</div>";
		$(document.body).append(div);
	}
	$('#' + divName).window({
		title : title,
		shadow : false,
		left : (getPageSize()[2] - width) / 2,
		top : 10 + $(document).scrollTop(),
		width : width,
		height : height,
		modal : modal,
		onClose : function() {
			$('#tt').datagrid('reload');
		}
	});
	$("#" + divName + "_frm").attr("src", href);
}

function f_close(divName) {
	var index = parent.layer.getFrameIndex(window.name); // 获取窗口索引
	parent.layer.close(index);
}
function showContent(value, length) {
	if (null == value)
		value = "";
	var shoinf = "showinfo(this,'详细','" + value + "')";
	var str = "";
	if (value.length > length)
		str = '<span  onmouseover="' + shoinf
				+ '" onmouseout="hideinfo()" style="cursor: pointer;">'
				+ value.substring(0, length) + '...' + '</span>';
	else
		str = value;
	return str;
}
/**
 * 删除指定datagrid的行
 * 
 * @param url
 * @param index
 * @param tableId
 * @return
 */
function del(url, index, tableId) {
	$.messager.confirm('提示:', '您确认要删除此条记录吗?', function(event) {
		if (event) {
			$.ajax({
				type : 'post',
				cache : false,
				url : url,
				success : function(result) {
					if (result.success) {
						$('#' + tableId).datagrid("deleteRow", index);
						$('#' + tableId).datagrid('load');
						$.messager.show({
							title : '成功',
							msg : result.msg,
							timeout : 1000
						});
					} else {
						$.messager.show({
							title : '错误',
							msg : result.msg,
							timeout : 5000
						});
					}
				},
				error : function() {
					$.messager.show({
						title : '错误',
						msg : '删除失败'
					});
				}
			});
		}
	});
}
function delTableTr(url, t) {
	$.messager.confirm('提示:', '您确认要删除此条记录吗?', function(event) {
		if (event) {
			$.ajax({
				type : 'get',
				cache : false,
				url : url,
				success : function(result) {
					if (result.success) {
						$(t).parent().parent().remove();
						$.messager.show({
							title : '成功',
							msg : result.msg,
							timeout : 3000
						});
					} else {
						$.messager.show({
							title : '错误',
							msg : result.msg,
							timeout : 5000
						});
					}
				},
				error : function() {
					$.messager.show({
						title : '错误',
						msg : '删除失败'
					});
				}
			});
		}
	});
}
function createCombobox(obj, checkvalue, functionvalue, datavalue, requirvalue) {
	obj.combobox({
		data : checkvalue,
		required : requirvalue,
		valueField : 'ID',
		textField : 'TEXT',
		editable : false,
		autoShowPanel : true,
		panelHeight : 'auto',
		value : datavalue,
		onSelect : functionvalue
	});
}

function createComboboxWithMuliti(obj, checkvalue, functionvalue, datavalue, requirvalue) {
	$('#tt').combobox({
		data : checkvalue,
		required : requirvalue,
		valueField : 'ID',
		textField : 'TEXT',
		editable : false,
		checkbox:true,  
		multiple:true,
		autoShowPanel : true,
		panelHeight : 'auto',
		value : datavalue,
        onSelect: function(rec){
            var allval = $(this).combobox("getData");
            var allth = allval.length;
                if (rec.areaCode != 0){
                    $(this).combobox("unselect", 0);
                }else{
                    for (var i=0;i<allth;i++) {
                        if (allval[i].areaCode != 0) {
                            $(this).combobox("unselect", allval[i].areaCode);
                        }
                    }
                }
            }
    });
}
function createComboboxM(obj, checkvalue, functionvalue, datavalue,
		requirvalue, height, editable) {
	obj.combobox({
		data : checkvalue,
		required : requirvalue,
		valueField : 'ID',
		textField : 'TEXT',
		editable : editable,
		autoShowPanel : false,
		panelHeight : height,
		value : datavalue,
		onSelect : functionvalue
	});
}
function checkValue(obj, message) {
	if (null == obj.val() || obj.val().length <= 0) {
		$.messager.alert('警告', message, 'warning');
		obj.focus();
		return false;
	}
	return true;
}
function checkNaN(obj, message) {
	if (null == obj.val() || obj.val().length <= 0 || isNaN(obj.val())) {
		$.messager.alert('警告', message, 'warning');
		obj.focus();
		return false;
	}
	return true;
}
function selectnull() {

}
function setNameFromComboBox(toValue, fromValue) {
	$(toValue).val($(fromValue).combobox('getText'));
}

function doClear() {
	$('form')[0].reset();
	$('#tt').datagrid('removeFilterRule');
	$('#tt').datagrid('options').url = getUrl();
	$('#tt').datagrid('load');
}
function checkIsNumber() {
	$(".number").change(function() {
		if (isNaN(this.value)) {
			$("#" + this.id).val("");
		}
	});
}

function doReadOnly() {
	$(":text").attr("readOnly", true);
	$(":checkbox").attr("disabled", true);
	$("textarea").attr("readOnly", true);
	$("select").attr("disabled", true);
	$(".combo-arrow").css("background", "FFFFFF");
	$("input").attr("disabled", true);
}
function doEdit() {
	$(":text").attr("readOnly", false);
	$(":checkbox").attr("disabled", false);
	$("textarea").attr("readOnly", false);
	$("select").attr("disabled", false);
	$("input").attr("disabled", false);
}

// 获取页面的高度、宽度
function getPageSize() {
	var xScroll, yScroll;
	if (window.innerHeight && window.scrollMaxY) {
		xScroll = window.innerWidth + window.scrollMaxX;
		yScroll = window.innerHeight + window.scrollMaxY;
	} else {
		if (document.body.scrollHeight > document.body.offsetHeight) {
			xScroll = document.body.scrollWidth;
			yScroll = document.body.scrollHeight;
		} else {
			xScroll = document.body.offsetWidth;
			yScroll = document.body.offsetHeight;
		}
	}
	var windowWidth, windowHeight;
	if (self.innerHeight) { // all except Explorer
		if (document.documentElement.clientWidth) {
			windowWidth = document.documentElement.clientWidth;
		} else {
			windowWidth = self.innerWidth;
		}
		windowHeight = self.innerHeight;
	} else {
		if (document.documentElement && document.documentElement.clientHeight) { // Explorer
			// 6
			// Strict
			// Mode
			windowWidth = document.documentElement.clientWidth;
			windowHeight = document.documentElement.clientHeight;
		} else {
			if (document.body) { // other Explorers
				windowWidth = document.body.clientWidth;
				windowHeight = document.body.clientHeight;
			}
		}
	}
	if (yScroll < windowHeight) {
		pageHeight = windowHeight;
	} else {
		pageHeight = yScroll;
	}
	if (xScroll < windowWidth) {
		pageWidth = xScroll;
	} else {
		pageWidth = windowWidth;
	}
	arrayPageSize = new Array(pageWidth, pageHeight, windowWidth, windowHeight);
	return arrayPageSize;
}

function delHtmlTag(str) {
	str = str.replace(/<[^>]+>/g, '');// 去掉所有的html标记
	return str.replace(/\s+/g, "");
}
/**
 * 
 * @param href
 *            调用的方法或者action
 * @param title
 *            标题
 * @param width
 *            宽度
 * @param height
 *            高度
 * @param modal
 *            模式（true 模态 false 非模态）
 * @return
 */
function openEasyDialog(divName, title, href, width, height, modal) {
	if ($('#' + divName).length <= 0) {
		var div = "<div id='" + divName + "' "
				+ "class='easyui-dialog' align='center' style='width: " + width
				+ "px; height: " + height + "px;'>" + "</div>";
		$(document.body).append(div);
	}
	$('#' + divName).dialog({
		title : title,
		width : width,
		height : height,
		closed : false,
		cache : false,
		modal : modal
	});
	$('#' + divName).dialog('refresh', href);
	$("#" + divName + "_frm").attr("src", href);
}

// 显示时间，首页用到
function tick() {
	var today;
	today = new Date();
	document.getElementById("LocalTime").innerHTML = showLocale(today);
	window.setTimeout("tick()", 1000);
}
function showLocale(objD) {
	var dn, s;
	var hh = objD.getHours();
	var mm = objD.getMinutes();
	var ss = objD.getSeconds();
	s = objD.getFullYear() + "年" + (objD.getMonth() + 1) + "月" + objD.getDate()
			+ "日 ";
	if (hh > 12) {
		hh = hh - 12;
		dn = '下午';
	} else {
		dn = '上午';
	}
	if (hh < 10)
		hh = '0' + hh;
	if (mm < 10)
		mm = '0' + mm;
	if (ss < 10)
		ss = '0' + ss;
	s += " " + dn + ' ' + hh + ":" + mm + ":" + ss;
	return (s);
}
/**
 * 判断字符串是否为空
 * 
 * @param s
 * @return
 */
function isEmpty(target) {
	if (isUndefined(target))
		return true;
	try {
		if (target == null || (target + "").trim().length == 0)
			return true;
	} catch (er) {
		alert(target);
	}
	return false;
}
/**
 * 
 * @param target
 * @returns {Boolean}
 */
function isUndefined(target) {
	if (typeof (target) == "undefined")
		return true;
	return false;
}

/**
 * 获得下拉框选中的TEXT
 */
function getSelectedText(name) {
	return $("select[name='" + name + "']").find("option:selected").text();
}
/**
 * 获得下拉框选中的id
 */
function getSelectedValueById(name) {
	return $("select[name='" + name + "']").find("option:selected").val();
}
/**
 * 获得下拉框选中的TEXT
 */
function getSelectedTextById(selectId) {
	return $("#" + selectId).find("option:selected").text();
}
/**
 * 获得下拉框选中的id
 */
function getSelectedValueByID(selectId) {
	return $("#" + selectId).find("option:selected").val();
}
/**
 * 格式化货币
 * 
 * @param val
 * @return
 */
function formatCurrency(val) {
	if (typeof val != "undefined" && null != val && val != "")
		return parseFloat(val).toFixed(2);
	else
		return parseFloat(0).toFixed(2);
}

/**
 * 格式化保留三位小数
 * 
 * @param val
 * @return
 */
function formatFloatToThree(val) {
	if (typeof val != "undefined" && null != val && val != "" && !isNaN(val))
		return parseFloat(val).toFixed(3);
	else
		return parseFloat(0).toFixed(3);
}
function formatFloatToZero(val) {
	if (typeof val != "undefined" && null != val && val != "" && !isNaN(val))
		return parseFloat(val).toFixed(0);
	else
		return parseFloat(0).toFixed(0);
}
function formatFloat(val) {
	if (typeof val != "undefined" && null != val && val != "" && !isNaN(val))
		return parseFloat(val);
	else
		return parseFloat(0);
}

// 验证手机电话
function checkMobile(obj) {
	var mobile = /^0?1(3|4|5|8)\d{9}$/;
	var value = obj.value;
	if (isEmpty(value)) {
		return;
	}
	if (mobile.test(value)) {
		return;
	} else {
		alert("请输入正确的手机号码!");
		obj.value = "";
	}
}
// 验证固定电话
function checkPhone(value) {
	var phone = /^((0\d{2,3})-)(\d{7,8})(-(\d{3,}))?$/;
	if ("" == value || null == value) {
		return true;
	}
	if (phone.test(value)) {
		return true;
	} else {
		alert("请输入正确的固定电话,以区号开头!");
		return false;
	}
}
// 验证电话
function checkMobilePhone(obj) {
	var mobile = /^0?1(3|4|5|8)\d{9}$/;
	var phone = /^((0\d{2,3})-)(\d{7,8})(-(\d{3,}))?$/;
	var value = obj.value;
	if (isEmpty(value)) {
		return;
	}
	if (mobile.test(value) || phone.test(value)) {
		return;
	} else {
		alert("请输入正确的联系电话!");
		obj.value = "";
	}
}
// 设置千分位
function setThousands(value) {
	var re = /\d{1,3}(?=(\d{3})+$)/g;
	var value1 = value.replace(/^(\d+)((\.\d+)?)$/, function(s, s1, s2) {
		return s1.replace(re, "$&,") + s2;
	});
	return value1;
}
// 只能输入数字
function validNum(obj) {
	obj.value = obj.value.replace(/[^\d]/g, '');
}
// 只能输入数字和小数点
function validNumById(id) {
	$('#' + id).val($('#' + id).val().replace(/[^\d]/g, ''));
}
// 只能输入数字、小数点和-,并且规定小数位数
function toDecimalAndFixed1(obj, i) {
	// 先把非数字的都替换掉，除了数字、.和-
	obj.value = obj.value.replace(/[^\d.-]/g, "");
	// 必须保证第一个不是.
	obj.value = obj.value.replace(/^\./g, "");
	// 保证只有出现一个.而没有多个.
	obj.value = obj.value.replace(/\.{2,}/g, ".");
	// 保证只有出现一个-而没有多个-
	obj.value = obj.value.replace(/\-{2,}/g, "-");
	// 保证.只出现一次，而不能出现两次以上
	obj.value = obj.value.replace(".", "$#$").replace(/\./g, "").replace("$#$",
			".");
	// 保证-只出现一次，而不能出现两次以上
	obj.value = obj.value.replace("-", "$#$").replace(/\-/g, "").replace("$#$",
			"-");
	if (isEmpty(obj.value) || obj.value == "-")
		obj.value = 0;
	var num = new Number(obj.value);
	obj.value = num.toFixed(i);
}

// 只能输入数字和小数点并且规定小数位数
function toDecimalAndFixed(obj, i) {
	obj.value = reFixed(obj.value, i);
}
// 只能输入数字和小数点并且规定小数位数（为空时不置0）
function toFixed(obj, i) {
	if (isEmpty(obj.value))
		return;
	obj.value = reFixed(obj.value, i);
}
// 格式化数字为小数
function reFixed(val, i) {
	// 先把非数字的都替换掉，除了数字和.
	val = val.replace(/[^\d.]/g, "");
	// 必须保证第一个为数字而不是.
	val = val.replace(/^\./g, "");
	// 保证只有出现一个.而没有多个.
	val = val.replace(/\.{2,}/g, ".");
	// 保证.只出现一次，而不能出现两次以上
	val = val.replace(".", "$#$").replace(/\./g, "").replace("$#$", ".");
	var num = new Number(val);
	return num.toFixed(i);
}
// 只能输入数字
function controlNum() {
	return event.keyCode >= 48 && event.keyCode <= 57;
}
// 控制金额输入
function controlAmt() {
	return event.keyCode >= 48 && event.keyCode <= 57 || event.keyCode == 46;
}

// 设置查询条件
function setQueryCondition(jsonString) {
	if (jsonString != null && jsonString.length != 0) {
		var json = eval(jsonString);
		for (var i = 0; i < json.length; i++) {
			$("#" + json[i]["name"]).val(json[i]["content"]);
		}
	}
}
// 获得今天的字符串格式
function getTodayString() {
	var date = new Date();
	var year = date.getFullYear();
	var month = (date.getMonth() + 1) < 10 ? "0" + (date.getMonth() + 1)
			: (date.getMonth() + 1);
	var day = date.getDate() < 10 ? "0" + date.getDate() : date.getDate();
	return year + "-" + month + "-" + day;
}
// 获得每月的第一天字符串格式
function getMonthFirstDayString() {
	var date = new Date();
	var year = date.getFullYear();
	var month = (date.getMonth() + 1) < 10 ? "0" + (date.getMonth() + 1)
			: (date.getMonth() + 1);
	return year + "-" + month + "-01";
}
// 获得今年第一天的字符串格式
function getThisYearFirstDayString() {
	var date = new Date();
	var year = date.getFullYear();
	return year + "-01-01";
}
function getFuncName(_callee) {
	var text = _callee.toString();
	var index = text.indexOf("(");
	text = text.substring(0, index);
	text = text.replace("function", "");
	return text.trim();
}
function showOrHiddenColumns(tableId, url, num) {
	var fields = $('#' + tableId + '').datagrid('getColumnFields');
	var filedName = "";
	var field = "";
	var hidden = "";
	for (var i = num; i < fields.length; i++) {
		var opts = $('#' + tableId + '').datagrid('getColumnOption', fields[i]);
		field += "," + fields[i];
		filedName += "," + opts.title;
		hidden += "," + opts.hidden;
	}
	url += "?_columnFiled=" + field + "&_columnTitle=" + filedName
			+ "&_columnsHidden=" + hidden;
	url = encodeURI(encodeURI(url));
	f_open("列表字段显示与隐藏", "列表字段显示与隐藏", "40%", "70%", url, true);
}

/**
 * 保存grid样式
 */
function saveGridStyle(tableId, url) {
	var clms = $("#" + tableId).datagrid('options').columns;
	var columns = '[[';
	for (var i = 0; i < clms[0].length; i++) {
		columns += '{';
		columns += 'field:\"' + clms[0][i].field + '\",';
		if (typeof (clms[0][i].title) != "undefined")
			columns += 'title:\"' + clms[0][i].title + '\",';
		if (typeof (clms[0][i].width) != "undefined")
			columns += 'width:' + clms[0][i].width + ',';
		if (typeof (clms[0][i].align) != "undefined")
			columns += 'align:\"' + clms[0][i].align + '\",';
		if (typeof (clms[0][i].sortable) != "undefined")
			columns += 'sortable:' + clms[0][i].sortable + ',';
		if (typeof (clms[0][i].hidden) != "undefined")
			columns += 'hidden:' + clms[0][i].hidden + ',';
		if (typeof (clms[0][i].resizable) != "undefined")
			columns += 'resizable:' + clms[0][i].resizable + ',';
		if (typeof (clms[0][i].headalign) != "undefined")
			columns += 'headalign:\"' + clms[0][i].headalign + '\",';
		if (typeof (clms[0][i].formatter) != "undefined") {
			var format = getFuncName(clms[0][i].formatter);
			columns += 'formatter:' + format + ',';
		}
		if (typeof (clms[0][i].checkbox) != "undefined") {
			columns += 'checkbox:\"' + clms[0][i].checkbox + '\",';
		}
		columns = columns.substring(0, columns.length - 1);
		columns += '},';
	}
	columns = columns.substring(0, columns.length - 1);
	columns += ']]';
	$.ajax({
		url : encodeURI(encodeURI(url)),
		type : 'post',
		data : {
			'_gridStyle' : columns
		},
		cache : false,
		async : false,
		success : function(result) {

            layer.msg(result.msgDesc);

		},
		error : function() {
			$.messager.alert('警告', "出现异常，请联系系统管理员!", 'error');
		}
	});
}
/**
 * 将字符串转换为json字符串，字符串格式为'111','22','333' , key代表属性值
 */
function convertStringToJsonStr(targetStr, key) {
	var arr = new Array();

	if (targetStr != null && targetStr != "") {
		var strsArr = targetStr.split(",");
		for (var i = 0; i < strsArr.length; i++) {
			if (strsArr[i] != "") {
				var obj = {};
				obj[key] = strsArr[i];
				arr[i] = obj;
			}
		}
	}
	var jsonStr = JSON.stringify(arr);
	return jsonStr;
}

// 以下几个方法暂时放到此处
// 以下代码用于创建标签按钮，可以删除按钮，用于显示辅营老师的显示
function getAidTeacherIds() {
	var str = "";
	$("input[name='aidTeacher']").each(function() {
		str += ',' + $(this).val();
	});
	var s = str.substring(1);
	return s;
}
function initAidTeacher(aidTeacherList, path) {
	for (var i = 0; i < aidTeacherList.length; i++) {
		var aidTeacher = aidTeacherList[i];
		addAidTeacher(aidTeacher.teacherId, aidTeacher.teacherName, path);
	}
}
function addAidTeacher(key, val, path) {
	var li_id = $(".label li:last-child").attr('id');
	if (li_id != undefined) {
		li_id = li_id.split('_');
		li_id = parseInt(li_id[1]) + 1;
	} else {
		li_id = 0;
	}
	$(".label_box").css("display", "block");
	var text = "<li id='li_" + li_id
			+ "'><a href='javascript:;'><span name='aidTeacher' id='v_" + li_id
			+ "'>" + val + "<span><img src='" + path
			+ "/res/public/img/form/label_03.png' onclick='delAidTeacher("
			+ li_id + ");' class='label-pic'></a><input type='hidden' id='k_"
			+ li_id + "' name='aidTeacher' value='" + key + "'></li>";
	$(".label").append(text);
}
function delAidTeacher(id) {
	$("#li_" + id).remove();
	var li_id = $(".label li:last-child").attr('id');
	if (li_id == undefined) {
		$(".label_box").css("display", "none");
	}
}
function unique(arr) {
	var result = [], hash = {};
	for (var i = 0, elem; (elem = arr[i]) != null; i++) {
		if (!hash[elem]) {
			result.push(elem);
			hash[elem] = true;
		}
	}
	return result;
}
function showNewContent(value, length) {
	if (value == null)
		return "";
	if (value.length > length)
		str = '<a id="titlekey" title="' + value
				+ '"    style="cursor: pointer;color:#676a6c;">'
				+ value.substring(0, length) + '...' + '</a>';
	else
		str = value;
	return str;
}

// 展示
function showFile(tableId, index, contentUrl) {
	var rows = $('#' + tableId).datagrid('getData').rows;
	if (rows[index].fileType == "mp3" || rows[index].fileType == "wav") {
		var width = 800;
		var height = 500;
		var swfpath = rows[index].filePath + rows[index].attrId + "."
				+ rows[index].fileType;
		var importurl = contentUrl + "/fileView/showFJYP.action?_filePath="
				+ swfpath;
		f_open("showFJYP", "展示音频文件", width, height, importurl, true);
	} else if (rows[index].fileType == "mp4" || rows[index].fileType == "webm"
			|| rows[index].fileType == "ogg") {
		var width = 800;
		var height = 500;
		var swfpath = rows[index].filePath + rows[index].attrId + "."
				+ rows[index].fileType;
		var importurl = contentUrl + "/fileView/showFJScreen.action?_filePath="
				+ swfpath;
		f_open("showScreen", "展示视屏", width, height, importurl, true);
	} else if (rows[index].fileType == "jpg" || rows[index].fileType == "png"
			|| rows[index].fileType == "jpeg" || rows[index].fileType == "bmp") {
		var width = 900;
		var height = 600;
		var swfpath = "projectdata/" + rows[index].filePath
				+ rows[index].attrId + "." + rows[index].fileType;
		var importurl = contentUrl + "/fileView/showImage.action?_filePath="
				+ swfpath;
		f_open("showImage", "展示图片", width, height, importurl, true);
	} else if (rows[index].isConversion == "1") {
		if (rows[index].isChangerSwf == "1") {
			var width = 900;
			var height = 600;
			var swfpath = rows[index].atts_path + rows[index].swf_path
					+ rows[index].file_name + ".swf";
			var importurl = contentUrl
					+ "/fileView/showFJSwf.action?_filePath=" + swfpath;
			f_open("showSWF", "展示SWF", width, height, importurl, true);
		} else {
			var width = 900;
			var height = 600;
			var swfpath = rows[index].filePath + rows[index].attrId + ".pdf";
			var importurl = contentUrl
					+ "/fileView/showFJPDF.action?_filePath=" + swfpath;
			f_open("showPDF", "展示PDF", width, height, importurl, true);
		}
	} else if (rows[index].isConversion == '0') {
		$.messager.alert("提示", "转换未完成请等待", "info");
	} else if (rows[index].isConversion == '-1') {
		$.messager.alert("提示", "此格式文件不能查看", "info");
	}
}

// 展示
function showFileSpecial(tableId, index, contentUrl, checkUri) {
	var rows = $('#' + tableId).datagrid('getData').rows;
	if (rows[index].is_conversion == '-1') {
		if (rows[index].file_type == "mp3" || rows[index].file_type == "wav") {
			var width = 800;
			var height = 500;
			var swfpath = rows[index].filePath + rows[index].attrId + "."
					+ rows[index].fileType;
			var importurl = contentUrl + "/fileView/showFJYP.action?_filePath="
					+ swfpath;
			f_open("showFJYP", "展示音频文件", width, height, importurl, true);
		} else if (rows[index].file_type == "mp4"
				|| rows[index].file_type == "webm"
				|| rows[index].file_type == "ogg") {
			var width = 800;
			var height = 500;
			var swfpath = rows[index].filePath + rows[index].attrId + "."
					+ rows[index].fileType;
			var importurl = contentUrl
					+ "/fileView/showFJScreen.action?_filePath=" + swfpath;
			f_open("showScreen", "展示视屏", width, height, importurl, true);
		} else if (rows[index].file_type == "swf") {
			// 获取token
			$.ajax({
				url : encodeURI(encodeURI(contentUrl + checkUri + "?_attsId="
						+ rows[index].id)),
				type : 'post',
				cache : false,
				async : false,
				success : function(result) {
					if (result.isExist == false) {
						$.messager.alert('警告', "文件不存在,请联系管理员！", 'info');
					} else {
						var token = result.token;
						var filePath = result.filePath;
						var showUrl = contentUrl
								+ "/fileView/showSwfSpecial.action?_filePath="
								+ filePath + "&_token=" + token;
						window.open(showUrl);
					}
				},
				error : function() {
					$.messager.alert('警告', "出现异常，请联系系统管理员!", 'error');
				}
			});
		}
	} else if (rows[index].is_conversion == '1') {
		if (rows[index].is_changer_swf == '1') {

			var width = 800;
			var height = 500;
			var swfpath = rows[index].atts_path + rows[index].swf_path
					+ rows[index].file_name + ".swf";
			var importurl = contentUrl
					+ "/fileView/showFJSwf.action?_filePath=" + swfpath;
			f_open("showSWF", "展示SWF", width, height, importurl, true);

		} else {
			var width = 940;
			var height = 500;
			var swfpath = rows[index].filePath + rows[index].attrId + ".pdf";
			var importurl = contentUrl
					+ "/fileView/showFJPDF.action?_filePath=" + swfpath;
			f_open("showPDF", "展示PDF", width, height, importurl, true);
		}
	} else if (rows[index].is_conversion == '0') {
		$.messager.alert("提示", "转换未完成请等待", "info");
	} else {
		$.messager.alert("提示", "此格式文件不能查看", "info");
	}
}

var _condtionShowFlag = false;
/**
 * 隐藏或显示查询条件 默认是展开的
 */
function doHideOrShowH() {
	if (_condtionShowFlag) {
		_condtionShowFlag = false;
		$("#hideOrShowBt").html(
				"<i class='fa fa-arrow-down'></i>&nbsp;&nbsp;显示条件");
		var height = $(window).height() - 90;
		$(".panel datagrid").css('height', height + 'px');
		$(".datagrid-view").css('height', height + 'px');
		$(".panel-body").css('height', height + 50 + 'px');
		$(".datagrid-body").css('height', height - 60 + 'px');
	} else {
		_condtionShowFlag = true;
		$("#hideOrShowBt").html(
				"<i class='fa fa-arrow-up'></i>&nbsp;&nbsp;隐藏条件");
		var height = $(window).height() - 90
				- $("#searchArea").outerHeight(true);
		$(".panel datagrid").css('height', height + 'px');
		$(".datagrid-view").css('height', height + 'px');
		$(".panel-body").css('height', height + 50 + 'px');
		$(".datagrid-body").css('height', height - 60 + 'px');
	}
	$("#searchArea").slideToggle();
}
/**
 * 隐藏或显示查询条件 页面有打印功能
 */
function doHideOrShowPrint() {
	if (_condtionShowFlag) {
		_condtionShowFlag = false;
		$("#hideOrShowBt").html(
				"<i class='fa fa-arrow-down'></i>&nbsp;&nbsp;显示条件");
		var height = $(window).height() - 100;
		$(".panel datagrid").css('height', height + 'px');
		$(".datagrid-view").css('height', height + 'px');
		$(".panel-body").css('height', height + 50 + 'px');
		$(".datagrid-body").css('height', height - 60 + 'px');
	} else {
		_condtionShowFlag = true;
		$("#hideOrShowBt").html(
				"<i class='fa fa-arrow-up'></i>&nbsp;&nbsp;隐藏条件");
		var height = $(window).height() - 100
				- $("#searchArea").outerHeight(true);
		$(".panel datagrid").css('height', height + 'px');
		$(".datagrid-view").css('height', height + 'px');
		$(".panel-body").css('height', height + 50 + 'px');
		$(".datagrid-body").css('height', height - 60 + 'px');
	}
	$("#searchArea").slideToggle();
}
/**
 * 隐藏或显示查询条件,datagrid含有查询条件
 */
function doHideOrShowNoQuery() {
	if (_condtionShowFlag) {
		_condtionShowFlag = false;
		$("#hideOrShowBt").html(
				"<i class='fa fa-arrow-down'></i>&nbsp;&nbsp;显示条件");
		var height = $(window).height() - 90;
		$(".panel datagrid").css('height', height + 'px');
		$(".datagrid-view").css('height', height + 'px');
		$(".panel-body").css('height', height + 40 + 'px');
		$(".datagrid-body").css('height', height - 30 + 'px');
	} else {
		_condtionShowFlag = true;
		$("#hideOrShowBt").html(
				"<i class='fa fa-arrow-up'></i>&nbsp;&nbsp;隐藏条件");
		var height = $(window).height() - 90
				- $("#searchArea").outerHeight(true);
		$(".panel datagrid").css('height', height + 'px');
		$(".datagrid-view").css('height', height + 'px');
		$(".panel-body").css('height', height + 40 + 'px');
		$(".datagrid-body").css('height', height - 30 + 'px');
	}
	$("#searchArea").slideToggle();
}
/**
 * 隐藏或显示查询条件,datagrid含有footer
 */
function doHideOrShowF() {
	if (_condtionShowFlag) {
		_condtionShowFlag = false;
		$("#hideOrShowBt").html(
				"<i class='fa fa-arrow-down'></i>&nbsp;&nbsp;显示条件");
		var height = $(window).height() - 100;
		$(".panel datagrid").css('height', height + 'px');
		$(".datagrid-view").css('height', height + 'px');
		$(".panel-body").css('height', height + 40 + 'px');
		$(".datagrid-body").css('height', height - 90 + 'px');
	} else {
		_condtionShowFlag = true;
		$("#hideOrShowBt").html(
				"<i class='fa fa-arrow-up'></i>&nbsp;&nbsp;隐藏条件");
		var height = $(window).height() - 100
				- $("#searchArea").outerHeight(true);
		$(".panel datagrid").css('height', height + 'px');
		$(".datagrid-view").css('height', height + 'px');
		$(".panel-body").css('height', height + 40 + 'px');
		$(".datagrid-body").css('height', height - 90 + 'px');
	}
	$("#searchArea").slideToggle();
}

var _condtionShowFlagT = true;
function doHideOrShow() {
	if (_condtionShowFlagT) {
		_condtionShowFlagT = false;
		$("#hideOrShowBt").html(
				"<i class='fa fa-arrow-down'></i>&nbsp;&nbsp;显示条件");

	} else {
		_condtionShowFlagT = true;
		$("#hideOrShowBt").html(
				"<i class='fa fa-arrow-up'></i>&nbsp;&nbsp;隐藏条件");
	}
	$("#searchArea").slideToggle();
}

function hideOrShow(searchDivId, buttonId) {
	if (_condtionShowFlagT) {
		_condtionShowFlagT = false;

		$("#" + buttonId).html(
				"<i class='fa fa-arrow-down'></i>&nbsp;&nbsp;显示条件");

	} else {
		_condtionShowFlagT = true;
		$("#" + buttonId)
				.html("<i class='fa fa-arrow-up'></i>&nbsp;&nbsp;隐藏条件");
	}
	$("#" + searchDivId).slideToggle();
}

var _condtionBtnShowFlag = true;
/**
 * 隐藏或显示操作按钮 默认是展开的
 */
function doHideOrShowBtn() {
	if (_condtionBtnShowFlag) {
		_condtionBtnShowFlag = false;
		$("#hideBtn")
				.html(
						"<i class='fa fa-arrow-down' onclick='javascript:doHideOrShowBtn()'></i>");
	} else {
		_condtionBtnShowFlag = true;
		$("#hideBtn")
				.html(
						"<i class='fa fa-arrow-up' onclick='javascript:doHideOrShowBtn()'></i>");
	}
	$("#operArea").animate({
		width : 'toggle'
	});
}
/**
 * 检查权限
 * 
 * @param funcCode
 * @param funcCodeArr
 * @returns {Boolean}
 */
function checkIfHasFunctionCode(funcCode, funcCodeArr) {
	var flag = false;
	for (var i = 0; i < funcCodeArr.length; i++) {
		var funcObj = funcCodeArr[i];
		var tempFuncCode = funcObj;
		if (tempFuncCode == funcCode) {
			flag = true;
			break;
		}
	}
	return flag;
}

// 按钮控制
/**
 * 按钮： 保存，提交，办理，退回 保存：（当创建人是自己，并且状态为草稿 ）或者（当创建人是自己，并且当前处理人是自己）
 * 提交：（当创建人是自己，并且状态为草稿 ）或者（当创建人是自己，并且当前处理人是自己，且流程节点是起始节点） 办理：
 * （前处理人是自己的,且流程节点非起始节点） 退回： （当前处理人是自己的,且流程节点非起始节点）
 */
function controlBtnForWP(status, contentUrl, belongUserId) {
	var creatorId = $("#creator_id").val();
	var process_id = $('#process_id').val();
	var url = contentUrl
			+ 'wp/checkCurUserAndGetProInsCurNode.action?_processId='
			+ process_id;
	$.ajax({
		type : 'post',
		cache : false,
		url : url,
		async : false,
		success : function(result) {
			var state = result.state;
			var curUserId = result.curUserId;
			// 当前人可以处理
			if (result.canHandle) {
				if (!isEmpty(belongUserId)) {
					if (belongUserId == curUserId) {
						if (state == "start") {
							$("#back").hide();
						}
					} else {
						$("#save").hide();
						$('#submit').html("<i class='fa fa-check'></i>办理");
					}
				} else {
					if (creatorId == curUserId) {
						if (state == "start") {
							$("#back").hide();
						}
					} else {
						$("#save").hide();
						$('#submit').html("<i class='fa fa-check'></i>办理");
					}
				}

			} else {
				if (isEmpty(process_id) && creatorId == curUserId) {
					$("#back").hide();
					return;
				} else {
					$("#save").hide();
					$("#submit").hide();
					$("#back").hide();
				}

			}
		},
		error : function() {
			alert("出错!请联系管理员!");
		}
	});
}

function queryWorkflow(contentUrl) {

	var url = contentUrl + 'wp/initQueryWorkflow.action?_processId='
			+ $("#process_id").val();
	layer.showWF(url, '审批流程');
}

// 时间从--到 调用
function checkStartAndEndDate(stratId, endId, formatType, istime) {
	// formatType = 'YYYY/MM/DD hh:mm:ss';
	// 日期范围限制
	var start = {
		elem : '#' + stratId,
		format : formatType,
		istime : istime,
		istoday : false
//		choose : function(datas) {
//			end.min = datas; // 开始日选好后，重置结束日的最小日期
//			end.start = datas // 将结束日的初始值设定为开始日
//		}
	};
	var end = {
		elem : '#' + endId,
		format : formatType,
		istime : istime,
		istoday : false
//		choose : function(datas) {
//			start.max = datas; // 结束日选好后，重置开始日的最大日期
//		}
	};
	laydate(start);
	laydate(end);
}

function getRandom(n) {
	return Math.floor(Math.random() * n + 1)
}

$(document).ready(function() {
	var strUrl = window.location.href;
	var arrUrl = strUrl.split("/");
	var strPage = arrUrl[arrUrl.length - 1];
	var index = strPage.indexOf("List");
	// 针对详情界面特殊处理
	if (index < 0) {
		$('body').css('margin-bottom', '50px');
	}
	// 折叠ibox
	$('.collapse-link').click(function() {
		var ibox = $(this).closest('div.ibox');
		var button = $(this).find('i');
		var content = ibox.find('div.ibox-content');
		content.slideToggle(200);
		button.toggleClass('fa-chevron-up').toggleClass('fa-chevron-down');
		ibox.toggleClass('').toggleClass('border-bottom');
		setTimeout(function() {
			ibox.resize();
			ibox.find('[id^=map-]').resize();
		}, 50);
	});
});
/**
 * 根据模块编号获取当前用户的操作 return 数组
 * 
 * @param url
 */
function getFunctions(contextPath, moduleCode) {
	var httpReqest = new HttpRequest();
	var url = contextPath
			+ '/manage/permission/getFunctionList?_curModuleCode=' + moduleCode;
	result = httpReqest.sendRequest(url);
	var funcObjList = result.funcObjs;
	var arrayObj = new Array();
	arrayObj = funcObjList.split(",");
	return arrayObj;
}


// datagrid 根据表头排序
function datagridSort(sort, order, datagridId, url) {
	var obj = $('#' + datagridId);
	obj.datagrid('options').queryParams.sortField = sort;
	obj.datagrid('options').queryParams.sortOrder = order;
	obj.datagrid('options').url = url;
	obj.datagrid('reload');
	obj.datagrid('options').queryParams.cpage = 1;
}
// datagrid 分页
function datagridPagination(pageNumber, pageSize, datagridId, url) {
	var obj = $('#' + datagridId);
	obj.datagrid('options').queryParams.cpage = pageNumber;
	obj.datagrid('options').queryParams.len = pageSize;
	obj.datagrid('options').url = url;
	obj.datagrid('reload');
	obj.datagrid('options').queryParams.cpage = 1;
}


// datagrid 查询
function getAllList(moduleCode,type,xqModul,tempOrderRecordIds,tempOrderType,orderEntrustNum) {
	var url = "/dataGridStyle/getQueryConfig.action?_curModuleCode="+ moduleCode + "";
	var httpReqest = new HttpRequest();
	var response = httpReqest.sendRequest(url);
	var msgCode=response.msgCode;
	var msgDesc=response.msgDesc;
	if(msgCode=="false")
	{
		layer.msg(msgDesc);
		return ;
	}
	var queryConfigStr="";
	var handleDateStr="";
	var queryConfigValue=response.queryConfigValue;
	var filedConfigArr= JSON.parse(queryConfigValue);
	var length = filedConfigArr.length;
	var dicAndFieldNameArr=new Array();
	for (var i = 0; i < length; i++) {
		var fieldConfig=filedConfigArr[i];
		var inputType=fieldConfig.input_type;
		var fieldName=fieldConfig.field_name;
		var dicTable=fieldConfig.dic_table;
		//如果空间类型为label
		if (inputType == "label") {
			queryConfigStr+= " {field:'" + fieldName
					+ "',type:'label'},";
			queryConfigStr+= handleIsOffer(fieldName);
		}
		else if (inputType == "datebox") {
			/*if(moduleCode=="DDGL"&&moduleCode=="DHGL"){
				handleDateStr+=fieldName+",";
			}else{
				queryConfigStr += " {field:'"
					+ fieldName
					+ "',type:'datebox',options:{onChange:function(value){if (value == ''){$('#tt').datagrid('removeFilterRule', '"
					+ fieldName
					+ "');}else{$('#tt').datagrid('addFilterRule', {field: '"
					+ fieldName
					+ "',op: 'equal',value: value});}$('#tt').datagrid('doFilter');}}},";	
			}*/
			handleDateStr+=fieldName+",";
			queryConfigStr+=	handleIsOffer(fieldName);
		}
		/*else if (inputType == "datebox") {
			handleDateStr+=fieldName+",";
			queryConfigStr+=handleIsOffer(fieldName);
		}*/
		else if (inputType == "combobox") {
			queryConfigStr+=handleCombox(fieldName,dicTable,dicAndFieldNameArr);
		}
	}
	//循环完毕之后，一次性到后台查询
	queryConfigStr+= queryDicDataForGridFilter(dicAndFieldNameArr,moduleCode,type,xqModul,tempOrderRecordIds,tempOrderType,orderEntrustNum);	
	var queryConfigAll=new Array(queryConfigStr,handleDateStr);
	return queryConfigAll;
	
}

function handleIsOffer(fieldName)
{
if(fieldName!="is_offer")
{
	return "";
}
var is_offer = '[{"data_content":"全部","data_id":""},{"data_content":"已报价","data_id":"1"},{"data_content":"未报价","data_id":"2"}]';
var queryConfigStr = "{field:'"
		+ fieldName
		+ "',type:'combobox',options:{panelHeight:'auto',data:"
		+ is_offer
		+ ",valueField: 'data_id',textField: 'data_content',onSelect:function(value){if (value.data_id == ''){$('#tt').datagrid('removeFilterRule', '"
		+ fieldName
		+ "');}else{$('#tt').datagrid('addFilterRule', { field: '"
		+fieldName
		+ "', op: 'equal',value: value.data_id }); }$('#tt').datagrid('doFilter');}}},"	;
	
return queryConfigStr; 
}
//如果有不需要查询后天的字段，直接拼接字符串返回，其他的记录再dictable中，最后一起在后台查询，减少前后台交互次数
function handleCombox(fieldName,dicTable,dicAndFieldNameArr)
{
if(fieldName== 'is_offer')
{
	return  handleIsOffer(fieldName);
}
dicAndFieldNameArr[dicAndFieldNameArr.length]=(dicTable+","+fieldName);
return "";
}
//一次性到后台查询数据
function queryDicDataForGridFilter(dicAndFieldNameArr,moduleCode,type,xqModul,tempOrderRecordIds,tempOrderType,orderEntrustNum)
{
var queryConfigStr="";
var dicTableAndFieldNameStr="";//字典名称或者标志，用分号隔开，查询不同数据
for(var i=0;i<dicAndFieldNameArr.length;i++)
{
	if(i==dicAndFieldNameArr.length-1)
		dicTableAndFieldNameStr+=dicAndFieldNameArr[i];
	else
		dicTableAndFieldNameStr+=dicAndFieldNameArr[i]+";";
}

var fromProvCondition ="";
var fromCityCondition = "";
var fromCounCondition = "";
var toProvCondition = "";
var toCityCondition = "";
var toCounCondition = "";
var orderProvCondition = "";
var orderCityCondition = "";
var orderCounCondition = "";
var url = getUrlPro(moduleCode,type,xqModul,tempOrderRecordIds,tempOrderType,orderEntrustNum);
if(url!=""){
	var httpReqest = new HttpRequest();
	var response = httpReqest.sendRequest(url);
	var mapList = response.resultMap;
	fromProvCondition = mapList.fromProv;
	fromCityCondition = mapList.fromCity;
	fromCounCondition = mapList.fromCoun;
	 toProvCondition =  mapList.toProv;
	 toCityCondition =  mapList.toCity;
	 toCounCondition =  mapList.toCoun;
	 orderProvCondition = mapList.orderProv;
	 orderCityCondition = mapList.orderCity;
	 orderCounCondition = mapList.orderCoun;
}
var httpReqest = new HttpRequest();
var url = "/dataGridStyle/getList.action";
/*var url = "/dataGridStyle/getList.action?_dicAndFieldNames="+dicTableAndFieldNameStr
+"&_condition.fromProvCondition="+fromProvCondition
+"&_condition.toProvCondition="+toProvCondition
+"&_condition.orderProvCondition="+orderProvCondition;*/
var transData = '{"_condition.fromProvCondition":' + "\"" +fromProvCondition+"\""+',"_condition.toProvCondition":' + "\"" +toProvCondition+"\""+',"_condition.orderProvCondition":'+"\""+orderProvCondition+"\""+',"_dicAndFieldNames":'+"\""+dicTableAndFieldNameStr+"\""+'}'; 
url=encodeURI(encodeURI(url));
var response = httpReqest.sendRequest(url,JSON.parse(transData));
var dataList = response.dataList;
if(dataList!=null){
	for(var i=0;i<dataList.length;i++)
	{
		
		var dataRow=dataList[i];  
		var dicTableName=dataRow.dicName;
		var fieldName=dataRow.fieldName;
		var dataContent=dataRow.listName;
		if (dicTableName == "fromProv") {
			queryConfigStr += "{field:'"
					+ fieldName
					+ "',type:'combobox',options:{data:"
					+ dataContent
					+ ",valueField: 'provCode',textField: 'provName',onSelect:function(value){" +
					"if (value.provCode == ''){$('#tt').datagrid('removeFilterRule', '"
					+ fieldName
					+ "');}else{$('#tt').datagrid('addFilterRule', { field: '"
					+ fieldName
					+ "', op: 'equal',value: value.provCode }); }$('#tt').datagrid('doFilter');},onChange:function(value){" +
					"getCities(value,'from_loc_city','from_loc_county','"+fromCityCondition+"','"+toCityCondition+"','"+orderCityCondition+"','"+fromCounCondition+"','"+toCounCondition+"','"+orderCounCondition+"'); }}},"
		} else if (dicTableName == "toProv") {
			queryConfigStr += "{field:'"
					+ fieldName
					+ "',type:'combobox',options:{data:"
					+ dataContent
					+ ",valueField: 'provCode',textField: 'provName',onSelect:function(value){"
					+ "if (value.provCode == ''){$('#tt').datagrid('removeFilterRule', '"
					+ fieldName
					+ "');}else{$('#tt').datagrid('addFilterRule', { field: '"
					+ fieldName
					+ "', op: 'equal',value: value.provCode }); }$('#tt').datagrid('doFilter');},onChange:function(value){" 
					+ "getCities(value,'to_loc_city','to_loc_county','"+fromCityCondition+"','"+toCityCondition+"','"+orderCityCondition+"','"+fromCounCondition+"','"+toCounCondition+"','"+orderCounCondition+"'); }}},";
		} else if (dicTableName == "orderProv") {
			queryConfigStr += "{field:'"
					+ fieldName
					+ "',type:'combobox',options:{data:"
					+ dataContent
					+ ",valueField: 'provCode',textField: 'provName',onSelect:function(value){" 
					+"if (value.provCode == ''){$('#tt').datagrid('removeFilterRule', '"
					+ fieldName
					+ "');}else{$('#tt').datagrid('addFilterRule', { field: '"
					+ fieldName
					+ "', op: 'equal',value: value.provCode }); }$('#tt').datagrid('doFilter');},onChange:function(value){"
					+ "getCities(value,'orderReceiveCity','orderReceiveCoun','"+fromCityCondition+"','"+toCityCondition+"','"+orderCityCondition+"','"+fromCounCondition+"','"+toCounCondition+"','"+orderCounCondition+"'); }}},";
		} 
		else if(dicTableName == "D_GOODS_STORE_IN_STATUS"||dicTableName == "d_goods_store_out_status"){
			getStroreInOrOutStatus(fieldName,dataContent);
			/*queryConfigStr += "{field:'"
				+ fieldName
				+ "',type:'combobox',options:{panelHeight:'auto',data:"
				+ dataContent
				+ ",valueField: 'data_id',textField: 'data_content',checkbox:true,multiple:true,onChange:function(value){if (value == ''){$('#tt').datagrid('removeFilterRule', '"
				+ fieldName
				+ "');}else{$('#tt').datagrid('addFilterRule', { field: '"
				+ fieldName
				+ "', op: 'equal',value:value}); }$('#tt').datagrid('doFilter');}}},";*/
		}else{
			queryConfigStr += "{field:'"
					+ fieldName
					+ "',type:'combobox',options:{panelHeight:'auto',data:"
					+ dataContent
					+ ",valueField: 'data_id',textField: 'data_content',onSelect:function(row){ if (row.data_id == ''){$('#tt').datagrid('removeFilterRule', '"
					+ fieldName
					+ "');}else{$('#tt').datagrid('addFilterRule', { field: '"
					+ fieldName
					+ "', op: 'equal',value: row.data_id }); }$('#tt').datagrid('doFilter');}}},";
		}		
	}
}
return queryConfigStr;
}
function getStroreInOrOutStatus(fieldName,dataContent){
	var dieListValue=[];
	data = JSON.parse(dataContent);
	 $('#tt').datagrid('enableFilter', [ {
			field : fieldName,
			type : 'combobox',
			options : {
				panelHeight : 'auto',
				data : data,
				valueField : 'data_id',
				textField : 'data_content',
				multiple:true,
				onSelect:function(row,value){
			        //排除相同选项被多次选择  
					dieListValue.push(row.data_content);
					value="";
					for(i in dieListValue){
						if(row.data_content=='全部'){
							value = '全部';
							dieListValue=[]
							break;
						}
						if(i==0){
							value=dieListValue[0];
						}else{
							value+=","+dieListValue[i];
						}
					}
					if (value == '') {
						$('#tt').datagrid('removeFilterRule', fieldName);
					} else {
						$('#tt').datagrid('addFilterRule', {
							field : fieldName,
							op : 'equal',
							value : value
						});
					}
					$('#tt').datagrid('doFilter');  
			    },onUnselect:function(row){  
			        for(i in dieListValue){  
			            if(dieListValue[i] == row.data_content){  
			            	dieListValue.splice(i,1);  
			            }  
			        }
			    },onChange:function(value){
			    	if(value=='')
			    		dieListValue=[];
			    }
			}
		} ]);
}
function getCities(parentCode, typeCity, tpeCounty,fromCityCondition,toCityCondition,orderCityCondition,fromCounCondtion,toCounCondtion,orderCounCondtion) {
	$('#tt').datagrid('removeFilterRule', typeCity);
	$('#tt').datagrid('removeFilterRule', tpeCounty);
	var url="/dic/getCitiesDic.action"
	/*var url = '/dic/getCitiesDic.action?_parentCode=' + parentCode
	+"&_condition.fromCityCondition="+fromCityCondition
	+"&_condition.toCityCondition="+toCityCondition
	+"&_condition.orderCityCondition="+orderCityCondition
	+"&_typeCode="+typeCity;*/
	var transData = '{"_condition.fromCityCondition":' + "\"" +fromCityCondition+"\""+',"_condition.toCityCondition":' + "\"" +toCityCondition+"\""+',"_condition.orderCityCondition":'+"\""+orderCityCondition+"\""+',"_typeCode":'+"\""+typeCity+"\""+',"_parentCode":'+"\""+parentCode+"\""+'}'; 

	$.ajax({
		type : 'post',
		cache : false,
		url : url,
		data:JSON.parse(transData),
		async : false,
		success : function(result) {
			var data = result.v;
			$('#tt').datagrid('enableFilter', [ {
				field : typeCity,
				type : 'combobox',
				options : {
					panelHeight : 'auto',
					data : data,
					valueField : "cityCode",
					textField : "cityName",
					onChange : function(value) {
						if (value == '') {
							$('#tt').datagrid('removeFilterRule', typeCity);
						} else {
							$('#tt').datagrid('addFilterRule', {
								field : typeCity,
								op : 'equal',
								value : value
							});
						}
						$('#tt').datagrid('doFilter');
					},
					onSelect : function(value) {
						if (typeCity == "from_loc_city") {
							getCoun(value.cityCode, "from_loc_county",fromCounCondtion,toCounCondtion,orderCounCondtion);
						} else if (typeCity == "to_loc_city") {
							getCoun(value.cityCode, "to_loc_county",fromCounCondtion,toCounCondtion,orderCounCondtion);
						} else {
							getCoun(value.cityCode, "orderReceiveCoun",fromCounCondtion,toCounCondtion,orderCounCondtion);
						}
					}
				}
			} ]);
		}
	});
	}
function getCoun(parentCode, type,fromCounCondtion,toCounCondtion,orderCounCondtion) {
	$('#tt').datagrid('removeFilterRule', type);
	/*var url = '/dic/getCountiesDic.action?_parentCode=' + parentCode
	+"&_condition.fromCounCondition="+fromCounCondtion
	+"&_condition.toCounCondition="+toCounCondtion
	+"&_condition.orderCounCondition="+orderCounCondtion
	+"&_typeCode="+type;*/
	var url="/dic/getCountiesDic.action";
	var transData = '{"_condition.fromCounCondition":' + "\"" +fromCounCondtion+"\""+',"_condition.toCounCondition":' + "\"" +toCounCondtion+"\""+',"_condition.orderCounCondition":'+"\""+orderCounCondtion+"\""+',"_typeCode":'+"\""+type+"\""+',"_parentCode":'+"\""+parentCode+"\""+'}'; 
	var dieListValue=[];
	$.ajax({
		type : 'post',
		cache : false,
		url : url,
		data:JSON.parse(transData),
		async : false,
		success : function(result) {
			var data = result.v;
			 $('#tt').datagrid('enableFilter', [ {
					field : type,
					type : 'combobox',
					options : {
						panelHeight : 'auto',
						data : data,
						valueField : "counCode",
						textField : "counName",
						checkbox:true,
						multiple:true,
						onSelect:function(row,value){
					        //排除相同选项被多次选择  
							dieListValue.push(row.counName);
							value="";
							for(i in dieListValue){
								if(i==0){
									value=dieListValue[0];
								}else{
									value+=","+dieListValue[i];
								}
							}
							if (value == '') {
								$('#tt').datagrid('removeFilterRule', type);
							} else {
								$('#tt').datagrid('addFilterRule', {
									field : type,
									op : 'equal',
									value : value
								});
							}
							$('#tt').datagrid('doFilter');  
					    },onUnselect:function(row){  
					        for(i in dieListValue){  
					            if(dieListValue[i] == row.counName){  
					            	dieListValue.splice(i,1);  
					            }  
					        }
					    },onChange:function(value){
					    	if(value=='')
					    		dieListValue=[];
					    }
					}
				} ]);
		}
	});
	}
function getCouncopy(parentCode, type,fromCounCondtion,toCounCondtion,orderCounCondtion) {
	$('#tt').datagrid('removeFilterRule', type);
	var url = '/dic/getCountiesDic.action?_parentCode=' + parentCode
	+"&_condition.fromCounCondition="+fromCounCondtion
	+"&_condition.toCounCondition="+toCounCondtion
	+"&_condition.orderCounCondition="+orderCounCondtion
	+"&_typeCode="+type;
	alert(url);
	$.ajax({
		type : 'post',
		cache : false,
		url : url,
		async : false,
		success : function(result) {
			var data = result.v;
			$('#tt').datagrid('enableFilter', [ {
				field : type,
				type : 'combobox',
				checkbox:true, 
				editable:true,
				//multiSelect :true,
				multiple:true,
				options : {
					panelHeight : 'auto',
					data : data,
					valueField : "counCode",
					textField : "counName",
					onSelect : function(value) {
						alert(value)
						if (value.counCode == '') {
							$('#tt').datagrid('removeFilterRule', type);
						} else {
							$('#tt').datagrid('addFilterRule', {
								field : type,
								op : 'equal',
								value : value.counCode
							});
						}
						$('#tt').datagrid('doFilter');
					}
				}
			} ]);
		}
	});
	}
function getUrlPro(moduleCode,type,xqModul,tempOrderRecordIds,tempOrderType,orderEntrustNum){
var url="";
if("DTHXX"== moduleCode)
{
  url = "/dispatchPickUp/queryPro.action";
}else if("YDLB"== moduleCode){
  url = "/waybillManage/queryPro.action?_bussinessType="+type;
}else if("THDGL"== moduleCode){
  url = "/dispatchPickUp/queryDTHPro.action";
}else if("DYSDGL"== moduleCode){
	  url = "/dispatchTransport/queryYSDPro.action";
}else if("DYSXX"== moduleCode){
	  url = "/dispatchTransport/queryDYSPro.action";
}else if("PSDGL"== moduleCode){
	  url = "/dispatchDelivery/queryPSDPro.action";
}else if("DPSXX"== moduleCode){
	  url = "/dispatchDelivery/queryDPSPro.action";
}
else if("DDGL"== moduleCode&&"DDWTXQ"!=xqModul&&"ZDCLFYGL"!=xqModul){
	  url = "/order/queryPro.action";
}
else if("DDGL"== moduleCode&&"DDWTXQ"==xqModul){
	url = "/order/queryPro.action?_condition.querySourse="+xqModul+"&_condition.entrustNum="+orderEntrustNum;
}
else if("DDGL"== moduleCode&&"ZDCLFYGL"==xqModul){
	url = "/order/queryPro.action?_condition.querySourse="+xqModul+"&_condition.assignVehicleId="+orderEntrustNum;
}
else if("KSLRXXGL"== moduleCode){
	  url = "/fastHandle/queryPro.action";
}
else if("DHGL"== moduleCode){
	  url = "/order/queryDHPro.action";
}
else if("DDDH"== moduleCode){
	  url = "/order/queryTempPro.action?_recordIds="+tempOrderRecordIds+"&_orderType="+tempOrderType;
}
else if("DDYMX"== moduleCode){
	  url = "/order/queryTempPro.action?_recordIds="+tempOrderRecordIds+"&_orderType="+tempOrderType;
}
else if("DDZL"== moduleCode){
	  url = "/order/queryTempPro.action?_recordIds="+tempOrderRecordIds+"&_orderType="+tempOrderType;
}
else if("ZDCLFYGL"== moduleCode){
	  url = "/assignVehiclePrice/queryPro.action";
}
return url;
}
function initSetTime(){
	var idStr = '';
	var selectedRows = $("#tt").datagrid("getSelections");
	if(!isEmpty(selectedRows)){
        for(var i=0;i<selectedRows.length;i++){
            if(selectedRows[i].dispatch_status_code=="CG"){
                idStr+=","+selectedRows[i].id;
             }else{
                 layer.msg("只有草稿状态的调度单才能进行批量设置!"+selectedRows[i].dispatch_num+"不是草稿状态!");
                 return;
             }
        }
        idStr=idStr.substr(1,idStr.length);
    }else{
    	layer.msg("请选中行!")
    	return;
    }
	windowName = "setTime";
	windowTitle = "设置时间";
	width = "30%";
	height = "50%";
	var url = "/typCommondispatch/indexSetDispacthTimeInfo.action?_dispatchIdsStr="+idStr;
	url = encodeURI(encodeURI(url));
	f_open(windowName, windowTitle, width, height, url, true);
}
//批量设置时间
function multiSetTime(fromTime,toTime,idStr){
	var msgnums='';
	var selectedRows = $("#tt").datagrid("getSelections");
        for(var i=0;i<selectedRows.length;i++){
            if(selectedRows[i].dispatch_status_code=="CG"&&!isEmpty(selectedRows[i].required_send_date)&&!isEmpty(selectedRows[i].expected_arrived_date)){
            	msgnums+=","+selectedRows[i].dispatch_num;
             }
        }
        msgnums=msgnums.substr(1,msgnums.length);
        if(!isEmpty(msgnums)){
        	msgnums+='等调度单已存在时间,继续降覆盖原有时间,';
        }
	 layer.confirm(msgnums+'确定设置吗?', {
         btn : [ '确定', '取消' ], //按钮
         shade : false
     //不显示遮罩
     }, function(index) {
    	  var url='/typCommondispatch/multiDispatchSetTime.action?_dispatchIdsStr='
              + idStr+"&_fromTime="+fromTime+"&_endTime="+toTime;
          $.ajax({
                  url : url,
                  type : 'post',
                  cache : false,
                  async : true,
                  success : function(data) {
                      if(data.success){
                          layer.msg(data.msgDesc,{time:1000},function(){
          	                $('#tt').datagrid('reload');
                          });
                      }else{
                          layer.msg(data.msgDesc);
                      }
                  },error:function(data){
              	   layer.msg('出错!请联系管理员!');
                  }
              });
     }, function(index) {
         layer.close(index);
     });
}
function saveQueryContionCache(mouleCode,_filterRule,_conditionName,_conditionMark){
	url = "/saveQueryCondition/saveDatagridQueryCondition.action?_curModuleCode="+mouleCode+"&_filterRule="+_filterRule+"&_conditionName="+_conditionName+"&_conditionMark="+_conditionMark;
	$.ajax({
		type:'post',
		cache:false,
		url:encodeURI(encodeURI(url)),
		async:false,
		success:function(result){
			if(result.success){
				parent.layer.msg(result.msg);
			}else{
				parent.layer.msg(result.msg);
			}
		},
		error:function(result) {
			layer.msg("系统异常，请联系系统管理员");
		}
	});
}
function getQueryContionCache(mouleCode){
	url = "/saveQueryCondition/getDatagridQueryCondition.action?_curModuleCode="+mouleCode; 
	$.ajax({
		type:'post',
		cache:false,
		url:url,
		async:false,
		success:function(result){
			if(result.success){
				var data = JSON.parse(result.conditionData); 
				for(var i=0;i<data.length;i++){
					var condition_field = data[i].field;
					var condition_value = data[i].value;
					var condition_op = data[i].op; 
					$('#tt').datagrid('addFilterRule',{
						field : condition_field,
						op : condition_op,
						value : condition_value
					});  
				}  
				$('#tt').datagrid('doFilter'); 
			}
		},
		error:function(result) {
			layer.msg("系统异常，请联系系统管理员");
		}
	});
}
function doClearCondition(mouleCode){
	url = "/saveQueryCondition/doClearQueryCondition.action?_curModuleCode="+mouleCode;
	$.ajax({
		type:'post',
		cache:false,
		url:url,
		async:false,
		success:function(result){
			if(result.success){
				layer.msg(result.msg);
			}
		},
		error:function(result) {
			layer.msg("系统异常，请联系系统管理员");
		}
	});
}
function doSelectCondition(_curModuleCode){
	 var url = "/saveQueryCondition/doSelectCondition.action?_curModuleCode="+_curModuleCode;
	 var width = "35%";
	 var height = "80%";
	 f_open("selectCondition", "查询条件", width, height, url, true);   
}
function addSelectOption(selectListValue,selectKey){
	$("#"+selectKey).append("<option ></option>");
	for(var i=0;i<selectListValue.length;i++){
		$("#"+selectKey).append("<option  value="+selectListValue[i].data_code+">"+selectListValue[i].data_name+"</option>");
	}

}
function doSelectValue(selectListValue,selectKey){
	var arrayItem = selectListValue.split("],");
	$("#"+selectKey).empty();
	var option1 = $("<option>").val("").text("");
	$("#"+selectKey).append(option1);
	for(var i=0;i<arrayItem.length;i++){
		var item = arrayItem[i];
		item=item.replace("[[","");
		item=item.replace("[","");
		item=item.replace("]]","");
		item=item.replace("]","");
		var itemArray = item.split(",");
		var itemvalue="";
		if(itemArray[0]!="" && itemArray[0]!=null)
			itemvalue=itemArray[0].replace(" ","");
		var itemText ="";
		if(itemArray[1]!="" && itemArray[1]!=null)
			itemText=itemArray[1].replace(" ","");
		var option = $("<option>").val(itemvalue).text(itemText);

		$("#"+selectKey).append(option);
	}
}
function doSaveConditionMark(_curModuleCode,_filterRule){
	if(typeof _filterRule != 'undefined'&&_filterRule!=''){
		 var url = "/saveQueryCondition/doSaveConditionMark.action?_curModuleCode="+_curModuleCode+"&_filterRule="+_filterRule;
		 var width = "50%";
		 var height = "32%";
		 f_open("saveCondition", "保存查询条件", width, height,encodeURI(encodeURI(url)), true); 
	}else{
		layer.msg('未检测到查询条件');
	}

}
function getLineDate() {
	for (var i = 5; i > -1; i--) {
		var nowdate = new Date();
		nowdate.setMonth(nowdate.getMonth() - i);
		var y = nowdate.getFullYear();
		var m = nowdate.getMonth() + 1;
		var formatwdate = ""
		if (0 < m && m < 10) {
			formatwdate = y + '-0' + m;
		} else {
			formatwdate = y + '-' + m;
		}
		lineDate.push(formatwdate)
	}
}
function getOneYearMonthDate() {
	for (var i = 11; i > -1; i--) {
		var nowdate = new Date();
		nowdate.setMonth(nowdate.getMonth() - i);
		var y = nowdate.getFullYear();
		var m = nowdate.getMonth() + 1;
		var formatwdate = ""
		if (0 < m && m < 10) {
			formatwdate = y + '-0' + m;
		} else {
			formatwdate = y + '-' + m;
		}
		lineDate.push(formatwdate)
	}
}

function getLineYearDate() {
	var d = new Date()
	var nowYear = d.getFullYear()-6;
	for (var i = 5; i > -1; i--) {
		nowYear++;
		lineYearDate.push(nowYear)
	}
}
function geCurYearMonth() {
	var d = new Date()
	var nowYear = d.getFullYear();
	for(var i=1;i<13;i++){
		var formatwdate = ""
		if (0 < i && i < 10) {
			formatwdate = nowYear + '-0' + i;
		} else {
			formatwdate = nowYear + '-' + i;
		}
		curYearMonth.push(formatwdate)
	}

}
function getNowFormatDate() {
	var date = new Date();
	var seperator1 = "-";

	var month = date.getMonth() + 1;
	var strDate = date.getDate();
	if (month >= 1 && month <= 9) {
		month = "0" + month;
	}
	if (strDate >= 0 && strDate <= 9) {
		strDate = "0" + strDate;
	}
	var currentdate = date.getFullYear() + seperator1 + month + seperator1 + strDate;

	return currentdate;
}
Array.prototype.remove=function(obj){
	for(var i =0;i <this.length;i++){
		var temp = this[i];
		if(!isNaN(obj)){
			temp=i;
		}
		if(temp == obj){
			for(var j = i;j <this.length;j++){
				this[j]=this[j+1];
			}
			this.length = this.length-1;
		}
	}
}
$.extend($.fn.datagrid.defaults.editors, {

	textarea: {
		init: function (container, options) {
			var input = $('<textarea class="datagrid-editable-input" rows=' + options.rows + '></textarea>').appendTo(container);
			return input;
		},
		getValue: function (target) {
			return $(target).val();
		},
		setValue: function (target, value) {
			$(target).val(value);
		},
		resize: function (target, width) {

			var input = $(target);
			if ($.boxModel == true) {
				input.width(width - (input.outerWidth() - input.width()));
			} else {
				input.width(width);
			}
		}
	}
});