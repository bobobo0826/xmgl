import React from 'react';
import BaseComponent from '../../BaseComponent'
import {Row, Col} from 'antd';


class HistoryListItem extends BaseComponent {
    constructor(props) {
        super(props);
        this.state = {
            columns: this.props.columns || [],
            data: this.props.data || {},
            content:[]
        }
        this.getNamesByIds = this.getNamesByIds.bind(this)
        this.showContent = this.showContent.bind(this)
    }

    getNamesByIds(idList,add_key, callback) {
        console.log("in getNamesByIds")
        let nameList = [];
        fetch('/api/resource/getNamesByIds/' + idList, {
            method: 'GET',
            headers: {
                "Content-Type": "application/json",
                token: this.getAccessToken(),
            },
        }).then((response) => {
            if (!response.ok || response.status != 200) {
                return new Promise(function (succeed, failed) {
                    failed("getNamesByIds()查询数据出错")
                })
            } else {
                return response.json()
            }
        }).then((obj) => {
            obj.map(item =>
                nameList.push(item.res_name)
            )
            callback(add_key,nameList)
            console.log("==nameList111==" + JSON.stringify(nameList))
        }).catch(error => {
            console.log(error)
        });

    }
    componentDidMount() {
        let data = this.state.data;
        this.showContent(data["content"])
    }


    showContent(data) {
        var content=[];
        if (data) {
            console.log(data)
            let dataArray = [];
            try {
                dataArray = JSON.parse(data);
            } catch (error) {
                dataArray = [];
                return data;
            }
            if (dataArray && dataArray.length > 0) {
                for (var i = 0; i < dataArray.length; i++) {
                    if (dataArray[i].add_type === "GLZD") {
                        console.log("find 关联字段")
                        this.getNamesByIds(dataArray[i].add_value,dataArray[i].add_key,(add_key,nameList)=>{
                            let content = this.state.content
                            let contentItem = add_key + "："+nameList+"；";
                            content.push(contentItem);
                            console.log("aaaaaa")
                            console.log(content)
                            this.setState({content:content})
                        })

                    } else {
                        let contentItem = dataArray[i].add_key + "："+dataArray[i].add_value+"；";
                        content.push(contentItem);
                    }
                }
            }
            console.log(content)
            this.setState({content:content})
        } else {
            this.setState({content})

        }
    }

    render() {
        let data = this.state.data;
        let row1 = this.state.columns.map((item, index) =>
            <Col key={'row_item' + index + '_' + item.id} sm={item.col}
                 className={' list-item ' + (item.hidden ? ' hidden' : '')}>
                {item.formatter ? item.formatter(data, data[item.field], index) : data[item.field]}
            </Col>
        );

        let row2 = <Col sm={20} offset={4}>{"content："}&nbsp;{this.state.content}</Col>


        return (
            <div>
                <Row className="list-row">
                    {row1}
                </Row>
                <Row className="list-row">
                    {row2}
                </Row>
            </div>
        );
    }
}

export default HistoryListItem;