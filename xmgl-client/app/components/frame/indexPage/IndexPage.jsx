import React from 'react'
import mirror, {connect, actions} from 'mirrorx'
//import ant layout and css
import {
    Button,
    Layout,
    Menu,
} from 'antd'
import {getJson} from '../../request'
import cache from '../../cache'
import {Userspace,Userpanel} from './Userspcae'
//导入样式
import './indexPage.scss'
import EmailHomeShow from '../../home/widgets/EmailHomeShow'

const {Header, Content, Footer, Sider} = Layout
let menuObj = {}

mirror.model({
    name: 'indexpage',
    initialState: {
        menus: '',
        isReady: false,
        top : [],
        content : '',
        up_show : false,
        isShowEmailTool : false,
        curUser:{}
    },
    reducers: {
        showEmailTool(state,visible)
        {
            return {
                ...state,
                isShowEmailTool : visible
            }
        },
        setUserpanelState(state, status)
        {
            return {
                ...state,
                up_show : status
            }
        },
        jumpTo(state,key)
        {
            console.log(menuObj[key].url)
            let content = (menuObj[key].url == '/?') ? <h1>404</h1> : <iframe src={menuObj[key].url + "menuid="+ menuObj[key].menuid}></iframe>
            return {
                ...state,
                content : (content)
            }
        },
        setMenu(state, obj) {
            let menus = {}
            for(var item of obj.menus)
            {
                menus[item.menuid] = item
            }
            let top =obj.menus.map((item)=>(
                <Menu.Item key={item.menuid}>{item.menuname}</Menu.Item>
            ))
            return {
                ...state,
                menus : menus,
                curUser:obj.curUser,
                top : top,
                isReady : true
            }
        }
    },
    effects: {
        async loadMenu(data, getState) {
            let menus = await getJson('/api/permission/manage/index/showMenuReact');
            let curUser = await getJson("/api/task/getCurUser", {'method': 'GET'});  //wjy,暂时没修改permission，借用task模块的接口
            if (menus && menus.length) {
                menuObj = {}
                for(var item of menus)
                {
                    menuObj[item.menuid] = item
                }
                cache.setData('menus',menuObj)
                actions.indexpage.setMenu({menus,curUser});
            }
        }
    }
})

const IndexPage = (() => {
    return connect(state => {
        if (!state.indexpage.isReady) {
            actions.indexpage.loadMenu()
        }
        return state.indexpage
    })(props => {
        {
            // <Button className="btn-loginout" onClick={loginOut.bind(null)}>注销</Button>
            return (
                <div className="page">
                <Layout>
                    <Header className="header">
                        <div className="logo" />
                        <Menu
                            className='menu'
                            onClick={(obj)=>{actions.indexpage.jumpTo(obj.key)}}
                            theme="dark"
                            mode="horizontal"
                            defaultSelectedKeys={['home']}
                            style={{ lineHeight: '64px' }}
                        >
                            {props.top}
                        </Menu>

                        <Userspace panel={props.up_show} userName = {props.curUser.displayName}/>
                    </Header>
                    <Content className="page-content" style={{ background: '#fff' }}>
                        {props.content}
                    </Content>
                    <Footer className="footer">
                        全高信息科技 ©2017 联系电话：025-84411350
                    </Footer>
                </Layout>
                    <div>
                        <EmailHomeShow/>
                    </div>
            </div>)
        }
    })
})()

export default IndexPage
