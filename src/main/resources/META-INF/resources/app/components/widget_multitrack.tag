<widget_multitrack>
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
    self.title = opts.title
    self.ref = opts.ref
    
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
    self.zoom = 15
    self.map=null
    self.allPoints=[]

    self.heightStr='width:100%;height:100px;'
    
    this.on('mount',function(){
        app.log('MOUNTING MAP WIDGET')
        getWidth()
    })
    
    self.show2 = function(){
        app.log('SHOW2: widget_map')
        self.jsonData = JSON.parse(self.rawdata)
        app.log(self.jsonData)
        self.allPoints=[]
        //getWidth()
        self.verify()
        
        try{
            if(self.map!==null){
                self.map.remove();
            }
        }catch(err){
            console.log(err)
        }
        try{
            self.map = L.map(self.ref+'_m')
        }catch(err){
            console.log(err)
        }
        for(idx=0; idx<self.jsonData.length; idx++){
            //console.log('track '+idx)
            self.showMap(idx)
        }
        self.map.fitBounds(self.allPoints);
        //self.map.setView([self.lat, self.lon], self.zoom)
        L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
            attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
        }).addTo(self.map);

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
    
    self.showMap = function(devIndex){
        if(self.jsonData.length==0 || self.jsonData[devIndex].length<2){
            self.noData = true
            return
        }
        riot.update()
        self.noData=false
        var marker=null;
        var p1=self.jsonData[devIndex][0][0]['name'].toLowerCase()
        var p2=self.jsonData[devIndex][0][1]['name'].toLowerCase()
        var lonFirst=false
        
        if(p2=='latitude'&&p1=='longitude' || p2=='lat'&&p1=='lon'){
            lonFirst=true
        }
        if(lonFirst){
            self.lat=parseFloat(self.jsonData[idx][0][1]['value'])
            self.lon=parseFloat(self.jsonData[idx][0][0]['value'])
        }else{
            self.lat=parseFloat(self.jsonData[idx][0][0]['value'])
            self.lon=parseFloat(self.jsonData[idx][0][1]['value'])
        }
        self.measureDate = new Date(self.jsonData[idx][self.jsonData[idx].length-1][0]['timestamp']).toLocaleString(getSelectedLocale())
        if(self.lat==self.prevLat && self.lon==self.prevLon){
            return
        }
        self.prevLat=self.lat
        self.prevLon=self.lon
        
        // Leaflet        
        try{
            marker.setLatLng([self.lat, self.lon])
            marker.setPopupContent(self.lat+','+self.lon)
        }catch(err){
            marker=L.marker([self.lat, self.lon])
            marker.addTo(self.map).bindPopup(self.lat+','+self.lon)
        }
        
        if(self.jsonData[idx].length>1){
            var tmpLat, tmpLon
            var latlngs =[]
            var polyline
            for(i=0; i<self.jsonData[idx].length-1; i++){
                if(lonFirst){
                    tmpLat=parseFloat(self.jsonData[idx][i][1]['value'])
                    tmpLon=parseFloat(self.jsonData[idx][i][0]['value'])
                    
                }else{
                    tmpLat=parseFloat(self.jsonData[idx][i][0]['value']),
                    tmpLon=parseFloat(self.jsonData[idx][i][1]['value'])
                }
                latlngs.push([tmpLat,tmpLon])
                self.allPoints.push([tmpLat,tmpLon])
            }
            app.log(latlngs)
            polyline = L.polyline(latlngs, {
                color: getTrackColor(idx)
            }).addTo(self.map);
            // zoom the map to the polyline
            //self.map.fitBounds(polyline.getBounds());
        }
        //
        riot.update()
    }
    
    function getTrackColor(trackId){
        switch(trackId){
            case 0:
            return 'red'
            case 1:
            return 'lime'
            case 2:
            return 'blue'
            case 3:
            return 'yellow'
            case 4:
            return 'cyan'
            case 5:
            return 'magenta'
            case 6:
            return 'silver'
            case 7:
            return 'gray'
            case 8:
            return 'maroon'
            case 9:
            return 'olive'
            case 10:
            return 'green'
            case 11:
            return 'purple'
            case 12:
            return 'teal'
            case 13:
            return 'navy'
            case 14:
            return 'black'
            case 15:
            return 'white'
            default:
            return 'black'
        }
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
</widget_multitrack>