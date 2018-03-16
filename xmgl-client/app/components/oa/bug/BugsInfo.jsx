import React from 'react';
import {Row, Modal, message, Button, Input, Col, Tabs, Table, Pagination, Select, Icon, Form,Collapse } from 'antd';//引入控件
import  "../../../styles/public/css/info.scss"
import SelectEmployee from '../../public/selects/SelectEmployee';
import SselectModule from './SselectModule'
import {ListHead,ListItem} from '../../public'
import BaseComponent from '../../BaseComponent'
import {InfoButton} from '../../public'
import LzEditor from 'react-lz-editor/editor/index'
import './bug.scss'
const Option = Select.Option;
const TabPane = Tabs.TabPane;
const FormItem = Form.Item;
const formItemLayout = {
    labelCol: {span: 8},
    wrapperCol: {span: 16},
};
const Panel = Collapse.Panel;
const { TextArea } = Input;
var id;
var projectIsExist;
var descriptionIsExist;
var descriptionInfo;
var projectInfo;
var projectIdAndName;
class BugsInfo extends BaseComponent {
    bugsData = {};

    constructor(props) {
        super(props);
        this.state = {
            reload:false,
            responseList: [],
            forceUpdate: true,
            dics: [],
            employeeid: [],
            treeResult: "",
            treeData: [],
            bugsData: {
                project: "",
                create_date: "",
                creator: "",
                module: "",
                description: "",
                responsible_person: "",
                status: "草稿",
            },
            key: "1",
            id: this.props.id,
            bugsInfo: {
                basic_info: {}
            },
            visible: false,
            maskClosable: false,
            size: 'large',
            formControl: {
                width: 150,
            },
            add: this.props.add,//是否为新增操作
            columns: [
                {
                    field: 'operator',
                    hidden: false,
                    name: '操作人',
                    col: 4
                }, {
                    field: 'operate_time',
                    hidden: false,
                    name: '操作时间',
                    col: 6
                }, {
                    field: 'status_code',
                    hidden: false,
                    name: '状态',
                    col: 6
                }, {
                    field: 'remarks',
                    hidden: false,
                    name: '备注',
                    col: 6,
                }
            ],
        }

        this.getBugsInfo = this.getBugsInfo.bind(this)
        this.handleCancel = this.handleCancel.bind(this)
        this.save = this.save.bind(this)
        this.getBugsOprInfoById = this.getBugsOprInfoById.bind(this);
        this.initProjectDic = this.initProjectDic.bind(this);
        this.handleChange = this.handleChange.bind(this);
        this.getModuleByProjectId = this.getModuleByProjectId.bind(this);
        this.getTreeResult = this.getTreeResult.bind(this);
        this.validate = this.validate.bind(this);
        this.getEmployeeIdListByPid = this.getEmployeeIdListByPid.bind(this);
        this.receiveDes = this.receiveDes.bind(this);
        this.receiveRemarks= this.receiveRemarks.bind(this);
    }

    handleChange (pro, val) {
        if (pro === "project") {
             projectIdAndName = val.split(",")
            this.bugsData[pro] =val;
            this.getModuleByProjectId(projectIdAndName[0])
            //this.getEmployeeIdListByPid(projectIdAndName[0])
            this.bugsData["module"]="";
        } else {
            this.bugsData[pro] = val
        }
    }

    getBugsInfo() {
        let _this = this;
        id = _this.state.id
        if (id != -1) {
            fetch('/api/bugs/getBugsInfoById/' + _this.state.id, {
                method: 'GET',
                headers: {
                    "Content-Type": "application/json",
                    "token": this.getAccessToken(),
                },
                //发送到后台的数据放这边
            }).then((response) => {
                response.json().then((responseJson) => {
                    //填充用户数据到state中，将visible设置为true以显示弹框
                    _this.setState({bugsData: responseJson.Bugs}, () => {
                        this.bugsData = responseJson.Bugs;
                        this.getModuleByProjectId(this.bugsData.project.split(",")[0])
                        this.getBugsOprInfoById();
                        //this.validate()
                        _this.setState({
                            visible: true
                        })
                    });
                })
            })
        } else {
            this.state.bugsData = {
                project: "",
                create_date: "",
                creator: "",
                module: "",
                description: "",
                responsible_person: "",
                record: "",
                status: "草稿",
            }
            this.bugsData = {
                project: "",
                create_date: "",
                creator: "",
                module: "",
                description: "",
                record: "",
                responsible_person: "",
                status: "草稿",
            }
            projectIsExist = ""
            projectInfo = ""
            descriptionIsExist = "";
            descriptionInfo = "";
            this.setState({
                visible: true
            })
        }
    }

    save(value) {
       // console.log("bugsData="+JSON.stringify(this.bugsData))
        if (!this.bugsData.project || !this.bugsData.description) {
            this.validate();
            return;
        }
        let _this = this;
        fetch('/api/bugs/saveBugsInfo/' + value, {
            method: 'PUT',
            headers: {
                "Content-Type": "application/json",
                "token": this.getAccessToken(),
            },
            //发送到后台的数据放这边
            body: JSON.stringify(_this.bugsData),
        }).then((response) => {
            //若新增操作需要将ID回填到bugsInfo中
            message.success("保存成功！");
            //_this.handleCancel();
        })
    }

    formChange(pro, val) {
        this.bugsData[pro] = val;
    }
    //点击模式窗口X回调方法
    handleCancel() {
        this.setState({
            visible: false,
            add: false,
            bugsInfo: {
                basic_info: {}
            },
            id: undefined,
            key: "1",
            forceUpdate: true
        },()=>{
            this.props.reload(true);
            }
        );
    }

    componentWillReceiveProps(nextProps) {
        if ((nextProps.add === true)) {
            this.setState({id: nextProps.id}, () => {
                this.getBugsInfo();
            });
        }
        else if (nextProps.add) {
            this.setState({
                visible: false,
                bugsInfo: {
                    basic_info: {}
                },
                id: undefined
            });
        }
    }

    getBugsOprInfoById(key) {
        let _this = this;
        if (key == "1") {
            _this.setState({
                key: key,
            })
        }

        //相当于ajax，在react中使用fetch方法，这也是es6之后的趋势之一，这里fetch返回一个Promise对象
        else if (key == "2") {
            fetch('/api/bugs/getBugsOprInfoById/' + id, {
                method: 'POST',
                headers: {
                    "Content-Type": "application/json",
                    "token": this.getAccessToken(),
                },
            }).then((response) => { //详情参见Promise，也是es6的新特性，使用Promise可以减少代码嵌套，且代码看起来更符合逻辑。
                response
                    .json()//这个json一样，尝试将从response中读取出数据转换为对象，也返回一个Promise对象
                    .then((responseJson) => {
                        _this.setState({
                            list: responseJson,
                            key: key,

                        });
                        //console.log("list="+JSON.stringify(this.state.list))
                    })
                    .catch((error) => {
                        console.log(error);
                    });
            }).catch((error) => {
                console.log(error);
            });
        }

    }
    //模版渲染挂载之后回调事件
    componentDidMount() {
        this.initProjectDic();
    }

    initProjectDic() {
        let _this = this;
        fetch('/api/bugs/getProject', {
            method: 'GET',
            headers: {
                "Content-Type": "application/json",
                "token": this.getAccessToken(),
            },
        }).then((response) => {
            if (!response.ok || response.status != 200) {
                throw Error("查询数据出错")
            }
            else {
                return response.json()
            }
        }).then(function (obj) {
            _this.setState({
                dics : obj.rows.map((item)=>{
                    return (
                        <Option key={item.id+','+item.project_name}>{item.project_name}</Option>
                    )
                })
            });
        }).catch((error) => {
            console.log(error)
        });
    }

    updatePerson(responsible_person) {
        let employees = [];
        let obj = JSON.parse(responsible_person);
        for (let i=0; i<obj.length; i++){
            employees.push(obj[i].id+"~"+obj[i].dept+"~"+obj[i].name);
        }
        this.bugsData["responsible_person"] = employees.join(",");

    }

    getTreeResult(treeResult) {
        this.setState({
            treeResult: treeResult
        })
        this.bugsData["module"] = treeResult
    }

    getModuleByProjectId(projectId) {
        let _this = this;
        fetch('/api/bugs/getModuleByProjectId/' + projectId, {
            method: 'POST',
            headers: {
                "Content-Type": "application/json",
                "token": this.getAccessToken(),
            },
        }).then((response) => { //详情参见Promise，也是es6的新特性，使用Promise可以减少代码嵌套，且代码看起来更符合逻辑。
            return response.json()//这个json一样，尝试将从response中读取出数据转换为对象，也返回一个Promise对象

        }).then((responseJson) => {
            _this.setState({
                treeData: responseJson,
            });
        }).catch((error) => {
            console.log(error);
        });

    }
    getEmployeeIdListByPid(projectId) {
        let _this = this;
        fetch('/api/bugs/getEmployeeIdListByPid/' + projectId, {
            method: 'POST',
            headers: {
                "Content-Type": "application/json",
                "token": this.getAccessToken(),
            },
        }).then((response) => { //详情参见Promise，也是es6的新特性，使用Promise可以减少代码嵌套，且代码看起来更符合逻辑。
            response
                .json()//这个json一样，尝试将从response中读取出数据转换为对象，也返回一个Promise对象
                .then((responseJson) => {
                    _this.setState({
                        employeeid: responseJson,
                    });

                })
                .catch((error) => {
                    console.log(error);
                });
        }).catch((error) => {
            console.log(error);
        });

    }

    validate() {
        if (!this.bugsData.project) {
            projectIsExist = "error"
            projectInfo = "请选择项目"
        } else {
            projectIsExist = ""
            projectInfo = ""
        }
        if (!this.bugsData.description) {
            descriptionIsExist = "error"
            descriptionInfo = "请输入bug描述"
        } else {
            descriptionIsExist = ""
            descriptionInfo = ""
        }

        this.setState({
            forceUpdate: true
        })
    }
    receiveDes(content) {
        this.bugsData["description"] =content;
        this.setState({responseList: []});
    }
    receiveRemarks(content) {
        this.bugsData["remarks"] = content;
        this.setState({responseList: []});
    }

    render() {
        let curModuleCode='BUGJL'
        let policy = "";
        const uploadProps = {
            action: "http://v0.api.upyun.com/devopee",
            onChange: this.onChange,
            listType: 'picture',
            fileList: this.state.responseList,
            data: (file) => {},
            multiple: true,
            beforeUpload: this.beforeUpload,
            showUploadList: true
        }
        if(this.state.bugsData.description){
            descriptionIsExist = ""
            descriptionInfo = ""
        }
        if(this.state.bugsData.project){
            projectIsExist = ""
            projectInfo = ""
        }

        let personArray;
        if (this.bugsData.responsible_person) {
            let responsible_person = this.bugsData.responsible_person
            personArray = responsible_person.split(",")
            for (let x in personArray) {
                if (personArray[x]) {
                    personArray[x] = parseInt(personArray[x].split("~")[0])
                }
            }

        }
        let content
        let moduleDiv
        let save
        let submit
        let test
        let confirm
        let notConfirm
        let tabs
        let record
        let tb_body = null

        if(this.state.bugsData.status=="待解决"){
            record=(
                <Panel header="备注" key="3">
                    <Col span={24}  >
                        <FormItem labelCol={{ span: 4 }}
                                  wrapperCol={{ span:18 }}
                                  label="备注：">
                            <div style={{height:450}}>
                            <LzEditor
                                active={true}
                                cbReceiver={this.receiveRemarks}
                                uploadProps={uploadProps}
                                lang="en"/>
                            </div>
                        </FormItem>
                    </Col>
                </Panel>

            );
        }
        if (this.state.list && this.state.list.length) {
            tb_body = this.state.list.map((item) =>
                <ListItem key={item.id} columns={this.state.columns} data={item}/>);
        } else {
            tb_body = (
                <Col span={24} className="no-data">
                    暂无数据
                </Col>
            );
        }
        if(this.state.bugsData.status!=="草稿"){
            tabs=(
                <TabPane tab="操作记录" key="2">
                    <Row className="list-operate">
                        {/*{record}*/}
                        <Col span={24} className="list-operate-head">
                            <ListHead columns={this.state.columns}/>
                        </Col>
                        <Col span={24} className="list-operate-content">
                            {tb_body}
                        </Col>
                    </Row>
                </TabPane>

            )
        }
        let buttonArray=new Array();
        switch (this.state.bugsData.status) {
            case("草稿"):
                let buttonObject=new Object()
                buttonObject.name='保存'
                buttonObject.function=this.save.bind(this, 'Save')
                buttonObject.class="btn-save"
                buttonArray.push(buttonObject)
                let tjbuttonObject=new Object()
                tjbuttonObject.name='提交'
                tjbuttonObject.function=this.save.bind(this, 'Submit')
                tjbuttonObject.class="btn-submit"
                buttonArray.push(tjbuttonObject)
              /*  save =
                    <Button className="btn-save"  onClick={this.save.bind(this, 'Save')}>保存</Button>
                submit = <Button className="btn-submit"  onClick={this.save.bind(this, 'Submit')}>
                    提交</Button>*/
                break;
            case("待解决"):
                let hcbuttonObject=new Object()
                hcbuttonObject.name='请求回测'
                hcbuttonObject.function=this.save.bind(this, 'Test')
                hcbuttonObject.class="btn-test"
                buttonArray.push(hcbuttonObject)
              /*  test = <Button className="btn-test"  onClick={this.save.bind(this, 'Test')}>
                    请求回测</Button>*/
                break;
            case("待回测"):
                let qrbuttonObject=new Object()
                qrbuttonObject.name='确认解决'
                qrbuttonObject.function=this.save.bind(this, 'Confirm')
                qrbuttonObject.class="btn-confirm"
                buttonArray.push(qrbuttonObject)
                let bygbuttonObject=new Object()
                bygbuttonObject.name='回测不通过'
                bygbuttonObject.function=this.save.bind(this, 'notConfirm')
                bygbuttonObject.class="btn-notConfirm"
                buttonArray.push(bygbuttonObject)
                /*confirm =
                    <Button className="btn-confirm"  onClick={this.save.bind(this, 'Confirm')}>
                        确认解决</Button>
                notConfirm =
                    <Button className="btn-notConfirm" onClick={this.save.bind(this, 'notConfirm')}>
                        回测不通过</Button>*/
                break;
        }

        if (this.state.visible) {
            content =
                <Collapse accordion defaultActiveKey={['1']} bordered={false}>
                    <Panel header="简单信息" key="1">
                        <p>
                            <Row>
                                <Col span={24}>
                                    <Form>
                                        <Row gutter={12}>
                                            <Col span={12} >
                                                <FormItem {...formItemLayout} label="所属项目:" validateStatus={projectIsExist} help={projectInfo}>
                                                    <Select
                                                        defaultValue={this.state.bugsData.project}
                                                        size={this.state.size}
                                                        style={this.state.formControl}
                                                        onChange={(e) => {
                                                            this.handleChange('project', e)
                                                        }}
                                                    >
                                                        {this.state.dics}
                                                    </Select>
                                                </FormItem>
                                            </Col>
                                            <Col span={11}>
                                                <FormItem {...formItemLayout} label="所属模块：">
                                                    <Input size={this.state.size} style={this.state.formControl}
                                                           value={this.state.bugsData.module || this.bugsData.module}
                                                           id="username"
                                                           onChange={(e) => {this.formChange('module', e.target.value)}}/>
                                                </FormItem>
                                            </Col>
                                            <Col span={1} pull={1}>
                                                <SselectModule treeData={this.state.treeData} getTreeResult={this.getTreeResult.bind(this)}/>
                                            </Col>
                                        </Row>
                                        <Row gutter={12}>
                                            <Col span={12}>
                                                <FormItem {...formItemLayout} label="创建人：">
                                                    <Input disabled size={this.state.size} style={this.state.formControl}
                                                           defaultValue={this.state.bugsData.creator || ''}
                                                           onChange={(e) => {this.formChange('creator', e.target.value)}}
                                                    />
                                                </FormItem>
                                            </Col>
                                            <Col span={11} >
                                                <FormItem {...formItemLayout} label="创建时间：">
                                                    <Input
                                                        disabled size={this.state.size} style={this.state.formControl}
                                                        defaultValue={this.state.bugsData.createDate || ''}
                                                        onChange={(e) => {this.formChange('create_date', e.target.value)}}
                                                    />
                                                </FormItem>
                                            </Col>
                                        </Row>
                                        <Row >
                                            <Col span={12}>
                                                <FormItem {...formItemLayout} label="状态：">
                                                    <Input
                                                        disabled size={this.state.size} style={this.state.formControl}
                                                        defaultValue={this.state.bugsData.status || ''}
                                                        onChange={(e) => {this.formChange('status', e.target.value)}}
                                                    />
                                                </FormItem>
                                            </Col>
                                        </Row>
                                        <Row>
                                            <Col span={24} key="6">
                                                <FormItem labelCol={{ span: 4 }} wrapperCol={{ span: 20 }} label="负责人：">
                                                    <SelectEmployee employees={personArray}
                                                                    updatePerson={this.updatePerson.bind(this)}/>
                                                </FormItem>
                                            </Col>
                                        </Row>
                                    </Form>
                                </Col>
                            </Row>
                        </p>
                    </Panel>
                    <Panel header="描述信息" key="2">
                        <p>
                            <Row>
                                <Col span={24} key="7"  >
                                    <FormItem labelCol={{ span: 4 }} validateStatus={descriptionIsExist} help={descriptionInfo}
                                              wrapperCol={{ span: 18 }} label="bug简述：">
                                        <div style={{height:450}}>
                                            <LzEditor
                                                active={true}
                                                importContent={this.state.bugsData.description}
                                                cbReceiver={this.receiveDes}
                                                uploadProps={uploadProps}
                                                lang="en"/>
                                        </div>
                                    </FormItem>
                                </Col>
                            </Row>
                        </p>
                    </Panel>
                    {record}
                </Collapse>

        }
        return (
            <Modal
                title={'bugs信息'}
                style={{ top: 20 }}
                maskClosable={this.state.maskClosable}
                visible={this.state.visible}
                onCancel={this.handleCancel}
                okText="保存"
                cancelText="关闭"
                width="640px"
                footer={
                    <Row className="list-action">
                        <InfoButton curModuleCode={curModuleCode} content={buttonArray} handleCancel={this.handleCancel.bind(this)}/>
                    </Row>
                }
            >
                <Tabs onChange={this.getBugsOprInfoById} activeKey={this.state.key}>
                    <TabPane tab="基本信息" key="1">{content}</TabPane>
                    {tabs}
                </Tabs>
            </Modal>

        )
    }
}

export default BugsInfo

