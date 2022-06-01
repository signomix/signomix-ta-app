<widget_form>
    <div if={ type == 'widget_form' } class="container bg-white border border-info rounded topspacing p-0">
        <div class="row px-1 py-1">
            <div if={ !app.user.guest } class="col-12 text-center">
                <button type="button" class="btn btn-info btn-block" onclick={ fillDesc() } data-toggle="modal" data-target="#{name}">{ title }</button>
            </div>
            <div if={ app.user.guest } class="col-12 text-center">
                <button type="button" class="btn btn-secondary btn-block" disabled>{ title }</button>
            </div>
        </div>
    </div> 
    <div id="{name+'2'}" class="modal" tabindex="-1" role="dialog">
        <div class="modal-dialog" role="document">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title">{ app.texts.widget_button.title[app.language] }</h5>
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close">
                        <span aria-hidden="true">&times;</span>
                    </button>
                </div>
                <div class="modal-body">
                  <form>
                    <virtual each={chName, i in channelFields }>
                    <div class="form-row">
                        <div class="form-group col-md-12">
                            <form_input 
                              id={chName} 
                              name={chName} 
                              label=" 
                              type="text" required="true" 
                              content="" 
                              readonly=false 
                              hint="">
                            </form_input>
                        </div>
                    </div>
                    </virtual>
                  </form>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-danger" data-dismiss="modal" if={dataToSend!=''} onclick={ sendCommand() }>{ app.texts.widget_button.confirm[app.language] }</button>
                    <button type="button" class="btn btn-secondary" data-dismiss="modal">{ app.texts.widget_button.cancel[app.language] }</button>
                </div>
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
                <div class="modal-body">
                    <p>{ app.texts.widget_button.device[app.language] } { dev_id }</p>
                    <form>
                        <div class="form-group" if="{channel==='HEX'}">
                            <label for="hexString">HEX STRING</label>
                            <input type='text' value={dataToSend} name="newvalue" id='hexString'>
                        </div>
                        <div class="form-group" if="{channel==='JSON'}">
                            <label for="jsonText">JSON</label>
                            <textarea class="form-control" id="jsonText" rows="3">{dataToSend}</textarea>
                        </div>
                        <div class="form-group" if="{channel!=='JSON' && channel!=='HEX'}">
                            <p>Unsupported data type. Must be "HEX" or "JSON"!</p>
                        </div>
                    </form>
                    <p id={name+'-desc'} style="margin-top: 1rem;">{description}</p>
                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-primary" onclick={ getData() } data-dismiss="modal" data-toggle="modal" data-target="#{name+'2'}">{ app.texts.widget_button.save[app.language] }</button>
                    <button type="button" class="btn btn-secondary pull-right" data-dismiss="modal">{ app.texts.widget_button.cancel[app.language] }</button>
                </div>
            </div>
        </div>
    </div>

    <script>
        var self = this
        self.dataToSend=''
        self.channelFields=[]

        self.show2 = function(){
            try{
            self.channelFields=self.channel.split(',')
            }catch(ex){
            }
            self.dataToSend=''
        }

        self.listener = riot.observable()
        self.listener.on('*', function(eventName){
            app.log("widget_form listener on event: " + eventName)
        })

        self.submitted = function(){
            app.log('submitted')
        }

        fillDesc(){
            return function(e){
                e.preventDefault()
                document.getElementById(self.name+'-desc').innerHTML=self.description
            }
        }
        
        getData(){
            return function(e){
                e.preventDefault()
                if(self.channel=='hex'){
                    //self.dataToSend = document.getElementById('hexString').value
                }else if(self.channel=='json'){
                    //self.dataToSend= document.getElementById('jsonText').value
                }
                //self.dataToSend=self.dataToSend.trim()
            }
        }

        sendData(){
            return function(e){
                e.preventDefault()
                var url
                if(self.channel=='hex'){
                    url=app.actuatorAPI + '/' + self.dev_id + "/hex"
                }else if(self.channel=='json'){
                    url=app.actuatorAPI + '/' + self.dev_id
                }
                sendTextData(
                    self.dataToSend,
                    'POST',
                    url,
                    app.user.token,
                    self.submitted,
                    self.listener,
                    'submit:OK',
                    'submit:ERROR',
                    app.debug,
                    globalEvents
                )
                
            }
        }
        
    </script>
    <style>
        .topspacing{
            margin-top: 10px;
        }

    </style>
</widget_form>