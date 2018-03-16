import React from 'react'
import '../../../styles/public/css/list.scss';
import {Spin, Pagination} from 'antd';
import {ListHead, ListItem, ToolBox} from '../../public';
import BaseComponent from '../../BaseComponent'
const st = {
    NONE: 'none', //无状态
    LOADING: 'loading', //数据加载中
    LOADING_SUCCESS: 'load_success', //数据加载成功
    LOADING_FAILED: 'load_failed' //数据加载失败
}


class NoticeList extends BaseComponent {
    constructor(props) {
        super(props);
        this.state = {
            url: this.props.url, //加载数据距的url无需加host
            columns: this.props.columns, //cols参数
            status: st.NONE, //列表状态
            toolbox: this.props.toolbox || undefined, //列表上方操作按钮
            queryOption: this.props.queryOption || {}, //查询条件
            page: 1, //页数
            pageSize: 10, //每页数量
            total: 0 //总数
        };

        /**
         * 这些方法都是在类中定义的，bind之后在方法体中this参数自动指向类实例，
         * 即可以使用this.state\this.props\this.setState等react的componet方法
         *
         */
        this.doQuery = this.doQuery.bind(this);
        this.onPageControlChange = this.onPageControlChange.bind(this);
        this.showTotal = this.showTotal.bind(this);
    }

    //分页控件左边显示数据，可自定义，不限于文本，也可以是自定义元素
    showTotal = function () {
        return '共' + this.state.total + '条数据';
    };
    /**
     * 分页控件事件，pagesize大小或页数改变事件都调用本方法
     */
    onPageControlChange = function (page, pageSize) {
        this.setState({'page': page, 'pageSize': pageSize});
        this.doQuery();
    };
    doQuery = function () {
        this.setState({status: st.LOADING});
        var _this = this;
        console.log("!!!notice!!!!"+_this.state.queryOption)
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

    //看名字自己领悟
    componentWillReceiveProps(nextProps) {
        let update = false;
        if (nextProps.queryOption && nextProps.queryOption.forceUpdate) {
            update = true;
        }
        else {
            if (nextProps.queryOption) {
                for (var attr in nextProps.queryOption) {
                        //setState方法是异步调用的，在setState操作之后需要做其它操作应该放到第二个参数里
                        update = true;
                }
            }
        }
        if (update) {
            this.setState({queryOption: nextProps.queryOption}, () => {
                this.doQuery();
            });
        }
        if(nextProps.forceUpdate){
            if(nextProps.queryOption){
                this.setState({
                    queryOption:nextProps.queryOption
                },()=>this.doQuery()
                )}else{
                this.doQuery()
            }
        }
        // this.setState({status: st.LOADING}); var _this = this; setTimeout(function ()
        // {     _this.doQuery(); }, 2000);
    }

    //模版渲染方法，每个Component都必须实现该方法，且该方法必须有返回值，在该方法中组装html标签或自定义标签或第三方标签
    render() {
        var tb_body = null;
     
        switch (this.state.status) {
            /*
             <Spin tip="加载中..." /> 为antd封装的加载控件 无需关心其实现
             若有兴趣了解，参考：https://ant.design/components/spin-cn/
             */
            case st.LOADING:
                tb_body = (
                    <div className="row list-row">
                        <div className="col-sm-12 list-loading">
                            <Spin tip="加载中..."/>
                        </div>
                    </div>
                );
                break;
            case st.LOADING_FAILED:
                tb_body = (
                    <div className="row list-row">
                        <div className="col-sm-12 no-data">
                            {'数据加载失败，请联系管理员！'}
                        </div>
                    </div>
                );
                break;
            case st.LOADING_SUCCESS:
                if (this.state.list && this.state.list.length) {
                    tb_body = this
                        .state
                        .list
                        .map((item) => <ListItem key={item.id} columns={this.state.columns} data={item}/>);
                    /**
                     * react中使用map遍历数组集合.
                     arrr.map(function(item){
                               //to do sth
                          });
                     * 箭头操作符为es6新语法，有兴趣自行百度。
                     * 且该遍历回调function内必须有返回值。es6默认将方法最后一条语句结果返回，故这边可省略return，
                     * 且es6中如果方法只有一句话可省略大括号
                     */
                } else {
                    tb_body = (
                        <div className="row list-row">
                            <div className="col-sm-12 no-data">
                                暂无数据
                            </div>
                        </div>
                    );
                }
                break;
            default:
                tb_body = (
                    <div className="row list-row">
                        <div className="col-sm-12 no-data">
                            暂无数据
                        </div>
                    </div>
                );
                break;
        }
        return (
            <div className="list-panel">
                <div className="list-action">
                    <ToolBox items={this.state.toolbox}/>
                </div>
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
export default NoticeList