<%--
  Created by IntelliJ IDEA.
  User: administror
  Date: 2017/8/22 0022
  Time: 16:49
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
  <title>请假信息详情</title>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
  <!--hplus-->
  <%@ include file="/res/public/hplus.jsp"%>
  <%@ include file="/res/public/easyui_lib.jsp"%>
  <%@ include file="/res/public/angularjs.jsp"%>
  <%@ include file="/res/public/msg.jsp"%>
  <%@ include file="/res/public/common.jsp"%>
  <%@ include file="/thirdparty/ke/kindeditor.jsp" %>


  <script type="text/javascript">
    $(window).resize(function(){ $("#task").datagrid("resize"); });
    var _funcArray;
    $(document).ready(function(){
      createRichText();
      _funcArray=getFunctions('${pageContext.request.contextPath}',$("#_curModuleCode").val());
      console.log($("#_curModuleCode").val());
      console.log(_funcArray);
      console.log("-=-=============="+$("#cur_user_id").val())
      getLeaveAskingStatusDic();
    });
    var myform = angular.module('mybody', ['ui.bootstrap']).controller('bodyCtrl', function($scope, $compile, $http) {

      $scope.model = {};
      var url = '${root}/manage/leaveAsking/getLeaveAskingInfoById/'+ $("#leaveAsking_id").val();

      $http.get(url).success(function(response) {
        console.log("leaveAsking after load!!!!\n"+JSON.stringify(response));
        $scope.model.leaveAsking = response;
        if(response.creator_id){
          $("#creator_id").val(response.creator_id);
        }
        if (response.reason) {
          kindEditer1.html(response.reason);
        }
        if (response.delay_reason) {
          kindEditer2.html(response.delay_reason);
        }
        if (response.leader_opinion) {
          kindEditer3.html(response.leader_opinion);
        }
        $("#status").val($scope.model.leaveAsking.status);
        console.log("-------"+$("#status").val())
        $("#resumpution_status").val($scope.model.leaveAsking.resumpution_status);


        setReadonly();

        controlButs($scope,$compile);

        console.log(response.creator);




      });
      $scope.processForm = function(funcCode) {
        if (!validateForm()) {
          return;
        }
        var msg;
        var status ="";
        var end_leave_status="";

        if($("#leave_start_time").val()>$("#leave_end_time").val())
        {
          layer.msg('申请时间大于结束时间，请修改！');
          return;
        }
        if (funcCode == "SAVE"){
          msg="保存";
          status = "CG";
        }
       else if(funcCode == "SUBMIT"){
          msg="提交";
          status = "DSH";
        }
        else if(funcCode=="ENDLEAVE"){
          msg="销假";
          if (getNowFormatDate()>$("#leave_end_time").val()){
            end_leave_status="YCXJ";
            status = "YTG";
          }
          else if(getNowFormatDate()<$("#leave_end_time").val()){
            end_leave_status="TQXJ";
            status = "YTG";
          }else{
            end_leave_status="ZSXJ";
            status = "YTG";
          }
        }
        else if(funcCode=="PASS"){
          msg="通过";
          status = "YTG";
        }
        else if(funcCode=="NOTPASS"){
          msg="不通过";
          status = "WTG";
        }
        layer.confirm('确定'+msg+'吗?', {
          btn: ['确定','取消'], //按钮
          shade: false //不显示遮罩
        } , function(index){
          $scope.model.leaveAsking.leave_start_time=$("#leave_start_time").val();
          $scope.model.leaveAsking.leave_end_time=$("#leave_end_time").val();
          $scope.model.leaveAsking.reason=$("#reason").val();
          $scope.model.leaveAsking.delay_reason=$("#delay_reason").val();
          $scope.model.leaveAsking.leader_opinion=$("#leader_opinion").val();
          $scope.model.leaveAsking.status = status;
          $scope.model.leaveAsking.resumpution_status =end_leave_status;
          var url="${root}/manage/leaveAsking/saveLeaveAsking?oprCode="+funcCode;
          $scope.model.leaveAsking = JSON.stringify($scope.model.leaveAsking);
          $.blockUI();
          $http({
            method: 'POST',
            url: encodeURI(encodeURI(url)),
            data: $scope.model,
            headers: {'Content-Type': 'application/x-www-form-urlencoded'}
          }).success(function (response) {
            $.unblockUI();
            console.log(response)
            $scope.model.leaveAsking=response.leaveAsking;//刷新
            console.log(JSON.stringify(response.leaveAsking));
            $("#status").val(response.leaveAsking.status);
            $("#resumpution_status").val(response.leaveAsking.resumpution_status);
            $("#leave_end_time").val(response.leaveAsking.leave_end_time);
            layer.close(index);
            layer.msg(response.msgDesc);
            setReadonly();
            controlButs($scope,$compile);

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

    function trim(str) {
      return str.replace(/(^\s*)|(\s*$)/g, "");
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
            $("html,body").animate({scrollTop:$("#"+$(e).attr("id")).offset().top- $("html,body").offset().top +  $("html,body").scrollTop()},1000);
            return false
          }
        }
      }
      return true;
    }
    function reloadUserList(){};

    /**
     * 保存和关闭
     * */
    function controlButs($scope,$compile){
      var html="";
      for(var i=0;i<_funcArray.length;i++)
      {
        var funcObj=_funcArray[i];
        switch(funcObj)
        {
          case 'saveLeaveAsking':
            if ($("#status").val() == "CG"){
              html+="<a class='btn btn-primary btn-sm'href='###' ng-click='processForm(\"SAVE\")'><i class='fa fa-check'></i>&nbsp;&nbsp;保存</a>&nbsp;&nbsp;";
            }
            break;
          case 'leaveAskingNotPass':
            if ($("#status").val() == "DSH"){
              html+="<a class='btn btn-danger btn-sm' href='###' ng-click='processForm(\"NOTPASS\")'><i class='fa fa-check'></i>&nbsp;&nbsp;不通过</a>&nbsp;&nbsp;";
            }
            break;
          case 'leaveAskingPass':
            if ($("#status").val() == "DSH"){
              html+="<a class='btn btn-success btn-sm' href='###' ng-click='processForm(\"PASS\")'><i class='fa fa-check'></i>&nbsp;&nbsp;通过</a>&nbsp;&nbsp;";
             }
            break;
          case 'leaveAskingSubmit':
            if ($("#status").val() == "CG"){
              html+="<a class='btn btn-success btn-sm' href='###' ng-click='processForm(\"SUBMIT\")'><i class='fa fa-check'></i>&nbsp;&nbsp;提交</a>&nbsp;&nbsp;";
            }
            break;
          case 'endLeave':
                  console.log("----------------==="+$("#cur_user_id").val());
                  console.log("----------------==="+$("#creator_id").val());
            if ($("#status").val() == "YTG" && !$("#resumpution_status").val() && $("#cur_user_id").val() == $("#creator_id").val()){
              html+="<a class='btn btn-success btn-sm' href='###' ng-click='processForm(\"ENDLEAVE\")'><i class='fa fa-check'></i>&nbsp;&nbsp;销假</a>&nbsp;&nbsp;";
            }
            break;
          default:
            break;
        }

      }

      html+="<a class='btn btn-danger btn-sm' href='###' ng-click='closeForm()'><i class='fa fa-remove'></i>&nbsp;&nbsp;关闭</a>&nbsp;&nbsp;";
      var template = angular.element(html);
      var element =$compile(template)($scope);
      angular.element("#operator").empty();
      angular.element("#operator").append(element);
    }


    function getLeaveAskingStatusDic(){
      var url = "${root}/manage/leaveAsking/getLeaveAskingDic";
      url=encodeURI(encodeURI(url));
      $.ajax({
        url: url,
        type : 'post',
        async : false,
        success: function(result) {
          addSelectOption(result.leaveAskingStatusList,"status");
          addSelectOption(result.leaveAskingResStatusList,"resumpution_status");
        }
      });
    }

    function setReadonly(){
      if($("#status").val() =="DSH") {
        $("#leave_start_time").attr("readonly", "true");
        $("#leave_start_time").attr("disabled", "disabled");
        $("#leave_end_time").attr("readonly", "true");
        $("#leave_end_time").attr("disabled", "disabled");
        $("#leader_opinion_head").show();
        kindEditer3.readonly(false);
        $("#checker_head").hide();
        $("#check_time_head").hide();
        document.getElementById("leader_opinion").setAttribute("required", true);
        $("#leader_opinion").removeAttr("readonly");
      }else if($("#status").val() =="CG") {
        $("#leave_start_time").removeAttr("readonly");
        $(".status_name_head").hide();
        $("#leader_opinion_head").hide();
        $("#checker_head").hide();
        $("#check_time_head").hide();
        kindEditer3.readonly(true);
        document.getElementById("leader_opinion").setAttribute("required", false);
      } else if($("#status").val() =="YTG" || $("#status").val() =="WTG"){
        $("#leave_start_time").attr("readonly", "true");
        $("#leave_start_time").attr("disabled", "disabled");
        $("#leave_end_time").attr("readonly", "true");
        $("#leave_end_time").attr("disabled", "disabled");
        $("#leader_opinion").attr("readonly","true");
        kindEditer3.readonly(true);
        $("#checker_head").show();
        $("#leader_opinion_head").show();
        $("#check_time_head").show();
        document.getElementById("leader_opinion").setAttribute("required", true);

      }
      if($("#status").val() !="CG") {kindEditer1.readonly(true);}
      if ($("#resumpution_status").val()){
        $(".status_name_head").show();
      }else{
        $(".status_name_head").hide();
      }
      if (!$("#resumpution_status").val()){
        console.log("end_time------------"+$("#leave_end_time").val());
        if(($("#status").val() =="YTG")&&(getNowFormatDate()>$("#leave_end_time").val())){
          $("#delay_reason_head").show();
          $("#delay_reason").removeAttr("readonly");
          document.getElementById("delay_reason").setAttribute("required", true);
        }
        else{
          $("#delay_reason_head").hide();
        }
      }else if ($("#resumpution_status").val() == "YCXJ"){
        $("#delay_reason_head").show();
        $("#delay_reason").attr("readonly", "true");
      }else{
        $("#delay_reason_head").hide();
      }
      if(($("#resumpution_status").val() == "YCXJ")&&($("#status").val() =="YTG")){
        kindEditer2.readonly(true);
      }

    }
    function createRichText() {
      var elements = $('.richtext');
      var eObj1 = elements[0];
      var eObj2 = elements[1];
      var eObj3 = elements[2];
      kindEditer1 = createY(eObj1.id);
      kindEditer2 = createY(eObj2.id);
      kindEditer3 = createY(eObj3.id);
    }


  </script>


</head>

<body ng-app="mybody" ng-controller="bodyCtrl">
<input  type="hidden"  id="creator_id"   value="${creator_id}" />
<input  type="hidden" id="leaveAsking_id"   value="${id}" />
<input  type="hidden" id="cur_user_id" value="${cur_user_id}" />
<input  type="hidden" id="imageUrl"   value="${imageUrl}" />
<input  type="hidden" id="_curModuleCode"   value="${_curModuleCode}" />
<input type="hidden" id="user_id"/>
<form collapse="isCollapsed" class="form-horizontal" role="form" id="myform" name="myform" novalidate>

  <div class="row">
    <div class="col-sm-12">
      <div class="ibox">
        <a class="collapse-link">
          <div class="ibox-title">
            <h5>请假信息详情</h5>
            <div class="ibox-tools">
              <i class="fa fa-chevron-up"></i>
            </div>
          </div>
        </a>

        <div  class="ibox-content">
          <div class="col-md-4">
            <div class=" form-group">
              <label class="col-sm-4 control-label">申请人：</label>
              <div class="col-sm-6">
                <input ng-model="model.leaveAsking.creator" type="text" class="form-control" id="creator" name="creator"readonly="true"/>
              </div>
            </div>
          </div>

          <div class="col-md-4">
            <div class=" form-group">
              <label class="col-sm-4 control-label">申请时间：</label>
              <div class="col-sm-6">
                <input ng-model="model.leaveAsking.create_time" type="text" class="form-control"
                       id="create_time" name="create_time"  readonly="true"/>
              </div>
            </div>
          </div>
          <div class="col-md-4">
            <div class=" form-group">
              <label class="col-sm-4 control-label">状态：</label>
              <div class="col-sm-6">
                <select type="text" class="form-control"
                       id="status" name="status"  readonly="true" disabled="true">
                  </select>
              </div>
              <div class="col-sm-2">
                <span></span>
              </div>
            </div>
          </div>

          <div class="col-md-4">
            <div class=" form-group">
              <label class="col-sm-4 control-label">开始日期：</label>
              <div class="col-sm-6">
                <input ng-model="model.leaveAsking.leave_start_time" type="text" class="form-control"
                       id="leave_start_time" name="leave_start_time" required='true' onclick="laydate()"/>
              </div>
              <div class="col-sm-1">
                <span class="text-danger">*</span>
              </div>
            </div>
          </div>
          <div class="col-md-4">
            <div class=" form-group">
              <label class="col-sm-4 control-label">结束日期：</label>
              <div class="col-sm-6">
                <input ng-model="model.leaveAsking.leave_end_time" type="text" class="form-control"
                       id="leave_end_time" name="leave_end_time" required='true' onclick="laydate()"/>
              </div>
              <div class="col-sm-1">
                <span class="text-danger">*</span>
              </div>
            </div>
          </div>

          <div class="col-md-4 status_name_head">
            <div class=" form-group">
              <label class="col-sm-4 control-label">销假状态：</label>
              <div class="col-sm-6">
                <select  type="text"  class="form-control"
                       id="resumpution_status" name="resumpution_status" readonly="true" disabled="true">
                  </select>
              </div>
            </div>
          </div>

          <div class="col-md-4 status_name_head">
            <div class=" form-group">
              <label class="col-sm-4 control-label">实际销假时间：</label>
              <div class="col-sm-6">
                <input ng-model="model.leaveAsking.actual_resump_time" type="text" class="form-control"
                       id="actual_resump_time" name="actual_resump_time"  readonly="true"/>
              </div>
            </div>
          </div>


            <div class="col-md-4"  id="checker_head">
              <div class=" form-group">
                <label class="col-sm-4 control-label">审核人：</label>
                <div class="col-sm-6">
                  <input ng-model="model.leaveAsking.checker" type="text" class="form-control" id="checker" name="checker"readonly="true"/>
                </div>
              </div>
            </div>

            <div class="col-md-4"  id="check_time_head">
              <div class=" form-group">
                <label class="col-sm-4 control-label">审核时间：</label>
                <div class="col-sm-6">
                  <input ng-model="model.leaveAsking.check_time" type="text" class="form-control"
                         id="check_time" name="check_time"  readonly="true"/>
                </div>
              </div>
            </div>



          <div style="clear: both; height:10px"></div>

            <div class="col-md-8">
              <div class=" form-group">
                <label class="col-sm-2 control-label">请假原因：</label>
                <div class="col-sm-10" id="reason_div">
                  <textarea type="text" rows ='8' class="form-control richtext"
                            id="reason" name="richtext" required='true'>
                  </textarea>
                </div>
                <div class="col-sm-1">
                  <span class="text-danger">*</span>
                </div>
              </div>
            </div>


        <div class="col-md-8" id="delay_reason_head">
          <div class=" form-group">
            <label class="col-sm-2 control-label">延迟销假原因：</label>
            <div class="col-sm-10" id="delay_reason_div">
              <textarea ng-model="model.leaveAsking.delay_reason" type="text" rows ='8' class="form-control richtext"
                        id="delay_reason" name="richtext" >
              </textarea>
            </div>
            <div class="col-sm-1">
              <span class="text-danger"></span>
            </div>
          </div>
        </div>


            <div class="col-md-8" id="leader_opinion_head">
              <div class=" form-group">
                <label class="col-sm-2 control-label">领导意见：</label>
                <div class="col-sm-10" id="leader_opinion_div">
                  <textarea ng-model="model.leaveAsking.leader_opinion" type="text" rows ='8' class="form-control richtext"
                            id="leader_opinion" name="richtext"  >
                  </textarea>
                </div>
                <div class="col-sm-1">
                  <span class="text-danger"></span>
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
