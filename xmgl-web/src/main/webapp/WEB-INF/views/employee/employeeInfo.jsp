<%--
  Created by wjy
  Date: 2017/7/18
  Time: 10:28
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!doctype html>
<html>
<head>
    <title>员工信息详情</title>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
    <!--hplus-->
    <%@ include file="/res/public/hplus.jsp"%>
    <%@ include file="/res/public/easyui_lib.jsp"%>
    <%@ include file="/res/public/angularjs.jsp"%>
    <%@ include file="/res/public/msg.jsp"%>
    <%@ include file="/res/public/common.jsp"%>

    <script type="text/javascript">
        $(window).resize(function(){ $("#task").datagrid("resize"); });
        var _funcArray;
        $(document).ready(function(){
            _funcArray=getFunctions('${pageContext.request.contextPath}',$("#_curModuleCode").val());
            console.log(_funcArray);
            getEmploymentStatusDic();
            getEducationBgDic();

        });
        var myform = angular.module('mybody', ['ui.bootstrap']).controller('bodyCtrl', function($scope, $compile, $http) {

            $scope.model = {};
            var url = '${root}/manage/employee/getEmployeeInfoById/'+ $("#employee_id").val();

            $http.get(url).success(function(response) {
                console.log("employee after load!!!!\n"+JSON.stringify(response));
                $scope.model.employee = response;
                $scope.model.employeeBasicInfo = new Object();
                console.log(response.creator);
                if (response!=null){
                    if ($scope.model.employee.basic_info){
                        $scope.model.employeeBasicInfo=JSON.parse($scope.model.employee.basic_info);

                        $('#education_bg').val( $scope.model.employeeBasicInfo.education_bg);
                        if ($scope.model.employee.user_id){
                            $('#user_id').val($scope.model.employee.user_id);
                        }
                        displayHobbies($scope.model.employeeBasicInfo.hobbies);
                        if ($scope.model.employeeBasicInfo.gender=="女"){
                            $("input[value='女']").attr('checked','true');
                        }
                        else{
                            $("input[value='男']").attr('checked','true');
                        }
                    }

                    $('#employment_status').val( $scope.model.employee.employment_code);

                    $('#dept_id').val( $scope.model.employee.dept_id);
                    $('#position_code').val( $scope.model.employee.position_code);
                }


                if ($scope.model.employee.photo){
                    $("#photo").attr('src',$("#imageUrl").val()+$scope.model.employee.photo);
                }
                else{
                    $("#photo").attr('src','/res/public/img/icons/tx.png');
                }
                /*除了系统管理员，其他人不可以修改他人的资料*/

                if($('#cur_user_id').val()!=$scope.model.employee.user_id && $('#cur_user_id').val()!=2){

                    $('.rdlActive').attr("readonly",true);
                    $('.rdlActive').attr("disabled",true);

                }
                if($('#_curModuleCode').val()=="GRZX"){
                    $('.no-modify').attr("readonly",true);
                    $('.no-modify').attr("disabled",true);
                    $('.em-hide').hide();
                }
                controlButs($scope,$compile);
            });

            $scope.processForm = function(funcCode) {
                if (!validateForm()) {
                    return;
                }
                var msg="保存";
                layer.confirm('确定'+msg+'吗?', {
                    btn: ['确定','取消'], //按钮
                    shade: false //不显示遮罩
                }, function(index){
                    var url="${root}/manage/employee/saveEmployee";
                    if ($('#photo_path').val()!='' && $('#photo_path').val()!=null){
                        $scope.model.employee.photo=$('#photo_path').val();
                    }

                    $scope.model.employee.employment_code=$('#employment_status').val();
                    $scope.model.employee.dept_name=$('#dept_name').val();
                    $scope.model.employee.position_name=$('#position_name').val();
                    $scope.model.employee.dept_id=$('#dept_id').val();
                    $scope.model.employee.user_id=$('#user_id').val();
                    $scope.model.employee.position_code=$('#position_code').val();

                    $scope.model.employeeBasicInfo.birthday=$('#birthday').val();
                    $scope.model.employeeBasicInfo.entry_date=$('#entry_date').val();
                    $scope.model.employeeBasicInfo.leave_date=$('#leave_date').val();
                    $scope.model.employeeBasicInfo.skills=$('#skills').val();
                    $scope.model.employeeBasicInfo.education_bg=$('#education_bg').val();
                    $scope.model.employeeBasicInfo.gender=$("input[name='gender']:checked").val();

                    $scope.model.employeeBasicInfo.hobbies=getHobbies();
                    $scope.model.employee.basic_info=JSON.stringify($scope.model.employeeBasicInfo);
                    $.blockUI();
                    $http({
                        method: 'POST',
                        url: encodeURI(encodeURI(url)),
                        data: $scope.model.employee,
                        headers: {'Content-Type': 'application/x-www-form-urlencoded'}
                    }).success(function (response) {
                        $.unblockUI();
                        $scope.model.employee=response.employee;//刷新
                        layer.close(index);
                        layer.msg(response.msgDesc);
                        if ($scope.model.employee.photo){
                            $("#photo").attr('src',$("#imageUrl").val()+$scope.model.employee.photo);
                        }
                        if ($scope.model.employee.user_id){
                                setUserHeadPhotoById($scope.model.employee.photo,$scope.model.employee.user_id);
                        }

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
            $scope.connectAccount=function(){
                var msg="";
                if ($scope.model.employee.user_id){
                     msg ="该员工已经关联了一个账户！更改关联？"

                }
                else{
                    msg ="确定关联账户？"
                }
                layer.confirm(msg, {
                    btn: ['确定','取消'], //按钮
                    shade: false //不显示遮罩
                },function(index){
                    //关联账户
                    var url = "${root}/manage/employee/connectAccount?employeeId="+$scope.model.employee.id+"&deptId="+$('#dept_id').val()+
                        "&roleCode="+$("#position_code").val()+"&deptName="+$('#dept_name').val()+
                        "&roleName="+$("#position_name").val()+"&displayName="+$("#employee_name").val()+
                        "&head_photo="+$scope.model.employee.photo;
                    var width = '80%';
                    var height ='80%';
                    url=encodeURI(encodeURI(url));
                    f_open("connectAccount", "关联账户", width, height, url, true);

                    layer.close(index);
                },function(index){
                    layer.close(index);
                    return;
                });

            };
            $scope.addAccount=function(){
                if ($scope.model.employee.user_id!==null && $scope.model.employee.user_id!==""){
                    layer.confirm('该员工已经有了一个账户！不能再开户', {
                        btn: ['确定','取消'], //按钮
                        shade: false //不显示遮罩
                    },function(index){
                        layer.close(index);
                    },function(index){
                        layer.close(index);
                    });
                    return;
                }
                var url="${root}/manage/user/initaddUserInfo?isFromEmployee="+true+"&deptId="+$('#dept_id').val()+
                "&roleCode="+$("#position_code").val()+"&deptName="+$('#dept_name').val()+
                    "&roleName="+$("#position_name").val()+"&displayName="+$("#employee_name").val()+
                    "&employeeId="+$scope.model.employee.id+"&head_photo="+$scope.model.employee.photo;
                var width = '80%';
                var height ='80%';
                url=encodeURI(encodeURI(url));
                f_open("newWindow", "任务详情", width, height, url, true);

            }

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
                        layer.tips('该字段必填', '#' + $(e).attr("id"));
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
                    case 'saveEmployee':
                        html+="<a id = 'bc' class='btn btn-primary btn-sm' href='###' ng-click='processForm(\"SAVE\")'><i class='fa fa-check'></i>&nbsp;&nbsp;保存</a>&nbsp;&nbsp;";
                        break;
                    default:
                        break;
                }
            }
            for(var i=0;i<_funcArray.length;i++)
            {
                var funcObj=_funcArray[i];
                switch(funcObj)
                {
                    case 'GLZH':
                        html+="<a class='btn btn-warning btn-sm' href='###' ng-click='connectAccount()'><i class='fa fa-link'></i>&nbsp;&nbsp;关联账户</a>&nbsp;&nbsp;";
                        break;
                    case 'KH':
                        html+="<a class='btn btn-info btn-sm' href='###' ng-click='addAccount()'><i class='fa fa-plus'></i>&nbsp;&nbsp;开户</a>&nbsp;&nbsp;";
                        break;
                    default:
                        break;
                }
            }
                html+="<a class='btn btn-danger btn-sm' href='###' ng-click='closeForm()'><i class='fa fa-remove'></i>&nbsp;&nbsp;关闭</a>";

            var template = angular.element(html);
            var element =$compile(template)($scope);
            angular.element("#operator").empty();
            angular.element("#operator").append(element);
        }
        function uploadPicture(){
            var url = "${root}/manage/employee/uploadEmployeePic?id="+$("#employee_id").val()+"&_module="+"YGZP";
            var width = '50%';
            var height ='70%';
            f_open("newWindow", "上传文件", width, height, url, true);
        }
        function setPhoto(photo_path){
            $('#photo_path').val(photo_path);
            $("#photo").attr('src',$("#imageUrl").val()+photo_path);
        }
        function getEmploymentStatusDic(){
            var url = "${root}/manage/employee/getEmploymentStatusDic";
            url=encodeURI(encodeURI(url));
            $.ajax({
                url: url,
                type : 'post',
                async : false,
                success: function(result) {
                    addSelectOption(result.employmentStatusDic,"employment_status");
                }
            });
        }
        function getEducationBgDic(){
            var url = "${root}/manage/employee/getEducationBgDic";
            url=encodeURI(encodeURI(url));
            $.ajax({
                url: url,
                type : 'post',
                async : false,
                success: function(result) {
                    addSelectOption(result.educationBgDic,"education_bg");
                }
            });
        }

        function chooseDept()
        {
            var url = '${root}/manage/dept/choseDept?_chkStyle=checkbox'+"&_selDept="+$("#dept_id").val();
            url=encodeURI(encodeURI(url));
            windowName="deptWindow";
            windowTitle="选择部门";
            width = "20%";
            height = "80%";
            f_open(windowName, windowTitle, width,height, url, true);
        }

        function choosePosition(){
            var url = '${root}/manage/permission/choseRoleWithId?_chkStyle=checkbox&_selCodes=' + $('#position_code').val();
            windowName="roleWindow";
            windowTitle="选择角色";
            width = "20%";
            height = "80%";
            f_open(windowName, windowTitle, width,height, url, true);
        }

        function setDept(deptInfo){
            if(!deptInfo)
                return;
            var dept_name='';
            var dept_id = '';
            for (var i=0;i<deptInfo.length;i++){
                dept_name += deptInfo[i].dept_name+',';
                dept_id += deptInfo[i].id+',';
            }
            dept_name = dept_name.substring(0,dept_name.length-1);
            dept_id = dept_id.substring(0,dept_id.length-1);
            $("#dept_name").val(dept_name);
            $("#dept_id").val(dept_id);

        }

        function setRole(roleList){
            if(!roleList)
                return;
            var roleName='';
            var roleCode= '';
            for (var i=0;i<roleList.length;i++){
                roleName += roleList[i].roleName+',';
                roleCode += roleList[i].roleCode+',';
            }
            roleName = roleName.substring(0,roleName.length-1);
            roleCode = roleCode.substring(0,roleCode.length-1);
            $("#position_name").val(roleName);
            $("#position_code").val(roleCode);
        }
        function setUserHeadPhotoById(head_photo,userId){
            if (head_photo!=null && head_photo!=''){
                var url = "${root}/manage/user/setUserHeadPhotoById?headPhoto="+head_photo+"&userId="+userId;
                url=encodeURI(encodeURI(url));
                $.ajax({
                    url: url,
                    type : 'post',
                    success: function(result) {
                    }
                });
            }

        }
        function getHobbies(){
            var str=[];
            $("input:checkbox[name='hobbies']:checked").each(function(i){
                str.push($(this).val());
            });
            return str.join(',');
        }
        function displayHobbies(str){
            if (str){
                var strArr = str.split(',');
                for (var i=0;i<strArr.length;i++){
                    $("input:checkbox[value='"+strArr[i]+"']").attr("checked",'true');
                }
            }
        }
        function setUserId(userId){
            $('#user_id').val(userId);
        }

    </script>


</head>

<body ng-app="mybody" ng-controller="bodyCtrl">

<input  type="hidden" id="employee_id"   value="${id}" />
<input  type="hidden" id="cur_user_id"   value="${user_id}" />
<input  type="hidden" id="imageUrl"   value="${imageUrl}" />
<input  type="hidden" id="_curModuleCode"   value="${_curModuleCode}" />
<input type="hidden" id="photo_path" />
<input type="hidden" id="user_id"/>

<form collapse="isCollapsed" class="form-horizontal" role="form"
      id="myform" name="myform" novalidate>

    <div class="row">
        <div class="col-sm-12">
            <div class="ibox">
                <a class="collapse-link">
                    <div class="ibox-title">
                        <h5>员工基本信息</h5>
                        <div class="ibox-tools">
                            <i class="fa fa-chevron-up"></i>
                        </div>
                    </div>
                </a>
                <div class="ibox-content">
                    <div class="col-md-8">
                        <div class="col-md-6">
                            <div class=" form-group">
                                <label class="col-sm-4 control-label">员工姓名：</label>
                                <div class=" col-sm-6">
                                    <input ng-model="model.employee.employee_name" type="text" class="form-control rdlActive"
                                           id="employee_name" name="employee_name"  required='true' />
                                </div>
                                <div class="col-sm-2">
                                    <span class="text-danger">*</span>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class=" form-group">
                                <label class="col-sm-4 control-label">性别：</label>
                                <div class="col-sm-6">
                                    <input  ng-model="model.employeeBasicInfo.gender" type="hidden" class="form-control rdlActive" id="gender" name="gender"  />
                                        <div class="radio radio-info radio-inline">
                                            <input type="radio" id="male" value="男" name="gender" checked="">
                                            <label for="male"> 男 </label>
                                        </div>
                                        <div class="radio radio-danger radio-inline">
                                            <input type="radio" id="female" value="女" name="gender">
                                            <label for="female"> 女</label>
                                        </div>
                                </div>
                                </div>
                        </div>
                        <div class="col-md-6">
                            <div class=" form-group">
                                <label class="col-sm-4 control-label">常住地址：</label>
                                <div class="col-sm-6">
                                    <input  ng-model="model.employeeBasicInfo.address" class="form-control rdlActive"  id="address" />
                                </div>
                                <div class="col-sm-2">
                                    <span ></span>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class=" form-group">
                                <label class="col-sm-4 control-label">身份证号：</label>
                                <div class="col-sm-6">
                                    <input ng-model="model.employeeBasicInfo.id_number" type="text" class="form-control rdlActive" id="id_number" name="id_number" />
                                </div>
                                <div class="col-sm-2">
                                    <span class="text-danger"></span>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class=" form-group">
                                <label class="col-sm-4 control-label">民族：</label>
                                <div class="col-sm-6">
                                    <input ng-model="model.employeeBasicInfo.minzu" type="text" class="form-control rdlActive" id="minzu" name="minzu" />
                                </div>
                                <div class="col-sm-2">
                                    <span class="text-danger"></span>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class=" form-group">
                                <label class="col-sm-4 control-label">政治面貌：</label>
                                <div class="col-sm-6">
                                    <input ng-model="model.employeeBasicInfo.politics_status" type="text" class="form-control rdlActive" id="politics_status" name="politics_status" />
                                </div>
                                <div class="col-sm-2">
                                    <span class="text-danger"></span>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class=" form-group">
                                <label class="col-sm-4 control-label">生日：</label>
                                <div class="col-sm-6">
                                    <input ng-model="model.employeeBasicInfo.birthday" onclick= "laydate()" type="text" class="form-control rdlActive" id="birthday" name="birthday" />
                                </div>
                                <div class="col-sm-2">
                                    <span class="text-danger"></span>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class=" form-group">
                                <label class="col-sm-4 control-label">身高：</label>
                                <div class="col-sm-6 ">
                                    <div class="input-group">
                                    <input ng-model="model.employeeBasicInfo.body_height" type="text" class="form-control rdlActive" id="body_height" name="body_height" />
                                    <span class="input-group-addon">cm</span>
                                    </div>
                                </div>
                                <div class="col-sm-2">
                                    <span class="text-danger"></span>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class=" form-group">
                                <label class="col-sm-4 control-label">体重：</label>
                                <div class="col-sm-6">
                                    <div class="input-group">
                                    <input ng-model="model.employeeBasicInfo.body_weight" type="text" class="form-control rdlActive" id="body_weight" name="body_weight" />
                                     <span class="input-group-addon">kg</span>
                                    </div>
                                </div>
                                <div class="col-sm-2">
                                    <span class="text-danger"></span>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class=" form-group">
                                <label class="col-sm-4 control-label">星座：</label>
                                <div class="col-sm-6">
                                    <input ng-model="model.employeeBasicInfo.constellations" type="text" class="form-control rdlActive" id="constellations" name="constellations" />
                                </div>
                                <div class="col-sm-2">
                                    <span class="text-danger"></span>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class=" form-group">
                                <label class="col-sm-4 control-label">籍贯：</label>
                                <div class="col-sm-6">
                                    <input ng-model="model.employeeBasicInfo.native_place" type="text" class="form-control rdlActive" id="native_place" name="native_place" />
                                </div>
                                <div class="col-sm-2">
                                    <span class="text-danger"></span>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class=" form-group">
                                <label class="col-sm-4 control-label">家庭地址：</label>
                                <div class="col-sm-6">
                                    <input ng-model="model.employeeBasicInfo.native_address" type="text" class="form-control rdlActive" id="native_address" name="native_address" />
                                </div>
                                <div class="col-sm-2">
                                    <span class="text-danger"></span>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class=" form-group">
                                <label class="col-sm-4 control-label">创建人：</label>
                                <div class="col-sm-6">
                                    <input ng-model="model.employee.creator" type="text" class="form-control" id="creator" name="creator" readonly/>
                                </div>
                                <div class="col-sm-2">
                                    <span class="text-danger"></span>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class=" form-group">
                                <label class="col-sm-4 control-label">创建时间：</label>
                                <div class="col-sm-6">
                                    <input ng-model="model.employee.create_date" type="text" class="form-control" id="create_date" readonly
                                           name="create_date" />
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class=" form-group">
                                <label class="col-sm-4 control-label">修改人：</label>
                                <div class="col-sm-6">
                                    <input ng-model="model.employee.modifier" type="text" class="form-control" id="modifier" name="modifier" readonly/>
                                </div>
                                <div class="col-sm-2">
                                    <span ></span>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-6">
                            <div class=" form-group">
                                <label class="col-sm-4 control-label">修改时间：</label>
                                <div class="col-sm-6">
                                    <input ng-model="model.employee.modify_date" type="text" class="form-control" id="modify_date" readonly
                                           name="modify_date" />
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class="col-md-12">
                            <div class=" form-group">
                                <label class="col-sm-4 control-label">头像：</label>
                                <div class="col-sm-6">
                                    <img border="0" alt="此处添加头像" width="250" height="250" id="photo"/>
                                </div>
                                <div class="col-sm-2">
                                    <a class="btn btn-warning btn-sm" href="javascript:uploadPicture();">
                                        <i class='fa fa-picture-o'></i>
                                    </a>
                                </div>
                            </div>
                        </div>


                    </div>

                </div>
            </div>
        </div>
        <div class="col-sm-12">

            <div class="ibox">
                <a class="collapse-link">
                    <div class="ibox-title">
                        <h5>联系信息</h5>
                        <div class="ibox-tools">
                            <i class="fa fa-chevron-up"></i>
                        </div>
                    </div>
                </a>
                <div  class="ibox-content">
                        <div class="col-md-4">
                            <div class=" form-group">
                                <label class="col-sm-4 control-label">联系电话：</label>
                                <div class="col-sm-6">
                                    <input ng-model="model.employeeBasicInfo.mobilephone_number" type="text" class="form-control rdlActive" id="mobilephone_number"
                                           name="mobilephone_number" />
                                </div>
                            </div>
                        </div>
                    <div class="col-md-4">
                        <div class=" form-group">
                            <label class="col-sm-4 control-label">QQ：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.employeeBasicInfo.qq" type="text" class="form-control rdlActive" id="qq"
                                       name="qq" />
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class=" form-group">
                            <label class="col-sm-4 control-label">电子邮箱：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.employeeBasicInfo.email" type="text" class="form-control rdlActive" id="email"
                                       name="email" />
                            </div>
                        </div>
                    </div>
                </div>
            </div>


        </div>
        <div class="col-sm-12">

            <div class="ibox">
                <a class="collapse-link">
                    <div class="ibox-title">
                        <h5>职位信息</h5>
                        <div class="ibox-tools">
                            <i class="fa fa-chevron-up"></i>
                        </div>
                    </div>
                </a>
                <div  class="ibox-content">
                    <div class="col-md-4">
                        <div class=" form-group">
                            <label class="col-sm-4 control-label">就职状态：</label>
                            <div class="col-sm-6">
                                <select type="text" class="form-control rdlActive no-modify" id="employment_status"
                                       name="employment_status" >
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class=" form-group">
                            <label class="col-sm-4 control-label">部门名称：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.employee.dept_name" type="text" class="form-control no-modify" placeholder="请选择部门" id="dept_name"
                                       name="dept_name" disabled="true" />
                            </div>
                            <div class="col-sm-2">
                                <input   ng-model="model.employee.dept_id" type="hidden" type="text" 	id="dept_id" name="dept_id" />
                                <a class="btn btn-warning btn-sm em-hide" href="javascript:chooseDept();">
                                    <i class='fa fa-search'></i>&nbsp;&nbsp;选择
                                </a>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class=" form-group">
                            <label class="col-sm-4 control-label">岗位名称：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.employee.position_name" type="text" class="form-control no-modify" id="position_name"
                                       placeholder="请选择角色" name="position_name" disabled="true" required='true' />
                            </div>
                            <div class="col-sm-2">

                                <input ng-model="model.employee.position_code" type="hidden"    type="text"
                                       id="position_code" name="position_code" />
                                <a class="btn btn-warning btn-sm em-hide" href="javascript:choosePosition();">
                                    <i class='fa fa-search'></i>&nbsp;&nbsp;选择
                                </a>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class=" form-group">
                            <label class="col-sm-4 control-label">入职时间：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.employeeBasicInfo.entry_date" onclick= "laydate()" type="text" class="form-control rdlActive no-modify" id="entry_date" name="entry_date" />
                            </div>
                            <div class="col-sm-2">
                                <span class="text-danger"></span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class=" form-group">
                            <label class="col-sm-4 control-label">离职时间：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.employeeBasicInfo.leave_date" type="text" onclick= "laydate()" class="form-control rdlActive no-modify" id="leave_date" name="leave_date" />
                            </div>
                            <div class="col-sm-2">
                                <span class="text-danger"></span>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
            <div class="ibox">
                <a class="collapse-link">
                    <div class="ibox-title">
                        <h5>教育信息</h5>
                        <div class="ibox-tools">
                            <i class="fa fa-chevron-up"></i>
                        </div>
                    </div>
                </a>
                <div  class="ibox-content">
                    <div class="col-md-4">
                        <div class=" form-group">
                            <label class="col-sm-4 control-label">学历：</label>
                            <div class="col-sm-6">
                                <select type="text" class="form-control rdlActive" id="education_bg"
                                        name="education_bg" >
                                </select>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                        <div class=" form-group">
                            <label class="col-sm-4 control-label">毕业学校：</label>
                            <div class="col-sm-6">
                                <input ng-model="model.employeeBasicInfo.graduation_school" type="text" class="form-control rdlActive" id="graduation_school" name="graduation_school" />
                            </div>
                            <div class="col-sm-2">
                                <span class="text-danger"></span>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4">
                            <div class=" form-group">
                                <label class="col-sm-4 control-label">专业：</label>
                                <div class="col-sm-6">
                                    <input ng-model="model.employeeBasicInfo.major" type="text" class="form-control rdlActive" id="major" name="major" />
                                </div>
                                <div class="col-sm-2">
                                    <span class="text-danger"></span>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            <div class="ibox">

                    <div class="ibox-title">
                        <h5></h5>
                        <div class="ibox-tools">
                            <i class="fa fa-chevron-up"></i>
                        </div>
                    </div>

            <div class="ibox-content">
                <div class="col-md-8">
                <div class=" form-group">
                    <label class="col-sm-2 control-label">兴趣爱好：</label>
                    <div class="col-sm-9">
                                <div class="col-sm-1">
                                    <label>
                                    <input type="checkbox" value="读书" name="hobbies" > 读书</label>
                                </div>
                                <div class="col-sm-1">
                                <label>
                                    <input type="checkbox" value="运动" name="hobbies" > 运动</label>
                                </div>
                                <div class=" col-sm-1">
                                <label>
                                    <input type="checkbox" value="音乐" name="hobbies" > 音乐</label>
                                </div>
                                <div class="col-sm-1">
                                <label>
                                    <input type="checkbox" value="游戏" name="hobbies" > 游戏</label>
                                </div>
                                <div class="col-sm-1">
                                <label>
                                    <input type="checkbox" value="影视" name="hobbies" > 影视</label>
                                </div>
                                <div class=" col-sm-1">
                                <label>
                                    <input type="checkbox" value="美食" name="hobbies" > 美食</label>
                                </div>
                                <div class="col-sm-1">
                                <label>
                                    <input type="checkbox" value="旅游" name="hobbies" > 旅游</label>
                                </div>
                    </div>


                    </div>
                    <div class="col-sm-1">
                        <span class="text-danger"></span>
                    </div>
                </div>

                <div class="col-md-8">
                    <div class=" form-group">
                        <label class="col-sm-2 control-label">技能专长：</label>
                        <div class="col-sm-9">
                                    <textarea ng-model="model.employeeBasicInfo.skills" type="text" rows ='5' class="form-control rdlActive" id="skills" name="skills" >
                                        </textarea>
                        </div>
                        <div class="col-sm-1">
                            <span class="text-danger"></span>
                        </div>
                    </div>
                </div>
                <div class="col-md-8">
                <div class=" form-group">
                    <label class="col-sm-2 control-label">备注：</label>
                    <div class="col-sm-9">
                                <textarea ng-model="model.employeeBasicInfo.remarks" type="text" rows ='5' class="form-control rdlActive " id="remarks" name="remarks" >
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

    <div style="clear: both;height: 35px"></div>
</form>
<!-- 隐藏div防止底部按钮区域覆盖表单区域 -->
<div style="margin-bottom:50px;"></div>
<div class="main_btnarea">
    <div class="btn_area_setc btn_area_bg" id="operator">

    </div>
</div>
</body>
</html>
