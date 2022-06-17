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
        self.verify()
        
        try{
            if(self.map!=null){
                self.map.remove()
            }
        }catch(err){
            console.log(err)
        }
        self.map = L.map(self.ref+'_m')

        for(idx=0; idx<self.jsonData.length; idx++){
            self.showMap(idx)
        }
        try{
          self.map.fitBounds(self.allPoints);
        }catch(exc){
          self.map.setZoom(self.zoom)
        }
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
            if(self.jsonData[i]==null || self.jsonData[i].length==0 || self.jsonData[i][0]==null || self.jsonData[i][0]==null 
                    || (self.jsonData[i][0]['value']==0.0 && self.jsonData[i][1]['value']==0.0)){
                self.jsonData.splice(i,1)
            }else{
                i=i+1
            }
        }
        self.noData=false
    }
    
    self.showMap = function(devIndex){
        if(self.jsonData.length==0 || self.jsonData[devIndex].length==0){
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
            //return
        }
        self.prevLat=self.lat
        self.prevLon=self.lon
        
        // Leaflet        
        try{
            marker=L.marker([self.lat, self.lon])
            marker.setPopupContent(self.lat+','+self.lon)
            marker.addTo(self.map)
        }catch(err){
            console.log(err)
            //marker.addTo(self.map).bindPopup(self.lat+','+self.lon)
        }
        
        if(self.jsonData[idx].length>0){
            var tmpLat, tmpLon
            var latlngs =[]
            var polyline
            for(i=0; i<self.jsonData[idx].length; i++){
                try{
                  if(lonFirst){
                    tmpLat=parseFloat(self.jsonData[idx][i][1]['value'])
                    tmpLon=parseFloat(self.jsonData[idx][i][0]['value'])
                    
                  }else{
                    tmpLat=parseFloat(self.jsonData[idx][i][0]['value']),
                    tmpLon=parseFloat(self.jsonData[idx][i][1]['value'])
                  }
                  if(!(isNaN(tmpLat) || isNaN(tmpLon))){
                      //latitude and longitude value is a number
                      latlngs.push([tmpLat,tmpLon])
                    self.allPoints.push([tmpLat,tmpLon])
                  }
                }catch(err){
                    //latitude or longitude value is not a number
                }
            }
            app.log(latlngs)
            polyline = L.polyline(latlngs, {
                color: getTrackColor(idx)
            }).on('mouseover', function(e) {
                e.target.bringToFront();
                e.target.setStyle({color: 'red'}); 
            }).on('mouseout', function(e) {
                e.target.setStyle({color: polyline._color}); 
            })
            polyline._color=getTrackColor(idx)
            polyline.addTo(self.map);
            // zoom the map to the polyline
            //self.map.fitBounds(polyline.getBounds());
        }
        //
        riot.update()
    }
    
    function getTrackColor(trackId){
        switch(trackId){
            case 0:
            return '#0095FF'
            case 1:
            return '#FF00AA'
            case 2:
            return '#FFD400'
            case 3:
            return '#6AFF00'
            case 4:
            return '#0040FF'
            case 5:
            return '#FFFF00'
            case 6:
            return '#00EAFF'
            case 7:
            return '#AA00FF'
            case 8:
            return '#FF7F00'
            case 9:
            return '#BFFF00'
            case 10:
            return '#EDB9B9'
            case 11:
            return '#B9D7ED'
            case 12:
            return '#E7E9B9'
            case 13:
            return '#DCB9ED'
            case 14:
            return '#B9EDE0'
            case 15:
            return '#8F2323'
            case 16:
            return '#23628F'
            case 17:
            return '#8F6A23'
            case 18:
            return '#6B238F'
            case 19:
            return '#4F8F23'
            case 20:
            return '#000000'
            case 21:
            return '#737373'
            case 22:
            return '#CCCCCC'
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