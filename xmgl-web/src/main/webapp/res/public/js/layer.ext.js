/**
 * 作者：mengjinqiao
 * 日期：2016年3月29日
 */

;(function(layer) {
	if (typeof layer === "undefined") layer = {};
	
	layer.showWF = function (url,title) {
		layer.open({
	   		type: 2,
	   	    title: title,
	   	    closeBtn: 1, //不显示关闭按钮
	   	    shade: [0],
	   	    area: ['340px', '405px'],
	   	    offset: 'rb', //右下角弹出
	   	    //time: 10000,
	   	    shift: 2,
	   	    content: [url, 'yes'] //iframe的url，no代表不显示滚动条
	   	});
	}
	layer.success = function(m) { layer.msg(m, {icon: 1}); }
	layer.error = function(m) { layer.msg(m, {icon: 2}); }
	layer.question = function(m) { layer.msg(m, {icon: 3}); }
})(layer);
