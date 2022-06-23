<app_recover_with_token> 
    <div class="panel panel-default signomix-form">
        <div class="panel-body">
            <div class="row">
                <div class="col">
                <p class="module-title h3 text-center mb-4">{app.texts.rwt.title[app.language]}</p>
                </div>
                </div>
            <div class="row" if={ self.success }>
                <div class="col alert alert-success" >
                <p><span>{ app.texts.register.l_successText1[app.language] }</span></p>
                <p><span>{ app.texts.register.l_successText2[app.language] + ' '+self.registeredEmail}</span></p>
                <button type="button" class="btn btn-secondary" onclick={ close }>{ app.texts.register.l_OK[app.language] }</button>
                </div>
            </div>
            <div class="row" if={ !self.success }>
            <div class="col">
            <form onsubmit={ submitRegistrationForm }>
                <div class="form-group">
                    <form_input 
                        id="login"
                        name ="login"
                        label={ app.texts.rwt.login[app.language] }
                        type="text"
                        readonly="true"
                        content={app.user.name}
                        />
                </div>
                <div class="md-form" if={ self.alert }>
                    <span class="red-text">password do not match</span>
                </div>
                <div class="form-group">
                    <form_input 
                        id="password"
                        name ="password"
                        label={ app.texts.rwt.password[app.language] }
                        type="password"
                        required="true"
                        />
                </div>
                <div class="form-group">
                    <form_input 
                        id="password2"
                        name ="password2"
                        label={ app.texts.rwt.password2[app.language] }
                        type="password"
                        required="true"
                        />
                </div>
                <div class="md-form" if={ self.error }>
                    <span class="red-text">password do not match</span>
                </div>
                <div class="form-group">
                    <form_input 
                        id="email"
                        name ="email"
                        label={ app.texts.rwt.email[app.language] }
                        type="email"
                        required="true"
                        />
                </div>
                <div class="form-group">
                    <form_input 
                        id="email2"
                        name ="email2"
                        label={ app.texts.rwt.email2[app.language] }
                        type="email"
                        required="true"
                        />
                </div>
                <div class="md-form" if={ self.error2 }>
                    <span class="red-text">e-mail do not match</span>
                </div>
                <div class="form-group">
                    <form_input 
                        id="name"
                        name ="name"
                        label={app.texts.rwt.name[app.language]}
                        type="text"
                        required="true"
                        />
                </div>
                <div class="form-group">
                    <form_input 
                        id="surname"
                        name ="surname"
                        label={app.texts.rwt.surname[app.language]}
                        type="text"
                        required="true"
                        />
                </div>
                <div class="form-group">
                <div class="form-check form-check-inline">
                    <label class="form-check-label">{ app.texts.rwt.language[app.language] }</label>
                </div>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="preferredLanguage" id="preferredLanguage1" value="pl" checked={self.user.language==='pl'}>
                    <label class="form-check-label" for="preferredLanguage1">Polski</label>
                </div>
                <div class="form-check form-check-inline">
                    <input class="form-check-input" type="radio" name="preferredLanguage" id="preferredLanguage2" value="en" checked={self.user.language==='en'}>
                    <label class="form-check-label" for="preferredLanguage2">English</label>
                </div> 
                </div> 
                <div class="form-group">
                <div class="form-check" style="margin-bottom: 20px;">
                        <input class="form-check-input" type="checkbox" value="y" id="accept" name="accept" required>
                        <label class="form-check-label" for="accept">
                        { app.texts.register.l_legalText1[app.language] } <a href="#!doc,legal">{ app.texts.register.l_legalText2[app.language] }</a>.
                        </label>
                    </div>
                </div>
                <button type="submit" class="btn btn-primary">{ app.texts.common.save[app.language] }</button>
                <button type="button" class="btn btn-secondary" onclick={ close }>{ app.texts.common.cancel[app.language] }</button>
            </form>
            </div>
        </div>
    </div>
    </div>

    <script>
        self=this
        self.errorCode=0
        self.success=false
        self.user={name:'',surname:'',email:'',password:'',language:''}
        self.user.language=app.user.preferredLanguage
        if(self.user.language==='' || self.user.language===null || self.user.language===undefined){
            self.user.language='pl'
        }else{
            console.log(self.user.language)
        }
        self.listener = riot.observable();
        submitForm = function(e){
            e.preventDefault()
            self.success=true
            //document.location='?tid='+document.getElementById('token_input')+'#!account'
        }
        
        self.close = function(e){
            route('main')
        }
        self.listener.on('*', function (eventName) {
            app.log('ALERTS: ' + eventName)
            if('err:409'==eventName){
            self.errorCode=3
            self.alertText = app.texts.register.l_alertName[app.language]
            riot.update()
            }
        });

    submitRegistrationForm = function (e) {
        e.preventDefault()
        riot.update()
        app.log("registering ..." + e.target)
        var formData = {
            type: 'USER',
            confirmed: false
        }
        //formData.uid = e.target.elements['login_input'].value
        formData.password = e.target.elements['password_input'].value
        formData.email = e.target.elements['email_input'].value
        formData.name = e.target.elements['name_input'].value
        formData.surname = e.target.elements['surname_input'].value
        formData.preferredLanguage = e.target.elements['preferredLanguage'].value
        formData.accept = e.target.elements['accept'].value
        self.registeredEmail = formData.email
        console.log(formData)
        self.errorCodet=self.validate(formData)
        if ( self.errorCode== 0) {
            //send
            app.log(JSON.stringify(formData))
            urlPath = ''
            sendData(
                formData,
                'PUT',
                app.userAPI+app.user.name,
                null,
                self.close,
                self.listener, 
                'submit:OK',
                null,
                app.debug,
                null //globalEvents
            )
        } else {
            self.alert = true
            self.alertText = app.texts.rwt.l_alertPassword[app.language]
            this.update()
        }
        riot.update()
    }

    self.validate = function (form) {
        app.log('validating ...')
        if (form.password != e.target.elements['password2_input'].value) {
            return 1;
        }
        if (form.email != e.target.elements['email2_input'].value) {
            return 2;
        }
        return 0
    }
        
    </script>
    <style>
        .form-footer{
            margin-top: 20px;
            margin-bottom: 20px;
        }
    </style>
</app_recover_with_token>