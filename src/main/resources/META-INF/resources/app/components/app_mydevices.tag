<app_mydevices>
    <div class="row" if={ selected!=='' }>
         <div class="col-md-12">
            <app_device_form ref="dev_edit"></app_device_form>
        </div>
    </div>
    <div class="row" if={ selectedGroup!=='' }>
         <div class="col-md-12">
            <app_group_form ref="gr_edit"></app_group_form>
        </div>
    </div>
     <div class="row" if={ selectedApplication!=='' }>
         <div class="col-md-12">
            <app_application_form ref="app_edit"></app_application_form>
        </div>
    </div>
    <div class="row" if={ selected=='' && selectedGroup==='' && selectedApplication===''}>
        <div class="col-md-12">
            <h2 class="module-title">{app.texts.mydevices.devices[app.language]}
                <i class="material-icons clickable" onclick="{ refresh() }" aria-label="refresh" title="REFRESH">refresh</i>
                <i class="material-icons clickable" onclick={ create() } title="ADD NEW">add_circle_outline</i>
                <i class="material-icons clickable" onclick={ createFromTemplate() } title="ADD PRODUCT" if="{activeTab=='devices'}">filter_none</i>
            </h2>
            <ul class="nav nav-tabs">
                <li class="nav-item">
                    <a class="nav-link { active: activeTab=='devices' }" onclick="{ selectDevices() }">{app.texts.mydevices.tab_devices[app.language]}</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link { active: activeTab=='groups' }" onclick="{ selectGroups() }">{app.texts.mydevices.tab_groups[app.language]}</a>
                </li>
                <li class="nav-item">
                    <a class="nav-link { active: activeTab=='applications' }" onclick="{ selectApplications() }">{app.texts.mydevices.tab_applications[app.language]}</a>
                </li>
            </ul>
            <table id="devices" class="table table-condensed table-striped" if="{activeTab=='devices'}">
                <thead>
                    <tr>
                        <th>{app.texts.mydevices.header_eui[app.language]}</th>
                        <th>{app.texts.mydevices.header_name[app.language]}</th>
                        <th>{app.texts.mydevices.header_type[app.language]}</th>
                        <th>{app.texts.mydevices.header_status[app.language]}</th>
                        <th class="text-right">{app.texts.mydevices.header_action[app.language]}</th>
                    </tr>
                </thead>
                <tbody>
                    <tr each={device in myDevices}>
                        <td>{(device.userID!=app.user.name?'&Implies;':'')}{device.eui}</td>
                        <td>{device.name}</td>
                        <td>{device.type}</td>
                        <td><img height="16px" style="margin-right: 10px;" src={ getStatus(device.lastSeen, device.transmissionInterval, device.alertStatus) }></td>
                        <td class="text-right">
                            <i class="material-icons clickable" onclick="{ selectForDownload(device.eui, device.name) }" title="DOWNLOAD DATA" data-toggle="modal" data-target="#downloadModal">cloud_download</i>
                            <i class="material-icons clickable" onclick={ editDevice(device.eui, false) } title="VIEW">open_in_browser</i>
                            <i class="material-icons clickable" if={device.userID == app.user.name || device.administrators.includes(','+app.user.name+',')} onclick={ editDevice(device.eui, true) } title="MODIFY">mode_edit</i>
                            <i class="material-icons clickable" if={device.userID == app.user.name || device.administrators.includes(','+app.user.name+',')} onclick={ selectForRemove(device.eui) } title="REMOVE" data-toggle="modal" data-target="#myModal">delete</i>
                        </td>
                    </tr>
                </tbody>
            </table>
            <table id="devices" class="table table-condensed table-striped" if="{activeTab=='groups'}">
                <thead>
                    <tr>
                        <th>{app.texts.mydevices.header_eui[app.language]}</th>
                        <th>{app.texts.mydevices.header_name[app.language]}</th>
                        <th class="text-right">{app.texts.mydevices.header_action[app.language]}</th>
                    </tr>
                </thead>
                <tbody>
                    <tr each={group in myGroups}>
                        <td>{(group.userID!=app.user.name?'&Implies;':'')}{group.EUI}</td>
                        <td>{group.name}</td>
                        <td class="text-right">
                            <i class="material-icons clickable" onclick={ editGroup(group.EUI, false) }>open_in_browser</i>
                            <i class="material-icons clickable" if={group.userID == app.user.name || group.administrators.includes(','+app.user.name+',')} onclick={ editGroup(group.EUI, true) }>mode_edit</i>
                            <i class="material-icons clickable" if={group.userID == app.user.name || group.administrators.includes(','+app.user.name+',')} onclick={ selectGroupForRemove(group.EUI) } data-toggle="modal" data-target="#myGroupModal">delete</i>
                        </td>
                    </tr>
                </tbody>
            </table>
            <table id="applications" class="table table-condensed table-striped" if="{activeTab=='applications'}">
                <thead>
                    <tr>
                        <th>{app.texts.mydevices.header_id[app.language]}</th>
                        <th>{app.texts.mydevices.header_name[app.language]}</th>
                        <th class="text-right">{app.texts.mydevices.header_action[app.language]}</th>
                    </tr>
                </thead>
                <tbody>
                    <tr each={app in myApplications}>
                        <td>{app.id}</td>
                        <td>{app.name}</td>
                        <td class="text-right">
                            <i class="material-icons clickable" onclick={ editApplication(app.id, false) }>open_in_browser</i>
                            <i class="material-icons clickable" if={isAdmin()} onclick={ editApplication(app.id, true) }>mode_edit</i>
                            <i class="material-icons clickable" if={isAdmin()} onclick={ selectApplicationForRemove(app.id) } data-toggle="modal" data-target="#myApplicationModal">delete</i>
                        </td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>
    <!-- Modal -->
        <div class="modal fade" id="myModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalLabel">{app.texts.mydevices.remove_title[app.language]}</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label={app.texts.mydevices.cancel[app.language]}>
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <p><b>{ selectedForRemove }</b></p>
                        <p>{app.texts.mydevices.remove_question[app.language]}</p>
                        <p class="text-danger">{app.texts.mydevices.remove_info[app.language]}</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary" onclick={ removeDevice() } data-dismiss="modal">{app.texts.mydevices.remove[app.language]}</button>
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">{app.texts.mydevices.cancel[app.language]}</button>
                    </div>
                </div>
            </div>
        </div>
        <div class="modal fade" id="myGroupModal" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalLabel">{app.texts.mydevices.remove_g_title[app.language]}</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label={app.texts.mydevices.cancel[app.language]}>
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <p><b>{ selectedGroupForRemove }</b></p>
                        <p>{app.texts.mydevices.remove_g_question[app.language]}</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary" onclick={ removeGroup() } data-dismiss="modal">{app.texts.mydevices.remove[app.language]}</button>
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">{app.texts.mydevices.cancel[app.language]}</button>
                    </div>
                </div>
            </div>
        </div>
        <div class="modal fade" id="myApplicationModal" tabindex="-1" role="dialog" aria-labelledby="myApplicationLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalLabel">{app.texts.mydevices.remove_a_title[app.language]}</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label={app.texts.common.cancel[app.language]}>
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <p><b>{ selectedApplicationForRemove }</b></p>
                        <p>{app.texts.mydevices.remove_a_question[app.language]}</p>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary" onclick={ removeApplication() } data-dismiss="modal">{app.texts.mydevices.remove[app.language]}</button>
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">{app.texts.common.cancel[app.language]}</button>
                    </div>
                </div>
            </div>
        </div>
        <div class="modal fade" id="downloadModal" tabindex="-1" role="dialog" aria-labelledby="downloadLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalLabel">{app.texts.mydevices.download_title[app.language]}</h5>
                        <button disabled type="button" class="close" data-dismiss="modal" aria-label={app.texts.mydevices.cancel[app.language]}>
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <div>
                            <p><b>{ selectedForDownloadName }</b><br>EUI: { selectedForDownload }</p>
                        </div>
                        <div if="{dataURL!=''}">
                            <a href="{dataURL}">{app.texts.mydevices.download_open[app.language]}</a>
                        </div>
                        <div if="{downloadStarted==false}">
                            <p>{app.texts.mydevices.download_comment[app.language]} <span if="{downloadPercent!=''}">({downloadPercent})</span></p>
                            <p>{app.texts.mydevices.download_comment2[app.language]} </p>
                            <div class="form-group col-md-6">
                            Od daty
                            <input type="datetime-local" id="from_date" class="form-control" value={ '' }/>
                            Do daty
                            <input type="datetime-local" id="to_date" class="form-control" value={ '' }/>
                            </div>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <button if="{!downloadStarted}" disabled="{downloadStarted}" type="button" class="btn btn-primary" onclick="{ download(null) }">{app.texts.mydevices.download_download[app.language]}</button>
                        <button type="button" class="btn btn-secondary" onclick="{ closeDownload() }" data-dismiss="modal">{app.texts.common.close[app.language]}</button>
                    </div>
                </div>
            </div>
        </div>
        <script charset="UTF-8">
        var self = this
        self.devListener = riot.observable()
        self.downloadListener = riot.observable()
        self.progressListener = riot.observable()
        self.info = {}
        self.myDevices = []
        self.myGroups = []
        self.myApplications = []
        self.selected = ''
        self.selectedGroup= ''
        self.selectedApplication = ''
        self.selectedForRemove = ''
        self.selectedGroupForRemove = ''
        self.selectedApplicationForRemove = ''
        self.selectedForDownload=''
        self.selectedForDownloadName=''
        self.downloadPercent=''
        //self.edited = false
        self.now = Date.now()
        self.activeTab = 'devices'
        self.dataURL = ''
        self.downloadStarted=false
        self.downloadComplete=false
        
        this.on('mount',function(){
            self.selected = ''
            readMyDevices()
        })

        self.devListener.on('*', function (eventName) {
            switch (eventName){
                case 'submitted':
                    //app.log('after submit device')
                    if(self.activeTab == 'groups'){
                        self.selectedGroup = ''
                        readMyGroups()
                    }else if(self.activeTab == 'applications'){
                        self.selectedApplication = ''
                        readMyApplications()
                    }else{
                        self.selected = ''
                        readMyDevices()  //this line results in logout,login error
                    }
                    break
                case 'cancelled':
                    self.selected = ''
                    self.selectedGroup = ''
                    self.selectedApplication = ''
                    self.dataURL = ''
                    break
                default:
                    app.log('ACCOUNT: error ' + eventName)
            }
            riot.update()
        });

        self.downloadListener.on('*', function (eventName) {
            console.log('download event: '+eventName)
            if('dataloaded'==eventName){
                self.downloadComplete=true
            }
        })

        self.progressListener.on('*', function (eventName) {
            console.log('progressListener: '+eventName)
            console.log(eventName)
            //if (oEvent.lengthComputable) {
            //var percentComplete = (oEvent.loaded / oEvent.total)*100;
            //self.downloadPercent=percentComplete+'%'
            riot.update()
            //} 
        })
        
        selectDevices(){
            return function(e){
                e.preventDefault()
                self.activeTab = 'devices'
                readMyDevices()
            }
        }
        
        selectGroups(){
            return function(e){
                e.preventDefault()
                self.activeTab = 'groups'
                readMyGroups()
            }
        }

        selectApplications(){
            return function(e){
                e.preventDefault()
                self.activeTab = 'applications'
                readMyApplications()
            }
        }
        
        getStatus(lastSeen, interval, alertStatus){
            if((self.now-lastSeen>interval) || alertStatus==2){
                return '/app/images/KO.svg'
            }else{
                return '/app/images/OK.svg'
            }
        }

        isAdmin(){
            return app.user.roles.indexOf('admin')>-1
        }
        
        create(){
            return function(e){
                e.preventDefault()
                if(self.activeTab=='groups'){
                    self.selectedGroup='NEW'
                    riot.update()
                    self.refs.gr_edit.init(self.devListener, 'NEW', true)
                }else if(self.activeTab=='applications'){
                    self.selectedApplication='NEW'
                    riot.update()
                    self.refs.app_edit.init(self.devListener, 'NEW', true)
                }else{
                    self.selected='NEW'
                    riot.update()
                    self.refs.dev_edit.init(self.devListener, 'NEW', true, false)
                }
            }
        }
        
        createFromTemplate(){
            return function(e){
                e.preventDefault()
                if(self.activeTab==='devices'){
                    self.selected='NEW'
                    riot.update()
                    self.refs.dev_edit.init(self.devListener, 'NEW', true, true)
                }
            }
        }
        
        editDevice(devEUI, allowEdit){
            return function(e){
                e.preventDefault()
                self.selected=devEUI
                riot.update()
                self.refs.dev_edit.init(self.devListener, devEUI, allowEdit, false)
            }
        }
                
        selectForRemove(devEUI){
            return function(e){
                e.preventDefault()
                self.selectedForRemove=devEUI
                riot.update()
            }
        }
        
        selectForDownload(devEUI,devName){
            return function(e){
                e.preventDefault()
                self.selectedForDownload=devEUI
                self.selectedForDownloadName=devName
                console.log('selectedForDownload:'+self.selectedForDownload)
                self.downloadPercent=''
                self.downloadStarted=false
                self.dataURL=''
                riot.update()
            }
        }
        
        editGroup(grEUI, allowEdit){
            return function(e){
                e.preventDefault()
                self.selectedGroup=grEUI
                riot.update()
                self.refs.gr_edit.init(self.devListener, grEUI, allowEdit)
            }
        }
        
        selectGroupForRemove(grEUI){
            return function(e){
                e.preventDefault()
                self.selectedGroupForRemove=grEUI
                riot.update()
            }
        }

        editApplication(appID, allowEdit){
            return function(e){
                e.preventDefault()
                self.selectedApplication=appID
                console.log('selectedApplication:'+self.selectedApplication)
                riot.update()
                self.refs.app_edit.init(self.devListener, appID, allowEdit)
            }
        }
        
        selectApplicationForRemove(appEUI){
            return function(e){
                e.preventDefault()
                self.selectedApplicationForRemove=appEUI
                riot.update()
            }
        }
        
        removeDevice(){
            return function(e){
                app.log('REMOVING ... '+self.selectedForRemove)
                deleteData( 
                    app.iotAPI+'/'+self.selectedForRemove, 
                    app.user.token, 
                    self.afterRemove, 
                    null, //self.listener, 
                    'submit:OK', 
                    'submit:ERROR', 
                    app.debug, 
                    null //globalEvents
                )
            }
        }
        
        self.afterRemove = function(object){
            self.selectedForRemove = ''
            readMyDevices()
        }
        
        removeGroup(){
            return function(e){
                app.log('REMOVING ... '+self.selectedGroupForRemove)
                deleteData( 
                    app.groupAPI+'/'+self.selectedGroupForRemove, 
                    app.user.token, 
                    self.afterGroupRemove, 
                    null, //self.listener, 
                    'submit:OK', 
                    'submit:ERROR', 
                    app.debug, 
                    null //globalEvents
                )
            }
        }
        removeApplication(){
            return function(e){
                app.log('REMOVING ... '+self.selectedApplicationForRemove)
                deleteData( 
                    app.applicationAPI+'/'+self.selectedApplicationForRemove, 
                    app.user.token, 
                    self.afterApplicationRemove, 
                    null, //self.listener, 
                    'submit:OK', 
                    'submit:ERROR', 
                    app.debug, 
                    null //globalEvents
                )
            }
        }


        
        self.handleFile=function(resp){
            console.log('handleFile: '+resp)
            console.log(resp)
            self.dataURL=URL.createObjectURL(resp)
            riot.update()
        }
        self.showProgress=function(oEvent){
            console.log('showProgress: '+oEvent)
            console.log(oEvent)
            if (oEvent.lengthComputable) {
            var percentComplete = (oEvent.loaded / oEvent.total)*100;
            self.downloadPercent=percentComplete+'%'
            riot.update()
            } 
        }
        self.showProgress2=function(oEvent){
            console.log('showProgress2: '+oEvent)
            console.log(oEvent)
            if (oEvent.lengthComputable) {
            var percentComplete = (oEvent.loaded / oEvent.total)*100;
            self.downloadPercent=percentComplete+'%'
            riot.update()
            } 
        }

        closeDownload(){
            //self.dataURL=''
            //self.downloadStarted=false;
            //self.downloadPercent=''
            //self.selectedForDownload=''
            //self.selectedForDownloadName=''
        }
        
        download(form){
            return function(e){
                var dt
                var fromTs=document.getElementById('from_date').value
                var toTs=document.getElementById('to_date').value
                var query='query=channel *'    // 'query=channel%20*%20last%20*%20csv.timeseries'
                if(fromTs!==''){
                    dt=new Date(fromTs)
                    fromTs=dt.toISOString()
                }
                if(toTs!==''){
                    dt=new Date(toTs)
                }else{
                    dt=new Date()
                }
                toTs=dt.toISOString()
                if(from_date===''){
                    query=query+' last *'
                }else{
                    query=query+' from '+fromTs+' to '+toTs
                }
                self.downloadStarted=true
                //TODO: toTs=now
                //query=query+' csv.timeseries' 
                getData( 
                    app.dataAPI+'/'+self.selectedForDownload+'/*?tid='+app.user.token+'&'+query,
                    '',
                    '', 
                    self.handleFile, 
                    self.downloadListener, 
                    'submit:OK', 
                    'submit:ERROR', 
                    app.debug, 
                    self.progressListener, //globalEvents
                    "text/csv",
                    self.showProgress
                )
            }    
            
        }
        
        self.afterGroupRemove = function(object){
            self.selectedGroupForRemove = ''
            readMyGroups()
        }
        self.afterApplicationRemove = function(object){
            self.selectedApplicationForRemove = ''
            readMyApplications()
        }
        
        refresh(){
            return function(e){
                e.preventDefault()
                if(self.activeTab == 'groups'){
                    readMyGroups()
                }else if(self.activeTab == 'applications'){
                    readMyApplications()
                }else{
                    readMyDevices()
                }
            }
        }
        
        var readMyDevices = function() {
                app.log('reading devices ...')
                getData(app.iotAPI+'?full=true',
                    null,
                    app.user.token,
                    updateMyDevices,
                    self.listener, //globalEvents
                    'OK',
                    null, // in case of error send response code
                    app.debug,
                    globalEvents
                    );
        }

        var updateMyDevices = function (text) {
            self.myDevices = JSON.parse(text);
            self.myDevices.sort((a,b)=>{
                let fa = a.name.toLowerCase(),
                fb = b.name.toLowerCase();
                if (fa < fb) {
                    return -1;
                }
                if (fa > fb) {
                    return 1;
                }
                return 0;
            })
            riot.update();
        }

        var readMyGroups = function() {
                app.log('reading groups ...')
                getData(app.groupAPI,
                    'offset=0&limit=100',
                    app.user.token,
                    updateMyGroups,
                    self.listener, //globalEvents
                    'OK',
                    null, // in case of error send r!mydevicesesponse code
                    app.debug,
                    globalEvents
                    );
        }

        var updateMyGroups = function (text) {
            app.log("ACCOUNT: " + text)
            self.myGroups = JSON.parse(text);
            riot.update();
        }
        var readMyApplications = function() {
                app.log('reading applications ...')
                getData(app.applicationAPI,
                    null,
                    app.user.token,
                    updateMyApplications,
                    self.listener, //globalEvents
                    'OK',
                    null, // in case of error send response code
                    app.debug,
                    globalEvents
                    );
        }

        var updateMyApplications = function (text) {
            app.log("ACCOUNT: " + text)
            self.myApplications = JSON.parse(text);
            riot.update();
        }
    </script> 
</app_mydevices>
