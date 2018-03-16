<%@page contentType="text/html;charset=gbk"%>
<style rel="stylesheet" type="text/css">
#showInfoDiv .infopanel .top_l { width: 10px; height: 10px; background: url(/et/autoetdz/image/bg_yj_tb.gif) left top no-repeat; }
#showInfoDiv .infopanel .top_m { height: 10px; background: url(/et/autoetdz/image/bg_yj_tb.gif) left bottom repeat-x; }
#showInfoDiv .infopanel .top_r { width: 10px; height: 10px; background: url(/et/autoetdz/image/bg_yj_tb.gif) right top no-repeat; }
#showInfoDiv .infopanel .middle_l { width: 10px; height: 10px; background: url(/et/autoetdz/image/bg_frame_lr.gif) right top repeat-y; }
#showInfoDiv .infopanel .middle_m { margin: 0; padding: 5px 10px 10px 5px; background: #F1F9FF; }
#showInfoDiv .infopanel .middle_content { margin: 0px; padding: 0px; font-size: 12px; text-align: left; color: #000; }
#showInfoDiv .infopanel h1 { margin: 0; padding: 0; font-size: 12px; border-bottom: #94CEFD solid 1px; color: #000; width: 100%; line-height: 20px; text-align: left; font-weight: bold; overflow: hidden; font-family:Simsun; }
#showInfoDiv .infopanel .middle_r { width: 10px; height: 10px; background: url(/et/autoetdz/image/bg_frame_lr.gif) left top repeat-y; }
#showInfoDiv .infopanel .bottom_l { width: 10px; height: 10px; background: url(/et/autoetdz/image/bg_yj_tb.gif) 0 -10px no-repeat; }
#showInfoDiv .infopanel .bottom_m { height: 10px; background: url(/et/autoetdz/image/bg_yj_tb.gif) 0 -20px repeat-x; }
#showInfoDiv .infopanel .bottom_r { width: 10px; height: 10px; background: url(/et/autoetdz/image/bg_yj_tb.gif) -10px -10px  no-repeat; }

#showInfoDiv .infopanel span { line-height:18px; }
#showInfoDiv .infopanel ul { margin:0px; padding:0px; list-style:none; }
#showInfoDiv .infopanel ul li { margin:0px; padding:0px; list-style:none; line-height:18px; }
#showInfoDiv .infopanel ul.unorderly_list { margin-top: 5px; }
#showInfoDiv .infopanel ul.unorderly_list li { margin-left: 14px; list-style: square outside none; }
#showInfoDiv .infopanel ol { margin-top: 5px; }
#showInfoDiv .infopanel ol li { list-style: decimal inside none; line-height: 18px; }
</style>
<div id="showInfoDiv" style="position: absolute; z-index: 120; left: 628px; top: 453px; display: none;">
	<table id="main" class="infopanel" cellpadding="0" cellspacing="0" width="300px">
        <tbody><tr>
            <td class="top_l"></td><td class="top_m"></td><td class="top_r"></td>
        </tr>
        <tr>
            <td class="middle_l"></td>
            <td class="middle_m">
                 <div class="middle_content">
                    <h1 style="background:none" id="title">Title</h1>                
                    <div id="info">FullPrice£º1800<br>&nbsp;X/100%</div>
                 </div>
            </td>
            <td class="middle_r"></td>
        </tr>
        <tr>
            <td class="bottom_l"></td><td class="bottom_m"></td><td class="bottom_r"></td>
        </tr>
    </tbody></table>
</div>