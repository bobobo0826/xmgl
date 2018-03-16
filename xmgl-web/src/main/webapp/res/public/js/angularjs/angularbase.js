var setModuleRequest = function(module)
{
	module.config(function($httpProvider) {
	    $httpProvider.defaults.headers.put['Content-Type'] = 'application/x-www-form-urlencoded';
	    $httpProvider.defaults.headers.post['Content-Type'] = 'application/x-www-form-urlencoded';
	    // Override $http service's default transformRequest
	    $httpProvider.defaults.transformRequest = [function(data) {
	        /**
	         * The workhorse; converts an object to x-www-form-urlencoded serialization.
	         * @param {Object} obj
	         * @return {String}
	         */
	        var param = function(obj) {
	            var query = '';
	            var name, value, fullSubName, subName, subValue, innerObj, i;
	 
	            for (name in obj) {
	                value = obj[name];
	 
	                if (value instanceof Array) {
	                    for (i = 0; i < value.length; ++i) {
	                        subValue = value[i];
	                        fullSubName = name + '[' + i + ']';
	                        innerObj = {};
	                        innerObj[fullSubName] = subValue;
	                        query += param(innerObj) + '&';
	                    }
	                } else if (value instanceof Object) {
	                    for (subName in value) {
	                        subValue = value[subName];
	                        fullSubName = name + '.' + subName;
	                        innerObj = {};
	                        innerObj[fullSubName] = subValue;
	                        query += param(innerObj) + '&';
	                    }
	                } else if (value !== undefined && value !== null) {
	                    query += encodeURIComponent(name) + '='
	                            + encodeURIComponent(value) + '&';
	                }
	            }
	 
	            return query.length ? query.substr(0, query.length - 1) : query;
	        };
	 
	        return angular.isObject(data) && String(data) !== '[object File]'
	                ? param(data)
	                : data;
	    }];
	});
}

var directives = angular.module('app.directives',[]);


directives.directive('ngUpdateHidden', function () {
    return {
        restrict: 'AE', //attribute or element
        scope: {},
        replace: true,
        require: 'ngModel',
        link: function ($scope, elem, attr, ngModel) {
            $scope.$watch(ngModel, function (nv) {
                elem.val(nv);
            });
            elem.change(function () {
                $scope.$apply(function () {
                    ngModel.$setViewValue(  elem.val());
                });
            });
        }
    };
});

directives.directive('layDate', function() {
    return {
        require: '?ngModel',
        restrict : 'A',
        scope:{
            ngModel: '='
        },
        link : function(scope, element, attr,ngModel) {
            // Specify how UI should be updated
            ngModel.$render = function() {
              element.val(ngModel.$viewValue || '');
            };
            // Listen for change events to enable binding
            element.on('blur keyup change', function() {
              scope.$apply(read);
            });
            read(); // initialize
            // Write data to the model
            function read() {
              var val = element.val();
              ngModel.$setViewValue(val);
            }
            if (attr.skin)
                laydate.skin(attr.skin);
            laydate({
                elem : '#' + attr.id,
                format:attr.format!=undefined&&attr.format!=''?attr.format:'YYYY-MM-DD',
                istime:attr.istime,
                choose:function(data){
                    scope.$apply(read);
                }
            });
        }
    }
});
