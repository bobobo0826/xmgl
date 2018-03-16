/***
 * Created by Mjq. 2016/2/1
 * 对表单中一些公共方法进行分离
 */


/**
 * 设置只读元素样式
 * @param formId
 */
function setReadonlyElements(formId) { $("#"+formId+" *[readonly=true]").css("background-color", "#f3f3f3"); }
/**
 * 验证表单元素必填
 * 引入layer.js弹出层框架，以后如果需要改动，重新修改（暂时不处理）
 */
function validateForm(formId) {
	var es = $("#"+formId+" *[required='true']");
	if (es.length > 0) {
		for (var i = 0;i < es.length;i++) {
			var e = es[i];
			if ($.trim($(e).val()) == "") {
				layer.tips('该字段必填', '#' + $(e).attr("id"));
				return false
			}
		}
	}
	return true;
}
/**
 * 鼠标离开事件，校验必填
 */
function validateRequired() {
	var es = $("input[required='true'],select[required='true']");
	if (es.length > 0) {
		for (var i = 0;i < es.length;i++) {
			var e = es[i];
			var id = $(e).attr("id");
			if (typeof id != "undefined") {
				$("#" + id).blur(function() {
					if ($.trim($(e).val()) == "") {
						layer.tips('该字段必填', '#' + id);	
					}
				});
			}
		}
	}
}