angular.module("app").controller "DiceController", ($scope, $filter, $location, $stateParams, $q, Growl, Wallet, Utils, WalletAPI, $modal, Blockchain, BlockchainAPI, Info) ->
    $scope.amount = 0
    $scope.diceSmall =$scope.diceBig = ->
        Wallet.get_current_or_first_account().then (account)->
            Wallet.wallet_dice(account.name, $scope.amount, 2).then (tx)->
                console.log(tx);

