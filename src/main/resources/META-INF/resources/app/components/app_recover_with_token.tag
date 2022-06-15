<app_recover_with_token> 
    <div class="panel panel-default signomix-form">
        <div class="panel-body">
            <div class="row">
            <div class="col">
            <p class="module-title h3 text-center mb-4">{'TYTUŁ FORMULARZA'}</p>
            </div>
            </div>
            <div class="row">
            <div class="col">
            <form onsubmit={ submitForm }>
                <div class="form-group">
                    <form_input 
                        id="token"
                        name ="token"
                        label={'TOKEN' }
                        type="text"
                        required="true"
                        />
                </div>
                <button type="submit" class="btn btn-primary">{ 'OK' }</button>
                <button type="button" class="btn btn-secondary" onclick={ close }>{ 'CANCEL' }</button>
            </form>
            </div>
        </div>
    </div>
    </div>

    <script>
        self=this
        submitForm = function(e){
            e.preventDefault()
            document.location='app/?tid='+document.getElementById('token_input')+'#!account'
        }
        
        self.close = function(e){
            route('main')
        }
        
    </script>
    <style>
        .form-footer{
            margin-top: 20px;
            margin-bottom: 20px;
        }
    </style>
</app_recover_with_token>