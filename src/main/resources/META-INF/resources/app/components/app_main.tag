<app_main>
    <div class="row" if={ isUpdateRequired() }>
        <div class="col-md-12">
            <div class="alert alert-danger" role="alert">
            <form onsubmit="{self.reloadPage}">
                <p>{ app.texts.main.outdated[app.language] }</p>
                <button type="submit" class="btn btn-primary" >{ app.texts.main.reload_page[app.language] }</button>
            </form>
            </div>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            <cs_article class="container" ref="homeart" path='/home' language={ app.language }></cs_article>
        </div>
    </div>
    <div class="row">
        <div class="col-md-12">
            <div class="text-center" if={app.user.status == 'logged-in' && !app.user.guest}>
                <a href="#!mydashboards" onclick={ goto('#!mydashboards') } >{ app.texts.main.mydashboards[app.language] }</a><br>
                <a href="#!mydevices" onclick={ goto('#!mydevices') } >{ app.texts.main.mydevices[app.language] }</a><br>
            </div>
            <div class="text-center" if={app.user.status != 'logged-in' || (app.user=='public' && app.user.guest==true)}>
                <a href="#!login" onclick={ goto('#!login') }>{ app.texts.main.login[app.language] }</a><br>
                <a href="#!register" onclick={ goto('#!register') }>{ app.texts.main.registerAccount[app.language] }</a><br>
                <a href="/">{ app.texts.main.mainpage[app.language] }</a>
            </div>
        </div>
    </div>
    <script charset="UTF-8">
        var self = this;
        self.refs=[]
        self.release_on_server=''

        this.on('unmount',function(){
            Object.keys(self.refs).forEach(function(key) {
                self.refs[key].unmount()
            });
            self.refs=[]
        })
        this.on('mount',function(){
            readRelease()
            self.loadDocuments()
        })
        globalEvents.on('language',function(){
            self.loadDocuments()
        })
        self.loadDocuments = function(){
            //app.log(self.refs)
            Object.keys(self.refs).forEach(function(key) {
                self.refs[key].updateContent()
            });
        }
        goto(address){
            return function(e){
                app.log(address)
                document.location = address
            }
        }
        self.reloadPage =function(e){
            e.preventDefault()
            window.location.reload(true)
        }
        self.isUpdateRequired = function(){
            var result=!(self.release_on_server===''||self.release_on_server===null || app.release===self.release_on_server)
            return result
        }
        var readRelease = function () {
            getData("/api/app/config?param=release",  // url
                    null,                // query
                    null,      // token
                    updateRelease,        // callback
                    null,       // event listener
                    'OK',                // success event name
                    null,                // error event name
                    app.debug,           // debug switch
                    null         // application event listener
                    );
        }
        var updateRelease = function (text) {
            self.release_on_server = text
            riot.update();
        }
        
    </script>
</app_main>