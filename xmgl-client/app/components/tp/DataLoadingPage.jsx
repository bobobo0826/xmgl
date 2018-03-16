import {Icon, Row,Col,Layout} from 'antd';
const { Header, Footer, Sider, Content } = Layout;
import React from 'react';
import './tp.scss';


const DataLoadingPage = function () {
    return (
        <div className = "data-loading">
            <Row  type="flex" align ="middle">
                <Col span={6} push={9}>
                    <h2><Icon type="loading"/> &nbsp;&nbsp; 数据正在加载中</h2>
                </Col>
            </Row>
        </div>)
}
export default DataLoadingPage