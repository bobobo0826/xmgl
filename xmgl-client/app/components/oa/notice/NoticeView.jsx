import React from 'react'
import NoticeList from './NoticeList'
import {Row,Col,message, Input, Select,Form,Button} from 'antd';
 import NoticeInfo from './NoticeInfo.jsx';
import BaseComponent from '../../BaseComponent'
import factory from '../../ComponentFactory'
import {Tabs} from 'antd';
const TabPane = Tabs.TabPane;
let status = "";
let sources = "";
const Option = Select.Option;
const FormItem = Form.Item;
const formItemLayout = {
    labelCol: {sm: {span: 6},},
    wrapperCol: {sm: {span: 14},},
};

class NoticeView extends BaseComponent {

    constructor(props) {
        super(props);
        let _this = this;
        const panes = [];
        this.state = {
            dics: [],
            dics1: [],
            activeKey: "list",
            panes: panes,
            currentId: undefined,
            columns: [
                {
                    field: 'id', //同dategrid
                    hidden: true, //是否隐藏
                    name: 'ID', //表头名称
                    col: 1 
                }, {
                    field: 'title',
                    hidden: false,
                    name: '标题',
                    col: 1
                }, {
                    field: 'contents',
                    hidden: false,
                    name: '内容',
                    col: 4,
                }, {
                    field: 'status',
                    hidden: false,
                    name: '状态',
                    col: 1,
                }, {
                    field: 'sources',
                    hidden: false,
                    name: '来源',
                    col: 1
                },{
                    field: 'create_date',
                    hidden: false,
                    name: '创建时间',
                    col: 3


                } , {
                    field: 'creator',
                    hidden: false,
                    name: '创建人',
                    col: 1
                }, {
                    field: 'publish_date',
                    hidden: false,
                    name: '发布时间',
                    col: 3
                }, {
                    field: 'recipients',
                    hidden: false,
                    name: '接收人',
                    col: 2

                }, {
                    field: '',
                    hidden: false,
                    name: '操作',
                    col: 2,
                    formatter: function (row, data, index) {//显示操作按钮
                        return (
                            <div className="list-item-action">
                                <span onClick={() => {
                                    _this.editInfo(row.id, row.title)
                                }} className="ac-edit">编辑</span>
                                <span onClick={() => {
                                    _this.deleteInfo(row.id)
                                }} className="ac-delete">删除</span>
                            </div>
                        );
                    }
                }
            ],
            queryOption: {},//查询条件
            add: false,//弹框的编辑模式：新增、编辑
        }
        this.doQuery = this.doQuery.bind(this);
        this.doClear = this.doClear.bind(this);
        this.editInfo = this.editInfo.bind(this);
        this.doAdd = this.doAdd.bind(this);
        this.initStatusDic = this.initStatusDic.bind(this);
        this.initSourcesDic = this.initSourcesDic.bind(this);
        this.onCloseCurTabs = this.onCloseCurTabs.bind(this);
        this.handleChange = this.handleChange.bind(this);
        this.onChange = this.onChange.bind(this);
        this.remove = this.remove.bind(this);
        this.onEdit = this.onEdit.bind(this);
    }
    doQuery = function () {
        this.setState({
            add: false,
            forceUpdate: true
        });
    }

    onChange(activeKey) {
        let forceUpdate = "";
        if (activeKey == "list") {
            forceUpdate = true;
        } else {
            forceUpdate = false;
        }
        this.setState({
            forceUpdate,
            activeKey
        });
    }

    remove(targetKey) {
        let activeKey = this.state.activeKey;
        let lastIndex;
        this.state.panes.forEach((pane, i) => {
            if (pane.key === targetKey) {

                lastIndex = i - 1;
            }
        });
        const panes = this.state.panes.filter(pane => pane.key !== targetKey);
        if (lastIndex >= 0 && activeKey === targetKey) {
            activeKey = panes[lastIndex].key;
        } else {
            activeKey = "list";
        }
        this.setState({panes, activeKey});
    }

    doClear = function () {
        this.setState({
            add: false,
            queryOption: {
                resource_type: '',
                operator: '',
                resource_name: '',
                res_type_name: ''
            }
        }, () => {
            this.setState({
                forceUpdate: true
            })
        });
    }

    onCloseCurTabs() {
        this.remove(this.state.activeKey);
    }

    editInfo = function (id,name) {
        const activeKey = `notice${id}`;
        const add = false;
        const title = `查看${name}详情`;
        this.addOrChangeTabs(activeKey, id, add, title)
    }

    doAdd = function () {
        const panes = this.state.panes;
        const activeKey = `noticeNew`;
        const id = -1;
        const add = true;
        const title = `新增公告详情`;
        this.addOrChangeTabs(activeKey, id, add, title);
    }

    addOrChangeTabs(activeKey, id, add, title) {
        const panes = this.state.panes;
        let isExist = false;
        console.log("newTab index :" + activeKey);
        for (let i = 0; i < panes.length; i++) {
            if (activeKey == panes[i].key) {
                isExist = true;
            }
        }
        if (isExist) {
            this.setState({activeKey});
        } else {
            panes.push({
                title: title,
                content: <NoticeInfo
                            add={add}
                            id={id}
                            closeTabs={this.onCloseCurTabs.bind(this)}
                        />,
                key: activeKey
            });
            this.setState({add, panes, forceUpdate: false, activeKey});
        }
    }

    deleteInfo = function (id) {
        fetch('/api/notice/delNotice/' + id, {
            method: 'DELETE',
            headers: {
                "Content-Type": "application/json",
                token: this.getAccessToken(),
            },
        }).then((response) => {
            if (!response.ok || !response.status == 200) {
                message.error("删除失败！");
            } else {
                this.setState({
                    forceUpdate: true,
                    currentId: undefined,
                    add: false
                })
                message.success("删除成功！");
            }
        })
    }


    initStatusDic = function () {
        let _this = this;
        fetch('/api/notice/getNoticeStatus', {
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
            _this.setState({
                dics: obj.map((item) => {
                    return (
                        <Option key={item.data_name}>{item.data_name}</Option>
                    )
                })
            });
        }).catch((error) => {
            console.log(error)
        });
    }

    initSourcesDic = function () {
        let _this = this;
        fetch('/api/notice/getNoticeSources', {
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
            _this.setState({
                dics1: obj.map((item) => {
                    return (
                        <Option key={item.data_name}>{item.data_name}</Option>
                    )
                })
            });
        }).catch((error) => {
            console.log(error)
        });
    }

    onEdit(targetKey, action) {
        this[action](targetKey);
    }
    handleChange = function (value,key) {
        console.log('aaaa>>>>>>>>>>>>' + value)
        var obj = this.state.queryOption
        obj[key] = value
        this.setState({
            forceUpdate: false,
            queryOption: obj
        })
    };


    componentDidMount() {
        this.initStatusDic();
        this.initSourcesDic();
    }


    render() {
        var noticeList = (
            <div>
                <Row gutter={64}>
                    <Col sm={8}>
                        <FormItem {...formItemLayout} label={`标题：`}>
                            <Input
                                placeholder="标题"
                                value={this.state.queryOption.title}
                                onChange={(e) => {
                                    this.handleChange(e.target.value, 'title')
                                }}
                            />
                        </FormItem>
                    </Col>
                    <Col sm={8}>
                        <FormItem {...formItemLayout} label={`来源：`}>
                            <Select
                                defaultValue=""
                                value={this.state.queryOption.sources}
                                style={{width: '100%'}}
                                onChange={(val) => {
                                    this.handleChange(val, 'sources')
                                }}
                                allowClear
                            >
                                {this.state.dics1}
                            </Select>
                        </FormItem>
                    </Col>
                    <Col sm={8}>
                        <FormItem {...formItemLayout} label={`状态：`}>
                            <Select
                                defaultValue=""
                                value={this.state.queryOption.status}
                                style={{width: '100%'}}
                                onChange={(val) => {
                                    this.handleChange(val, 'status')
                                }}
                                allowClear
                            >
                                {this.state.dics}
                            </Select>
                        </FormItem>
                    </Col>
                    <Col sm={8}>
                        <FormItem {...formItemLayout} label={`创建人：`}>
                            <Input
                                placeholder="创建人"
                                value={this.state.queryOption.creator}
                                onChange={(e) => {
                                    this.handleChange(e.target.value, 'creator')
                                }}
                            />
                        </FormItem>
                    </Col>
                </Row>
                <Row>
                    <Col sm={8} offset={8}>
                        <Button size="large" icon="plus" onClick={this.doAdd}>添加</Button>
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <Button type="primary" size="large" icon="search" onClick={this.doQuery}>查询</Button>
                        &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <Button type="danger" size="large" icon="reload" onClick={this.doClear}>清空</Button>
                    </Col>
                </Row>
                <NoticeList
                    columns={this.state.columns}
                    toolbox={this.state.toolbox}
                    queryOption={this.state.queryOption}
                    forceUpdate={this.state.forceUpdate}
                    url="/api/notice/getNoticeList"/>

            </div>

        );
        return (
            <Tabs
                hideAdd
                onChange={this.onChange}
                activeKey={this.state.activeKey}
                type="editable-card"
                onEdit={this.onEdit}
            >
                <TabPane tab='公告管理' key='list' closable='false'>{noticeList} </TabPane>
                {this.state.panes.map(pane => <TabPane tab={pane.title} key={pane.key}>{pane.content}</TabPane>)}
            </Tabs>

        )




    }





}

factory.register('NoticeList',<NoticeView />)


