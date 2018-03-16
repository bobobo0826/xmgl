<%--
  Created by fcy.
  User: quangao
  Date: 2017/8/11
  Time: 15:46
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html >
<html>
<head>

    <title>帮助文档</title>

    <%@ include file="/res/public/loginStyle.jsp"%>
    <style>
        .change-color{ background-color: #F5F5F5; height:45px; }
        .change-colors:hover{ background-color: #F3F7F9; height:30px;line-height:30px; }
    </style>
    <script>
        var _hmt = _hmt || [];
        (function() {
            var hm = document.createElement("script");
            hm.src = "https://hm.baidu.com/hm.js?c9dd85291ea88dcf64671a7dfa65e0ef";
            var s = document.getElementsByTagName("script")[0];
            s.parentNode.insertBefore(hm, s);
        })();
    </script>

    <script type="text/javascript">
        var code=0;
        $(document).ready(function(){

            getStandards();
            $("#removecss").hide();
        });
        function getStandards(){
            var url = "${root}/manage/writingStandards/getStandardsPage";

            $.ajax({
                url:url,
                type:'post',
                cache:false,
                async:false,
                success:function(data){

                    var response = data.StandardsList;
                    console.log(JSON.stringify(response));
                    var html="";

                    for(var i=0;i<response.length;i++){
                        if(response[i].pid==-1){

                            var _id = response[i].id;
                            html+='<a class="list-group-item change-color" data-toggle="tab" href="####" aria-controls="category-1" role="tab" style="text-align: left;font-weight: bold; color: #2e8ded;"   onclick="getStandardsId('+_id+')">'+response[i].name;
                            html+=' </a>'
                        }

                    }

                    $("#name").html(html);



                }
            });
        }

        function getStandardsId(_id) {

            data = {'_id':_id};
            var url = '${root}/manage/writingStandards/queryStandardsShowList';
            $.ajax({
                url:url,
                type:'post',
                data:data,
                cache:false,
                async:false,
                success:function(response){

                    var html="";


                    for(var i=0;i<response.length;i++){



                        html+='<p class="change-colors" style="font-size: 14px;color: #0a6aa1; height:30px; font-weight: bold; line-height:30px;" id="standards_name_'+i+'" onclick="con('+i+')">' +response[i].name+'</p>';
                        html+='<p1 class = "standards_content" id="standards_content_'+i+'"'+
                            ' style="font-size: 12px;display:none;margin-bottom:15px; border-bottom: 1px dashed #ccc; padding-bottom:5px;text-indent:1em; " >'+response[i].content+'</p1>';


                    }
                    $("#question").html(html);

                    if (!$("#question").children().length>0) {
                        $("#removecss").hide();
                    }
                    else {
                        $("#removecss").show();
                    }

                }
            });

        }


        function con(i) {
            if(document.getElementById("standards_content_" + i).style.display=='none'){
                var es = $("#standards_name_"+i).siblings();
                for (var j = 0; j<es.length;j++){
                    if($(es[j]).attr('class') == "standards_content" && $(es[j]).attr('id') != ("#standards_content_"+i)){
                        es[j].style.display='none';
                    }
                }
                document.getElementById("standards_content_" + i).style.display='block';


            }else{
                document.getElementById("standards_content_" + i).style.display='none';
            }

        }


    </script>
</head>
<body>
<div class="page-container" id="admui-pageContent">




    <div class="page animation-fade page-faq">

        <div class="page-header">
            <h1 class="page-title">帮助文档</h1>
        </div>

        <div class="page-content container-fluid">
            <div class="row">
                <div class="col-lg-3 col-sm-4">

                    <div class="panel" >
                        <div class="panel-body" style="background-color:#F5F5F5">
                            <div class="list-group" data-plugin="nav-tabs" role="tablist" id="name"  style="cursor: pointer; ">

                            </div>
                        </div>
                    </div>

                </div>

                <div class="col-lg-9 col-sm-8">

                    <div class="panel">
                        <div class="panel-body" id="removecss" style="background-color:#F5F5F5;" >
                            <div class="tab-content" >

                                <div class="tab-pane animation-fade active" id="category-1" role="tabpanel">
                                    <div class="panel-group panel-group-simple panel-group-continuous" id="accordion2" aria-multiselectable="true" role="tablist">

                                        <div class="panel">
                                            <div class="panel-heading" id="question" role="tab" style="cursor: pointer">


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

    </div>


</div>

</body>
</html>
