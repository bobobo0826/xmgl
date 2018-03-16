const MENU = {
    'home': {
        'text': '首页'
    },
    'oa': {
        'text': '自动化办公'
    },
    'proj': {
        'text': '项目追踪'
    },
    // 'resManage': {
    //     'text': '资源管理'
    // },
    'doc': {
        'text': '知识库'
    },
    'git': {
        'text': 'Gitlab',
        'url': 'http://192.168.117.144'
    },
    'maven': {
        'text': 'Maven',
        'url': 'http://192.168.117.145:8081'
    }
};
const SUBMENU = {
    'oa': [
        {
            select: true,
            text: '公告',
            key: 'overview'
        }, {
            text: '请假管理',
            key: 'qinjia'
        }, {
            text: '物品管理',
            key: 'wupin'
        },
        {
            text: '资源管理',
            key: 'resources'
        }
    ],
    'proj': [
        {
            select: true,
            text: 'Bug记录',
            key: 'bugs'
        }
    ],
    // 'resManage':[
    //     {
    //         select: true,
    //         text: '资源管理',
    //         key: 'resources'
    //     }
    // ]
}
export {MENU, SUBMENU}

