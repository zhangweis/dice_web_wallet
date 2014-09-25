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
                BlockchainAPI.get_block_count().then (blockCount) ->
                    console.log(blockCount);
                    startBlock = blockCount-30*24*60*60/5;
                    if (startBlock<0)
                        startBlock = 0
                    
                    Wallet.wallet_api.account_transaction_history("", "", 0, startBlock, -1).then (result) =>
                        console.log(result.reverse())
                        angular.forEach result.reverse(), (history)->
                            Wallet.rpc.request('get_transaction', [history.trx_id]).then (response) ->
                                tx = response.result
                                console.log(history.trx_id)
                                console.log(tx)
                                
                    
    $scope.enlargeBetSizeBy= (enlargeBy)->
        $scope.amount*=enlargeBy;
        $scope.calculateProfit()
