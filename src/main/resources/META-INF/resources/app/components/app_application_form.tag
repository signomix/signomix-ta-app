<app_application_form>
    <div class="row">
        <div class="input-field col-md-12">
            <h2 if={ self.mode=='create' }>{ app.texts.device_form.header_a_new[app.language] }</h2>
            <h2 if={ self.mode=='update' }>{ app.texts.device_form.header_a_modify[app.language] }</h2>
            <h2 if={ self.mode=='view' }>{ app.texts.device_form.header_a_view[app.language] }</h2>
        </div>
    </div>
    <div class="row">
        <form class="col-md-12" onsubmit={ self.submitForm }>
            <div class="form-row">
                <div class="form-group col-md-12">
                    <form_input 
                        id="name" 
                        name="name" 
                        label={ app.texts.device_form.name[app.language] } 
                        type="text" required="true" 
                        content={ application.name } 
                        readonly={ !allowEdit } 
                        hint={ app.texts.device_form.name_hint[app.language] }>
                    </form_input>
                </div>
            </div>
            <div class="form-row">
                <div class="form-group col-md-12">
                    <form_input 
                        id="configuration" 
                        name="configuration" 
                        label={ app.texts.device_form.configuration[app.language] } 
                        type="textarea" 
                        content={ group.description } 
                        readonly={ !allowEdit } 
                        rows=4>
                    </form_input>
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
                    <button type="button" class="btn btn-secondary" onclick={ close }>{ app.texts.common.cancel[app.language] }</button>
                </div>
            </div>
        </form>
    </div>
    <script>
        this.visible = true
        self = this
        self.listener = riot.observable()
        self.callbackListener
        self.allowEdit = false
        self.method = 'POST'
        self.mode = 'view'
        self.communicationError = false
        self.errorMessage = ''
        self.application = {
            'id': '',
            'name': '',
            'configuration': ''
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
        })

        globalEvents.on('data:submitted', function(event) {
            app.log('SUBMITTED')
        })

        init(eventListener, id, editable) {
            self.callbackListener = eventListener
            self.allowEdit = editable
            self.method = 'POST'
            if (id != 'NEW') {
                readApplication(id)
                self.method = 'PUT'
                if (self.allowEdit) {
                    self.mode = 'update'
                } else {
                    self.mode = 'view'
                }
            } else {
                self.mode = 'create'
            }
        }

        self.submitForm = function(e) {
            e.preventDefault()
            applicationPath = ''
            if (self.mode == 'update') {
                applicationPath = (self.method == 'PUT') ? '/' + self.application.id : ''
            }
            var formData = {
                name: '',
                configuration: ''
            }
            formData.name = e.target.elements['name_input'].value
            formData.configuration = e.target.elements['configuration_input'].value
            app.log(JSON.stringify(formData))
            sendData(
                formData,
                self.method,
                app.applicationAPI + applicationPath,
                app.user.token,
                self.submitted,
                self.listener,
                'submit:OK',
                null,
                app.debug,
                null //globalEvents
            )
        }

        self.close = function() {
            self.callbackListener.trigger('cancelled')
        }

        self.submitted = function() {
            self.callbackListener.trigger('submitted')
        }

        var update = function(text) {
            app.log("GROUP: " + text)
            self.application = JSON.parse(text);
            riot.update();
        }

        var readApplication = function(appID) {
            getData(app.applicationAPI + '/' + appID,
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

    </script>
</app_application_form>
