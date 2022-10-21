<widget_map>
    <div id={ref} class="container bg-white border border-info rounded topspacing p-0">
        <div class="row px-3 pt-1 pb-0">
            <div class="col-12 text-center {app.wt_color||'text-white'} sgx-wt"><span class="text-body">{title.length>0?('&nbsp;'+title+'&nbsp;'):''}</span></div>
        </div>    
        <div class="row px-3 py-1">
                <div class="col-12"><div style={ heightStr } id={ ref+'_m' }>
{ app.texts.widget_map.nodata[app.language] }
        </div></div>
        </div>
    </div> 
    <script>
    var self = this
    //self.refs = this.refs
    // opts: poniższe przypisanie nie jest używane
    //       wywołujemy update() tego taga żeby zminieć parametry
    self.title = opts.title
    self.ref = opts.ref
    // opts
    
    self.value = '-'
    self.measureDate = '-'
    self.tstamp = 0;
    self.front = true

    self.rawdata = "[]"
    self.jsonData = {}

    // map
    self.prevLat = 0.0
    self.prevLon = 0.0
    self.lat = 0.0
    self.lon = 0.0
    self.mapUrl = ''
    self.mapExternalUrl = ''
    self.noData = false
    
    self.heightStr='width:100%;height:100px;'
    self.map=null;
    self.marker;
    self.polyline
    
    
    this.on('mount',function(){
        app.log('MOUNTING MAP WIDGET')
        getWidth()
    })
    
    self.show2 = function(){
        app.log('SHOW2: widget_map')
        self.jsonData = JSON.parse(self.rawdata)
        app.log(self.jsonData)
        self.verify()
        self.showMap()
    }
    
    self.verify=function(){
        try{
            if(self.jsonData==null || jsonData.length==0){
                self.noData=true
            }
        }catch(err){
            self.nodaData=true
        }
        let i=0
        while(i<self.jsonData.length){
            if(self.jsonData[i]==null || self.jsonData[i].length<2 || self.jsonData[i][0]==null || self.jsonData[i][1]==null 
                    || (self.jsonData[i][0]['value']==0.0 && self.jsonData[i][1]['value']==0.0)){
                self.jsonData.splice(i,1)
            }else{
                i=i+1
            }
        }
        self.noData=false
    }
    
    self.showMap = function(){
        if(self.jsonData.length==0 || self.jsonData[0].length<1){
            self.noData = true
            return
        }
        riot.update()
        self.noData=false
        var p1=self.jsonData[0][0]['name'].toLowerCase()
        var p2=self.jsonData[0][1]['name'].toLowerCase()
        var lonFirst=false
        console.log('P1:'+p1)
        console.log('P2:'+p2)
        if((p2=='latitude'&&p1=='longitude') || (p2=='lat'&&p1=='lon')){
            lonFirst=true
        }
        console.log('LONFIRST:'+lonFirst)
        if(lonFirst){
            self.lat=parseFloat(self.jsonData[self.jsonData.length-1][1]['value'])
            self.lon=parseFloat(self.jsonData[self.jsonData.length-1][0]['value'])
        }else{
            self.lat=parseFloat(self.jsonData[self.jsonData.length-1][0]['value'])
            self.lon=parseFloat(self.jsonData[self.jsonData.length-1][1]['value'])
        }
        self.measureDate = new Date(self.jsonData[self.jsonData.length-1][0]['timestamp']).toLocaleString(getSelectedLocale())
        if(self.lat==self.prevLat && self.lon==self.prevLon){
        //    return
        }
        self.prevLat=self.lat
        self.prevLon=self.lon
        
        // Leaflet
        
        self.zoom = 15;
        try{
            if(self.map!=null){
                self.map.remove()
            }
        }catch(err){
            console.log(err)
        }
        self.map = L.map(self.ref+'_m')
        self.map.setView([self.lat, self.lon], self.zoom)
        
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
        }).addTo(self.map);
        
        try{
            self.marker=L.marker([self.lat, self.lon])
            self.marker.setPopupContent(self.lat+','+self.lon)
            self.marker.addTo(self.map);//.bindPopup(self.lat+','+self.lon)
        }catch(err){
            console.log(err)
            //self.marker=L.marker([self.lat, self.lon])
            //self.marker.addTo(self.map).bindPopup(self.lat+','+self.lon)
        }
        
        if(self.jsonData.length>0){
            var tmpLat, tmpLon
            var latlngs =[]
            for(i=0; i<self.jsonData.length; i++){
                if(lonFirst){
                    tmpLat=parseFloat(self.jsonData[i][1]['value'])
                    tmpLon=parseFloat(self.jsonData[i][0]['value'])
                }else{
                    tmpLat=parseFloat(self.jsonData[i][0]['value'])
                    tmpLon=parseFloat(self.jsonData[i][1]['value'])
                }
                if(!(isNaN(tmpLat) || isNaN(tmpLon))){
                    latlngs.push([tmpLat,tmpLon])
                }
            }
            app.log(latlngs)
            self.polyline = L.polyline(latlngs, {
                color: '#0095FF'
            }).addTo(self.map);
            // zoom the map to the polyline
            self.map.fitBounds(self.polyline.getBounds());
        }
        //
        riot.update()
    }
    
    this.on('update', function(e){
    })
    
    self.listener = riot.observable()
    self.listener.on('*',function(eventName){
        app.log("widget_a1 listener on event: "+eventName)
    })
    
    
    //$(window).on('resize', resize)
    
    function getWidth(){
        self.width=$('#'+self.ref).width()
        self.heightStr='width:100%;height:'+self.width+'px;'
    }
    
    function resize(){
        getWidth()
        self.show2()
    }
        
    </script>
    <style>
        .topspacing{
            margin-top: 10px;
        }
       
    </style>
</widget_map>