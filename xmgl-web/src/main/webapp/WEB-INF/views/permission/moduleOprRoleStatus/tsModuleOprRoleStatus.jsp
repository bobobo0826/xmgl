<%@ page language="java" contentType="text/html; charset=UTF-8" %>
<html>
<head>
	<title>模块角色状态管理</title>
	<%@ include file="/res/public/hplus.jsp"%>
	<%@ include file="/res/public/easyui_lib.jsp"%>
	<%@ include file="/res/public/common.jsp"%>
	<jsp:include page="/res/public/float_div.jsp" ></jsp:include>
	<script type="text/javascript" src="${pageContext.request.contextPath}/res/public/js/easyui-1.3.2/plugins/datagrid-detailview.js"  charset="UTF-8"></script>
	<script type="text/javascript">
        $(document).ready(function(){
            doSelectValue($("#oprList").val(),"oprName");
            $("#tt").datagrid({
                url:getUrl(),
                sortable:true,
                singleSelect:true,
                pagination:true,
                height:'auto',
                width:'auto',
                striped:true,
                rownumbers:true,
                showFooter: true,
                remoteSort:false,
                columns:[[
                    {field:"action",title:"操作",resizable:true,width:110,headalign:"center",align:"center",sortable:true,formatter:editf },
                    {field:"modulename",title:"模块",resizable:true,width:150,headalign:"center",sortable:true },
                    {field:"role_name",title:"角色",resizable:true,width:120,headalign:"center",sortable:true },
                    {field:"oprname",title:"操作名",resizable:true,width:100,headalign:"center",sortable:true },
                    {field:"expression",title:"条件",resizable:true,width:120,headalign:"center",sortable:true },
                    {field:"statusname",title:"之前状态",resizable:true,width:120,headalign:"center",sortable:true },
                    {field:"afterstatusname",title:"之后状态",resizable:true,width:120,headalign:"center",sortable:true },
                    {field:"retvalue",title:"返回值",resizable:true,width:80,headalign:"center",sortable:true }
                ]],
                onDblClickRow: function(index,row){
                    detail(index);
                }
            });
            $('#tt').datagrid('getPager').pagination({
                pageList:[20,40,60],
                afterPageText:'页  共{pages}页',
                displayMsg:'当前显示第{from}~{to}条记录，共{total}条记录',
                onSelectPage:function(pageNumber, pageSize) {
                    var param=new Object();
                    param.cpage = pageNumber;
                    param.len = pageSize;
                    $('#tt').datagrid('options').queryParams=param;
                    $('#tt').datagrid('options').url=getUrl();
                    $('#tt').datagrid('reload');
                    $('#tt').datagrid('options').queryParams=null;
                }
            });
        });
        $(document).keyup(function(event) {
            if (event.keyCode == 13) {
                doQuery();
            }
        });
        function editf(value,row,index) {
            var u = '[<a href="###" style="text-decoration:none;color:red;" onclick="detail('+index+')">修改</a>]';
            var c = '[<a href="###" style="text-decoration:none;color:red;" onclick="delRow(\''+row.id+'\')">删除</a>]';
            var t =u+" "+c;
            return t;
        }
        function delRow(id) {
            url = "${root}/manage/moduleAndRoleOprStatus/tsMROdel?id="+id;
            layer.confirm('确定删除吗?', {
                btn: ['确定','取消'], //按钮
                shade: false //不显示遮罩
            }, function(index){
                $.ajax({
                    type : 'post',
                    cache : false,
                    url : url,
                    success : function(data) {
                        if(data.msgCode==1)
                        {
                            $('#tt').datagrid('reload');
                        }
                        layer.msg(data.msgDesc);
                    },
                    error:function(result) {
                        layer.msg("系统异常，请联系系统管理员");
                    }
                });
            }, function(index){
                layer.close(index);
            });
        }
        function getUrl() {
            var url = "${root}/manage/moduleAndRoleOprStatus/tsMROQueryList"+getQueryCondition();
            url = encodeURI(encodeURI(url));
            return url;
        }

        function getQueryCondition(){
            var url="?moduleName="+$('#moduleName').val()
                +"&roleName="+$('#roleName').val()
                +"&oprName="+$('#oprName').val();
            return url;
        }

        // 查询
        function query(str) {
            $('#tt').datagrid('options').url = getUrl();
            $('#tt').datagrid('load');
        }
        function addNew()
        {
            var url="${root}/manage/moduleAndRoleOprStatus/tsMROIndex?moduleId=&roleCode=";
            parent.addTab("新增模块角色操作状态", url);
        }
        function detail(index) {
            var rows=$('#tt').datagrid('getData').rows;
            var moduleId = rows[index].moduleid;
            var roleCode  = rows[index].role_code;
            var url='${root}/manage/moduleAndRoleOprStatus/tsMROIndex?moduleId='+moduleId+'&roleCode='+roleCode;
            parent.addTab("修改模块角色操作状态", url);
        }
	</script>
</head>

<body>
<input type="hidden" id="oprList" value="${oprList}"/>
<div class="row">
	<div class="col-sm-12">
		<div class="ibox float-e-margins">
			<div class="ibox-content" id="searchArea" >
				<form method="get" class="form-horizontal">
					<div class="col-sm-4">
						<div class="form-group">
							<label class="col-sm-4 control-label">模块名称:</label>
							<div class="col-sm-6">
								<input type="text" class="form-control" id="moduleName"
									   name="moduleName">
							</div>
						</div>
					</div>
					<div class="col-sm-4">
						<div class="form-group">
							<label class="col-sm-4 control-label">角色名称:</label>
							<div class="col-sm-6">
								<input type="text" class="form-control" id="roleName" name="roleName">
							</div>
						</div>
					</div>
					<div class="col-sm-4">
						<div class="form-group">
							<label class="col-sm-4 control-label">操作:</label>
							<div class="col-sm-6">
								<select  class="form-control"  name="oprName" id="oprName"></select>
							</div>
						</div>
					</div>
				</form>
			</div>
		</div>
	</div>
</div>
<div align="center" id="operator">
	<a class="btn btn-primary btn-sm" href="javascript:query('1');"><i class="fa fa-search"></i>&nbsp;&nbsp;查询</a>&nbsp;&nbsp;
	<a class='btn btn-success btn-sm' href='javascript:addNew();' id='dc'><i class='fa fa-plus'></i>&nbsp;&nbsp;新增</a>&nbsp;&nbsp;
	<a class="btn btn-warning btn-sm" href="javascript:doClear();"><i class="fa fa-refresh"></i>&nbsp;&nbsp;清空</a>&nbsp;&nbsp;
</div>
<div id="tt"></div>
</body>
</html>
