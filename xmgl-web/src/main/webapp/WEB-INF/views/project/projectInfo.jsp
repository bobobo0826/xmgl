<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!doctype html>
<html>
<head>
    <title>项目详情</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <!--hplus-->
    <%@ include file="/res/public/hplus.jsp" %>
    <%@ include file="/res/public/easyui_lib.jsp" %>
    <%@ include file="/res/public/angularjs.jsp" %>
    <%@ include file="/res/public/msg.jsp" %>
    <%@ include file="/res/public/common.jsp" %>

    <!--hplus--><!--项目模块移植-->
    <link rel="stylesheet" type="text/css"
          href="${pageContext.request.contextPath}/thirdparty/zTree_v3/css/metroStyle/metroStyle.css"/>
    <script type="text/javascript"
            src="${pageContext.request.contextPath}/thirdparty/zTree_v3/js/jquery.ztree.all-3.5.min.js"></script>
    <style type="text/css">
        div#rMenu {
            position: absolute;
            visibility: hidden;
            top: 0;
            background-color: #555;
            text-align: left;
            padding: 2px;
        }

        div#rMenu ul li {
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

    <script type="text/javascript">
        var _funcArray;
        var _curModuleCode = "${_curModuleCode}";
        var myform = angular.module('mybody', ['ui.bootstrap']).controller('bodyCtrl', function ($scope, $compile, $http) {

            _funcArray = getFunctions('${pageContext.request.contextPath}', _curModuleCode);
            $scope.model = {};
            var url = '${root}/manage/project/getProjectInfoById?id=' + $("#_id").val();
            $http.get(url).success(function (response) {

                $scope.model.projectBase = response.projectBase;
                controlButs($scope, $compile);
                var projectTypeCode = "";
                if ($scope.model.projectBase.projectTypeCode != null) {
                    projectTypeCode = $scope.model.projectBase.projectTypeCode;
                }
                getProjectTypeList(projectTypeCode);

                var projectStatusCode = "";
                if ($scope.model.projectBase.projectStatusCode != null) {
                    projectStatusCode = $scope.model.projectBase.projectStatusCode;
                }
                getProjectStatusList(projectStatusCode);
                /**
                 * 读取&显示完成情况百分比
                 * */
                if ($scope.model.projectBase.completeStatus) {
                    $("#completeStatus").text($scope.model.projectBase.completeStatus);
                } else {

                    $("#completeStatus").text("0%");
                }
                $(".progress-bar").css("width", $("#completeStatus").text());
                //初始化参与人员列表
                initParticipant();
                //初始化项目模块
                if ($("#_id").val() == 0) {
                    $("#XMMK").hide();
                }
                var root = {'name': $scope.model.projectBase.projectName, 'id': -1, open: true, isParent: true};
                _zTree = $.fn.zTree.init($("#tree"), setting, root);
                var node = _zTree.getNodeByParam('id', -1, null);//获取根节点
                tool.onClick(null, null, node);
                _rMenu = $("#rMenu");
            });
            $scope.processForm = function (funcCode) {
                if (!validateForm()) {
                    return;
                }
                var msg = "";
                switch (funcCode) {
                    case 'SAVE':
                        msg = "保存"
                        break;
                    default:
                        break;
                }
                layer.confirm('确定' + msg + '吗?', {
                    btn: ['确定', '取消'], //按钮
                    shade: false //不显示遮罩
                }, function (index) {
                    $scope.model.projectBase.projectTypeCode = $("#projectType").val();
                    $scope.model.projectBase.projectName = $("#projectName").val();
                    $scope.model.projectBase.projectAbbr = $("#projectAbbr").val();
                    $scope.model.projectBase.projectDesc = $("#projectDesc").val();
                    $scope.model.projectBase.creator = $("#creator").val();
                    $scope.model.projectBase.createDate = $("#createDate").val();
                    $scope.model.projectBase.modifier = $("#modifier").val();
                    $scope.model.projectBase.modifyDate = $("#modifyDate").val();
                    $scope.model.projectBase.developStartTime = $("#developStartTime").val();
                    $scope.model.projectBase.developEndTime = $("#developEndTime").val();
                    $scope.model.projectBase.maintainStartTime = $("#maintainStartTime").val();
                    $scope.model.projectBase.maintainEndTime = $("#maintainEndTime").val();


                    //添加保存项目人员
                    var participantList = $('#participant').datagrid('getData').rows;
                    var participantLists = new Array();
                    if (participantList != "" && participantList != null) {
                        for (var i = 0; i < participantList.length; i++) {
                            delete participantList[i].participant_type;
                            participantLists.push(participantList[i]);
                        }
                        $scope.model.participantList = JSON.stringify(participantLists);
                    }
                    $scope.model.projectBase = JSON.stringify($scope.model.projectBase);

                    var url = "${root}/manage/project/saveProject";
                    $http({
                        method: 'POST',
                        url: encodeURI(encodeURI(url)),
                        data: $scope.model,
                        headers: {'Content-Type': 'application/x-www-form-urlencoded'}
                    }).success(function (response) {
                        layer.close(index);
                        if (response.msgCode == 1) {
                            $scope.model.projectBase = JSON.parse(response.msgData);
                            $('#participant').datagrid('reload');
                        }
                        layer.msg(response.msgDesc);
                    });

                }, function (index) {
                    layer.close(index);
                });
            };
            $scope.closeForm = function () {
                layer.confirm('确定关闭窗口吗?', {
                    btn: ['确定', '取消'], //按钮
                    shade: false //不显示遮罩
                }, function (index) {
                    parent.closeCurTab();
                    layer.close(index);
                }, function (index) {
                    layer.close(index);
                });
            };
        });
        setModuleRequest(myform);

        function getProjectTypeList(value) {
            var url = "${root}/manage/project/getProjectTypeList";
            url = encodeURI(encodeURI(url));
            $.ajax({
                url: url,
                type: 'get',
                async: true,
                success: function (result) {
                    addSelectOption(result.projectTypeList, "projectType");
                    $("#projectType").val(value);

                }
            });
        }
        function getProjectStatusList(value) {
            var url = "${root}/manage/project/getDicListByBusinessCode?businessCode=project_status";
            url = encodeURI(encodeURI(url));
            $.ajax({
                url: url,
                type: 'get',
                async: true,
                success: function (result) {
                    addSelectOption(result.dictionaryList, "projectStatus");
                    $("#projectStatus").val(value);

                }
            });
        }


        function controlButs($scope, $compile) {
            var html = "";
            if (_funcArray != null && _funcArray != undefined) {
                for (var i = 0; i < _funcArray.length; i++) {
                    var funcObj = _funcArray[i];
                    switch (funcObj) {
                        case 'saveProject':
                            html += "<a class='btn btn-primary btn-sm' href='###' ng-click='processForm(\"SAVE\")'><i class='fa fa-check'></i>&nbsp;&nbsp;保存</a>&nbsp;&nbsp;";
                            break;
                        case 'addParticipant':
                            $("#addNewParticipant").show();
                            break;
                        default:
                            break;
                    }
                }
            }
            html += "<a class='btn btn-danger btn-sm' href='###' ng-click='closeForm()'><i class='fa fa-check'></i>&nbsp;&nbsp;关闭</a>&nbsp;&nbsp;";
            var template = angular.element(html);
            var element = $compile(template)($scope);
            angular.element("#operator").empty();
            angular.element("#operator").append(element);
        }

        //对有required=required属性的表单元素，进行必填校验
        function validateForm() {
            var es = $("#myform *[required='true']");
            if (es.length > 0) {
                for (var i = 0; i < es.length; i++) {
                    var e = es[i];
                    if ($.trim($(e).val()) == "") {
                        layer.tips('该字段必填', '#' + $(e).attr("id"));
                        $("html,body").animate({scrollTop: $("#" + $(e).attr("id")).offset().top - $("html,body").offset().top + $("html,body").scrollTop()}, 1000);
                        return false
                    }
                }
            }
            return true;
        }

    </script>
    <script type="text/javascript">
        var className = "dark", curDragNodes, autoExpandNode;
        var _FONT_GREEN = {'color': "#008000", 'font-weight': 'bold'};
        var _FONT_DEF = {'color': "#000000", 'font-weight': 'normal'};
        var tree = "";
        var setting = {
            view: {
                showIcon: true,
                showLine: true,
                fontCss: function (treeId, node) {
                    var fontStyle = _FONT_DEF;
                    return fontStyle;
                }
            },
            data: {
                keep: {}
            },
            callback: {
                onClick: function (event, treeId, treeNode) {
                    tool.onClick(event, treeId, treeNode);
                },
                onDbClick: function (event, treeId, treeNode) {

                },
                onRightClick: function (event, treeId, treeNode) {
                    if (!treeNode && event.target.tagName.toLowerCase() != "button" && $(event.target).parents("a").length == 0) {
                        _zTree.cancelSelectedNode();
                        tool.showRMenu({
                            'pos': {'x': event.offsetX, 'y': event.offsetY},
                            'show': []
                        });
                        $("body").unbind("mousedown", tool.onBodyMouseDown);
                    }
                    else if (treeNode) {
                        _pNode = treeNode;
                        _zTree.selectNode(treeNode);
                        tool.showRMenu({
                            'pos': {'x': event.offsetX + 100, 'y': event.offsetY + 100},
                            'show': ['#m_add', '#m_del', '#m_refresh']
                        });
                        $('#m_add').hide();
                        $('#m_del').hide();
                    }
                    //新增与删除模块权限配置
                    if (_funcArray != null && _funcArray != undefined) {
                        for (var i = 0; i < _funcArray.length; i++) {
                            var funcObj = _funcArray[i];
                            switch (funcObj) {
                                case 'addModule':
                                    $('#m_add').show();
                                    break;
                                case 'deleteModule':
                                    $('#m_del').show();
                                    break;
                                default:
                                    break;
                            }
                        }
                    }
                },
                beforeDragOpen: function (treeId, treeNode) {
                    tool.onClick(null, null, treeNode);
                    autoExpandNode = treeNode;
                    return true;
                },
                beforeDrag: function (treeId, treeNodes) {
                    className = (className === "dark" ? "" : "dark");
                    for (var i = 0, l = treeNodes.length; i < l; i++) {
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

                onDrag: function (event, treeId, treeNodes) {
                    return true;
                },
                onDrop: function (event, treeId, treeNodes, targetNode, moveType, isCopy) {
                    var movedNode = treeNodes[0];
                    $.ajax({
                        type: 'post',
                        url: "${pageContext.request.contextPath}/manage/projectModule/moveProjModule?fromModuleId=" + movedNode.id + "&toModuleId=" + targetNode.id + "&targetLevel=" + (targetNode.level + 1),
                        dataType: "text",
                        async: false,
                        success: function (data) {
                            if (data.msgCode == "success") {
                                reloadTreeNodeById(movedNode.id);
                            }
                            layer.msg(data.msgDesc);
                        },
                        error: function (msg) {
                        }
                    });
                }

            },
            edit: {
                enable: true,
                showRemoveBtn: false,
                showRenameBtn: false,
                drag: {//暂时不启用抓取移动功能
                    autoExpandTrigger: false,
                    prev: false,
                    inner: false,
                    next: false
                }
            }
        };
        var tool = {
            onClick: function (event, treeId, treeNode) {

                tree = $.fn.zTree.getZTreeObj("tree");
                var frame = document.getElementById('moduleItemIndex');
                if (!treeNode.load) {
                    var url;
                    if (treeNode.id == -1) {
                        //根据项目id直接查找模块
                        url = "${root}/manage/projectModule/getProjModuleTreeList?parentId=" + $("#_id").val() + "&level=" + (treeNode.level + 2);
                    } else {
                        //加level条件，预防第一层项目id与第二层模块id冲突的情况
                        url = "${root}/manage/projectModule/getProjModuleTreeList?parentId=" + treeNode.id + "&level=" + (treeNode.level + 2);
                    }

                    $.ajax({
                        type: "post",
                        url: url,
                        async: false,//此处用同步;用异步，树展开时，点快了会出现数据重复
                        success: function (data) {
                            if (data == null || data.length == 0)
                                return;
                            for (var i = 0; i != data.length; ++i) {
                                data[i].open = false;
                                data[i]['load'] = false;
                            }
                            tree.addNodes(treeNode, data);
                            treeNode.load = true;
                            tree.updateNode(treeNode);

                        }
                    });
                }
                //查看模块信息权限配置
                frame.src = '';
                if (treeNode.level > 0 && _funcArray != null && _funcArray != undefined) {
                    for (var i = 0; i < _funcArray.length; i++) {
                        var funcObj = _funcArray[i];
                        switch (funcObj) {
                            case 'moduleInfo':
                                //详情页面只需传moduleId供查询信息，传projectName用于显示，projectId和level虽能通查询查到，为方便保存一并传过去,level传过去要加1，因为数据库中存的level比实际树上的level大1.
                                frame.src = "${root}/manage/projectModule/initProjModuleInfo?moduleId=" + treeNode.id + "&projectName=" + treeNode.project_name + "&projectId=" + treeNode.project_id + "&parentId=" + "&level=" + (treeNode.level + 1) + "&_curModuleCode=" + _curModuleCode + "&oprCode=moduleInfo";
                                break;
                            default:
                                break;
                        }
                    }
                }
            },
            showRMenu: function (obj) {
                var y = obj.pos.y;
                var x = obj.pos.x;
                $('#rMenu ul').show();
                if (obj.show.length != 0) {
                    for (var i = 0; i != obj.show.length; ++i) {
                        $(obj.show[i] + '').show();
                    }
                    _rMenu.css({"top": y + "px", "left": x + "px", "visibility": "visible"});
                    $("body").bind("mousedown", tool.onBodyMouseDown);
                }
            },
            hideRMenu: function () {
                if (_rMenu) {
                    _rMenu.css({"visibility": "hidden"});
                }
                $("body").unbind("mousedown", tool.onBodyMouseDown);
            },
            onBodyMouseDown: function (event) {
                if (!(event.target.id == "rMenu" || $(event.target).parents("#rMenu").length > 0)) {
                    _rMenu.css({"visibility": "hidden"});
                }
            },
            delNode: function () {
                tool.hideRMenu();
                if (_pNode.id == -1) {
                    layer.alert("根节点不能删除！");
                    return;
                }
                layer.confirm('确定删除吗?', {
                    btn: ['确定', '取消'], //按钮
                    shade: false //不显示遮罩
                }, function (index) {
                    var url = '${root}/manage/projectModule/delProjModuleInfo?moduleId=' + _pNode.id;
                    $.ajax({
                        url: url,
                        type: 'post',
                        cache: false,
                        async: false,
                        success: function (data) {
                            if (data.msgCode == "success") {
                                _zTree.removeNode(_pNode);
                                if (_pNode.pid != $("#_id").val()) {
                                    reloadTreeNodeById(_pNode.pid);
                                }
                            }
                            layer.msg(data.msgDesc);
                        }
                    });
                }, function (index) {
                    layer.close(index);
                });
            },
            addSubNode: function () {
                tool.hideRMenu();
                var frame = document.getElementById('moduleItemIndex');
                if (_pNode.level == 0) {
                    frame.src = "${root}/manage/projectModule/initProjModuleInfo?parentId=" + $("#_id").val() + "&projectName=" + $("#projectName").val() + "&projectId=" + $("#_id").val() + "&moduleId=" + "&level=" + (_pNode.level + 2) + "&_curModuleCode=" + _curModuleCode + "&oprCode=moduleInfo";
                } else {
                    //新增页面，需传projectName用于显示，其他参数用于存储
                    frame.src = "${root}/manage/projectModule/initProjModuleInfo?parentId=" + _pNode.id + "&projectName=" + _pNode.project_name + "&projectId=" + _pNode.project_id + "&moduleId=" + "&level=" + (_pNode.level + 2) + "&_curModuleCode=" + _curModuleCode + "&oprCode=moduleInfo";//为保证以前功能可以用，暂时数据库里存的level比实际树上的要大1
                }
            },
            refresh: function () {
                tool.hideRMenu();
                reloadTreeNodeById(_pNode.id, null);
            }
        };
        //根据节点id，加载节点下的子节点
        function reloadTreeNodeById(id, parentId) {
            var treeNode = "";
            if (parentId != null)
                treeNode = _zTree.getNodeByParam("id", parentId, null);
            else
                treeNode = _zTree.getNodeByParam("id", id, null);
            treeNode.load = false;
            _zTree.removeChildNodes(treeNode);
            tool.onClick(null, "tree", treeNode);
            _zTree.expandNode(treeNode, true, true, false);
            if (parentId != null) {
                window.setTimeout(function () {
                    reloadTreeChildNodeById(id);
                }, 120);
            }
        }
        function reloadTreeChildNodeById(id) {
            var treeNode = _zTree.getNodeByParam("id", id, null);
            treeNode.load = false;
            _zTree.removeChildNodes(treeNode);
            tool.onClick(null, "tree", treeNode);
            if (treeNode != null) {
                _zTree.expandNode(treeNode, true, true, true);
            }
        }
        //改变父节点后的刷新
        function reloadTreeNodeByParentId(parentId, newId, id) {
            var treeNode = _zTree.getNodeByParam("id", parentId, null);
            if (treeNode != null) {
                treeNode.load = false;
                _zTree.removeChildNodes(treeNode);
                tool.onClick(null, "tree", treeNode);
                _zTree.expandNode(treeNode, true, true, true);
                window.setTimeout(function () {
                    reloadNewTreeNodeByParentId(newId, id);
                }, 120);
            }
        }
        function reloadNewTreeNodeByParentId(newId, id) {
            var treeNode = _zTree.getNodeByParam("id", newId, null);
            if (treeNode != null) {
                treeNode.load = false;
                _zTree.removeChildNodes(treeNode);
                tool.onClick(null, "tree", treeNode);
                _zTree.expandNode(treeNode, true, true, true);
                window.setTimeout(function () {
                    showTreeNodeByParentId(id);
                }, 120);
            }
        }
        function showTreeNodeByParentId(id) {
            var treeNode = _zTree.getNodeByParam("id", id, null);
            if (treeNode != null) {
                treeNode.load = false;
                _zTree.removeChildNodes(treeNode);
                tool.onClick(null, "tree", treeNode);
                _zTree.expandNode(treeNode, true, true, true);
            }
        }
    </script>
    <script type="text/javascript">
        var _rMenu, _zTree, _pNode;
        $(document).ready(function () {


        });
    </script>
    <script type="text/javascript">
        $(window).resize(function () {
            $("#participant").datagrid("resize");
        });

        function initParticipant() {
            $("#participant").datagrid({
                url: getUrl(),
                sortable: true,
                remoteSort: false,
                singleSelect: true,
                pagination: false,
                height: 'auto',
                width: $(window).width() - 100,
                striped: true,
                nowrap: false,

                columns: [[
                    {field: "id", title: "id", hidden: true},
                    {field: "employee_id", title: "员工id", hidden: true},
                    {
                        field: "action",
                        title: "操作",
                        resizable: true,
                        width: 100,
                        headalign: "center",
                        align: "center",
                        formatter: editParticipant
                    },
                    {
                        field: "participant_name",
                        title: "参与人员",
                        resizable: true,
                        width: 200,
                        headalign: "center",
                        align: "center",
                        sortable: true
                    },
                    {
                        field: "participant_type",
                        title: "人员类别",
                        resizable: true,
                        width: 200,
                        headalign: "center",
                        align: "center",
                        sortable: true
                    },
                    {
                        field: "participant_gender",
                        title: "性别",
                        resizable: true,
                        width: 200,
                        headalign: "center",
                        align: "center",
                        sortable: true
                    },
                    {
                        field: "participant_tel",
                        title: "手机",
                        resizable: true,
                        width: 200,
                        headalign: "center",
                        align: "center",
                        sortable: true
                    },
                    {field: "participant_photo", title: "照片", hidden: true},
                    {field: "participant_type_code", title: "类别编码", hidden: true}

                ]],
                onDblClickRow: function (rowIndex, rowData) {
                    beginEdit(rowIndex);
                }
            });
        }
        function editParticipant(value, row, index) {
            var t = '';
            if (_funcArray != null && _funcArray != undefined) {
                for (var i = 0; i < _funcArray.length; i++) {
                    var funcObj = _funcArray[i];
                    switch (funcObj) {
                        case 'participantInfo':
                            t += '[<a href="###" style="text-decoration:none;color:red;" onclick="beginEdit(' + index + ')">详情</a>]';
                            break;
                        case 'deleteParticipant':
                            t += '[<a href="###" style="text-decoration:none;color:red;" onclick="delRow(' + index + ')">删除</a>]';
                            break;
                        default:
                            break;
                    }
                }
            }
            return t;
        }
        function getUrl() {
            var url = "${root}/manage/project/queryParticipantList?projectId=" + $("#_id").val();
            url = encodeURI(encodeURI(url));
            return url;
        }

        function beginEdit(rowIndex) {
            var url;
            var width = '80%';
            var height = '80%';
            url = "${root}/manage/project/initParticipantInfo?_rowIndex=" + rowIndex + "&_curModuleCode=" + _curModuleCode;
            if (-1 == rowIndex) {
                f_open("newWindow", "新增参与人员", width, height, url, true);
            } else {
                f_open("newWindow", "参与人员详情", width, height, url, true);
            }
        }
        /**
         * 删除行
         * 行数据有id时，从数据库删，删除成功再从表格删
         * 行数据没有id时，直接从表格删除
         */
        function delRow(index) {
            var rows = $('#participant').datagrid('getData').rows;
            var id = rows[index].id;
            var index1 = index;
            if (id) {
                var url = "${root}/manage/project/delParticipantById?id=" + id;
                layer.confirm(_DELETE_ONE_MSG, {
                    btn: ['确定', '取消'], //按钮
                    shade: false //不显示遮罩
                }, function (index) {
                    $.ajax({
                        url: url,
                        type: 'delete',
                        success: function (response) {

                            if (response.msgCode == 1) {
                                $("#participant").datagrid('deleteRow', index1);
                                for (var k = index1; k < rows.length; k++) {
                                    $('#participant').datagrid('refreshRow', k);
                                }
                            }
                            layer.msg(response.msgDesc);
                        },
                        error: function (result) {
                            layer.msg("系统异常，请联系系统管理员");
                        }
                    });
                }, function (index) {
                    layer.close(index);
                });
            } else {
                $("#participant").datagrid('deleteRow', index);
                for (var k = index; k < rows.length; k++) {
                    $('#participant').datagrid('refreshRow', k);
                }
            }
        }
        /**
         * 获取行数据
         * */
        function getGrid(rowIndex) {
            if (rowIndex != "") {
                var rows = $('#participant').datagrid('getData').rows;
                var row_data = rows[rowIndex];
                return JSON.stringify(row_data);
            }

        }
        /**
         * 添加行
         * */
        function appendRow() {
            $('#participant').datagrid('appendRow', {});
//            var rowIndex = $('#participant').datagrid('getRows').length - 1;
        }
        /**
         * 更新行
         * */
        function updateGrid(object, grid_index) {
            if (grid_index == -1) {
                appendRow();
                grid_index = $('#participant').datagrid('getRows').length - 1;
            }
            $('#participant').datagrid('updateRow', {
                index: grid_index,
                row: {
                    employee_id: object.employee_id,
                    participant_name: object.participant_name,
                    participant_type: object.participant_type,
                    participant_gender: object.participant_gender,
                    participant_tel: object.participant_tel,
                    participant_photo: object.participant_photo,
                    participant_type_code: object.participant_type_code
                }
            });
        }

    </script>

</head>

<body ng-app="mybody" ng-controller="bodyCtrl">
<input type="hidden" id="_id" value="${id}">
<form collapse="isCollapsed" class="form-horizontal" role="form" id="myform" name="myform" novalidate>
    <div class="row">
        <div class="col-sm-12">
            <div class="ibox">
                <a>
                    <div class="ibox-title">
                        <h5>基本信息</h5>
                    </div>
                </a>
                <div class="ibox-content">
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">项目名称：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.projectBase.projectName" type="text" class="form-control"
                                       id="projectName" name="projectName" required='true'/>
                            </div>
                            <div class="col-sm-2">
                                <span class="text-danger">*</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">项目简称：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.projectBase.projectAbbr" type="text" class="form-control"
                                       id="projectAbbr" name="projectAbbr"/>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">项目类型：</label>
                            <div class="col-sm-6">
                                <select class="form-control" id="projectType" name="projectType"></select>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">项目完成情况：</label>
                            <%-- <div class="col-sm-6">
                                 <input ng-model="model.projectBase.completeStatus" type="text" class="form-control"
                                        id="completeStatus" name="completeStatus" readonly="true"/>
                             </div>--%>
                            <div class="col-sm-6">
                                <div class="progress progress-striped active m-b-sm"
                                     style="margin-bottom:0px;height:28px">
                                    <div style="width: 0%;" class="progress-bar"></div>
                                </div>
                            </div>
                            <div class="col-sm-2">
                                <span id="completeStatus"></span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class=" form-group">
                            <label class="col-sm-4 control-label">项目状态：</label>
                            <div class="col-sm-6">
                                <select type="text" class="form-control" id="projectStatus" name="projectStatus"
                                        disabled="disabled" >
                                </select>
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
                    <div class="col-md-8">
                        <div class="form-group">
                            <label class="col-sm-2 control-label">项目描述：</label>
                            <div class="col-sm-9">
                                <textarea type="text" ng-model="model.projectBase.projectDesc" class="form-control"
                                          id="projectDesc" name="projectDesc" rows='4'></textarea>
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
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">创建人：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.projectBase.creator" type="text" class="form-control"
                                       id="creator" name="creator" required='true' readonly="true"/>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">创建时间：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.projectBase.createDate" type="text" class="form-control"
                                       id="createDate" name="createDate" readonly="true"/>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">修改人：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.projectBase.modifier" type="text" class="form-control"
                                       id="modifier" name="modifier" readonly="true"/>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">修改时间：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.projectBase.modifyDate" type="text" class="form-control"
                                       id="modifyDate" name="modifyDate" readonly="true"/>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">开发开始时间：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.projectBase.developStartTime" type="text" class="form-control"
                                       onclick="laydate()" id="developStartTime" name="developStartTime" required = "true"/>
                            </div>
                            <div class="col-sm-2">
                                <span class="text-danger">*</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">开发结束时间：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.projectBase.developEndTime" type="text" class="form-control"
                                       onclick="laydate()"  id="developEndTime" name="developEndTime" required = "true"/>
                            </div>
                            <div class="col-sm-2">
                                <span class="text-danger">*</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">维护开始时间：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.projectBase.maintainStartTime" type="text" class="form-control"
                                       onclick="laydate()"  id="maintainStartTime" name="maintainStartTime" />
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">维护结束时间：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.projectBase.maintainEndTime" type="text" class="form-control"
                                       onclick="laydate()"  id="maintainEndTime" name="maintainEndTime" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="row">
        <%--参与人员--%>
        <div class="col-sm-12">
            <div class="ibox">
                <a class="collapse-link">
                    <div class="ibox-title">
                        <h5>参与人员</h5>
                        <div class="ibox-tools">
                            <i class="fa fa-chevron-up"></i>
                        </div>
                    </div>
                </a>
                <div class="ibox-content">
                    <div class="toolbardiv" id="goodsToolBar">
                        <a id="addNewParticipant" class="btn btn-success btn-sm" style="display: none"
                           href="javascript:beginEdit(-1);">
                            <i class='fa fa-plus'></i>&nbsp;&nbsp;新增</a>
                    </div>
                    <table id="participant"></table>
                </div>
            </div>
        </div>
    </div>

    <div class="row" id="XMMK">
        <%--项目模块--%>
        <div class="col-sm-12">

            <div class="ibox">
                <a class="collapse-link">
                    <div class="ibox-title">
                        <h5>项目模块</h5>
                        <div class="ibox-tools">
                            <i class="fa fa-chevron-up"></i>
                        </div>
                    </div>
                </a>
                <div class="ibox-content">
                    <div class="inner6px">
                        <table border=0 height=600px align=left>
                            <tr>
                                <td width=260px align=left valign=top style="BORDER-RIGHT: #999999 1px dashed">
                                    <div>
                                        <ul id="tree" class="ztree">
                                        </ul>
                                    </div>
                                </td>

                                <td width=1400px align=left valign=top>
                                    <IFRAME ID="moduleItemIndex" Name="moduleItemIndex" FRAMEBORDER=0 SCROLLING=AUTO
                                            width=100% height=600px SRC=""></IFRAME>
                                </td>
                            </tr>
                        </table>
                    </div>
                    <div id="rMenu">
                        <ul>
                            <li id="m_add" onclick="tool.addSubNode();">添加项目模块</li>
                            <li id="m_del" onclick="tool.delNode();">删除项目模块</li>
                            <li id="m_refresh" onclick="tool.refresh();">刷新</li>
                        </ul>
                    </div>
                </div>
            </div>

        </div>
    </div>
</form>
<!-- 隐藏div防止底部按钮区域覆盖表单区域 -->
<div style="margin-bottom:50px;"></div>
<div class="main_btnarea">
    <div class="btn_area_setc btn_area_bg" id="operator">

    </div>
</div>
</body>
</html>
