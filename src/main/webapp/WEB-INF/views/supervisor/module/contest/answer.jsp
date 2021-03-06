<%@ page pageEncoding="UTF-8" contentType="text/html; charset=UTF-8"%>
<%@ include file="/WEB-INF/views/supervisor/include/header.jsp"%>
<script type="text/javascript">
var contest = angular.module('Contest', ['ngRoute', 'ui.bootstrap','aon.input.directives', 'ngSanitize',  'aon.admin.diretives', 'Filters'])
.config(function ($httpProvider) {
	$httpProvider.defaults.headers.common = { 'Accept': 'text/html, text/ng-template' };
})
.config(function($routeProvider)
{
	$routeProvider.when('/', {
		controller : 'ContestAnswerListCtl',
		templateUrl : jcontext.getContextPath('/supervisor/module/contest/answerList.aon')
	}).when('/qaview/:id', {
		controller : 'ContestAnswerReadCtl',
		templateUrl : jcontext.getContextPath('/supervisor/module/contest/answerView.aon')
	}).otherwise({
		redirectTo : '/'
	});
});
	
contest.controller('ContestAnswerListCtl', function($scope, $http, $rootScope, $httpParamSerializer) {
	$rootScope.leftMenu = 'answer';
	
	$scope.searchItem = {
			searchKey : 'title',
			startDate : '',
			endDate : ''
		};
	
	// 검색어 유지
	if($rootScope.searchText != undefined && $rootScope.searchText != ''){
		$scope.searchItem.searchKey = $rootScope.searchKey;
		$scope.searchItem.searchText = $rootScope.searchText;
	}
	
	if($rootScope.startDate != undefined && $rootScope.startDate != ''){
		$scope.searchItem.startDate = $rootScope.startDate;
	}
	
	if($rootScope.endDate != undefined && $rootScope.endDate != ''){
		$scope.searchItem.endDate = $rootScope.endDate;
	}
		
	var init = function(data){
		$scope.list = data.list;
		$scope.totalItems = data.count;
		if(!$rootScope.currentPage)
			$scope.currentPage = 1;
	};
	
	var searchParam = function() {
		var param = '&'+$httpParamSerializer($scope.searchItem);
		return param;
	};
	
	$scope.pageChanged = function() {
		$rootScope.currentPage = $scope.currentPage;
		var data = jcontext.loadJSON('/supervisor/module/contest/listAnswer.json?page='+$scope.currentPage + searchParam());
		init(data);
	};	
	
	$scope.checkEnter = function($event){
		var keyCode = $event.which || $event.keyCode;
	    if (keyCode === 13) {
	    	$scope.searchList();
	    }
	};
	
	$scope.searchList = function(){
		$rootScope.searchKey = $scope.searchItem.searchKey;
		$rootScope.searchText = $scope.searchItem.searchText;
		$rootScope.startDate = $scope.searchItem.startDate;
		$rootScope.endDate = $scope.searchItem.endDate;
		$scope.pageChanged();
	};
	
	$scope.searchReset = function(){
		$scope.currentPage = 1;
		$scope.searchItem.searchKey='title';
		$scope.searchItem.searchText=null;
		$scope.searchItem.startDate = '';
		$scope.searchItem.endDate = '';
		$scope.searchList();
	};
	
	$scope.searchList();
})
.controller('ContestAnswerReadCtl',function($scope, $http, $rootScope, $routeParams, $location, $route, safeApply) {
	$rootScope.leftMenu = 'answer';
	
	$scope.contestBtn=true;
	function setValue(data)
	{			
		$scope.item = data.item;
		$scope.answerList = data.answerList;		
	}
	
	// 경고 처리
	$scope.block = function(){
		var id = $scope.item.id;
		jcontext.jsonAction('/supervisor/module/contest/setWarnnig.json','id='+id,
			{
				message:i18n.getLang('contest','process')
			 	,callback: function(data){
					safeApply($scope,function() {
						$route.reload()
					});
			    }
			}
		);		
	};
	
	// 공모 취소 승인 처리
	$scope.permit = function(){
		var id = $scope.item.id;
		jcontext.jsonAction('/supervisor/module/contest/cancel.json','id='+id,
				{
					message:i18n.getLang('contest','process')
				 	,callback: function(data){
						safeApply($scope,function() {
							$route.reload()
						});
				    }
				}
		);
	};
	
	$scope.goAnswerList = function(){
		$location.path('/answerList/');
	}
	
	$scope.load = function(id) {
		var data = jcontext.loadJSON('/supervisor/module/contest/readAnswer.json?id='+id);
		setValue(data); 
	};
	
	$scope.load($routeParams.id);
})
.directive('listContest', function() {
	return function(scope, element, attrs) {
		if(scope.$last){
			element.ready(function () {
				$(".el_txt").dotdotdot({
					watch: "window"
				});
			});
		}
	};
}).directive('numbersOnly', function () {
    return {
        require: 'ngModel',
        link: function (scope, element, attr, ngModelCtrl) {
            function fromUser(text) {
                if (text) {
                    var transformedInput = text.replace(/[^0-9]/g, '');

                    if (transformedInput !== text) {
                        ngModelCtrl.$setViewValue(transformedInput);
                        ngModelCtrl.$render();
                    }
                    return transformedInput;
                }
                return undefined;
            }            
            ngModelCtrl.$parsers.push(fromUser);
        }
    };
});
</script>
<div ng-app="Contest">  
   	<!-- left menu -->
	<%@ include file="/WEB-INF/views/supervisor/include/left.jsp" %>
	<!-- //left menu -->
	<!-- contents -->
	<div class="con">
           <div class="box">
               <div ng-view></div>
           </div>
       </div> 	
    <!-- //contents -->
</div>
<!-- //contents --> 
<%@ include file="/WEB-INF/views/supervisor/include/footer.jsp" %>
