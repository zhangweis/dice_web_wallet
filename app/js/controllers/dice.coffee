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
                        transactions = (result.reverse())
                        async.each result.reverse(), (history, cb)->
                            
                            BlockchainAPI.rpc.request('blockchain_get_jackpot_transactions', [history.block_num+1]).then (response) ->
                                jackpots = response.result
                                angular.forEach jackpots, (jackpot)->
                                    if (jackpot.dice_transaction_id==history.trx_id)
                                        history.jackpot = jackpot
                                
                    
    $scope.enlargeBetSizeBy= (enlargeBy)->
        $scope.amount*=enlargeBy;
        $scope.calculateProfit()
