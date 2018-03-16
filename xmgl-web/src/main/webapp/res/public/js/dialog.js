
var dlg = {
	_default_options:{
		width:1024,
		height:530,
		'buttons':[
   		{
			iconCls:'icon-ok',
			text:'确定',
			handler:function() { 
				dlg.ok = true;
				dlg.close(); 
			}
		},
		{
			 iconCls:'icon-cancel',
			 text:'关闭',
			 handler:function() { dlg.close(); }
		}]
	},
	_default_toolbar:[
		{
			iconCls:'icon-ok',
			text:'确定',
			handler:function() { 
				dlg.ok = true;
				dlg.close(); 
			}
		},
		{
			 iconCls:'icon-cancel',
			 text:'关闭',
			 handler:function() { dlg.close(); }
		}],
	_fake_res_val:undefined,
	show:function(id,title,href,callback,option)
	{

		var _this = this;
		_this.ok = undefined;		
		_this.option = option;
		if(!_this.div)
		{
			_this.div = document.createElement("div");
			_this.div.id = id; 
			document.body.appendChild(_this.div);
			_this.id = _this.div.id;
		}
		$('#' + _this.id).dialog({
			title: title,
			width: option?(option.width || 400):400,
			height: option?(option.height || 400):400, 
			closed: false,
			cache: false,
			href: href,
			modal: true,
			toolbar:option?(option.toolbar || []):[],
			buttons:option?(option.buttons || []):[],
			onClose:function()
			{
				if(_this.ok)
					callback(_this._fake_res_val);

			}
		});	
	},
	showDeptDialog: function(width, height, href, callback) {
		var _this = this; 
		divName = "deptWindow";
		title = "选择部门";
		if ($('#' + divName).length <= 0) {
			var div = "<div id='" + divName + "' class='easyui-window' align='center' style='overflow:hidden;width: "
					+ width + "px; height: " + height + "px;'>" + "<iframe id='" + divName 
					+ "_frm' scrolling='yes' frameborder='0' style='width:100%; height:100%;'></iframe>" + "</div>";
			$(document.body).append(div);
		}
		$('#' + divName).window({
			title : title,
			shadow: false,
			left:(getPageSize()[2] - width)/2,
			top:30 + $(document).scrollTop(), 
			width : width,
			height : height,
			modal: true,
			onBeforeClose:function(){
				$('#' + divName).remove();
				if(_this.ok) {
					var names = '';
					var ids = '';
					var obj = [];
					if(_this._fake_res_val && _this._fake_res_val.length) {
						for(var i = 0; i != _this._fake_res_val.length; ++i) {
							var item = _this._fake_res_val[i];
							
							names += item.name;
							ids += item.id;
							var it = {};
							it['id'] = item.id;
							obj[obj.length] = it;
							if(i != _this._fake_res_val.length - 1) {
								names += ' ';
								ids += ',';
							}
						} 
					}
					callback(ids,names,JSON.stringify(obj));
				}
			}
		});
		$("#" + divName + "_frm").attr("src", href);
	},
	showRoleDialog:function(width,height,href,callback)
	{
		var _this = this; 
		divName = "deptWindow";
		title = "选择角色";
		if ($('#' + divName).length <= 0) {
			var div = "<div id='" + divName
					+ "' class='easyui-window' align='center' style='overflow:hidden;width: "
					+ width + "px; height: " + height + "px;'>" + "<iframe id='"
					+ divName 
					+ "_frm' scrolling='yes' frameborder='0' style='width:100%; height:100%;'></iframe>" + "</div>";
			$(document.body).append(div);
		}
		$('#' + divName).window( {
			title : title,
			shadow: false,
			left:(getPageSize()[2] - width)/2,
			top:30 + $(document).scrollTop(), 
			width : width,
			height : height,
			modal: true,
			onBeforeClose:function(){
				$('#' + divName).remove();
				if(_this.ok)
				{
					var names = '';
					var ids = '';
					var obj = [];
					if(_this._fake_res_val && _this._fake_res_val.length)
					{
						for(var i = 0; i != _this._fake_res_val.length; ++i)
						{
							var item = _this._fake_res_val[i];
							names += item.deptName;
							ids += item.deptCode;
							var it = {};
							it['dept_id'] = item.id;
							obj[obj.length] = it;
							if(i != _this._fake_res_val.length - 1)
							{
								names += ' ';
								ids += ',';
							}
						} 
					}
					callback(ids,names,JSON.stringify(obj));
				}
			}
		});
		$("#" + divName + "_frm").attr("src", href);
	},
	//潜在客户分配部门时候的特殊处理，因为要带一个参数
	_ptlc_select_type:undefined,
	showDeptDialogForPtlc:function(width,height,href,callback)
	{
		var _this = this; 
		divName = "deptWindow";
		title = "选择部门";
		if ($('#' + divName).length <= 0) {
			var div = "<div id='" + divName
					+ "' class='easyui-window' align='center' style='overflow:hidden;width: "
					+ width + "px; height: " + height + "px;'>" + "<iframe id='"
					+ divName 
					+ "_frm' scrolling='yes' frameborder='0' style='width:100%; height:100%;'></iframe>" + "</div>";
			$(document.body).append(div);
		}
		$('#' + divName).window( {
			title : title,
			shadow: false,
			left:(getPageSize()[2] - width)/2,
			top:30 + $(document).scrollTop(), 
			width : width,
			height : height,
			modal: true,
			onBeforeClose:function(){
				$('#' + divName).remove();
				if(_this.ok)
				{
					var names = '';
					var ids = '';
					var obj = [];
					if(_this._fake_res_val && _this._fake_res_val.length)
					{
						for(var i = 0; i != _this._fake_res_val.length; ++i)
						{
							var item = _this._fake_res_val[i];
							names += item.deptName;
							ids += item.id;
							var it = {};
							it['dept_id'] = item.id;
							obj[obj.length] = it;
							if(i != _this._fake_res_val.length - 1)
							{
								names += ' ';
								ids += ',';
							}
						} 
					}
					callback(ids,names,_this._ptlc_select_type,JSON.stringify(obj));
				}
			}
		});
		$("#" + divName + "_frm").attr("src", href);
	},
	closeDeptDialog:function()
	{ 
		divName = "deptWindow";
		this.ok = true;
		$('#' + divName).window('close');
	},
	close:function(idd)
	{
		var closeId = undefined;
		if(idd) closeId = idd;
		else if(this.id) closeId = this.id;
		if(closeId) $('#' + closeId).dialog('close');
	},
	setDeptByArg:function(url,deptCodes,callback)
	{
		//url = '<%=request.getContextPath()%>/dept/queryDeptMap.action'
		var _this = this;
		if(!_this.fake_depts)
		{
			$.ajax({ 
				url	: url,
				type : 'post',
				cache : false,
				async:false,
				success:function(result)
				{ 
					_this.fake_depts = result;
				}
			 });
		}
		var deptArr = deptCodes;
		if(!(deptArr instanceof Array))
			deptArr = JSON.parse(deptCodes);
		var deptNames = '';
		for(var i = 0; i != deptArr.length; ++i)
		{
			if(_this.fake_depts[deptArr[i]['dept_id']])
				deptNames += _this.fake_depts[deptArr[i]['dept_id']];
			if(i < deptArr.length - 1)
				deptNames += ' ';
		}
		callback(deptNames);
	},
	setGoodsCategoryByArg:function(url,categoryCode,callback)
	{
		var _this = this;
		if(!_this.fake_categorys)
		{
			$.ajax({ 
				url: url,
				type : 'post',
				cache : false,
				async:false,
				success:function(result)
				{ 
					_this.fake_categorys = result;
				}
			 });
		}
		callback(_this.fake_categorys[categoryCode],_this.fake_categorys['d' + categoryCode]);
	},
	addTabWithCallback:function(title,url,callback)
	{
		var tab = parent.$('#mainTabs').tabs('getSelected');
		var index = parent.$('#mainTabs').tabs('getTabIndex',tab);
		if(!parent._$_)
			parent._$_ = {};
		parent._$_.tabIndex = index;
		parent._$_.callback = callback;
		if(parent.$('#mainTabs').tabs('exists',title))
			parent.$('#mainTabs').tabs('close',title);
		parent.$('#mainTabs').tabs('add',{
			title: title,
			content: '<iframe src="'+url+'" allowTransparency="true" id="'+title+'_frm" style="border: 0; width: 100%; height: 100%; overflow:hidden;" frameBorder="0"></iframe>',
			closable: true,
			tabPosition:'right'
		}); 
	},
	closeTab:function(ok,getResCallback)
	{
		var op = parent.$('#mainTabs').tabs('options');
		op.onSelect = function(title,index)
		{
			if(ok)
				parent._$_.callback(getResCallback());
			var options = parent.$('#mainTabs').tabs('options');
			delete op.onSelect;
		};
		var tab = parent.$('#mainTabs').tabs('getSelected');
		var index = parent.$('#mainTabs').tabs('getTabIndex',tab);
		parent.$('#mainTabs').tabs('select',parent._$_.tabIndex);
		parent.$('#mainTabs').tabs('close',index);
	}
};