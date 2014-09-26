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
    $scope.precision = 1000000
    $scope.reloadDices = ->
        BlockchainAPI.get_block_count().then (blockCount) ->
            console.log(blockCount);
            startBlock = blockCount-30*24*60*60/5;
            if (startBlock<0)
                startBlock = 0
            
            Wallet.rpc.request('wallet_account_dice_transaction_history', ["", "", 0, startBlock, -1]).then (result) =>
                transactions = (result.result.reverse())
                $scope.transactions = transactions
                angular.forEach transactions, (tx) ->
                    tx.transaction_id_prev = tx.transaction.record_id.substring(0, 8)
                    if (!tx.has_jackpot)
                        tx.jackpot.play_amount = tx.dice.amount;
                        tx.jackpot.payouts = tx.dice.payouts;
                    else
                        tx.jackpot.lucky_number/= 10
                        tx.jackpot.jackpot_received/= $scope.precision
                    tx.jackpot.play_amount /= $scope.precision;
                    console.log(tx);

        
    $scope.calculateFromProfit=->
        $scope.amount = $scope.profit / ($scope.payouts-1)
    Wallet.get_current_or_first_account().then (account)->
        $scope.balance = Wallet.balances[account.name]['JDST']
        $scope.precision = $scope.balance.precision;
        $scope.balance = $scope.balance.amount / $scope.balance.precision
        $scope.reloadDices()
        $scope.diceSmall =$scope.diceBig = ->
            Wallet.dice(account.name, $scope.amount, $scope.payouts).then (tx)->
                console.log(tx);
                $scope.reloadDices()                

    $scope.enlargeBetSizeBy= (enlargeBy)->
        $scope.amount*=enlargeBy;
        $scope.calculateProfit()
