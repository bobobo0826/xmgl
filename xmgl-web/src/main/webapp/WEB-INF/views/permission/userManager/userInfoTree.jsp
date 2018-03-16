<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html >
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title></title>

<!--hplus-->
<%@ include file="/res/public/hplus.jsp"%>
<link rel="stylesheet" type="text/css" href="${root}/thirdparty/zTree_v3/css/zTreeStyle/zTreeStyle.css" />
<script type="text/javascript" src="${root}/thirdparty/zTree_v3/js/jquery-1.4.4.min.js"></script>
<script type="text/javascript" src="${root}/thirdparty/zTree_v3/js/jquery.ztree.all-3.5.min.js"></script>
<script type="text/javascript" src="${root}/res/public/js/easyui-1.3.2/jquery.easyui.min.js"  charset="UTF-8"></script>
<link rel="stylesheet" type="text/css" href="${root}/res/public/js/easyui-1.3.2/themes/default/easyui.css">
<link rel="stylesheet" type="text/css" href="${root}/res/public/js/easyui-1.3.2/themes/icon.css">
<script type="text/javascript" src="${root}/res/public/js/easyui-1.3.2/locale/easyui-lang-zh_CN.js" charset="UTF-8"></script>
<script type="text/javascript" src="${root}/res/public/js/common.js"  charset="UTF-8"></script>
<%@ include file="/res/public/msg.jsp"%>
</head>
<body  >
	<div class="row">
	<div class="col-sm-12">
					<div class="col-md-2">
					 	 <div class="ibox float-e-margins"> 
							<ul id="tree" class="ztree">
							</ul>
						</div>
					</div>
					<div class="col-md-10" >
						 <div class="ibox float-e-margins" > 
							<iframe id="userList" name="userList" frameborder=0  style='width:100%; height:450px; ' src=""></iframe>
						</div>
					</div>
		</div>
	</div>
	
	<script type="text/javascript"> 
		var className = "dark", curDragNodes, autoExpandNode;
	    var _FONT_GREEN = {'color':"#008000",'font-weight':'bold'};
	    var _FONT_DEF = {'color':"#000000",'font-weight':'normal'};
	    var setting = {
				view: {
					showIcon: true,
					showLine: true,
					fontCss:function(treeId, node) {
						var fontStyle = _FONT_DEF;
						return fontStyle;
					}
				},
				data: {
					keep: {
					}
				},
				callback:{
					onClick:function(event, treeId, treeNode)
					{ 
						tool.onClick(event, treeId, treeNode);
					},
					beforeDragOpen:function (treeId, treeNode) {
						tool.onClick(null,null,treeNode);
						autoExpandNode = treeNode;
						return true;
					},
					beforeDrag:function (treeId, treeNodes) {
						className = (className === "dark" ? "":"dark");
						for (var i=0,l=treeNodes.length; i<l; i++) {
							if (treeNodes[i].drag === false) {
								curDragNodes = null;
								return false;
							} else if (treeNodes[i].parentTId && treeNodes[i].getParentNode().childDrag === false) {
								curDragNodes = null;
								return false;
							}
						}
						curDragNodes = treeNodes;
						return true;
					},
					onDrag:function(event, treeId, treeNodes)
					{
						return true;
					} 
				},
				edit:{
					enable: true,
					showRemoveBtn:false,
					showRenameBtn:false,
					drag:{
						autoExpandTrigger: true,
						prev: true,
						inner: true,
						next:true
					}
				}
			};
	    var tool={
				onClick:function(event, treeId, treeNode)
				{ 
					var tree = $.fn.zTree.getZTreeObj("tree");
					var frame = document.getElementById('userList');
					if(!treeNode.load)
					{  
						data = {'_id':treeNode.id};
						//后加载部门
						var url = '${root}/manage/user/queryDeptListForTree';
						$.ajax({
			       	        type: "POST",                 
			       	        dataType: "json",  
			       	        data:data,
			       	        url: url,     
			       	        success: function(data) {
			       	        	if( data==null|| data.length == 0)
			       	        		return;
								var deptList=data.deptList;
			       	        	for(var i = 0; i != deptList.length;++i)
		       	        		{
									deptList[i].open = false;
									deptList[i]['load'] = false;
		       	        			var childCount=deptList[i]['child_count']  ;
		       	        			var dateType=deptList[i]['data_type'];
		       	        			if(dateType=="dept")
		       	        			{
		       	        				if(childCount>0)
		       	        				{
											deptList[i]['icon']='${root}/res/public/img/treeIcons/folder.png';
											deptList[i]['iconOpen']='${root}/res/public/img/treeIcons/folder-open.png';
											deptList[i]['iconClose']='${root}/res/public/img/treeIcons/folder.png';
		       	        				}
		       	        				else
											deptList[i]['icon']='${root}/res/public/img/treeIcons/blank.png';
		       	        					
		       	        			}
		       	        		}
		       	        		tree.addNodes(treeNode,deptList);
			       	        	treeNode.load = true;
			       	        	tree.updateNode(treeNode); 
			       	        }   
			       	    });
					}
					frame.src = "${root}/manage/user/indexUserInforList?_deptId=" + treeNode.id;
				},
				showRMenu:function(obj) {
					var y = obj.pos.y;
					var x = obj.pos.x;
					$('#m_add').hide();
					$('#m_del').hide();
					$('#m_refresh').hide();
					$('#rMenu ul').show();
					if(obj.show.length != 0)
					{
						for(var i = 0; i != obj.show.length;++i)
						{
							$(obj.show[i] + '').show();
						}
						_rMenu.css({"top":y+"px", "left":x+"px", "visibility":"visible"});
						$("body").bind("mousedown", tool.onBodyMouseDown);
					}
				},
				hideRMenu:function() {
					if (_rMenu) 
					{
						_rMenu.css({"visibility": "hidden"});
					}
					$("body").unbind("mousedown", tool.onBodyMouseDown);
				},
				onBodyMouseDown:function(event){
					if (!(event.target.id == "rMenu" || $(event.target).parents("#rMenu").length>0)) {
						_rMenu.css({"visibility" : "hidden"});
					}
				},
				delNode:function(){
					tool.hideRMenu();  
					if(_pNode.id ==-1) 
					{
						$.messager.alert("提示", "根节点不能删除！", "info");
						return;
					}
					$.messager.confirm('提示',"是否确定删除该部门？",function(f) {
						if (f) {
								data = {'_id':_pNode.id};
								var url = '${root}/manage/dept/delDeptInfo';
								$.ajax({                 
					       	        type: "POST",                 
					       	        dataType: "json",  
					       	        data:data,
					       	        url: url,     
					       	        success: function(data) { 
					       	        	_zTree.removeNode(_pNode);
					       	            reloadTreeNodeById(_pNode.pid);
					       	        }   
					       	    });	
			        		}
						});
				},
				refresh:function(){
					tool.hideRMenu();  
       	            reloadTreeNodeById(_pNode.id);
				}
			};

	    //根据节点id，加载节点下的子节点
	    function reloadTreeNodeById(id)
	    {
	    	var treeNode = _zTree.getNodeByParam("id", id, null);
	    	treeNode.load=false;
	    	_zTree.removeChildNodes(treeNode);
	    	tool.onClick(null, "tree", treeNode);
	    	_zTree.expandNode(treeNode, true, true, false );  
	    }
	    //编辑用户信息
	    function addUserInfo()
	    {
	    	url = "${root}/manage/user/initaddUserInfo";
	        width = "90%";
 	        height = "80%";
	    	f_open("editUserInfo", "用户信息编辑", width, height, url, true);
	    }
	    //编辑用户信息
	    function editUserInfo(id)
	    {
	    	url = "${root}/manage/user/initaddUserInfo?id="+id;
	        width = "90%";
 	        height = "80%";
	    	f_open("editUserInfo", "用户信息编辑", width, height, url, true);
	    }
	    function reloadUserList()
	    {
	    	  document.getElementById("userList").contentWindow.doQuery();	    	
	    }
    </script>
    <script type="text/javascript">
		var _zTree,_pNode;
		$(document).ready(function(){
			var root = {'name':'全部','id':-1,open:true,isParent:true};
			_zTree = $.fn.zTree.init($("#tree"), setting, root);
			var node = _zTree.getNodeByParam('id',-1,null);//获取根节点
			tool.onClick(null, null, node);
		});
	</script>
</body>
</html>