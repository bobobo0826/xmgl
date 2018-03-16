import React from 'react'
import NoticeHomeShow from './NoticeHomeShow/NoticeHomeShow.jsx'
import EmailHomeShow from '../home/widgets/EmailHomeShow.jsx'
class Home extends React.Component
{
    render(){
        return(
            <div>
                <NoticeHomeShow />
                <EmailHomeShow />
            </div>
        )
    }
}

export default Home