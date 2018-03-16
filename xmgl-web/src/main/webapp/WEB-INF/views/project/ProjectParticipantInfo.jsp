<%--
  Created by IntelliJ IDEA.
  User: QG-YKM
  Date: 2017-07-27
  Time: 17:00 下午
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!doctype html>
<html>
<head>
    <title>参与人员详情</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <!--hplus-->
    <%@ include file="/res/public/hplus.jsp"%>
    <%@ include file="/res/public/easyui_lib.jsp"%>
    <%@ include file="/res/public/angularjs.jsp"%>
    <%@ include file="/res/public/msg.jsp"%>
    <%@ include file="/res/public/common.jsp"%>


    <script type="text/javascript">
        var photoUrl;
        var _funcArray;
        var _curModuleCode = "${_curModuleCode}";
        $(document).ready(function(){
            //配置选择员工权限
            _funcArray = getFunctions('${pageContext.request.contextPath}', _curModuleCode);
            if (_funcArray != null && _funcArray != undefined) {
                for (var i = 0; i < _funcArray.length; i++) {
                    var funcObj = _funcArray[i];
                    switch (funcObj) {
                        case 'selectEmployee':
                            $("#oprToolBar").show();
                            break;
                        default:
                            break;
                    }
                }
            }
            getParticipantTypeList()
            var gridData=parent.getGrid($("#grid_index").val());
            $("#grid_data").val(gridData);
            if($("#grid_data").val()!="") {
                var gridData = JSON.parse($("#grid_data").val());
                $("#employee_id").val(gridData.employee_id);
                $("#participantName").val(gridData.participant_name);
                $("#participantType").val(gridData.participant_type_code);
                $("#participantGender").val(gridData.participant_gender);
                $("#participantTel").val(gridData.participant_tel);
                $("#photoRelativeUrl").val(gridData.participant_photo);//暂存下相对地址，方便保存至父页面
            }
            photoUrl=$("#imageUrl").val()+$("#photoRelativeUrl").val();
            document.getElementById("participantPhoto").src = photoUrl;

        });

        function closeForm(){
            layer.confirm('确定关闭窗口吗?', {
                btn: ['确定','取消'], //按钮
                shade: false //不显示遮罩
            }, function(index){
                f_close("newWindow");
                layer.close(index);readonly="true"
            }, function(index){
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
                        layer.tips('该字段必填', '#' + $(e).attr("id"));
                        $("html,body").animate({scrollTop:$("#"+$(e).attr("id")).offset().top- $("html,body").offset().top +  $("html,body").scrollTop()},1000);
                        return false
                    }
                }
            }
            return true;
        }
        /**
         * 保存
         */
        function confirmInfo(){
            if (!validateForm()) {
                return;
            }
            var object=new Object();
            object.employee_id=$("#employee_id").val();
            object.participant_name=$("#participantName").val();
            object.participant_type_code=$("#participantType").val();
            object.participant_type=$("#participantType option:checked").text();
            object.participant_gender=$("#participantGender").val();
            object.participant_tel=$("#participantTel").val();
            object.participant_photo=$("#photoRelativeUrl").val();
            layer.confirm('确定保存么',{
                btn: ['确定','取消'], //按钮
                shade: false //不显示遮罩
            }, function(index) {
                layer.close(index);
                parent.updateGrid(object, $("#grid_index").val());
                f_close("newWindow");
            },function(index) {
                layer.close(index);
            })
        }
        function getParticipantTypeList(){
            var url = "${root}/manage/project/getParticipantTypeList";
            url=encodeURI(encodeURI(url));
            $.ajax({
                url: url,
                type : 'get',
                async : false,
                success: function(result) {
                    addSelectOption(result.participantTypeList,"participantType");
                }
            });
        }

        function selectEmployee(){
            var url="${root}/manage/employee/selectEmployee?_curModuleCode=XMCYRY";
            var width="80%";
            var height="80%";
            f_open("newWindow","选择员工",width,height,url,true);
        }
        function setEmployeeInfo(object){
            $("#employee_id").val(object.employee_id);
            $("#participantName").val(object.employee_name);
            $("#participantGender").val(object.gender);
            $("#participantTel").val(object.mobilephone_number);
            $("#photoRelativeUrl").val(object.photo);
            //选择人员后，下拉框设为空值，刷新头像
            $("#participantType").attr("value", "");
            photoUrl=$("#imageUrl").val()+$("#photoRelativeUrl").val();
            document.getElementById("participantPhoto").src = photoUrl;
        }
    </script>
</head>

<body >
<input  type="hidden" id="grid_index" value="${gridIndex}" />
<input  type="hidden" id="imageUrl" value="${imageUrl}"/>
<input  type="hidden" id="grid_data" />
<input  type="hidden" id="employee_id" />
<input  type="hidden" id="photoRelativeUrl" />
<form collapse="isCollapsed" class="form-horizontal" role="form" id="myform" name="myform" novalidate>
    <div class="row">
        <div class="col-sm-12">
            <div class="ibox">
                <div class="ibox-content">
                    <div class="col-md-8">
                        <div class="col-sm-10" >
                            <div  class=" form-group">
                                <label class="col-sm-4 control-label">参与人：</label>
                                <div class="col-sm-6">
                                    <input type="text" class="form-control" id="participantName" name="participantName" readonly="true"/>
                                 </div>
                                <div class="col-sm-2">
                                    <span class="text-danger">*</span>
                                    <a class="btn btn-warning btn-sm" id="oprToolBar" style="display: none" href="javascript:selectEmployee();">
                                        <i class='fa fa-search'></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-10" >
                            <div  class=" form-group">
                                <label class="col-sm-4 control-label">人员类型：</label>
                                <div class="col-sm-6">
                                    <select type="text" class="form-control" id="participantType" name="participantType" ></select>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-10" >
                            <div  class=" form-group">
                                <label class="col-sm-4 control-label">性别：</label>
                                <div class="col-sm-6">
                                    <input type="text" class="form-control" id="participantGender" name="participantGender" readonly="true"/>
                                </div>
                            </div>
                        </div>
                        <div class="col-sm-10" >
                            <div  class=" form-group">
                                <label class="col-sm-4 control-label">电话：</label>
                                <div class="col-sm-6">
                                <input type="text" class="form-control" id="participantTel" name="participantTel" readonly="true"/>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="col-md-12">
                            <div class=" form-group">
                                <label class="col-sm-4 control-label">照片：</label>
                                <div class="col-sm-6">
                                    <img border="0" alt="image" width="250" height="250" id="participantPhoto"/>
                                </div>
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
        <a class='btn btn-primary btn-sm' href='###' onclick='confirmInfo()'><i class='fa fa-check'></i>&nbsp;&nbsp;确定</a>
        <a class='btn btn-danger btn-sm' href='###' onclick='closeForm()'><i class='fa fa-remove'></i>&nbsp;&nbsp;关闭</a>
    </div>
</div>
</body>
</html>
