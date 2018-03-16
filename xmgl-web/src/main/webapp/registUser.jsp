<%@ taglib prefix="c" uri="http://www.springframework.org/tags/form" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
  <title>用户注册</title>
  <%@ include file="/res/public/hplus.jsp"%>
  <%@ include file="/res/public/easyui_lib.jsp"%>
  <%@ include file="/res/public/angularjs.jsp"%>
  <%@ include file="/res/public/common.jsp"%>
  <link rel="shortcut icon" href="/logo/favicon.ico">
  <link rel="icon" type="image/gif" href="/logo/animated_favicon1.gif" >
  <!--hplus-->
  <link
          href="${root}/res/hplus/css/login.css"
          rel="stylesheet">
  <script type="text/javascript">
    var myform  = angular.module('mybody', ['ui.bootstrap']).controller('expertRegistCtrl', function($scope,$compile, $http){
      $("#cgOrgy").show();
      $("#zj").hide();
      $scope.model = {};
      $scope.processForm = function() {
        if(!checkInputValueIsEmpty()){
          return;
        }
        if(!checkInputValueIsValid()){
          return;
        }
          var userType = $("#userType").val();
          if(userType=="gys"){
            var url="${root}/manage/supplier/submit";
          }else if(userType=="cgs"){
            var url="${root}/manage/buyer/submit";
          }else if(userType=="zj"){
            if(!checkInputValueIsValidE()){
              return;
            }
            var url="${root}/manage/expertRegist/submit";
          }
          $http({
            method  : 'POST',
            url     : encodeURI(encodeURI(url)),
            data    : $scope.model.baseJson,
            headers : { 'Content-Type': 'application/x-www-form-urlencoded' }
          }).success(function(response) {
            if (response.msgCode=='success') {
              layer.msg(response.msgDesc);
             // url='${root}/manage/index/indexLoginPage';
             // window.location.href=url;
            }else{
              layer.msg(response.msgDesc);
            }
          });
      };
      //关闭当前按钮
      $scope.clearForm=function(){
        doClear();
        $("#departmentCode").val();
      };
    });
    setModuleRequest(myform);

    //保存之前验证文本框是否为空
    function checkInputValueIsEmpty()
    {
      if($("#userType").val()=="zj"){
        var es = $("#myform *[required='tru']");
        if (es.length > 0)
        {
          for (var i = 0;i < es.length;i++)
          {
            var e = es[i];
            if ($.trim($(e).val()) == "")
            {
              layer.tips('该字段必填', '#' + $(e).attr("id"));
              return false;
            }
          }
        }
      }else{
        var es = $("#myform *[required='true']");
        if (es.length > 0)
        {
          for (var i = 0;i < es.length;i++)
          {
            var e = es[i];
            if ($.trim($(e).val()) == "")
            {
              layer.tips('该字段必填', '#' + $(e).attr("id"));
              return false;
            }
          }
        }
      }
      if($("#userType").val()=="cgs"){
        var es = $("#myform *[required='tr']");
        if (es.length > 0)
        {
          for (var i = 0;i < es.length;i++)
          {
            var e = es[i];
            if ($.trim($(e).val()) == "")
            {
              layer.tips('该字段必填', '#' + $(e).attr("id"));
              return false;
            }
          }
        }
      }
      return true;
    }
    function checkInputValueIsValid()
    {
      var password=$("#password").val();
      var passwordConfirm=$("#passwordConfirm").val();
      if (password==passwordConfirm)
        return true;
      else {
        layer.msg("密码不一致");
        $("#passwordConfirm").focus();
        return false;
      }
    }
    function checkInputValueIsValidE()
    {
      var email=$("#email").val();
      var filter  = /^([a-zA-Z0-9_\.\-])+\@(([a-zA-Z0-9\-])+\.)+([a-zA-Z0-9]{2,4})+$/;
      if (filter.test(email))
        return true;
      else {
        layer.msg('邮箱格式不正确')
        $("#email").focus();
        return false;
      }
    }
    function choseDept(){
      var url = '${root}/manage/expert/choseDept';
      url=encodeURI(encodeURI(url));
      windowName="deptWindow";
      windowTitle="选择部门";
      width = '20%';
      height = '60%';
      f_open(windowName, windowTitle, width,height, url, true);
    }

    function setDept(deptInfo){
      if(deptInfo==null || deptInfo=="")
        return;
      $("#departmentName").val(deptInfo.dept_name);
      $("#departmentCode").val(deptInfo.dept_code);
    }
    function choseRole(role){
     // $("#departmentCode").val();
        if(role=="zj"){
          $("#cgOrgy").hide();
          $("#zj").show();
        }else if(role=="cgs"){
          $("#cgOrgy").show();
          $("#cgs").show();
          $("#zj").hide();
        }else{
          $("#cgOrgy").show();
          $("#cgs").hide();
          $("#zj").hide();
        }
    }
  </script>
</head>
<body  class="signin" ng-app="mybody" ng-controller="expertRegistCtrl" style="background-image: url('/res/hplus/img/regist.jpg') " >
<form class="form-horizontal" role="form" id="myform" name="myform">
  <input type="hidden" id="departmentCode" name="departmentCode"/>
  <div class="signinpanel">
    <div class="row" style="margin-top: -70px;">
      <div class="col-sm-4" >
        <div class="logopanel m-b">
          <h1>[ 全高项目管理系统 ]</h1>
        </div>
        <div class="m-b"></div>
        <h4>
          欢迎使用 <strong> 全高项目管理系统 </strong>
        </h4>
      </div>
      <div class="col-sm-4">
        <div class="logopanel m-b">
          <h1>注册</h1>
        </div>
        <div class="m-b"></div>
        <h4>
        </h4>
      </div>
      <div class="col-sm-4" style="margin-top: 90px;">
        <div class="form-group">
          <label >用户角色：</label>
          <select id="userType" class="form-control uname " placeholder="请选择用户角色" onchange="choseRole(value)">
           <option value ="cgs">采购商</option>
           <option value ="gys">供应商</option>
           <option value ="zj">专家</option>
         </select>
        </div>
        <div id="cgOrgy">
            <div class="form-group">
              <label >单位名称：</label>
              <div>
                <input type="text"  class="form-control"  style="background:#fff  center;color:#333;" id="companyName"
                     name="companyName" ng-model='model.baseJson.companyName' required='true' placeholder="请输入您的用户名"/>
              </div>
            </div>
              <div class="form-group">
                <label >密码：</label>
                  <input type="password" class="form-control pword m-b" id="password"
                         name="password" ng-model='model.baseJson.password' required='true' placeholder="请输入您的密码"/>
              </div>
              <div class="form-group">
                <label >确认密码：</label>
                <div>
                  <input type="password"  class="form-control pword m-b" id="passwordConfirm"
                         name="passwordConfirm" ng-model='model.baseJson.passwordConfirm' required='true' placeholder="请再次输入您的密码"/>
                  </div>
              </div>
          </div>
        <div id="cgs">
          <div class="form-group">
            <label >单位别称：</label>
            <div>
              <input type="text"  class="form-control"  style="background:#fff  center;color:#333;" id="companyNameOther"
                     name="companyNameOther" ng-model='model.baseJson.companyNameOther' required='tr' placeholder="请输入您的别名"/>
            </div>
          </div>
        </div>
        <div id="zj">
          <div class="form-group">
            <label >证件号码：</label>
            <div>
              <input type="text" class="form-control " style="background:#fff  center;color:#333;" placeholder="请输入证件号码" id="idNum"
                     name="idNum" ng-model='model.baseJson.idNum' onkeyup="this.value=this.value.replace(/[^\-?\d.]/g,'')"
                     onafterpaste="this.value=this.value.replace(/[^\-?\d.]/g,'')" required='tru' />
            </div>
          </div>
          <div class="form-group">
            <label >姓名：</label>
            <input type="text"  ng-model='model.baseJson.name' class="form-control " style="background:#fff  center;color:#333;" id="name"
                   name="name" required='tru' placeholder="请输入您的姓名"/>
          </div>
          <div class="form-group">
            <label >性别：</label>
            <select id="gender" class="form-control uname"  ng-model='model.baseJson.gender' placeholder="请选择您的性别">
              <option value="男">男</option>
              <option value="女">女</option>
            </select>
          </div>
          <div class="form-group">
            <label >出生日期：</label>
            <div>
              <input type="text"   class="laydate-icon form-control " style="background:#fff  center;color:#333;" id="birthday"
                     name="birthday" onclick="laydate({format:'YYYY-MM-DD'})"  ng-model='model.baseJson.birthday' placeholder="请选择出生日期"/>
            </div>
          </div>
          <div class="form-group">
            <label >手机号码：</label>
            <div>
              <input id="tel"  type="text" class="form-control " style="background:#fff  center;color:#333;"
                     placeholder="请输入手机号码" onkeyup="this.value=this.value.replace(/[^\-?\d.]/g,'')"
                     onafterpaste="this.value=this.value.replace(/[^\-?\d.]/g,'')" required='tru'   ng-model='model.baseJson.tel'/>
            </div>
          </div>
          <div class="form-group">
            <label >座机号码：</label>
            <div>
              <input id="landlineNum"  type="text" class="form-control "
                     placeholder="请输入座机号码" style="background:#fff  center;color:#333;" onkeyup="this.value=this.value.replace(/[^\-?\d.]/g,'')"
                     onafterpaste="this.value=this.value.replace(/[^\-?\d.]/g,'')" required='tru'  ng-model='model.baseJson.landlineNum'/>
            </div>
          </div>
          <div class="form-group">
            <label >电子邮箱</label>
            <div>
              <input id="email"  type="text" class="form-control "
                     placeholder="请输入电子邮箱" required='tru' style="background:#fff  center;color:#333;"  ng-model='model.baseJson.email'/>
            </div>
          </div>
          <div class="form-group">
            <label >申报单位：</label>
            <div>
              <input type="text"  class="form-control " style="background:#fff  center;color:#333;" placeholder="请输入申报单位" id="applyUnit"
                     name="applyUnit" required='tru'   ng-model='model.baseJson.applyUnit'/>
            </div>
          </div>
          <div class="form-group">
            <label >工作单位：</label>
            <div>
              <input type="text"  class="form-control " style="background:#fff  center;color:#333;" placeholder="请输入工作单位" id="workUnit"
                     name="workUnit" required='tru'   ng-model='model.baseJson.workUnit'/>
            </div>
          </div>
          <div class="form-group">
            <label >工作部门：</label>

            <div>
              <input id="departmentName" class="form-control" style="background:#fff  center;color:#333;" placeholder="请选择所属部门" required='tru'   ng-model='model.baseJson.departmentName'/>
            </div>
          </div>
        </div>
          <div class="form-group">
            <div  align="center">
              <a class='btn btn-primary btn-sm'  href='###' ng-click='processForm()'><i class='fa fa-check'></i>&nbsp;&nbsp;提交</a>&nbsp;&nbsp;
              <a class='btn btn-danger btn-sm'  href='###' ng-click='clearForm()'><i class='fa fa-remove'></i>&nbsp;&nbsp;重置</a>
              <a class='btn btn-primary btn-sm'  href='${root}/manage/index/indexLoginPage'><i class='glyphicon glyphicon-share-alt'></i>&nbsp;&nbsp;返回登录</a>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</form>
</body>
</html>