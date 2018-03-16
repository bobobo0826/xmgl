import React from 'react'

import ResourcesList from './ResourcesList';
import {Form, Row, Col, message, Input, Select, Button} from 'antd';
import BaseComponent from '../../BaseComponent'
import ResourcesInfo from './ResourcesInfo.jsx'
import factory from '../../ComponentFactory'
import ResHistoryView from './ResHistoryView';

import {Tabs} from 'antd';
const TabPane = Tabs.TabPane;
const Option = Select.Option;
const FormItem = Form.Item;
const formItemLayout = {
    labelCol: {sm: {span: 6},},
    wrapperCol: {sm: {span: 14},},
};

let curUserId;
let curUserName;
let curUserDisplayName;
class ResourcesView extends BaseComponent {
    constructor(props) {
        super(props);
        var _this = this;
        const panes = [];
        this.state = {
            activeKey: "list",
            panes: panes,
            currentId: undefined,
            columns: [
                {
                    field: 'id', //同dategrid
                    hidden: true, //是否隐藏
                    name: 'ID', //表头名称
                    col: 2,
                }, {
                    field: 'name',
                    hidden: false,
                    name: '资源名称',
                    col: 4,
                }, {
                    field: 'res_type_name',
                    hidden: false,
                    name: '资源类别',
                    col: 2,
                }, {
                    field: 'res_desc',
                    hidden: false,
                    name: '资源描述',
                    col: 4,
                },
                {
                    field: 'viewer',
                    hidden: false,
                    name: '维护人',
                    col: 4,
                    formatter: function (row, data, index) {
                        var ids = [];
                        if (data) {
                            let dataArray = [];
                            try {
                                dataArray = JSON.parse(data);
                            } catch (error) {
                                dataArray = [];
                                return data;
                            }
                            if (dataArray && dataArray.length > 0) {
                                for (var i = 0; i < dataArray.length; i++) {
                                    ids.push(dataArray[i].name);
                                }
                            }
                            return ids.join(',');
                        } else {
                            return ids;
                        }
                    }
                }, {
                    field: 'operator',
                    hidden: false,
                    name: '操作人',
                    col: 2,
                }, {
                    field: 'operate_time',
                    hidden: false,
                    name: '操作时间',
                    col: 4,
                }, {
                    field: '',
                    hidden: false,
                    name: '操作',
                    col: 4,
                    formatter: function (row, data, index) {//显示操作按钮
                        return (
                            <div className="list-item-action">
                                <span onClick={() => {
                                    _this.editInfo(row.id, row.name)
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
            add: true,//弹框的编辑模式：新增、编辑

        }
        this.doQuery = this.doQuery.bind(this);
        this.editInfo = this.editInfo.bind(this);
        this.doAdd = this.doAdd.bind(this);
        this.getResTypeDic = this.getResTypeDic.bind(this);
        this.handleChange = this.handleChange.bind(this);
        this.doClear = this.doClear.bind(this);
        this.onChange = this.onChange.bind(this);
        this.onEdit = this.onEdit.bind(this);
        this.onCloseCurTabs = this.onCloseCurTabs.bind(this);
        this.remove = this.remove.bind(this);
        this.historyTabs = this.historyTabs.bind(this)
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

    onEdit(targetKey, action) {
        this[action](targetKey);
    }

    onCloseCurTabs() {
        this.remove(this.state.activeKey);
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

    doQuery() {
        this.setState({
            add: false,
            forceUpdate: true
        });
    }

    doAdd() {
        const panes = this.state.panes;
        const activeKey = `resourceNew`;
        const id = -1;
        const add = true;
        const title = `新增资源`;
        this.addOrChangeTabs(activeKey, id, add, title);

    }


    editInfo(id, name) {
        const activeKey = `resource${id}`;
        const add = false;
        const title = `${name}`;
        this.addOrChangeTabs(activeKey, id, add, title)
    }

    addOrChangeTabs(activeKey, id, add, title) {
        const panes = this.state.panes;
        let isExist = false;
        for (let i = 0; i < panes.length; i++) {
            if (activeKey == panes[i].key) {
                isExist = true;
            }
        }
        if (isExist) {
            this.setState({activeKey});
        } else {
            let pane = {
                title: title,
                content: <ResourcesInfo
                    add={add}
                    id={id}
                    curUserName={curUserDisplayName}
                    closeTabs={this.onCloseCurTabs.bind(this)}
                    historyTabs = {this.historyTabs.bind(this)}
                />,
                key: activeKey
            }
            panes.push(pane);

            this.setState({add, panes, forceUpdate: false, activeKey});
        }
    }

    historyTabs(activeKey, title, queryOption) {
        const panes = this.state.panes;
        let isExist = false;
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
                content: <ResHistoryView
                    // toolbox={this.state.toolbox}
                    queryOption={queryOption}
                    url="/api/resource/queryResHistory"/>,
                key: activeKey
            });
            this.setState({panes, forceUpdate: false, activeKey});
        }
    }
    deleteInfo(id) {
        fetch('/api/resource/delRes/' + id, {
            method: 'DELETE',
            headers: {
                "Content-Type": "application/json",
                "token": this.getAccessToken()
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
            _this.setState({
                resTypeDic: obj.map((item) =>
                    <Option key={item.data_code}>{item.data_name}</Option>
                )
            });
        }).catch((error) => {
            console.log(error)
        });
    }

    handleChange(value, key) {
        var obj = this.state.queryOption
        obj[key] = value
        this.setState({
            forceUpdate: false,
            queryOption: obj
        })
    }

    componentDidMount() {
        this.getResTypeDic();
        this.getCurUser();
    }

    doClear() {
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

    getCurUser() {
        fetch('/api/resource/getCurUser/', {
            method: 'GET',
            headers: {
                "Content-Type": "application/json",
                "token": this.getAccessToken()
            },
        }).then((response) => {
            if (response.status !== 200) {

            } else {
                response
                    .json()
                    .then((responseJson) => {
                        if (responseJson.success) {
                            if (responseJson.curUser) {
                                curUserId = responseJson.curUser.id;
                                curUserDisplayName = responseJson.curUser.displayName;
                                curUserName = responseJson.curUser.name;
                            }
                        } else {

                        }
                    })
            }
        })
    }

    render() {
        let resourceList = (
            <div>
                <Row gutter={64}>
                    <Col sm={8}>
                        <FormItem {...formItemLayout} label={`资源名称：`}>
                            <Input
                                placeholder="资源名称"
                                value={this.state.queryOption.resource_name}
                                onChange={(e) => {
                                    this.handleChange(e.target.value, 'resource_name')
                                }}
                            />
                        </FormItem>
                    </Col>
                    <Col sm={8}>
                        <FormItem {...formItemLayout} label={`资源类别：`}>
                            <Select
                                defaultValue=""
                                value={this.state.queryOption.resource_type}
                                style={{width: '100%'}}
                                onChange={(val) => {
                                    this.handleChange(val, 'resource_type')
                                }}
                                allowClear
                            >
                                {this.state.resTypeDic}
                            </Select>
                        </FormItem>
                    </Col>
                    <Col sm={8}>
                        <FormItem {...formItemLayout} label={`操作人：`}>
                            <Input
                                placeholder="操作人"
                                value={this.state.queryOption.operator}
                                onChange={(e) => {
                                    this.handleChange(e.target.value, 'operator')
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
                <ResourcesList
                    columns={this.state.columns}
                    toolbox={this.state.toolbox}
                    queryOption={this.state.queryOption}
                    forceUpdate={this.state.forceUpdate}
                    url="/api/resource/queryResList"/>
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
                <TabPane tab='资源管理' key='list' closable='false'>{resourceList} </TabPane>
                {this.state.panes.map(pane => <TabPane tab={pane.title} key={pane.key}>{pane.content}</TabPane>)}
            </Tabs>

        )
    }

}
factory.register('ResourcesView',<ResourcesView />)
