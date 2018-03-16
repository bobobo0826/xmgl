<%--
  Created by IntelliJ IDEA.
  User: mjq
  Date: 2017/7/26
  Time: 14:42
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>我的任务详情</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <%@ include file="/res/public/hplus.jsp" %>
    <%@ include file="/res/public/easyui_lib.jsp" %>
    <%@ include file="/res/public/angularjs.jsp" %>
    <%@ include file="/res/public/msg.jsp" %>
    <%@ include file="/res/public/common.jsp" %>
    <%@ include file="/thirdparty/ke/kindeditor.jsp" %>

    <script type="text/javascript">

        var myform = angular.module('mybody', ['ui.bootstrap']).controller('bodyCtrl', function ($scope, $compile, $http) {
            $scope.model = {};
            var url = "${root}/manage/myTask/getMyTaskInfo/" + $("#plan_id").val();
            $http.get(url).success(function (response) {
                createRichText();
                $scope.model.plan = response.plan;
                if (response.plan.plan_desc!=null){
                    kindEditer2.html(response.plan.plan_desc);
                }
                getParticipants();
                $scope.model.complete = getTaskDetail();
                controlButs($scope, $compile);
            });

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

        function getTaskDetail()
        {
            var url = "${root}/manage/task/getTaskInfoById/"+ $("#task_id").val();
            url=encodeURI(encodeURI(url));
            var complete = "";
            $.ajax({
                       url: url,
                       type : 'post',
                       async : false,
                       success: function(result) {
                           $("#task_name").val(result.task_name),
                           $("#task_type").val(typeCodeToName(result.task_type_code)),
                           complete = result.complete,
                           $("#project_name").val(result.sup_project_name),
                           $("#module_name").val(result.sup_module_name),
                           $("#task_creator").val(result.creator),
                           $("#task_create_time").val(result.create_time),
                           $(".progress-bar").css("width",result.complete),
                           kindEditer1.html(result.task_desc)
                       }
                   });
            if($("#task_type").val()!="项目任务"){
                $("#module_name_head").hide();
                $("#project_name_head").hide()
            }else{
                $("#module_name_head").show();
                $("#project_name_head").show()
            }
            return complete
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

        function createRichText() {
            var elements = $('.richtext');
            var eObj1 = elements[0];
            var eObj2 = elements[1];
            kindEditer1 = createY(eObj1.id);
            kindEditer2 = createY(eObj2.id);
        }

        /**
         * 关闭
         * */
        function controlButs($scope, $compile) {
            var html="";
            html += "<a class='btn btn-danger btn-sm' href='###' ng-click='closeForm()'><i class='fa fa-remove'></i>&nbsp;&nbsp;关闭</a>";
            var template = angular.element(html);
            var element = $compile(template)($scope);
            angular.element("#operator").empty();
            angular.element("#operator").append(element);
        }

        function getParticipants() {
            var url = "${root}/manage/myTask/getParticipantsListById/" + $("#plan_id").val();
            $.ajax({
                type: 'post',
                cache: false,
                url: url,
                async: false,
                success: function (response) {
                    var participants=response.participantsList;
                    var imageUrl=$("#imageUrl").val();
                    initParticipants(participants,imageUrl);
                }
            });
        }

        function initParticipants(browse,imageUrl) {
            var html = "";
            if (browse.length > 0) {
                //页面先规定一页显示3个，后面有时间，再根据宽度写成动态的
                var length = Math.ceil((browse.length) / 3);

                for (var i = 1; i <= length; i++) {
                    if (i == 1) {
                        html += "<li class='cur'>" + i + "</li>"
                    } else {
                        html += "<li>" + i + "</li>"
                    }
                    $("#cyry").html(html);
                }
                html = "";
                var value = -2;
                for (var l = 0; l < length; l++) {
                    if (l != 0) {
                        html += "<span style='display:none' class='browse'>";
                    } else {
                        html += "<span class='browse'>";
                    }
                    value += 2;
                    for (var k = value; k < browse.length; k++) {
                        if (browse[k].photo != null && browse[k].photo != "null" && browse[k].photo != "undefined" && browse[k].photo != "") {
                            html += '<div class="col-sm-4" style="text-align:center;"><div class="form group"><p style="text-align:center"><img src="' + imageUrl + browse[k].photo + '" style="width:50px;height:50px;"/>'
                                + '</p><p style="text-align:center;line-height:0.8">' + browse[k].employee_id + '</p><p style="text-align:center">' + browse[k].name + '</p><p style="text-align:center;line-height:0.8">' + browse[k].mobilephone_number + '</p></div></div>';
                        } else {
                            html += '<div class="col-sm-4" style="text-align:center;"><div class="form group"><p style="text-align:center"><img src="/res/public/img/icons/tx.png" style="width:50px;height:50px;"/>'
                                + '</p><p style="text-align:center;line-height:0.8">' + browse[k].employee_id + '</p><p style="text-align:center">' + browse[k].name + '</p><p style="text-align:center;line-height:0.8">' + browse[k].mobilephone_number + '</p></div></div>';
                        }

                        if (k >= value + 2) {
                            break;
                        }

                    }
                    html += " </span>";
                }
                $("#participants").html(html);
                var curr = 0;
                if ($(".scroll>ul.tip>li")) {
                    $(".scroll>ul.tip>li").each(function (i) {
                        $(this).click(function () {
                            curr = i;
                            $(".scroll>div.imgs>span.browse").eq(i).fadeIn("slow").siblings("span").hide();
                            $(this).siblings("li").removeClass("cur").end().addClass("cur");
                            return false;
                        });
                    });
                }
            } else {
                html = "<div class='no_result'>暂时没有参与人员</div>";
                $("#participants").html(html);
            }
        }

        function typeCodeToName(value){
            var taskName;
            switch (value) {
                case "LSRW":
                    taskName = "临时任务";
                    break;
                case "XXRW":
                    taskName = "学习任务";
                    break;
                case "XMRW":
                    taskName = "项目任务";
                    break;
                case "PXRW":
                    taskName = "培训任务";
                    break;
            }
            return taskName
        }

    </script>
</head>

<body ng-app="mybody" ng-controller="bodyCtrl">
<input type="hidden" id="plan_id" value="${plan_id}"/>
<input type="hidden" id="task_id" value="${task_id}"/>
<input type="hidden" id="UserId" value="${UserId}"/>
<input type="hidden" id="imageUrl" value="${imageUrl}"/>
<form collapse="isCollapsed" class="form-horizontal" role="form" id="myform" name="myform" novalidate>
    <div class="row">
        <div class="col-sm-12">
            <div class="ibox">
                <a class="collapse-link">
                    <div class="ibox-title">
                        <h5>任务基本信息</h5>
                        <div class="ibox-tools">
                            <i class="fa fa-chevron-up"></i>
                        </div>
                    </div>
                </a>
                <div class="ibox-content">
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">任务名称：</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="task_name" name="plan_name" readonly/>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">任务类型：</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="task_type" name="task_type" readonly/>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class=" form-group">
                            <label class="col-sm-4 control-label">任务完成情况：</label>
                            <div class="col-sm-6">
                                <div class="progress progress-striped active m-b-sm" style="margin-bottom:0px;height:28px">
                                    <div style="width: 0%;" class="progress-bar"></div>
                                </div>
                            </div>
                            <div class="col-sm-2">
                                {{model.complete}}
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4" id="project_name_head">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">项目名称：</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="project_name" name="project_name" readonly/>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4" id="module_name_head">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">模块名称：</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="module_name" name="module_name" readonly/>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">创建人：</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="task_creator" name="task_creator" readonly/>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">创建时间：</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="task_create_time" name="task_create_time" readonly/>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">&nbsp;</label>
                            <div class="col-sm-6">
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-8">
                        <div class="form-group">
                            <label class="col-sm-2 control-label">任务描述：</label>
                            <div class="col-sm-9">
                                <textarea type="text" class="form-control rdlActive richtext" id="task_desc" name="task_desc" required readonly></textarea>
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
                <a class="collapse-link">
                    <div class="ibox-title">
                        <h5>任务计划基本信息</h5>
                        <div class="ibox-tools">
                            <i class="fa fa-chevron-up"></i>
                        </div>
                    </div>
                </a>
                <div class="ibox-content">
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">任务计划名称：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.plan.plan_name" type="text" class="form-control" id="plan_name" name="plan_name" readonly/>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">计划完成情况：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.plan.complete" type="text" class="form-control" id="complete" name="complete" readonly/>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">开始时间：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.plan.start_date" type="text" class="form-control" id="start_date" name="start_date" readonly/>
                            </div>
                            <div class="col-sm-2">
                                <span></span>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">结束时间：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.plan.end_date" type="text" class="form-control"
                                       id="end_date" name="end_date" readonly/>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">实际开始时间：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.plan.actual_start_time" type="text" class="form-control"
                                       id="actual_start_time" name="actual_start_time" readonly/>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">实际结束时间：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.plan.actual_end_time" type="text" class="form-control" id="actual_end_time" name="actual_end_time" readonly/>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-8">
                        <div class="form-group">
                            <label class="col-sm-2 control-label">任务计划描述：</label>
                            <div class="col-sm-9">
                                <textarea ng-model="model.plan.plan_desc" type="text" class="form-control rdlActive richtext" id="plan_desc" name="plan_desc" readonly></textarea>
                            </div>
                        </div>
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
