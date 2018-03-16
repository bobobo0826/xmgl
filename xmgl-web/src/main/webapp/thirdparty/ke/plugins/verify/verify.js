/*******************************************************************************
* KindEditor - WYSIWYG HTML Editor for Internet
* Copyright (C) 2006-2011 kindsoft.net
*
* @author ykm <175223598@qq.com>
* @site http://www.kindsoft.net/
* @licence http://www.kindsoft.net/license.php
*******************************************************************************/

	KindEditor.plugin('verify', function(K) {
		var self = this, name = 'verify', lang = self.lang(name + '.');
		self.clickToolbar(name, function() {
			var knode = self.toolbar.get('verify').children();
			if(knode.hasClass('ke-icon-verify')) {
				knode.removeClass('ke-icon-verify');//去除？样式
				knode.addClass('ke-icon-verify1');//改为勾样式
				$("#"+self.kid+"_verify").val("1");//设置值为1
				self.toolbar.get('verify').attr('title', lang.ysh);//设置标题 已审核，不能修改
			    self.toolbar.disableAll(true, 'verify,verifyAdvice');//禁止所有的功能，除了审核意见
			    self.edit.doc.body.contentEditable = false;//禁止内容
			    self.edit.doc.body.style.background="#ebeae7";
			} else {
				knode.removeClass('ke-icon-verify1');//去除勾样式
				knode.addClass('ke-icon-verify');//改为？样式
				$("#"+self.kid+"_verify").val("0");//设置值为0
				self.edit.doc.body.style.background="#ffffff";
				if (roleId == "RP10") {
					//登记机构处理中，开放所有按钮
					 if ($("#cntStatusId").val() == "cnt07") {
					    self.toolbar.disableAll(false);
					    self.edit.doc.body.contentEditable = true;
					 }
				} else if (roleId == "TM10" || roleId == "TM20") {
					//市场处理中，开放所有按钮
					if ($("#cntStatusId").val()=="cnt12") {
						 self.toolbar.disableAll(false);
						self.edit.doc.body.contentEditable = true;
					}
				} else {
				}
				self.toolbar.get('verify').attr('title', lang.wsh);
			}
        });
	});


