Array.prototype.contain = function (item) {
    for (var i = 0; i != this.length; ++i) {
        if (this[i] == item) 
            return true
    }
    return false;
}
var employ = [
    '曹崇瑞',
    '崔伟',
    '封超耀',
    '郝敬桃',
    '姬东溟',
    '匡玲',
    '刘贝贝',
    '刘波',
    '刘福明',
    '陆天乐',
    '毛梦莹',
    '钱猛',
    '佘陶陶',
    '王超',
    '王遥',
    '吴锦钰',
    '谢炜',
    '许玉聪',
    '张召',
    '赵鸿飞'
];
var ipMax = 150;
var ipMin = 51;
var pool = [133, 144, 145, 111, 142];
var result = {};
for (var i = 0; i != employ.length; ++i) {
    var arr = [];
    for (var j = 0; j != 3; ++j) {
        var ipp;
        while ((ipp = 51 + parseInt(Math.random() * 100))) {
            if (!pool.contain(ipp)) {
                break;
            }
        }
        pool.push(ipp)
        if (j == 0) {
            ipp = {
                '默认IP': '192.168.117.' + ipp
            }
        } else {
            ipp = '192.168.117.' + ipp;
        }
        arr.push(ipp)
    }
    result[employ[i]] = arr;
}
console.log(JSON.stringify(result))
