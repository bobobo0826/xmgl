//部门选择界面回掉这个函数
function setDepts(dept){
	if(dept==null || dept=="")
		return;
	var deptCodes="";
	var deptName="";
	for(var i=0;i<dept.length;i++){
		var deptInfo=dept[i];
		if(i==dept.length-1){
			deptCodes+=deptInfo.deptCode;
			deptName+=deptInfo.deptName;
		}else{
			deptCodes+=deptInfo.deptCode+",";
			deptName+=deptInfo.deptName+",";
		}
	}
	$("#deptName").val(deptName);
	$("#deptCode").val(deptCodes); 
}

function selectDeptAndSetVal(url){
	var selIds=$("#deptIds").val();
	url += "?_selIds="+selIds; 
	dlg.showDeptDialog(_deptWinWidth,_deptWinHeight,url,function(ids,names){
		 $("#deptIds").val(ids);
		 $("#deptName").val(names);
	});
}

