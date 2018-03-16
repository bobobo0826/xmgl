import React from 'react'
import '../../../styles/public/css/list.scss';
import {Spin, Pagination, Row, Col} from 'antd';
import BaseComponent from '../../BaseComponent'
import {ListHead,ListItem} from '../../public/list_component';
import HistoryListItem from './HistoryListItem';
import ToolBox from '../../public/list_component/ToolBox';

const st = {
    NONE: 'none', //无状态
    LOADING: 'loading', //数据加载中
    LOADING_SUCCESS: 'load_success', //数据加载成功
    LOADING_FAILED: 'load_failed' //数据加载失败
}

class ResHistoryView extends BaseComponent {
    constructor(props) {
        super(props);
        let _this = this;
        this.state = {
            url: this.props.url, //加载数据距的url无需加host
            status: st.NONE, //列表状态
            // toolbox: this.props.toolbox || undefined, //列表上方操作按钮
            queryOption: this.props.queryOption || {}, //查询条件
            page: 1, //页数
            pageSize: 10, //每页数量
            total: 0,//总数
            visitContent:false,
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
                                    _this.visitInfo()
                                }} >查看</span>
                                <span onClick={() => {
                                    _this.hideInfo()
                                }} className="ac-delete">隐藏</span>
                            </div>

                        );
                    }
                }
            ],
        };

        /**
         * 这些方法都是在类中定义的，bind之后在方法体中this参数自动指向类实例，
         * 即可以使用this.state\this.props\this.setState等react的componet方法
         *
         */
        this.doQuery = this.doQuery.bind(this);
        this.onPageControlChange = this.onPageControlChange.bind(this);
        this.showTotal = this.showTotal.bind(this);
        this.visitInfo = this.visitInfo.bind(this);
        this.hideInfo = this.hideInfo.bind(this);
    }

    //分页控件左边显示数据，可自定义，不限于文本，也可以是自定义元素
    showTotal = function () {
        return '共' + this.state.total + '条数据';
    };
    /**
     * 分页控件事件，pagesize大小或页数改变事件都调用本方法
     */
    onPageControlChange = function (page, pageSize) {
        this.setState({'page': page, 'pageSize': pageSize}, () => {
            this.doQuery();
        });
    }
    visitInfo(){
        console.log("in visitInfo")
        this.setState({
            visitContent: true
        })
    }
    hideInfo(){
        console.log("in hideInfo")
        this.setState({
            visitContent: false
        })
    }

    doQuery = function () {
        console.log("in resHistoryView's doQuery")
        console.log(this.state.queryOption)
        console.log(this.state.columns)
        console.log(this.state.visitContent)
        this.setState({status: st.LOADING});
        var _this = this;
        const apiUrl = _this.state.url;
        fetch(apiUrl, {
            method: 'POST',
            headers: {
                "Content-Type": "application/json",
                "token": this.getAccessToken()
            },
            //发送到后台的数据放这边
            body: JSON.stringify({
                queryOptions: _this.state.queryOption,
                page: _this.state.page,
                pageSize: _this.state.pageSize
            })
        }).then((response) => {
            if (response.status !== 200) {
                throw new Error('Fail to get response with status ' + response.status);
            } else {
                return response.json()//这个json一样，尝试将从response中读取出数据转换为对象，也返回一个Promise对象
            }
        }).then((responseJson) => {
            console.log(responseJson)
            _this.setState({
                list: responseJson.list,
                total: responseJson.totalitem,
                status: st.LOADING_SUCCESS
            });
        }).catch((error) => {
            console.log(error);
            _this.setState({status: st.LOADING_FAILED});
        });
    }
    //模版渲染挂载之后回调事件
    componentDidMount() {
        this.doQuery();
    }

    componentWillReceiveProps(nextProps) {
        //console.log("======nextPPPPP=====" + JSON.stringify(nextProps));
        if (nextProps.forceUpdate) {
            if (nextProps.queryOption) {
                this.setState({queryOption: nextProps.queryOption}, () => {
                    this.doQuery();
                });
            } else {
                this.doQuery();
            }
        }
        this.setState({visitContent:nextProps.visitContent})
    }


    render() {
        let tb_body = null;
        switch (this.state.status) {
            case st.LOADING:
                tb_body = (
                    <Row className="list-row">
                        <Col sm={24} className="list-loading">
                            <Spin tip="加载中..."/>
                        </Col>
                    </Row>
                );
                break;
            case st.LOADING_FAILED:
                tb_body = (
                    <Row className="list-row">
                        <Col sm={24} className="no-data">
                            {'数据加载失败，请联系管理员！'}
                        </Col>
                    </Row>
                );
                break;
            case st.LOADING_SUCCESS:
                if (this.state.list && this.state.list.length) {
                    if (this.state.visitContent) {
                        console.log(this.state)
                        tb_body = this
                            .state
                            .list
                            .map((item) => <HistoryListItem key={item.id} columns={this.state.columns} data={item}/>);
                    } else {
                        tb_body = this
                            .state
                            .list
                            .map((item) => <ListItem key={item.id} columns={this.state.columns} data={item}/>);
                    }
                } else {
                    tb_body = (
                        <Row className="list-row">
                            <Col sm={24} className="no-data">
                                暂无数据
                            </Col>
                        </Row>
                    );
                }
                break;
            default:
                tb_body = (
                    <Row className="row list-row">
                        <Col sm={24} className=" no-data">
                            暂无数据
                        </Col>
                    </Row>
                );
                break;
        }
        return (
            <div className="list-panel">
                {/*<div className="list-action">*/}
                    {/*<ToolBox items={this.state.toolbox}/>*/}
                {/*</div>*/}
                <div className="list">
                    <ListHead columns={this.state.columns}/> {tb_body}
                </div>
                <div className="list-page">
                    <Pagination
                        onChange={this.onPageControlChange}
                        onShowSizeChange={this.onPageControlChange}
                        showTotal={this.showTotal}
                        total={this.state.total}
                        showSizeChanger
                        showQuickJumper/>
                </div>
            </div>
        );
    }
}
export default ResHistoryView