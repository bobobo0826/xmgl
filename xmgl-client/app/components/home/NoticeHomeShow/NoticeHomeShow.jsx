import React from 'react'
import { Link } from 'react-router'
import { Modal, Card , Row , Button  , Form, Col, Input  } from 'antd'
import "./NoticeHomeShowStyle.scss"
import NoticeList from '../../oa/notice/NoticeView'
import factory from '../../ComponentFactory'
import BaseComponent from '../../BaseComponent'
import { History, browserHistory } from 'react-router'
const FormItem = Form.Item;
const { TextArea } = Input;
const formItemLayout = {
    labelCol: {span: 8},
    wrapperCol: {span: 16},
};

class NoticeHomeShow  extends BaseComponent{
    constructor(props) {
        super(props);
        this.state = {
            list: [],
            visible: false,
            show:'',
            NoticeData: {
                title: '',
                creator: '',
                create_date: '',
                publish_date: '',
                contents: '',
                recipients: ''
            }
        }
        this.selectValue = this.selectValue.bind(this)
        this.doClick = this.doClick.bind(this)
        this.closeView = this.closeView.bind(this)
        this.showList = this.showList.bind(this)
        this.getNowFormatDate = this.getNowFormatDate.bind(this)
    }

    //查询数据
    selectValue(){
        var _this = this;
        fetch('/api/notice/getNoticeLists', {
            method: 'POST',
                headers: {
                "Content-Type": "application/json",
                    token: this.token,
            },
            //发送到后台的数据放这边
        }).then((response) => {
            if (response.status !== 200) {
                throw new Error('Fail to get response with status ' + response.status);
            }
            response.json().then((responseJson) => {
                this.getJsonValue(responseJson,"name")
                let NowDate=this.getNowFormatDate()
                let show = <p className="no_notice">暂无公告</p>
                if (responseJson && responseJson.length >0) {
                    show = responseJson.map((item)=>{
                    let dot = ''
                    if(item.publish_date == NowDate){
                        dot = " notice-new"
                    }
                    let html= 
                        (<Row className="notice-item"  key={item.title}>
                            <Col className={"notice-title"} span={18} onClick={()=>this.doClick(item.title,item.creator,item.create_date,item.publish_date,item.contents,item.recipients)}>
                                {item.title}
                            </Col>
                            <Col className={dot} span={6}>
                                {item.publish_date}
                            </Col>
                        </Row>)
                        return html
                    })
                }
                _this.setState({
                    list: responseJson,
                    show : show
                });
            })
        }).catch((error) =>{
            console.log(error);
            })
    }

    //解析json中的字段，以"，"号分隔
    getJsonValue(responseJson,value) {
        for(let i=0;i<responseJson.length;i++){
            let recipients=JSON.parse(responseJson[i].recipients)
            let field=""
            for(let k=0;k<recipients.length;k++){
                field+=recipients[k][value]+","
            }
            responseJson[i].recipients=field.substring(0,field.length-1)
        }
        return responseJson
    }

    //单击获取map中的参数
    doClick (title,creator,create_date,publish_date,contents,recipients){
        console.log(title)
        this.setState({
            NoticeData : 
            {
                title:title,
                creator:creator,
                create_date:create_date,
                publish_date:publish_date,
                contents:contents,
                recipients:recipients
            },  
            visible: true
        })
    }
    //关闭弹窗
    closeView() {
        this.setState({
            visible: false
        });
    }

    //获取系统当前时间
    getNowFormatDate() {
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

    //页面跳转
    showList() {
        alert("待完成...")
        /*return(
            <NoticeList />)
        this.props.browserHistory.push('../../notice/notice/NoticeList')
        this.props.history.pushState(null, '../../notice/notice/NoticeList')*/

    }
    //模版渲染挂载之后回调事件
    componentDidMount(){
        this.selectValue();
    }

    render() {

        return (
            <div className="main_div" >
                <Card title="公告" className="notice-list" >
                    {this.state.show}
                </Card>
                <Modal
                    title={<span className="model-title">公告详情</span>}
                    visible={this.state.visible}
                    onCancel={this.closeView}
                    cancelText="关闭"
                    width="640px"
                    footer={<Button type="button" className="btn btn-danger" onClick={this.closeView}>关闭</Button>}
                    >
                    <div className="notice-info">
                        <div className="notice-title">{this.state.NoticeData.title}</div>
                        <div className="notice-ps">
                            <span>发布人：{this.state.NoticeData.creator}</span>
                            <span>发布时间：{this.state.NoticeData.publish_date}</span>
                        </div>
                        <div className="notice-content">{this.state.NoticeData.contents || '暂无内容'}</div>
                    </div>
                </Modal>
            </div>


        );
    }
}
export default NoticeHomeShow

