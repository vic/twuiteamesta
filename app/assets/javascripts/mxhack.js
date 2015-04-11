
angular.module("mxhack", [])
  .controller('TweetsCtrl', ['$scope', '$http', Tweets])
  .controller('TweetComposerCtrl', ['$scope', '$http', TweetComposer]);

function Tweets ($scope, $http) {
  $scope.username = 'vic';
  var sse = null;
  $scope.fetch = function () {
    $http.get('/api/fetch/'+$scope.username)
      .then(function (response) { 
        $scope.tweets = response.data.statuses; 
        sse = new EventSource('/api/subscribe/'+$scope.username);
        console.log("Subscribed", sse)
        sse.addEventListener('status-created', function (event) {
          console.log("OMG! a server side event: ", event);;
          var newTweet = JSON.parse(event.data);
          $scope.$apply(function () {
            $scope.tweets.unshift(newTweet);
          })
        })
    })
  }
  $scope.fetch()
}

function TweetComposer ($scope, $http) {
  $scope.username = "vic";
  $scope.status = "";
  
  $scope.create = function () {
    $http.post('/api/create', {username: $scope.username, status: $scope.status})
      .then(function() { $scope.status = ""; })
  }
}
