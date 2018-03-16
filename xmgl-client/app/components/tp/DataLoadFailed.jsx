import {Icon, Row,Col} from 'antd';
import React from 'react';
import './tp.scss';


const DataLoadFailed = function () {
    return (
        <div className = "data-loading">
            <Row  type="flex" align ="middle">
                <Col span={6} push={9}>
                    <h2><Icon type="frown-o" /> &nbsp;&nbsp; 数据加载失败</h2>
                </Col>
            </Row>
        </div>)
}
export default DataLoadFailed