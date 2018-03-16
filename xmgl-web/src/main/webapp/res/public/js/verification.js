
function isEmail(str){
       var reg = /^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+((\.[a-zA-Z0-9_-]{2,3}){1,2})$/;
       return reg.test(str);
}

function isPhone(str){
       var reg = /^14[0-9]{9}$|13[0-9]{9}$|15[0-9]{9}$|18[0-9]{9}$/;
       return reg.test(str);
}
function isTelPhone(str){
       var reg = /^(0[0-9]{2,3}\-)?([2-9][0-9]{6,7})+(\-[0-9]{1,4})?$/;
       return reg.test(str);
}

function isIdCards(str){
	var reg = /(^\d{15}$)|(^\d{18}$)|(^\d{17}(\d|X|x)$)/;  
    return reg.test(str);
}
