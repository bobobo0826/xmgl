<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html >
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>
<script type="text/javascript" src="${root}/res/public/js/common.js" charset="UTF-8"></script> <!-- 工具 -->
<link rel="stylesheet" type="text/css" href="${root}/res/ui/css/style.css" />
<link rel="stylesheet" type="text/css" href="${root}/thirdparty/zTree_v3/css/zTreeStyle/zTreeStyle.css" />
<script type="text/javascript" src="${root}/thirdparty/zTree_v3/js/jquery-1.4.4.min.js"></script>
<script type="text/javascript" src="${root}/thirdparty/zTree_v3/js/jquery.ztree.all-3.5.min.js"></script>
<script src="${root}/thirdparty/jqueryalerts/jquery.alerts.js"></script>
<link rel="stylesheet" href="${root}/thirdparty/jqueryalerts/jquery.alerts.css">
<style type="text/css">
*{ 
	margin:0px; 
	padding:0px; 
	font-size:14px;
	font-family:微软雅黑,tahoma;
} 
html,body{ 
	height:100%; 
} 
* html, * html body { 
	overflow: hidden; /*隐藏IE的默认滚动条的宽度*/ 
} 
#bodyDiv{ 
	width:100%; 
	height:100%; 
} 
#topDiv{ 
	height:70%; 
	overflow:auto; /*溢出的时候显示滚动条为 auto */ 
} 
#bottomDiv{ 
	height:30%; 
	border:1px solid #8DB2FF; 
	margin-top:-4px; 
	overflow:auto; 
}
</style> 
</head>
<body ng-app="roletreebody" ng-controller="roletreeCtrl">
<form method="post">
<%--<s:hidden name="_dialogName" id="dialogName"></s:hidden>--%>
	<script type="text/javascript">
		var className = "dark", curDragNodes, autoExpandNode;
	    var _FONT_GREEN = {'color':"#008000",'font-weight':'bold'};
	    var _FONT_DEF = {'color':"#000000",'font-weight':'normal'};
	    var setting = {
				view: {
					showIcon: false,
					showLine: true,
					fontCss:function(treeId, node) {
						var fontStyle = _FONT_DEF;
						return fontStyle;
					}
				},
				data: {
					keep: {
						//parent: true
					}
				},
				callback:{
					onDblClick: zTreeOnDblClick,
					onClick:function(event, treeId, treeNode)
					{  
						tool.onClick(event, treeId, treeNode);
					},
					beforeDragOpen:function (treeId, treeNode) {
						tool.onClick(null,null,treeNode);
						autoExpandNode = treeNode;
						return true;
					} 
					 
				} 
			};  
	    function zTreeOnDblClick(event, treeId, treeNode) {
	     var flag =$("#dialogName").val();
	     if(flag=="mainrole")
    		{
	    		parent.document.getElementById("mainRoleId").value=treeNode.rolenum;
		        parent.document.getElementById("mianRoleName").value=treeNode.name;
		        f_close(flag);
    		}else if(flag=="auxrole")
    		{
    			var selectedNode =parent.document.getElementById("auxRoleId").value;
    			if(nodeIsSelected(selectedNode,treeNode.rolenum)){
    				return;
    			}
	    		parent.document.getElementById("auxRoleId").value+=treeNode.rolenum+";";
		        parent.document.getElementById("auxRoleName").value+=treeNode.name+"  ";
		        var descContent =$("#desc").val();
		        descContent+=treeNode.name+" ";
		        $("#desc").val(descContent);
		        _selectRoleid+=treeNode.rolenum+";"; 
    		}else if(flag=="maindept"){
    			if(treeNode.sysid==null)
    				return;
    			if(treeNode.sysid==-1)
    				return;
    			parent.document.getElementById("mainDeptId").value=treeNode.sysid;
		        parent.document.getElementById("mainDeptName").value=treeNode.name;
		        f_close(flag);
    		}else if(flag=="auxdept"){
    			var selectedNode =parent.document.getElementById("auxDeptId").value;
    			if(nodeIsSelected(selectedNode,treeNode.rolenum)){
    				return;
    			}
    			parent.document.getElementById("auxDeptId").value+=treeNode.rolenum+";";
		        parent.document.getElementById("auxDeptName").value+=treeNode.name+"  ";
		        var descContent =$("#desc").val();
		        descContent+=treeNode.name+" ";
		        $("#desc").val(descContent);
		        _selectRoleid+=treeNode.rolenum+";";
    		}
	        
	    }
	    var tool={
				onClick:function(event, treeId, treeNode)
				{ 
					var tree = $.fn.zTree.getZTreeObj("tree"); 
						if(!treeNode.load)
						{  
							var dialogName=$("#dialogName").val();
							data = {'_treeId':treeNode.id,'_sysid':treeNode.sysid,'_dialogName':dialogName};
							var url = '${root}/permission/getTreeList.action';
							$.ajax({                 
				       	        type: "POST",                 
				       	        dataType: "json",  
				       	        data:data,
				       	        url: url,     
				       	        success: function(data) { 
				       	        	if( data==null|| data.length == 0) 
				       	        		return;
			       	        		for(var i = 0; i != data.length;++i)
			       	        		{ 
			       	        			data[i].open = false;
			       	        			data[i]['load'] = false;   
			       	        		}
			       	        		tree.addNodes(treeNode,data);
				       	        	treeNode.load = true;
				       	        	tree.updateNode(treeNode);
				       	        }   
				       	    });
						}  
				} 
			};

		//判断节点是否已经选中
	function nodeIsSelected(selectedNode,curNode){
	 var nodeArray =selectedNode.split(";");
	 for(var i=0;i<nodeArray.length;i++){
		 if(nodeArray[i]==curNode){
			 return true;
		 }
	 }
	 return false;
	}
    </script>
    <script type="text/javascript">
		var _zTree,_pNode,_selectRoleid="";
		$(document).ready(function(){
			var flag =$("#dialogName").val();
			var title="";//根节点名称
			var root = {'name':title,'id':-1,open:true,isParent:true};
			_zTree = $.fn.zTree.init($("#tree"), setting, root);
			var node = _zTree.getNodeByParam('id',-1,null);//获取根节点
			tool.onClick(null, null, node); 
			initDiv(flag);
		});
		function initDiv(flag){
			if(flag=="mainrole" || flag=="maindept"){
				document.getElementById("bottomDiv").style.display="none";
				document.getElementById("btn_div").style.display="none";
			}
		} 
		function sure(){
			var flag =$("#dialogName").val();
			if(flag=="auxrole"){
				parent.document.getElementById("auxRoleId").value=_selectRoleid;
		        parent.document.getElementById("auxRoleName").value=$("#desc").val();
		        f_close("auxrole");
			} 
			else if(flag=="auxdept") {
				parent.document.getElementById("auxDeptId").value=_selectRoleid;
		        parent.document.getElementById("auxDeptName").value=$("#desc").val(); 
				f_close("auxdept");
			}
			
		}
		function clear(){
			$("#desc").val("");
			var flag =$("#dialogName").val();
			if(flag=="auxrole"){
				parent.document.getElementById("auxRoleId").value="";
		        parent.document.getElementById("auxRoleName").value="";
			} 
			else if(flag=="auxdept"){
				parent.document.getElementById("auxDeptId").value="";
		        parent.document.getElementById("auxDeptName").value="";
			} 
		}
	</script>
</form>
<div id="bodyDiv"> 
	<div id="topDiv">
	<ul id="tree" class="ztree"></ul>
	</div> 
	<div id="bottomDiv">
		<textarea id="desc" name="desc" style="width:99%;height:94%;" readonly></textarea>
	</div> 
	<div class="main_btnarea" id="btn_div">
		<div class="btn_area_setc btn_area_bg">
		
			<a href="javascript:sure();" class="btn_01">确 定<b></b></a>
		 	<a href="javascript:clear();" class="btn_01">清空<b></b></a> 
		</div>
	</div>
</div>
</body>
</html>