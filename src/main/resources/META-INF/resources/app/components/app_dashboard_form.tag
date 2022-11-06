<app_dashboard_form>
    <div class="row">
        <div class="input-field col-md-12">
            <h2 if={ self.mode == 'create' }>{app.texts.dashboard_form.new[app.language]}</h2>
            <h2 if={ self.mode == 'update' }>{app.texts.dashboard_form.modify[app.language]}</h2>
            <h2 if={ self.mode == 'view' }>{app.texts.dashboard_form.view[app.language]}</h2>
        </div>
    </div>
    <!-- Central Modal: REMOVE -->
    <div class="modal fade" id="widgetRemove" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true" if={self.selectedForRemove>-1}>
        <div class="modal-dialog modal-notify modal-danger" role="document">
            <!--Content-->
            <div class="modal-content">
                <!--Header-->
                <div class="modal-header">
                    <p class="heading lead">{app.texts.dashboard_form.f_remove_title[app.language]}</p>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true" class="white-text">&times;</span>
                    </button>
                </div>
                <!--Body-->
                <div class="modal-body">
                    <div class="text-center">
                        <p><b>{ self.dashboard.widgets[self.selectedForRemove].name }</b></p>
                        <p>{app.texts.dashboard_form.f_remove_question[app.language]}</p>
                    </div>
                </div>
                <!--Footer-->
                <div class="modal-footer justify-content-center">
                    <a type="button" class="btn btn-primary-modal" onclick={confirmRemoveWidget(self.selectedForRemove)}>{app.texts.dashboard_form.remove[app.language]} <i class="material-icons clickable">delete</i></a>
                    <a type="button" class="btn btn-outline-secondary-modal waves-effect" data-dismiss="modal">{app.texts.dashboard_form.cancel[app.language]}</a>
                </div>
            </div>
            <!--/.Content-->
        </div>
    </div>
    <!-- Central Modal: REMOVE -->
    
    <!-- EDIT WIDGET -->
    <div class="modal fade" id="widgetEdit" tabindex="-1" role="dialog" aria-labelledby="myModalLabel" aria-hidden="true">
        <div class="modal-dialog cascading-modal" role="document">
            <div class="modal-content">
                <div class="modal-header light-blue darken-3 white-text">
                    <h4 class="title"><i class="material-icons clickable">mode_edit</i> {app.texts.dashboard_form.f_widget_formtitle[app.language]}</h4>
                </div>
                <div class="modal-body mb-0">
                    <ul class="nav nav-tabs mb-1">
                        <li class="nav-item">
                            <a class="nav-link { active: activeTab=='basic' }" onclick="{ selectBasic() }">Basic</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link { active: activeTab=='extended' }" onclick="{ selectExtended() }">Extended</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link { active: activeTab=='description' }" onclick="{ selectDescription() }">Description</a>
                        </li>
                    </ul>
                    <form if={activeTab==='basic'}>
                        <div class="row" if={ isOnBasicTab('w_type',self.editedWidget.type)}>
                        <div class="form-group col-md-12">
                            <label for="w_type" class="active">{app.texts.dashboard_form.f_widget_type[app.language]}</label>
                            <select class="form-control" id="w_type" disabled={!allowEdit} onchange={changeType}>
                                <option value="text" selected={self.editedWidget.type=='text'}>{self.getTypeName('text')}</option>
                                <option value="symbol" selected={self.editedWidget.type=='symbol'}>{self.getTypeName('symbol')}</option>
                                <option value="raw" selected={self.editedWidget.type=='raw'}>{self.getTypeName('raw')}</option>
                                <option value="line" selected={self.editedWidget.type=='line'}>{self.getTypeName('line')}</option>
                                <option value="stepped" selected={self.editedWidget.type=='stepped'}>{self.getTypeName('stepped')}</option>
                                <option value="bar" selected={self.editedWidget.type=='bar'}>{self.getTypeName('bar')}</option>
                                <option value="map" selected={self.editedWidget.type=='map'}>{self.getTypeName('map')}</option>
                                <option value="plan" selected={self.editedWidget.type=='plan'}>{self.getTypeName('plan')}</option>
                                <option value="date" selected={self.editedWidget.type=='date'}>{self.getTypeName('date')}</option>
                                <option value="led" selected={self.editedWidget.type=='led'}>{self.getTypeName('led')}</option>
                                <option value="report" selected={self.editedWidget.type=='report'}>{self.getTypeName('report')}</option>
                                <option value="multimap" selected={self.editedWidget.type=='multimap'}>{self.getTypeName('multimap')}</option>
                                <option value="multitrack" selected={self.editedWidget.type=='multitrack'}>{self.getTypeName('multitrack')}</option>
                                <option value="button" selected={self.editedWidget.type=='button'}>{self.getTypeName('button')}</option>
                                <option value="stopwatch" selected={self.editedWidget.type=='stopwatch'}>{self.getTypeName('stopwatch')}</option>
                                <option value="time" selected={self.editedWidget.type=='time'}>{self.getTypeName('time')}</option>
                                <option value="devinfo" selected={self.editedWidget.type=='devinfo'}>{self.getTypeName('devinfo')}</option>
                                <option value="form" selected={self.editedWidget.type=='form'}>{self.getTypeName('form')}</option>
                                <option value="openweather" selected={self.editedWidget.type=='openweather'}>{self.getTypeName('openweather')}</option>
                                <option value="custom" selected={self.editedWidget.type=='custom'}>{self.getTypeName('custom')}</option>
                                <option value="custom1" selected={self.editedWidget.type=='custom1'}>{self.getTypeName('custom1')}</option>
                            </select>
                        </div>
                        </div>
                        <div class="form-group row" if={ isOnBasicTab('w_name',self.editedWidget.type)}>
                            <label for="w_name" class="col-sm-2 col-form-label">{ app.texts.dashboard_form.f_widget_name[app.language] }</label>
                            <div class="col-sm-10">
                                <input required type="text" class="form-control" id="w_name" 
                                pattern="[a-zA-Z][a-zA-Z0-9-_\.]\{1,20}"
                                readonly={ !allowEdit }
                                value={ self.editedWidget.name }
                                aria-describedby="w_nameHelpBlock">
                                <small id="w_nameHelpBlock" class="form-text text-muted">
                                { app.texts.dashboard_form.f_widget_name_hint[app.language] }
                                </small>
                            </div>
                        </div>
                        <!--<div class="row" if={ isOnBasicTab('w_name',self.editedWidget.type)}>-->
                        <!--<div class="form-group col-md-12">-->
                        <!--    <form_input -->
                        <!--        id="w_name" -->
                        <!--        name="w_name" -->
                        <!--        label={ app.texts.dashboard_form.f_widget_name[app.language] } -->
                        <!--        type="text" -->
                        <!--        required="true" -->
                        <!--        pattern="[a-zA-Z][a-zA-Z0-9-_\.]\{1,20}" -->
                        <!--        content={ self.editedWidget.name } -->
                        <!--        readonly={ !allowEdit } -->
                        <!--        hint={ app.texts.dashboard_form.f_widget_name_hint[app.language] } -->
                        <!--    ></form_input> -->
                        <!--</div> -->
                        <!--</div> -->
                        <div class="row" if={ isOnBasicTab('w_title',self.editedWidget.type)}>
                        <div class="form-group col-md-12">
                            <form_input 
                                id="w_title"
                                name="w_title"
                                label={ app.texts.dashboard_form.f_widget_title[app.language] }
                                type="text"
                                content={ self.editedWidget.title }
                                readonly={ !allowEdit }
                                hint={ app.texts.dashboard_form.f_widget_title_hint[app.language] }
                            ></form_input>
                        </div>
                        </div>
                        <div class="row" if={ isOnBasicTab('w_dev_id',self.editedWidget.type)}>
                        <div class="form-group col-md-12">
                            <div class="input-field">
                                <label for="w_dev_id">{ app.texts.dashboard_form.f_widget_deviceid[app.language] }</label>
                                    <select class="form-control" id="w_dev_id" name="w_dev_id" disabled={!allowEdit} required>
                                        <option value="">{ app.texts.dashboard_form.f_widget_select_device[app.language] }</option>
                                        <option each="{d in myDevices}" value="{d.EUI}" selected="{d.EUI==self.editedWidget.dev_id}">{ d.EUI+': '+d.name}</option>
                                    </select>
                            </div>
                        </div>
                        </div>
                        <div class="row" if={ isOnBasicTab('w_app_id',self.editedWidget.type) }>
                        <div class="form-group col-md-12">
                            <div class="input-field">
                                <label for="w_app_id">{ app.texts.dashboard_form.f_widget_applicationid[app.language] }</label>
                                    <select class="form-control" id="w_app_id" name="w_app_id" disabled={!allowEdit}>
                                        <option value="">{ app.texts.dashboard_form.f_widget_select_application[app.language] }</option>
                                        <option each="{d in myApplications}" value="{d.id}" selected="{d.id==self.editedWidget.app_id}">{ d.id+': '+d.name}</option>
                                    </select>
                            </div>
                        </div>
                        </div>
                        <div class="row" if={ isOnBasicTab('w_group',self.editedWidget.type) }>
                        <div class="form-group col-md-12">
                            <form_input 
                                id="w_group"
                                name="w_group"
                                label={ app.texts.dashboard_form.f_widget_group[app.language] }
                                type="text"
                                content={ self.editedWidget.group }
                                readonly={ !allowEdit }
                                hint={ app.texts.dashboard_form.f_widget_group_hint[app.language] }
                            ></form_input>
                        </div>
                        </div>
                        <div class="row" if={ isOnBasicTab('w_width',self.editedWidget.type)}>
                        <div class="form-group col-md-12">
                            <label for="w_width" class="active">{app.texts.dashboard_form.f_widget_width[app.language]}</label>
                            <select class="form-control" id="w_width" disabled={!allowEdit}>
                                <option value="1" selected={self.editedWidget.width==1}>1</option>
                                <option value="2" selected={self.editedWidget.width==2}>2</option>
                                <option value="3" selected={self.editedWidget.width==3}>3</option>
                                <option value="4" selected={self.editedWidget.width==4}>4</option>
                            </select>
                        </div>
                        </div>
                    </form>
                    <form if={activeTab==='description'}>
                        <div class="row">
                        <div class="form-group col-md-12">
                            <form_input 
                                id="w_description"
                                name="w_description"
                                label={ self.editedWidget.type!='plan'?app.texts.dashboard_form.f_widget_description[app.language]:app.texts.dashboard_form.f_widget_svg[app.language] }
                                type="textarea"
                                content={ self.editedWidget.description.trim() }
                                readonly={ !allowEdit }
                                hint={ app.texts.dashboard_form.f_widget_description_hint[app.language] }
                            ></form_input>
                        </div>
                        </div>
                    </form>
                    <form if={activeTab==='extended'}>

                        <div class="form-group col-md-12" if={ isOnExtendedTab('w_format',self.editedWidget.type)}>
                            <label for="w_format" class="active">{app.texts.dashboard_form.f_widget_format[app.language]}</label>
                            <select class="form-control" id="w_format" disabled={!allowEdit}>
                                <option value="standard" selected={self.editedWidget.format=='standard'}>standard</option>
                                <option value="timeseries" selected={self.editedWidget.format=='timeseries'}>time series</option>
                            </select>
                        </div>
                        <div class="form-group col-md-12" if={ isOnExtendedTab('w_command_type',self.editedWidget.type) }>
                            <form_input 
                                id="w_command_type"
                                name="w_command_type"
                                label={ app.texts.dashboard_form.f_widget_commandtype[app.language] }
                                type="text"
                                content={ self.editedWidget.commandType }
                                readonly={ !allowEdit }
                                hint={ app.texts.dashboard_form.f_widget_commandtype_hint[app.language] }
                            ></form_input>
                        </div>
                        <div class="form-group col-md-12" if={ isOnExtendedTab('w_channel',self.editedWidget.type) }>
                            <form_input 
                                id="w_channel"
                                name="w_channel"
                                label={ app.texts.dashboard_form.f_widget_channel[app.language] }
                                type="text"
                                content={ self.editedWidget.channel }
                                readonly={ !allowEdit }
                                hint={ app.texts.dashboard_form.f_widget_channel_hint[app.language] }
                            ></form_input>
                        </div>
                        <div class="form-group col-md-12" if={ isOnExtendedTab('w_role',self.editedWidget.type) }>
                            <form_input 
                                id="w_role"
                                name="w_role"
                                label={ app.texts.dashboard_form.f_widget_role[app.language] }
                                type="text"
                                content={ self.editedWidget.role }
                                readonly={ !allowEdit }
                                hint={ app.texts.dashboard_form.f_widget_role_hint[app.language] }
                            ></form_input>
                        </div>                                                
                        <div class="form-group col-md-12" if={ isOnExtendedTab('w_channel_translated',self.editedWidget.type) }>
                            <form_input 
                                id="w_channel_translated"
                                name="w_channel_translated"
                                label={ app.texts.dashboard_form.f_widget_channel_translated[app.language] }
                                type="text"
                                content={ self.editedWidget.channelTranslated }
                                readonly={ !allowEdit }
                                hint={ app.texts.dashboard_form.f_widget_channel_translated_hint[app.language] }
                            ></form_input>
                        </div>
                        <div class="form-group col-md-12" if={ isOnExtendedTab('w_unit',self.editedWidget.type) }>
                            <form_input 
                                id="w_unit"
                                name="w_unit"
                                label={ app.texts.dashboard_form.f_widget_unit[app.language] }
                                type="text"
                                content={ self.editedWidget.unitName }
                                readonly={ !allowEdit }
                                hint={ app.texts.dashboard_form.f_widget_unit_hint[app.language] }
                            ></form_input>
                        </div>                        
                        <div class="form-group col-md-12" if={ isOnExtendedTab('w_rounding',self.editedWidget.type) }>
                            <form_input 
                                id="w_rounding"
                                name="w_rounding"
                                label={ app.texts.dashboard_form.f_widget_rounding[app.language] }
                                type="text"
                                content={ self.editedWidget.rounding }
                                readonly={ !allowEdit }
                                hint={ app.texts.dashboard_form.f_widget_rounding_hint[app.language] }
                            ></form_input>
                        </div>
                        <div class="form-group col-md-12" if={ isOnExtendedTab('w_query',self.editedWidget.type) }>
                            <form_input 
                                id="w_query"
                                name="w_query"
                                label={ app.texts.dashboard_form.f_widget_query[app.language] }
                                type="text"
                                content={ self.editedWidget.query }
                                readonly={ !allowEdit }
                                hint={ app.texts.dashboard_form.f_widget_query_hint[app.language] }
                            ></form_input>
                            <div class="alert alert-danger" if="{ self.invalidQuery}">{ app.texts.dashboard_form.f_widget_query_error[app.language] }</div>
                        </div>
                        <div class="form-group col-md-12" if={ isOnExtendedTab('w_range',self.editedWidget.type) }>
                            <form_input 
                                id="w_range"
                                name="w_range"
                                label={ app.texts.dashboard_form.f_widget_range[app.language] }
                                type="text"
                                content={ self.editedWidget.range }
                                readonly={ !allowEdit }
                                hint={ (self.editedWidget.type=='multimap'||self.editedWidget.type=='multitrack')?app.texts.dashboard_form.f_widget_range_hint_mm[app.language]:app.texts.dashboard_form.f_widget_range_hint[app.language] }
                            ></form_input>
                        </div>
                        <div class="form-group col-md-12" if={ isOnExtendedTab('w_icon',self.editedWidget.type) }>
                            <form_input 
                                id="w_icon"
                                name="w_icon"
                                label={ app.texts.dashboard_form.f_widget_icon[app.language] }
                                type="text"
                                content={ self.editedWidget.icon }
                                readonly={ !allowEdit }
                                hint={ app.texts.dashboard_form.f_widget_icon_hint[app.language] }
                            ></form_input>
                        </div>
                        <div class="form-group col-md-12" if={ isOnExtendedTab('w_config',self.editedWidget.type) }>
                            <form_input 
                                id="w_config"
                                name="w_config"
                                label={ app.texts.dashboard_form.f_widget_config[app.language] }
                                type="textarea"
                                content={ self.editedWidget.config }
                                readonly={ !allowEdit }
                                hint={ app.texts.dashboard_form.f_widget_config_hint[app.language] }
                            ></form_input>
                        </div>
                        <div class="form-group col-md-12" if={ isOnExtendedTab('w_chartOption',self.editedWidget.type) }>
                            <label for="w_chartOption" class="active">{app.texts.dashboard_form.f_widget_chartOption[app.language]}</label>
                            <select class="form-control" id="w_chartOption" disabled={!allowEdit}>
                                <option value="dots" selected={self.editedWidget.chartOption=='dots'}>show dots</option>
                                <option value="plain" selected={self.editedWidget.chartOption=='plain'}>line only</option>
                                <option value="area" selected={self.editedWidget.chartOption=='area'}>area below</option>
                                <option value="areaWithDots" selected={self.editedWidget.chartOption=='areaWithDots'}>area with dots</option>
                            </select>
                        </div>
                    </form>
                    <div class="modal-footer">
                        <button type="button" onClick={saveWidget} class="btn btn-primary" disabled={!allowEdit}>{app.texts.dashboard_form.save[app.language]}</button>
                        <button type="button" class="btn btn-secondary" data-dismiss="modal">{app.texts.dashboard_form.cancel[app.language]}</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
    <!-- END EDIT WIDGET -->
    
    <!-- DASHBOARD form -->
    <div class="row">
        <form class="col-md-12" onsubmit={ self.submitForm }>
            <div class="form-row">
                <div class="form-group col-md-6">
                    <form_input 
                        id="name"
                        name="name"
                        label={ app.texts.dashboard_form.name[app.language] }
                        type="text"
                        required="true"
                        content={ dashboard.name }
                        readonly={ self.mode != 'create' }
                        hint={ app.texts.dashboard_form.name_hint[app.language] }
                        ></form_input>
                </div>
                <div class="form-group col-md-6">
                    <form_input 
                        id="shared"
                        name="shared"
                        label={ app.texts.dashboard_form.shared[app.language] }
                        type="check"
                        checked={ dashboard.shared }
                        readonly={ !allowEdit }
                        ></form_input>
                        </div>
            </div>
            <div class="row">
                <div class="form-group col-md-12">
                    <form_input 
                        id="title"
                        name="title"
                        label={ app.texts.dashboard_form.title[app.language] }
                        type="text"
                        required="true"
                        content={ dashboard.title }
                        readonly={ !allowEdit }
                        hint={ app.texts.dashboard_form.title_hint[app.language] }
                        ></form_input>
                </div>
            </div>
            <div class="row">
                <div class="form-group col-md-12">
                    <form_input 
                        id="team"
                        name="team"
                        label={ app.texts.dashboard_form.team[app.language] }
                        type="text"
                        content={ dashboard.team }
                        readonly={ !allowEdit }
                        hint={ app.texts.dashboard_form.team_hint[app.language] }
                        ></form_input>
                </div>
            </div>
            <div class="row">
                <div class="form-group col-md-12">
                    <form_input 
                        id="admins"
                        name="admins"
                        label={ app.texts.dashboard_form.admins[app.language] }
                        type="text"
                        content={ dashboard.administrators }
                        readonly={ !allowEdit }
                        hint={ app.texts.dashboard_form.admins_hint[app.language] }
                        ></form_input>
                </div>
            </div>
            <div class="row">
                <div class="form-group col-md-12">
                    <form_input 
                        id="refresh_interval"
                        name="refresh_interval"
                        label={ app.texts.dashboard_form.refresh_interval[app.language] }
                        type="text"
                        content={ dashboard.refresh_interval }
                        readonly={ !allowEdit }
                        hint={ app.texts.dashboard_form.refresh_interval_hint[app.language] }
                        ></form_input>
                </div>
            </div>
            <div class="form-row" if={ !allowEdit }>
                <div class="form-group col-md-12">
                    <label for="status">{ app.texts.device_form.owner[app.language] }</label>
                    <p class="form-control-static" id="owner">{dashboard.userID}</p>
                </div>
            </div>
            <div class="row">
                <div class="form-group col-md-12">
                    <h4>{ app.texts.dashboard_form.widgets[app.language] } <i class="material-icons clickable" if={allowEdit} onclick={ editWidget(-1) } title="NEW WIDGET" data-toggle="modal" data-target="#widgetEdit">add</i></h4>
                    <table id="devices" class="table table-condensed table-striped">
                        <thead>
                            <tr>
                                <th>{ app.texts.dashboard_form.name[app.language].toUpperCase() }</th>
                                <th>{ app.texts.dashboard_form.type[app.language].toUpperCase() }</th>
                                <th class="text-right">{ app.texts.dashboard_form.action[app.language].toUpperCase() }</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr each={widget,index in self.dashboard.widgets}>
                                <td if={widget.modified}>* {widget.name}</td>
                                <td if={!widget.modified}>{widget.name}</td>
                                <td>{getTypeName(widget.type)}</td>
                                <td class="text-right">
                                    <i class="material-icons clickable" if={allowEdit} onclick={ moveWidgetDown(index) } title="MOVE DOWN">arrow_downward</i>
                                    <i class="material-icons clickable" if={allowEdit} onclick={ moveWidgetUp(index) } title="MOVE UP">arrow_upward</i>
                                    <i class="material-icons clickable" if={!allowEdit} onclick={ editWidget(index) } title="VIEW DEFINITION" data-toggle="modal" data-target="#widgetEdit">open_in_browser</i>
                                    <i class="material-icons clickable" if={allowEdit} onclick={ editWidget(index) } title="MODIFY" data-toggle="modal" data-target="#widgetEdit">mode_edit</i>
                                    <i class="material-icons clickable" if={allowEdit} onclick={ removeWidget(index) } title="REMOVE" data-toggle="modal" data-target="#widgetRemove">delete</i>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>
            </div>
            <div class="row">
                <div class="form-group col-md-12">
                    <button type="submit" class="btn btn-primary" disabled={ !allowEdit }>{ app.texts.dashboard_form.save[app.language] }</button>
                    <button type="button" class="btn btn-secondary" onclick={ close } >{ app.texts.dashboard_form.cancel[app.language] }</button>
                </div>
            </div>
        </form>
    </div>
        
    <!-- DASHBOARD form -->
    <script>
        this.visible = true
        self = this
        self.listener = riot.observable()
        self.callbackListener
        self.allowEdit = false
        self.method = 'POST'
        self.mode = 'view'
        self.channelsEncoded = ''
        self.invalidQuery = false
        self.isCopy = false
        self.dashboard = {
            id: '',
            name: '',
            title: '',
            userID: '',
            team: '',
            administrators: '',
            refresh_interval: (app.dashboardRefreshInterval/1000),
            shared: false,
            widgets:[]
        }
        self.newWidget = function(){
            return {
                name:'',
                dev_id: '',
                dev_auth_key:'',
                dev_config:'',
                dev_app_config:'',
                channel:'',
                channelTranslated:'',
                unitName:'',
                rounding:'',
                type:'text',
                query:'last 1',
                range:'',
                title:'',
                icon: '',
                width:1,
                description:'',
                format: 'standard',
                chartOption: 'dots',
                group: '',
                config:'',
                modified: false
            }
        }
        self.selectedForRemove = - 1
        self.selectedForEdit = - 1
        self.editedWidget = {}
        self.myDevices=[]
        self.myApplications=[]
        self.previousTab='basic'
        self.activeTab='basic'

        globalEvents.on('data:submitted', function(event){
            app.log("Submitted!")
        });
        
        init(eventListener, id, editable, isCopy){
            self.isCopy=isCopy
            self.callbackListener = eventListener
            self.allowEdit = editable
            self.method = 'POST'
            if (id != 'NEW' && !isCopy){
                readDashboard(id)
                self.method = 'PUT'
                if (self.allowEdit){
                    self.mode = 'update'
                } else {
                    self.mode = 'view'
                }
            } else if (id != 'NEW' && isCopy){
                readDashboard(id)
                id = 'NEW'
                self.method = 'POST'
                self.mode = 'create'
            } else{
                self.editedWidget = self.newWidget()
                self.mode = 'create'
            }
            readMyDevices()
            readMyApplications()
            riot.update()
        }

        self.submitForm = function(e){
            e.preventDefault()
            dashboardPath = ''
                //if(e.target.elements['id']){
            dashboardPath = (self.method == 'PUT') ? '/' + self.dashboard['id'] : ''
                //}
            var formData = {id:'', name:'', title:'', userID:'', shared:false, team:'', administrators: '', refresh_interval:0 , widgets:[]}
            console.log(e.target)
            formData.id = self.dashboard.id
            formData.name = e.target.elements['name_input'].value
            formData.title = e.target.elements['title_input'].value
            formData.userID = app.user.name
            formData.team = e.target.elements['team_input'].value
            formData.administrators = e.target.elements['admins_input'].value
            formData.refresh_interval = e.target.elements['refresh_interval_input'].value
            formData.shared = e.target.elements['shared_input'].checked
            formData.widgets = self.dashboard.widgets
            app.log(JSON.stringify(formData))
            e.target.reset()
            sendJsonData(
                        formData,
                        self.method,
                        app.dashboardAPI + dashboardPath,
                        'Authentication',
                        app.user.token,
                        self.submitted,
                        self.listener,
                        'submit:OK',
                        'submit:ERROR',
                        app.debug,
                        globalEvents
                        )
                //self.callbackListener.trigger('submitted')
        }

        self.close = function(){
            self.callbackListener.trigger('cancelled')
        }

        self.submitted = function(){
            self.callbackListener.trigger('submitted')
        }

        var update = function (text) {
            app.log("DASHBOARD: " + text)
            self.dashboard = JSON.parse(text);
            if(self.isCopy) {
                self.dashboard.id = ''
                self.dashboard.name=self.dashboard.name+'_1'
            }
            for(i=0; i<self.dashboard.widgets.length; i++){
                self.dashboard.widgets[i].modified=false
            }
            if(self.dashboard.refresh_interval == null || isNaN(self.dashboard.refresh_interval) || self.dashboard.refresh_interval<0){
                self.dashboard.refresh_interval=app.dashboardRefreshInterval/1000
            }
            riot.update();
        }

        var readDashboard = function (id) {
            getData(app.dashboardAPI + '/' + id,
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

        editWidget(index){
            return function(e){
                e.preventDefault()
                app.log('WIDGET:' + index)
                self.invalidQuery=false
                self.selectedForEdit = index
                if (index > - 1){
                    self.editedWidget = self.dashboard.widgets[index]
                } else{
                    self.editedWidget = self.newWidget()
                }
                self.activeTab = 'basic'
                app.log(index)
                app.log(self.editedWidget)
                self.selectedForRemove = - 1
                riot.update()
            }
        }
        
        self.changeType = function(e){
            e.preventDefault()
            self.editedWidget.type = e.target.value
            riot.update()
        }
        
        self.saveWidget = function(e){
            e.preventDefault()
            savePreviousTab('')
            var query=self.editedWidget.query
            if(query!='' && !checkQuerySyntax(query)){
                self.invalidQuery=true
                self.activeTab = 'extended'
                return
            }
            $('#widgetEdit').modal('hide');
            //
            self.editedWidget.modified=true
            //
            if (self.selectedForEdit > - 1){
                self.dashboard.widgets[self.selectedForEdit] = self.editedWidget
            } else{
                self.dashboard.widgets.push(self.editedWidget)
            }
            self.selectedForEdit = - 1
            self.editedWidget = self.newWidget()
            //e.target.reset()
            riot.update()
        }



        removeWidget(index){
            return function(e){
                e.preventDefault()
                app.log('WIDGET:' + index)
                self.selectedForRemove = index
            }
        }
        moveWidgetUp(index){
            return function(e){
                e.preventDefault()
                if (index > 0){
                    self.dashboard.widgets.splice(index-1, 0, self.dashboard.widgets.splice(index, 1)[0]);
                }
                riot.update()
            }
        }
        moveWidgetDown(index){
            return function(e){
                e.preventDefault()
                if (index < self.dashboard.widgets.length-1){
                    self.dashboard.widgets.splice(index+1, 0, self.dashboard.widgets.splice(index, 1)[0]);
                }
                riot.update()
            }
        }
        confirmRemoveWidget(index){
            return function(e){
                e.preventDefault()
                $('#widgetRemove').modal('hide');
                self.dashboard.widgets.splice(index, 1)
                self.selectedForRemove = - 1
                riot.update()
            }
        }

        self.getTypeName = function(name){
            var tmpName
            switch (name){
                case 'symbol':
                    return app.texts.dashboard_form.type_symbol[app.language]
                    break
                case 'text':
                    return app.texts.dashboard_form.type_text[app.language]
                    break
                case 'raw':
                    return app.texts.dashboard_form.type_raw[app.language]
                    break
                case 'gauge':
                    return app.texts.dashboard_form.type_gauge[app.language]
                    break
                case 'line':
                    return app.texts.dashboard_form.type_line[app.language]
                    break
                case 'stepped':
                    return app.texts.dashboard_form.type_stepped[app.language]
                    break
                case 'bar':
                    return app.texts.dashboard_form.type_bar[app.language]
                    break
                case 'button':
                    return app.texts.dashboard_form.type_button[app.language]
                    break
                case 'form':
                    return app.texts.dashboard_form.type_form[app.language]
                    break
                case 'map':
                    return app.texts.dashboard_form.type_map[app.language]
                    break
                case 'multimap':
                    return app.texts.dashboard_form.type_multimap[app.language]
                    break
                case 'multitrack':
                    return app.texts.dashboard_form.type_multitrack[app.language]
                    break
                case 'date':
                    return app.texts.dashboard_form.type_date[app.language]
                    break
                case 'led':
                    return app.texts.dashboard_form.type_led[app.language]
                    break
                case 'plan':
                    return app.texts.dashboard_form.type_plan[app.language]
                    break
                case 'report':
                    return app.texts.dashboard_form.type_report[app.language]
                    break
                case 'stopwatch':
                    return app.texts.dashboard_form.type_stopwatch[app.language]
                    break
                case 'time':
                    return app.texts.dashboard_form.type_time[app.language]
                    break
                case 'devinfo':
                    return app.texts.dashboard_form.type_devinfo[app.language]
                    break
                case 'openweather':
                    return app.texts.dashboard_form.type_openweather[app.language]
                    break
                case 'custom':
                    return app.texts.dashboard_form.type_custom[app.language]
                case 'custom1':
                    return app.texts.dashboard_form.type_custom1[app.language]
                    break
                default:
                    if(typeof name==='string' && (name.startsWith('form_') || name.startsWith('custom_'))){
                        try{
                            var elemName='type_'+name
                            var tmpElem=app.custom_texts.dashboard_form[elemName]
                            tmpName=tmpElem[app.language]
                            return tmpName
                        }catch(err){
                            return name;
                        }
                    }else{
                        return name
                    }
            }
        }
        
        var readMyDevices = function() {
                getData(app.iotAPI,
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
            riot.update();
        }
        var readMyApplications = function() {
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
            self.myApplications = JSON.parse(text);
            riot.update();
        }

        selectBasic(e){
            console.log('basic selected')
            return function(e){
                e.preventDefault()
                savePreviousTab('basic')
                self.activeTab = 'basic'
                readMyDevices()
            }
        }
        selectDescription(e){
            return function(e){
                e.preventDefault()
                savePreviousTab('description')
                self.activeTab = 'description'
            }
        }
        selectExtended(e){
            return function(e){
                e.preventDefault()
                savePreviousTab('extended')
                self.activeTab = 'extended'
            }
        }

        isOnBasicTab(fieldName, widgetType){
            var requiredFields=['w_type','w_name','w_title','w_width']
            if(requiredFields.includes(fieldName)){
                return true
            }
            var result=false;
            var fields=[]
            switch(widgetType){
                case 'report':
                case 'multimap':
                case 'multitrack':
                case 'plan':
                    fields=['w_group']
                    break
                default:
                    if(typeof widgetType==='string' && (widgetType.startsWith('form') || widgetType.startsWith('custom'))){
                        fields=['w_app_id','w_dev_id']
                    }else if(widgetType==='text'){
                        fields=[]
                    }else{
                        fields=['w_dev_id']
                    }
            }
            result=fields.indexOf(fieldName)>=0
            console.log('isOnBasicTab '+fieldName+' '+widgetType+' '+result)
            return result
        }

        isOnExtendedTab(fieldName, widgetType){
            var requiredFields=['w_channel','w_role']
            if(requiredFields.includes(fieldName)){
                return true
            }
            var result=false;
            var fields=[]
            switch(widgetType){
                case 'text':
                    fields=[]
                    break
                case 'raw':
                    fields=['w_query','w_format']
                    break
                case 'line':
                case 'stepped':
                case 'bar':
                case 'map':
                case 'date':
                case 'stopwatch':
                case 'time':
                    fields=['w_query']
                    break
                case 'plan':
                case 'led':
                    fields=['w_query','w_range']
                    break
                case 'report':
                case 'devinfo':
                case 'openweather':
                    fields=['w_query','w_channel_translated']
                    break
                case 'multimap':
                case 'multitrack':
                    fields=['w_query','w_channel_translated','w_range']
                    break
                case 'button':
                    fields=['w_data_type','w_command_type']
                    break
                case 'symbol':
                    fields=['w_query','w_unit','w_rounding','w_range','w_icon']
                    break
                case 'chart':
                    fields=['w_query','w_chartOption']
                    break
                default:
                    if(typeof widgetType==='string' && widgetType.startsWith('form')){
                        fields=['w_config']
                    }else if(typeof widgetType==='string' && widgetType.startsWith('custom')){
                        fields=['w_unit','w_rounding','w_query','w_config']
                    }
            }
            result=fields.indexOf(fieldName)>=0
            console.log('isOnExtendedTab '+fieldName+' '+widgetType+' '+result)
            return result
        }

        getAuthKey = function(eui){
            console.log(self.myDevices)
            for(i=0;i<self.myDevices.length; i++){
                if(self.myDevices[i].EUI===eui){
                    return self.myDevices[i].key
                }
            }
            return ''
        }
        getDeviceConfig = function(eui){
            console.log(self.myDevices)
            for(i=0;i<self.myDevices.length; i++){
                if(self.myDevices[i].EUI===eui){
                    return self.myDevices[i].configuration
                }
            }
            return ''
        }
        getApplicationConfig = function(id){
            //console.log('applications:')
            //console.log('getApplicationConfig('+id+')')
            //console.log(self.myApplications)
            var cfg=''
            for(i=0;i<self.myApplications.length; i++){
                if(self.myApplications[i].id==id){
                    cfg=self.myApplications[i].configuration
                    break;
                }
            }
            //console.log('configuration: '+cfg)
            return cfg
        }

        savePreviousTab = function(nextTab){
            if(self.activeTab===nextTab) return;
            console.log('tab name (active/next): '+self.activeTab+'/'+nextTab)
            if(self.activeTab==='basic'){
                try{
                  self.editedWidget.name = document.getElementById('w_name').value
                  self.editedWidget.name=self.editedWidget.name.replace(/[^0-9a-zA-Z]/g, '')
                }catch(err){console.log(err)}
                try{
                  self.editedWidget.width = parseInt(document.getElementById('w_width').value,10)
                  if(self.editedWidget.width == null || isNaN(self.editedWidget.width) || self.editedWidget.width<1 || self.editedWidget.width >4){
                  self.editedWidget.width = 1
                  }
                }catch(err){console.log(err)}
                try{
                  self.editedWidget.dev_id = document.getElementById('w_dev_id').value.replace(/\s+/g,'')
                }catch(err){
                  self.editedWidget.dev_id = ''
                }
                try{
                  self.editedWidget.app_id = document.getElementById('w_app_id').value.replace(/\s+/g,'')
                }catch(err){
                  self.editedWidget.app_id = ''
                }
                try{
                  self.editedWidget.dev_auth_key=getAuthKey(self.editedWidget.dev_id)
                }catch(err){
                    console.log(err)
                  self.editedWidget.dev_auth_key=''
                }
                try{
                  self.editedWidget.dev_config=getDeviceConfig(self.editedWidget.dev_id)
                }catch(err){
                    console.log(err)
                  self.editedWidget.dev_config=''
                }
                try{
                  self.editedWidget.dev_app_config=getApplicationConfig(self.editedWidget.app_id)
                }catch(err){
                    console.log(err)
                  self.editedWidget.dev_app_config=''
                }
                try{
                  self.editedWidget.group = document.getElementById('w_group_input').value.replace(/\s+/g,'')
                }catch(err){
                  self.editedWidget.group = ''
                }
                try{
                  self.editedWidget.title= document.getElementById('w_title_input').value
                }catch(err){
                }
                self.editedWidget.type = document.getElementById('w_type').value
            }
            
            if(self.activeTab==='description'){
                try{
                self.editedWidget.description = document.getElementById('w_description_input').value
                }catch(err){console.log(err)}
            }

            if(self.activeTab==='extended'){
                try{
                  self.editedWidget.format = document.getElementById('w_format').value
                }catch(err){
                  self.editedWidget.format = 'standard'
                }
                try{
                  self.editedWidget.chartOption = document.getElementById('w_chartOption').value
                }catch(err){
                  self.editedWidget.chartOption = 'plain'
                }
                try{
                    self.editedWidget.channel = document.getElementById('w_channel_input').value.replace(/\s+/g,'')
                    if(self.editedWidget.channel=='') self.editedWidget.channel='-'
                }catch(err){console.log(err)}
                try{
                self.editedWidget.commandType = document.getElementById('w_command_type_input').value
                }catch(err){console.log(err)}
                try{
                self.editedWidget.channelTranslated = document.getElementById('w_channel_translated_input').value.replace(/\s+/g,'')
                }catch(err){console.log(err)}
                try{
                self.editedWidget.unitName = document.getElementById('w_unit_input').value
                }catch(err){console.log(err)}
                try{
                self.editedWidget.rounding = document.getElementById('w_rounding_input').value
                }catch(err){console.log(err)}
                try{
                self.editedWidget.config = document.getElementById('w_config_input').value
                }catch(err){console.log(err)}
                try{
                  self.editedWidget.query = document.getElementById('w_query_input').value.trim()
                    try{
                    var n=parseInt(self.editedWidget.query)
                    if(Number.isInteger(n)){
                        self.editedWidget.query = 'last '+n
                    }
                    }catch(err){
                    self.editedWidget.query = 'last 1'
                    }
                }catch(err){console.log(err)}
                try{
                self.editedWidget.range = document.getElementById('w_range_input').value
                }catch(err){console.log(err)}
                try{
                self.editedWidget.config = document.getElementById('w_config_input').value
                }catch(err){console.log(err)}
                try{    
                  self.editedWidget.icon = document.getElementById('w_icon_input').value
                }catch(err){
                  self.editedWidget.icon = ''
                }
                try{
                self.editedWidget.role = document.getElementById('w_role_input').value
                }catch(err){console.log(err)}
            }
        }

    </script>
</app_dashboard_form>