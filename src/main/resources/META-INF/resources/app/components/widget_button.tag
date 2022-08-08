<widget_button>
    <div if={ type == 'button' } class="container bg-white border border-info rounded topspacing p-0">
        <div class="row px-1 py-1">
            <div if={ !app.user.guest } class="col-12 text-center">
                <button type="button" class="btn btn-danger btn-block" onclick={ fillDesc() } data-toggle="modal" data-target="#{name}">{ title }</button>
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
                    <p>{ app.texts.widget_button.line1[app.language] } {dev_id}</p>
                    <p>{dataToSend}</p>
                    <p class="text-danger">
                        { app.texts.widget_button.line2[app.language] }<br>
                        { app.texts.widget_button.line3[app.language] }
                    </p>
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
                        <div class="form-group" if="{commandType==='HEX'}">
                            <label for="hexString">HEX STRING</label>
                            <input type='text' value={dataToSend} name="newvalue" id='hexString'>
                        </div>
                        <div class="form-group" if="{commandType==='PLAIN'}">
                            <label for="plainString">PLAIN STRING</label>
                            <input type='text' value={dataToSend} name="newvalue" id='plainString'>
                        </div>
                        <div class="form-group" if="{commandType==='JSON'}">
                            <label for="jsonText">JSON</label>
                            <textarea class="form-control" id="jsonText" rows="3">{dataToSend}</textarea>
                        </div>
                        <div class="form-group" if="{commandType!=='PLAIN' && commandType!=='JSON' && commandType!=='HEX'}">
                            <p>Unsupported data type. Must be "HEX", "PLAIN" or "JSON"!</p>
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
        // object fields (title,device_id,channel ...) are set by running update() from app_dashboard2.tag
        self.dataToSend=''

        self.show2 = function(){
            //nothing to do
            try{
            self.commandType=self.commandType.toUpperCase()
            }catch(ex){
                self.commandType=''
            }
            self.dataToSend=''
        }

        self.listener = riot.observable()
        self.listener.on('*', function(eventName){
            app.log("widget_button receive event: " + eventName)
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
                if(self.commandType==='HEX'){
                    self.dataToSend = document.getElementById('hexString').value
                }else if(self.commandType==='PLAIN'){
                    self.dataToSend = document.getElementById('plainString').value
                }else if(self.commandType=='JSON'){
                    self.dataToSend= document.getElementById('jsonText').value
                }
                self.dataToSend=self.dataToSend.trim()
            }
        }

        sendCommand(){
            return function(e){
                e.preventDefault()
                var url
                if(self.commandType==='HEX'){
                    url=app.actuatorAPI + '/' + self.dev_id + "/hex"
                }else if(self.commandType==='PLAIN'){
                    url=app.actuatorAPI + '/' + self.dev_id + "/plain"
                }else if(self.commandType==='JSON'){
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
</widget_button>