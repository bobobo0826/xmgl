import React from 'react';
import {Modal, message, Button, Input, Row, Col, Transfer, Select, Collapse, Form} from 'antd';//引入控件
import  "../../../styles/public/css/info.scss"
import SelectEmployee from '../../public/selects/SelectEmployee';
import AddContent from './AddContent';
import BaseComponent from '../../BaseComponent'
const {Option, OptGroup} = Select;
const {TextArea} = Input;
const Panel = Collapse.Panel;
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
const addContentLayout = {
    labelCol: {
        xs: {span: 24},
        sm: {span: 6},
    },
    wrapperCol: {
        xs: {span: 24},
        sm: {span: 16},
    },
};
const largeFormItemLayout = {
    labelCol: {
        xs: {span: 24},
        sm: {span: 3},
    },
    wrapperCol: {
        xs: {span: 24},
        sm: {span: 18},
    },
};


class ResourcesInfo extends BaseComponent {
    resData = {};
    addData = [];

    constructor(props) {
        super(props);
        this.state = {
            addElement: [],//添加的信息展示（reactElement）
            loadErr: false,
            loaded: false,
            id: this.props.id,
            tabKey: props.tabKey,
            resourcesInfo: {},
            maskClosable: false,
            size: 'large',
            formControl: {
                width: 150,
            },
            add: this.props.add,//是否为新增操作
            add_visible: false,
            queryOption: {res_id: this.props.id},
            nameIsExist: "",
            nameInfo: "",
            typeIsExist: "",
            typeInfo: "",
            descriptionIsExist: "",
            descriptionInfo: "",
        }
        this.getResTypeDic = this.getResTypeDic.bind(this);
        this.getResourcesInfo = this.getResourcesInfo.bind(this)
        this.handleCancel = this.handleCancel.bind(this)
        this.save = this.save.bind(this)
        this.addContent = this.addContent.bind(this)
        this.addContentChange = this.addContentChange.bind(this)
        this.getNamesByIds = this.getNamesByIds.bind(this)
        this.initInfoPage = this.initInfoPage.bind(this)
        this.getOptions = this.getOptions.bind(this);
        this.getResByType = this.getResByType.bind(this);
        this.visitHistory = this.visitHistory.bind(this);

    }

    componentDidMount() {
        this.getResTypeDic();
    }

    initInfoPage() {
        if (!this.state.add) {
            this.getResourcesInfo();
        } else {
            this.resData['operate_time'] = ResourcesInfo.getNowFormatDate();
            this.resData['operator'] = this.props.curUser || "超级管理员";
            this.setState({
                loaded: true
            })
        }
    }

    //获取信息
    getResourcesInfo() {
        var _this = this;
        fetch('/api/resource/getResInfoById/' + _this.state.id, {
            method: 'GET',
            headers: {
                "Content-Type": "application/json",
                "token": this.getAccessToken()
            },
            //发送到后台的数据放这边
        }).then((response) => {
            if (response.status !== 200) {
                throw new Error('Fail to get response with status ' + response.status);
            } else {
                return response.json()
            }
        }).then((responseJson) => {
            if (responseJson.success) {
                let addElement = [];
                if (responseJson.data.content) {
                    this.addData = JSON.parse(responseJson.data.content);
                    addElement = this.getAddContentArea(responseJson.data.content);
                }
                _this.setState({addElement, resourcesInfo: responseJson.data, loaded: true}, () => {
                    _this.resData = responseJson.data;
                });
            }
        }).catch((error) => {
            _this.setState({loadErr: true, loaded: false});
            console.log(error);
        });
    }

    //获取 添加信息区域
    getAddContentArea(content) {
        let addElement = this.state.addElement;
        let contentArray = [];
        if (content) {
            try {
                contentArray = JSON.parse(content);
            } catch (error) {
                console.log("content 转换数组失败！");
                console.log(error);
                contentArray = [];
            }
            contentArray.map(item => {
                addElement.push(this.generateElement(item.add_key, item.add_type, item.add_value));
            })
        } else {
            addElement = [];
        }
        return addElement;
    }

    generateElement(key, type, value) {
        let element;
        switch (type) {
            case "ZDYZD":
                element =
                    <Input
                        placeholder={key}
                        defaultValue={value}
                        onChange={(e) => {
                            this.addContentChange(key, e.target.value);
                        }}
                    />
                break;
            case "GLZD":
                element =
                    <Select
                        mode="multiple"
                        defaultValue={value}
                        onChange={(e) => {
                            this.addContentChange(key, e.target.value);
                        }}
                    >
                        {this.state.resList}
                    </Select>
                break;
            default:
                break;
        }
        return (
            <Col sm={8}>
                <Row>
                    <FormItem
                        {...addContentLayout}
                        label={key}>
                        <Col span={10}>
                            {element}
                        </Col>
                        <Col span={2} offset={1}>
                            <Button type="danger" size="small" onClick={() => {
                                this.deleteContent(key)
                            }
                            }>删除</Button>
                        </Col>
                    </FormItem>
                </Row>
            </Col>);
    }

    deleteContent(key) {
        let addElement = this.state.addElement;
        console.log("deleteContent");
        for (let i = 0; i < this.addData.length; i++) {
            if (this.addData[i].add_key === key) {
                this.addData.splice(i, 1);
                addElement.splice(i, 1);
                break;
            }
        }
        this.setState({
            addElement,
            add_visible: false
        })
    }

    validate() {
        if (!this.resData.name) {
            this.setState({
                nameIsExist: "error",
                nameInfo: "资源简称必填！"
            })
        }
        if (!this.resData.res_type) {
            this.setState({
                typeIsExist: "error",
                typeInfo: "资源类型必填！"
            })
        }
        if (!this.resData.res_desc) {
            this.setState({
                descriptionIsExist: "error",
                descriptionInfo: "资源描述必填！"
            })
        }
    }

    save() {
        let _this = this;
        if (!this.resData.name || !this.resData.res_type || !this.resData.res_desc) {
            this.validate();
            return;
        }
        _this.resData["content"] = JSON.stringify(this.addData);
        fetch('/api/resource/saveResInfo', {
            method: 'PUT',
            headers: {
                "Content-Type": "application/json",
                "token": this.getAccessToken()
            },
            //发送到后台的数据放这边
            body: JSON.stringify(_this.resData)
        }).then((response) => {
            if (response.status !== 200) {
                throw new Error('Fail to get response with status ' + response.status);
            } else {
                response
                    .json()
                    .then((responseJson) => {
                        console.log('after save--------' + JSON.stringify(responseJson));
                        if (responseJson.success) {
                            message.success("保存成功！");
                            _this.setState({
                                add_visible: false,
                                resourcesInfo: responseJson.data,
                                loaded: true
                            }, () => {
                                _this.resData = responseJson.data;
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
            console.log(error);
        });
    }

    getResTypeDic() {
        let _this = this;
        fetch('/api/resource/getResTypeDic', {
            method: 'GET',
            headers: {
                "Content-Type": "application/json",
                token: this.getAccessToken(),
            },
        }).then((response) => {
            if (!response.ok || !response.status == 200) {
                return new Promise(function (succeed, failed) {
                    failed("查询数据出错")
                })
            }
            else {
                return response.json()
            }
        }).then(function (obj) {
            let opt = obj.map((item) =>
                <Option key={item.data_code}>{item.data_name}</Option>
            )
            console.log("==opt==" + JSON.stringify(opt))
            _this.setState({
                resTypeList: obj,
                resTypeDic: opt
            }, () => {
                _this.initInfoPage()
                _this.getOptions()
            });
        }).catch((error) => {
            console.log(error)
        });
    }

    formChange(pro, val) {
        this.resData[pro] = val;
        if (pro === "name") {
            if (!val) {
                this.setState({
                    nameIsExist: "error",
                    nameInfo: "资源简称必填！",
                })
            } else {
                this.setState({
                    nameIsExist: "",
                    nameInfo: "",
                })
            }
        } else if (pro === "res_type") {
            if (!val) {
                this.setState({
                    typeIsExist: "error",
                    typeInfo: "资源类型必填！",
                })
            } else {
                this.setState({
                    typeIsExist: "",
                    typeInfo: "",
                })
            }
        } else if (pro === "res_desc") {
            if (!val) {
                this.setState({
                    descriptionIsExist: "error",
                    descriptionInfo: "资源描述必填！",
                })
            } else {
                this.setState({
                    descriptionIsExist: "",
                    descriptionInfo: "",
                })
            }
        }

    }

    //点击模式窗口X回调方法
    handleCancel() {
        this.props.closeTabs();
    }

    updatePerson(viewer) {
        this.formChange('viewer', viewer);
    };

    addContent() {
        this.setState({
            add_visible: true
        })
    }

    componentWillReceiveProps(props) {
        console.log('cuiwei>>>' + JSON.stringify(props))
    }

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

    //更新添加内容区域
    updateAddContentArea(add_key, add_type, add_value) {
        console.log(add_value);
        let _this = this;
        this.addData.push({add_key: add_key, add_type: add_type, add_value: add_value});
        let addElement = _this.state.addElement;
        console.log(add_value);
        addElement.push(this.generateElement(add_key, add_type, add_value));
        this.setState({
            addElement,
            add_visible: false
        })
    }

    addContentChange(key, value) {
        let addData = this.addData;
        console.log(key);
        console.log(value);
        for (let i = 0; i < addData.length; i++) {
            if (addData[i].add_key == key) {
                addData[i].add_value = value;
                break;
            }
        }
        this.addData = addData;
    }

    getNamesByIds(idList, callback) {
        let nameList = [];
        fetch('/api/resource/getNamesByIds/' + idList, {
            method: 'GET',
            headers: {
                "Content-Type": "application/json",
                token: this.getAccessToken(),
            },
        }).then((response) => {
            if (!response.ok || !response.status == 200) {
                return new Promise(function (succeed, failed) {
                    failed("getNamesByIds()查询数据出错")
                })
            } else {
                return response.json()
            }
        }).then((obj) => {
            obj.map(item =>
                nameList.push(item.res_name)
            )
            callback(nameList)
        }).catch(error => {
            console.log(error)
        });
    }

    getOptions() {
        let _this = this;
        let options = [];
        if (_this.state.resTypeList) {
            _this.state.resTypeList.map((item) => {
                let opts = this.getResByType(item.data_code)
                console.log("after return opts" + opts)
                options.push(<OptGroup key={item.data_code} label={item.data_name}>{opts}</OptGroup>)
            })
        }
        _this.setState({
            resList: options
        })
    }

    getResByType(type) {
        let opts = []
        fetch('/api/resource/getResByType/' + type, {
            method: 'GET',
            headers: {
                "Content-Type": "application/json",
                token: this.getAccessToken(),
            },
        }).then((response) => {
            if (!response.ok || !response.status == 200) {
                return new Promise(function (succeed, failed) {
                    failed("查询数据出错")
                })
            }
            else {
                return response.json()
            }
        }).then(function (obj) {
            obj.map((item) =>
                opts.push(<Option key={item.data_id}>{item.data_name}</Option>)
            )
            console.log("in getResByType")
            console.log(opts)
        }).catch((error) => {
            console.log(error)
        });
        return opts;
    }


    visitHistory() {
        let _this = this;
        console.log("===this.queryOption====" + this.state.queryOption)
        const activeKey = `res_history${_this.state.id}`;
        const title = `查看${_this.state.resourcesInfo.name}历史`;
        this.props.historyTabs(activeKey, title, this.state.queryOption)
    }

    render() {
        let buttons = <div></div>
        if (!this.state.add) {
            buttons = (<div className="list-action">
                <Button onClick={this.visitHistory}>查看历史</Button >
                <Button type="primary" onClick={this.save}>保存</Button >
                <Button type="danger" onClick={this.handleCancel}>关闭</Button >
            </div>)
        } else {
            buttons = (<div className="list-action">
                <Button type="primary" onClick={this.save}>保存</Button >
                <Button type="danger" onClick={this.handleCancel}>关闭</Button >
            </div>)
        }
        let content = <span style={{color: 'blue'}}>数据加载中...</span>
        // 关于select、input、DatePicker等控件使用参见https://ant.design/components/date-picker-cn/
        if (this.state.loadErr) {
            content = (<span style={{color: 'blue'}}>数据加载出错！</span>)
        } else {
            if (this.state.loaded) {
                content = (
                    <div>
                        <div className="info-panel ">
                            <Collapse bordered={false} defaultActiveKey={['1']}>
                                <Panel header="基本信息" key="1">
                                    <Form >
                                        <Row >
                                            <Col sm={14}>
                                                <Row>
                                                    <Col sm={12}>
                                                        <FormItem
                                                            {...formItemLayout}
                                                            validateStatus={this.state.nameIsExist}
                                                            help={this.state.nameInfo}
                                                            label="资源名称："
                                                            hasFeedback
                                                        >
                                                            <Input
                                                                placeholder="资源名称"
                                                                defaultValue={this.state.resourcesInfo.name}
                                                                onChange={(e) => {
                                                                    this.formChange('name', e.target.value)
                                                                }}
                                                            />
                                                        </FormItem>
                                                    </Col>
                                                    <Col sm={12}>
                                                        <FormItem
                                                            {...formItemLayout}
                                                            validateStatus={this.state.typeIsExist}
                                                            help={this.state.typeInfo}
                                                            label="资源类别："
                                                            hasFeedback
                                                        >
                                                            <Select defaultValue={this.state.resourcesInfo.res_type}
                                                                    allowClear={true}
                                                                    onChange={(val) => {
                                                                        this.formChange('res_type', val)
                                                                    }}>
                                                                {this.state.resTypeDic}
                                                            </Select>
                                                        </FormItem>
                                                    </Col>
                                                    <Col sm={12}>
                                                        <FormItem
                                                            {...formItemLayout}
                                                            label="操作人："
                                                            hasFeedback
                                                        >
                                                            <Input
                                                                placeholder="操作人"
                                                                disabled={true}
                                                                defaultValue={this.state.resourcesInfo.operator || '超级管理员'}
                                                                onChange={(e) => {
                                                                    this.formChange('operator', e.target.value)
                                                                }}
                                                            />
                                                        </FormItem>
                                                    </Col>
                                                    <Col sm={12}>
                                                        <FormItem
                                                            {...formItemLayout}
                                                            label="操作时间："
                                                            hasFeedback
                                                        >
                                                            <Input
                                                                placeholder="操作时间"
                                                                disabled={true}
                                                                defaultValue={this.state.resourcesInfo.operate_time || ResourcesInfo.getNowFormatDate()}
                                                                onChange={(e) => {
                                                                    this.formChange('operate_time', e.target.value)
                                                                }}
                                                            />
                                                        </FormItem>
                                                    </Col>
                                                    <Col sm={24}>
                                                        <FormItem
                                                            {...largeFormItemLayout}
                                                            validateStatus={this.state.descriptionIsExist}
                                                            help={this.state.descriptionInfo}
                                                            label="描述："
                                                            hasFeedback
                                                        >
                                            <TextArea
                                                size={this.state.size}
                                                rows={6}
                                                placeholder="资源描述"
                                                defaultValue={this.state.resourcesInfo.res_desc || ''}
                                                onChange={(e) => {
                                                    this.formChange('res_desc', e.target.value)
                                                }}
                                            />
                                                        </FormItem>
                                                    </Col>
                                                </Row>
                                            </Col>
                                            <Col sm={10}>

                                                <FormItem
                                                    {...largeFormItemLayout}
                                                    label="维护人员："
                                                    hasFeedback
                                                >
                                                    <SelectEmployee
                                                        employees={ResourcesInfo.getViewerIds(this.state.resourcesInfo.viewer)}
                                                        updatePerson={this.updatePerson.bind(this)}/>
                                                </FormItem>
                                            </Col>
                                        </Row>
                                    </Form>

                                </Panel>
                                <Panel header="添加信息" key="2">
                                    <Row className="add-info-button">
                                        <Col sm={4} offset={2}>
                                            <Button type="primary" onClick={this.addContent}>添加信息</Button>
                                        </Col>
                                    </Row>
                                    <Form layout="horizontal">
                                        <Row>
                                            {this.state.addElement}
                                        </Row>
                                    </Form>
                                </Panel>
                            </Collapse>
                        </div>
                        {buttons}
                        <AddContent add_visible={this.state.add_visible} resList={this.state.resList}
                                    updateAddContentArea={this.updateAddContentArea.bind(this)}/>
                    </div>)
            }

        }
        return content
    }
}

export default ResourcesInfo

