<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>县编辑管理</title>
  <!--hplus-->
  <%@ include file="/res/public/hplus.jsp"%>
  <%@ include file="/res/public/easyui_lib.jsp"%>
  <%@ include file="/res/public/angularjs.jsp"%>
  <%@ include file="/res/public/msg.jsp"%>
  <%@ include file="/res/public/common.jsp"%>
  <script type="text/javascript">
    //获取数据
    var myform  = angular.module('mybody', ['ui.bootstrap']).controller('countyCtrl', function($scope,$compile, $http){
      $scope.model = {};
      var url='${root}/manage/pcc/getCounBase?counCode='+$("#_code").val();
      $http.get(url).success(function(response) {
        $scope.model.countyBase = response.county;
        var _cityCode = $("#_cityCode").val();
        if(_cityCode!=""){
          $scope.model.countyBase.cityCode = _cityCode;
        }
        $("#is_used").val(response.is_used);
      });
      //保存
      $scope.processForm = function(v,funcCode) {
        if(!checkInputValueIsEmpty()){
          return;
        }
        layer.confirm('确定保存吗?', {
          btn: ['确定','取消'], //按钮
          shade: false //不显示遮罩
        }, function(index){
            $scope.model.countyBase.counCode= $("#counCode").val();
            console.log($scope.model.countyBase);
            var url="${root}/manage/pcc/saveCountyBase";
            $http({
              method  : 'POST',
              url     : encodeURI(encodeURI(url)),
              data    : $scope.model.countyBase,
              headers : { 'Content-Type': 'application/x-www-form-urlencoded' }
            }).success(function(data) {
              if (data.msgCode="1") {
                $scope.model.countyBase = data.county;
                layer.msg(data.msgDesc);
              } else {
                layer.msg(data.msgDesc);
              }
            });
        }, function(index){

          layer.close(index);
        });
      };
      //关闭当前按钮
      $scope.closeForm=function(){
        $.messager.confirm("提示","确定关闭窗口吗?",function (f){
          if(f){
            parent.closeCurTab();
          }
        });
        return;
      };
    });
    setModuleRequest(myform);
    //保存之前验证文本框是否为空
    function checkInputValueIsEmpty(){
      var es = $("#myform *[required='true']");
      if (es.length > 0) {
        for (var i = 0;i < es.length;i++) {
          var e = es[i];
          if ($.trim($(e).val()) == "") {
            layer.tips('该字段必填', '#' + $(e).attr("id"));
            return false;
          }
        }
      }
      return true;
    }
  </script>
</head>
<body ng-app="mybody" ng-controller="countyCtrl">
<form  collapse="isCollapsed" class="form-horizontal"  role="form" id="myform" name="myform"  novalidate>
  <input type="hidden" id="_code" name="_code" value="${_code}">
  <input type="hidden" id="_cityCode" name="_cityCode" value="${_cityCode}">
  <div class="row">
    <div class="col-sm-12">
      <div class="ibox">
        <div class="ibox-content">
          <div class="col-md-6">
            <div class="form-group">
              <label class="col-sm-4 control-label">县编码：</label>
              <div class="col-sm-6">
                <input ng-model="model.countyBase.counCode" type="text" class="form-control"
                       id="counCode" name="counCode"/>
              </div>
            </div>
          </div>
          <div class="col-md-6">
            <div class="form-group">
              <label class="col-sm-4 control-label">县名称：</label>
              <div class="col-sm-6">
                <input ng-model="model.countyBase.counName" type="text" class="form-control"
                       id="counName" name="counName"/>
              </div>
            </div>
          </div>
          <div class="col-md-6">
            <div class="form-group">
              <label class="col-sm-4 control-label">城市编码：</label>
              <div class="col-sm-6">
                <input ng-model="model.countyBase.cityCode" type="text" class="form-control"
                       id="cityCode" name="cityCode" />
              </div>
              <div class="col-sm-2">
                <span class="text-danger">*</span>
              </div>
            </div>
          </div>
          <div class="col-md-6">
            <div class="form-group">
              <label class="col-sm-4 control-label">描述：</label>
              <div class="col-sm-6">
                <input ng-model="model.countyBase.counDesc" type="text" class="form-control"
                       id="counDesc" name="counDesc"/>
              </div>
            </div>
          </div>
          <div class="col-md-6">
            <div class="form-group">
              <label class="col-sm-4 control-label">是否有效：</label>
              <div class="col-sm-6">
                <select id="is_used" class="form-control" theme="simple">
                  <option value="1">是</option>
                  <option value="0">否</option>
                </select>
              </div>
            </div>
          </div>
          <div class="col-md-6">
            <div class="form-group">
              <label class="col-sm-4 control-label">拼音：</label>
              <div class="col-sm-6">
                <input ng-model="model.countyBase.pinYin" type="text" class="form-control"
                       id="pinYin" name="pinYin"/>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</form>
<div style="margin-bottom:50px;"></div>
<div class="main_btnarea">
  <div class="btn_area_setc btn_area_bg" id="operator">
    <a class="btn_small" href="###" ng-disabled ='!myform.$valid' ng-click="processForm(myform.$valid)" align="center">保 存<b></b></a>
  </div>
</div>
</body>
</html>