angular.module("app").controller "AccountController", ($scope, $location, $stateParams, Growl, Wallet, Utils, WalletAPI, $modal) ->

    name = $stateParams.name
    #$scope.accounts = Wallet.receive_accounts
    #$scope.account.balances = Wallet.balances[name]
    #$scope.utils = Utils
    $scope.account = Wallet.accounts[name]
    console.log('act')
    console.log(Wallet.accounts[name])


    $scope.balances = Wallet.balances[name]
    $scope.formatAsset = Utils.formatAsset

    #Wallet.refresh_accounts()
    $scope.trust_level=Wallet.trust_levels[name]
    $scope.wallet_info = {file : "", password : ""}
    
    $scope.private_key = {value : ""}
    
    refresh_account = ->
        Wallet.get_account(name).then (acct) ->
            $scope.account = acct
            $scope.balances = Wallet.balances[name]
            Wallet.refresh_transactions(name)
    refresh_account()

    $scope.import_key = ->
        WalletAPI.import_private_key($scope.private_key.value, $scope.account.name).then (response) ->
            $scope.private_key.value = ""
            Growl.notice "", "Your private key was successfully imported."
            refresh_account()

    $scope.register = ->
        WalletAPI.account_register($scope.account.name, $scope.account.name).then (response) ->
            Wallet.refresh_account()

    $scope.import_wallet = ->
        WalletAPI.import_bitcoin($scope.wallet_info.file,$scope.wallet_info.password,$scope.account.name).then (response) ->
            $scope.wallet_info.file = ""
            $scope.wallet_info.password = ""
            Growl.notice "The wallet was successfully imported."
            refresh_account()

    $scope.send = ->
        WalletAPI.transfer($scope.amount, $scope.symbol, $scope.account.name, $scope.payto, $scope.memo).then (response) ->
            $scope.payto = ""
            $scope.amount = ""
            $scope.memo = ""
            Growl.notice "", "Transaction broadcasted (#{angular.toJson(response.result)})"
            refresh_account()

    $scope.toggleVoteUp = ->
        if name not of Wallet.trust_levels or Wallet.trust_levels[name] < 1
            Wallet.set_trust(name, 1)
        else
            Wallet.set_trust(name, 0)

    $scope.toggleFavorite = ->
        if (Wallet.accounts[name].private_data)
            private_data=Wallet.accounts[name].private_data
        else
            private_data={}
        if !(private_data.gui_data)
            private_data.gui_data={}
        private_data.gui_data.favorite=!(private_data.gui_data.favorite)
        Wallet.account_update_private_data(name, private_data).then ->
            $scope.account.private_data=Wallet.accounts[name].private_data
            console.log($scope.account.private_data)

    $scope.regDial = ->
        $modal.open
          templateUrl: "registration.html"
          #controller: "NewContactController"
          resolve:
            refresh:  -> $scope.refresh_addresses
