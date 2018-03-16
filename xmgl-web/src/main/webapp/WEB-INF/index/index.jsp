<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>全高项目管理系统</title>
    <meta content="width=device-width, initial-scale=1.0" name="viewport"/>
    <%@ include file="/res/public/hplus.jsp" %>
    <%@ include file="/res/public/easyui_lib.jsp" %>
    <%@ include file="/res/public/angularjs.jsp" %>
    <%@ include file="/res/public/msg.jsp" %>
    <%@ include file="/res/public/common.jsp" %>
    <script type="text/javascript">
        $(document).ready(function () {
            initUncompletePlan();
            getProjectAndProgress();
            getLoginRecordInfo();
        });

        function init(type) {
            var url = "";
            if (type == "MR") {
                url = "/manage/dayLog/dayLogManage?_curModuleCode=MY_MRJH";
                parent.addTab("我的每日计划", url);
            } else if (type == "MZ") {
                url = "/manage/weekLog/weekLogQueryIndex?_curModuleCode=MY_MZJH";
                parent.addTab("我的每周计划", url);
            } else if (type == "MY") {
                url = "/manage/monthLog/monthLogList?_curModuleCode=MY_MYJH";
                parent.addTab("我的每月计划", url);
            } else if (type == "XM") {
                url = "/manage/project/initProjectList?_curModuleCode=XMGL";
                parent.addTab("项目管理", url);
            }

        }
        function initMyTaskPlan() {
            var url = "";
            url = "/manage/myTask/initMyTaskList?_curModuleCode=MY_RWGL";
            parent.addTab("我的任务计划管理", url);
        }
        function initUncompletePlan() {
            var html = "";
            var url = "/manage/myTask/getUnCompletePlan?_curModuleCode=MY_RWGL";
            $.ajax({
                type: 'post',
                cache: false,
                url: url,
                async: false,
                success: function (response) {
                    var plan = response.plan;
                    var plan_id = "";
                    var task_id = "";
                    if(plan.length==0){
                        html += '<p style="color:#000;font-size:20px;font-family:KaiTi">暂无待完成任务计划</p>';
                    }
                    for (var i = 0; i < plan.length; i++) {
                        plan_id = plan[i].id;
                        task_id = plan[i].task_id;
                        //html += '<div class="col-sm-12"><div class="col-sm-3" style="text-align:center;"><a href="###" style="color:#00F;line-height:15px;font-size:23px;font-family:KaiTi" onclick="initmyTaskInfo(' + plan_id + ','+task_id+')">'+plan[i].plan_name+'</a></div><div class="col-sm-9" style="text-align:center;"><a href="###" style="line-height:15px;color:#000;font-size:23px;font-family:KaiTi" >周期：&nbsp;&nbsp;'+plan[i].start_date + '-'+ plan[i].end_date+'</a></div></div><div>&nbsp;</div>';
                        html += '<div class="col-sm-12"><div class="col-sm-3" style="text-align:center;"><p><a href="###" style="color:#00F;font-size:18px;font-family:KaiTi" onclick="initmyTaskInfo(' + plan_id + ',' + task_id + ')">' + plan[i].plan_name + '</a></p></div><div class="col-sm-9" style="text-align:center;"><p style="line-height:15px;color:#000;font-size:18px;font-family:KaiTi" >周期：&nbsp;&nbsp;' + plan[i].start_date + '-' + plan[i].end_date + '</p></div></div><div>&nbsp;</div>';

                    }
                    $("#uncompletePlan").html(html);

                },

            });

        }
        function initmyTaskInfo(plan_id, task_id) {
            url = "/manage/myTask/initMyTaskInfo/" + plan_id + "/" + task_id;
            parent.addTab("我的任务详情", url);
        }

        function getProjectAndProgress() {
            var url = "${root}/manage/project/queryProjectListAndParticipantByUser?userId=" + "${userID}";
            url = encodeURI(encodeURI(url));
            $.ajax({
                url: url,
                type: 'get',
                cache: false,
                success: function (response) {
                    projectAndProgress(response);
                }
            });
        }

        function projectAndProgress(data) {
            var html = "";
            for (var x in data) {
                var project = data[x];
                if (!JSON.stringify(project)) {
                    continue;
                }
                var complete_status;
                if (project.complete_status) {
                    complete_status = project.complete_status
                } else {
                    complete_status = 0
                }
                html += '<div class="col-sm-12" style="padding: 20px 0px 0px 0px;height: 80px">' +
                    '<div class="col-sm-3" style="color: red">' + project.project_name + '</div>' +
                    '<div class="col-sm-8">' + '<div class="progress progress-striped active m-b-sm" style="margin-bottom:0px;height:23px">' +
                    '<div style="width: ' + project.complete_status + '%;" class="progress-bar"></div></div></div>' +
                    '<div class="col-sm-1">' + project.complete_status + '%</div>' +
                    '<div class="col-sm-3"></div><div class="col-sm-9" style="padding-top: 5px">';
                if (project.children) {
                    for (var y in project.children) {
                        var participant = project.children[y];
                        if (participant.participant_photo === undefined) {
                            continue;
                        }
                        if (participant.participant_photo) {
                            html += '<img alt="image" style="width: 40px;height: 40px; margin-right: 3px" class="img-circle" src="${imageUrl}/' + participant.participant_photo + '">'
                        } else {
                            html += '<img alt="image" style="width: 40px;height: 40px; margin-right: 3px" class="img-circle" src="/res/public/img/icons/tx.png">'
                        }
                    }
                } else {
                    html += '<span>无参与人员</span>';
                }
                html += '</div></div>';
                $("#rate_of_progress").html(html)
            }
        }
        function getLoginRecordInfo() {
            var html = "";
            var url = "/manage/loginRecord/getLoginRecordInfo";
            $.ajax({
                type: 'post',
                cache: false,
                url: url,
                async: false,
                success: function (response) {
                    var loginRecordList = response.loginRecordList;
                    var count=loginRecordList.length;
                    if(count==1){
                        html += '<p>这是您第'+count+'次登录，详情请查看<a href="###" style="color:#00F;" onclick="initLoginRecord()">日志</a>，如果不是您本人登录，请及时<a href="###" style="color:#00F;" onclick="initChangePassword()">修改密码</a></p>';
                    }else{
                        html += '<p>这是您第'+count+'次登录，上次登录日期'+loginRecordList[1].login_time+'，详情请查看<a href="###" style="color:#00F;" onclick="initLoginRecord()">日志</a>，如果不是您本人登录，请及时<a href="###" style="color:#00F;" onclick="initChangePassword()">修改密码</a></p>';
                    }
                    $("#loginRecord").html(html);
                },
            });

        }
        function initLoginRecord() {
            var url = "";
            url = "/manage/user/personalCenter?displayPage=loginInfo";
            parent.addTab("登录信息", url);
        }
        function initChangePassword() {
            var url = "";
            url = "/manage/user/personalCenter?displayPage=pwd";
            parent.addTab("修改密码", url);
        }

    </script>
</head>
<body class="gray-bg">
<input type="hidden" id="roleCode" value="${roleCode}"/>
<div class="wrapper wrapper-content animated fadeInRight">
    <div class="row">
        <div class="col-sm-12">
            <div class="ibox-content m-b-sm border-bottom">
                <div class="p-xs">
                    <div class="pull-left m-r-md">
                    </div>
                    <h2>欢迎使用 全高项目管理系统</h2>
                    <span>你可以方便的进行项目管理。</span>
                    <div id="loginRecord"></div>
                </div>
            </div>
        </div>
        <div class="col-sm-12">
            <div class="wrapper wrapper-content">
                <div class="row animated fadeInRight">
                    <div class="col-sm-6">
                        <div class="ibox float-e-margins">
                            <div class="" id="ibox-content">
                                <div id="vertical-timeline" class="vertical-container light-timeline">
                                    <div class="vertical-timeline-block">
                                        <div class="vertical-timeline-icon red-bg">
                                            <i class="fa fa-file-text"></i>
                                        </div>
                                        <div class="col-sm-12">
                                            <div class="vertical-timeline-content">
                                                <h2>项目完成进度</h2>
                                                <hr/>
                                                <div id="rate_of_progress"></div>
                                                <a href="javascript:void(0);" onclick="init('XM')" class="btn btn-sm btn-danger">查看所有</a>
                                            </div>
                                        </div>
                                        <div>&nbsp;</div>
                                        <div class="col-sm-4">
                                            <div class="vertical-timeline-content">
                                                <h2>我的每日计划</h2>
                                                <hr/>
                                                <div class="row">
                                                </div>
                                                <a href="javascript:void(0);" onclick="init('MR')" class="btn btn-sm btn-danger">查看所有</a>
                                            </div>
                                        </div>
                                        <div class="col-sm-4">
                                            <div class="vertical-timeline-content">
                                                <h2>我的每周计划</h2>
                                                <hr/>
                                                <div class="row">
                                                </div>
                                                <a href="javascript:void(0);" onclick="init('MZ')" class="btn btn-sm btn-danger">查看所有</a>
                                            </div>
                                        </div>
                                        <div class="col-sm-4">
                                            <div class="vertical-timeline-content">
                                                <h2>我的每月计划</h2>
                                                <hr/>
                                                <div class="row">
                                                </div>
                                                <a href="javascript:void(0);" onclick="init('MY')" class="btn btn-sm btn-danger">查看所有</a>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-6">
                        <div class="ibox float-e-margins">
                            <div class="" id="ibox-content">
                                <div id="vertical-timeline" class="vertical-container light-timeline">
                                    <div class="vertical-timeline-block">
                                        <div class="vertical-timeline-icon red-bg">
                                            <i class="fa fa-file-text"></i>
                                        </div>
                                        <div class="col-sm-12">
                                            <div class="vertical-timeline-content">
                                                <h2>待完成任务计划</h2>
                                                <hr/>
                                                <div class="uncompletePlan" id="uncompletePlan">
                                                </div>
                                                <a href="javascript:void(0);" onclick="initMyTaskPlan()" class="btn btn-sm btn-danger">查看所有</a>
                                            </div>
                                        </div>
                                        <div>&nbsp;</div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>

                </div>
            </div>
        </div>

    </div>
</div>
</body>
</html>