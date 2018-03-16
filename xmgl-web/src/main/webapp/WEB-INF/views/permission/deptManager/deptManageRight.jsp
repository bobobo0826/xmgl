<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>部门信息</title>
	<%@ include file="/res/public/hplus.jsp"%>
	<%@ include file="/res/public/easyui_lib.jsp"%>
	<%@ include file="/res/public/common.jsp"%>
	<%@ include file="/res/public/angularjs.jsp"%>
	<%@ include file="/res/public/msg.jsp"%>
	<script type="text/javascript" src="http://api.map.baidu.com/api?v=2.0&ak=HH0Ze3kk1ZuopsMXfMP8bbzqQDxaGSMg"></script>
</head>
<body>
<body ng-app="body" ng-controller="deptCtrl">
<input type="hidden"  id="deptId"   value="${deptId}"/>
<input type="hidden" id="parent_id" value="${parentId}"/>
<form method="post" class="form-horizontal" name="myform" id="myform">
	<div class="ibox-content">
		<div class="row">
			<div class="col-sm-12">
				<div class="ibox">
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-2 control-label">名称：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control" id="deptName"
									   ng-model="model._model.deptName" name="deptName"  required='true'/>
							</div>
							<div class="col-sm-3">
								<span class="text-danger">*</span>
							</div>
						</div>
					</div>
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-2 control-label">部门编码：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control" id="deptCode"
									   ng-model="model._model.deptCode" name="deptCode" />
							</div>
						</div>
					</div>
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-2 control-label">父部门名称：</label>
							<div class="col-sm-7">
								<input type="hidden" ng-model="model._model.parentId"
									   name="parentId" id="parentId">
								<input	ng-model="model._model.parentDeptName" readOnly type="text" 	class="form-control" id="parentDeptName" name="parentDeptName" required='true'>
							</div>
							<%--<div class="col-sm-3">
								<a class="btn btn-warning btn-sm"
								   href="javascript:choseDept();"><i class='fa fa-search'></i>选择<b></b></a>
							</div>--%>
						</div>
					</div>
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-2 control-label">描述：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control"
									   ng-model="model._model.deptDesc" name="deptDesc" id="deptDesc" />
							</div>
						</div>
					</div>
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-2 control-label">排序：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control" name="orderNo"
									   ng-model="model._model.orderNo" />
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<div class="row">
			<div class="col-sm-12">
				<div class="ibox ">
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-2 control-label">地区：</label>
							<div class="col-sm-2">
								<select  class="form-control"  id="prov_code" name="prov_code" onchange="setCities(this.value,'','city_code')"></select>
							</div>
							<div class="col-sm-2">
								<select id="city_code" name="city_code" onchange="setCounties(this.value,'','county_code')" emptyOption="true" class="form-control"></select>
							</div>
							<div class="col-sm-3">
								<select id="county_code" name="county_code" class="form-control" emptyOption="true" onchange="showMap()"></select>
							</div>
						</div>
					</div>
					<div class="col-sm-6">
						<div class="form-group">
							<label class="col-sm-2 control-label">详细地址：</label>
							<div class="col-sm-7">
								<input type="text" class="form-control" name="area_address" id="area_address"
									   ng-model="model._model.address" required="true"/>
							</div>
							<div class="col-sm-3">
								<span class="text-danger">*</span>
								<a class="btn btn-warning btn-sm" href="javascript:initMap('show');"  id="show">
									<i class='fa fa-search'></i>&nbsp;&nbsp;查看地图
								</a>
								<a class="btn btn-warning btn-sm" href="javascript:initMap('hide');"  style="display:none" id="hide">
									<i class='fa fa-arrow-up'></i>&nbsp;&nbsp;隐藏地图
								</a>
							</div>
						</div>
					</div>
					<div class="col-sm-12" id="mapDiv" style="display:none">
						<div class="form-group">
							<label class="col-sm-1 control-label"></label>
							<div class="col-sm-10">
								<div class="bigdiv"   id="map">
									<div id="button"><span>提示：单击地图可设置地址</span></div>
									<div  id="allmap" style="height:300px"></div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
</form>
<div class="btn_area_setc btn_area_bg" id="operator" >

	<%--
        <a class="btn btn-primary btn-sm" href="###" ng-click="processForm(myform.$valid)"><i class='fa fa-check'></i>&nbsp;&nbsp;保存<b></b></a>&nbsp;&nbsp;
    --%>

</div>
</body>
<script>
    var oldParentId="";
    var _funcArray;
    var _curModuleCode = "BMGL";
    var myform  = angular.module('body', ['ui.bootstrap']).controller('deptCtrl', function($scope, $compile, $http){
        $scope.model = {};
        _funcArray = getFunctions('${pageContext.request.contextPath}', _curModuleCode);
        //获取数据
        var url='${root}/manage/dept/getDeptInfo?deptId='+$("#deptId").val()+'&parentId='+$("#parent_id").val();
        $http.get(url).success(function(response) {
            $scope.model._model = response._model;
            controlButs($scope, $compile);
            setProvinces('',$scope.model._model.provCode,'prov_code');
            setCities($scope.model._model.provCode,$scope.model._model.cityCode,'city_code');
            setCounties($scope.model._model.cityCode,$scope.model._model.countyCode,'county_code');
            handlePage();
        });
        function controlButs($scope, $compile) {
            var html = "";
            if (_funcArray != null && _funcArray != undefined) {
                for (var i = 0; i < _funcArray.length; i++) {
                    var funcObj = _funcArray[i];
                    switch (funcObj) {
                        case 'saveDeptInfo':
                            html += "<a class='btn btn-primary btn-sm' href='###' ng-click='processForm()'><i class='fa fa-check'></i>&nbsp;&nbsp;保存</a>&nbsp;&nbsp;";
                            break;
                        default:
                            break;
                    }
                }
            }
            var template = angular.element(html);
            var element = $compile(template)($scope);
            angular.element("#operator").empty();
            angular.element("#operator").append(element);
        }

        function handlePage()
        {
            oldParentId=$scope.model._model.parentId;
            $("#deptId").val($scope.model._model.id);
            $("#parentDeptName").val($scope.model._model.parentDeptName);
            $("#parentId").val($scope.model._model.parentId);
            $("#deptCode").val($scope.model._model.deptCode);
        }
        $scope.processForm = function() {
            var address=$("#area_address").val();
            var myGeo = new BMap.Geocoder();
            myGeo.getPoint(address, function(point){
                if (point) {
                    $('#baidu_lng').val(point.lng);
                    $('#baidu_lat').val(point.lat);
                }else{
                    layer.msg("改地址无法定位或不明确，请在地图上手动定位");
                    return;
                }
            },$("#city_code").find("option:selected").text());
            $scope.model._model.parentDeptName=$("#parentDeptName").val();
            $scope.model._model.parentId=$("#parentId").val();
            $scope.model._model.id=$("#deptId").val();
            $scope.model._model.deptCode=$("#deptCode").val();
            $scope.model._model.provCode=$("#prov_code").val();
            $scope.model._model.cityCode=$("#city_code").val();
            $scope.model._model.address=$("#area_address").val();
            $scope.model._model.countyCode=$("#county_code").val();
            $scope.model._model.baiduLng=$("#baidu_lng").val();
            $scope.model._model.baiduLat=$("#baidu_lat").val();
            $http({
                method  : 'POST',
                url     : encodeURI(encodeURI('${root}/manage/dept/saveDeptInfo')),
                data    : $scope.model._model,
                headers : { 'Content-Type': 'application/x-www-form-urlencoded' }
            }).success(function(response) {
                if(response.msgCode=="success")
                {
                    var model=response._model;
                    $scope.model._model = response._model;
                    handlePage();
                    //加载父节点的父节点
                    if($scope.model._model.parentId==-1)
                        window.parent.reloadTreeChildNodeById(-1);
                    else
                    {
                        //查找父节点的父节点
                        var httpReqest=new HttpRequest();
                        var url='${root}/manage/dept/getDeptInfo?deptId='+$scope.model._model.parentId+'&parentId=';
                        var result=httpReqest.sendRequest(url);
                        window.parent.reloadTreeChildNodeById(result._model.id);
                    }
                }
                layer.msg(response.msgDesc);
            }, function(index){
                layer.close(index);
            });
        };
    });
    setModuleRequest(myform);

    function choseDept()
    {
        var url = '${root}/manage/dept/choseDept';
        url=encodeURI(encodeURI(url));
        windowName="deptWindow";
        windowTitle="选择部门";
        width = '30%';
        height = '70%';
        f_open(windowName, windowTitle, width,height, url, true);
    }

    function setDept(deptInfo)
    {
        if(deptInfo==null || deptInfo=="")
            return;
        //重新设置部门，1、不能选择自己做自己的父部门
        // 2、不能选择自己的下级部门
        var canChanged=checkChangeCodeIsCorrect(deptInfo.id);
        if(canChanged==false)
            return;
        $("#parentDeptName").val(deptInfo.dept_name);
        $("#parentId").val(deptInfo.id);
    }
    //检查选择后的部门是否正确,选择后的部门id， 当前部门id，如果当操作为新建，那么可以任意操作
    function checkChangeCodeIsCorrect(changeAfterDeptId){
        var curDeptId=$("#deptId").val();
        if(curDeptId==0||curDeptId=="")
            return true;
        var httpReqest=new HttpRequest();
        var url='${root}/manage/dept/checkChangeCodeIsCorrect?chageAfterDeptId='+changeAfterDeptId+"&deptId="+curDeptId;
        result=httpReqest.sendRequest(url);
        if(result.msgCode=="failure")
        {
            layer.msg(result.msgDesc);
            return false;
        }
        return true;
    }

    function setProvinces(parentCode,defVal,elementId) {
        var city = document.getElementById(elementId);
        var url = '${root}/manage/dept/getProvincesDic';
        $.ajax({
            type : 'post',
            cache : false,
            url : url,
            async : false,
            success : function(result) {
                var data = result.v;
                city.options.length = 0;
                var fOpt = new Option("", "");
                city.options.add(fOpt);
                if (null != data) {
                    for (var i=0; i < data.length; i++) {
                        var opt = document.createElement("option");
                        opt.value = data[i].prov_code;
                        opt.text = data[i].prov_name;
                        city.options.add(opt);
                    }
                    city.value = defVal;
                    if(defVal==null||defVal==""){
                        $("#"+elementId).next().empty();
                    }
                }
            },
            error : function() {
                alert("出错!请联系管理员!");
            }
        });
        showMap();
    }

    function setCities(parentCode,defVal,elementId) {
        var city = document.getElementById(elementId);
        var url = '${root}/manage/dept/getCitiesDicByProvCode?provCode=' + parentCode;
        $.ajax({
            type : 'post',
            cache : false,
            url : url,
            async : false,
            success : function(result) {
                var data = result.v;
                city.options.length = 0;
                var fOpt = new Option("", "");
                city.options.add(fOpt);
                if (null != data) {
                    for (var i=0; i < data.length; i++) {
                        var opt = document.createElement("option");
                        opt.value = data[i].city_code;
                        opt.text = data[i].city_name;
                        city.options.add(opt);
                    }
                    city.value = defVal;
                    if(defVal==null||defVal==""){
                        $("#"+elementId).next().empty();
                    }
                }
            },
            error : function() {
                alert("出错!请联系管理员!");
            }
        });
        showMap();
    }
    function setCounties(parentCode,defVal,elementId) {
        var county = document.getElementById(elementId);
        var url = '${root}/manage/dept/getCountiesDicByCityCode?cityCode=' + parentCode;
        $.ajax({
            type : 'post',
            cache : false,
            url : url,
            async : false,
            success : function(result) {
                var data = result.v;
                county.options.length = 0;
                var fOpt = new Option("", "");
                county.options.add(fOpt);
                if (null != data) {
                    for (var i=0; i < data.length; i++) {
                        var opt = document.createElement("option");
                        opt.value = data[i].coun_code;
                        opt.text = data[i].coun_name;
                        county.options.add(opt);
                    }
                    county.value = defVal;
                    if(defVal==null||defVal==""){
                        $("#"+elementId).next().empty();
                    }
                }
            },
            error : function() {
                alert("出错!请联系管理员!");
            }
        });
        showMap();
    }
    function showMap(){
        var map = new BMap.Map("allmap");
        map.enableScrollWheelZoom();    //启用滚轮放大缩小，默认禁用
        map.enableContinuousZoom();    //启用地图惯性拖拽，默认禁用
        map.addControl(new BMap.NavigationControl());  //添加默认缩放平移控件
        var myGeo = new BMap.Geocoder();
        if($("#city_code").val()!=""&&$("#city_code").val()!=null){
            var address="";
            if($("#area_address").val()!=""){
                address=$("#area_address").val();
            }else{
                address=$("#prov_code").find("option:selected").text()+$("#city_code").find("option:selected").text()
                    +$("#county_code").find("option:selected").text();
            }
            myGeo.getPoint(address, function(point){
                if (point) {
                    $('#baidu_lng').val(point.lng);
                    $('#baidu_lat').val(point.lat);
                    map.centerAndZoom(point, 15);
                    map.addOverlay(new BMap.Marker(point));
                }else{
                    address=$("#prov_code").find("option:selected").text()+$("#city_code").find("option:selected").text()
                        +$("#county_code").find("option:selected").text();
                    var newmyGeo = new BMap.Geocoder();
                    newmyGeo.getPoint(address, function(point){
                        if (point) {
                            map.centerAndZoom(point, 12);
                            map.addOverlay(new BMap.Marker(point));
                        }
                    }, $("#prov_code").find("option:selected").text());
                    layer.msg("改地址无法定位或不明确，请在地图上手动定位");
                }
            }, $("#city_code").find("option:selected").text());
        }else{
            //默认地址显示上海
            map.centerAndZoom("上海",12);
        }
        //单击设置地址
        map.addEventListener("click", function (e) {
            $('#baidu_lng').val(e.point.lng);
            $('#baidu_lat').val(e.point.lat);
            map.clearOverlays()
            map.addOverlay(new BMap.Marker(e.point)); //将标记添加到地图中
            var myGeo = new BMap.Geocoder();
            // 根据坐标得到地址描述
            myGeo.getLocation(new BMap.Point(e.point.lng, e.point.lat), function(result){
                if (result){
                    $("#area_address").val(result.address);
                    var url = "${root}/manage/dept/getProvAndCityAndCounCodeByName?provName="
                        +result.addressComponents.province+"&cityName="+result.addressComponents.city+"&counName="+result.addressComponents.district;
                    $.ajax({
                        url: url,
                        type : 'post',
                        cache : false,
                        async : false,
                        success:function(response)
                        {
                            if(response.provCode!=""&&response.cityCode!=""&&response.countyCode!=""){
                                $("#prov_code").val(response.provCode);
                                setCities(response.provCode,response.cityCode,'city_code');
                                setCounties(response.cityCode,response.countyCode,'county_code');
                            }
                        }
                    });
                }
            });
        });
    }
    function initMap(type){
        var address=$("#area_address").val();
        $("#mapDiv").animate({
            height:'toggle'
        });
        if(type=="show"){
            $("#show").hide();
            $("#hide").show();
            showMap();
        }else if(type="hide"){
            $("#show").show();
            $("#hide").hide();
        }
    }
</script>
</body>
</html>