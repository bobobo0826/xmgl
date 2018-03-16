<%--
  Created by IntelliJ IDEA.
  User: mjq
  Date: 2017/7/7
  Time: 10:32
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>新增任务明细</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <%@ include file="/res/public/hplus.jsp" %>
    <%@ include file="/res/public/easyui_lib.jsp" %>
    <%@ include file="/res/public/angularjs.jsp" %>
    <%@ include file="/res/public/msg.jsp" %>
    <%@ include file="/res/public/common.jsp" %>
    <%@ include file="/thirdparty/ke/kindeditor.jsp" %>

    <script type="text/javascript">
        $(document).ready(function(){
            createRichText();
            getDic();
            getNotPlanTaskTypeDic();
            if (parent.getStatusName()==="已提交"){
                $("#qd").hide();
            }else{
                $("#qd").show();
            }
            var gridData=parent.getGrid($("#grid_index").val());
            $("#grid_data").val(gridData);
            $("input[value='未完成']").attr('checked','true');
            if($("#grid_data").val()!="") {
                var gridData = JSON.parse($("#grid_data").val());
                if($("#isCopy").val()==="notCopy") {
                    $("#start_time").val(gridData.task_start_time);
                    $("#end_time").val(gridData.task_end_time);
                    $("input[value='"+gridData.complete+"']").attr('checked','true');
                }else{
                    $("input[value='未完成']").attr('checked','true')
                }
                $("input[value='"+gridData.isPlan+"']").attr('checked','true');
                if(gridData.isPlan==="非计划"){
                    notPlanHide();
                    $("#not_plan_task_type").val(gridData.task_type);
                    if($("#not_plan_task_type").val()==="supporting" || $("#not_plan_task_type").val()==="discussion" || $("#not_plan_task_type").val()==="maintaining"){
                        $("#sup_project_head").show();
                        $("#sup_module_head").show();
                        $("#selectProject").show();
                        $("#selectModule").show();
                        document.getElementById("sup_module").setAttribute("required","true");
                    }
                }else{
                    $("#task_type").val(gridData.task_type);
                    projectHide();
                    isPlanHide();
                }
                $("#sup_project").val(gridData.sup_project);
                $("#sup_project_id").val(gridData.sup_project_id);
                $("#sup_module").val(gridData.sup_module);
                $("#sup_module_id").val(gridData.sup_module_id);
                $("#record").val(gridData.record);
                kindEditer1.html(gridData.record);
                $("#incomplete_explain").val(gridData.incomplete_explain);
                kindEditer2.html(gridData.incomplete_explain);
                $("#task_name").val(gridData.task_name);
                $("#mission_name").val(gridData.mission_name);
                $("#plan_name").val(gridData.plan_name);
                $("#period_start").val(gridData.period_start);
                $("#period_end").val(gridData.period_end);
                $("#task_id").val(gridData.task_id);
                $("#plan_id").val(gridData.plan_id);
                $("#plan_actual_start_time").val(gridData.plan_actual_start_time);
                if (gridData.delayReason) {
                    kindEditer3.html(gridData.delayReason);
                    $("#delay_reason_head").show();
                    document.getElementById("delay_reason").setAttribute("required", "true");
                }
            } else{
                $('#task_type').val("RJYF");
            }
        });

        function getDic() {
            var url = "${root}/manage/weekLog/getWeekLogTaskTypeDic";
            url = encodeURI(encodeURI(url));
            $.ajax({
                url: url,
                type: 'post',
                async: false,
                success: function (result) {
                    addSelectOption(result.taskTypeList, "task_type");
                }
            });
        }

        function closeForm() {
            layer.confirm('确定关闭窗口吗?', {
                btn: ['确定', '取消'], //按钮
                shade: false //不显示遮罩
            }, function (index) {
                f_close("newWindow");
                //parent.closeCurTab();
                layer.close(index);
            }, function (index) {
                layer.close(index);
            });
        }

        //对有required=required属性的表单元素，进行必填校验
        function validateForm() {
            var es = $("#myform *[required='true']");
            if (es.length > 0) {
                for (var i = 0; i < es.length; i++) {
                    var e = es[i];
                    if ($.trim($(e).val()) == "") {
                        if(($(e).attr("name")) == "richtext"){
                            layer.tips('该字段必填', '#' + $(e).attr("id")+'_div');
                        }else{
                            layer.tips('该字段必填', '#' + $(e).attr("id"));
                        }
                        $("html,body").animate({scrollTop: $("#" + $(e).attr("id")).offset().top - $("html,body").offset().top + $("html,body").scrollTop()}, 1000);
                        return false
                    }
                }
            }
            return true;
        }

        function confirm() {
            if (!validateForm()) {
                return;
            }
            var object = new Object();
            object.start_time=$("#start_time").val();
            object.end_time=$("#end_time").val();
            object.isPlan=$("input[name='plan']:checked").val();
            if($("input[name='plan']:checked").val()=="计划"){
                object.task_type=$("#task_type").val();
            }else{
                object.task_type=$("#not_plan_task_type").val();
            }
            object.sup_project=$("#sup_project").val();
            object.sup_module=$("#sup_module").val();
            object.complete=$("input[name='complete']:checked").val();//完成情况
            object.record=$("#record").val();
            object.incomplete_explain=$("#incomplete_explain").val();
            object.sup_project_id=$("#sup_project_id").val();
            object.sup_module_id=$("#sup_module_id").val();
            object.task_name=$("#task_name").val();
            object.mission_name = $("#mission_name").val();
            object.plan_name = $("#plan_name").val();
            object.period_start = $("#period_start").val();
            object.period_end = $("#period_end").val();
            object.plan_id = $("#plan_id").val();
            object.task_id = $("#task_id").val();
            object.plan_actual_start_time = $("#plan_actual_start_time").val();
            if ($("#incomplete_explain").val() !== null && $("#incomplete_explain").val() !== "" && $("#incomplete_explain").val() !== "null") {
                object.incomplete_explain = $("#incomplete_explain").val();
            } else {
                object.incomplete_explain = " ";
            }
            object.delayReason = $("#delay_reason").val();
            layer.confirm('确定保存吗?', {
                btn: ['确定', '取消'], //按钮
                shade: false //不显示遮罩
            }, function (index) {
                layer.close(index);
                if($("#isCopy").val()=="copy") {
                    parent.updateGrid(object, -1);
                }else{
                    parent.updateGrid(object, $("#grid_index").val());
                }
                f_close("newWindow");
            }, function (index) {
                layer.close(index);
            })
        }

        function informationRemove(){
            $("#plan_id").val("");
            $("#task_id").val("");
            $("#sup_project_id").val("");
            $("#sup_module_id").val("");
            $("#sup_module").val("");
            $("#sup_project").val("");
            $("#period_start").val("");
            $("#period_end").val("");
            $("#plan_name").val("");
            $("#mission_name").val("");
            projectHide()
        }

        function projectHide()
        {
            if($('#task_type').val()!="XMRW"){
                $('#sup_project_head').hide();
                $('#sup_module_head').hide();
            } else{
                $('#sup_project_head').show();
                $('#sup_module_head').show();
            }
        }

        function createRichText() {
            var elements = $(".richtext");
            var eObj1 = elements[0];
            var eObj2 = elements[1];
            var eObj3 = elements[2];
            kindEditer1 = createY(eObj1.id);
            kindEditer2 = createY(eObj2.id);
            kindEditer3 = createY(eObj3.id);

        }

        function selectPlan()
        {
            var url="${root}/manage/myTask/selectMyPlan/" + $("#task_type").val();
            var width="80%";
            var height="80%";
            f_open("newWindow","选择计划",width,height,url,true);
        }

        function selectMyPlan(object)
        {
            if(!$('#task_type').val()){
                layer.msg("请先选择记录类别")
            }
            $('#plan_name').val(object.plan_name);
            $('#period_start').val(object.plan_start_time);
            $('#period_end').val(object.plan_end_time);
            $('#task_id').val(object.task_id);
            $('#plan_actual_start_time').val(object.actual_plan_start_time);
            $('#plan_id').val(object.plan_id);
            $('#mission_name').val(object.task_name);
            $('#sup_project').val(object.sup_project_name);
            $('#sup_module').val(object.sup_module_name);
            $('#task_type').val(object.task_type);

            projectHide();
            delayReason();
        }

        function isPlanHide()
        {
            document.getElementById("plan_name").setAttribute("required","true");
            document.getElementById("task_type").setAttribute("required","true");
            document.getElementById("not_plan_task_type").removeAttribute("required");
            document.getElementById("sup_module").removeAttribute("required");
            informationRemove();
            $("#mission_name_head").show();
            $("#plan_name_head").show();
            $("#period_head").show();
            $("#task_type").show();
            $("#sup_project_head").show();
            $("#sup_module_head").show();
            $("#not_plan_task_type").hide();
            $("#selectProject").hide();
            $("#selectModule").hide();
            $("#task_type").val("RJYF")
        }

        function notPlanHide()
        {
            document.getElementById("plan_name").removeAttribute("required");
            document.getElementById("task_type").removeAttribute("required");
            document.getElementById("not_plan_task_type").setAttribute("required","true");
            document.getElementById("sup_module").removeAttribute("required");
            informationRemove();
            $("#not_plan_task_type").val("");
            $("#sup_module").val("");
            $("#sup_project").val("");
            $("#mission_name_head").hide();
            $("#plan_name_head").hide();
            $("#period_head").hide();
            $("#task_type").hide();
            $("#sup_project_head").hide();
            $("#sup_module_head").hide();
            $("#not_plan_task_type").show();
        }

        function selectModuleAndProject()
        {
            informationRemove();
            if($("#not_plan_task_type").val()==="supporting" || $("#not_plan_task_type").val()==="discussion"){
                $("#sup_project_head").show();
                $("#sup_module_head").show();
                $("#selectProject").show();
                $("#selectModule").show();
                document.getElementById("sup_module").setAttribute("required","true");
            }else{
                $("#sup_project_head").hide();
                $("#sup_module_head").hide();
                $("#selectProject").hide();
                $("#selectModule").hide();
                document.getElementById("sup_module").removeAttribute("required");
            }
        }

        function getNotPlanTaskTypeDic()
        {
            var url = "${root}/manage/dayLog/getNotPlanTaskTypeDic";
            url=encodeURI(encodeURI(url));
            $.ajax({
                       url: url,
                       type : 'post',
                       async: false,
                       success: function(result) {
                           addSelectOption(result.taskTypeList,"not_plan_task_type");
                       }
                   });
        }
        function selectModule(){
            if ($("#sup_project").val()===""){
                layer.msg("请先选择项目");
                return;
            }
            var url = '${root}/manage/projectModule/choseProjModule?_chkStyle=radio&projectId=' + $('#sup_project_id').val();
            windowName="moduleWindow";
            windowTitle="选择模块";
            var width = "20%";
            var height = "80%";
            f_open(windowName, windowTitle, width,height, url, true);
        }

        function selectProject(){
            $("#sup_module_name").val("");
            $("#sup_module_id").val(null);
            var url="${root}/manage/project/initSelectProjectList";
            var width="80%";
            var height="80%";
            f_open("newWindow","选择项目",width,height,url,true);
        }

        function setModule(moduleList){
            if(moduleList==null || moduleList==""){
                return;
            }
            $("#sup_module").val(moduleList[0].moduleName);
            $("#sup_module_id").val(moduleList[0].id);
        }

        function setProjectInfo(object){
            $("#sup_project").val(object.project_name);
            $("#sup_project_id").val(object.project_id);
        }
        function delayReason() {
            if ($("#period_end").val() && $("#end_time").val() && $("input[name='complete']:checked").val() === "已完成") {
                if (($("#end_time").val()) > $("#period_end").val()) {
                    $("#delay_reason_head").show();
                    document.getElementById("delay_reason").setAttribute("required", "true");
                } else {
                    $("#delay_reason_head").hide();
                    document.getElementById("delay_reason").removeAttribute("required");
                }
            } else {
                $("#delay_reason_head").hide();
                document.getElementById("delay_reason").removeAttribute("required");
            }
        }

    </script>
</head>

<body>
<input type="hidden" id="task_id" />
<input type="hidden" id="plan_actual_start_time" />
<input type="hidden" id="plan_id" />
<input type="hidden" id="isCopy" value="${isCopy}" />
<input type="hidden" id="grid_index" value="${gridIndex}"/>
<input type="hidden" id="grid_data"/>
<input type="hidden" id="sup_project_id"/>
<input type="hidden" id="sup_module_id"/>
<form collapse="isCollapsed" class="form-horizontal" role="form" id="myform" name="myform" novalidate>
    <div class="row">
        <div class="col-sm-12">
            <div class="ibox">
                <div class="ibox-content">
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">起止时间：</label>
                            <div data-autoclose="true">
                                <div class="col-sm-3">
                                    <input type="text" class="form-control" id="start_time" name="start_time" readonly="true" required='true' onclick="laydate()"onchange="delayReason()"/>
                                </div>
                            </div>
                            <div data-autoclose="true">
                                <div class="col-sm-3">
                                    <input type="text" class="form-control" id="end_time" name="end_time" readonly="true" required='true' onclick="laydate()" onchange="delayReason()"/>
                                </div>
                            </div>
                            <div class="col-sm-2">
                                <span class="text-danger">*</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">日志记录名称：</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="task_name" name="task_name" required />
                            </div>
                            <div class="col-sm-2">
                                <span class="text-danger">*</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class=" form-group">
                            <label class="col-sm-4 control-label">是否计划：</label>
                            <div class="col-sm-8">
                                <div class="radio radio-success radio-inline">
                                    <input type="radio" id="isPlan" value="计划" name="plan" checked="" onchange="isPlanHide()" />
                                    <label for="isPlan"> 计划 </label>
                                </div>
                                <div class="radio radio-warning radio-inline">
                                    <input type="radio" id="notPlan" value="非计划" name="plan" onchange="notPlanHide()" />
                                    <label for="notPlan"> 非计划</label>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4" id="task_type_head">
                        <div  class="form-group">
                            <label class="col-sm-4 control-label">记录类别：</label>
                            <div class="col-sm-6">
                                <select onchange="informationRemove()" id="task_type" class="form-control" required="true">
                                </select>
                                <select onchange="selectModuleAndProject()" id="not_plan_task_type" class="form-control" style="display: none">
                                </select>
                            </div>
                            <div class="col-sm-2">
                                <span class="text-danger">*</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4" id="mission_name_head">
                        <div  class=" form-group">
                            <label class="col-sm-4 control-label">任务名称：</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="mission_name" name="mission_name" />
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4" id="plan_name_head">
                        <div  class=" form-group">
                            <label class="col-sm-4 control-label">计划名称：</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="plan_name" name="plan_name" readonly/>
                            </div>
                            <div class="col-sm-2">
                                <span class="text-danger">*</span>
                                <a class="btn btn-warning btn-sm"  href="javascript:selectPlan();">
                                    <i class='fa fa-search'></i>
                                </a>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4" id="period_head">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">任务计划周期：</label>
                            <div data-autoclose="true">
                                <div class="col-sm-3">
                                    <input type="text" class="form-control" id="period_start" name="period_start" readonly onclick="laydate()"/>
                                </div>
                            </div>
                            <div data-autoclose="true">
                                <div class="col-sm-3">
                                    <input type="text" class="form-control" id="period_end" name="period_end" readonly onclick="laydate()"/>
                                </div>
                            </div>
                            <div class="col-sm-2">
                                <span class="text-danger">*</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4" id="sup_project_head" style="display: none">
                        <div  class=" form-group">
                            <label class="col-sm-4 control-label">所属项目：</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="sup_project" name="sup_project" readonly/>
                            </div>
                            <div class="col-sm-2" id="selectProject" style="display: none">
                                <span class="text-danger">*</span>
                                <a class="btn btn-warning btn-sm"  href="javascript:selectProject();">
                                    <i class='fa fa-search'></i>
                                </a>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4" id="sup_module_head" style="display: none">
                        <div  class=" form-group">
                            <label class="col-sm-4 control-label">所属模块：</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control" id="sup_module" name="sup_module" readonly />
                            </div>
                            <div class="col-sm-2" id="selectModule" style="display: none">
                                <span class="text-danger">*</span>
                                <a class="btn btn-warning btn-sm"  href="javascript:selectModule();">
                                    <i class='fa fa-search'></i>
                                </a>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class=" form-group">
                            <label class="col-sm-4 control-label">计划完成情况：</label>
                            <div class="col-sm-8">
                                <div class="radio radio-info radio-inline">
                                    <input type="radio" id="complete" value="已完成" name="complete" checked="" onchange="delayReason()">
                                    <label for="complete"> 已完成 </label>
                                </div>
                                <div class="radio radio-danger radio-inline">
                                    <input type="radio" id="incomplete" value="未完成" name="complete" onchange="delayReason()">
                                    <label for="incomplete"> 未完成</label>
                                </div>
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
                    <div class="col-sm-8">
                        <div class="form-group">
                            <label class="col-sm-2 control-label">工作记录：</label>
                            <div class="col-sm-9"  id = "record_div">
                                    <textarea type="text" class="richtext"
                                              id="record" name="richtext" rows="6" required='true'></textarea>
                            </div>
                            <div class="col-sm-1">
                                <span class="text-danger">*</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-8">
                        <div class="form-group">
                            <label class="col-sm-2 control-label">未完成情况描述：</label>
                            <div class="col-sm-9">
                                    <textarea type="text" class="richtext" id="incomplete_explain" name="incomplete_explain" rows="6"></textarea>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-8" id="delay_reason_head" style="display: none">
                        <div class="form-group">
                            <label class="col-sm-2 control-label">延期原因：</label>
                            <div class="col-sm-9" id="delay_reason_div">
                                <textarea type="text" class="form-control richtext" id="delay_reason" name="richtext" rows="6"></textarea>
                            </div>
                            <div class="col-sm-1">
                                <span class="text-danger">*</span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div style="clear: both;height: 35px"></div>
    </div>
</form>
<!-- 隐藏div防止底部按钮区域覆盖表单区域 -->
<div style="margin-bottom:50px;"></div>

<div class="main_btnarea">
    <div class="btn_area_setc btn_area_bg" id="operator">
        <a id="qd" style="display:none" class='btn btn-primary btn-sm' href='###' onclick='confirm()'><i
                class='fa fa-check'></i>&nbsp;&nbsp;确定</a>
        <a class='btn btn-danger btn-sm' href='###' onclick='closeForm()'><i class='fa fa-remove'></i>&nbsp;&nbsp;关闭</a>
    </div>
</div>
</body>
</html>

