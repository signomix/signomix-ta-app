<app_session_manager>
    // thread for refreshing session token
    /*
    // It seems that this mechanism is error prone. To be removed.
    var self = this
    self.intervalID = null
    self.listener = riot.observable()

    self.listener.on('*', function (event) {
        if('submit:ERROR'==event){
            app.user.name = '';
            app.user.token = '';
            app.user.status = 'logged-out';
            stopSessionRefresh()
            riot.update();
        }
    })
    
    function startSessionRefresh(){
        if (app.sessionRefreshInterval > 0){
            self.intervalID=setInterval(function(){ self.refresh() }, app.sessionRefreshInterval)
            app.log('STARTED SESSION REFRESH THREAD '+self.intervalID)
        }
    }
    
    function stopSessionRefresh() {
        if (app.sessionRefreshInterval > 0){
            app.log('STOPPING REFRESH THREAD '+self.intervalID)
            clearInterval(self.intervalID);
        }
    }
    
    self.refresh = function(){
        app.log('REFRESHING SESSION TOKEN ('+self.intervalID+')')
        var formData = {enything:''}
        sendData(
                formData,
                'PUT',
                app.authAPI,
                app.user.token,
                self.submitted,
                self.listener,
                'submit:OK',
                'submit:ERROR',
                app.debug,
                null
                )
    }
    
    self.submitted = function(){
    }

    globalEvents.on('auth:loggedin', function (event) {
        startSessionRefresh()
    })

    globalEvents.on('logout:OK', function (event) {
        stopSessionRefresh()
    })

    globalEvents.on('err:401', function (eventName) {
        app.user.name = '';
        app.user.token = '';
        app.user.status = 'logged-out';
        stopSessionRefresh()
        riot.update();
    })
    globalEvents.on('err:403', function (eventName) {
        app.user.name = '';
        app.user.token = '';
        app.user.status = 'logged-out';
        stopSessionRefresh()
        riot.update();
    })
    
    globalEvents.on('err:403', function (eventName) {
        //komunikat o zmianie uprawnień
        riot.update();
    })
    */
</app_session_manager>
