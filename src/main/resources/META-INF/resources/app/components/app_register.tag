<app_register>
    <div class="panel panel-default signomix-form">
        <div class="panel-body">
            <div class="row" if={ !self.success }>
                <div class="col-md-12"><h3 class="module-title">{app.texts.register.l_title[app.language]}</h3></div>
            </div>
            <div class="row">
                <div class="col-md-12 alert alert-light" ><span>{ app.texts.register.l_comment[app.language] }</span></div>
            </div>
            <div class="row" if={ self.success }>
                <div class="col-md-12 alert alert-success" >
                <p><span>{ app.texts.register.l_successText1[app.language] }</span></p>
                <p><span>{ app.texts.register.l_successText2[app.language] + ' '+self.registeredEmail}</span></p>
                <button type="button" class="btn btn-secondary" onclick={ close }>{ app.texts.register.l_OK[app.language] }</button>
                </div>
            </div>
            <div class="row" if={ !self.success }>
                <div class="col-md-12">
                <form class="card border-0 p2" onsubmit={ submitRegistrationForm } id="registration-form">
                    <div class="form-row">
                        <div class="input-field mr-1">
                            <label for="login_input">* { app.texts.register.l_login[app.language] }</label>
                            <input type="text" class="form-control" id="login_input" 
                                pattern="[a-zA-Z][a-zA-Z0-9-_@\.]\{1,20}" 
                                required
                                aria-describedby="login_inputHelp">
                            <small id="login_inputHelp" class="form-text text-muted">{ app.texts.register.l_loginHint[app.language] }</small>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="input-field mr-1">
                            <label for="email_input">* { app.texts.register.l_email[app.language] }</label>
                            <input type="email" class="form-control" id="email_input" 
                                required
                                aria-describedby="email_inputHelp">
                            <small id="email_inputHelp" class="form-text text-muted">{ app.texts.register.l_emailHint[app.language] }</small>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="input-field mr-1">
                            <label for="name_input">* { app.texts.register.l_name[app.language] }</label>
                            <input type="text" class="form-control" id="name_input" 
                                required
                                aria-describedby="name_inputHelp">
                            <small id="name_inputHelp" class="form-text text-muted">{ app.texts.register.l_nameHint[app.language] }</small>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="input-field mr-1">
                            <label for="surname_input">* { app.texts.register.l_surname[app.language] }</label>
                            <input type="text" class="form-control" id="surname_input" 
                                required
                                aria-describedby="surname_inputHelp">
                            <small id="surname_inputHelp" class="form-text text-muted">{ app.texts.register.l_surnameHint[app.language] }</small>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="input-field mr-1">
                            <label for="organization_input">* { app.texts.register.l_organization[app.language] }</label>
                            <input type="text" class="form-control" id="organization_input" 
                                aria-describedby="organization_inputHelp">
                            <small id="organization_inputHelp" class="form-text text-muted">{ app.texts.register.l_organizationHint[app.language] }</small>
                        </div>
                    </div>
                    <a href='' onclick="alert('Pobieranie danych organizacjji zostanie udostępnione w kolejnej wersji serwisu.'); return false;">{ app.texts.register.l_getOrganization[app.language] }</a><br>
                    <div class="form-row">
                        <div class="input-field mr-1">
                            <label for="password_input">* { app.texts.register.l_password[app.language] }</label>
                            <input type="password" class="form-control" id="password_input"
                                pattern="(?=^.\{8,}$)((?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$"
                                required
                                aria-describedby="password_inputHelp">
                            <small id="password_inputHelp" class="form-text text-muted">{ app.texts.register.l_passwordHint[app.language] }</small>
                        </div>
                    </div>
                    <div class="form-row">
                        <div class="input-field mr-1">
                            <label for="password2_input">* { app.texts.register.l_retypepassword[app.language] }</label>
                            <input type="password" class="form-control" id="password2_input"
                                pattern="(?=^.\{8,}$)((?=.*\d)|(?=.*\W+))(?![.\n])(?=.*[A-Z])(?=.*[a-z]).*$"
                                required
                                aria-describedby="password2_inputHelp">
                            <small id="password2_inputHelp" class="form-text text-muted">{ app.texts.register.l_passwordHint[app.language] }</small>
                        </div>
                    </div>
                    <div class="form-check form-check-inline">
                    <label class="form-check-label">{ app.texts.user_form.preferredLanguage[app.language] }</label>
                    </div>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="preferredLanguage" id="preferredLanguage1" value="pl" checked>
                        <label class="form-check-label" for="preferredLanguage1">Polski</label>
                    </div>
                    <div class="form-check form-check-inline">
                        <input class="form-check-input" type="radio" name="preferredLanguage" id="preferredLanguage2" value="en">
                        <label class="form-check-label" for="preferredLanguage2">English</label>
                    </div>
                    <div class="form-check" style="margin-bottom: 20px;">
                        <input class="form-check-input" type="checkbox" value="y" id="accept" name="accept" required>
                        <label class="form-check-label" for="accept">
                        { app.texts.register.l_legalText1[app.language] } <a href="#!doc,legal" target="_blank">{ app.texts.register.l_legalText2[app.language] }</a>.
                        </label>
                    </div>
                    <div class="row" if={ self.alert }>
                        <div class="col-md-12 alert alert-warning" ><span><strong>{ app.texts.register.l_warning[app.language] } </strong>{ self.alertText }</span></div>
                    </div>
                    <div class="form-group">
                        <button type="submit" class="btn btn-primary">{ app.texts.register.l_register[app.language] }</button>
                        <button type="button" class="btn btn-secondary" onclick={ goto('#!') }>{ app.texts.register.l_cancel[app.language] }</button>
                    </div>
                </form>
                </div>
            </div>
        </div>
    </div>
<script>
    self = this
    self.alert = false;
    self.alertText = ''
    self.success = false
    self.registeredEmai = ''
    self.listener = riot.observable();
    
    self.listener.on('*', function (eventName) {
        app.log('ALERTS: ' + eventName)
        if('err:409'==eventName){
            self.alert=true
            self.alertText = app.texts.register.l_alertName[app.language]
            riot.update()
        }else if('err:400'==eventName){
            self.alert=true
            self.alertText = app.texts.register.l_alertOrganization[app.language]
            riot.update()
        } else if (eventName.startsWith('err')) {
            self.alert = true
            self.alertText = app.texts.register.l_alertError[app.language]
            riot.update()
        }
    });

    submitRegistrationForm = function (e) {
        e.preventDefault()
        self.alert = false
        riot.update()
        app.log("registering ..." + e.target)
        var formData = {
            type: 'USER',
            confirmed: false
        }
        formData.uid = e.target.elements['login_input'].value
        formData.password = e.target.elements['password_input'].value
        formData.email = e.target.elements['email_input'].value
        formData.name = e.target.elements['name_input'].value
        formData.surname = e.target.elements['surname_input'].value
        formData.preferredLanguage = e.target.elements['preferredLanguage'].value
        formData.accept = e.target.elements['accept'].value
        try{
          formData.organization = e.target.elements['organization_input'].value
        }catch(err){}
        self.registeredEmail = formData.email
        if (self.validate(formData,e.target.elements['password2_input'].value) == 0) {
            //send
            app.log(JSON.stringify(formData))
            urlPath = ''
            sendData(
                formData,
                'POST',
                app.userAPI,
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
            self.alertText = app.texts.register.l_alertPassword[app.language]
            this.update()
        }
        riot.update()
    }

    self.validate = function (form, password2) {
        app.log('validating ...')
        if (form.password != password2) {
            return 1;
        }
        return 0
    }

    goto(address){
            return function(e){
                app.log(address)
                document.location = address
            }
        }

    self.close = function (object) {
        var text = '' + object
        app.log(text)
        if (text.startsWith('"')) {
            self.success = true
        } else if (text.startsWith('error:409')) {
            self.alert = true
            self.alertText = app.texts.register.l_alertName[app.language]
        } else if (text.startsWith('error:400')) {
            self.alert = true
            self.alertText = app.texts.register.l_alertOrganization[app.language]
        } else if (text.startsWith('error:')) {
            self.alert = true
            self.alertText = app.texts.register.l_alertError[app.language]
        } else {
            app.currentPage = 'main'
        }
        riot.update()
    }

</script>
</app_register>
