<app_logout>
    <div class="row">
        <div class="col-md-12">logout</div>
    </div>
    <script charset="UTF-8">
        var self = this;
        self.listener = riot.observable()
        
        globalEvents.on('logout:OK', function (eventName) {
            app.log("RECEIVED: "+eventName)
            self.afterLogout()
        });
        globalEvents.on('logout:ERR', function (eventName) {
            app.log("RECEIVED: "+eventName)
            self.afterLogout()
        });
        
        this.on('mount',function(){
            app.log("LOGOUT");
            sendLogout();
        })
        
        sendLogout = function () {
            deleteData(app.authAPI+'/'+app.user.token,
                    app.user.token,
                    self.afterLogout,
                    globalEvents, //globalEvents
                    'logout:OK',
                    'logout:ERR',
                    app.debug,
                    globalEvents
                    );
        }

        self.afterLogout = function (event) {
            app.log("LOGOUT!");
            app.user.name=''
            app.user.token=''
            app.user.status='logged-out'
            app.user.role=''
            app.user.roles=[]
            app.user.guest=false
            app.user.dashboards = []
            //route('main')
            document.location='#!'
        }

    </script>
</app_logout>