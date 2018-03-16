/*******************************************************************************
* KindEditor - WYSIWYG HTML Editor for Internet
* Copyright (C) 2006-2011 kindsoft.net
*
* @author ykm <175223598@qq.com>
* @site http://www.kindsoft.net/
* @licence http://www.kindsoft.net/license.php
*******************************************************************************/

	KindEditor.plugin('clearcontent', function(K) {
		var self = this, name = 'clearcontent', lang = self.lang(name + '.');
		self.clickToolbar(name, function() {
		self.text('');	
        });
	});	


