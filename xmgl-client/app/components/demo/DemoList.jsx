import React from 'react'
import mirror, {connect, actions} from 'mirrorx'
import {fetchAsync} from '../request'
import {Row, Col, Spin, Icon, Timeline} from 'antd'
import './demo.scss'
const editInfo = function (id) {}

mirror.model({
    name: 'demo',
    initialState: {
        list: undefined
    },
    reducers: {
        setList(state, data) {
            return {
                ...state,
                list: data
            }
        },
        doExpandInfo(state, index) {
            console.log(state)
            return {
                ...state,
                list: state
                    .list
                    .map((item, i) => {
                        if (index == i) 
                            item.expandInfo = !item.expandInfo
                        return item
                    })
            }
        }
    },
    effects: {
        async getList() {
            let response = await fetchAsync('/daylog')
            let list = await response.json();
            if (!list) {
                list = []
            }
            for (let item of list) {
                item.expandInfo = false
            }
            actions
                .demo
                .setList(list.slice(0,10))
        }
    }

})

const DemoList = (() => {
    return connect(state => {
        if (!state.demo.list) {
            actions
                .demo
                .getList()
        }
        return state.demo
    })
    (props => {
        let content = (<Spin tip={"加载中"}/>)
        if (props.list && props.list.length) {
            content = props
                .list
                .map((item, index) => {
                    let rwList = (
                        <div className="no-data">暂无数据</div>
                    )
                    if (item.content && item.content.length) {
                        rwList = item.content.map((subItem, index) => {
                                return (
                                    <Timeline.Item className="timeline-item">
                                        <span>{subItem.task_start_time + '~' + subItem.task_end_time}</span>
                                        <span>{subItem.task_name}</span>
                                    </Timeline.Item>
                                )
                            })
                        console.log(rwList)
                        return (
                            <div key={item.id} className="list2-item">
                                <div><h1>{item.creator}</h1></div>
                                <Timeline className="timeline">
                                    {rwList}
                                </Timeline>
                            </div>
                        )
                    }
                })
        }
        return (
            <div className="list2-view">{content}</div>
        )
    })
})()

export default DemoList