import React from 'react'
import {Input, Icon, Button, Spin} from 'antd';
import './login.scss'
import mirror, {connect, actions} from 'mirrorx'
import cache from '../../cache'
import {fetchAsync} from '../../request'
mirror.model({
    name: 'login',
    initialState: {
        status: '',
        username: '',
        password: ''
    },
    reducers: {
        loginOut(state) {
            return {
                ...state,
                status: '',
                password: '',
                username: ''
            }
        },
        setStatus(state, status) {
            return {
                ...state,
                'status': status
            };
        },
        onChange(state, obj) {
            return {
                ...state,
                ...obj
            }
        }
    },
    effects: {
        async auth(data, getState) {
            let obj = getState()['login']
            actions
                .login
                .setStatus('authing')
            let response = await fetchAsync('/auth/getAccessToken', {
                body: {
                    'username': obj.username,
                    'password': obj.password
                }
            })
            let json = await response.json()
            let status = ''
            if (json.token) {
                cache.setAccessToken(json.token)
                status = 'auth_success'
                actions.indexpage.loadMenu()
                setTimeout(() => {
                    actions.routing.replace('/')
                }, 300);
            } else {
                status = 'auth_failed'
            }
            actions.login.setStatus('status')
        }
    }
})

const Login = (() => {
    return connect(state => {
        return state.login
    })(props => {
        {
            let tip = <span></span>
            switch (props.status) {
                case 'authing':
                    tip = <span>登录验证中...</span>
                    break;
                case 'auth_success':
                    tip = <span className="login-success">登录验证成功,正在跳转...</span>
                    break
                case 'auth_failed':
                    tip = <span className="login-failed">用户名或密码错误</span>
                    break
                default:
                    tip = <span></span>
            }
            return (
                <div className="loginView">
                    <div className="login-panel">
                        <div className="login-row login-title">
                            全高项目管理系统
                        </div>
                        <div className="login-row">
                            <Input
                                placeholder="请输入用户名"
                                prefix={< Icon type = "user" />}
                                size="large"
                                onChange={(e) => {
                                actions
                                    .login
                                    .onChange({'username': e.target.value})
                            }}/>
                        </div>
                        <div className="login-row">
                            <Input
                                type="password"
                                placeholder="请输入密码"
                                prefix={< Icon type = "lock" />}
                                size="large"
                                onPressEnter={() => {
                                actions
                                    .login
                                    .auth()
                            }}
                                onChange={(e) => {
                                actions
                                    .login
                                    .onChange({'password': e.target.value})
                            }}/>
                        </div>
                        <div className="login-row login-action">
                            <span className="login-tip">{tip}</span>
                            <Button
                                type="primary"
                                onClick={() => {
                                actions
                                    .login
                                    .auth()
                            }}>登录</Button>
                        </div>
                    </div>
                </div>
            )
        }
    })
})()

export default Login