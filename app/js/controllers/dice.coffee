angular.module("app").controller "DiceController", ($scope, $filter, $location, $stateParams, $q, Growl, Wallet, Utils, WalletAPI, $modal, Blockchain, BlockchainAPI, Info) ->
    $scope.amount = 10
    $scope.payouts = 2
    $scope.calculateProfit=->
        $scope.profit = $scope.amount*($scope.payouts-1)
    $scope.calculateProfit()
    $scope.$watch 'payouts',->
        $scope.chancePercent = (100-1)/$scope.payouts
        $scope.win = {
            lessThan : $scope.chancePercent,
            greaterThan : 100-$scope.chancePercent
        }
        $scope.calculateProfit()
        
    $scope.calculateFromProfit=->
        $scope.amount = $scope.profit / ($scope.payouts-1)
    Wallet.get_current_or_first_account().then (account)->
        $scope.balance = Wallet.balances[account.name]['JDST']
        $scope.balance = $scope.balance.amount / $scope.balance.precision
        $scope.diceSmall =$scope.diceBig = ->
            Wallet.dice(account.name, $scope.amount, $scope.payouts).then (tx)->
                console.log(tx);
                @wallet_api.account_transaction_history("", "", 0, Wallet.transactions_last_block, -1).then (result) =>
                    console.log(result)                    
                    
    $scope.enlargeBetSizeBy= (enlargeBy)->
        $scope.amount*=enlargeBy;
        $scope.calculateProfit()
