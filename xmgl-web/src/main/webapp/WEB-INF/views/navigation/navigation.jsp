<script src="${root}/res/hplus/js/plugins/suggest/bootstrap-suggest.min.js"></script>
<script type="text/javascript">
$(document).ready(function(){
	initNavigationCombox();
	initNavigationRecord();
	$("#moduleName").click(
		function() {
				$("#operDiv").hide();
	})
});
function initNavigationRecord(){
	var url="${root}/manage/navigation/getNavigationBefore";
	$.ajax({
		type:'post',
		cache:false,
		url:url,
		async:false,
		success:function(result){
			var recordList = result.record;
			if(recordList!='')
				for(var i=0;i<recordList.length;i++){
					showNavigationRecord(recordList[i].module_name,recordList[i].module_method,recordList[i].id);
				}
		}
	});
}
function initNavigationCombox(){
	$("#moduleName").bsSuggest("destroy");
	var url="${root}/manage/navigation/getNavigationList";
 	$("#moduleName").bsSuggest({
	 url: url,
     effectiveFields: ["modulename"],  
     idField: "method",
     keyField: "modulename"
 }).on('onSetSelectValue', function (e, keyword) {
		$("#method").val(keyword.id);
	  //$("#moduleName").val('');
 });
}
$(document).keyup(function(event) {
    if (event.keyCode == 13) {
        initOnSelect($("#moduleName").val(),$("#method").val());
    }
});
function initOnSelect(name,method){
	var url="${root}/"+method;
	saveNavigationRecord(name,method);
	parent.addTab(name,url);
}
function saveNavigationRecord(name,method){
	var url = "${root}/manage/navigation/saveNavigationRecord?_name="+name+"&_method="+method;
	$.ajax({
		type:'post',
		cache:false,
		url:encodeURI(encodeURI(url)),
		async:false,
		success:function(result){
			$("#operDiv").html('');
			initNavigationRecord();
			$("#operDiv").show();
		}
	});
}
function showNavigationRecord(name,method,id){
	 var html = '<div class="col-sm-6">';
	 html +='<span>';
     html += '<a href="#"';
     html += 'onclick="goRecordIndex(\''+name+'\',\''+method+'\');">';
     html += name+'</a><img src="${root}/res/public/img/form/label_03.png" onclick="delDiv(this,'+id+');" class="label-pic" >';
     html += '</span></div>';
     $("#operDiv").append(html);
}
function delDiv(obj,id) {
    $(obj).parent().remove();
    deleNavigation(id);
}
function deleNavigation(id){
	var url = "${root}/manage/navigation/deleNavigationRecord?_id="+id;
	$.ajax({
		type:'post',
		cache:false,
		url:url,
		async:false,
		success:function(result){
		}
	});
}
function goRecordIndex(name,method){
	var url = "${root}/"+method;
	saveNavigationRecord(name,method);
	parent.addTab(name,url);
}
function goQuery(){
	//$("#operDiv").hide();
    initOnSelect($("#moduleName").val(),$("#method").val());
}
</script>
<li >
<div class="input-group"  style="width:350px;">
	<input type="hidden" id="method" name="method">
	<div class="input-group-btn">
		<a href="javascript:goQuery();"><i class="fa fa-search"></i></a>
	</div>
	<input id="moduleName" name="moduleName" class="form-control" onChange="clearOp()"/>
	<div class="input-group-btn">
	     <ul class="dropdown-menu dropdown-menu-right" role="menu" id="sel">
	     </ul>
    </div>
    </div>
</li> 
<li >
<div class="form-group J_menuItem" style="margin-left:20px" id="operDiv">
							
</div>
</li>	

