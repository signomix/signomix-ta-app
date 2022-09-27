<app_alert_client>
    // thread for refreshing user alerts
    var self = this
    self.intervalID = null
    self.listener = riot.observable()

    self.listener.on('*', function (event) {
        if('submit:ERROR'==event){
            app.user.name = '';
            app.user.token = '';
            app.user.status = 'logged-out';
            stopRefresh()
            riot.update();
        }
    })
    
    function startRefresh(){
        if (app.alertRefreshInterval > 0){
            self.intervalID=setInterval(function(){ self.refresh() }, app.alertRefreshInterval)
            app.log('STARTED ALERT REFRESH THREAD '+self.intervalID)
        }
    }
    
    function stopRefresh() {
        if (app.alertRefreshInterval > 0){
            app.log('STOPPING REFRESH THREAD '+self.intervalID)
            clearInterval(self.intervalID);
        }
    }
    
    self.refresh = function(){
        app.log('REFRESHING ALERTS ('+self.intervalID+')')
        readAlerts()
    }
    
    var readAlerts = function () {
        getData(app.alertAPI + "/",  // url
                null,                // query
                app.user.token,      // token
                updateMyAlerts,        // callback
                self.listener,       // event listener
                'OK',                // success event name
                'submit:ERROR',                // error event name
                app.debug,           // debug switch
                null         // application event listener
        );
    }

    var updateMyAlerts = function (text) {
        app.user.alerts = JSON.parse(text)
        globalEvents.trigger('alerts:updated')
        riot.update();
    }

    globalEvents.on('auth:loggedin', function (event) {
        startRefresh()
    })

    globalEvents.on('logout:OK', function (event) {
        stopRefresh(self.intervalID)
    })

    globalEvents.on('err:401', function (eventName) {
        app.user.name = '';
        app.user.token = '';
        app.user.status = 'logged-out';
        stopRefresh(self.intervalID)
    })
    globalEvents.on('err:403', function (eventName) {
        app.user.name = '';
        app.user.token = '';
        app.user.status = 'logged-out';
        stopRefresh(self.intervalID)
    })
    
</app_alert_client>