import React from 'react'
import {Icon, message, Input,Form,Col,Row, DatePicker,Button,Modal}from 'antd'
import  "../../../styles/public/css/info.scss"
import SelectEmployee from '../../public/selects/SelectEmployee';
import BaseComponent from '../../BaseComponent'
import moment from 'moment';
moment.locale('zh-cn');
const FormItem = Form.Item;
const formItemLayout = {
    labelCol: {
        xs: {span: 24},
        sm: {span: 6},
    },
    wrapperCol: {
        xs: {span: 24},
        sm: {span: 12},
    },
};
class NoticeInfo extends BaseComponent
{
    noticeData = {};
    addData = [];
    constructor(props) {
        super(props);
        this.state = {
            addElement: [],
            dics: [],
            noticeData: {
                title: "",
                create_date: "",
                contents: "",
                creator: "",
                sources:"",
                publish_date: "",
                recipients: "",
                status: "草稿",
            },
            loadErr: false,
            loaded: false,
            id: this.props.id,
            tabKey: props.tabKey,
            noticeInfo: {},
            maskClosable: false,
            size: 'large',
            add: this.props.add,//是否为新增操作
            add_visible: false
        }

        this.handleCancel = this.handleCancel.bind(this)
        this.getNoticeInfoById = this.getNoticeInfoById.bind(this)
        this.initInfoPage = this.initInfoPage.bind(this)
        this.save = this.save.bind(this)
    }
    componentDidMount() {
        this.initInfoPage();
    }
    initInfoPage() {
        if (!this.state.add) {
            this.getNoticeInfoById();
        } else {
            this.noticeData['create_date'] = NoticeInfo.getNowFormatDate();
            this.noticeData['creator'] = this.props.curuser || "超级管理员";
            this.state.noticeInfo.publish_date = NoticeInfo.getTodayDate();
            this.setState({
                loaded: true
            })
        }
    }

    //获取信息

    getNoticeInfoById() {
        var _this = this;
        fetch('/api/notice/getNoticeInfoById/' + _this.state.id, {

            method: 'GET',
            headers: {
                "Content-Type": "application/json",
                "token": this.getAccessToken()
            },
            //发送到后台的数据放这边
        }).then((response) => {
            if (response.status != 200) {
                throw new Error('Fail to get response with status ' + response.status);
            } else {
                return response.json()
            }
        }).then((responseJson) => {
            if (responseJson.success) {
                console.log(responseJson.data)
                _this.setState({ noticeInfo: responseJson.data, loaded: true}, () => {
                    _this.noticeData = responseJson.data;
                });
            }
        }).catch((error) => {
            _this.setState({loadErr: true, loaded: false});
            console.log(error);
        });
    }
    save(value) {
        let _this = this;
        _this.noticeData['create_date'] = _this.state.noticeData.create_date
        _this.noticeData['creator'] = '超级管理员'
        console.log(_this.noticeData)
        this.saveOk(value);

    }
    // confirm(value){
    //     let msg = '';
    //     switch (value) {
    //         case 'save':
    //             msg = '保存'
    //             break;
    //         case 'submit':
    //             msg = '提交'
    //             break;
    //     }
            // Modal.confirm({
            //     title: '提示',
            //     content: '确认'+msg+'吗?',
            //     //onOk(){this.saveOk(value);},
            //     onOk:this.saveOk(value),
            //     onCancel(){console.log('cancel');},
            // })
        // }
     saveOk(value){
         let _this = this;
        fetch('/api/notice/saveNoticeInfo/'+value, {
            method: 'PUT',
            headers: {
                "Content-Type": "application/json",
                "token": this.getAccessToken(),
            },
            //发送到后台的数据放这边
            body: JSON.stringify(_this.noticeData)
        }).then((response) => {
            if (response.status !== 200) {
                throw new Error('Fail to get response with status ' + response.status);
            } else {
                response
                    .json()
                    .then((responseJson) => {
                        if (responseJson.success) {
                            if(value=='save'){
                                message.success("保存成功！");
                            }
                            if(value=='submit'){
                                message.success("提交成功！");
                            }
                            _this.setState({noticeInfo: responseJson.data, loaded: true}, () => {
                                _this.noticeData = responseJson.data;
                            });
                        } else {
                            message.error("保存失败！");
                        }
                    })
                    .catch((error) => {
                        message.error("保存失败！");
                        console.log(error);
                    });
            }
        }).catch((error) => {
            message.error("保存失败！");
        });

    }
    updatePerson(viewer) {
    this.formChange('recipients',viewer);
  };
    static getViewerIds(viewer) {
        let ids = [];
        let obj = [];
        try {
            obj = JSON.parse(viewer);
        } catch (error) {
            obj = [];
        }
        if (obj && obj.length > 0) {
            for (let i = 0; i < obj.length; i++) {
                ids.push(obj[i].id);
            }
            return ids;
        }
    }
    formChange = function (pro, val) {
        this.noticeData[pro] = val;
    }
    handleCancel() {
        this.props.closeTabs();
    }
    static getNowFormatDate() {
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
    static getTodayDate() {
        let date = new Date();
        const seperator1 = "-";
        let month = date.getMonth() + 1;
        let strDate = date.getDate();
        if (month >= 1 && month <= 9) {
            month = "0" + month;
        }
        if (strDate >= 0 && strDate <= 9) {
            strDate = "0" + strDate;
        }
        var currentdate = date.getFullYear() + seperator1 + month + seperator1 + strDate;

        return currentdate;
    }
//      onChange(date, dateString) {
//     console.log(date, dateString);
// }
    render(){
        let content = <span style={{color:'green'}}>数据加载中...</span>
        if(this.state.loadErr){
            content = <span style={{color :'red'}}>数据加载出错，请联系管理员</span>
        }
        else{
            if(this.state.loaded) {
                content=(
                            <Row>
                                <Col span={9}>
                                    <Form>
                                        <Row >
                                        <Col span={12}>
                                        <FormItem {...formItemLayout}
                                                  label="公告标题："
                                                  hasFeedback>
                                        <Input  prefix={<Icon type="edit" />}
                                        style={this.state.formControl}
                                                defaultValue={this.state.noticeInfo.title}
                                            onChange={(e) => {
                                            this.formChange('title', e.target.value)
                                        }}/>
                                        </FormItem>
                                        </Col>
                                        <Col span={12}>
                                            <FormItem {...formItemLayout}
                                                      label="创建时间："
                                                      hasFeedback>
                                        <Input prefix={<Icon type="clock-circle-o"/>}
                                                   disabled={true}
                                                   defaultValue={this.state.noticeInfo.create_time|| NoticeInfo.getNowFormatDate()}
                                                onChange={(e) => {
                                                this.formChange('create_date', e.target.value)
                                            }}/>
                                            </FormItem>
                                        </Col>
                                        </Row>
                                        <Row >
                                            <Col span={12}>
                                            <FormItem{...formItemLayout}
                                                     label="创建人："
                                                     hasFeedback>
                                            <Input prefix={<Icon type="user" />}
                                                   disabled={true}
                                                   defaultValue={this.state.noticeInfo.creator || '超级管理员'}
                                                onChange={(e) => {
                                                this.formChange('creator', e.target.value)
                                            }}/>
                                            </FormItem>
                                            </Col>


                                            <Col span={12}>
                                                <FormItem{...formItemLayout}
                                                         label="状态："
                                                         hasFeedback>
                                            <Input
                                                     defaultValue={this.state.noticeInfo.status ||'草稿'}
                                                     disabled={true}
                                                     >
                                            </Input>
                                                </FormItem>
                                            </Col>
                                        </Row>
                                        <Row >
                                            <Col span={12} >
                                                <FormItem{...formItemLayout}
                                                         label="来源："
                                                         hasFeedback>
                                            <Input
                                                defaultValue={this.state.noticeInfo.sources ||'页面新建'}
                                                disabled={true}
                                                onChange={(val) => {
                                                    this.formChange('sources', val)
                                                }}>
                                                {/*<Select.Option value="null"></Select.Option>*/}
                                                {/*<Select.Option value="页面新建">页面新建</Select.Option>*/}
                                                {/*<Select.Option value="接口调用">接口调用</Select.Option>*/}
                                            </Input>
                                                </FormItem>
                                            </Col>
                                            <Col span={12}>
                                                <FormItem{...formItemLayout}
                                                         label="发布时间："
                                                         hasFeedback>
                                            <DatePicker
                                                   defaultValue={moment(this.state.noticeInfo.publish_date, 'YYYY-MM-DD')}
                                                    onChange={(date,dateString) => {
                                                    this.formChange('publish_date', dateString)
                                                }}/>
                                                </FormItem>
                                            </Col>
                                        </Row>
                                        <Row>
                                            <Col span={24}>
                                                <FormItem labelCol={{ span: 3 }} wrapperCol={{ span: 21 }} label="接收人：">

                                            <SelectEmployee
                                                employees={NoticeInfo.getViewerIds(this.state.noticeInfo.recipients)}
                                                updatePerson={this.updatePerson.bind(this)}

                                            />

                                                </FormItem>
                                            </Col>
                                        </Row>
                                        <Row>
                                            <Col span={24}>
                                                <FormItem labelCol={{ span: 3 }} wrapperCol={{ span: 21 }}label="公告内容：" >
                                            <textarea rows={4}
                                                      cols={73}
                                                defaultValue={this.state.noticeInfo.contents}
                                                    onChange={(e) => {
                                                    this.formChange('contents', e.target.value)
                                                }}/>
                                                </FormItem>
                                            </Col>
                                        </Row>
                                        <Row>
                                            <Col>
                                                <div className="list-action">

                                                    <Button type="primary"  onClick={this.save.bind(this,'save')}>保存</Button>
                                                    <Button type="dashed" onClick={this.save.bind(this,'submit')}>提交</Button>
                                                    <Button type="danger"  onClick={this.handleCancel}>关闭</Button>
                                                </div>
                                            </Col>
                                        </Row>


                                    </Form>
                                </Col>
                            </Row>




                )
            }
        }
        return content
    }
}
export default NoticeInfo