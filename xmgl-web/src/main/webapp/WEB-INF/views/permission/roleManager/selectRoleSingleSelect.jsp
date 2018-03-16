<!-- add by cuiwei 2015-03-03 -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<html>
	<head>
		<%@include file="/res/public/easyui_lib.jsp" %>
		<link rel="stylesheet" type="text/css" href="${root}/res/ui/css/style.css" />
		<link rel="stylesheet" type="text/css" href="${root}/thirdparty/zTree_v3/css/zTreeStyle/zTreeStyle.css" />
		<script type="text/javascript" src="${root}/thirdparty/zTree_v3/js/jquery.ztree.all-3.5.min.js"></script>
		<script type="text/javascript" src="${root}/thirdparty/zTree_v3/js/jquery.ztree.exhide-3.5.js"></script>
		<script src="${root}/thirdparty/jqueryalerts/jquery.alerts.js"></script>
		<script type="text/javascript" src="${root}/res/public/js/common.js"  charset="UTF-8"></script>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title>选择机构</title>
		<style type="text/css">
			.chose_style{
				list-style-type:none;
				margin:20px;
				float:left;
			}
		</style>
	</head>
	<body>
	<div>
		<ul id="tree" class="ztree"> </ul>
		<ul id="chose"></ul>
				
	</div>
	<div style="margin-bottom:40px;"></div>
	<div class="main_btnarea" id="btn_div">

		<div class="btn_area_setc btn_area_bg">
		<a class="btn_01" href="###" onClick="openTree();" id="openTree">展 开<b></b></a>
			<a class="btn_01" href="###" onClick="closeTree();" id="closeTree">收 缩<b></b></a>
			<a class="btn_01" href="###" onClick="javascript:closeDialog();">确 定<b></b></a>
		</div>
	</div>
		<input type="hidden"/>

		<script type="text/javascript">
			var treeObj="";
			var ischeck="";
			var dTree = {
				data:null,
				setting:null,
				tree:null,
				resVal:null,
				needModel:null,//返回值是否以机构Model形式组织
				option:null,
				triggerNodeClick:function (treeId, node) {
		      		$('body').trigger('treeNodeClick', [treeId, node]);
		      	},
				init:function(id,option)
				{
					this.needModel = option.needModel || true;
					this.option = option;
					var _this = this;
					//设置data
					this.data = JSON.parse('<s:property value="_roleList"/>'.replace(/&quot;/g, '\"'));
					this.setting = {
							view: {
								showIcon: false,
								showLine: true,
								dblClickExpand:option.chkStyle == 'checkbox'
							},
							check:option.check || {
									enable:true,
									autoCheckTrigger:true,
									chkStyle:option.chkStyle || undefined,
									chkboxType:option.chkboxType || { "Y": "", "N": "" },
									radioType:option.radioType || 'all'
							},
							callback: {
								onClick:function(event, treeId, treeNode)
								{
									  // 用于解决双击时候会调用两次单击事件的问题
								    if (treeNode.clickTimeout) {
								        clearTimeout(treeNode.clickTimeout);
								        treeNode.clickTimeout = null;
								    } else {
								    	treeNode.clickTimeout = setTimeout(function() {
								            _this.triggerNodeClick(treeId, treeNode);
								            treeNode.clickTimeout = null;
								            if(_this.setting.check.chkStyle == 'radio')
											{
												_this.tree.checkAllNodes(false);
												_this.tree.checkNode(treeNode,true,false,false);
												_this.tree.expandNode(treeNode,true,false,false,false);
												_this.resVal = [];
												_this.checkNode(treeNode, true);
												
											}
											else if(_this.setting.check.chkStyle == 'checkbox')
											{
												_this.tree.checkNode(treeNode,!treeNode.checked,false,false);
												_this.checkNode(treeNode, treeNode.checked);
											}
								        }, 250);
								    }
								},
								onCheck:function(event, treeId, treeNode)
								{
									if(_this.setting.check.chkStyle == 'radio')
									{
										_this.tree.expandNode(treeNode,true,false,false,false);
										_this.resVal = [];
										_this.checkNode(treeNode, true);
									}
									else if(_this.setting.check.chkStyle == 'checkbox')
									{
										_this.checkNode(treeNode, treeNode.checked);
									}
								},
								onDblClick:function(event, treeId, treeNode)
								{
									if(_this.setting.check.chkStyle == 'radio')
									{
										_this.tree.checkAllNodes(false);
										_this.tree.checkNode(treeNode,true,false,false);
										_this.tree.expandNode(treeNode,true,false,false,false);
										_this.resVal = [];
										_this.checkNode(treeNode, true);
										closeDialog();
										return
									}
									else if(_this.setting.check.chkStyle == 'checkbox')
									{
										return;
									}
									
								}
							}
						};
					this.tree = $.fn.zTree.init($('#' + id), this.setting, this.data);
					(function(list){
						treeObj = $.fn.zTree.getZTreeObj(id);
						if(list && list.length > 0)
						{
							for(var i=0; i != list.length; ++i){
								var item = list[i];
								if(item.isHidden)
									treeObj.hideNode(item);
								if(item.checked)
								{
									if(item.name!="总经理"){
										ischeck=+item.checked;
									}
									var tmp = item;
									while(tmp.getParentNode())
									{
										treeObj.expandNode(tmp.getParentNode(),true,false,false,false);
										tmp = tmp.getParentNode();
									}
									_this.checkNode(item, item.checked);
									
								}
								if(item.children)
								{
									arguments.callee(item.children);
								}
							}
						}
					})(this.tree.getNodes());
				},
				need:function(node)
				{
					var res = {};
					if(this.needModel)
					{
						res.id = node.mid;
						res.deptCode = node.id;
						res.deptName = node.name;
						if(node.getParentNode())
							res.parentId = node.getParentNode().mid;
					}
					else
					{
						res.id = node.mid;
						res.dept_code = node.id;
						res.dept_name = node.name;
						if(node.getParentNode())
							res.parent_id = node.getParentNode().mid;
					}
					return res;
				},
				checkNode:function(node,checked)
				{
					var _this = this;
					if(!this.resVal) this.resVal = [];
					var chose = document.getElementById('chose');
					var remove = function()
					{
						for(var i = 0; i != _this.resVal.length;++i)
						{
							if(node.mid == _this.resVal[i].id)
							{
								_this.resVal.splice(i,1);
								if(_this.setting.check.chkStyle == 'checkbox' && false)
								{
									var tmpLi = document.getElementById('li_' + node.id);
									if(tmpLi)
										chose.removeChild(tmpLi);
								}
								break;
							}
						}
					};
					if(checked)
					{
						this.resVal[this.resVal.length] =  this.need(node);
						if(_this.setting.check.chkStyle == 'checkbox' && false)
						{
							var li = document.createElement('li');
							li.id = 'li_' + node.id; 
							li.className = 'chose_style';
							var btn = document.createElement('buton');
							btn.innerHTML = node.name;
							btn.id = 'btn_' + node.id;
							btn.className='btn_01';
							btn.onclick = function()
							{
								remove();
								_this.tree.checkNode(node,false,false,false);
							};
							li.appendChild(btn);
							chose.appendChild(li);
						}
					}
					else
					{
						remove();
					}
					parent.dlg._fake_res_val = this.resVal;
				}
			};
			function closeDialog()
			{
				parent.dlg.closeDeptDialog();
			}
			function openTree()
			{
				treeObj.expandAll(true);
				document.getElementById("openTree").style.display="none";
				document.getElementById("closeTree").style.display="";
			}
			function closeTree()
			{
				treeObj.expandAll(false);
				document.getElementById("closeTree").style.display="none";
				document.getElementById("openTree").style.display="";
			}
		</script>
		<script type="text/javascript">
			$(document).ready(function(){
				var chkStyle = '<s:property value="_chkStyle"/>' || 'checkbox';
				dTree.init('tree',{"chkStyle":chkStyle});
				if(ischeck>=1){
					document.getElementById("closeTree").style.display="";
					document.getElementById("openTree").style.display="none";
				}
				if(ischeck<1){
					document.getElementById("closeTree").style.display="none";
					document.getElementById("openTree").style.display="";
				}
			});
			
		</script>
	</body>
</html>