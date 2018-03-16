<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<html>
	<head>
		<%@ include file="/res/public/hplus.jsp"%>
		<%@ include file="/res/public/easyui_lib.jsp"%>
		<%@ include file="/res/public/common.jsp"%>
		<%@ include file="/res/public/angularjs.jsp"%>
		<%@ include file="/res/public/msg.jsp"%>
		<link rel="stylesheet" type="text/css" href="${root}/thirdparty/zTree_v3/css/zTreeStyle/zTreeStyle.css" />
		<script type="text/javascript" src="${root}/thirdparty/zTree_v3/js/jquery.ztree.all-3.5.min.js"></script>
		<script src="${root}/thirdparty/jqueryalerts/jquery.alerts.js"></script>
		<title>选择角色</title>
		<style type="text/css">
			.chose_style{
				list-style-type:none;
				margin:20px;
				float:left;
			}
		</style>
	</head>
	<body>
	<input  type="hidden" id="_chkStyle"   value="${_chkStyle}"/>
	<input type="hidden" id="roleListStr"  value="${roleListStr}" />
	<%--<input type="hidden" id="roleListStr"  value="<c:out value='${roleListStr}'/>" />--%>
	<div>
		<ul id="tree" class="ztree"> </ul>
		<ul id="chose"></ul>
				
	</div>
	<div style="height:50px"></div>
	<div class="main_btnarea" id="btn_div">
		<div class="btn_area_setc btn_area_bg">
			<a class="btn btn-danger btn-sm" href="###" onClick="openTree();" id="openTree"><i class='fa fa-arrow-up'></i>&nbsp;&nbsp;展 开<b></b></a>
			<a class="btn btn-danger btn-sm" href="###" onClick="closeTree();" id="closeTree"><i class='fa fa-arrow-up'></i>&nbsp;&nbsp;收 缩<b></b></a>
			<a class="btn btn-primary btn-sm" href="###" onClick="javascript:closeDialog();"><i	class='fa fa-check'></i>&nbsp;&nbsp;确 定<b></b></a>
		</div>
	</div>
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
				multi:true,
				triggerNodeClick:function (treeId, node) {
		      		$('body').trigger('treeNodeClick', [treeId, node]);
		      	},
				init:function(id,option)
				{
					this.needModel = option.needModel || true;
					this.option = option;
					var _this = this;
					//设置data
					var roleListStr=$("#roleListStr").val();
					this.data = JSON.parse(roleListStr.replace(/'/g, '"'));
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
									ischeck=+item.checked;
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
						res.roleCode = node.id;
						res.roleName = node.name;
						if(node.getParentNode())
							res.parentId = node.getParentNode().mid;
					}
					else
					{
						res.id = node.mid;
						res.roleCode = node.id;
						res.roleName = node.name;
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
					//parent.dlg._fake_res_val = this.resVal;
				}
			};
			function closeDialog()
			{
				parent.setRole(dTree.resVal);
				f_close("roleWindow");
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
				var chkStyle = $("#_chkStyle").val() || 'checkbox';
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