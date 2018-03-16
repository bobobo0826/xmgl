import React from "react";
import { Modal, Button,Checkbox, Row, Col, Input, Tag, Tooltip,FormItem ,message} from "antd";
import "./EmailHomeShowStyle.scss";
import mirror, {connect, actions,render, Route, Link} from 'mirrorx'
import {getJson} from "../../request"
const { TextArea } = Input;
var tagValues = []
var tagValuess  = tagValues
var nameList = []
var emailAdd = []
let checkboxValue = false;
let emailDataToSave = {};

const formChange = function(pro, val) {
        emailDataToSave[pro] = val;
        console.log(pro+"***"+val);

}

const getNowFormatDate =function() {
    let date = new Date();
    const seperator1 = "-";
    const seperator2 = ":";
    let month = date.getMonth() + 1;
    let strDate = date.getDate();
    if (month >= 1 && month <= 9) {
        month = "0" + month;
    }
    if (strDate >= 0 && strDate <= 9) {
        strDate = "0" + strDate;
    }
    var currentdate = date.getFullYear() + seperator1 + month + seperator1 + strDate
        + " " + date.getHours() + seperator2 + date.getMinutes();
    return currentdate;
}

// const saveInputRef =function(data) {(this.input = data)}



mirror.model({
    name: 'emailHomeShow',
    initialState: {
        visible: false,
        emailContext:'',
        emailTitle:'',
        tags: [],
        inputVisible: false,
        inputValue: '',
        emailAddValue: [],
        emailData: {
            receiver: [],
            context: '',
            title: '',
            send_time: '',
        }
    },
    reducers: {
        //添加赋值内容
        changeContext(state,val){
            return{
                ...state,
                emailContext:val
            }
        },
        //添加标题内容
        changeTitle(state,val){
            return{
                ...state,
                emailTitle:val
            }
        },
        //弹窗清空数据
        showOrHide(state,data){
            if(data==true)
            {
                 tagValues = []
                 tagValuess  = []
                 emailDataToSave.receiver=[];
            }
          return {
              ...state,
              visible:data,
              emailAddValue : [],
              checkboxValue : false,
              emailData: {
                  receiver: [],
                  context: '',
                  title: '',
                  send_time:'',
              },
              emailContext:'',
              emailTitle:''

          }
        },
        handleClose(state,data) {
            const tags = state.tags.filter(tag => tag !== data);
            return {
                ...state,
                tags
            }
        },

        /*showInput(state,data) {
            return {
                ...state,
                inputVisible: true
            };

        },*/
        /*
        handleInputChange(state,data) {
            console.log(data);
            return {
                ...state,
                inputValue: data.target.value
            }
        },*/

        /*handleInputConfirm(state,data) {
            const inputValue = state.inputValue;
            let tags = state.tags;
            if (inputValue && tags.indexOf(inputValue) === -1) {
                tags = [...tags, inputValue];
            }
            return {
                ...state,
                tags,
                inputVisible: false,
                inputValue: ""
            }
        },*/

        showValue(state,data) {
            //单选状态下取消全选按钮
            if(checkboxValue==true)
            {
                checkboxValue=false
            }
            //保存选中的人员
            let flag = false;
            for (var i = 0; i < tagValuess.length; i++) {
                if ([tagValuess[i]] == data) {
                    flag = true;
                    tagValuess.splice(i, 1);
                }
            }
            if (!flag) tagValuess.push(data);
            //添加邮件地址
            let k = 0, j = 0;
            let addemail = [];
            for (k in nameList) {
                for (j in tagValuess)
                    if (nameList[k] == tagValuess[j]) {
                        addemail.push(emailAdd[k])
                    }
            }
            formChange('receiver', tagValuess.join(","));
            //赋值给选择框
            return {
                ...state,
                emailAddValue: addemail,
                // checkboxValue: false,
                emailData: {
                    receiver: tagValuess
                },
                checkboxValue:checkboxValue
            }
        },

        //全选方法
        allCheck(state,data) {
            checkboxValue = !checkboxValue;
            tagValuess = [];
            emailDataToSave.receiver=[];
            if (checkboxValue == true) {
                tagValues = nameList;
                formChange('receiver', nameList.join(","));
                return {
                    ...state,
                    emailAddValue: emailAdd,
                    emailData: {
                        receiver: nameList},
                    checkboxValue:checkboxValue
                }

            }
            else if (checkboxValue == false) {
                tagValuess = [];
                emailDataToSave.receiver=[];
                return {
                    ...state,
                    emailAddValue: '',
                    emailData: {
                        receiver: ''},
                    checkboxValue:checkboxValue
                }
            }
        },
        //赋值方法
        setEmployeeList(state,data){
            return{
                ...state,
                tags:data
            }
        },



    },
    effects: {
        //获取员工信息
        async getEmployeeList(data, getState) {
            let response = await getJson("/api/employee/manage/employee/selectEmployeeLists")
            if (nameList) {
                response.map((item) => {
                    nameList.push(item.employee_name);
                    emailAdd.push(item.email);
                    actions.emailHomeShow.setEmployeeList(nameList);//在把值赋给state，需要写方法。
                })
              }
        },
        //保存邮件信息
        async save(data, getState) {
            formChange('send_time', getNowFormatDate())
            let emailAddValues = getState().emailHomeShow.emailAddValue;

            if (emailDataToSave.receiver.length==0) {
                 message.error("收件人不能为空！")
                 return;
             }
            if (!emailDataToSave.title) {
                message.error("主题不能为空！")
                return;
            }
            else if (!emailDataToSave.context) {
                message.error("正文不能为空！")
                return;
            }


            await getJson("/api/oa/saveEmailInfo", {body: {...emailDataToSave, emailAddValues}})
            message.success("发送成功！");

        },
    }
})

const  EmailHomeShow = connect(state =>{
        if(nameList.length==0)
        {
            actions.emailHomeShow.getEmployeeList()
        }
    return  state.emailHomeShow
    }
)(props => {
    return (
        <div>
            <Modal
                title="Email"
                cancelText="关闭"
                width="800px"
                visible={props.visible || false}
                onCancel={()=>{actions.emailHomeShow.showOrHide(false)}}
                footer={
                    <div>
                        <Button type="dashed" onClick={()=>{actions.emailHomeShow.save()}}>
                            发送
                        </Button>
                        <Button type="danger" onClick={()=>{actions.emailHomeShow.showOrHide(false)}}>
                            关闭
                        </Button>
                    </div>
                }
            >
                <Row className="email">
                    <Col span={12} className="email-left">
                        <Row className="email-row">
                            <Col span={6} className="label-text">收件人：</Col>
                            <Col span={18}>
                                <Input className="email-control" value={props.emailData.receiver}
                                />
                            </Col>
                        </Row>

                        <Row className="email-row">
                            <Col span={6} className="label-text">地址：</Col>
                            <Col span={18}>
                                <Input className="email-control" value={props.emailAddValue}
                                />
                            </Col>
                        </Row>

                        <Row className="email-row">
                            <Col span={6} className="label-text">主题：</Col>
                            <Col span={18}>
                                <Input className="email-control"
                                       value={props.emailTitle}
                                       onChange={(e) => {formChange('title', e.target.value);actions.emailHomeShow.changeTitle(e.target.value)}}
                                />
                            </Col>
                        </Row>

                        <Row className="email-row">
                            <Col span={6} className="label-text">正文：</Col>
                            <Col span={18}>
                                <TextArea className="email-control" rows={6}
                                          value={props.emailContext}
                                          onChange={(e) => {formChange('context', e.target.value);actions.emailHomeShow.changeContext(e.target.value)}}
                                />
                            </Col>
                        </Row>
                    </Col>


                    <Col span={12} className="text-right">
                        <Row span={24}>
                            <Col span={20}>
                                <p className="text-right-title">人员列表</p>
                            </Col>
                            <Col span={4}>
                                <Checkbox className="checkBox" checked={props.checkboxValue}
                                          onChange={() => actions.emailHomeShow.allCheck()}>全选</Checkbox>
                            </Col>
                        </Row>
                        <div className="text-right-text">
                            {props.tags.map((tag, index) => {
                                const isLongTag = tag.length > 20;
                                const tagElem = (
                                    <Tag
                                        key={index}
                                        /*closable={index !== 0}*///标签自信删除
                                        afterClose={() => actions.emailHomeShow.handleClose(tag)}
                                        onClick={() => actions.emailHomeShow.showValue(tag)}
                                    >
                                        {isLongTag ? `${tag.slice(0, 20)}...` : tag}
                                    </Tag>
                                );
                                return isLongTag ? <Tooltip title={tag}>{tagElem}</Tooltip> : tagElem;
                            })}
                            {/*{props.inputVisible && (
                                <Input
                                    // ref={saveInputRef()}
                                    type="text"
                                    size="small"
                                    style={{width: 78}}
                                    value={props.inputValue}
                                    onChange={(e)=>{actions.emailHomeShow.handleInputChange(e)}}
                                    onBlur={(e)=>{actions.emailHomeShow.handleInputConfirm(e)}}
                                    onPressEnter={(e)=>{actions.emailHomeShow.handleInputConfirm(e)}}
                                />
                            )}
                            {!props.inputVisible && (
                                <Button size="small" type="dashed" onClick={(e)=>{actions.emailHomeShow.showInput(e)}}>
                                    + 收件人
                                </Button>
                            )}*/}
                        </div>
                    </Col>
                </Row>
            </Modal>
        </div> )

});
export default EmailHomeShow

