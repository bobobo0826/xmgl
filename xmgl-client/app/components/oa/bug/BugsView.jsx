import React from 'react'
import BugsList from './BugsList'
import {Row,Col,message, Input, Select,Form,Button} from 'antd';
import BugsInfo from './BugsInfo.jsx';
import BaseComponent from '../../BaseComponent'
import factory from '../../ComponentFactory'
import {ListButton} from '../../public';
let status = "";
const Option = Select.Option;
const FormItem = Form.Item;

class BugsView extends BaseComponent {

    constructor(props) {
        super(props);
        let _this = this;
        this.state = {
            dics: [],
            currentId: undefined,
            columns: [
                 {
                    field: 'project',
                    hidden: false,
                    name: '所属项目',
                    col: 4,
                    formatter: function (row, data, index) {
                        let name = "";
                        if (data) {
                            name =  data.split(",")[1]
                        }
                        return name;
                    }
                }, {
                    field: 'module',
                    hidden: false,
                    name: '所属模块',
                    col: 4,
                }, {
                    field: 'description',
                    hidden: false,
                    name: 'bug简述',
                    col: 4,
                }, {
                    field: 'create_date',
                    hidden: false,
                    name: '创建时间',
                    col: 3
                }, {
                    field: 'creator',
                    hidden: false,
                    name: '创建人',
                    col: 2
                }, {
                    field: 'status',
                    hidden: false,
                    name: '状态',
                    col: 2
                }, {
                    field: 'responsible_person',
                    hidden: false,
                    name: '负责人',
                    col: 3,
                    formatter: function (row, data, index) {
                        let name = "";
                        if (data) {
                            let dataArray = data.split(",")
                            for (let x in dataArray) {
                                name += dataArray[x].split("~")[2] ? dataArray[x].split("~")[2] + " " : ""
                            }
                        }
                        return name
                    }
                }, {
                    field: '',
                    hidden: false,
                    name: '操作',
                    col: 2,
                    formatter: function (row, data, index) {//显示操作按钮
                        return (
                            <div className="list-item-action">
                                <span onClick={() => {
                                    _this.editInfo(row.id)
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
            forceUpdate:false,
            add: false,//弹框的编辑模式：新增、编辑
        }
        //this.doQuery = this.doQuery.bind(this);
        //this.doClear = this.doClear.bind(this);
        this.editInfo = this.editInfo.bind(this);
        //this.doAdd = this.doAdd.bind(this);
        this.initStatusDic = this.initStatusDic.bind(this);
        this.handleChange = this.handleChange.bind(this);
    }

    doQuery() {
        this.setState({
            add: false,
            forceUpdate: true,
        });
    }

    doClear() {
        this.setState({
            add: false,
            queryOption: {
                module: '',
                project: '',
                creator: '',
                status: ''
            }
        }, () => {
            this.setState({
                forceUpdate: true
            })
        });
    }

    doAdd() {
        this.setState({
            add: true,
            currentId: -1,
            forceUpdate: false,
        });
    }

    editInfo(id) {
        this.setState({
            currentId: id,
            add: true,
            forceUpdate: false
        });
    }

    deleteInfo(id) {
        let _this = this;
        fetch('/api/bugs/delBugs/' + id, {
            method: 'DELETE',
            headers: {
                "Content-Type": "application/json",
                "token": this.getAccessToken(),
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

    initStatusDic() {
        let _this = this;
        fetch('/api/bugs/getDicByBusinessType', {
            method: 'GET',
            headers: {
                "Content-Type": "application/json",
                "token": this.getAccessToken(),
            },
        }).then((response) => {
            if (!response.ok || response.status != 200) {
                    throw Error("查询数据出错")
            }
            return response.json()
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

    handleChange(value, key) {
        var obj = this.state.queryOption
        obj[key] = value
        this.setState({
            add:false,
            forceUpdate: false,
            queryOption: obj
        })
    }

    componentDidMount() {
        this.initStatusDic();
    }
    reload(reload){
        if(reload){
            this.doClear();
        }
    }


    render() {
        let curModuleCode='BUGJL'
        let formItemLayout = {
            labelCol: { span:8 },
            wrapperCol: { span:14 },
        };
        return (
            <div>
                <Row style={{marginTop:40}}>
                    <Col span={24}>
                        <Form className="ant-advanced-search-form">
                            <Row gutter={12}>
                                <Col span={6} key="1" >
                                    <FormItem {...formItemLayout} label="所属项目:">
                                        <Input value={this.state.queryOption.project}
                                               onChange={(e) => {
                                                   this.handleChange(e.target.value, 'project')
                                               }}
                                               placeholder="所属项目"/>
                                    </FormItem>
                                </Col>
                                <Col span={6} key="2" >
                                    <FormItem {...formItemLayout} label="所属模块：">
                                        <Input value={this.state.queryOption.module}
                                               onChange={(e) => {
                                                   this.handleChange(e.target.value, 'module')
                                               }}
                                            placeholder="所属模块"/>

                                    </FormItem>
                                </Col>
                                <Col span={6} key="3" >
                                    <FormItem {...formItemLayout} label="创建人：">
                                        <Input
                                            value={this.state.queryOption.creator}
                                            onChange={(e) => {
                                                this.handleChange(e.target.value, 'creator')
                                            }}
                                            placeholder="创建人" />

                                    </FormItem>
                                </Col>
                                <Col span={6} key="4" >
                                    <FormItem {...formItemLayout} label="状态：">
                                        <Select size="default"
                                                style={{width: '100%'}}
                                                defaultValue=""
                                                allowClear
                                                value={this.state.queryOption.status}
                                                onChange={(val) => {
                                                    this.handleChange(val, 'status')
                                                }}
                                        >
                                            {this.state.dics}
                                        </Select>
                                    </FormItem>
                                </Col>
                            </Row>
                        </Form>
                    </Col>
                    <Col span={24} style={{marginTop:10}}>
                        <ListButton curModuleCode={curModuleCode} doAdd={this.doAdd.bind(this)} doQuery={this.doQuery.bind(this)} doClear={this.doClear.bind(this)}/>
                    </Col>
                    <Col span={24}>
                        <BugsList
                            columns={this.state.columns}
                            toolbox={this.state.toolbox}
                            queryOption={this.state.queryOption}
                            url="/api/bugs/queryBugsList"/>
                    </Col>
                    <Col span={24}>
                        <BugsInfo add={this.state.add} id={this.state.currentId}  reload={this.reload.bind(this)} />
                    </Col>
                </Row>
            </div>

        )
    }

}

factory.register('BugsView',<BugsView />)