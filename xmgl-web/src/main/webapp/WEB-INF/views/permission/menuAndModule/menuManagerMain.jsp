<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html >
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>菜单模块管理</title>
<%@ include file="/res/public/msg.jsp"%>
	<%@ include file="/res/public/hplus.jsp"%>
<link rel="stylesheet" type="text/css" href="${root}/res/ui/css/style.css" />
<link rel="stylesheet" type="text/css" href="${root}/thirdparty/zTree_v3/css/zTreeStyle/zTreeStyle.css" />
<script type="text/javascript" src="${root}/thirdparty/zTree_v3/js/jquery-1.4.4.min.js"></script>
<script type="text/javascript" src="${root}/thirdparty/zTree_v3/js/jquery.ztree.all-3.5.min.js"></script>
<script type="text/javascript" src="${root}/res/public/js/easyui-1.3.2/jquery.easyui.min.js"  charset="UTF-8"></script>
<link rel="stylesheet" type="text/css" href="${root}/res/public/js/easyui-1.3.2/themes/default/easyui.css"> 
<link rel="stylesheet" type="text/css" href="${root}/res/public/js/easyui-1.3.2/themes/icon.css">
<script type="text/javascript" src="${root}/res/public/js/easyui-1.3.2/locale/easyui-lang-zh_CN.js" charset="UTF-8"></script>
<style type="text/css">
	div#rMenu {position:absolute; visibility:hidden; top:0; background-color: #555;text-align: left;padding: 2px;}
	div#rMenu ul li{
		margin: 1px 0;
		padding: 0 5px;
		cursor: pointer;
		list-style: none outside none;
		background-color: #DFDFDF;
	}
	.dark {
		background-color: #E3E3E3;
	}
</style>
</head>
<body>
	<div class="inner6px" >
		<table  border=0 height=600px align=left>
			<!-- <tr>
				<td>
					查询：
					<input class="form_text"  type="text" name="division_name" id="division_name" onkeyup="queryTool.query(this.value)"/>
				</td>
			</tr> -->
			<tr>
				<td width=260px align=left valign=top style="BORDER-RIGHT: #999999 1px dashed">
					<div>
						<ul id="tree" class="ztree">
						</ul>
					</div>
				</td>
				<td width=770px align=left valign=top>
					<IFRAME ID="menuItemIndex" Name="menuItemIndex" FRAMEBORDER=0 SCROLLING=AUTO width=100%  height=600px SRC=""></IFRAME>
				</td>
			</tr>
		</table>
	</div>
	<div id="rMenu">
		<ul>
			<li id="m_createTree" onclick="tool.createMenuTree();">生成角色子系统菜单树</li>
			<li id="m_rename" onclick="tool.renameNode();">重命名</li>
			<li id="m_add" onclick="tool.addSubNode();">添加子节点</li>
			<li id="m_del" onclick="tool.delNode();">删除节点</li>
			<li id="m_refresh" onclick="tool.refresh();">刷新</li>
		</ul>
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
					//parent: true
				}
			},
			callback:{
				onClick:function(event, treeId, treeNode)
				{ 
					tool.onClick(event, treeId, treeNode);
				},
				onDbClick:function(event, treeId, treeNode)
				{
					if(treeNode.isleaf != 1)
					{
						tree.expandNode(treeNode,!treeNode.open,false,true,false);
					}
				},
				onRightClick:function(event, treeId, treeNode)
				{
					if (!treeNode && event.target.tagName.toLowerCase() != "button" && $(event.target).parents("a").length == 0) 
					{
						_zTree.cancelSelectedNode();
						tool.showRMenu({'pos':{'x':event.clientX,'y':event.clientY},
							   'show':[]
							});
						$("body").unbind("mousedown", tool.onBodyMouseDown);
					}
					else if(treeNode)
					{
						_pNode = treeNode;
						_zTree.selectNode(treeNode);
						tool.showRMenu({'pos':{'x':event.clientX,'y':event.clientY},
									   'show':['#m_add','#m_del','#m_refresh']
									});
					}
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
				},
				onRename:function(event, treeId, treeNode, isCancel)
				{
					if(isCancel) return;
					if(treeNode.id == 0) 
					{
						jAlert("根节点不允许重命名！");
					}
					var data={'_id':treeNode.id,'_param':treeNode.name,'_sysId':treeNode.sysid};
					var url = '${root}/manage/menuModule/renameMenu';
					$.ajax({                 
		       	        type: "POST",                 
		       	        data:data,
		       	        url: url,     
		       	        success: function(data) {  
		       	        	if(data.success)
		       	        	{
		       	        		//to do 修改成功
		       	        	}
		       	        }     
		       	    });
					
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
				var frame = document.getElementById('menuItemIndex');
				if(treeNode.isleaf == 0)
				{
					//frame.src = "";
					if(!treeNode.load)
					{
						data = {'_sysId':treeNode.sysid,'_id':treeNode.id};
						var url = '${root}/manage/menuModule/menuTreeList';
						$.ajax({                 
			       	        type: "POST",                 
			       	        dataType: "json",  
			       	        data:data,
			       	        url: url,     
			       	        success: function(data) {  
			       	        	if(data && data.length != 0)
			       	        	{ 
			       	        		if(treeNode.id == -1)
			       	        		{
			       	        			for(var i = 0; i != data.length; ++i)
			       	        			{
			       	        				data[i]['id'] = 0;
			       	        				data[i]['load'] = false;
			       	        				data[i]['isleaf'] = 0;
			       	        			}
			       	        		}
			       	        		else
			       	        		{
				       	        		for(var i = 0; i != data.length;++i)
				       	        		{ 
				       	        			data[i].open = false;
				       	        			data[i]['load'] = false;
				       	        			data[i]['sysid'] = treeNode.sysid;
				       	        			data[i]['sysName'] = treeNode.name;
				       	        			if(treeNode.id == 0)
				       	        			{
				       	        				
				       	        			}
				       	        		}
			       	        		}
			       	        		tree.addNodes(treeNode,data);
				       	        	treeNode.load = true;
				       	        	tree.updateNode(treeNode);
			       	        	}
			       	        }   
			       	    });
					}
				}
				if(treeNode.id != -1 && treeNode.id != 0) frame.src = "${root}/manage/menuModule/menuItemIndex?_id=" + treeNode.mmid;
				else frame.src = '';
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
				if(_pNode.id == 0) 
				{
					layer.msg("根节点不允许删除!");
					return;
				}
				layer.confirm('确定删除菜单项'+ _pNode.name + ".", {
					btn: ['确定','取消'], //按钮
					shade: false //不显示遮罩
				}, function(index){
					data = {'_sysId':_pNode.sysid,'_id':_pNode.id,'_param':_pNode.isleaf };
					var url = '${root}/manage/menuModule/delMenuItem.action';
					$.ajax({
						type: "POST",
						dataType: "json",
						data:data,
						url: url,
						success: function(data) {
							//删除菜单及模块配置后，再将树上的选中节点删除
							_zTree.removeNode(_pNode);
							layer.close(index);
						}
					});
				}, function(index){
					layer.close(index);
				});
			},
			addSubNode:function(){
				tool.hideRMenu();
				var frame = document.getElementById('menuItemIndex');
				frame.src = "${root}/manage/menuModule/menuItemAddIndex?parentItemId=" + _pNode.id+"&subSysId="+_pNode.sysid+"&pid="+ _pNode.pid;

			},
			renameNode:function()
			{
				tool.hideRMenu();
				var tree = $.fn.zTree.getZTreeObj("tree");
				tree.editName(_pNode);
			},
			createMenuTree:function()
			{
				tool.hideRMenu(); 
				layer.confirm('确定重新生成子系统角色菜单树？', {
					btn: ['确定','取消'], //按钮
					shade: false //不显示遮罩
				}, function(index){
					data = {'_sysId':_pNode.sysid };
					var url = '${root}/manage/menuModule/createSysRoleMenuTree';
					$.ajax({
						type: "POST",
						dataType: "json",
						data:data,
						url: url,
						success: function(data) {
							layer.msg(data.msg);
						}
					});
				}, function(index){
					layer.close(index);
				});
			},
			
			refresh:function(){
				window.location.reload();
			}
		};


	</script>
	<script type="text/javascript">
		
		var queryTool = {
			queryRes:[],
			query:function(val)
			{
				var p = document.getElementById('division_name').value;
				if(p == undefined || p.trim().length < 1)
				{
					return;
				}
				var data={'_param':p};
				var url = '${root}/manage/menuModule/queryDivisions';
				$.ajax({                 
	       	        type: "POST",                 
	       	        data:data,
	       	        url: url,     
	       	        success: function(data) {  
	       	        	if(data == undefined || data.length == 0)
	       	        	{
	       	        		return;
	       	        	}
	       	        	queryTool.queryRes = data;
	       	        	var tree = $.fn.zTree.getZTreeObj("tree");
	       	        	var node = tree.getNodeByParam('id',data[0] + '',null);//获取根节点
	       				tool.onClick(null, null, node);//加载第一级行政区划（省）
	       	        	//tree.addNodes(treeNode,data);
	       	        }     
	       	    });
				
			}
		};
		
	</script>
	
	
	
	<script type="text/javascript">
		var _rMenu,_zTree,_pNode;
		$(document).ready(function(){
			var root = {'name':'菜单模块配置','id':-1,'isleaf':0,open:true,isParent:true};
			_zTree = $.fn.zTree.init($("#tree"), setting, root);
			var node = _zTree.getNodeByParam('id',-1,null);//获取根节点
			tool.onClick(null, null, node);
			_rMenu = $("#rMenu");
		});
	</script>
	
</body>
</html>