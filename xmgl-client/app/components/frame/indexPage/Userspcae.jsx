import React from 'react'
import {actions,render} from 'mirrorx'
import cache from '../../cache'
import './userspace.scss'
import {Row, Col} from 'antd'
const loginOut = function()
{
    cache.clearToken()
    actions.indexpage.setUserpanelState(false)
    actions.routing.replace('/login')
}
const show_user_center = function (){//wjy 临时------------个人中心菜单id是64
    actions.indexpage.jumpTo("64");
}

const Userpanel = () =>(
    <div className="userpanel">
        <div className="user-menu">
            <Row className="user-menu-row">
                <Col span={12}><span
                    onClick = {()=>{show_user_center()}}
                >个人中心</span></Col>
                <Col span={12}><span className="emailWidgets" onClick={()=>{actions.emailHomeShow.showOrHide(true)}}>邮件工具</span></Col>
            </Row>
        </div>
        <div className="action-footer">
            <span className="loginout-btn" onClick={loginOut}>注销</span>
        </div>
    </div>
)

const Userspace = (props) =>(
    <div 
        className="userspace" 
        onMouseOver={()=>{actions.indexpage.setUserpanelState(true)}}
        onMouseLeave={()=>{actions.indexpage.setUserpanelState(false)}}
        >
        <img className="user-avtar" src="https://static.oschina.net/uploads/user/288/577714_50.jpeg?t=1500552693000" />
        <div className="user-name">{props.userName}</div>
        <div className="user-action"></div>
        {props.panel  ? <Userpanel /> : ''}
        
    </div>
)



export {Userspace,Userpanel}