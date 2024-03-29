<app_dashboard2>
<!-- Modal -->
    <div class="modal fade" id="linkView" tabindex="-1" role="dialog" aria-labelledby="shared link view" aria-hidden="true" if={ !app.embeded}>
    <div class="modal-dialog" role="document">
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title w-100" id="myModalLabel">{ app.texts.dashboard2.dialogTitle[app.language] }</h4>
                <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                    <span aria-hidden="true">&times;</span>
                </button>
            </div>
            <div class="modal-body">
                <form>
                    <div class="form-group">
                        <p>{ app.texts.dashboard2.line1[app.language] }</p>
                        <input type="text" class="form-control" id="link" onclick="this.select();" value={ sharedLink }/>
                    </div>
                    <div class="form-group">
                        <p>{ app.texts.dashboard2.line2[app.language] }</p>
                        <textarea class="form-control" rows="5" onclick='this.select();'>{ sharedEmbeded }</textarea>
                        <p>{ app.texts.dashboard2.line3[app.language] }</p>
                    </div>
                </form>
            </div>
            <div class="modal-footer">
                <button type="button" class="btn btn-primary" data-dismiss="modal">{ app.texts.dashboard2.close[app.language] }</button>
            </div>
        </div>
    </div>
    </div>

    <div class="modal fade" id="filterView" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
            <div class="modal-dialog" role="document">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="modalLabel">{app.texts.dashboard_filter.title[app.language]}</h5>
                        <button type="button" class="close" data-dismiss="modal" aria-label={app.texts.mydevices.cancel[app.language]}>
                            <span aria-hidden="true">&times;</span>
                        </button>
                    </div>
                    <div class="modal-body">
                        <form onSubmit="{saveFilter}" >
                            <div class="form-group">
                                { app.texts.dashboard_filter.description[app.language] }
                            </div>
                            <div class="form-group">
                                { app.texts.dashboard_filter.from_date[app.language] }
                                <input type="datetime-local" id="from_date" class="form-control" value="{ filter.fromDateInput }"/>
                            </div>
                            <div class="form-group">
                                { app.texts.dashboard_filter.to_date[app.language] }
                                <input type="datetime-local" id="to_date" class="form-control" value="{ filter.toDateInput }"/>
                            </div>
                            <div class="form-group">
                                <button type="button" class="btn btn-link" onClick={clearFilter}>{ app.texts.common.clear[app.language]}</button>
                            </div>
                        </form>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-primary" onClick={saveFilter} data-dismiss="modal">{app.texts.common.apply[app.language]}</button>
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">{app.texts.common.cancel[app.language]}</button>
                    </div>
                </div>
            </div>
        </div>
<!-- Modal -->
    <div class="row" if={ !accessOK }>
        <div class="col-md-12">
            { app.texts.dashboard2.notfound[app.language] }
        </div>
    </div>
    <div if={ accessOK }>
    <div class="row" if={ !app.embeded }>
        <div class="col-md-10">
            <h3 class="module-title">{ dashboardConfig.title }
            </h3>
        </div>
        <div class="col-md-2">
            <h3 class="module-title text-right">
            <i class="material-icons clickable" onclick={ refresh } if={app.user.status == 'logged-in' && !app.user.guest}>refresh</i>
            <i class="material-icons clickable" data-toggle="modal" data-target="#linkView"
                   if={ dashboardConfig.shared && dashboardConfig.sharedToken && !app.embeded && app.shared==''}
                   >link</i>
            <i class="material-icons-outlined clickable"  data-toggle="modal" data-target="#filterView" if={app.user.status == 'logged-in' && !app.user.guest && !filter.isSet}>filter_alt</i>
            <i class="material-icons clickable"  data-toggle="modal" data-target="#filterView" if={app.user.status == 'logged-in' && !app.user.guest && filter.isSet}>filter_alt</i>
            </h3>
        </div>
    </div>

    <virtual each={name, i in rowArr }>
        <div class="row my-n1" if={w_line[i] && w_line[i].length>0}>
            <virtual each={colname, j in colArr }>
                <div class={ getColumnClass(w_line[i][j])+' h100' } if={w_line[i].length>j}>
                    <widget_a1 ref={ getRefName(w_line[i][j]) } icon={w_line[i][j]['icon']} if={w_line[i][j]['type']=='symbol' && isVisible(w_line[i][j]) }></widget_a1>
                    <widget_button ref={ getRefName(w_line[i][j]) } if={w_line[i][j]['type']=='button' && isVisible(w_line[i][j])}></widget_button>
                    <widget_form ref={ getRefName(w_line[i][j]) } if={w_line[i][j]['type']=='form' && isVisible(w_line[i][j])}></widget_form>
                    <widget_chart ref={ getRefName(w_line[i][j]) } if={w_line[i][j]['type']=='line' && isVisible(w_line[i][j])}></widget_chart>
                    <widget_bar ref={ getRefName(w_line[i][j]) } if={w_line[i][j]['type']=='bar' && isVisible(w_line[i][j])}></widget_bar>
                    <widget_date ref={ getRefName(w_line[i][j]) } if={w_line[i][j]['type']=='date' && isVisible(w_line[i][j])}></widget_date>
                    <widget_filter ref={ getRefName(w_line[i][j]) } if={w_line[i][j]['type']=='filter' && isVisible(w_line[i][j])}></widget_filter>
                    <widget_map ref={ getRefName(w_line[i][j]) } if={w_line[i][j]['type']=='map' && isVisible(w_line[i][j])}></widget_map>
                    <widget_raw ref={ getRefName(w_line[i][j]) } if={(w_line[i][j]['type']=='raw' || w_line[i][j]['type']=='text') && isVisible(w_line[i][j])}></widget_raw>
                    <widget_image ref={ getRefName(w_line[i][j]) } if={w_line[i][j]['type']=='image' && isVisible(w_line[i][j])}></widget_image>
                    <widget_led ref={ getRefName(w_line[i][j]) } if={w_line[i][j]['type']=='led' && isVisible(w_line[i][j])}></widget_led>
                    <widget_plan ref={ getRefName(w_line[i][j]) } if={w_line[i][j]['type']=='plan' && isVisible(w_line[i][j])}></widget_plan>
                    <widget_report ref={ getRefName(w_line[i][j]) } if={w_line[i][j]['type']=='report' && isVisible(w_line[i][j])}></widget_report>
                    <widget_multimap ref={ getRefName(w_line[i][j]) } if={w_line[i][j]['type']=='multimap' && isVisible(w_line[i][j])}></widget_multimap>
                    <widget_multitrack ref={ getRefName(w_line[i][j]) } if={w_line[i][j]['type']=='multitrack' && isVisible(w_line[i][j])}></widget_multitrack>
                    <widget_stopwatch ref={ getRefName(w_line[i][j]) } if={w_line[i][j]['type']=='stopwatch' && isVisible(w_line[i][j])}></widget_stopwatch>
                    <widget_time ref={ getRefName(w_line[i][j]) } if={w_line[i][j]['type']=='time' && isVisible(w_line[i][j])}></widget_time>
                    <widget_devinfo ref={ getRefName(w_line[i][j]) } if={w_line[i][j]['type']=='devinfo' && isVisible(w_line[i][j])}></widget_devinfo>
                    <widget_custom ref={ getRefName(w_line[i][j]) } if={w_line[i][j]['type']=='custom' && isVisible(w_line[i][j])}></widget_custom>
                    <widget_custom1 ref={ getRefName(w_line[i][j]) } if={w_line[i][j]['type']=='custom1' && isVisible(w_line[i][j])}></widget_custom1>
                </div>
            </virtual>
        </div>
    </virtual>
    </div>

    <script charset="UTF-8">
    var self = this
    self.rowArr = [0,1,2,3,4,5,6,8,9,10,11,12,13]
    self.colArr = [0,1,2,3]
    self.dashboardConfig = {
        title:'reading dashboard ...',
        widgets:[]
    }
    self.sharedLink = ''
    self.sharedEmbeded
    self.mounted = false
    self.w_line=[]
    self.consolidatedData = '['
    self.consolidatedDataCounter=0
    self.consolidationRequired=false
    self.accessOK = true
    self.refreshInterval = app.dashboardRefreshInterval
    self.intervalID=null
    self.filter={
        fromDateInput:'',
        toDateInput:'',
        fromDate:'',
        toDate:'',
        isSet:false
    }
    self.devices=[]
    self.applications=[]
    self.devConfigs={}
    self.appConfigs={}
    self.listener = riot.observable()

    self.listener.on('err:403', function (event) {
        myStopRefresh()
    })
    self.listener.on('err:401', function (event) {
        self.accessOK=false
        myStopRefresh()
    })
    
    globalEvents.on('pageselected:dashboard',function(event){
        if(self.mounted){
            readDashboardConfig(app.user.dashboardID, updateDashboard)
        }
    })
    
    globalEvents.on('err:401',function(event){
        self.accessOK=false
        myStopRefresh()
    })
    globalEvents.on('err:403',function(event){
        self.accessOK=false
        riot.update()
    })

    this.on('mount',function(){
        self.dashboardConfig = {
            title:'reading dashboard ...',
            widgets:[]
        }
        self.sharedLink = ''
        self.sharedEmbeded
        self.accessOK=true
        readDashboardConfig(app.user.dashboardID, updateDashboard)
        if(app.embeded){
            self.refreshInterval=app.publicDashboardRefreshInterval;
        }
        if(app.user.status != 'logged-in' || app.user.guest){
            if(self.dashboardConfig.refresh_interval){
                self.refreshInterval=self.dashboardConfig.refresh_interval
            }else{
                self.refreshInterval=app.publicDashboardRefreshInterval
            }
        }
        // thread for refreshing dashboard data
        myStopRefresh()
        self.intervalID = setInterval(function(){ self.refresh(null) }, self.refreshInterval);
        self.mounted=true
    })
    
    this.on('unmount',function(){
        myStopRefresh()
        self.mounted=false
    })

    saveFilter(){
        var dt;
        try{
            self.filter.fromDateInput = document.getElementById('from_date').value
            if(self.filter.fromDateInput!==''){
              dt=new Date(self.filter.fromDateInput)
              self.filter.fromDate=dt.toISOString()
            }else{
                self.filter.fromDate=''
            }
            self.filter.toDateInput = document.getElementById('to_date').value
            if(self.filter.toDateInput!==''){
              dt=new Date(self.filter.toDateInput)
              self.filter.toDate=dt.toISOString()
            }else{
                self.filter.toDate=''
            }
            self.filter.isSet=(self.filter.fromDate!=='' || self.filter.toDate!=='')
        }catch(error){
            console.log(error)
        }
    }

    clearFilter(e){
        self.filter.fromDate=''
        self.filter.toDate=''
        self.filter.fromDateInput=''
        self.filter.toDateInput=''
        self.filter.isSet=false
    }

    refresh(e){
        app.log('REFRESHING DATA')
        var id, eui
        var widget
        Object.keys(self.refs).forEach(function(key,index) {
            widget=self.getWidgetDefinition(key)
            if((widget['dev_id']||widget['type']=='report'||widget['type']=='multimap'||widget['type']=='multitrack'||widget['type']=='plan'))
            {
                eui=widget['dev_id']
                if(eui!=='' && !self.devices.includes(eui)){
                    self.devices.push(eui)
                }
                id=widget['app_id']
                if(!isNaN(id) && id!=null && id!=='' && id!='null' && !self.applications.includes(id)){
                    self.applications.push(id)
                }
            }
        })
        app.log(self.devices)
        app.log(self.applications)
        reloadConfigs()
        app.log(self.devConfigs)
        app.log(self.appConfigs)
        Object.keys(self.refs).forEach(function(key,index) {
            widget=self.getWidgetDefinition(key)
            if((widget['dev_id']||widget['type']=='report'||widget['type']=='multimap'||widget['type']=='multitrack'||widget['type']=='plan'))
            {
                readDashboardData(widget, updateWidget, 0, index);
            }
        })
        riot.update()
    }

    function reloadConfigs(){
        try{
        var obj, id, eui
        for(i=0; i<self.devices.length; i++){
            eui=self.devices[i]
            readDeviceProperties(eui,updateDevConfigs)
        }
        for(i=0; i<self.applications.length; i++){
            id=self.applications[i]
            readApplicationProperties(id,updateAppConfigs)
        }
        }catch(err){
            console.log(err)
        }
    }

    var readDashboardConfig = function(dashboardID, callback){
        app.log('READING DASHBOARD CONFIG for: '+dashboardID)
        if(!dashboardID){return}
        self.dashboardConfig = {}
        self.w_line=[]
        localParams=app.shared==''?'':'?tid='+app.shared
        var dboard
        var byName=''
        if(dashboardID.endsWith('@')){
            dboard=dashboardID.substring(0, dashboardID.length - 1);
            byName=localParams!=''?'&name=true':'?name=true'
        }else{
            dboard=dashboardID
        }
        getData(
            app.dashboardAPI + "/" + dashboardID + localParams + byName, //url
            null,                                      //query
            (localParams!=''?null:app.user.token),                            //session token
            callback,                    //callback
            null,                           //event listener
            'OK',                                      //success event name
            null,                                      //error event name
            app.debug,                                 //debug switch
            globalEvents                               //application's event listener
        )
    }

    var readDeviceProperties = function(eui, callback){
        getData(
            app.iotAPI + "/" + eui, //url
            null,                                      //query
            app.user.token,                            //session token
            callback,                    //callback
            self.listener,                           //event listener
            'OK',                                      //success event name
            null,                                      //error event name
            app.debug,                                 //debug switch
            null                               //application's event listener
        )
    }
    var readApplicationProperties = function(id, callback){
        getData(
            app.applicationAPI + "/" + id, //url
            null,                                      //query
            app.user.token,                            //session token
            callback,                    //callback
            null,                           //event listener
            'OK',                                      //success event name
            null,                                      //error event name
            app.debug,                                 //debug switch
            null                               //application's event listener
        )
    }

    var updateDevConfigs = function(data){
        var obj=JSON.parse(data)
        self.devConfigs[''+obj.eui]=obj.configuration
    }
    var updateAppConfigs = function(data){
        var obj=JSON.parse(data)
        self.appConfigs[''+obj.id]=obj.configuration
    }

    //callback function
    var updateDashboard = function(data){
        app.log('UPDATING DASHBOARD')
        self.dashboardConfig = {
            title:'reading dashboard ...',
            widgets:[]
        }
        rebuild()
        self.dashboardConfig = JSON.parse(data)
        app.log('NEW config IS: '+self.dashboardConfig)
        if(self.dashboardConfig == null){
            self.dashboardConfig = {
            title:'the selected dashboard is unavailable',
            shared:false,
            sharedToken:'',
            widgets:[]
        }
        }
        app.log(self.dashboardConfig)
        rebuild()
        riot.update()
        app.log(self.refs)
        Object.keys(self.refs).forEach(function(key,index) {
            app.log(key)
            self.refs[key].update(self.getWidgetDefinition(key))
        });
        app.log('SHARED TOKEN='+self.dashboardConfig.sharedToken)
        if(self.dashboardConfig.sharedToken){
            self.sharedLink = location.origin+'/app/?tid='+self.dashboardConfig.sharedToken+location.hash
            self.sharedEmbeded = 
                    '<IFRAME \nsrc="'
                    +location.origin+'/app/embed.html?tid='+self.dashboardConfig.sharedToken+'/'+location.hash
                    +'" \nwidth="300" \nheight="300">\n</IFRAME>'
        }else{
            self.sharedLink = ''
            self.sharedEmbeded = ''
        }
        self.refresh(null)
    }

    self.getWidgetDefinition=function(name){
        try{
        var tmpW
        for(i=0; i<self.dashboardConfig.widgets.length; i++){
            tmpW=self.dashboardConfig.widgets[i]
            if(tmpW.name==name){
                return tmpW
            }
        }
        }catch(err){
            console.log(err)
        }
        return {}
    }

    //callback function
    var updateWidget = function(d, tPos){
        var row=parseInt(tPos.substring(0,1))
        var col=parseInt(tPos.substring(2))
        app.log('UPDATING '+tPos+' '+row+' '+col)
        Object.keys(self.refs).forEach(function(key,index) {
            if(index==col){
                self.refs[key].rawdata = d
                self.refs[key].devConfigs=self.devConfigs
                self.refs[key].appConfigs=self.appConfigs
                self.refs[key].show2()
            }
        })
        riot.update()
    }

    // get data from IoT devices
    var readDashboardData = function (config, callback, row, column) {
        if(config['type']=='button' || config['type']=='filter'){
            return
        }
        app.log('CONIFIG')
        app.log(config)
        var query
        var channelName = config.channel
        if(config.query){
            query = config.query
        }else{
            query = 'last 1'
        }
        if(config.format){
            if(config.format == 'timeseries'){
                query = query + ' timeseries'
            }
        }

        var url=''
        var queryWithFilter=applyFilter(query,self.filter)
        if(config.type=='devinfo'||config.type=='devmap'){
            url=app.iotAPI + "/" + config.dev_id
        }else if(config.type=='report'||config.type=='multimap'||config.type=='multitrack'||config.type=='plan'){
            ////url=app.groupDataAPI + "/" + config.group + "/"+channelName+"?"+(app.shared!=''?'tid='+app.shared+'&':'')+"query=" + queryWithFilter
            url=app.groupDataAPI + "/" + config.group + "/"+channelName+"?tid="+(app.shared!=''?app.shared:app.user.token)+"&query=" + queryWithFilter
            //url=app.groupAPI + "/" + config.group + "/"+channelName+"?"+(app.shared!=''?'tid='+app.shared+'&':'')+"query=" + queryWithFilter
        }else if(config.dev_id){
            //url=app.dataAPI + "/" + config.dev_id + "/"+channelName+"?tid="+ (app.shared!=''?app.shared:app.user.token)+"&query=" + queryWithFilter
            url=app.dataAPI + "/" + config.dev_id + "/"+channelName+"?query=" + queryWithFilter
        }
        try{
        if(url.length>0 && (typeof config.role == 'undefined' || config.role==null || config.role.length==0 || app.user.roles.includes(config.role))) {
            getData(
                url, 
                null,  
                (app.shared==''?app.user.token:null),                            //session token
                callback,
                null, 
                row+':'+column,  //success event name
                null,            //error event name
                app.debug,       //debug switch
                globalEvents    //application's event listener
            )
        }
        }catch(err){
            console.log('readDashboardData:'+err)
        }
    }
        
    var rebuild = function(){
        self.w_line = []
        var lineNo = 0
        var colNo = 0
        app.log('dashboardConfig.widgets.length: '+self.dashboardConfig.widgets.length)
        for(i=0; i<self.dashboardConfig.widgets.length; i++){
            if(colNo+self.dashboardConfig.widgets[i].width>4){
                lineNo ++
                colNo=0
            }
            if(colNo==0){
                self.w_line.push(Array(0))
            }
            self.w_line[lineNo].push(self.dashboardConfig.widgets[i])
            colNo=colNo+self.dashboardConfig.widgets[i].width
        }
        app.log('w_line')
        app.log(self.w_line)
    }
    
    function myStopRefresh() {
        app.log('STOPPING THREAD')
        if(null!=self.intervalID) clearInterval(self.intervalID);
        self.intervalID=null
    }
    
    getColumnClass(widget){
        switch(widget.width){
            case 1:
                return 'col-md-3'
            case 2:
                return 'col-md-6'
            case 3:
                return 'col-md-9'
            case 4: 
                return 'col-md-12'
            default:
                return 'col-md-3'
        }
    }
    
    getRefName(widget){
        return widget.name
    }

    isVisible(widget){
        return typeof widget.role =='undefined' || widget.role == null || widget.role =='' || app.user.roles.includes(widget.role)
    }
    
    </script>
</app_dashboard2>
