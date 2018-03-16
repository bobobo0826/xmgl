import React from 'react';
import {Modal, message, Button, Input, Select, Form, Row, Col,} from 'antd';//引入控件
import  "../../../styles/public/css/info.scss"
import BaseComponent from '../../BaseComponent'

const Option = Select.Option;
const FormItem = Form.Item;
const formItemLayout = {
    labelCol: {sm: {span: 6},},
    wrapperCol: {sm: {span: 14},},
};

class AddContent extends BaseComponent {
    addData = {};

    constructor(props) {
        super(props);
        this.state = {
            add_key: "",
            add_type: "",
            add_value: "",
            size:'large',
            add_visible: this.props.add_visible,
            maskClosable: false,
            resList:this.props.resList,
        }


        this.handleCancel = this.handleCancel.bind(this);
        this.handleChange = this.handleChange.bind(this);
        this.getAddTypeDic = this.getAddTypeDic.bind(this);
        this.confirm = this.confirm.bind(this);


    }


    handleChange(key, val) {
        if (key === "add_type") {
            this.addData[key] = val;
            this.setState({
                add_type: val
            })
        } else {
            this.addData[key] = val;
        }
        console.log(this.addData)
    }

    confirm() {

        let add_key = this.addData.add_key;
        let add_type = this.addData.add_type;
        let add_value = this.addData.add_value;

        if (add_key && add_value) {
            this.props.updateAddContentArea(add_key,add_type,add_value);
        } else {
            message.warning("请填写完整信息！")
            return;
        }

        add_key = '';
        add_value = '';
        this.addData.add_key = add_key;
        this.addData.add_value = add_value;
        this.setState({
            add_type:''
        });
        message.success("添加信息成功！");

    }

    //点击模式窗口X回调方法
    handleCancel() {
        this.setState({
            add_visible: false,
            add_type:'',
        });
    }


    componentWillReceiveProps(nextProps) {
        this.setState({
            add_visible: nextProps.add_visible
        })

    }

    //模版渲染挂载之后回调事件
    componentDidMount() {
        this.getAddTypeDic();
    }

    getAddTypeDic() {
        let _this = this;
        fetch('/api/resource/getAddTypeDic', {
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
                addTypeDic: obj.map((item) =>
                    <Option key={item.data_code}>{item.data_name}</Option>
                )
            });
        }).catch((error) => {
            console.log(error)
        });
    }

    render() {
        let content = <div></div>
        let variableInput = <div></div>
        if (this.state.add_type) {
            switch (this.state.add_type) {
                case 'ZDYZD':
                    variableInput =
                        (<FormItem {...formItemLayout} label={`自定义字段值：`}>
                            <Input
                                size={this.state.size}
                                defaultValue=""
                                ref="add_value_custom"
                                onChange={(e) => {
                                    this.handleChange('add_value', e.target.value)
                                }}
                            />
                        </FormItem>)
                    break;
                case 'GLZD':
                    variableInput =
                        (<FormItem {...formItemLayout} label={`关联字段值：`}>
                            <Select
                                mode="multiple"
                                onChange={(val) => {
                                    this.handleChange('add_value', val)
                                }}
                                // ref="add_value_relevance"
                                defaultValue={[]}
                                // value = {this.state.add_value}
                            >
                                {this.state.resList}
                            </Select>
                        </FormItem>)
                    break;
                default:
                    break;

            }
        }
        if (this.state.add_visible) {
            content =
                <Modal
                    title={'添加信息'}
                    maskClosable={this.state.maskClosable}
                    visible={this.state.add_visible}
                    onCancel={this.handleCancel}
                    okText="保存"
                    cancelText="关闭"
                    width="640px"
                    footer={
                        <div className="list-action">
                            <Button size="large" onClick={this.confirm}>确定</Button>
                            <Button type="danger" size="large" onClick={this.handleCancel}>关闭</Button>
                        </div>}
                >
                    <div className="info-panel">
                        <Form >
                            <Row >
                                <Col sm={24}>
                                    <FormItem {...formItemLayout} label={`添加字段名：`}>
                                        <Input
                                            ref="add_key"
                                            size={this.state.size}
                                            defaultValue={this.state.add_key}
                                            onChange={(e) => {
                                                this.handleChange('add_key', e.target.value)
                                            }}
                                        />
                                    </FormItem>
                                </Col>
                                <Col sm={24}>
                                    <FormItem {...formItemLayout} label={`添加类型：`}>
                                        <Select
                                            size={this.state.size}
                                            onChange={(val) => {
                                                this.handleChange('add_type', val)
                                            }}
                                            defaultValue=""
                                        >
                                            {this.state.addTypeDic}
                                        </Select>
                                    </FormItem>
                                </Col>
                                <Col sm={24}>
                                    {variableInput}
                                </Col>
                            </Row>
                        </Form>
                    </div>
                </Modal>

        }
        return content
    }
}

export default AddContent

