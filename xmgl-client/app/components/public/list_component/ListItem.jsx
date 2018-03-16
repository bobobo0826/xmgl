import React from 'react';
import BaseComponent from '../../BaseComponent'
import {Row,Col} from 'antd';

class ListItem extends BaseComponent
{
    constructor(props)
    {
        super(props);
        this.state = {
            columns: this.props.columns || [],
            data : this.props.data || {},
        }
    }
    render(){
        let data = this.props.data;
        let row = this.props.columns.map((item,index) =>
            <Col key={'row_item' + index + '_' + item.id} sm={item.col} className={' list-item ' +  (item.hidden ? ' hidden' : '')}>
                {item.formatter ? item.formatter(data,data[item.field],index) : data[item.field]}
            </Col>
        );
        return(
            <Row className="list-row">
                {row}
            </Row>
        );
    }
}

export default ListItem;