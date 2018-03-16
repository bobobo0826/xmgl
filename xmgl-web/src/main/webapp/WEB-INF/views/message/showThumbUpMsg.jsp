<%--
  Created by IntelliJ IDEA.
  User: wch
  Date: 2017-07-20
  Time: 9:03 上午
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>我的点赞消息</title>
    <!--[if lt IE 9]>
    <meta http-equiv="refresh" content="0;ie.html" />
    <![endif]-->

    <link rel="shortcut icon" href="../../logo/favicon.ico">
    <link rel="icon" type="image/gif" href="../../logo/animated_favicon1.gif" >
    <!--hplus-->
    <%@ include file="/res/public/hplus.jsp"%>
    <style type="text/css">

        body{
            height: 100%;
        }
    </style>
</head>
<body>
<input type="hidden" id="userId" value="${UserId}">
<input type="hidden" id="imageUrl" value="${imageUrl}">
<div class="row m-t-sm">
    <div class="col-sm-12">
        <div class="panel blank-panel">
            <div class="panel-heading">
                <div class="panel-options">
                    <ul class="nav nav-tabs">
                        <li class="active"><a href="project_detail.html#tab-1" data-toggle="tab" aria-expanded="true">谁点赞了我</a>
                        </li>
                        <li class=""><a href="project_detail.html#tab-2" data-toggle="tab" aria-expanded="false">我点赞了谁</a>
                        </li>
                    </ul>
                </div>
            </div>

            <div class="panel-body">

                <div class="tab-content">
                    <div class="tab-pane active" id="tab-1">
                        <div class="feed-activity-list" id="tab-one">
                        </div>
                        <div class="pageBox">
                            <ul class="pageDiv clearfix">

                            </ul>
                            <div class="notContent hide">
                                无数据
                            </div>
                            <div class="page">
                                <ul class="pageMenu clearfix">
                                    <li class="firstPage">首页</li>
                                    <li class="prevPage"> < 上一页 </li>
                                    <div class="pageObj ">

                                    </div>
                                    <li class="nextPage"> 下一页 > </li>
                                    <li class="lastPage">尾页</li>
                                    <li class="last" style="font-size: 14px;">
                                        共<span class="totalPage"></span>页，跳转至 <input type="number" class="keuInput" value="1">
                                        <button type="button" class="btnSure">确定</button>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                    <div class="tab-pane" id="tab-2">
                        <div class="feed-activity-list" id="tab-two">
                        </div>
                        <div class="pageBox2">
                            <ul class="pageDiv clearfix">

                            </ul>
                            <div class="notContent hide">
                                无数据
                            </div>
                            <div class="page">
                                <ul class="pageMenu clearfix">
                                    <li class="firstPage">首页</li>
                                    <li class="prevPage"> < 上一页 </li>
                                    <div class="pageObj ">

                                    </div>
                                    <li class="nextPage"> 下一页 > </li>
                                    <li class="lastPage">尾页</li>
                                    <li class="last" style="font-size: 14px;">
                                        共<span class="totalPage"></span>页，跳转至 <input type="number" class="keuInput" value="1">
                                        <button type="button" class="btnSure">确定</button>
                                    </li>
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>

            </div>

        </div>
    </div>
</div>

</body>
<script type="text/javascript" >

    var photoUrl;

    $(function() {
        getReceivePage();
        getSendPage();

    });
    function getReceivePage(){
        var url = "${root}/manage/message/getMessageList?receiver_id=" + $("#userId").val() + "&messageType=DZ";
        $(".pageBox").pageFun({  /*在本地服务器上才能访问哦*/
            interFace:url,  /*接口*/
            displayCount:5,  /*每页显示总条数*/
            maxPage:5,/*每次最多加载多少页*/
            dataFun:function(data){
                getReceiveMessagePage(data);
            },
            pageFun:function(i){
                var pageHtml = '<li class="pageNum">'+i+'</li>';
                return pageHtml;
            }

        })
    }
    function getSendPage(){
        var url = "${root}/manage/message/getMessageList?sender_id=" + $("#userId").val() + "&messageType=DZ";
        $(".pageBox2").pageFun({  /*在本地服务器上才能访问哦*/
            interFace:url,  /*接口*/
            displayCount:5,  /*每页显示总条数*/
            maxPage:5,/*每次最多加载多少页*/
            dataFun:function(data){
                getSendMessagePage(data);
            },
            pageFun:function(i){
                var pageHtml = '<li class="pageNum">'+i+'</li>';
                return pageHtml;
            }

        })
    }
    function getReceiveMessagePage(response){
        var html = '';
        if(response.length==0) {
            html += '<div class="feed-element" readonly="true">暂无消息</div>'
        }else{
            for(var i=0;i<response.length;i++){
                if(response[i].sender_head_photo){
                    photoUrl = $("#imageUrl").val()+response[i].sender_head_photo;
                }else{
                    photoUrl = "/res/public/img/icons/tx.png";
                }
                html+='<div class="feed-element">'+
                    '<a href="profile.html#" class="pull-left"> <img alt="image" class="img-circle" src="'+photoUrl+'"></a>'+
                    '<div class="media-body ">'+
                    '<small class="pull-right text-navy">'+response[i].timeDiff+'&nbsp;'+response[i].remind_time+'</small>' +
                    '<a><span onclick="checkMessage(\''+response[i].business_type+'\','+response[i].business_id+','+response[i].id+',\''+response[i].sender_id+'\')"><strong>'+response[i].sender+'</strong>点赞了<strong>我</strong>的<strong>'+response[i].business_name+'</strong></span></a>'+
                    '<br>'+
                    '<div class="well">'+response[i].remind_content+'</div>'+
                    '</div></div>';
            }
        }
        $('#tab-one').html(html);
    }
    function getSendMessagePage(response){
        var html = '';
        if(response.length==0) {
            html += '<div class="feed-element" readonly="true">暂无消息</div>'
        }else{
            for(var i=0;i<response.length;i++){
                if(response[i].sender_head_photo){
                    photoUrl = $("#imageUrl").val()+response[i].sender_head_photo;
                }else{
                    photoUrl = "/res/public/img/icons/tx.png";
                }
                html+='<div class="feed-element">'+
                    '<a href="profile.html#" class="pull-left"> <img alt="image" class="img-circle" src="'+photoUrl+'"></a>'+
                    '<div class="media-body ">'+
                    '<small class="pull-right text-navy">'+response[i].timeDiff+'&nbsp;'+response[i].remind_time+'</small>' +
                    '<a><span onclick="checkMessage(\''+response[i].business_type+'\','+response[i].business_id+','+response[i].id+',\''+response[i].sender_id+'\')"><strong>我</strong>点赞了<strong>'+response[i].receiver+'</strong>的<strong>'+response[i].business_name+'</strong></span></a>'+
                    '<br>'+
                    '<div class="well">我点赞了'+response[i].receiver+'的【'+response[i].business_name+'】{ '+response[i].log_date+' } </div>'+
                    '</div></div>';
            }
        }

        $("#tab-two").html(html);
    }

    function checkMessage(log_type, log_id, message_id ,sender_id){
        var url1;
        if(log_type=="MRJH"){
            url1="${root}/manage/dayLog/initDayLogInfo/"+log_id+"/comments/MRJH";
        }
        if(log_type=="MZJH"){
            var url1 = "${root}/manage/weekLog/weekLogInfoIndex/"+log_id+"/comments/MZJH";
        }
        if(log_type=="MYJH"){
            var url1 = "${root}/manage/monthLog/monthLogInfo/"+log_id+"/comments/MYJH";
        }
        url1=encodeURI(encodeURI(url1));
        parent.addTab("日志详情", url1);

        if($("#userId").val()!=sender_id){
            var url2 = "${root}/manage/message/checkMessage?id="+message_id;
            url2=encodeURI(encodeURI(url2));
            $.ajax({
                url: url2,
                type : 'post',
                async : false,
                success: function(result) {

                }
            });
        }
    }
</script>
<script
        src="${root}/res/hplus/js/plugins/metisMenu/jquery.metisMenu.js"></script>
<script
        src="${root}/res/hplus/js/hplus.js?v=4.1.0"></script>
<script
        src="${root}/res/hplus/js/contabs.js"></script>
</html>
