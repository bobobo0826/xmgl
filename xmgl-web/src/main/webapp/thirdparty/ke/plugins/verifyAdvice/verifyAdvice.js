/*******************************************************************************
* KindEditor - WYSIWYG HTML Editor for Internet
* Copyright (C) 2006-2011 kindsoft.net
*
* @author ykm <175223598@qq.com>
* @site http://www.kindsoft.net/
* @licence http://www.kindsoft.net/license.php
*******************************************************************************/
 
	KindEditor.plugin('verifyAdvice', function(K) {
		var self  = this, name = 'verifyAdvice', lang = self.lang(name + '.');
		self.clickToolbar(name, function() {
			html = ['<div style="padding:10px 20px;">',
					'<textarea class="ke-textarea" style="width:408px;height:260px;" >'+$("#"+self.kid+"_remark").val()+'</textarea>',
					'</div>'].join(''),
					dialog = self.createDialog({
						name : name,
						width : 450,
						title : self.lang(name),
						body : html,
						yesBtn : {
							name : self.lang('yes'),
							click : function(e) {
								var text = textarea.val();
								$("#"+self.kid+"_remark").val(text);
								//本地化存储
								if(localStorage){
									setLocalStorage();
								}
								self.hideDialog();
							}
						}
					});
				textarea = K('textarea', dialog.div);
        });
	});	

