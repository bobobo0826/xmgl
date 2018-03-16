import React from 'react';
import BaseComponent from '../../BaseComponent'
import {Row,Col} from 'antd';
class ListHead extends BaseComponent
{
    constructor(props)
    {
        super(props);
        this.state = {
            columns: this.props.columns || []
        }
    }
    render(){
        let row = this.state.columns.map((item,index) =>
            <Col key={index} sm={item.col} className={' list-item ' + (item.hidden ? 'hidden' : '')}>
                {item.name}
            </Col>
        );
        return(
            <Row className="list-head">
                {row}
            </Row>
        );
    }
}
export default ListHead;