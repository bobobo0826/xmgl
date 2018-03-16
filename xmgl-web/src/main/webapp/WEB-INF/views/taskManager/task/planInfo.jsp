<%--
  Created by IntelliJ IDEA.
  User: wjy
  Date: 2017/7/4
  Time: 10:09
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.text.SimpleDateFormat,java.util.Date"%>
<!doctype html>
<html>
<head>
    <title>计划详情</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <!--hplus-->
    <%@ include file="/thirdparty/ke/kindeditor.jsp"%>
    <%@ include file="/res/public/hplus.jsp"%>
    <%@ include file="/res/public/easyui_lib.jsp"%>
    <%@ include file="/res/public/angularjs.jsp"%>
    <%@ include file="/res/public/msg.jsp"%>
    <%@ include file="/res/public/common.jsp"%>


    <script type="text/javascript">
        $(document).ready(function(){
            initEmployeeList();
            createRichText();
            setPlanReadOnly();
            var gridData=parent.getGrid($("#grid_index").val());
            /*            console.log("gridData after load!!!\n"+JSON.stringify(gridData));*/
            $("#grid_data").val(gridData);
            if($("#grid_data").val()) {
                var gridData = JSON.parse($("#grid_data").val());
                if (typeof(gridData.participants) !== 'undefined' && gridData.participants !== null && $("#isCopy").val()!=="copy") {
                    $('#employee').datagrid('loadData', JSON.parse(gridData.participants));
                }
                $("#is_cancel").val(gridData.is_cancel);
                $("#period_start").val(gridData.start_date);
                $("#plan_name").val(gridData.plan_name);
                $("#plan_desc").val(gridData.plan_desc);
                if (gridData.plan_desc){
                    kindEditer1.html(gridData.plan_desc);
                }
                if (gridData.complete_type){
                    $("#complete_type").val(gridData.complete_type);
                }else{
                    $("#complete_type").val("WKS");//新建未开始
                }
                $("#period_end").val(gridData.end_date);
                $("input[name='complete'][value='"+gridData.complete+"']").attr("checked",'true');
                $("#create_time").val(gridData.create_time);
                $("#modify_time").val(gridData.modify_time);

            }else{
                $("#create_time").val(getNowFormatTime());
            }
            if($("#grid_index").val()==-1){
                $("#is_cancel").val("未注销");
                //add default para here
            }
        });
        function closeForm(){
            layer.confirm('确定关闭窗口吗?', {
                btn: ['确定','取消'], //按钮
                shade: false //不显示遮罩
            }, function(index){
                f_close("newWindow");
                layer.close(index);
            }, function(index){
                layer.close(index);
            });
        }
        function initEmployeeList(){
            $("#employee").datagrid({
                        sortable: true,
                        remoteSort: false,
                        singleSelect: true,
                        pagination: false,
                        height: 'auto',
                        width: $(window).width() - 100,
                        striped: true,
                        nowrap: false,
                        showFooter: true,
                        columns: [[
                            {
                                field: "act",
                                title: "操作",
                                resizable: true,
                                width: 120,
                                headalign: "center",
                                align: "center",
                                formatter: editEmployee
                            },
                            {
                                field: "name",
                                title: "员工姓名",
                                resizable: true,
                                width: 180,
                                headalign: "center",
                                align: "center",
                                sortable: true
                            },
                            {
                                field: "mobilephone_number",
                                title: "员工手机号",
                                resizable: true,
                                width: 200,
                                headalign: "center",
                                align: "center",
                                sortable: true
                            }
                        ]]

                    });
        }
        function validateForm() {
            var es = $("#myform *[required='true']");
            if (es.length > 0) {
                for (var i = 0; i < es.length; i++) {
                    var e = es[i];
                    if ($.trim($(e).val()) == "") {
                        layer.tips('该字段必填', '#' + $(e).attr("id"));
                        $("html,body").animate({scrollTop:$("#"+$(e).attr("id")).offset().top- $("html,body").offset().top +  $("html,body").scrollTop()},1000);
                        return false
                    }
                }
            }
            return true;
        }
        function validateTime(){
            if ($("#period_start").val()>=$("#period_end").val()){
                layer.msg('时间选择不对！');
                return false;
            }
            else {
                return true;
            }
        }
        function confirm(){
            if (!validateForm()) {
                return;
            }
            if (!validateTime()){
                return;
            }
            var object=new Object();
            object.start_date=$("#period_start").val();
            object.end_date=$("#period_end").val();
            object.plan_name=$("#plan_name").val();
            object.plan_desc=$("#plan_desc").val();
            object.complete=$("input[name='complete']:checked").val();
            object.is_cancel=$("#is_cancel").val();
            var content = $('#employee').datagrid('getData').rows;
            if (content!=null){
                var contents = new Array();
                if (content != "" && content != null) {
                    for (var i = 0; i < content.length; i++) {
                        contents.push(content[i]);
                    }
                    object.participants = JSON.stringify(contents);
                }
            }
            object.complete_type = $("#complete_type").val();
            object.create_time=$("#create_time").val();
            /*            console.log("gridData before save!!!\n"+JSON.stringify(object));*/
            var confirmMSG="确定保存吗？";
            layer.confirm(confirmMSG, {
                btn: ['确定','取消'], //按钮
                shade: false //不显示遮罩
            }, function(index) {
                layer.close(index);
                if ($("#grid_index").val()!=-1 && $("#isCopy").val() !="copy" && $("#task_condition").val()=="CG"){
                    $("#modify_time").val(getNowFormatTime());
                    object.modify_time=$("#modify_time").val();
                }
                if ($("#isCopy").val() =="copy"){
                    parent.updateGrid(object, -1);
                }else{
                    parent.updateGrid(object, $("#grid_index").val());
                }
                f_close("newWindow");
            },function(index) {
                layer.close(index);
            })
        }
        function createRichText() {
            var elements = $('.richtext');
            var eObj1 = elements[0];
            kindEditer1 = createY(eObj1.id);
        }
        function editEmployee(value, row, index){
            var html="";
            html += '[<a href="###" onclick="delRowGoods(' + index + ' )" style="color:red;" class="xg">删除</a>]';
            return html;
        }

        function delRowGoods(index){
            var rows=$("#employee").datagrid('getData').rows;
            $("#employee").datagrid('deleteRow', index);
            for(var k=index;k<rows.length;k++){
                $('#employee').datagrid('refreshRow', k);
            }
        }
        function addEmployee(){
            var url;
            var width = '80%';
            var height = '80%';
            if (!$("#idList").val()){
                layer.msg("请先选择任务参与人员！");
                return;
            }
            var rows=$("#employee").datagrid('getData').rows;
            if( rows.length>=1){
                layer.msg("每条计划只能选择一个参与人员！");
                return;
            }
            url = "${root}/manage/employee/selectEmployee?_curModuleCode="+$("#_curModuleCode").val()+"&idList="+$("#idList").val()
                  +"&isSingleSelect=1";
            f_open("newWindow", "添加员工", width, height, url, true);
        }

        function appendRowEmployee() {
            $('#employee').datagrid('appendRow', {

            });
        }
        function setEmployeeInfo(object){

            var rows=$('#employee').datagrid('getRows');
            for (var i =0;i<rows.length;i++){
                if (rows[i].id==object.employee_id){
                    layer.msg("已经选择了该员工！");
                    return;
                }
            }
            appendRowEmployee();
            var grid_index = rows.length - 1;
            $('#employee').datagrid('updateRow', {
                index: grid_index,
                row: {
                    name: object.employee_name,
                    mobilephone_number: object.mobilephone_number,
                    id: object.employee_id,
                    photo: object.photo
                }
            });
        }
        function setPlanReadOnly(){
            if ($("#grid_index").val() && $("#task_condition").val()!="CG" && $("#isCopy").val()=="notCopy"){
                $(".rdlActive").attr("readonly","true");//设置只读
                $(".rdlActive").attr("disabled","disabled");//设置禁用
                $("#addNewEmployee").hide();//隐藏添加员工按钮
                $("#employee").datagrid("hideColumn","act");//隐藏操作列
                kindEditer1.readonly();//设置富文本只读
            }else{
                $(".rdlActive").removeAttr("readonly","true");//取消 只读
                $(".rdlActive").removeAttr("disabled","disabled");//取消 禁用
                $("#addNewEmployee").show();//显示 添加员工按钮
                $("#employee").datagrid("showColumn","act");//显示 操作列
                kindEditer1.readonly(false);//取消 富文本只读
            }
        }

        function chooseTime(code){
            /*            var start_time="";
             var end_time="";*/
            Date.prototype.Format = function (fmt) { //author: meizz
                var o = {
                    "M+": this.getMonth() + 1, //月份
                    "d+": this.getDate(), //日
                    "h+": this.getHours(), //小时
                    "m+": this.getMinutes(), //分
                    "s+": this.getSeconds(), //秒
                    "q+": Math.floor((this.getMonth() + 3) / 3), //季度
                    "S": this.getMilliseconds() //毫秒
                };
                if (/(y+)/.test(fmt)) fmt = fmt.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
                for (var k in o)
                    if (new RegExp("(" + k + ")").test(fmt)) fmt = fmt.replace(RegExp.$1, (RegExp.$1.length == 1) ? (o[k]) : (("00" + o[k]).substr(("" + o[k]).length)));
                return fmt;
            };
            var start_date="";
            var end_date="";
            if ($("#period_start").val()){
                start_date = new Date($("#period_start").val()).Format("yyyy-MM-dd");
                end_date = new Date($("#period_start").val()).Format("yyyy-MM-dd");
            }else{
                start_date = new Date(getNowFormatDate()).Format("yyyy-MM-dd");
                end_date = new Date(getNowFormatDate()).Format("yyyy-MM-dd");
            }
            switch (code){
                case "SW":
                    start_date += " 08:30";
                    end_date += " 12:00";
                    $("#period_start").val(start_date);
                    $("#period_end").val(end_date);
                    break;
                case "XW":
                    start_date += " 13:30";
                    end_date += " 17:30";
                    $("#period_start").val(start_date);
                    $("#period_end").val(end_date);
                    break;
                case "ZT":
                    start_date += " 08:30";
                    end_date += " 17:30";
                    $("#period_start").val(start_date);
                    $("#period_end").val(end_date);
                    break;
                default:

                    break;

            }
        }


    </script>
</head>

<body >
<input  type="hidden" id="grid_index" value="${gridIndex}" />
<input  type="hidden" id="is_cancel" />
<input  type="hidden" id="grid_data" />
<input  type="hidden" id="task_id" value="${taskId}"/>
<input  type="hidden" id="isCopy" value="${isCopy}"/>
<input  type="hidden" id="projectId" value="${projectId}"/>
<input  type="hidden" id="idList" value="${idList}"/><%--任务所选员工的id list--%>
<input  type="hidden" id="_curModuleCode" value="${_curModuleCode}"/>
<input  type="hidden" id="task_condition" value="${taskCondition}"/>
<form collapse="isCollapsed" class="form-horizontal" role="form" id="myform" name="myform" novalidate>
    <div class="row">
        <div class="col-sm-12">
            <div class="ibox">
                <a class="collapse-link">
                    <div class="ibox-title">
                        <h5>计划基本信息</h5>
                        <div class="ibox-tools">
                            <i class="fa fa-chevron-up"></i>
                        </div>
                    </div>
                </a>
                <div class="ibox-content">
                    <div class = "col-md-4">
                        <div class = "col-md-4"></div>
                        <div class = "col-md-6" >
                            <a class='btn btn-success btn-xs' href='###' onclick='chooseTime("SW")'><i class='fa '></i>上午</a>&nbsp;&nbsp;
                            &nbsp;&nbsp;<a class='btn btn-success btn-xs' href='###' onclick='chooseTime("XW")'><i class='fa'></i>下午</a>&nbsp;&nbsp;
                            &nbsp;&nbsp; <a class='btn btn-success btn-xs' href='###' onclick='chooseTime("ZT")'><i class='fa '></i>整天</a>&nbsp;&nbsp;
                        </div>
                    </div>
                </div>
                <div class="ibox-content">
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">开始时间：</label>
                            <div  data-autoclose="true">
                                <div class="col-sm-6">
                                    <input type="text" class="form-control rdlActive" id="period_start" name="period_start" onclick="laydate({format:'YYYY-MM-DD hh:mm',istime:true})"/>
                                </div>
                            </div>
                            <div class="col-sm-2">
                                <span class="text-danger">*</span>
                            </div>
                        </div>
                    </div>
                    <div class="col-sm-4">
                        <div class="form-group">
                            <label class="col-sm-4 control-label">结束时间：</label>
                            <div  data-autoclose="true">
                                <div class="col-sm-6">
                                    <input type="text" class="form-control rdlActive" id="period_end" name="period_end" onclick="laydate({format:'YYYY-MM-DD hh:mm',istime:true})"/>
                                </div>
                            </div>
                            <div class="col-sm-2">
                                <span class="text-danger">*</span>
                            </div>
                        </div>
                    </div>

                    <div class="col-sm-4" >
                        <div  class=" form-group">
                            <label class="col-sm-4 control-label">计划名称：</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control rdlActive" id="plan_name" name="plan_name" required="true"/>
                            </div>
                            <div class="col-sm-2">
                                <span class="text-danger">*</span>
                            </div>
                        </div>
                    </div>
<%--                    <div class="col-sm-4">
                        <div  class="form-group">
                            <label class="col-sm-4 control-label">预期目标：</label>
                            <div class="col-sm-6">
                                <input id="task_type"  class="form-control" required="true"/>
                            </div>
                            <div class="col-sm-2">
                                <span class="text-danger">*</span>
                            </div>
                        </div>
                    </div>--%>
                    <div class="col-sm-4">
                        <div class=" form-group">
                            <label class="col-sm-4 control-label">完成情况：</label>
                            <div class="col-sm-8">
                                <div class="radio radio-info radio-inline">
                                    <input class = "rdlActive" type="radio" id="complete" value="已完成" name="complete">
                                    <label for="complete"> 已完成 </label>
                                </div>
                                <div class="radio radio-danger radio-inline">
                                    <input class = "rdlActive" type="radio" id="incomplete" value="未完成" name="complete"  checked="">
                                    <label for="incomplete"> 未完成</label>
                                </div>
                                <input id="complete_type" type="hidden">
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class=" form-group">
                            <label class="col-sm-4 control-label">创建时间：</label>
                            <div class="col-sm-6">
                                <input  type="text" class="form-control"
                                        id="create_time"
                                        name="create_time" readonly="true"/>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class=" form-group">
                            <label class="col-sm-4 control-label">修改时间：</label>
                            <div class="col-sm-6">
                                <input type="text" class="form-control"
                                       id="modify_time"
                                       name="modify_time" readonly="true"/>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <div class="row">
        <%--计划列表--%>
        <div class="col-sm-12">
            <div class="ibox">
                <a class="collapse-link">
                    <div class="ibox-title">
                        <h5>执行人员</h5>
                        <div class="ibox-tools">
                            <i class="fa fa-chevron-up"></i>
                        </div>
                    </div>
                </a>
                <div class="ibox-content">
                    <div class="toolbardiv" id="goodsToolBar">
                        <a id="addNewEmployee" class="btn btn-success btn-sm" href="javascript:addEmployee();">
                            <i class='fa fa-plus'></i>&nbsp;&nbsp;添加员工</a>
                    </div>
                    <table id="employee"></table>
                </div>

            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-sm-12">
            <div class="ibox">
                <a class="collapse-link">
                    <div class="ibox-title">
                        <h5></h5>
                        <div class="ibox-tools">
                            <i class="fa fa-chevron-up"></i>
                        </div>
                    </div>
                </a>
                <div class="ibox-content" >
                    <div class="col-sm-12">
                        <div class="form-group">
                            <label class="col-sm-2 control-label">计划描述：</label>
                            <div class="col-sm-9">
                                <textarea  type="text" class="form-control richtext" id="plan_desc" name="plan_desc"  rows="6"  ></textarea>
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
</form>
<!-- 隐藏div防止底部按钮区域覆盖表单区域 -->
<div style="margin-bottom:50px;"></div>
<div class="main_btnarea">
    <div class="btn_area_setc btn_area_bg" id="operator">
        <a  class='btn btn-primary btn-sm' href='###' onclick='confirm()'><i class='fa fa-check'></i>&nbsp;&nbsp;确定</a>
        <a class='btn btn-danger btn-sm' href='###' onclick='closeForm()'><i class='fa fa-remove'></i>&nbsp;&nbsp;关闭</a>
    </div>
</div>
<script src="${pageContext.request.contextPath}/res/hplus/js/plugins/clockpicker/clockpicker.js"></script>
<script type="text/javascript">
    $('.clockpicker').clockpicker();
</script>
</body>
</html>
