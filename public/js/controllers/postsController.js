angular.module("miniBlogApp").controller("postsController", function($scope, postsAPI) {
	$scope.posts = [];
	$scope.pages = [];

	$scope.loadPosts = function(page) {
		postsAPI.getPosts(page).then(function onSuccess(response) {
			$scope.posts = response.data.posts;
			for (var i=0; i < response.data.total_pages; i++)
				$scope.pages[i] = i+1;
		});
	}

	$scope.loadPosts();
});