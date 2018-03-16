<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html >
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title> 角色管理</title>
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
		<li id="m_add" onclick="tool.addSubNode();">添加角色</li>
		<li id="m_del" onclick="tool.delNode();">删除角色</li>
		<li id="m_refresh" onclick="tool.refresh();">刷新</li>
	</ul>
</div>
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
			onClick:function(event, treeId, treeNode)
			{
				tool.onClick(event, treeId, treeNode);
			},
			onDbClick:function(event, treeId, treeNode)
			{

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
			if(!treeNode.load)
			{
				data = {'_id':treeNode.id};
				var url = '${root}/manage/permission/getRoleTreeList';
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
			if(treeNode.id != -1 )
				frame.src = "${root}/manage/permission/roleInfoIndex?_id=" + treeNode.id;
			else
				frame.src = '';
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
				layer.msg( "根节点不能删除！");
				return;
			}
			layer.confirm("是否确定删除该角色？" ,{
				btn: ['确定','取消'],
				//按钮
				shade: false //不显示遮罩
			}, function(index){
				data = {'_id':_pNode.id};
				var url = '${root}/manage/permission/delRoleInfo';
				$.ajax({
					type: "POST",
					dataType: "json",
					data:data,
					url: url,
					success: function(data) {
						//删除菜单及模块配置后，再将树上的选中节点删除
						_zTree.removeNode(_pNode);
						reloadTreeNodeById(_pNode.pid);
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
			frame.src = "${root}/manage/permission/roleInfoIndex?_parentId=" + _pNode.id;
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
        alert("sdd"+treeNode.load);
		_zTree.removeChildNodes(treeNode);
		tool.onClick(null, "tree", treeNode);
		_zTree.expandNode(treeNode, true, true, false );
	}
</script>
<script type="text/javascript">
	var _rMenu,_zTree,_pNode;
	$(document).ready(function(){
		var root = {'name':'角色配置','id':-1,open:true,isParent:true};
		_zTree = $.fn.zTree.init($("#tree"), setting, root);
		var node = _zTree.getNodeByParam('id',-1,null);//获取根节点
		tool.onClick(null, null, node);
		_rMenu = $("#rMenu");
	});
</script>
</body>
</html>