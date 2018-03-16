/**
 * 构造一个Map对象
 * @author Jinqiao
 * @since 2015/3/31
 */

function Map() {
	this.container = new Object();
}
Map.prototype.put = function(key, value) {
	this.container[key] = value;
}
Map.prototype.get = function(key) {
	return this.container[key];
}
Map.prototype.keySet = function() {
	var keyset = new Array();
	var count = 0;
	for (var key in this.container) {
		if (key == 'extend') {
			continue;
		}

		keyset[count] = key;
		count++;
	}
	return keyset;
}
Map.prototype.size = function() {
	var count = 0;
	for (var key in this.container) {
		if (key == 'extend') {
			continue;
		}
		count++;
	}
	return count;
}
Map.prototype.remove = function(key) {
	delete this.container[key];
}
Map.prototype.toString = function(){
	var str = "";
	for (var i = 0, keys = this.keySet(), len = keys.length; i < len; i++) {
		str = str + keys[i] + "=" + this.container[keys[i]] + ";\n";
	}
	return str;
}

Map.prototype.putArray=function(arr,keyName,valueName){
	for(var i=0;i<arr.length;i++)
	{
		var tempObj=arr[i];
		this.put(tempObj[keyName],tempObj[valueName]);
	}
}
Map.prototype.getArr=function(keyName,valueName)
{
	var keySet=this.keySet();
	var arr = new Array(); 
	var count=0;
	for(var i=0;i<keySet.length;i++)
	{
		var obj=new Object();
		var keyValue=keySet[i];
		obj[keyName]=keyValue;
		obj[valueName]=this.get(keyValue);
		arr[count]=obj;
		count++;
	}
	return arr;
}