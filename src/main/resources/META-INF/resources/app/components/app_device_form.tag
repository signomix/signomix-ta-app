<app_device_form>
    <div class="row">
        <div class="input-field col-md-12">
            <h2 if={ self.mode=='create' }>{ app.texts.device_form.header_new[app.language] }</h2>
            <h2 if={ self.mode=='update' }>{ app.texts.device_form.header_modify[app.language] }</h2>
            <h2 if={ self.mode=='view' }>{ app.texts.device_form.header_view[app.language] }</h2>
        </div>
    </div>
    <div class="row">
        <form class="col-md-12" onsubmit="{ self.submitSelectTemplate }" if="{self.useTemplate}">
            <div class="form-group">
                <div class="input-field">
                    <label for="template">{ app.texts.device_form.template[app.language] }</label>
                    <select class="form-control" id="template" name="template" value={ selectedTemplate } onchange={ changeTemplate } disabled={ !(allowEdit && !device.eui) }>
                        <option each="{t in templates}" value="{t.eui}">{ t.producer+': '+t.eui}</option>
                    </select>
                </div>
            </div>
            <div class="card text-left col-md-12" style="margin-bottom: 1rem">
                <div class="card-body">
                    <raw content={ template.description }></raw>
                </div>
            </div>
            <div class="form-group">
                <button type="submit" class="btn btn-primary">{ app.texts.device_form.next[app.language] }</button>
                <button type="button" class="btn btn-secondary" onclick={ close }>{ app.texts.device_form.cancel[app.language] }</button>
            </div>
        </form>
        <form class="col-md-12" onsubmit="{ self.submitForm }" if="{!self.useTemplate}">
            <div class="form-row" if="{isVisible('type')}">
                <div class="form-group col-md-6">
                    <label for="type">{ app.texts.device_form.type[app.language] }</label>
                    <select class="form-control" id="type" name="type" value={ device.type } onchange={ changeType } disabled={ !(allowEdit && !device.eui) } required>
                        <option value="GENERIC">DIRECT</option>
                        <option value="TTN">TTN</option>
                        <option value="LORA">CHIRPSTACK</option>
                        <!--<option value="KPN">KPN</option>-->
                        <!--<option value="GATEWAY">HOME GATEWAY</option>-->
                        <option value="VIRTUAL">VIRTUAL</option>
                        <option value="EXTERNAL">EXTERNAL</option>
                    </select>
                </div>
                <div class="card col-md-6" style="margin-bottom: 10px">
                    <div class="card-body">
                        <raw content={ getTypeDescription() }></raw>
                    </div>
                </div>
            </div>
            <div class="form-row" if="{!isVisible('type')}">
                <div class="card col-md-12" style="margin-bottom: 10px">
                    <div class="card-body">
                        <raw content={ device.description }></raw>
                    </div>
                </div>
            </div>
            <div class="form-row">
                <div class="form-group col-md-12">
                    <form_input id="name" name="name" label="{ app.texts.device_form.name[app.language] }" type="text" required="true" content="{ device.name }" readonly="{ !allowEdit }" hint="{ app.texts.device_form.name_hint[app.language] }"></form_input>
                </div>
            </div>
            <div class="form-row" if="{isVisible('eui')}">
                <div class="form-group col-md-12">
                    <form_input id="eui" name="eui" label={ app.texts.device_form.eui[app.language] } type="text" content={ device.eui } required={device.type=='TTN' || device.type=='KPN' || device.type=='LORA'} readonly={ !(allowEdit && !device.eui) } hint={ app.texts.device_form.eui_hint[app.language] }></form_input>
                </div>
            </div>
            <div class="form-row" if="{isVisible('key')}">
                <div class="form-group col-md-12">
                    <form_input id="key" name="key" label={ app.texts.device_form.key[app.language] } type="text" content={ device.key } readonly={ !allowEdit } hint={ app.texts.device_form.key_hint[app.language] }></form_input>
                </div>
            </div>
            <div class="form-row" if="{isVisible('channels')}">
                <div class="form-group col-md-12">
                    <form_input id="channels" name="channels" label={ app.texts.device_form.channels[app.language] } type="text" content={ device.channels } readonly={ !allowEdit } hint={ app.texts.device_form.channels_hint[app.language] } onchange={ changeChannels }></form_input>
                </div>
            </div>
            <div class="form-row" if="{isVisible('team')}">
                <div class="form-group col-md-12">
                    <form_input id="team" name="team" label={ app.texts.device_form.team[app.language] } type="text" content={ device.team } readonly={ !allowEdit } hint={ app.texts.device_form.team_hint[app.language] }></form_input>
                </div>
            </div>
            <div class="form-row" if="{isVisible('admins')}">
                <div class="form-group col-md-12">
                    <form_input id="admins" name="admins" label={ app.texts.device_form.admins[app.language] } type="text" content={ device.administrators } readonly={ !allowEdit } hint={ app.texts.device_form.admins_hint[app.language] }></form_input>
                </div>
            </div>
            <div class="form-row" if="{isVisible('description')}">
                <div class="form-group col-md-12">
                    <form_input id="description" name="description" label={ app.texts.device_form.description[app.language] } type="textarea" content={ device.description } readonly={ !allowEdit } rows=2></form_input>
                </div>
            </div>
            <div class="form-row" if="{isVisible('encoder')}">
                <div class="form-group col-md-12">
                    <form_input id="encoder" name="encoder" label={ app.texts.device_form.encoder[app.language] } type="textarea" content={ device.encoder } readonly={ !allowEdit } rows=6 hint={ app.texts.device_form.encoder_hint[app.language] }></form_input>
                </div>
            </div>
            <div class="form-row">
                <div class="form-group col-md-12" if="{isVisible('code')}">
                    <form_input id="code" name="code" label={ app.texts.device_form.code[app.language] } type="textarea" content={ device.code } readonly={ !allowEdit } rows=6 hint={ app.texts.device_form.code_hint[app.language] }></form_input>
                </div>
            </div>
            <div class="form-row">
                <div class="form-group col-md-12" if="{isVisible('interval')}">
                    <form_input id="interval" name="interval" label={ app.texts.device_form.interval[app.language] } type="text" content={ device.transmissionInterval/60000 } readonly={ !allowEdit } hint={ app.texts.device_form.interval_hint[app.language] }></form_input>
                </div>
            </div>
            <div class="form-row" if="{isVisible('groups')}">
                <div class="form-group col-md-12">
                    <form_input id="groups" name="groups" label={ app.texts.device_form.groups[app.language] } type="text" content={ device.groups } readonly={ !allowEdit } hint={ app.texts.device_form.groups_hint[app.language] }></form_input>
                </div>
            </div>
            <div class="form-row" if="{ device.type=='TTN' && isVisible('appeui') }">
                <div class="form-group col-md-12">
                    <form_input id="appeui" name="appeui" label={ app.texts.device_form.appeui[app.language] } type="text" content={ device.applicationEUI } readonly={ !allowEdit } hint={ app.texts.device_form.appeui_hint[app.language] }></form_input>
                </div>
            </div>
            <div class="form-row" if="{ device.type=='TTN' && isVisible('appid')}">
                <div class="form-group col-md-12">
                    <form_input id="appid" name="appid" label={ app.texts.device_form.appid[app.language] } type="text" content={ device.applicationID } readonly={ !allowEdit } hint={ app.texts.device_form.appid_hint[app.language] }></form_input>
                </div>
            </div>
            <div class="form-row" if="{isVisible('project')}">
                <div class="form-group col-md-12">
                    <form_input id="project" name="project" label={ app.texts.device_form.project[app.language] } type="text" content={ device.project } readonly={ !allowEdit } hint={ app.texts.device_form.project_hint[app.language] }></form_input>
                </div>
            </div>
            <div class="form-row" if="{isVisible('state')}">
                <div class="form-group col-md-12">
                    <form_input id="state" name="state" label={ app.texts.device_form.state[app.language] } type="text" content={ device.state } readonly={ !allowEdit } hint={ app.texts.device_form.state_hint[app.language] }></form_input>
                </div>
            </div>
            <div class="form-row" if="{isVisible('latitude')}">
                <div class="form-group col-md-12">
                    <form_input id="latitude" name="latitude" label={ app.texts.device_form.latitude[app.language] } type="text" content={ device.latitude } readonly={ !allowEdit } hint={ app.texts.device_form.latitude_hint[app.language] }></form_input>
                </div>
            </div>
            <div class="form-row" if="{isVisible('longitude')}">
                <div class="form-group col-md-12">
                    <form_input id="longitude" name="longitude" label={ app.texts.device_form.longitude[app.language] } type="text" content={ device.longitude } readonly={ !allowEdit } hint={ app.texts.device_form.longitude_hint[app.language] }></form_input>
                </div>
            </div>
            <!--
            <div class="form-row" if="{isVisible('downlink')}">
                <div class="form-group col-md-12">
                    <form_input id="downlink" name="downlink" label={ app.texts.device_form.downlink[app.language] } type="text" content={ device.downlink } readonly={ !allowEdit } hint={ app.texts.device_form.downlink_hint[app.language] }></form_input>
                </div>
            </div>
            -->
            <div class="form-row" if="{isVisible('organization')}">
                <div class="form-group col-md-12">
                    <form_input id="organization" name="organization" label={ app.texts.device_form.organization[app.language] } type="text" content={ device.organizationId } readonly={ !(allowEdit && isAdmin()) } hint={ app.texts.device_form.organization_hint[app.language] }></form_input>
                </div>
            </div>
            <div class="form-row" if="{isVisible('organizationapp')}">
                <div class="form-group col-md-12">
                    <form_input id="organizationapp" name="organizationapp" label={ app.texts.device_form.organizationapp[app.language] } type="text" content={ device.orgApplicationId } readonly={ !allowEdit } hint={ app.texts.device_form.organizationapp_hint[app.language] }></form_input>
                </div>
            </div>
            <div class="form-row" if="{isVisible('configuration')}">
                <div class="form-group col-md-12">
                    <form_input id="configuration" name="configuration" label={ app.texts.device_form.configuration[app.language] } type="textarea" content={ device.configuration } readonly={ !allowEdit } rows=2></form_input>
                </div>
            </div>
            <div class="form-row" if="{isVisible('active')}">  
                <div class="form-group form-check">
                    <input type="checkbox" class="form-check-input" id="active" value={device.active} readonly={ !allowEdit } checked="{device.active}">
                    <label class="form-check-label" for="active">{ app.texts.device_form.active[app.language] }</label>
                </div>
            </div>
            <div class="form-row" if={ self.mode !='create' }>
                <div class="form-group col-md-12">
                    <label for="status">{ app.texts.device_form.devicestatus[app.language] }</label>
                    <p class="form-control-static" id="status">
                        <img height="16px" style="margin-right: 10px;" src={ getStatus(self.device.lastSeen, self.device.transmissionInterval) }>last seen { getLastSeenString(self.device.lastSeen)}
                    </p>
                </div>
            </div>
            <div class="form-row" if={ self.mode !='create' }>
                <div class="form-group col-md-12">
                    <label for="status">{ app.texts.device_form.owner[app.language] }</label>
                    <p class="form-control-static" id="owner">{self.device.userID}</p>
                </div>
            </div>
            <div class="form-row" if={ self.mode=='update' && self.channelsChanged }>
                <div class="form-group col-md-12">
                    <div class="alert alert-danger" role="alert">{ app.texts.device_form.channels_alert[app.language] }</div>
                </div>
            </div>
            <div class="form-row" if={ self.communicationError }>
                <div class="form-group col-md-12">
                    <div class="alert alert-danger" role="alert">{ self.errorMessage }</div>
                </div>
            </div>
            <div class="form-row">
                <div class="form-group col-md-12">
                    <button type="submit" class="btn btn-primary" disabled={ !allowEdit }>{ app.texts.device_form.save[app.language] }</button>
                    <button type="button" class="btn btn-secondary" onclick={ close }>{ app.texts.device_form.cancel[app.language] }</button>
                </div>
            </div>
        </form>
    </div>
    <script>
        this.visible = true
        self = this
        self.now = Date.now()
        self.listener = riot.observable()
        self.callbackListener
        self.templateSelected = true
        self.selectedTemplate = 'UNDEFINED'
        self.allowEdit = false
        self.useTemplate = false
        self.method = 'POST'
        self.mode = 'view'
        self.channelsEncoded = ''
        self.channelsChanged = false
        self.communicationError = false
        self.errorMessage = ''
        self.templates=[]
        self.template = {}
        self.device = {
            template:null,
            name:null,
            applicationEUI:null,
            applicationID:null,
            key:null,
            userID:null,
            type:"GENERIC",
            team:null,
            channels:null,
            code:null,
            encoder:null,
            description:"",
            transmissionInterval:0,
            checkFrames:null,
            pattern:null,
            commandScript:null,
            groups:null,
            deviceID:null,
            active:true,
            project:null,
            latitude:null,
            longitude:null,
            altitude:null,
            retentionTime:null,
            administrators:null,
            configuration:null,
            orgApplicationId:null,
            applicationConfig:null,
            organizationId:null,
            virtual:null,
            eui:null,
            channelsAsString:null,
            codeUnescaped:null,
            encoderUnescaped:null,
            configurationMap:null
            }
        self.device_prev = {
            'EUI': '',
            'applicationEUI': '',
            'appplicatioID': '',
            'name': '',
            'key': '',
            'type': 'GENERIC',
            'team': '',
            'administrators': '',
            'channels': '',
            'code': '',
            'encoder': '',
            'description': '',
            'groups': '',
            'lastSeen': -1,
            'transmissionInterval': 0,
            'pattern': '',
            'commandscript': '',
            'template': '',
            'active':'true',
            'state': 0,
            'latitude': '',
            'longitude': '',
            'project':'',
            'downlink':'',
            'configuration':'',
            'organizationId':0,
            'orgApplicationId':0
        }
        self.accepted = 0

        self.listener.on('*', function(eventName) {
            if (eventName == 'err:402') {
                self.communicationError = true
                self.errorMessage = app.texts.device_form.err402[app.language]
                self.update()
            }
            if (eventName == 'err:400') {
                self.communicationError = true
                self.errorMessage = app.texts.device_form.err400[app.language]
                self.update()
            }
            if (eventName == 'err:401') {
                self.communicationError = true
                self.errorMessage = app.texts.device_form.err401[app.language]
                self.update()
                globalEvents.trigger('err:401')
            }
            if (eventName == 'err:409') {
                self.communicationError = true
                self.errorMessage = app.texts.device_form.err409[app.language]
                self.update()
            }
        })

        globalEvents.on('data:submitted', function(event) {
            app.log('SUBMITTED')
        })

        init(eventListener, id, editable, fromTemplate){
            self.callbackListener = eventListener
            self.allowEdit = editable
            self.useTemplate = fromTemplate
            self.method = 'POST'
            if (id != 'NEW') {
                readDevice(id)
                self.method = 'PUT'
                if (self.allowEdit) {
                    self.mode = 'update'
                } else {
                    self.mode = 'view'
                }
            } else {
                if(self.useTemplate){
                    readTemplates()
                }
                self.mode = 'create'
            }
            if(fromTemplate){
                self.changeTemplate()
            }
        }

        self.changeType = function(e) {
            e.preventDefault()
            if (e.target) {
                self.device.type = e.target.value
                riot.update()
            } else {
                app.log('UNKNOWN TARGET OF: ' + e)
            }
            if('EXTERNAL'==self.device.type){
                self.template['pattern']=",type,eui,name,key,description,team,administrator,active,groups"
            }else if('VIRTUAL'==self.device.type){
                self.template['pattern']=",type,eui,name,key,description,team,administrator,active,groups,project,transmissionInterval"
            }
        }
        
        self.changeChannels = function(e) {
            if (self.device.channels != e.target.value.trim()) {
                self.channelsChanged = true
            } else {
                self.channelsChanged = false
            }
            riot.update()
        }

        self.undefined = {
            "eui":"-",
            "appid":"",
            "appeui":"",
            "type":"",
            "channels":"",
            "code":"",
            "decoder":"",
            "description":"self defined",
            "interval":0,
            "pattern":",type,eui,name,key,channels,encoder,code,description,team,interval,active,appeui,appid,project,groups,",
            "commandScript":"",
            "producer":"user defined"
        }

        self.template = self.undefined
        self.selectedTemplate = ''
        
        isVisible(fieldName){
            return (self.mode!='create' || self.template.pattern.indexOf(fieldName)>=0)
        }
        isAdmin(){
            return app.user.roles.indexOf('admin')>-1
        }

        getStatus(lastSeen, interval) {
            if (self.now - lastSeen > interval) {
                return '/app/images/KO.svg'
            } else {
                return '/app/images/OK.svg'
            }
        }

        getLastSeenString(lastSeen) {
            if (lastSeen && lastSeen > 0) {
                return new Date(lastSeen).toLocaleString()
            } else {
                return '---'
            }
        }

        getTypeDescription() {
            switch (self.device.type) {
                case 'GENERIC':
                    return app.texts.device_form.generic_desc[app.language]
                case 'TTN':
                    return app.texts.device_form.ttn_desc[app.language]
                case 'LORA':
                    return app.texts.device_form.lora_desc[app.language]
                //case 'KPN':
                //    return app.texts.device_form.kpn_desc[app.language]
                //case 'GATEWAY':
                //    return app.texts.device_form.gateway_desc[app.language]
                case 'VIRTUAL':
                    return app.texts.device_form.virtual_desc[app.language]
                case 'EXTERNAL':
                    return app.texts.device_form.external_desc[app.language]
                default:
                    return app.texts.device_form.default_desc[app.language]
            }
        }
        
        self.changeTemplate = function(e) {
            console.log('changeTemplate')
            //e.preventDefault()
            var templateEui='-'
            try {
                templateEui = document.getElementById("template").value;
                console.log(templateEui)
                //templateEui=e.target.value
            }catch(err){ console.log(err)}
            for(var i=0; i<self.templates.length; i++){
                if(self.templates[i].eui==templateEui){
                    self.selectedTemplate = self.templates[i].eui
                    self.template=self.templates[i]
                    console.log(i)
                    break
                }
            }
            self.device.type=self.template.type
            self.device.channels=self.template.channels
            self.device.description=self.template.description
            self.device.encoder=self.template.decoder
            self.device.code=self.template.code
            self.device.applicationID=self.template.appid
            self.device.applicationEUI=self.template.appeui
            self.device.transmissionInterval=self.template.interval
            self.device.template=self.template.eui
            self.device.configuration=self.template.configuration
            self.device.active='true'
            self.device.project=''
            //self.device.downlink=''
            //self.device.applicationEUI = ''
            //self.device.applicationID=''
            self.device.state=''
            self.device.latitude=''
            self.device.longitude=''
            console.log(self.template)
            console.log(self.device)
            riot.update()
        }
        
        self.submitSelectTemplate =function(e){
            e.preventDefault()
            self.useTemplate=false
        }

        self.submitForm = function(e) {
            e.preventDefault()
            devicePath = ''
            if (self.mode == 'update') {
                devicePath = (self.method == 'PUT') ? '/' + e.target.elements['eui_input'].value : ''
            }
            var formData = {
                eui: '',
                applicationEUI: '',
                applicationID: '',
                name: '',
                key: '',
                type: '',
                team: '',
                administrators: '',
                channelsAsString: '',
                transmissionInterval: '',
                description: '',
                code: '',
                pattern: '',
                groups: '',
                commandScript: '',
                template: '',
                project: '',
                active: '',
                //state:'',
                latitude:'',
                longitude:'',
                //downlink:'',
                configuration:'',
                organizationId:0,
                orgApplicationId:0
            }
            if(e.target.elements['eui_input']) formData.eui = e.target.elements['eui_input'].value
            if (self.device.type == 'TTN') {
                if(e.target.elements['appeui_input']) {
                    formData.applicationEUI = e.target.elements['appeui_input'].value
                }else{
                    formData.applicationEUI = self.device.applicationEUI
                }
                if(e.target.elements['appid_input']) {
                    formData.applicationID = e.target.elements['appid_input'].value
                }else{
                    formData.applicationID = self.device.applicationID
                }
            }
            if(e.target.elements['name_input']) {
                formData.name = e.target.elements['name_input'].value
            }else{
                formData.name = self.device.name
            }
            if(e.target.elements['key_input']) {
                formData.key = e.target.elements['key_input'].value
            }else{
                formData.key = self.device.key
            }
            if(e.target.elements['type_input']) {
                formData.type = e.target.elements['type_input'].value
            }else{
                formData.type = self.device.type
            }
            if(e.target.elements['team_input']) {
                formData.team = e.target.elements['team_input'].value
            }else{
                formData.team = self.device.team
            }
            if(e.target.elements['admins_input']) {
                formData.administrators = e.target.elements['admins_input'].value
            }else{
                formData.administrators = self.device.administrators
            }
            if(e.target.elements['channels_input']) {
                formData.channelsAsString = e.target.elements['channels_input'].value
            }else{
                formData.channelsAsString = self.device.channels
            }
            if(e.target.elements['groups_input']) {
                formData.groups = e.target.elements['groups_input'].value
            }else{
                formData.groups = self.device.groups
            }
            if(e.target.elements['project_input']) {
                formData.project = e.target.elements['project_input'].value
            }else{
                formData.project = self.device.project
            }
            if(e.target.elements['active_input']) {
                var aCheck = e.target.elements['active_input']
                formData.active = aCheck.checked?'true':'false'
            }else{
                formData.active = self.device.active
            }
            if(e.target.elements['description_input']) {
                formData.description = e.target.elements['description_input'].value
            }else{
                formData.description = self.device.description
            }
            //formData.code = escape(trimSpaces(e.target.elements['code'].value))
            //formData.encoder = escape(trimSpaces(e.target.elements['encoder'].value))
            if(e.target.elements['code_input']) {
                formData.code = trimSpaces(e.target.elements['code_input'].value)
            }else{
                formData.code = self.device.code
            }
            if(e.target.elements['encoder_input']) {
                formData.encoder = trimSpaces(e.target.elements['encoder_input'].value)
            }else{
                formData.encoder = self.device.encoder
            }
            
            formData.commandScript = self.device.commandScript
            formData.template = self.device.template
            if(e.target.elements['interval_input']) {
                formData.transmissionInterval = 60000 * Number(e.target.elements['interval_input'].value)
            }else{
                formData.transmissionInterval = self.device.transmissionInterval
            }
            //if(e.target.elements['state_input']) {
            //    formData.state = e.target.elements['state_input'].value
            //}else{
            //    formData.state = self.device.state
            //}
            if(e.target.elements['latitude_input']) {
                formData.latitude = e.target.elements['latitude_input'].value
            }else{
                formData.latitude = self.device.latitude
            }
            if(e.target.elements['longitude_input']) {
                formData.longitude = e.target.elements['longitude_input'].value
            }else{
                formData.longitude = self.device.longitude
            }
            //if(e.target.elements['downlink_input']) {
            //    formData.downlink = e.target.elements['downlink_input'].value
            //}else{
            //    formData.downlink = self.device.downlink
            //}
            if(e.target.elements['configuration_input']) {
                formData.configuration = e.target.elements['configuration_input'].value
            }else{
                formData.configuration = self.device.configuration
            }
            if(e.target.elements['organization_input']) {
                formData.organizationId = e.target.elements['organization_input'].value
            }else{
                formData.organizationId = self.device.organizationId
            }
            if(e.target.elements['organizationapp_input']) {
                formData.orgApplicationId = e.target.elements['organizationapp_input'].value
            }else{
                formData.orgApplicationId = self.device.orgApplicationId
            }
            app.log(app.iotAPI + devicePath)
            app.log(JSON.stringify(formData))
            sendJsonData(formData, self.method, app.iotAPI + devicePath, 
            'Authentication', app.user.token, self.submitted, self.listener, 
            'submit:OK', null, app.debug, null)
            //sendJsonData(
            //    formData,
            //    self.method,
            //    app.iotAPI + devicePath,
            //    app.user.token,
            //    self.submitted,
            //    self.listener,
            //    'submit:OK',
            //    null,
            //    app.debug,
            //    null //globalEvents
            //)
        }

        self.close = function() {
            self.callbackListener.trigger('cancelled')
        }

        self.submitted = function() {
            self.callbackListener.trigger('submitted')
        }

        encodeChannels = function() {
            var result = ''
            var i = 0
            var channel = {}
            for (var key in self.device.channels) {
                if (self.device.channels.hasOwnProperty(key)) {
                    //app.log(key + " -> " + self.device.channels[key]);
                    channel = self.device.channels[key]
                    if (i > 0) {
                        result = result + ','
                    }
                    result = result + channel.name
                    i++
                }
            }
            return result
        }

        var update = function(text) {
            app.log("DEVICE: " + text)
            self.device = JSON.parse(text);
            if (self.device.code) {
                self.device.code = unescape(self.device.code)
            } else {
                self.device.code = ''
            }
            if (self.device.encoder) {
                self.device.encoder = unescape(self.device.encoder)
            } else {
                self.device.encoder = ''
            }
            if(self.device.latitude==100000){
                self.device.latitude=''
            }
            if(self.device.longitude==100000){
                self.device.longitude=''
            }
            self.device.channels = encodeChannels()
            self.templateSelected = true
            riot.update();
        }
        
         var updateTemplates = function(text) {
            self.templates = JSON.parse(text);
            self.templates.unshift(self.undefined)
            riot.update()
        }

        var readDevice = function(devEUI) {
            getData(app.iotAPI + '/' + devEUI+'?full=true',
                null,
                app.user.token,
                update,
                self.listener, //globalEvents
                'OK',
                null, // in case of error send response code
                app.debug,
                globalEvents
            );
        }
        
        var readTemplates = function() {
            getData(app.templateAPI,
                null,
                app.user.token,
                updateTemplates,
                self.listener, //globalEvents
                'OK',
                null, // in case of error send response code
                app.debug,
                globalEvents
            );
        }

    </script>
</app_device_form>
