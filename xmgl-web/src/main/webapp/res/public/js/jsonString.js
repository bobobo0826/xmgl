
StringUtil = new SU();
HtmlUtil = new HU();

// 字符串工具类
function SU() {
	var _this = this;
	SU.prototype.isNullOrBlank = function(str) {
		return str == null || str == undefined || str.trim() == "";
	}
	SU.prototype.isNotNullOrBlank = function(str) {
		return !_this.isNullOrBlank(str);
	}
	SU.prototype.empty = "";
}

// Dom操作工具类
function HU() {
	var _this = this;
	HU.prototype.get = function(id) {
		return document.getElementById(id);
	}
	HU.prototype.getValue = function(id) {
		var obj = _this.get(id);
		if (obj == null || obj.value == null) {
			return StringUtil.empty;
		}
		return obj.value;
	}
	HU.prototype.setValue = function(id, val) {
		var obj = _this.get(id);
		if (obj != null) {
			obj.value = val;
		}
	}
	HU.prototype.disableObj = function(id) {
		_this.get(id).disabled = true;
	}
}
function debug(str) {
	alert(str);
}


/*
 * 自动将input（type="text"）中的数据组装成JSON放到input(type="hidden")中
 * inId:input（type="text"）的ID hiId:input（type="hidden"）的ID
 */
function packJson(inId, hiId) {
	var json = new Object();
	var obj = HtmlUtil.get(inId);
	var jsonCon = HtmlUtil.get(hiId);
	if (StringUtil.isNotNullOrBlank(jsonCon.value)) {
		json = JSON.parse(jsonCon.value);
		json[obj.id] = obj.value;
	} else {
		json[obj.id] = obj.value;
	}
	jsonCon.value = JSON.stringify(json);
}
//將Json数据塞到界面
function putJson(jsonStr)
{
	var jsonStrto = jsonStr.replace(/&quot;/g,"\"");
	if(StringUtil.isNullOrBlank(jsonStrto))
	{
		return;
	}
	json = JSON.parse(jsonStrto);
	for(var attr in json)
	{
		HtmlUtil.get(attr).value = json[attr];
	}
}

