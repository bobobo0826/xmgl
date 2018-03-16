<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
	<title>模块角色操作状态</title>
	<link rel="stylesheet" type="text/css" href="${root}/res/ui/css/style.css" />
	<%@ include file="/res/public/hplus.jsp"%>
	<%@ include file="/res/public/easyui_lib.jsp"%>
	<%@ include file="/res/public/angularjs.jsp"%>
	<%@ include file="/res/public/msg.jsp"%>
	<%@ include file="/res/public/common.jsp"%>
	<script type="text/javascript">
        var myform = angular.module('mybody', ['ui.bootstrap']).controller('bodyCtrl', function($scope, $compile, $http) {
            $scope.model = {};
            doSelectValue($("#moduleList").val(),"moduleId");

            if(isEmpty($("#oprOrderList").val())){
                $("#oprOrderList").val("[]");
            }
            if(isEmpty($("#statusList").val())){
                $("#statusList").val("[]");
            }
            if(isEmpty($("#returnValueList").val())){
                $("#returnValueList").val("[]");
            }

            initOprDataGrid();

            var url = "${root}/manage/moduleAndRoleOprStatus/getMRSByModuleIdAndRoleCode?moduleId="+$("#module_id").val()+"&roleCode="+$("#role_code").val();
            $http.get(url).success(function(response) {
                $("#moduleId").val(response.moduleId);
                selectRoleCode();
                $("#roleCode").val(response.roleCode);
//                $("#roleCode").find("option[value="+response.roleCode+"]").attr("selected",true);
                getList();
            });


            $scope.processForm = function() {
                var rows = $('#oprList').datagrid('getRows');
                if(rows.length==0){
                    layer.alert("请进行编辑!");
                    return;
                }
                for(var i=0;i<rows.length;i++){
                    var rowss = rows[i];
                    if(isBlankOrNull(rowss.oprordername)||
                        isBlankOrNull(rowss.beforestatusname)||
                        isBlankOrNull(rowss.afterstatusname)||
                        isBlankOrNull(rowss.retvaluename)){
                        layer.alert("不允许有空行");
                        return;
                    }
                }

                layer.confirm('确定保存吗?', {
                    btn: ['确定','取消'], //按钮
                    shade: false //不显示遮罩
                }, function(index){
                    var oprListData=$("#oprList").datagrid("getData").rows;
                    alert(JSON.stringify(oprListData))
                    var url="${root}/manage/moduleAndRoleOprStatus/save";
                    $http({
                        method  : 'PUT',
                        url     : encodeURI(encodeURI(url)),
                        data    :{'moduleId':$("#moduleId").val(),'roleCode':$("#roleCode").val(),'oprListData':JSON.stringify(oprListData)},
                        dataType:'json',
                        contentType :'application/json;charset=UTF-8'
                    }).success(function(response) {
                        layer.close(index);
                        if(response.msgCode=='success'){
                            $("#moduleId").val(response.moduleId);
                            $("#roleCode").val(response.roleCode);
                            getList();
                        }
                        layer.msg(response.msgDesc);
                    });
                }, function(index){
                    layer.close(index);
                });
            };

            $scope.closeForm = function() {
                layer.confirm('确定关闭窗口吗?', {
                    btn: ['确定','取消'], //按钮
                    shade: false //不显示遮罩
                }, function(index){
                    parent.closeCurTab();
                    layer.close(index);
                }, function(index){
                    layer.close(index);
                });
            };
        });
        setModuleRequest(myform);

        function isBlankOrNull(data) {
            if(data==undefined||data==null||data=="")
                return true;
            else return false;
        }

        function getList(){
            var url = "${root}/manage/moduleAndRoleOprStatus/getMRSListByModuleIdAndRoleCode?moduleId="+$("#moduleId").val()+"&roleCode="+$("#roleCode").val() ;
            $.ajax({
                url: url,
                type : 'post',
                cache : false,
                async : false,
                success:function(response)
                {
                    list=response.list;
                    $('#oprList').datagrid('loadData',list);
                }
            });
        }

        //模块变动后动态列出角色
        function selectRoleCode( ) {
            var moduleId=$("#moduleId").val();
            var url = "${root}/manage/moduleAndRoleOprStatus/getRoleInfoByModuleId?moduleId="+moduleId ;
            $.ajax({
                url: url,
                type : 'post',
                cache : false,
                async : false,
                success:function(response)
                {
                    list=response.list;
                    $("#roleCode").empty();
                    var emptyOption = $("<option>").val("").text("");
                    $("#roleCode").append(emptyOption);
                    for(var i=0;i<list.length;i++){
                        var itemText =list[i].rolename;
                        var itemvalue =list[i].rolecode;
                        var option = $("<option>").val(itemvalue).text(itemText);
                        $("#roleCode").append(option);
                    }
                }
            });
        }

        function initSelectData(){
            getOprList();
            getStatusList();
            getReturnValueList();
        }

        function getOprList() {
            var url = "${root}/manage/moduleAndRoleOprStatus/getTcOprList?moduleId="+$("#moduleId").val()+"&roleCode="+$("#roleCode").val();
            $.ajax({
                url: url,
                type : 'post',
                cache : false,
                async : false,
                success:function(response)
                {
                    list=response.list;
                    $("#oprOrderList").val(JSON.stringify(list));
                }
            });
        }

        function getStatusList() {
            var url = "${root}/manage/moduleAndRoleOprStatus/getStatus";
            $.ajax({
                url: url,
                type : 'get',
                cache : false,
                async : false,
                success:function(response)
                {
                    list=response.list;
                    $("#statusList").val(JSON.stringify(list));
                }
            });
        }

        function getReturnValueList()
        {
            var url = "${root}/manage/moduleAndRoleOprStatus/getMapRetValue";
            $.ajax({
                url: url,
                type : 'get',
                cache : false,
                async : false,
                success:function(response)
                {
                    list=response.list;
                    $("#returnValueList").val(JSON.stringify(list));
                }
            });
        }


        $(window).resize(function(){ $("#oprList").datagrid("resize");});
        function initOprDataGrid(){
            $("#oprList").datagrid({
                sortable:true,
                singleSelect:true,
                remoteSort:false,
                pagination:false,
                height:'auto',
                width:'auto',
                striped:true,
                columns:[[
                    {field:"tabid",hidden:true},
                    {field:"moduleid",hidden:true},
                    {field:"role_code",hidden:true},
                    {field:"oprorder",hidden:true},
                    {field:"beforestatusid",hidden:true},
                    {field:"afterstatusid",hidden:true},
                    {field:"retvalue",hidden:true},
                    {field:"oprordername",title:"模块操作",resizable:true, width:300,headalign:"center",align:"center",
                        editor: {
                            type: "combobox", options: {
                                data: JSON.parse($("#oprOrderList").val()),
                                valueField: "data_id",
                                textField: "data_name",
                                panelHeight:'auto',
                                editable: false,
                                required: true
                            }
                        }},
                    {field:"expression",title:"真值条件(或表达式)",resizable:true, width:400,headalign:"center",align:"center",
                        editor: {
                            type: "text",
                            options: {
                                required: true
                            }
                        }},
                    {field:"beforestatusname",title:"当前状态",resizable:true, width:200,headalign:"center",align:"center",editor: {
                        type: "combobox", options: {
                            data: JSON.parse($("#statusList").val()),
                            valueField: "data_id",
                            textField: "data_name",
                            panelHeight:'auto',
                            editable: false,
                            required: true
                        }
                    }},
                    {field:"afterstatusname",title:"后续状态",resizable:true, width:200,headalign:"center",align:"center",
                        editor: {
                            type: "combobox", options: {
                                data:JSON.parse($("#statusList").val()),
                                valueField: "data_id",
                                textField: "data_name",
                                panelHeight:'auto',
                                editable: false,
                                required: true
                            }
                        }},
                    {field:"retvaluename",title:"返回值",resizable:true, width:200,headalign:"center",align:"center",
                        editor: {
                            type: "combobox", options: {
                                data: JSON.parse($("#returnValueList").val()),
                                valueField: "data_id",
                                textField: "data_name",
                                panelHeight:'auto',
                                editable: false,
                                required: true
                            }
                        }},
                    {field:"action",title:"删除",width:200, headalign:"center", align:"center", formatter:editf}
                ]],
                onBeforeEdit:function(index,row){
                    row.editing = true;
                    $('#oprList').datagrid('refreshRow', index);
                },
                onAfterEdit:function(index,row){
                    row.editing = false;
                    $('#oprList').datagrid('refreshRow', index);
                },
                onCancelEdit:function(index,row){
                    row.editing = false;
                    $('#oprList').datagrid('refreshRow', index);
                }
            });
        }

        //操作栏目初始化
        function editf(value, row, index)
        {
            var f='';
            if(row.editing){
                f = '[<a href="###" style="text-decoration:none;color:red;" onclick="updateRow('+index+')">保存</a>]&nbsp&nbsp';
            }
            var e = '[<a href="###" style="text-decoration:none;color:red;" onclick="del('+index+')">删除</a>]&nbsp&nbsp';
            return f+" "+e;
        }

        function appendRow() {
            var moduleId = $("#moduleId").val();
            var roleCode = $("#roleCode").val();
            var rows = $('#oprList').datagrid('getRows');
            if (moduleId == "") {
                layer.alert("请选择模块");
                return;
            }
            if (roleCode == "") {
                layer.alert("请选择角色");
                return;
            }
            if(rows!=null){
                for(var i=0;i<rows.length;i++){
                    if(rows[i].editing){
                        layer.alert("请选择保存当前正在编辑的操作信息");
                        return;
                    }
                }
            }

            initSelectData();
            initOprDataGrid();

            addRow();
        }

        function updateRow(){
            var rows = $("#oprList").datagrid("getRows");
            for(var i=0;i<rows.length;i++)
            {
                if(rows[i].editing)
                {
                    var oprorder = $("#oprList").datagrid('getEditor', {
                        index: i,
                        field: 'oprordername'
                    });
                    var expression = $("#oprList").datagrid('getEditor', {
                        index: i,
                        field: 'expression'
                    });
                    var beforestatusid = $("#oprList").datagrid('getEditor', {
                        index: i,
                        field: 'beforestatusname'
                    });
                    var afterstatusid = $("#oprList").datagrid('getEditor', {
                        index: i,
                        field: 'afterstatusname'
                    });
                    var retvalue = $("#oprList").datagrid('getEditor', {
                        index: i,
                        field: 'retvaluename'
                    });

                    $('#oprList').datagrid('updateRow', {
                        index: i,
                        row: {
                            oprorder:$(oprorder.target).combobox('getValue'),
                            oprordername:$(oprorder.target).combobox('getText'),
                            expression:$(expression.target).val(),
                            beforestatusid:$(beforestatusid.target).combobox('getValue'),
                            beforestatusname:$(beforestatusid.target).combobox('getText'),
                            afterstatusid:$(afterstatusid.target).combobox('getValue'),
                            afterstatusname:$(afterstatusid.target).combobox('getText'),
                            retvalue:$(retvalue.target).combobox('getValue'),
                            retvaluename:$(retvalue.target).combobox('getText')
                        }
                    });

                    $('#oprList').datagrid('endEdit', i);
                }
            }
        }

        function addRow() {
            $("#oprList").datagrid("appendRow", {
                moduleid:$("#moduleId").val(),
                role_code:$("#roleCode").val()
            });

            editIndex = $("#oprList").datagrid("getRows").length - 1;
            $("#oprList").datagrid("selectRow", editIndex).datagrid("beginEdit", editIndex);
        }

        function del(index){
            var rows=$('#oprList').datagrid('getData').rows;
            var tabid =rows[index].tabid;
            if(tabid==null)
            {
                $('#oprList').datagrid('deleteRow', index);
            }else
            {
                var url="${root}/manage/moduleAndRoleOprStatus/tsMROdel?id="+tabid;
                layer.confirm("确定删除？", {
                    btn: ['确定','取消'],
                    shade: false
                }, function(index){
                    $.ajax({
                        url: url,
                        type : 'post',
                        cache : false,
                        async : false,
                        success:function(response)
                        {
                            if(response.msgCode=="1")
                            {
                                getList();
                            }
                            layer.msg(response.msgDesc);
                        }
                    });
                }, function(index){
                    layer.close(index);
                });
            }
        }

	</script>
</head>
<body ng-app="mybody" ng-controller="bodyCtrl">
<form collapse="isCollapsed" class="form-horizontal" role="form"  id="myform" name="myform" novalidate>
	<input type="hidden" id="module_id" value="${moduleId}"/>
	<input type="hidden" id="role_code" value="${roleCode}"/>
	<input type="hidden" id="moduleList" value="${moduleList}"/>
	<input type="hidden" id="oprOrderList" value="${oprOrderList}"/>
	<input type="hidden" id="statusList" value="${statusList}"/>
	<input type="hidden" id="returnValueList" value="${returnValueList}"/>
	<div class="row">
		<div class="col-sm-12">
			<div class="ibox">
				<div class="ibox-content">
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-4 control-label">模块：</label>
							<div class="col-sm-6">
								<select  class="form-control"  name="moduleId" id="moduleId" onchange="selectRoleCode()"></select>
							</div>
						</div>
					</div>
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-4 control-label">角色：</label>
							<div class="col-sm-6">
								<select  class="form-control"  name="roleCode" id="roleCode" ></select>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>

	<div class="row">
		<div class="col-sm-12">
			<div class="ibox">
				<div class="ibox-content">
					<div class="col-sm-12">
						<div class="toolbardiv">
							<a class="btn btn-success btn-sm"
							   href="javascript:appendRow();"><i class='fa fa-plus'></i>&nbsp;&nbsp;添加</a>
						</div>
						<div id="oprList"></div>
					</div>
				</div>
			</div>
		</div>
	</div>
</form>

<div class="main_btnarea">
	<div class="btn_area_setc btn_area_bg" id="operator">
		<a class='btn btn-primary btn-sm' href='###' ng-click='processForm()'><i class='fa fa-check'></i>&nbsp;&nbsp;保存</a>&nbsp;&nbsp;
		<a class='btn btn-danger btn-sm' href='###' ng-click='closeForm()'><i class='fa fa-remove'></i>&nbsp;&nbsp;关闭</a>
	</div>
</div>

</body>
</html>