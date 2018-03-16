import React from 'react'
import IndexPage from './indexPage'
import {Login} from './login'
import mirror, {Router, Route, connect, actions} from 'mirrorx'
import cache from '../cache'
import '../../styles/index.scss'

mirror.model({name: 'app', reducers: {}, initialState: {}})
mirror.hook((action, getState) => {
    const {routing: {location}} = getState()
    if(!cache.token && location.pathname != '/login')
    {
        actions.routing.replace('/login')
    }
})
const App = connect(state => {
    return {count: state.app}
})(props => {
    return (
        <Router>
            <div className="fullpage">
                <Route exact path="/" component={IndexPage}></Route>
                <Route path="/login" component={Login}></Route>
            </div>
        </Router>
    )
})
export default App