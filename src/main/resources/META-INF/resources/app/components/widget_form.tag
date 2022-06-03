<widget_form>
    <div if={ type == 'form' } class="container bg-white border border-info rounded topspacing p-0">
        <div class="row px-1 py-1">
            <div if={ !app.user.guest } class="col-12 text-center">
                <button type="button" class="btn btn-info btn-block" } data-toggle="modal" data-target="#{name}">{ title }</button>
            </div>
            <div if={ app.user.guest } class="col-12 text-center">
                <button type="button" class="btn btn-secondary btn-block" disabled>{ title }</button>
            </div>
        </div>
    </div> 
    <div id="{name}" class="modal" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h4 class="modal-title">{ title }</h4>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body" if={ app.user.roles.includes(role) || role==='' }>
                    <p>{ app.texts.widget_button.device[app.language] } { dev_id }</p>
                    <virtual each={chName, i in channelFields }>
                    <div class="form-row">
                        <div class="form-group col-md-12">
                            <label for={chName+'_input'}>{ chName }</label>
                            <input class="form-control" 
                            id={chName+'_input'}
                            name={chName+'_input'}
                            type={chName==='timestamp'?'datetime-local':'text'}
                            value=''
                            >
                        </div>
                    </div>
                    </virtual>
                    <p id={name+'-desc'} style="margin-top: 1rem;">{description}</p>
                </div>
                <div class="modal-body" if={ !app.user.roles.includes(role) && role!==''}>
                    <p>{ app.texts.widget_button.device[app.language] } { dev_id }</p>
                    <p id={name+'-desc'} style="margin-top: 1rem;">{description}</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" if={ app.user.roles.includes(role) || role==='' } onclick={ getData() } data-dismiss="modal" >{ app.texts.widget_button.save[app.language] }</button>
                    <button type="button" class="btn btn-secondary pull-right" data-dismiss="modal">{ app.texts.widget_button.cancel[app.language] }</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        var self = this
        self.channelFields=[]

        self.show2 = function(){
            try{
            self.channelFields=self.channel.split(',')
            }catch(ex){
            }
            self.dataToSend={}
            self.authKey=self.dev_auth_key

        }

        self.submitted = function(){
            app.log('submitted')
        }
        
        getData(){
            return function(e){
                e.preventDefault()
                var ename,evalue,dt
                for(i=0; i<self.channelFields.length; i++){
                    ename=self.channelFields[i]
                    evalue=document.getElementById(ename+'_input').value
                    if('timestamp'===ename){
                        dt=new Date(evalue)
                        evalue=dt.toISOString()
                        console.log('evalue:'+evalue)
                        self.dataToSend[''+ename]=evalue
                    }else{
                        self.dataToSend[''+ename]=evalue
                    }
                }
                console.log(self.dataToSend)
                self.sendTheData()
            }
        }

        sendTheData(){
                var url=app.dataInputAPI
                sendIotData(
                    self.dataToSend,
                    'POST',
                    url,
                    self.dev_id,
                    self.authKey,
                    self.submitted,
                    self.listener,
                    'submit:OK',
                    'submit:ERROR',
                    app.debug,
                    globalEvents
                )               
        }
        
    </script>
    <style>
        .topspacing{
            margin-top: 10px;
        }
    </style>
</widget_form>