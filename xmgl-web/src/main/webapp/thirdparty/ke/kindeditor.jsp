<script charset="utf-8" src="${pageContext.request.contextPath}/thirdparty/ke/kindeditor-all-min.js"></script>
<script charset="utf-8" src="${pageContext.request.contextPath}/thirdparty/ke/lang/zh_CN.js"></script>
<script type="text/javascript" charset="utf-8">
var createEditor;
function createK( id ) {
	var flag = false;
	var itemsContent=['fullscreen','wordpaste','|','fontsize','fontname','forecolor','|', 
			   			'bold','italic', 'underline', 'strikethrough','removeformat','|',
			   			'justifyleft', 'justifycenter', 'justifyright','insertorderedlist','insertunorderedlist','|',
			   			'undo', 'redo','|',
			   			'cut', 'copy', 'paste','plainpaste','image','|',
			   			'table','clearcontent','verify','verifyAdvice' ];
	editor = KindEditor.create('textarea[id="'+id+'"]',{
		width : '100%',
		height : '200px',
		resizeType : 1,
		kid : id,
		cssPath : '${pageContext.request.contextPath}/thirdparty/ke/themes/default/default.css',
		uploadJson : '${pageContext.request.contextPath}/thirdparty/ke/jsp/upload_json.jsp',
		fileManagerJson : '${pageContext.request.contextPath}/thirdparty/ke/jsp/file_manager_json.jsp',
		allowFileManager : true,
		afterChange : function() {
		 	$(this.edit.doc).keyup(function () {
			 	if(localStorage) {
					if (flag&&!isEmpty($('#'+id).val())) {
						setLocalStorage();
					}
					flag= true;
				 }
             });
			var autoheight = this.IE ? this.edit.doc.body.scrollHeight : this.edit.doc.body.offsetHeight; 
		    if(autoheight < 150) {
			   autoheight = 150;
			}
			this.edit.setHeight(autoheight);
			this.sync(id);
		},
		afterCreate : function() {
			var cntStatus = $("#cntStatusId").val();
			var textStatus = $("#textStatusId").val();
			if (typeof textStatus != "undefined" && textStatus != null && textStatus != "")  {
				if (roleId == "QY10" || roleId == "QY20") {
					if (cntStatus == "cnt02" && textStatus == "cntTxt02") {
						this.edit.doc.body.contentEditable = true;
						this.toolbar.disableAll(true,'fullscreen,fontsize,fontname,forecolor,bold,italic,underline,strikethrough,removeformat,justifyleft,justifycenter,justifyright,insertorderedlist,insertunorderedlist,undo,redo,cut,copy,paste,plainpaste,wordpaste,image,table,clearcontent,verifyAdvice');
					} else {
						this.edit.doc.body.contentEditable = false;
						this.edit.doc.body.style.background="#ebeae7";
						this.toolbar.disableAll(true);
					}
				} else if (roleId == "RP10") {
					if (cntStatus == "cnt07" && (textStatus != "cntTxt17")) {
						this.edit.doc.body.contentEditable = true;
					} else {
						this.edit.doc.body.contentEditable = false;
						this.edit.doc.body.style.background="#ebeae7";
						this.toolbar.disableAll(true,'verify,verifyAdvice');
					}
				} else if (roleId == "TM10" || roleId == "TM20") {
					if (cntStatus == "cnt12" && (textStatus != "cntTxt27")) {
						this.edit.doc.body.contentEditable = true;
					} else {
						this.edit.doc.body.contentEditable = false;	
						this.edit.doc.body.style.background="#ebeae7";
						this.toolbar.disableAll(true,'verify,verifyAdvice');
					}
				} else {

				}
				var val = $("#"+id+"_verify").val();
				if (val=="1") {
					this.edit.doc.body.contentEditable = false;	
					this.toolbar.disableAll(true,'verify,verifyAdvice');
					this.edit.doc.body.style.background="#ebeae7";
					
					var verify = this.lang('verify.');
					this.toolbar.get('verify').attr('title', verify.ysh);
					this.toolbar.get('verify').children().removeClass('ke-icon-verify');
					this.toolbar.get('verify').children().addClass('ke-icon-verify1');
				}
			}
			if(roleId=="ADMIN") {
				this.toolbar.disableAll(true,'source,fullscreen,fontsize,fontname,forecolor,bold,italic,underline,strikethrough,removeformat,justifyleft,justifycenter,justifyright,insertorderedlist,insertunorderedlist,undo,redo');
			}
			if($("#_curModuleId").val()=='CNTCX')
			{
				this.readonly(true);
			}
		},
		afterBlur : function() {
			$("#targetPoint").val(id);
		},
		items : itemsContent
	});
}

function createK_WH(id) {
	var itemsContent=['fullscreen','|','fontsize','fontname','forecolor','|', 
			   			'bold','italic', 'underline', 'strikethrough','removeformat','|',
			   			'justifyleft', 'justifycenter', 'justifyright','insertorderedlist','insertunorderedlist','|',
			   			'undo', 'redo','|',
			   			'cut', 'copy', 'paste','plainpaste', 'wordpaste','image','|',
			   			'table','clearcontent','verify','verifyAdvice' ];
	var editor;
	editor = KindEditor.create('textarea[id="'+id+'"]',{
		width : '100%',
		height : '200px',
		resizeType : 1,
		kid : id,
		cssPath : '${pageContext.request.contextPath}/thirdparty/ke/themes/default/default.css',
		uploadJson : '${pageContext.request.contextPath}/thirdparty/ke/jsp/upload_json.jsp',
		fileManagerJson : '${pageContext.request.contextPath}/thirdparty/ke/jsp/file_manager_json.jsp',
		allowFileManager : true,
		afterChange : function() {
			var autoheight = this.IE ? this.edit.doc.body.scrollHeight : this.edit.doc.body.offsetHeight; 
		    if(autoheight < 150) {
			   autoheight = 150;
			}
			this.edit.setHeight(autoheight);
			this.sync(id);
		},
		items : itemsContent
	}); 
}

// new kindediter NoticeKindEditer
function createN(id)
{  
		var itemsContent=['fullscreen','|','fontsize','fontname','forecolor','|', 
		   			'bold','italic', 'underline', 'strikethrough','removeformat','|',
		   			'justifyleft', 'justifycenter', 'justifyright','insertorderedlist','insertunorderedlist','|',
		   			'undo', 'redo','image'];
		createEditor = KindEditor.create('textarea[id="'+id+'"]',{
			width : '100%',
			height : '200px',
			resizeType : 1,
			kid : id,
			cssPath : '${pageContext.request.contextPath}/thirdparty/ke/themes/default/default.css',
			uploadJson : '${pageContext.request.contextPath}/thirdparty/ke/jsp/upload_json.jsp',
			fileManagerJson : '${pageContext.request.contextPath}/thirdparty/ke/jsp/file_manager_json.jsp',
			allowFileManager : true,
			afterChange : function() {
				var autoheight = this.IE ? this.edit.doc.body.scrollHeight : this.edit.doc.body.offsetHeight; 
			    if(autoheight < 150) {
				   autoheight = 150;
				}
				this.edit.setHeight(autoheight);
				this.sync(id);
			},
			
			items : itemsContent
		});
	return createEditor;
}
//new kindediter NoticeKindEditer
function createImg(id)
{
    var itemsContent=['fullscreen','|','fontsize','fontname','forecolor','|',
        'bold','italic', 'underline', 'strikethrough','removeformat','|',
        'justifyleft', 'justifycenter', 'justifyright','insertorderedlist','insertunorderedlist','|',
        'undo', 'redo','image'];
    createEditor = KindEditor.create('textarea[id="'+id+'"]',{
        width : '100%',
        height : '200px',
        resizeType : 1,
        kid : id,
        cssPath : '<%=request.getContextPath() %>/thirdparty/ke/themes/default/default.css',
        uploadJson : '<%=request.getContextPath() %>/thirdparty/ke/jsp/upload_json.jsp',
        fileManagerJson : '<%=request.getContextPath() %>/thirdparty/ke/jsp/file_manager_json.jsp',
        allowFileManager : true,
        afterChange : function() {
            var autoheight = this.IE

                ? this.edit.doc.body.scrollHeight : this.edit.doc.body.offsetHeight;
            if(autoheight < 150) {
                autoheight = 150;
            }
            this.edit.setHeight(autoheight);
            this.sync(id);
        },

        items : itemsContent
    });
    return createEditor;
}

function createWord(id)
{  
		var itemsContent=['fullscreen','|','fontsize','fontname','forecolor','|', 
		   			'bold','italic', 'underline', 'strikethrough','removeformat','|',
		   			'justifyleft', 'justifycenter', 'justifyright','insertorderedlist','insertunorderedlist','|',
		   			'undo', 'redo', 'wordpaste'];
		createEditor = KindEditor.create('textarea[id="'+id+'"]',{
			width : '100%',
			height : '200px',
			resizeType : 1,
			kid : id,
			cssPath : '${pageContext.request.contextPath}/thirdparty/ke/themes/default/default.css',
			uploadJson : '${pageContext.request.contextPath}/thirdparty/ke/jsp/upload_json.jsp',
			fileManagerJson : '${pageContext.request.contextPath}/thirdparty/ke/jsp/file_manager_json.jsp',
			allowFileManager : true,
			afterChange : function() {
				var autoheight = this.IE ? this.edit.doc.body.scrollHeight : this.edit.doc.body.offsetHeight; 
			    if(autoheight < 150) {
				   autoheight = 150;
				}
				this.edit.setHeight(autoheight);
				this.sync(id);
			},
			
			items : itemsContent
		});
	return createEditor;
} 

function createY(id)
{  
		var itemsContent=['fullscreen','|','fontsize','fontname','forecolor','|', 
		   			'bold','italic', 'underline', 'strikethrough','removeformat','|',
		   			'justifyleft', 'justifycenter', 'justifyright','insertorderedlist','insertunorderedlist','|',
		   			'undo', 'redo'];
		createEditor = KindEditor.create('textarea[id="'+id+'"]',{
			width : '100%',
			height : '100px',
			resizeType : 1,
			kid : id,
			cssPath : '${pageContext.request.contextPath}/thirdparty/ke/themes/default/default.css',
			uploadJson : '${pageContext.request.contextPath}/thirdparty/ke/jsp/upload_json.jsp',
			fileManagerJson : '${pageContext.request.contextPath}/thirdparty/ke/jsp/file_manager_json.jsp',
			allowFileManager : true,
			afterChange : function() {
				var autoheight = this.IE ? this.edit.doc.body.scrollHeight : this.edit.doc.body.offsetHeight; 
			    if(autoheight < 150) {
				   autoheight = 150;
				}
				this.edit.setHeight(autoheight);
				this.sync(id);
			},
			
			items : itemsContent
		});
	return createEditor;
} 

function checkEmpty(paraVal) {
	var blReturn = true;
	if (paraVal.replace(/(^[\s\u3000]*)|([\s\u3000]*$)/g, "") == ""){
	    blReturn = false;
	}
	return blReturn;
} 
</script>  